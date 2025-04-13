# Written by Mikhail P. Ortiz-Lunyov
#
# Updated April 12th 2025
# This script is licensed under the GNU Public License Version 3 (GPLv3).
# More information about license in readme and bottom.


MissingRootMessage() {
  # Alerts user to lack of root execution
  printf "\e[1mMISSING ROOT!\e[0m\n"
  # Gives user advices for intended use
  echo "Update_Full is intended to be used by sysadmins and others authorized to update Linux and UNIX-based systems."
  echo "As such, it is best for the script to have limited writing and executing permissions."
  echo "This first setup script changes the script's permission."
  printf "\nAs such, this script needs to be executed as root to improve the update_full's permissions.\n"
}

# Checks for root user
RootCheck() {
  # Checks whoami
  case `whoami` in
    "root") ;;
    *)
      MissingRootMessage
      exit 1
      ;;
  esac
  # Checks UID
  case "$UID" in
    "0") ;;
    *)
      MissingRootMessage
      exit 1
      ;;
  esac
  # Check groups
  case `groups` in
    "sudo"|"wheel"|"root") ;;
    *)
      MissingRootMessage
      exit 1
      ;;
  esac
  echo "Script run as root..."
}

# Sets default (root) settings
DefaultSettings() {
  # Sets owner
  OWNERNAME="root"
  # Sets group
  GROUPNAME="root"
  chown $OWNERNAME:$GROUPNAME $SCRIPTNAME
  chmod 744 $SCRIPTNAME
}

# Sets custom settings for chown
CustomChown() {
  # Starts loop
  Q_LOOP1=true
  while [ "$Q_LOOP1" = true ] ; do
    printf "File owner name: "
    read OWNERNAME
    printf "File group name: "
    read GROUPNAME
    chown $OWNERNAME:$GROUPNAME $SCRIPTNAME
    if [ "$?" != "0" ] ; then
      clear
      echo "Something went wrong, try again!"
    else
      Q_LOOP1=false
    fi
  done
}

# Sets custom settings for Chmod
CustomChmod() {
  # Starts loop
  Q_LOOP2=true
  while [ "$Q_LOOP2" = true ] ; do
    printf "Owner rights code: "
    read OWNERRIGHTS
    printf "Group rights code: "
    read GROUPRIGHTS
    printf "Others rights code: "
    read OTHERSRIGHTS
    chmod $OWNERRIGHTS$GROUPRIGHTS$OTHERSRIGHTS $SCRIPTNAME
    if [ "$?" != "0" ] ; then
      clear
      echo "Something went wrong, try again!"
    else
      Q_LOOP2=false
    fi
  done
}

# Main
clear
# Runs Root check function
RootCheck
SCRIPTNAME="update_full-unix.sh"

# Start default check loop
DEFAULT_Q_LOOP=true
while [ "$DEFAULT_Q_LOOP" = true ] ; do
  echo "Do you want to use defaults ($SCRIPTNAME is owned by root, $SCRIPTNAME can only be read, writen, and executed by user (root), and read by everyone else)?"
  echo "!!!RECOMMENDED!!!"
  printf "[Y]es/[N]o < "
  read DEFAULT_Q
  case $DEFAULT_Q in
    "Y"|"y"|"Yes"|"yes")
      DefaultSettings
      DEFAULT_Q_LOOP=false
      ;;
    "N"|"n"|"No"|"no")
      Q_LOOP0=true
      while [ "$Q_LOOP0" = true ] ; do
        echo "What do you want to change?"
        printf "\t[1] chown (change file owner and group)\n"
        printf "\t[2] chmod (change file mode bits)\n"
        printf "\t[3] Both\n"
        printf "\t[4] Use defaults instead\n"
        printf " < "
        read Q_0
        case $Q_0 in
          "1")
            CustomChown
            ;;
          "2")
            CustomChmod
            Q_LOOP0=false
            ;;
          "3")
            CustomChown
            CustomChmod
            Q_LOOP0=false
            ;;
          "4")
            DefaultSettings
            Q_LOOP0=false
            ;;
        esac
      done
      ;;
    *)
      clear
      echo "Invalid response, try again."
      ;;
  esac
done

# Notifies user to changed permissions
printf "\n\e[1mPermissions changed for $SCRIPTNAME!\e[0m\n"
# Describes changes
echo "$SCRIPTNAME's owner is now '$OWNERNAME' in group '$GROUPNAME'."
printf "This first-setup script will now delf-destruct.\n\tIf you need different permissions and ownership, change it manually!\n"
rm -f $0
exit 0

# uf-first-setup.sh  Copyright (C) 2024  Mikhail P. Ortiz-Lunyov
#   This program comes with ABSOLUTELY NO WARRANTY.
#   This is free software, and you are welcome to redistribute it
#   under certain conditions.
