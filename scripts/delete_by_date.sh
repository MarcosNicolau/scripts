show_help(){
    echo "Usage: delete_by_date <PATH> <DATE_TO_COMPARE_IN_EPOCH>\n"
    echo "EXAMPLE:"
    echo "Delete all the folders that are a week old:"
    echo "delete_by_date /home/user/Documents/saves \`date --date "a week ago"\` + '%s'"
    
    echo "\nThe files/folders names must be in GNU date, see more here https://www.gnu.org/software/coreutils/manual/html_node/date-invocation.html"
}


if [ $1 = "--help" ] || [ $1 = "-h" ]; then 
    show_help
    exit 0
fi

if [ -z $1 ] || [ -z $2 ]; then
    echo "You must provide the necessary arguments, enter --help or -h to see usage"
    exit 1
fi 


for dir in $1/*; do
    DIR_DATE=`date --date "$(basename $dir)" +'%s'`
    if [ -z $DIR_DATE ]; then continue 
    fi
    if [ $DIR_DATE -lt $2 ]; then 
        sudo rm -rf /home/marcos/Documents/gaming/save_backups/switch/$(basename $dir)
    fi
done