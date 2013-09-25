#!/bin/sh

### BEGIN INIT INFO
# Provides:          jiraticketservice
# Required-Start:    
# Required-Stop:     
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: jiraticketservice
# Description:       jiraticketservice
### END INIT INFO

# System binaries
SU=/bin/su
TOUCH=/bin/touch
JAVA=/usr/bin/java
PKILL=/usr/bin/pkill
DAEMON=/usr/bin/daemon

NAME=$( basename -- $0 )
DESC=jiraticketservice

VERSION=1.3.2

CMD_PATH=/usr/share/jiraticketservice
CMD_JAVA_CLASS=com.melexis.jiraservice.JiraTicketStandAlone

USER=jiraticketservice

LOCK_FILE=/var/run/${NAME}.lock

# Read configuration variable file if it is present
[ -r /etc/default/$NAME ] && . /etc/default/$NAME

do_start()
{
    echo "Starting ${NAME}: ${DESC}"
    
    if [ -f "${LOCK_FILE}" ];
    then
	echo "Lock file exists - ${DESC} is running already?"
	exit 1
    else
	${SU} ${USER} --shell=/bin/bash -c "$DAEMON --name $NAME -- $JAVA -cp $CMD_PATH/$NAME-$VERSION.jar $CMD_JAVA_CLASS"
	${TOUCH} ${LOCK_FILE}
    fi
}

do_stop()
{
    echo "Stopping ${NAME}: ${DESC}"
    $PKILL -U $USER
    rm -f ${LOCK_FILE}
}

do_restart()
{
    do_stop
    do_start
}

case "$1" in

	start)
		do_start
		;;
	stop)
		do_stop
		;;
	restart)
		do_restart
		;;
	*)
		echo "Usage: ${NAME} {start|stop|restart}"
		exit 1
		;;

esac

exit 0

