#!/bin/bash

set -e

if [ ! -f /etc/fdfs/client.conf ];then
  cp /fdfs_conf/client.conf /etc/fdfs/client.conf
fi
if [ ! -f /etc/fdfs/storage.conf ];then
  cp /fdfs_conf/storage.conf /etc/fdfs/storage.conf
fi
if [ ! -f /etc/fdfs/tracker.conf ];then
  cp /fdfs_conf/tracker.conf /etc/fdfs/tracker.conf
fi
if [ ! -f /etc/fdfs/http.conf ];then
  cp /fdfs_conf/http.conf /etc/fdfs/http.conf
fi
if [ ! -f /etc/fdfs/mime.types ];then
  cp /fdfs_conf/mime.types /etc/fdfs/mime.types
fi

sed -i "s/__group__/$fdfs_group/g" /etc/fdfs/client.conf
sed -i "s/__group__/$fdfs_group/g" /etc/fdfs/storage.conf
sed -i "s/__group__/$fdfs_group/g" /etc/fdfs/tracker.conf
if [ -n "$fdfs_tracker_hosts" ]; then
  _hosts_array=( $fdfs_tracker_hosts )
  _hosts_str=""
  for _s in ${_hosts_array[@]}
  do
    if [ "$_s" != "" ];then
      _conf="tracker_server = "$_s
      if [ "$_hosts_str" == "" ];then
        _hosts_str="$_conf"
      else
        _hosts_str="$_hosts_str \n$_conf"
      fi
    fi
  done
  sed -i "s/__tracker_hosts__/$_hosts_str/g" /etc/fdfs/client.conf
  sed -i "s/__tracker_hosts__/$_hosts_str/g" /etc/fdfs/storage.conf
  sed -i "s/__tracker_hosts__/$_hosts_str/g" /etc/fdfs/tracker.conf
fi
sed -i "s/__tracker_port__/$fdfs_tracker_port/g" /etc/fdfs/client.conf
sed -i "s/__tracker_port__/$fdfs_tracker_port/g" /etc/fdfs/storage.conf
sed -i "s/__tracker_port__/$fdfs_tracker_port/g" /etc/fdfs/tracker.conf
sed -i "s/__tracker_http_port__/$fdfs_tracker_http_port/g" /etc/fdfs/client.conf
sed -i "s/__tracker_http_port__/$fdfs_tracker_http_port/g" /etc/fdfs/storage.conf
sed -i "s/__tracker_http_port__/$fdfs_tracker_http_port/g" /etc/fdfs/tracker.conf
sed -i "s/__storage_port__/$fdfs_storage_port/g" /etc/fdfs/client.conf
sed -i "s/__storage_port__/$fdfs_storage_port/g" /etc/fdfs/storage.conf
sed -i "s/__storage_port__/$fdfs_storage_port/g" /etc/fdfs/tracker.conf
sed -i "s/__storage_http_port__/$fdfs_storage_http_port/g" /etc/fdfs/client.conf
sed -i "s/__storage_http_port__/$fdfs_storage_http_port/g" /etc/fdfs/storage.conf
sed -i "s/__storage_http_port__/$fdfs_storage_http_port/g" /etc/fdfs/tracker.conf

mkdir -p /data/{client,storage,tracker}

for _file in $( ls /docker-entrypoint.d ); do
  if [[ "$_file" == *".sh"  ]]; then
    chmod +x /docker-entrypoint.d/$_file
    bash /docker-entrypoint.d/$_file
  fi
done

if [ "$fdfs_app" == "full" ]; then
  echo "start trackerd"
  fdfs_trackerd /etc/fdfs/tracker.conf start

  echo "start storage"
  fdfs_storaged /etc/fdfs/storage.conf start
fi

if [ "$fdfs_app" == "tracker" ]; then
  echo "start trackerd"
  fdfs_trackerd /etc/fdfs/tracker.conf start
fi

if [ "$fdfs_app" == "storage" ]; then
  echo "start storage"
  fdfs_storaged /etc/fdfs/storage.conf start
fi

tail -f  /dev/null
