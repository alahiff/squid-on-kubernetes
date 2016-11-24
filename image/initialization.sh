#!/bin/sh

sed -i -- "s@SQUID_CACHE_SIZE@$SQUID_CACHE_SIZE@g" /etc/squid/squid.conf
sed -i -- "s@SQUID_CACHE_MEM@$SQUID_CACHE_MEM@g" /etc/squid/squid.conf

# Log dir
mkdir -p /var/log/squid
chown -R squid:squid /var/log/squid

# Cache dir
mkdir -p /var/cache/squid
chown -R squid:squid /var/cache/squid

# Prepare the cache
/usr/sbin/squid -z

# Give the squid cache some time to rebuild
sleep 5
