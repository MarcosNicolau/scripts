show_help() {
    echo "This script will create a basic systemd service and timer files for you\n"
    echo "Go see docs if you want to know more: 
    - service file: https://www.freedesktop.org/software/systemd/man/systemd.service.html
    - Timer file: https://www.freedesktop.org/software/systemd/man/systemd.timer.html"
}

if [ ! -z $1 ] && ([ $1 = "--help" ] || [ $1 = "-h" ]); then 
    show_help
    exit 0
fi

echo -n "service name: (`basename $PWD`) "
read UNIT
echo -n "description: (A small and concise description) "
read DESCRIPTION
echo -n "User: ($USER): "
read SERVICE_USER
echo -n "Type (simple): "
read TYPE
echo -n "Restart (on-failure): "
read RESTART
echo -n "calendar, when to run?: "
read ON_CALENDAR
if [ -z $ON_CALENDAR ]; then
    echo "calendar is mandatory"
    exit 1
fi
echo -n "Persistent (y/n): "
read PERSISTENT
echo -n "Script to run (can be a file path or a just bash code): "
read SCRIPT
if [ -z $SCRIPT ]; then
    echo "scripts is mandatory"
    exit 
fi


#Default variables

if [ -z $UNIT ]; then UNIT=`basename $PWD`
fi

if [ -z $SERVICE_USER ]; then SERVICE_USER=$USER
fi

if [ -z $TYPE ]; then TYPE="simple"
fi

if [ -z $RESTART ]; then RESTART="on-failure"
fi

if [ $PERSISTENT = "Y"  ] || [ $PERSISTENT = "y" ]; then PERSISTENT="true"
else PERSISTENT="false"
fi

# Now we create the files

#Service file
echo "[Unit]
Description=$DESCRIPTION

[Service]
Type=simple
ExecStart=$SCRIPT
User=$SERVICE_USER

[Install]
WantedBy=multi-user.target" | sudo tee /etc/systemd/system/$UNIT.service

#Timer file
echo "[Unit]
Description=Runs $UNIT

[Timer]
OnCalendar=$ON_CALENDAR
Persistent=$PERSISTENT
Unit=$UNIT.service

[Install]
WantedBy=timers.target" | sudo tee /etc/systemd/system/$UNIT.timer

# Verify that the files created are correct
systemd-analyze verify /etc/systemd/system/$UNIT.*

# Start timer
sudo systemctl daemon-reload
sudo systemctl start $UNIT.timer
sudo systemctl enable  $UNIT.timer
# Restar service, in case it has already been created
sudo systemctl restart $UNIT.service