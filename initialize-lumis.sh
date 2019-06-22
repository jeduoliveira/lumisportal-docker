#!/bin/sh
echodate()
{
    >&2  echo `date +%y-%m-%d" "%H:%M:%S` - $*
}

config_update()
{
    echodate "Updating defaults configurations..."   
    mysql -h $LUMIS_DB_HOST -P $LUMIS_DB_PORT -u $LUMIS_DB_USER -p$LUMIS_DB_PASSWORD $LUMIS_DB_NAME < /config.sql
}

initialize(){
    echodate "Initializing lumisportal tables..."
     cd $LUMIS_HOME/setup
    ./initializeportal.sh 
    echodate "Finish initialize lumisportal tables..."
}

echodate "Checking if lumisportal tables exist..."
ret=$(mysql --skip-column-names \
        -h $LUMIS_DB_HOST \
        -P $LUMIS_DB_PORT \
        -u$LUMIS_DB_USER  \
        -p$LUMIS_DB_PASSWORD $LUMIS_DB_NAME \
        -e 'select count(*) from lum_User;') 

if [[ "$ret" = "" ]];  
then
    echodate "Creating tables lumisportal..."
    mysql -h $LUMIS_DB_HOST -P $LUMIS_DB_PORT -u $LUMIS_DB_USER -p$LUMIS_DB_PASSWORD $LUMIS_DB_NAME < $LUMIS_HOME/setup/db_mysql.sql
    echodate "Tables created..."

    initialize
    config_update
else
    config_update
    echodate "Database already initialized..."
fi

cd $CATALINA_HOME