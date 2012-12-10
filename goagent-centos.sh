#! /bin/sh
#
# chkconfig: - 84 16
# description:  goagent proxy
# processname: goagent
# author: yaohuaq@gmail.com

###########################
# End of configuration
###########################

# Source function library.
. /etc/rc.d/init.d/functions

BASE_DIR=/usr/local/goagent

PY_BIN=`which python`
if [ ! -e $PY_BIN ];then
    PY_BIN=/usr/local/bin/python
fi
RETVAL=0
prog="goagent"
pidfile=/var/run/goagent.pid
logfile=/var/log/goagent.log

start () {
    nohup $PY_BIN $BASE_DIR/local/proxy.py >> $logfile 2>&1 &
    RETVAL=$?
    if [ $RETVAL -eq 0 ];then
        pid=`ps ax|grep $prog |head -n1|awk '{print $1}'`
        echo $pid > $pidfile
        action $"Starting $prog: " /bin/true
    fi
}

stop () {
    if [ ! -e $pidfile ];then
        echo "$pidfile not found."
        exit 1
    fi
    pid=`cat $pidfile`
    kill $pid
    rm $pidfile
    RETVAL=$?
    if [ $RETVAL -eq 0 ];then
        action $"Stoping $prog: " /bin/true
    else
        action $"Stoping $prog: " /bin/false
    fi
}

restart () {
    stop
    start
}

status () {
    if [ ! -e $pidfile ];then
        echo "$prog is running"
    else
        echo "$prog is stopped"
    fi
    exit 1
}

# See how we were called.
case "$1" in
  start)
    start
    ;;  
  stop)
    stop
    ;;  
  status)
    status
    ;;  
  restart)
    restart
    ;;  
  *)  
    echo $"Usage: $0 {start|stop|status|restart}"
    RETVAL=2
        ;;  
esac

exit $RETVAL
