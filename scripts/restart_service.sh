show_help() {
    echo "This script will restart a systemd service, it has autocompletion (press <TAB>) so you don't have to remember the services names! \n"
    echo "Usage: restar_service <YOUR_SERVICE_NAME>.service"
}

if [ $1 = "--help" ] || [ $1 = "-h" ]; then 
    show_help
    exit 0
fi


sudo systemctl daemon-reload
sudo systemctl restart $1