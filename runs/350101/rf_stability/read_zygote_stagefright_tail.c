#define _FILE_OFFSET_BITS 64

#include <dirent.h>
#include <errno.h>
#include <fcntl.h>
#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

static int read_all(int fd, unsigned char *buf, size_t len) {
  size_t off = 0;
  while (off < len) {
    ssize_t n = read(fd, buf + off, len - off);
    if (n < 0) {
      if (errno == EINTR) continue;
      return -1;
    }
    if (n == 0) break;
    off += (size_t)n;
  }
  return (int)off;
}

static int write_all_file(const char *path, const unsigned char *buf, size_t len) {
  int fd = open(path, O_CREAT | O_TRUNC | O_WRONLY, 0600);
  if (fd < 0) return -1;
  size_t off = 0;
  while (off < len) {
    ssize_t n = write(fd, buf + off, len - off);
    if (n < 0) {
      if (errno == EINTR) continue;
      close(fd);
      return -1;
    }
    off += (size_t)n;
  }
  close(fd);
  return 0;
}

static int find_zygote64_pid(void) {
  DIR *dir = opendir("/proc");
  if (!dir) return -1;
  struct dirent *de;
  while ((de = readdir(dir)) != NULL) {
    char *end = NULL;
    long pid = strtol(de->d_name, &end, 10);
    if (!end || *end != '\0' || pid <= 0) continue;
    char path[128];
    snprintf(path, sizeof(path), "/proc/%ld/cmdline", pid);
    int fd = open(path, O_RDONLY);
    if (fd < 0) continue;
    char cmd[64] = {0};
    ssize_t n = read(fd, cmd, sizeof(cmd) - 1);
    close(fd);
    if (n > 0 && strcmp(cmd, "zygote64") == 0) {
      closedir(dir);
      return (int)pid;
    }
  }
  closedir(dir);
  return -1;
}

static int find_stagefright_map(int pid, unsigned long long *start,
                                unsigned long long *end,
                                unsigned long long *map_off,
                                char *path_out, size_t path_out_len,
                                char *line_out, size_t line_out_len) {
  char maps_path[128];
  snprintf(maps_path, sizeof(maps_path), "/proc/%d/maps", pid);
  FILE *fp = fopen(maps_path, "r");
  if (!fp) return -1;
  char line[1024];
  while (fgets(line, sizeof(line), fp)) {
    if (!strstr(line, "/system/lib64/libstagefright.so") || !strstr(line, "r-xp")) {
      continue;
    }
    char perms[8] = {0};
    char dev[32] = {0};
    unsigned long inode = 0;
    char pathname[512] = {0};
    int matched = sscanf(line, "%llx-%llx %7s %llx %31s %lu %511s",
                         start, end, perms, map_off, dev, &inode, pathname);
    if (matched >= 7) {
      snprintf(path_out, path_out_len, "%s", pathname);
      snprintf(line_out, line_out_len, "%s", line);
      size_t n = strlen(line_out);
      if (n > 0 && line_out[n - 1] == '\n') line_out[n - 1] = 0;
      fclose(fp);
      return 0;
    }
  }
  fclose(fp);
  return -1;
}

static unsigned long long fnv1a64(const unsigned char *buf, size_t len) {
  unsigned long long h = 1469598103934665603ULL;
  for (size_t i = 0; i < len; i++) {
    h ^= (unsigned long long)buf[i];
    h *= 1099511628211ULL;
  }
  return h;
}

int main(int argc, char **argv) {
  size_t len = 4048;
  const char *out_dir = NULL;
  if (argc >= 2) len = (size_t)strtoull(argv[1], NULL, 0);
  if (argc >= 3) out_dir = argv[2];
  if (len == 0 || len > 4096) {
    fprintf(stderr, "bad len\n");
    return 2;
  }

  int pid = find_zygote64_pid();
  if (pid <= 0) {
    printf("error=no_zygote64\n");
    return 2;
  }

  unsigned long long start = 0, end = 0, map_off = 0;
  char path[512] = {0};
  char map_line[1024] = {0};
  if (find_stagefright_map(pid, &start, &end, &map_off, path, sizeof(path),
                           map_line, sizeof(map_line)) != 0) {
    printf("error=no_stagefright_rx_map\npid=%d\n", pid);
    return 2;
  }

  unsigned long long base = end - 0x1000ULL;
  unsigned long long file_off = map_off + (base - start);

  unsigned char *mem = calloc(1, len);
  unsigned char *file = calloc(1, len);
  if (!mem || !file) {
    fprintf(stderr, "oom\n");
    return 2;
  }

  char mem_path[128];
  snprintf(mem_path, sizeof(mem_path), "/proc/%d/mem", pid);
  int mem_fd = open(mem_path, O_RDONLY | O_CLOEXEC);
  if (mem_fd < 0) {
    printf("error=open_proc_mem_failed errno=%d\npid=%d\n", errno, pid);
    return 3;
  }
  if (lseek(mem_fd, (off_t)base, SEEK_SET) < 0) {
    printf("error=lseek_proc_mem_failed errno=%d\npid=%d base=0x%llx\n", errno, pid, base);
    close(mem_fd);
    return 3;
  }
  int mem_n = read_all(mem_fd, mem, len);
  close(mem_fd);
  if (mem_n < 0 || (size_t)mem_n != len) {
    printf("error=read_proc_mem_failed errno=%d read=%d\npid=%d\n", errno, mem_n, pid);
    return 3;
  }

  int file_fd = open(path, O_RDONLY | O_CLOEXEC);
  if (file_fd < 0) {
    printf("error=open_backing_failed errno=%d path=%s\npid=%d\n", errno, path, pid);
    return 3;
  }
  if (lseek(file_fd, (off_t)file_off, SEEK_SET) < 0) {
    printf("error=lseek_backing_failed errno=%d path=%s off=0x%llx\npid=%d\n",
           errno, path, file_off, pid);
    close(file_fd);
    return 3;
  }
  int file_n = read_all(file_fd, file, len);
  close(file_fd);
  if (file_n < 0) {
    printf("error=read_backing_failed errno=%d read=%d path=%s\npid=%d\n", errno, file_n, path, pid);
    return 3;
  }

  int dirty = memcmp(mem, file, len) != 0;
  printf("pid=%d\n", pid);
  printf("map=%s\n", map_line);
  printf("base=0x%llx\n", base);
  printf("fileoff=0x%llx\n", file_off);
  printf("len=%zu\n", len);
  printf("mem_fnv=%016llx\n", fnv1a64(mem, len));
  printf("file_fnv=%016llx\n", fnv1a64(file, len));
  printf("dirty=%d\n", dirty ? 1 : 0);
  printf("mem_head=");
  for (size_t i = 0; i < 32 && i < len; i++) printf("%02x", mem[i]);
  printf("\nfile_head=");
  for (size_t i = 0; i < 32 && i < len; i++) printf("%02x", file[i]);
  printf("\n");

  if (out_dir && out_dir[0]) {
    mkdir(out_dir, 0700);
    char out_mem[768], out_file[768];
    snprintf(out_mem, sizeof(out_mem), "%s/mem.bin", out_dir);
    snprintf(out_file, sizeof(out_file), "%s/file.bin", out_dir);
    write_all_file(out_mem, mem, len);
    write_all_file(out_file, file, len);
  }

  return dirty ? 1 : 0;
}
