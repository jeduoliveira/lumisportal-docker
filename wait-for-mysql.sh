#!/bin/sh
echodate()
{
    >&2  echo `date +%y-%m-%d" "%H:%M:%S` - $*
}

maxcounter=60 
counter=1

echodate "$counter - Waiting for MySQL to listen to port $LUMIS_DB_PORT ..."

while ! mysql -h $LUMIS_DB_HOST -P $LUMIS_DB_PORT  -u"$LUMIS_DB_USER" -p"$LUMIS_DB_PASSWORD" $LUMIS_DB_NAME -e "show tables;" > /dev/null 2>&1; do
    sleep 5
    counter=`expr $counter + 1`
    echodate "$counter - Waiting for MySQL to listen to port $LUMIS_DB_PORT ..."
    if [ $counter -gt $maxcounter ]; then
        >&2 echodate "We have been waiting for MySQL too long already; failing."
        exit 1
    fi;
done

echodate "MySQL available $LUMIS_DB_HOST:$LUMIS_DB_PORT"

