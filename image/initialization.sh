#!/bin/sh

# Defaults
if [ -z "$SQUID_CACHE_SIZE" ]; then
    export SQUID_CACHE_SIZE=70000
fi

if [ -z "$SQUID_CACHE_MEM" ]; then
    export SQUID_CACHE_MEM=2048
fi

if [ -z "$SQUID_LOG_DIR" ]; then
    export SQUID_LOG_DIR=/var/log/squid
fi

if [ -z "$SQUID_CACHE_DIR" ]; then
    export SQUID_CACHE_DIR=/var/cache/squid
fi

# Update configuration as necessary
sed -i -- "s@SQUID_CACHE_SIZE@$SQUID_CACHE_SIZE@g" /etc/squid/squid.conf
sed -i -- "s@SQUID_CACHE_MEM@$SQUID_CACHE_MEM@g" /etc/squid/squid.conf
sed -i -- "s@SQUID_LOG_DIR@$SQUID_LOG_DIR@g" /etc/squid/squid.conf
sed -i -- "s@SQUID_CACHE_DIR@$SQUID_CACHE_DIR@g" /etc/squid/squid.conf

# Log dir
mkdir -p $SQUID_LOG_DIR
chown -R squid:squid $SQUID_LOG_DIR

# Cache dir
mkdir -p $SQUID_CACHE_DIR
chown -R squid:squid $SQUID_CACHE_DIR

# Prepare the cache
/usr/sbin/squid -z

# Wait a moment
sleep 2
