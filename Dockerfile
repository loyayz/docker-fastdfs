FROM debian:bullseye

LABEL maintainer="loyayz - https://loyayz.com"

ENV LIBFASTCOMMON_URL https://github.com/happyfish100/libfastcommon/archive/refs/heads/master.tar.gz
ENV LIBSERVERFRAME_URL https://github.com/happyfish100/libserverframe/archive/refs/heads/master.tar.gz
ENV FASTDFS_URL https://github.com/happyfish100/fastdfs/archive/refs/heads/master.tar.gz
ENV fdfs_app full
ENV fdfs_group group0
ENV fdfs_tracker_hosts ""
ENV fdfs_tracker_port 22122
ENV fdfs_tracker_http_port 8889
ENV fdfs_storage_port 23000
ENV fdfs_storage_http_port 8888
ADD src/docker-entrypoint.sh /
ADD src/fdfs_conf/* /fdfs_conf/

RUN apt-get update \
      && apt-get install -y --no-install-recommends  \
           ca-certificates \
           wget \
           gcc \
           g++ \
           make  \
           automake \
           autoconf \
           libtool \
           pcre2-utils \
           libpcre2-dev \
           zlib1g \
           zlib1g-dev \
           openssl \
           libssh-dev \
      && chmod +x /docker-entrypoint.sh  \
      && mkdir -p /docker-entrypoint.d  \
      && SRC_DIR=/app \
      && mkdir -p $SRC_DIR && cd $SRC_DIR \
      && wget -q -O - $LIBFASTCOMMON_URL | tar xzf - \
      && wget -q -O - $LIBSERVERFRAME_URL | tar xzf - \
      && wget -q -O - $FASTDFS_URL | tar xzf -  \
      && mv $SRC_DIR/libfastcommon-master $SRC_DIR/libfastcommon \
      && mv $SRC_DIR/libserverframe-master $SRC_DIR/libserverframe \
      && mv $SRC_DIR/fastdfs-master $SRC_DIR/fastdfs \
      && cd $SRC_DIR/libfastcommon && ./make.sh && ./make.sh install \
      && cd $SRC_DIR/libserverframe && ./make.sh && ./make.sh install \
      && cd $SRC_DIR/fastdfs && ./make.sh && ./make.sh install \
      && rm -f /etc/fdfs/client.conf /etc/fdfs/storage.conf /etc/fdfs/tracker.conf \
      && cd /

VOLUME /app/fastdfs
VOLUME /data
ENTRYPOINT ["/docker-entrypoint.sh"]
