# Written by Mikhail Patricio Ortiz-Lunyov
#
# Updated: March 4th 2023
# This script is licensed under the GNU Public License Version 3 (GPLv3).
# Compatible and tested with BASH, SH, KSH, ASH, and ZSH.
# Not compatible with CSH, TCSH, or Powershell (Development in progress).
# More information about license in readme and bottom.
# Best practice is to limit writing permissions to this script in order to avoid accidental or malicious tampering.
# Checking the hashes from the github can help to check for tampering.

# Prints Exit Statement
ExitStatement () {
    printf "\tI hope this program was useful for you!\n\n"
    printf "\t\e[3mPlease give this project a star on github!\e[0m\n"
}

# Tests network connectivity using PING
NetworkTest () {
    printf "Checking network connectivity using ping ($PING_TARGET):\n=-=-=-=-=\n"
    # Checks internet connectivity using ping
    # If ping command returns anything except 0, echo error statement and exit script
    ping -q -c 6 $PING_TARGET || {
        # Bold Font (\e[1m), Black background (\e[40m), Red X (\e[31m)
        printf "\e[1;1m\e[1;40m--\e[1;31mx\e[1;0m\e[1;1m\e[1;40m-->\e[1;0m No Connection, diagnose the problem and relaunch script.\n"
        if [ "$SAVECONFIRM" = true ] ; then
            SAVESTATSNOPING=true
            SaveStats
        else
            exit 1
        fi
    }
    # Otherwise, continue as usual
        # Bold Font (\e[1m), Black background (\e[40m), Green + (\e[32m)
    printf "\e[1;1m\e[1;40m--\e[1;32m+\e[1;0m\e[1;40m-->\e[1;0m Connection to $PING_TARGET successful, beginning update:\n=-=-=-=-=\n"
}

# For Debian/Ubuntu-based operating systems
AptUpdate () {
    APTFLAG=true
    printf "\t\e[1mDEBIAN/UBUNTU detected!\e[0m\n\n"
    $ROOTUSE apt-get update
    $ROOTUSE apt-get $APT_UPGRADE $MANQ
    $ROOTUSE apt-get -f install $MANQ
    $ROOTUSE apt-get autoremove $MANQ
    $ROOTUSE apt-get autoclean $MANQ
}

# For Red HAT Enterprise Linux-based operating systems
DnfUpdate () {
    DNFFLAG=true
    printf "\t\e[1mRED HAT detected\e[0m\n\n"
    $ROOTUSE dnf check-update $MANQ
    $ROOTUSE dnf update $MANQ
    $ROOTUSE dnf autoremove $MANQ
}

# Also for Red Hat Enterprise Linux-based operating systems
YumUpdate () {
    YUMFLAG=true
    printf "\t\e[1mRED HAT detected\e[0m\n\n"
    $ROOTUSE yum check-update $MANQ
    $ROOTUSE yum update $MANQ
    $ROOTUSE yum autoremove $MANQ
}

# For Flatpaks
FlatpakUpdate () {
    FLATPAKFLAG=true
    printf "\t\e[1mFLATPAK detected\e[0m\n\n"
    flatpak update $MANQ
    flatpak uninstall --unused $MANQ
}

# For Snaps
SnapUpdate () {
    SNAPFLAG=true
    printf "\t\e[1mSNAP detected\e[0m\n\n"
    snap refresh
}

# For Clear Linux
SwupdUpdate () {
    SWUPDFLAG=true
    printf "\t\e[1mCLEAR LINUX detected\e[0m\n\n"
    echo "By default, Clear Linux automatically updates its packages. You may need to disable auto-update."
    $ROOTUSE swupd check-update $MANQ
    $ROOTUSE swupd update $MANQ
}

# For Alpine Linux
ApkUpdate () {
    APKFLAG=true
    printf "\t\e[1mALPINE LINUX detected\e[0m\n\n"
    $ROOTUSE apk update
    $ROOTUSE apk upgrade
    $ROOTUSE apk fix
}

# For Arch Linux
PacmanUpdate () {
    PACMANFLAG=true
    printf "\t\e[1mARCH LINUX detected\e[0m\n\n"
    $ROOTUSE pacman -Syu $MANQ
}

# For OpenSUSE Linux
ZypperUpdate () {
    ZYPPERFLAG=true
    printf "\t\e[1mOpenSUSE LINUX detected\e[0m\n\n"
    $ROOTUSE zypper list-updates
    $ROOTUSE zypper patch-check
    $ROOTUSE zypper $SUSE_UPGRADE $MANQ
    $ROOTUSE zypper patch $MANQ
    $ROOTUSE zypper purge-kernels
}

# For Nix OS Linux
NixUpdate () {
    NIXFLAG=true
    printf "\t\e[1mNIX OS or PACKAGE MANAGER detected\e[0m\n\n"
    $ROOTUSE nix-channel --update
    $ROOTUSE nix-env --upgrade
    $ROOTUSE nix-env --delete-generations old
    $ROOTUSE nix-collect-garbage
}

# For FreeBSD-based operating systems
PkgUpdate () {
    PKGFLAG=true
    printf "\t\e[1mFREEBSD detected\e[0m\n\n"
    $ROOTUSE pkg update
    $ROOTUSE pkg upgrade $MANQ
    $ROOTUSE pkg autoremove $MANQ
    $ROOTUSE pkg clean
    $ROOTUSE pkg audit -F
}

# For OpenBSD
Pkg_addUpdate () {
    PKG_ADDFLAG=true
    printf "\t\e[1mOPENBSD detected\e[0m\n\n"
    $ROOTUSE pkg_add -Uuvm
    $ROOTUSE syspatch
}

# For Portsnaps
PortsnapUpdate () {
    PORTSNAPFLAG=true
    printf "\t\e[1mPORTSNAP detected\e[0m\n\n"
    $ROOTUSE portsnap auto
}

# For Homebrew
BrewUpdate () {
    BREWFLAG=true
    printf "\t\e[1mHOMEBREW detected\e[0m\n\n"
    $ROOTUSE brew update
    $ROOTUSE brew upgrade -v
    $ROOTUSE brew cleanup -v
}

# For Void Linux
XbpsUpdate () {
    XBPSFLAG=true
    printf "\t\e[1mVOID LINUX detected\e[0m\n\n"
    $ROOTUSE xbps-install -u xbps
    $ROOTUSE xbps-install -Su
}

# For RubyGems
GemUpdate () {
    GEMFLAG=true
    printf "\t\e[1mRUBYGEM detected!\e[0m\n\n"
    $ROOTUSE gem update
    $ROOTUSE gem cleanup
}

# For Node.Js Package Manager
NpmUpdate () {
    NPMFLAG=true
    printf "\t\e[1mNODE.JS PACKAGE MANAGER detected!\e[0m\n\n"
    $ROOTUSE npm update
}

# For Yarn
YarnUpdate () {
    YARNFLAG=true
    printf "\t\e[1mYARN detected\e[0m\n\n"
    $ROOTUSE yarn upgrade
    $ROOTUSE yarn install
}

# Selects the correct package manager to modify packages
CheckPkgAuto () {
    NOPKG=0
    while [ "$CHECK_PKG" = true ] ; do
        # If disabling alternative package managers is not disabled.
        if [ "$DISABLEALT" = false ] ; then
            flatpak > /dev/null 2>&1
            if [ "$?" != "127" -a "$?" = "1" ] ; then
                FlatpakUpdate
            else
                NOPKG=$(( $NOPKG + 1 ))
            fi
            snap > /dev/null 2>&1
            if [ "$?" != "127" -a "$?" = "0" ] ; then
                SnapUpdate
            else
                NOPKG=$(( $NOPKG + 1 ))
            fi
            brew > /dev/null 2>&1
            if [ "$?" != "127" -a "$?" = "1" ] ; then
                BrewUpdate
            fi
            portsnap > /dev/null 2>&1
            if [ "$?" != "127" -a "$?" = "0" ] ; then
                PortsnapUpdate
            else
                NOPKG=$(( $NOPKG + 1 ))
            fi
            gem > /dev/null 2>&1
            if [ "$?" != "127" -a "$?" = "1" ] ; then
                GemUpdate
            else
                NOPKG=$(( $NOPKG + 1 ))
            fi
            yarn --version > /dev/null 2>&1
            if [ "$?" != "127" -a "$?" = "0" ] ; then
                YarnUpdate
            else
                NOPKG=$(( $NOPKG + 1 ))
            fi
            if [ "$ALTONLY" = true ] ; then
                CHECK_PKG=false
            else
                NOPKG=$(( $NOPKG + 1 ))
            fi
        else
            printf "\t\e[1mSkipping Alternative Package managers...\e[0m\n\n"
        fi
        if [ "$ALTONLY" = false ] ; then
            nix > /dev/null 2>&1
            if [ "$?" != "127" -a "$?" = "1" ] ; then
                NixUpdate
                # No 'CHECK_PKG=false', due to Nix package manager being able to exist with other distros' package managers
            else
                NOPKG=$(( $NOPKG + 1 ))
            fi
            xbps-install > /dev/null 2>&1
            if [ "$?" != "127" -a "$?" = "1" ] ; then
                XbpsUpdate
                CHECK_PKG=false
            else
                NOPKG=$(( $NOPKG + 1 ))
            fi
            apt > /dev/null 2>&1
            if [ "$?" != "127" -a "$?" = "1" ] ; then
                AptUpdate
                CHECK_PKG=false
            else
                NOPKG=$(( $NOPKG + 1 ))
            fi
            # If the user adds the argument to use YUM instead of DNF, use YUM
            if [ "$YUM_UPDATE" = true ] ; then
                yum > /dev/null 2>&1
                if [ "$?" != "127" -a "$?" = "0" ] ; then
                    YumUpdate
                    CHECK_PKG=false
                else
                    NOPKG=$(( $NOPKG + 1 ))
                fi
            # Else, use Dnf
            else
                dnf > /dev/null 2>&1
                if [ "$?" != "127" -a "$?" = "0" ] ; then
                    DnfUpdate
                    CHECK_PKG=false
                else
                    NOPKG=$(( $NOPKG + 1 ))
                fi
            fi
            swupd > /dev/null 2>&1
            if [ "$?" != "127" -a "$?" = "0" ] ; then
                SwupdUpdate
                CHECK_PKG=false
            else
                NOPKG=$(( $NOPKG + 1 ))
            fi
            apk > /dev/null 2>&1
            if [ "$?" != "127" -a "$?" = "1" ] ; then
                ApkUpdate
                CHECK_PKG=false
            else
                NOPKG=$(( $NOPKG + 1 ))
            fi
            pacman > /dev/null 2>&1
            if [ "$?" != "127" -a "$?" = "1" ] ; then
                PacmanUpdate
                CHECK_PKG=false
            else
                NOPKG=$(( $NOPKG + 1 ))
            fi
            zypper > /dev/null 2>&1
            if [ "$?" != "127" -a "$?" = "0" ] ; then
                ZypperUpdate
                CHECK_PKG=false
            else
                NOPKG=$(( $NOPKG + 1 ))
            fi
            pkg > /dev/null 2>&1
            if [ "$?" != "127" -a "$?" = "1" ] ; then
                PkgUpdate
                CHECK_PKG=false
            else
                NOPKG=$(( $NOPKG + 1 ))
            fi
            pkg_add > /dev/null 2>&1
            if [ "$?" != "127" -a "$?" = "1" ] ; then
                Pkg_addUpdate
                CHECK_PKG=false
            else
                NOPKG=$(( $NOPKG + 1 ))
            fi
        else
            printf "\t\e[1mSkipping Official Package managers...\e[0m\n\n"
        fi
        if [ "$NOPKG" = "17" ] ; then
            printf "\t\e[1mNO KNOWN PACKAGE MANAGERS DETECTED AT ALL!!!\e[0m\n\n"
            CHECK_PKG=false
        elif [ "$NOPKG" = "10" -a "$BREWFLAG" = true ] ; then
            printf "\t\e[1mNO OFFICIAL PACKAGE MANAGERS DETECTED, BREW UPDATED...\e[0m\n"
            printf "Using MacOS?\n\n"
            CHECK_PKG=false
        elif [ "$NOPKG" = "10" ] ; then
            printf "\t\e[1mNO KNOWN OFFICIAL PACKAGE MANAGERS DETECTED!\e[0m\n\n"
            CHECK_PKG=false
        elif [ "$NOPKG" = "7" ] ; then
            printf "\t\e[1mNO KNOWN ALTERNATIVE PACKAGE MANAGERS DETECTED!\e[0m\n\n"
            CHECK_PKG=false     
        else
            printf "\t\e[1mSOMETHING ELSE IS DETECTED!\e[0m\n\n]"
            CHECK_PKG=false
        fi
    done
}

 # Prints a Help message
 HelpMessage () {
    echo ' = = ='
    echo 'This bash script allows for a full update on most UNIX systems, on most package managers.'
    # Explain two different types of arguments for this script
    printf "This script uses two different kinds of arguments: \e[1mFunctional (changes how the script works)\e[0m and \e[1mDescriptive (gives information about the script)\e[0m.\n"
    # Explain Functional arguments
    printf "\n\tFunctional arguments:\n"
    # Explain --no-test / -nt
    printf "\nBy default, the script attempts to test the connection of the computer to the internet before attempting to update ay packages.\n"
    printf "\tTo disable this, add the \e[1m--no-test\e[1;0m or \e[1m-nt\e[0m argument when running the script.\n"
    # Explain --custom-domain / -cd
    printf '\nBy default, the script uses the domain \e[1mcloudflare.com\e[0m in the ping test. One can also customise the domain that the update script attempts to contact.\n'
    printf "\tThis can be done by adding \e[1m--custom-domain\e[0m or \e[1m-cd\e[0m argument.\n"
    # Explain --manual-all / -ma
    printf "\nOne can make any questions the package manager makes to be manually decided. By default, any questions are answered with \e[1m-y\e[0m.\n"
    printf "\tTo disable this, add the \e[1m--manual-all\e[0m or \e[1m-ma\e[0m argument.\n"
    # Explain --disable-alt-managers / -dam
    printf "\nBy default, the script attempts to check the existence of and update packages from alternative package managers such as Flatpaks and Snaps.\n"
    printf "\tTo disable this, add the \e[1m--disable-alt-managers\e[0m or \e[1m-dam\e[0m argument.\n"
    # Explain yum-update / -yu
    printf "\nBy default, the script uses the more modern DNF package manager instead of the older YUM package manager if the Linux distrobution is Red-Hat based.\n"
    printf "\tTo use YUM instead of DNF, add the \e[1m--yum-update\e[0m or \e[1m-yu\e[0m argument.\n"
    # Explain --alt-only / -ao
    printf "\nBy default, the script attempts to update both the official distrobution packag managers and any alternative package managers installed.\n"
    printf "\tTo only update alternative package managers, add the \e[1m--alt-only\e[0m or \e[1m-ao\e[0m argument.\n"
    #Explain --save-statistics / -ss
    printf "\nBy default, the script does not save any statistics on errors or general usage.\n"
    printf "\tTo save statistics into a log file (and even make comments for context!), add the \e[1m--save-statistics\e[0m or \e[1m--ss\e[0m argument.\n"
    # Esplain Descriptive arguments
    printf "\n\tDescriptive arguments:\n"
    # Exlpain --help / -h
    printf "\nTo print the help statement, add the \e[1m--help\e[0m or \e[1m-h\e[0m argument\n"
    # Explain --conditions / -c
    printf "\nTo print the conditions of redistribution, add the \e[1m--conditions\e[0m or \e[1m-c\e[0m argument.\n"
    # Explain --warranty / -w
    printf "\nTo print the warranty of the program, add the \e[1m--warranty\e[0m or \e[1m-w\e[0m argument.\n"
    # Explain --privacy-policy / -pp
    printf "\nTo print the privacy policy of the program, add the \e[1m--privacy-policy\e[0m or \e[1m-pp\e[0m argument.\n"
    # Basic security advice
    printf "\nIt is safest to limit writing permissions to avoid malicious/accidental tampering!\n"
 }

# Prints the conditions under which the GPLv3 license allows the program to be redistributed
ConditionMessage () {
    echo ' = = ='
    echo 'If conditions are imposed on you (whether by court order, agreement or otherwise) that contradict the conditions of this'
    echo 'License, they do not excuse you from the conditions of this License. If you cannot convey a covered work so as to'
    echo 'satisfy simultaneously your obligations under this License and any other pertinent obligations, then as a consequence'
    echo 'you may not convey it at all. For example, if you agree to terms that obligate you to collect a royalty for further'
    echo 'conveying from those to whom you convey the Program, the only way you could satisfy both those terms and this'
    echo 'License would be to refrain entirely from conveying the Program.'
}

# Prints the warranty under which GPLv3 covers the script
WarrantyMessage () {
    echo ' = = ='
    echo 'THERE IS NO WARRANTY FOR THE PROGRAM, TO THE EXTENT PERMITTED BY APPLICABLE LAW.'
    echo 'EXCEPT WHEN OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES'
    echo 'PROVIDE THE PROGRAM “AS IS” WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR'
    echo 'IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND'
    echo 'FITNESS FOR A PARTICULAR PURPOSE. THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE'
    echo 'OF THE PROGRAM IS WITH YOU. SHOULD THE PROGRAM PROVE DEFECTIVE, YOU ASSUME THE'
    echo 'COST OF ALL NECESSARY SERVICING, REPAIR OR CORRECTION.'
}

# Prints the privacy policy
PrivacyPolicyMessage () {
    echo ' = = ='
    echo 'THIS PROGRAM DOES NOT COLLECT ANY TELEMETRY OR USER DATA.'
    echo 'THE ONLY TIME IN WHICH THIS PROGRAM CONNECTS TO THE INTERNET IS DURING'
    echo 'THE PING TEST (IN ORDER TO VERIFY CONNECTION TO THE INTERNET, CAN BE DISABLED)'
    echo 'AND WHILE UPDATING PACKAGES THROUGH THEIR RESPECTIVE PACKAGE MANAGERS.'
    echo 'THE ONLY TIME THAT THIS SCRIPT ACCESSES THE USERS FILE SYSTEM IS WHEN MAKING'
    echo 'LOG FILES (WITH EXPRESS CONSENT FROM THE USER) AND WHEN CALLING UPON THE'
    echo 'VARIOUS PACKAGE MANAGERS THAT THE SCRIPT SUPPORTS TO UPDATE THEIR PACKAGES.'
    echo 'THIS SCRIPT CAN ONLY CONTROL THE PACKAGE MANAGERS THROUGH THE'
    echo 'CONTROLS THEY PROVIDE TO THEIR USERS.'
    echo 'ALL OF THESE STATEMENTS CAN BE VERIFIED, AS THIS SOFTWARE IS FREE & OPEN-SOURCE,'
    echo 'THUS MEANING THAT ANYBODY CAN READ THE SOURCE CODE AND VERIFY WHAT IT DOES.'
}

# This function sets up the commenting function in the SaveStats function
SaveStatsComments () {
    printf "\n\n\e[1mType in the letters \"~esc~\" to exit the comments bar\n= = =\n"
    COMMENTINPUT=""
    # Loops until user types in 'esc'
    until [ "$COMMENTINPUT" = "~esc~" ] ; do
        ( echo "$COMMENTINPUT" ) >> ./tempfile || {
            # In case user deletes tempfile while writing comments
            tempfileISSUEFLAG=true
            break
        }
        printf "TYPE: "
        read COMMENTINPUT
    done
    printf "= = =\n\e[0m"
    if [ "tempfileISSUEFLAG" = true ] ; then
        LOGCOMMENTS="tempfile PREMATURELY DELETED, USER COMMENTS NOT SAVED"
    else
        LOGCOMMENTS="$(cat ./tempfile)"
        if [ "$LOGCOMMENTS" = "" ] ; then
            LOGCOMMENTS="*No comments by user*"
        fi
        rm ./tempfile
    fi
    ( echo "= = User-Generated Comments: = =" && echo "$LOGCOMMENTS" && printf "= = = = = = = = = =\n\n" ) >> ./uf-unix-log.txt
}

# This function records and sets up the package managers used by the script for the save-statistics argument.
SaveStatsPkgLog () {
    # Begins to prepare adding the used package managers in log
    OFFICIALPKGMAN="No official package managers used"
    ALTPKGMAN="No alternative package managers used"
    STATUSFLATPAK="NOT USED"
    STATUSSNAP="NOT USED"
    STATUSPORTSNAP="NOT USED"
    STATUSBREW="NOT USED"
    STATUSGEM="NOT USED"
    STATUSYARN="NOT USED"
    STATUSNPM="NOT USED"
    # For official Package Managers
    if [ "$APTFLAG" = true ] ; then
        OFFICIALPKGMAN="APT package manager used."
    elif [ "$PACMANFLAG" = true ] ; then
        OFFICIALPKGMAN="PACMAN package manager used."
    elif [ "$DNFFLAG" = true ] ; then
        OFFICIALPKGMAN="DNF package manager used."
    elif [ "$YUMFLAG" = true ] ; then
        OFFICIALPKGMAN="YUM package manager used."
    elif [ "$SWUPDFLAG" = true ] ; then
        OFFICIALPKGMAN="SWUPD package manager used."
    elif [ "$APKFLAG" = true ] ; then
        OFFICIALPKGMAN="APK package manager used."
    elif [ "$PACMANFLAG" = true ] ; then
        OFFICIALPKGMAN="PACMAN package manager used."
    elif [ "$ZYPPERFLAG" = true ] ; then
        OFFICIALPKGMAN="ZYPPER package manager used."
    elif [ "$NIXFLAG" = true ] ; then
        OFFICIALPKGMAN="NIX package manager used."
    elif [ "$PKGFLAG" = true ] ; then
        OFFICIALPKGMAN="PKG package manager used."
    elif [ "$PKG_ADDFLAG" = true ] ; then
        OFFICIALPKGMAN="PKG_ADD package manager used."
    elif [ "$XBPSFLAG" = true ] ; then
        OFFICIALPKGMAN="XBPS package manager used."
    fi
    # Changes variable ALTPKGMAN as nessesary
    if [ "$FLATPAKFLAG" = true -o "$SNAPFLAG" = true -o "$PORTSNAPFLAG" = true -o "$BREWFLAG" = true -o "$GEMFLAG" = true -o "$YARNFLAG" = true -o "$NPMFLAG" = true ] ; then
        ALTPKGMAN="Alternative package managers used"
    fi
    # For alternative package managers
    if [ "$FLATPAKFLAG" = true ] ; then
        STATUSFLATPAK="USED"
        FLATPAKFLAG=false
    fi
    if [ "$SNAPFLAG" = true ] ; then
        STATUSSNAP="USED"
        FLATPAKFLAG=false
    fi
    if [ "$PORTSNAPFLAG" = true ] ; then
        STATUSPORTSNAPSNAP="USED"
        PORTSNAPFLAG=false
    fi
    if [ "$BREWFLAG" = true ] ; then
        STATUSBREW="USED"
        BREWFLAG=false
    fi
    if [ "$GEMFLAG" = true ] ; then
        STATUSGEM="USED"
        GEMFLAG=false
    fi
    if [ "$YARNFLAG" = true ] ; then
        STATUSYARN="USED"
        YARNFLAG=false
    fi
    if [ "$NPMFLAG" = true ] ; then
        STATUSNPM="USED"
        YARNFLAG=false
    fi
    # Changes logfile depending on if 
    if [ "$OFFICIALPKGMAN" = "No official package managers used" -a "$ALTPKGMAN" = "No alternative package managers used" ] ; then
        ( echo "No package managers at all detected!" ) >> ./uf-unix-log.txt
    else
        ( echo "$OFFICIALPKGMAN" && printf "$ALTPKGMAN\n FLATPAK:  $STATUSFLATPAK\n SNAP:     $STATUSSNAP\n PORTSNAP: $STATUSPORTSNAP\n BREW:     $STATUSBREW\n GEM:      $STATUSGEM\n NPM:      $STATUSNPM\n" ) >> ./uf-unix-log.txt
    fi
}

# This function sets up the Save Statistics action
SaveStats () {
    # Checks if save stat is enabled
    if [ "$SAVECONFIRM" = true ] ; then
        # Checks if directory exists
        if [ -d "$./update_full-bash-log" ] ; then
            echo "Log directory exists"
        else
            mkdir -p update_full-bash-log
        fi
        # Ends counting time
        TIMEEND=$(date +%s)
        TIMETOTAL=$(( $TIMEEND - $TIMEBEGIN ))
        # If no root detected
        if [ "$SAVESTATSNOROOT" = true ] ; then
            ( echo "Log generated: $(date)" && printf "\t\n$DESC_ROOT\n" && printf "\nTime took: $TIMETOTAL sec.\n--- Unsuccessful Operation ---\n" ) >> ./uf-unix-log.txt
            SaveStatsComments
            # Ending phrase
            printf "Log Saved...\nAll done!\n"
            ExitStatement
            exit 1
        # If ping scan fails
        elif [ "$SAVESTATSNOPING" = true ] ; then
            DESCNOPING="Ping test failed, check domain ($PING_TARGET)"
            ( echo "Log generated: $(date)" && printf "\t\n$DESCNOPING\n" && printf "\nTime took: $TIMETOTAL sec.\n--- Unsuccessful Operation ---\n" ) >> ./uf-unix-log.txt
            SaveStatsComments
            # Ending phrase
            printf "Log Saved...\nAll done!\n"
            ExitStatement
            exit 1
        # If duplicate arguments are detcted
        elif [ "$SAVESTATDUPARGS" = true ] ; then
            DESCDUPARGS="Duplicate arguments detected"
            ( echo "Log generated: $(date)" && printf "\t\n$DESCDUPARGS\n" && printf "\nTime took: $TIMETOTAL sec.\n--- Unsuccessful Operation ---\n" ) >> ./uf-unix-log.txt
            SaveStatsComments
            # Ending phrase
            printf "Log Saved...\nAll done!\n"
            ExitStatement
            exit 1
        # If too many arguments are detected
        elif [ "$SAVESTATTOOMANYARGS" = true ] ; then
            DESCTOOMANYARGS="Too many arguments detected"
            ( echo "Log generated: $(date)" && printf "\t\n$DESCTOOMANYARGS\n" && printf "\nTime took: $TIMETOTAL sec.\n--- Unsuccessful Operation ---\n" ) >> ./uf-unix-log.txt
            SaveStatsComments
            # Ending phrase
            printf "Log Saved...\nAll done!\n"
            ExitStatement
            exit 1
        # If two or more incompatible functional arguments are detected
        elif [ "$SAVESTATINCOMPARGS" = true ] ; then
            DESCINCOPARGS="Incompatible arguments detected($INCOMPARGS_DETAIL)"
            ( echo "Log generated $(date)" && printf "\t\n$DESCINCOPARGS\n" && printf "\nTime took: $TIMETOTAL sec.\n--- Unsuccessful Operation ---\n" ) >> ./uf-unix-log.txt
            SaveStatsComments
            # Ending phrase
            printf "Log Saved...\nAll done!\n"
            ExitStatement
            exit 1
        # If everything else worked normally
        elif [ "$SAVESTATSNOROOT" = false -a "$SAVESTATSNOPING" = false ] ; then
            SaveStatsPkgLog
            ( echo "Log generated: $(date)" && printf "\t\nScript run$DESC$DESC_LOG\n" && printf "\nTime took: $TIMETOTAL sec.\n--- Successful Operation ---\n" ) >> ./uf-unix-log.txt
            SaveStatsComments
            # Ending phrase
            printf "Log Saved...\nAll done!\n"
            ExitStatement
        fi
    else
        echo "All done!"
        ExitStatement
    fi
}

# Action Flag Function
ActionFlag () {
    # Functional arguments
    if [ "$1" = "--save-stats" -o "$1" = "-ss" ] ; then
        DESC_SS=" and saving in log"
        SAVECONFIRM=true
    elif [ "$1" = "--no-test" -o "$1" = "-nt" ] ; then
        DESC_NT=" skipping ping testing"
        TEST_CONNECTION=false
    elif [ "$1" = "--custom-domain" -o "$1" = "-cd" ] ; then
        DESC_CD=" using custom domain"
        CUSTOM_DOMAIN=true
    elif [ "$1" = "--manual-all" -o "$1" = "-ma" ] ; then
        DESC_MA=" using manual setting"
        MANUAL_ALL=true
    elif [ "$1" = "--disable-alt-managers" -o "$1" = "-dam" ] ; then
        DESC_DAM=" skipping alternative package managers"
        DISABLEALT=true
    elif [ "$1" = "--yum-update" -o "$1" = "-yu" ] ; then
        DESC_YU=" using YUM over DNF"
        YUM_UPDATE=true
    elif [ "$1" = "--alt-only" -o "$1" = "-ao" ] ; then
        DESC_AO=" using only alternative package managers"
        ALTONLY=true
    # Descriptive Arguments
    elif [ "$1" = "--conditions" -o "$1" = "-c" ] ; then
        CONDITIONS=true
    elif [ "$1" = "--privacy-policy" -o "$1" = "-pp" ] ; then
        PRIVACYPOLICY=true
    elif [ "$1" = "--warranty" -o "$1" = "-w" ] ; then
        WARRANTY=true
    elif [ "$1" = "--help" -o "$1" = "-h" ] ; then
        HELP=true
    else    
        printf "ARGUMENT NOT RECOGNISED!!\n"
        exit 1
    fi
    # Description
    DESC_LOG="$DESC_NT$DESC_CD$DESC_MA$DESC_DAM$DESC_YU$DESC_AO$DESC_SS"
}

# Preperation Function
ActionPrep () {
    # Seperates between descriptive and functional arguments
    # Descriptive arguments below:
    if [ "$CONDITIONS" = "true" -o "$PRIVACYPOLICY" = "true" -o "$WARRANTY" = "true" -o "$HELP" = "true" ] ; then
        if [ "$HELP" = "true" ] ; then
            HelpMessage
        fi
        if [ "$PRIVACYPOLICY" = "true" ] ; then
            PrivacyPolicyMessage
        fi
        if [ "$CONDITIONS" = "true" ] ; then
            ConditionMessage
        fi
        if [ "$WARRANTY" = "true" ] ; then
            WarrantyMessage
        fi
        exit 0
    # Functional argument errors below:
    else
        # Error if all arguments are attempted
        if [ "$SAVECONFIRM" = "true" -a "$TEST_CONNECTION" = "false" -a "$CUSTOM_DOMAIN" = "true" -a "$MANUAL_ALL" = "true" -a "$DISABLEALT" = "true" -a "$YUM_UPDATE" = "true" -a "$ALTONLY" = "true" ] ; then
            echo "All Possible Arguments attempted! Not all functional variables are compatible with one-another!"
            echo "Invalid argument combination (likely -ao/--alt-only and -dam/--disable-alt-managers). Relaunch script with valid combination."
            if [ "$SAVECONFIRM" = true ] ; then
                SAVESTATINCOMPARGS=true
                INCOMPARGS_DETAIL="Likely all possible arguments attempted."
                SaveStats
            else
                exit 1
            fi
        fi
        # Error for mixed -ao/--alternate-only and -dam/--disable-alt-managers
        if [ "$DISABLEALT" = "true" -a "$ALTONLY" = "true" ] ; then
            echo "Invalid argument combination (likely -ao/--alt-only and -dam/--disable-alt-managers). Relaunch script with valid combination."
            if [ "$SAVECONFIRM" = true ] ; then
                SAVESTATINCOMPARGS=true
                INCOMPARGS_DETAIL="Likely -dam / --disable-alt-managers and -ao / --alt-only mixed."
                SaveStats
            else
                exit 1
            fi
        fi
        # Error for mixed -nt/--no-test and -cd/--custom-domain
        if [ "$CUSTOM_DOMAIN" = "true" -a "$TEST_CONNECTION" = "false" ] ; then
            echo "Invalid argument combination (likely -nt/--no-test and -cd/--custom-domain). Relaunch script with valid combination."
            if [ "$SAVECONFIRM" = true ] ; then
                SAVESTATINCOMPARGS=true
                INCOMPARGS_DETAIL="Likely -cd / --custom-domain and -nt / --no-test mixed."
                SaveStats
            else
                exit 1
            fi
        fi
        # Network Test
        if [ "$TEST_CONNECTION" = "true" ] ; then
            # Using default domain
            if [ "$CUSTOM_DOMAIN" = "false" ] ; then
                PING_TARGET="cloudflare.com"
                NetworkTest
            # Using custom domain
            elif [ "$CUSTOM_DOMAIN" = "true" ] ; then
                printf "Type domain: < "
                read PING_TARGET
                NetworkTest
            fi   
        fi
        # Manual controls
        if [ "$MANUAL_ALL" = "true" ] ; then
            # Defines loops for program
            MANQ_DEB1=true
            MANQ_DEB2=true
            MANQ_SUSE1=true
            MANQ_SUSE2=true
            # Makes all package manager questions manual
            MANQ=" "
            while [ "$MANQ_DEB1" = true ] ; do
                printf "Are you updating a \e[3mDebian/Ubuntu-based system\e[0m?\n"
                printf "[Y/y]es/[N/n]o < "
                read MANQ_R1
                if [ "$MANQ_R1" = "N" -o "$MANQ_R1" = "n" -o "$MANQ_R1" = "No" -o "$MANQ_R1" = "no" ] ; then
                    MANQ_DEB1=false
                elif [ "$MANQ_R1" = "Y" -o "$MANQ_R1" = "y" -o "$MANQ_R1" = "Yes" -o "$MANQ_R1" = "yes" ] ; then
                    while [ "$MANQ_DEB2" = true ] ; do
                        printf "Would you like to run: \n\t[1] dist-upgrade (\e[1mdefault\e[0m)\n\tor\n\t[2] upgrade\n\t"
                        printf " < "
                        read MANQ_R2
                        if [ "$MANQ_R2" = "1" ] ; then
                            APT_UPGRADE="dist-upgrade"
                            MANQ_DEB1=false
                            MANQ_DEB2=false
                            # Below two lines added to prevent SUSE loop from starting
                            MANQ_SUSE1=false
                            MANQ_DEB2=false
                        elif [ "$MANQ_R2" = "2" ] ; then
                            APT_UPGRADE="upgrade"
                            MANQ_DEB1=false
                            MANQ_DEB2=false
                            MANQ_SUSE1=false
                            MANQ_DEB2=false
                        else
                            printf "Please select one of the two options. Otherwise, quit and re-leanch the script.\n\n"
                        fi
                    done
                else
                    printf "Please select one of the two options. Otherwise, quit and re-leanch the script.\n\n"
                fi
            done
            while [ "$MANQ_SUSE1" = true ] ; do
                printf "Are you updating an \e[3mOpenSUSE\e[0m system?\n"
                printf "[Y/y]es/[N/n]o < "
                read MANQ_R1
                if [ "$MANQ_R1" = "N" -o "$MANQ_R1" = "n" -o "$MANQ_R1" = "No" -o "$MANQ_R1" = "no" ] ; then
                    MANQ_SUSE1=false
                elif [ "$MANQ_R1" = "Y" -o "$MANQ_R1" = "y" -o "$MANQ_R1" = "Yes" -o "$MANQ_R1" = "yes" ] ; then
                    while [ "$MANQ_SUSE2" = true ] ; do
                        printf "Would you like to run: \n\t[1] dist-upgrade (\e[1mdefault\e[0m)\n\tor\n\t[2] update\n\t"
                        printf " < "
                        read MANQ_R2
                        if [ "$MANQ_R2" = "1" ] ; then
                            SUSE_UPGRADE="dist-upgrade"
                            MANQ_SUSE1=false
                            MANQ_SUSE2=false
                        elif [ "$MANQ_R2" = "2" ] ; then
                            SUSE_UPGRADE="update"
                            MANQ_SUSE1=false
                            MANQ_SUSE2=false
                        else
                            printf "Please select one of the two options. Otherwise, quit and re-leanch the script.\n\n"
                        fi
                    done
                else
                    printf "Please select one of the two options. Otherwise, quit and re-leanch the script.\n\n"
                fi
            done
            printf "\tContinuing...\n"
        fi
    fi
}

# Duplicate Argument Function
DupArgs () {
    printf "NO DUPLICATE ARGS!!\n"
    if [ "$SAVECONFIRM" = true ] ; then
        SAVESTATDUPARGS=true
        SaveStats
    else
        exit 1
    fi
}

# Too Many Argument Functions
TooManyArgs () {
    printf "TOO MANY ARGUMENTS!!\n"
    if [ "$SAVECONFIRM" = true ] ; then
        SAVESTATTOOMANYARGS=true
        SaveStats
    else
        exit 1
    fi
}

# Main
clear
# Starts counting time
TIMEBEGIN=$(date +%s)
# Sets up initial variables
MANUAL_ALL=false
MANQ="-y"
SAVECONFIRM=false
TEST_CONNECTION=true
CUSTOM_DOMAIN=false
DISABLEALT=false
ALTONLY=false
DISABLEALT=false
APT_UPGRADE="dist-upgrade"
# |-- For checking root permission
NOROOT=0
# |- Prepares in case of --save-sttistics function
# |-- For event of no root
SAVESTATSNOROOT=false
# |-- For event of failed ping
SAVESTATSNOPING=false
# |-- For event of duplicate arguments
SAVESTATDUPARGS=false
# |-- For event of too many arguments
SAVESTATTOOMANYARGS=false
# Checks for root privileges
if [ "$(whoami)" != "root" ] ; then
    printf "\e[3mScript not executed as root, checking if user $(whoami) has sudo/doas permission...\e[0m\n"
    sudo > /dev/null 2>&1
    if [ "$?" != 127 -a "$?" = 1 ] ; then
        if [ -n "$(sudo -l | grep "ALL")" ] ; then
            printf "\t\e[3mUser $(whoami) has sudo permissions, continuing...\e[0m\n"
            ROOTUSE="sudo"
            RUNPROMPT=false
        else
            printf "no sudo priviledges detected...\n"
            NOROOT=$(( $NOROOT + 1 ))
        fi
    else
        printf "sudo not found..."
        NOROOT=$(( $NOROOT + 1 ))
        NOSUDO=true
    fi
    doas > /dev/null 2>&1
    if [ "$?" != 127 -a "$?" = 1  ] ; then
        if [ -n "$(groups $(whoami) | grep "wheel")" ] ; then
            printf "\t\e[3mUser $(whoami) has doas permissions, continuing...\e[0m\n"
            ROOTUSE="doas"
            RUNPROMPT=false
        else
            printf "no doas priviledges detected...\n"
            NOROOT=$(( $NOROOT + 1 ))
        fi
    else
        printf "doas not found...\n"
        NOROOT=$(( $NOROOT + 1 ))
        NODOAS=true
    fi
    RUNPROMPT=false
    if [ "$NOSUDO" = true -a "$NODOAS" = true ] ; then
        printf "\t\e[3;5mNeither sudo nor doas detected!\e[0m\n"
        if [ "$SAVECONFIRM" = true ] ; then
            SAVESTATSNOROOT=true
            DESC_ROOT="Nether sudo nor doas detected by the script."
            SaveStats
        else
            exit 1
        fi
    elif [ "$NOROOT" = "2" ] ; then
        printf "\t\e[3;5mUser $(whoami) has no root privileges!\e[0m\n"
        if [ "$SAVECONFIRM" = true ] ; then
            SAVESTATSNOROOT=true
            DESC_ROOT="User $(whomami) had no root priviledges."
            SaveStats
        else
            exit 1
        fi
    fi
else
    printf "\tScript is run as root\n"
    ROOTUSE=""
fi
# Collect arguments
if [ "$1" != "" ] ; then
    ActionFlag $1
    if [ "$2" != "" ] ; then
        # Check for duplicates
        if [ "$2" = "$1" ] ; then
            DupArgs
        else
            ActionFlag $2
            if [ "$3" != "" ] ; then
                if [ "$3" = "$2" -o "$3" = "$1" ] ; then
                    DupArgs
                else
                    ActionFlag $3
                    if [ "$4" != "" ] ; then
                        if [ "$4" = "$3" -o "$4" = "$2" -o "$4" = "$1" ] ; then
                            DupArgs
                        else
                            ActionFlag $4
                            if [ "$5" != "" ] ; then
                                if [ "$5" = "$4" -o "$5" = "$3" -o "$5" = "$2" -o "$5" = "$1" ] ; then
                                    DupArgs
                                else
                                    ActionFlag $5
                                    if [ "$6" = "$5" -o "$6" = "$4" -o "$6" = "$3" -o "$6" = "$2" -o "$6" = "$1" ] ; then
                                        DupArgs
                                    else
                                        ActionFlag $6
                                        if [ "$7" != "" ] ; then
                                            if [ "$7" = "$6" -o "$7" = "$5" -o "$7" = "$4" -o "$7" = "$3" -o "$7" = "$2" -o "$7" = "$1" ] ; then
                                                DupArgs
                                            fi
                                        else
                                            ActionFlag $7
                                            if [ "$#" -gt 7 ] ; then
                                                TooManyArgs
                                            fi
                                        fi
                                    fi
                                fi
                            fi
                        fi
                    fi
                fi
            fi
        fi
    fi
fi
ActionPrep
printf "Running \e[4mUpdate_Full [GENERIC UNIX]\e[01;m script\e[1m$DESC_LOG"
printf "\e[0m:\nDate and Time is:\n\t$(date)\n"
# Begins the package manager checker function
CHECK_PKG=true
CheckPkgAuto
SaveStats

# Update_full-unix.sh  Copyright (C) 2023  Mikhail Patricio Ortiz-Lunyov
#   This program comes with ABSOLUTELY NO WARRANTY; for details add argument `-w' or `--warranty'.
#   This is free software, and you are welcome to redistribute it
#   under certain conditions; add argument `-c' or `--conditions' for details.
