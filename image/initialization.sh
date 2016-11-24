#!/bin/sh

# Defaults
if [ -z "$SQUID_CACHE_SIZE" ]; then
    export SQUID_CACHE_SIZE=70000
fi

if [ -z "$SQUID_CACHE_MEM" ]; then
    export SQUID_CACHE_MEM=2048
fi

# Update configuration as necessary
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

# Wait a moment
sleep 2
