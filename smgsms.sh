#!/bin/sh

script=./$HOME/$GOROOT/bin/smgsms
runas=$USER

pidfile=/var/run/smgsms.pid
logfile=$HOME/log/smgsms.log

start() {
  if [ -f /var/run/$PIDNAME ] && kill -0 $(cat /var/run/$PIDNAME); then
    echo 'service already running' >&2
    return 1
  fi
  echo 'starting service…' >&2
  local cmd="$script &> \"$logfile\" & echo \$!"
  su -c "$cmd" $runas > "$pidfile"
  echo 'service started' >&2
}

stop() {
  if [ ! -f "$pidfile" ] || ! kill -0 $(cat "$pidfile"); then
    echo 'service not running' >&2
    return 1
  fi
  echo 'stopping service…' >&2
  kill -15 $(cat "$pidfile") && rm -f "$pidfile"
  echo 'service stopped' >&2
}

uninstall() {
  echo -n "are you really sure you want to uninstall this service? That cannot be undone. [yes|No] "
  local sure
  read sure
  if [ "$sure" = "yes" ]; then
    stop
    rm -f "$pidfile"
    echo "notice: log file is not be removed: '$logfile'" >&2
    update-rc.d -f smgsms remove
    rm -fv "$0"
  fi
}

case "$1" in
  start)
    start
    ;;
  stop)
    stop
    ;;
  uninstall)
    uninstall
    ;;
  restart)
    stop
    start
    ;;
  *)
    echo "usage: $0 {start|stop|restart|uninstall}"
esac
