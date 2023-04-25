# docker-fastdfs
docker image for https://github.com/happyfish100/fastdfs

```yaml
version: '3'

services:
  fastdfs:
    image: loyayz/fastdfs:latest
    container_name: fastdfs
    restart: always
    environment:
      TZ: Asia/Shanghai
      # 非必填，默认值 full
      # tracker: 表示执行 fdfs_trackerd /etc/fdfs/tracker.conf start
      # storage: 表示执行 fdfs_storaged /etc/fdfs/storage.conf start
      # full: 表示执行 tracker 和 storage
      fdfs_app: full
      # 非必填，默认值 group0 值为 storage.conf、tracker.conf 中的 group 配置
      fdfs_group: group0
      # 必填，表示 tracker 的 链接，如下示例
      fdfs_tracker_hosts: "192.168.1.1:22122 192.168.1.2:22122 192.168.1.3:22122"
      # 四个端口非必填，以下值即为默认值
      fdfs_tracker_port: 22122
      fdfs_tracker_http_port: 8889
      fdfs_storage_port: 23000
      fdfs_storage_http_port: 8888
    volumes:
      - ./data:/data
    # 建议网络模式为 host 不用再映射端口，当然也可以不用
    network_mode: host
```
