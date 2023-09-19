#!/bin/bash
ENTRIES_DIR=/home/$USER/.local/share/applications

show_help() {
    echo "This script will create a desktop entry and desktop actions for you! It has autocompletion (press <TAB>) so you don't have to remember the desktop file names"
    echo "All desktop files are created in $ENTRIES_DIR and so the actions"
    echo ""
    echo "Usage: shortcut [COMMAND]"
    echo ""
    echo "COMMANDS"
    echo  " create                   Prompts you and creates a desktop entry with the provided data"
    echo  " action <DESKTOP_FILE>    Prompts you and creates a desktop action to the provided desktop entry"
}

if [ -z $1 ] || [ $1 = "--help" ] || [ $1 = "-h" ]; then 
    show_help
    exit 0
fi

yesOrNoPrompt() {
  ANSWER=0
  PS3=""
  select yn in "Yes" "No"; do
      case $yn in
          Yes) 
            ANSWER=1 
            break
          ;;
          No) 
            break
          ;;
          *) 
            echo "Please answer yes or no."
          ;;
      esac
  done
  return $ANSWER
}


# Shortcut creation
if [ $1 = "create" ]; then
  read -p  "Name of the shortcut: " NAME

  PS3="Select the type of shortcut to create: "
  TYPE=""
  select opt in application link; do
    case $opt in
      application)
          TYPE=Application
          break
        ;;
      link)
          TYPE=Link
          break
        ;;
      *) 
        echo "Invalid option $REPLY"
        ;;
    esac
  done

  read  -p "Comment (a small description of the shortcut): " COMMENT

  ICONS_DIR=/home/$USER/.local/share/icons
  read -e -p "Icon (will be copied to $ICONS_DIR):" ICON


  echo "Does it need to be run on the terminal?"
  TERMINAL="false"
  if [ `yesOrNoPrompt` ]; then 
    TERMINAL="true"
  fi

  read -p "Categories (semicolon separated. Ex: Education;Languages;Java;):" CATEGORIES

  read -p  "Command to execute:" EXEC

  ENTRY_PATH=$ENTRIES_DIR/$NAME.desktop
  ICON_PATH=$ICONS_DIR/`basename $ICON`
  eval ICON=$ICON
  ICON_FULL_PATH=`readlink -f $ICON`
  cp $ICON_FULL_PATH $ICON_PATH

  # Check if there is already is another file by that name
  if [ -f $ENTRY_PATH ]; then
     echo "There is another desktop entry already created by that name, do you wish to replace it?"
     if [ ! `yesOrNoPrompt` ]; then 
      exit 0
     fi
  fi 

  echo "
[Desktop Entry]
Name=$NAME
Comment=$COMMENT
Exec=$EXEC
Icon=$ICON_PATH
Terminal=$TERMINAL
Type=$TYPE
Categories=$CATEGORIES
Actions=""
  " > $ENTRY_PATH

  echo "Desktop entry created at: $ENTRY_PATH"
  exit 0
fi


# Shortcut action creation
if [ $1 = "action" ]; then
  if [ -z $2 ]; then
    echo "Must provide a desktop file to create the action, pass --help to see usage"
    exit 1
  fi
  # check that the file exists
  if [ ! -f $ENTRIES_DIR/$2 ];  then
    echo "Desktop entry does not exist, pass --help to see usage"
    exit 1;
  fi

  read -p  "Name of the action: " NAME
  read -p  "Command to execute:"  EXEC
  ENTRY_PATH=$ENTRIES_DIR/`basename $2`
  echo "
  
[Desktop Action $NAME]
Name=$NAME
Exec=$EXEC
  " >> $ENTRY_PATH
  
  sed -i "/^Actions/ s/$/$NAME;/" $ENTRY_PATH

  echo "Action created at: $ENTRY_PATH"
  exit 0
fi

# If it reached here, command is wrong
echo "Command not understood, pass --help to see usage"