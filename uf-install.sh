# Written by Mikhail P. Ortiz-Lunyov
#
# Updated April 12th 2025
# This script is licensed under the GNU Public License Version 3 (GPLv3).
# More information about license in readme and bottom.


# Critical variables
INSTALLATION_FOLDER_GENERAL="/opt/update_full/"
INSTALLATION_FOLDER_UNIX="/opt/update_full/uf-unix/"

# Prints noroot message
NoRootMessage() {
  # Alerts user to lack of root execution
  printf "\e[1mMISSING ROOT!\e[0m\n"
  # Gives user advices for intended use
  echo "Update_Full is intended to be used by sysadmins and others authorized to update Linux and UNIX-based systems."
  echo "As such, it is best for the script to have limited writing and executing permissions."
  echo "This first setup script changes the script's permission."
  echo ""
  echo "As such, this script needs to be executed as root to improve the update_full's permissions."
  exit 1
}

# Checks for root user
RootCheck() {
  # Check whoami command
  case "$(whoami)" in
    "root") ;;
    *) NoRootMessage ;;
  esac
  # Check UID
  case "$UID" in
    "0") ;;
    *) NoRootMessage ;;
  esac
  # Check groups command
  case "$(groups)" in
    "sudo"|"wheel"|"root") ;;
    *) NoRootMessage ;;
  esac
}

# Create a new install in /opt
## If needed, create new folder/subfolder
CreateInstall() {
  # Check what type of operation
  case "$1" in
    "fresh") mkdir $INSTALLATION_FOLDER_GENERAL ; mkdir $INSTALLATION_FOLDER_UNIX ;;
    "subfolder") mkdir $INSTALLATION_FOLDER_UNIX ;;
    "update") rm $INSTALLATION_FOLDER_UNIX/* ;;
    *) echo "@@ INTERNAL ERROR, check CreateInstall arg [$1] @@" ;;
  esac
  # Copy local files, including script
  cp "./update_full-unix.sh" "$INSTALLATION_FOLDER_UNIX"
  cp "./README.md" "$INSTALLATION_FOLDER_UNIX"
  cp "./CHANGELOG.txt" "$INSTALLATION_FOLDER_UNIX"
  cp "./SECURITY.md" "$INSTALLATION_FOLDER_UNIX"
  cp -v -s "$INSTALLATION_FOLDER_UNIX/update_full-unix.sh" "/bin/update_full-unix" > /dev/null 2>&1
  
  # Set executable permission for symbolic link
  chmod +x /bin/update_full-unix
}


# Main
## Check for root
RootCheck # Anything after this point is confirmed as root
## Check for pre-existing installation
### Check folder
if [ -d "$INSTALLATION_FOLDER_GENERAL" ] ; then
  # Check subfolder
  if [ -d "$INSTALLATION_FOLDER_UNIX" ] ; then
    echo "* All previous folders [ $INSTALLATION_FOLDER_UNIX ] exist, updating files"
    CreateInstall "update"
  else
    echo "* General folder [ $INSTALLATION_FOLDER_GENERAL ] EXISTS, creating fresh uf-UNIX install"
    CreateInstall "subfolder"
  fi
else
  echo "* FRESH install of Update_Full-UNIX incoming!"
  CreateInstall "fresh"
fi

# Update_full-unix.sh  Copyright (C) 2025  Mikhail P. Ortiz-Lunyov (mportizlunyov)
#   This program comes with ABSOLUTELY NO WARRANTY; for details add argument `-w' or `--warranty'.
#   This is free software, and you are welcome to redistribute it
#   under certain conditions; add argument `-c' or `--conditions' for details.
