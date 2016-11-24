#!/bin/sh

CONF_DIR=/etc/squid
CONF_FILE=$CONF_DIR/squid.conf
SQUID=/usr/sbin/squid

if [ `id -u` = 0 ]; then
  echo "ERROR: `basename $0` not allowed to be run as root" >&2
  exit 1
fi

# size in bytes at which rotateiflarge will rotate access.log
LARGE_ACCESS_LOG=${LARGE_ACCESS_LOG:-1000000000}

# assume there are no spaces in these file paths
ACCESS_LOG=`awk '$1 == "access_log" {x=$2} END{print x}' $CONF_FILE`
CACHE_LOG=`awk '$1 == "cache_log" {x=$2} END{print x}' $CONF_FILE`

if [ -z "$CACHE_LOG" ]; then
 echo "ERROR: cache_log not found in $CONF_FILE" >&2
 exit 1
fi

CACHE_LOG_DIR=`dirname "$CACHE_LOG"`
if [ ! -d "$CACHE_LOG_DIR" ] || [ ! -w "$CACHE_LOG_DIR" ]; then
 echo "ERROR: cache_log directory $CACHE_LOG_DIR does not exist or is not writable" >&2
 exit 1
fi

if [ -z "$ACCESS_LOG" ]; then
 echo "ERROR: access_log not found in $CONF_FILE" >&2
 exit 1
fi

if [ "$ACCESS_LOG" != "none" ]; then
 ACCESS_LOG_DIR=`dirname "$ACCESS_LOG"`
 if [ "$ACCESS_LOG_DIR" != "$CACHE_LOG_DIR" ]; then
  echo "ERROR: access_log directory $ACCESS_LOG_DIR is not the same as the cache_log directory $CACHE_LOG_DIR" >&2
  exit 1
 fi
fi

LOGFILE_ROTATE=`awk '$1 == "logfile_rotate" {x=$2} END{print x}' $CONF_FILE`
if [ -z "$LOGFILE_ROTATE" ]; then
 LOGFILE_ROTATE=10
fi

# rotate

rotate()
{
 if [ "$ACCESS_LOG" = none ]; then
  echo "No access log to rotate"
  return
 fi
 echo "Rotating Squid Logs... "
 typeset ROTATESUFFIX
 let ROTATESUFFIX="$LOGFILE_ROTATE - 1"
# delete the log files that will be kicked out first, because
#  otherwise squid stops serving traffic while it removes them
 rm -f $ACCESS_LOG_DIR/access.log.$ROTATESUFFIX $ACCESS_LOG_DIR/cache.log.$ROTATESUFFIX
 $SQUID -k rotate
 RETVAL=$?
 if [ $RETVAL != 0 ]; then
  echo "failed"
 else
  echo "done"
 fi
 return
}

# rotate if large
rotateiflarge()
{
 LFILE=$ACCESS_LOG_DIR/`basename $ACCESS_LOG`
 if [ -f "$LFILE" ] && [ "$(stat -c %s $LFILE)" -gt "$LARGE_ACCESS_LOG" ]; then
    rotate
    return
 fi
}

case "$1" in
  rotate)
        rotate
        exit $?
        ;;
  rotateiflarge)
        rotateiflarge
        exit $?
        ;;
  *)
        echo $"Usage: $0 {rotate|rotateiflarge}"
        exit 1
esac
