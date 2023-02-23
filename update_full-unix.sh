# Updated: February 23rd 2023
#
# Written by Mikhail Patricio Ortiz-Lunyov
# This script is licensed under the GNU Public License Version 3 (GPLv3).
# Compatible and tested with BASH, SH, KSH, ASH.
# For ZSH, use update_full-bash-zsh <https://github.com/mportizlunyov/update_full-zsh>
# More information about license in readme and bottom.
# Best practice is to limit writing permissions to this script in order to avoid accidental or malicious tampering.
# Checking the hashes from the github can help to check for tampering.

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

# Decides based on the arguments whether to perform a ping on a domain or not.
DecideTest () {
    if [ "$TEST_CONNECTION" = true ] ; then
        NetworkTest
    fi
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
    $ROOTUSE apk pacman -Syu $MANQ
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
    # Decides whether to do the Ping Test
    DecideTest
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
        fi
    done
}

# Sets up the manual
ManualApt () {
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
}

# Sets up the default settings, as well as modifiers
Settings () {
    # Default option (cloudflare.com domain)
    if [ "$1" = "" -o "$1" = "0" ] ; then
        PING_TARGET="cloudflare.com"
    # Custom domain
    elif [ "$1" = "custom-domain" ] ; then
        #PING_TARGET="$1"
        if [ "$INPUTDOMAIN" = "true" ] ; then
            # Takes input from user for custom domain to use ping test on
            printf "Type domain: < "
            read PING_TARGET
        fi
    fi
    # Default option (do ping test)
    if [ "$2" = "" -o "$2" = "0" ] ; then
        TEST_CONNECTION=true
    # Do not do ping test
    elif [ "$2" = "no-test" ] ; then
        TEST_CONNECTION=false
    fi
    # Default option (dist-upgrade on apt, default -y option)
    if [ "$3" = "" -o "$3" = "0" ] ; then
        MANQ="-y"
        APT_UPGRADE="dist-upgrade"
    # Al questions manual, further configuration
    elif [ "$3" = "manual" ] ; then
        ManualApt
    fi
    # Default option (check for updates on alternative package managers if they exist)
    if [ "$4" = "" -o "$4" = "0" ] ; then
        DISABLEALT=false
    # Only use the distro's official package manager
    elif [ "$4" = "disable-alt" ] ; then
        DISABLEALT=true
    fi
    # Use newer dnf instead of older yum
    if [ "$5" = "" -o "$5" = "0" ] ; then
        YUM_UPDATE=false
    # Use older yum instead of newer dnf
    elif [ "$5" = "yum-update" ] ; then
        YUM_UPDATE=true
    fi
    # Use official package manager
    if [ "$6" = "" -o "$6" = "0" ] ; then
        ALTONLY=false
    # Only use alternative package manager
    elif [ "$6" = "alt-only" ] ; then
        ALTONLY=true
    fi
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

# Decides what to do depending on the score:
#  default = 0 [+1]
#   Functional (POINTVAR):
#      -cd = 1  [*2]
#      -nt = 2  [*2]
#      -ma = 4  [*2]
#     -dam = 8  [*2]
#      -yu = 16 [*2]
#      -ao = 32
PointDecideFunc () {
    # Using single arguments only
    #############################
    # Default settings
    DESC_CD=" using custom domain"
    DESC_NT=" skipping ping testing"
    DESC_MA=" using manual setting"
    DESC_DAM=" skipping alternative package managers"
    DESC_YU=" using YUM over DNF"
    DESC_AO=" using only alternative package mangers"
    # Default
    if [ "$POINTVAR" = "0" ] ; then
        Settings
        DESC=" using default settings"
    # Only Custom Directory
    elif [ "$POINTVAR" = "1" ] ; then
        Settings custom-domain
        DESC="$DESC_CD"
    # Only skip ping tests
    elif [ "$POINTVAR" = "2" ] ; then
        Settings 0 no-test
        DESC="$DESC_NT"
    # Only use manual descisions
    elif [ "$POINTVAR" = "4" ] ; then
        Settings 0 0 manual
        DESC="$DESC_MA"
    # Only disable alternative package manangers
    elif [ "$POINTVAR" = "8" ] ; then
        Settings 0 0 0 disable-alt
        DESC="$DESC_DAM"
    # Only enables yum instead of dnf
    elif [ "$POINTVAR" = "16" ] ; then
        Settings 0 0 0 0 yum-update
        DESC="$DESC_YU"
    elif [ "$POINTVAR" = "32" ] ; then
        Settings 0 0 0 0 0 alt-only
        DESC="$DESC_AO"
    # Using combined compatible arguments
    #####################################
    elif [ "$POINTVAR" = "5" ] ; then
        Settings custom-domain 0 manual
        DESC="$DESC_CD ($PING_TARGET) and$DESC_MA"
    elif [ "$POINTVAR" = "6" ] ; then
        Settings 0 no-test manual
        DESC="$DESC_NT and$DESC_MA"
    elif [ "$POINTVAR" = "9" ] ; then
        Settings custom-domain 0 0 disable-alt
        DESC="$DESC_DAM and$DESC_CD ($PING_TARGET)"
    elif [ "$POINTVAR" = "10" ] ; then
        Settings 0 no-test 0 disable-alt
        DESC="$DESC_DAM and$DESC_NT"
    elif [ "$POINTVAR" = "12" ] ; then
        Settings 0 0 manual disable-alt
        DESC="$DESC_DAM and$DESC_MA"
    elif [ "$POINTVAR" = "13" ] ; then
        Settings custom-domain 0 manual disable-alt
        DESC="$DESC_DAM,$DESC_CD ($PING_TARGET) and$DESC_MA"
    elif [ "$POINTVAR" = "14" ] ; then
        Settings 0 no-test manual disable-alt
        DESC="$DESC_DAM,$DESC_NT and$DESC_MA"
    elif [ "$POINTVAR" = "17" ] ; then
        Settings custom-domain 0 0 0 yum-update
        DESC="$DESC_YU and$DESC_CD ($PING_TARGET)"
    elif [ "$POINTVAR" = "18" ] ; then
        Settings 0 no-test 0 0 yum-update
        DESC="$DESC_YU and$DESC_NT"
    elif [ "$POINTVAR" = "20" ] ; then
        Settings 0 0 manual 0 yum-update
        DESC="$DESC_YU and$DESC_MA"
    elif [ "$POINTVAR" = "21" ] ; then
        Settings custom-domain 0 manual 0 yum-update
        DESC="$DESC_YU,$DESC_MA and$DESC_CD ($PING_TARGET)"
    elif [ "$POINTVAR" = "22" ] ; then
        Settings 0 no-test manual 0 yum-update
        DESC="$DESC_YU,$DESC_MA and$DAM_NT"
    elif [ "$POINTVAR" = "24" ] ; then
        Settings 0 0 0 disable-alt yum-update
        DESC="$DESC_YU and$DESC_DAM"
    elif [ "$POINTVAR" = "25" ] ; then
        Settings custom-domain 0 0 disable_alt yum-update
        DESC="$DESC_YU,$DESC_DAM and$DESC_CD ($PING_TARGET)"
    elif [ "$POINTVAR" = "26" ] ; then
        Settings 0 no-test 0 disable-alt yum-update
        DESC="$DESC_YU,$DESC_DAM and$DESC_NT"
    elif [ "$POINTVAR" = "28" ] ; then
        Settings 0 0 manual disable-alt yum-update
        DESC="$DESC_YU,$DESC_DAM and$DESC_MA"
    elif [ "$POINTVAR" = "29" ] ; then
        Settings custom-domain 0 manual disable-alt yum-update
        DESC="$DESC_YU,$DESC_DAM,$DESC_MA and$DESC_CD ($PING_TARGET)"
    elif [ "$POINTVAR" = "30" ] ; then
        Settings 0 0 manual disable-alt yum-update
        DESC="$DESC_YU,$DESC_DAM,$DESC_MA and$DESC_NT"
    elif [ "$POINTVAR" = "33" ] ; then
        Settings custom-domain 0 0 0 0 alt-only
        DESC= "$DESC_AO and$DESC_CD ($PING_TARGET)"
    elif [ "$POINTVAR" = "34" ] ; then
        Settings 0 no-test 0 0 0 alt-only
        DESC="$DESC_NT and$DESC_AO"
    elif [ "$POINTVAR" = "36" ] ; then
        Settings 0 0 manual 0 0 alt-only
        DESC="$DESC_MA and$DESC_AO"
    elif [ "$POINTVAR" = "37" ] ; then
        Settings custom-domain 0 manual 0 0 alt-only
        DESC="$DESC_CD ($PING_TARGET),$DESC_MA and$DESC_AO"
    elif [ "$POINTVAR" = "38" ] ; then
        Settings 0 no-test manual 0 0 alt-only
        DESC="$DESC_NT,$DESC_MA and$DESC_AO"
    elif [ "$POINTVAR" = "48" ] ; then
        Settings 0 0 0 0 yum-update alt-only
        DESC="$DESC_YU and$DESC_AO"
    elif [ "$POINTVAR" = "49" ] ; then
        Settings custom-domain 0 0 0 yum-update alt-only
        DESC="$DESC_CD ($PING_TARGET),$DESC_YU and$DESC_AO"
    elif [ "$POINTVAR" = "50" ] ; then
        Settings 0 no-test 0 0 yum-update alt-only
        DESC="$DESC_NT,$DESC_YU and$DESC_AO"
    elif [ "$POINTVAR" = "52" ] ; then
        Settings 0 0 manual 0 yum-update alt-only
        DESC="$DESC_MA,$DESC_YU and$DESC_AO"
    elif [ "$POINTVAR" = "53" ] ; then
        Settings custom-domain 0 manual 0 yum-update alt-only
        DESC="$DESC_CD ($PING_TARGET),$DESC_MA,$DESC_YU and$DESC_AO"
    elif [ "$POINTVAR" = "54" ] ; then
        Settings 0 no-test manual 0 yum-update alt-only
        DESC="$DESC_NT,$DESC_MA,$DESC_YU and$DESC_AO"
    # Error Statement for mixed -nt/--no-test and -cd/--custom-domain
    ##################
    elif [ "$POINTVAR" = "3" -o "$POINTVAR" = "7" -o "$POINTVAR" = "11" -o "$POINTVAR" = "15" -o "$POINTVAR" = "19" -o "$POINTVAR" = "23" -o "$POINTVAR" = "27" -o "$POINTVAR" = "31" -o "$POINTVAR" = "35" -o "$POINTVAR" = "39" -o "$POINTVAR" = "51" -o "$POINTVAR" = "55" ] ; then
        #echo "POINTVAR = $POINTVAR"
        echo "Invalid argument combination (likely -nt/--no-test and -cd/--custom-domain). Relaunch script with valid combination."
        if [ "$SAVECONFIRM" = true ] ; then
            SAVESTATINCOMPARGS=true
            INCOMPARGS_DETAIL="Likely -cd / --custom-domain and -nt / --no-test mixed."
            SaveStats
        else
            exit 1
        fi
    # Error Statement for mixed -ao/--alt-only
    #################
    elif [ "$POINTVAR" = "40" -o "$POINTVAR" = "41" -o "$POINTVAR" = "42" -o "$POINTVAR" = "44" -o "$POINTVAR" = "45" -o "$POINTVAR" = "46" -o "$POINTVAR" = "47" -o "$POINTVAR" = "56" -o "$POINTVAR" = "57" -o "$POINTVAR" = "58" -o "$POINTVAR" = "60" -o "$POINTVAR" = "61" -o "$POINTVAR" = "62" ] ; then
        #echo "POINTVAR = $POINTVAR"
        echo "Invalid argument combination (likely -ao/--alt-only and -dam/--disable-alt-managers). Relaunch script with valid combination."
        if [ "$SAVECONFIRM" = true ] ; then
            SAVESTATINCOMPARGS=true
            INCOMPARGS_DETAIL="Likely -dam / --disable-alt-managers and -ao / --alt-only mixed."
            SaveStats
        else
            exit 1
        fi
    #Error Statement for hybrid mixed errors
    ################
    elif [ "$POINTVAR" = "43" -o "$POINTVAR" = "59" ] ; then
        #echo "POINTVAR = $POINTVAR"
        echo "Multiple invalid argument combinations (likely -ao/--alt-only and -dam/--disable-alt-managers and -cd/--custom-domain and -nt/--no-test). Relaunch script with valid combination."
        echo "Invalid argument combination (likely -ao/--alt-only and -dam/--disable-alt-managers). Relaunch script with valid combination."
        if [ "$SAVECONFIRM" = true ] ; then
            SAVESTATINCOMPARGS=true
            INCOMPARGS_DETAIL="Likely an invalid combination of multiple incompatible arguments [See README for incompatible arguments]"
            SaveStats
        else
            exit 1
        fi
    # Error Statement for all possible functional arguments
    ################
    elif [ "$POINTVAR" = "63" ] ; then
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
}

#  Descriptive (DESCPOINT):
#       -h = 1 [*2]
#       -c = 2 [*2]
#       -w = 4 [*2]
#      -pp = 8
PointDecideDesc () {
    if [ "$DESCPOINT" = "1" ] ; then
        echo 'Descriptive Variables detected:'
        HelpMessage
        exit 0
    elif [ "$DESCPOINT" = "2" ] ; then
        echo 'Descriptive Variables detected:'
        ConditionMessage
        exit 0
    elif [ "$DESCPOINT" = "3" ] ; then
        echo 'Descriptive Variables detected:'
        HelpMessage
        ConditionMessage
        exit 0
    elif [ "$DESCPOINT" = "4" ] ; then
        echo 'Descriptive Variables detected:'
        WarrantyMessage
        exit 0
    elif [ "$DESCPOINT" = "5" ] ; then
        echo 'Descriptive Variables detected:'
        HelpMessage
        WarrantyMessage
        exit
    elif [ "$DESCPOINT" = "6" ] ; then
        echo 'Descriptive Variables detected:'
        WarrantyMessage
        ConditionsMessage
        exit 0
    elif [ "$DESCPOINT" = "7" ] ; then
        echo 'Descriptive Variables detected:'
        HelpMessage
        WarrantyMessage
        ConditionMessage
        exit 0
    elif [ "$DESCPOINT" = "8" ] ; then
        echo 'Descriptive Variables detected:'
        PrivacyPolicyMessage
        exit 0
    elif [ "$DESCPOINT" = "9" ] ; then
        echo 'Descriptive Variables detected:'
        PrivacyPolicyMessage
        HelpMessage
        exit 0
    elif [ "$DESCPOINT" = "10" ] ; then
        echo 'Descriptive Variables detected:'
        PrivacyPolicyMessage
        ConditionsMessage
        exit 0
    elif [ "$DESCPOINT" = "11" ] ; then
        echo 'Descriptive Variables detected:'
        PrivacyPolicyMessage
        HelpMessage
        ConditionsMessage
        exit 0
    elif [ "$DESCPOINT" = "12" ] ; then
        echo 'Descriptive Variables detected:'
        PrivacyPolicyMessage
        WarrantyMessage
        exit 0
    elif [ "$DESCPOINT" = "13" ] ; then
        echo 'Descriptive Variables detected:'
        PrivacyPolicyMessage
        WarrantyMessage
        HelpMessage
        exit 0
    elif [ "$DESCPOINT" = "14" ] ; then
        echo 'Descriptive Variables detected:'
        PrivacyPolicyMessage
        WarrantyMessage
        ConditionsMessage
        exit 0
    elif [ "$DESCPOINT = "15"" ] ; then
        echo 'Descriptive Variables detected:'
        PrivacyPolicyMessage
        WarrantyMessage
        ConditionsMessage
        HelpMessage
        exit 0
    fi
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
    ( echo "= = User-Generated Comments: = =" && echo "$LOGCOMMENTS" && printf "= = = = = = = = = =\n\n" ) >> ./update_full-bash-log/uf-bash-log.txt
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
    for count in {0...7} ; do
        if [ "$FLATPAKFLAG" = true ] ; then
            STATUSFLATPAK="USED"
            FLATPAKFLAG=false
        elif [ "$SNAPFLAG" = true ] ; then
            STATUSSNAP="USED"
            FLATPAKFLAG=false
        elif [ "$PORTSNAPFLAG" = true ] ; then
            STATUSPORTSNAPSNAP="USED"
            PORTSNAPFLAG=false
        elif [ "$BREWFLAG" = true ] ; then
            STATUSBREW="USED"
            BREWFLAG=false
        elif [ "$GEMFLAG" = true ] ; then
            STATUSGEM="USED"
            GEMFLAG=false
        elif [ "$YARNFLAG" = true ] ; then
            STATUSYARN="USED"
            YARNFLAG=false
        elif [ "$NPMFLAG" = true ] ; then
            STATUSNPM="USED"
            YARNFLAG=false
        fi
    done
    # Changes logfile depending on if 
    if [ "$OFFICIALPKGMAN" = "No official package managers used" -a "$ALTPKGMAN" = "No alternative package managers used" ] ; then
        ( echo "No package managers at all detected!" ) >> ./update_full-bash-log/uf-bash-log.txt
        DOEXIT1=true
    else
        ( echo "$OFFICIALPKGMAN" && printf "$ALTPKGMAN\n FLATPAK:  $STATUSFLATPAK\n SNAP:     $STATUSSNAP\n PORTSNAP: $STATUSPORTSNAP\n BREW:     $STATUSBREW\n GEM:      $STATUSGEM\n NPM:      $STATUSNPM\n" ) >> ./update_full-bash-log/uf-bash-log.txt
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
            ( echo "Log generated: $(date)" && printf "\t\n$DESC_ROOT\n" && printf "\nTime took: $TIMETOTAL sec.\n--- Unsuccessful Operation ---\n" ) >> ./update_full-bash-log/uf-bash-log.txt
            SaveStatsComments
            # Ending phrase
            echo "Log Saved..."
            echo "All done!"
            printf "\tI hope this program was useful for you!\n\n"
            printf "\t\e[3mPlease give this project a star on github!\e[0m\n"
            exit 1
        # If ping scan fails
        elif [ "$SAVESTATSNOPING" = true ] ; then
            DESCNOPING="Ping test failed, check domain ($PING_TARGET)"
            ( echo "Log generated: $(date)" && printf "\t\n$DESCNOPING\n" && printf "\nTime took: $TIMETOTAL sec.\n--- Unsuccessful Operation ---\n" ) >> ./update_full-bash-log/uf-bash-log.txt
            SaveStatsComments
            # Ending phrase
            echo "Log Saved..."
            echo "All done!"
            printf "\tI hope this program was useful for you!\n\n"
            printf "\t\e[3mPlease give this project a star on github!\e[0m\n"
            exit 1
        # If duplicate arguments are detcted
        elif [ "$SAVESTATDUPARGS" = true ] ; then
            DESCDUPARGS="Duplicate arguments detected"
            ( echo "Log generated: $(date)" && printf "\t\n$DESCDUPARGS\n" && printf "\nTime took: $TIMETOTAL sec.\n--- Unsuccessful Operation ---\n" ) >> ./update_full-bash-log/uf-bash-log.txt
            SaveStatsComments
            # Ending phrase
            echo "Log Saved..."
            echo "All done!"
            printf "\tI hope this program was useful for you!\n\n"
            printf "\t\e[3mPlease give this project a star on github!\e[0m\n"
            exit 1
        # If too many arguments are detected
        elif [ "$SAVESTATTOOMANYARGS" = true ] ; then
            DESCTOOMANYARGS="Too many arguments detected"
            ( echo "Log generated: $(date)" && printf "\t\n$DESCTOOMANYARGS\n" && printf "\nTime took: $TIMETOTAL sec.\n--- Unsuccessful Operation ---\n" ) >> ./update_full-bash-log/uf-bash-log.txt
            SaveStatsComments
            # Ending phrase
            echo "Log Saved..."
            echo "All done!"
            printf "\tI hope this program was useful for you!\n\n"
            printf "\t\e[3mPlease give this project a star on github!\e[0m\n"
            exit 1
        elif [ "$SAVESTATINCOMPARGS" = true ] ; then
            DESCINCOPARGS="Incompatible arguments detected($INCOMPARGS_DETAIL)"
            ( echo "Log generated $(date)" && printf "\t\n$DESCINCOPARGS\n" && printf "\nTime took: $TIMETOTAL sec.\n--- Unsuccessful Operation ---\n" ) >> ./update_full-bash-log/uf-bash-log.txt
            SaveStatsComments
            # Ending phrase
            echo "Log Saved..."
            echo "All done!"
            printf "\tI hope this program was useful for you!\n\n"
            printf "\t\e[3mPlease give this project a star on github!\e[0m\n"
            exit 1
        # If everything else worked normally
        elif [ "$SAVESTATSNOROOT" = false -a "$SAVESTATSNOPING" = false ] ; then
            SaveStatsPkgLog
            ( echo "Log generated: $(date)" && printf "\t\nScript run$DESC$DESC_LOG\n" && printf "\nTime took: $TIMETOTAL sec.\n--- Successful Operation ---\n" ) >> ./update_full-bash-log/uf-bash-log.txt
            SaveStatsComments
            # Ending phrase
            echo "Log Saved..."
            echo "All done!"
            printf "\tI hope this program was useful for you!\n\n"
            printf "\t\e[3mPlease give this project a star on github!\e[0m\n"
            if [ "$DOEXIT1" ] ; then
                exit 1
            fi
        fi
    else
        echo "All done!"
        printf "\tI hope this program was useful for you!\n\n"
        printf "\t\e[3mPlease give this project a star on github!\e[0m\n"
    fi
}

# Starts counting time
TIMEBEGIN=$(date +%s)
# Main
clear
# Sets up initial variables
# |- Defines argument position
ARGPOS="$1"
# |- Allows incompatible shell prompt to run
RUNPROMPT=true
# |- Sets up point system
# |-- For functional arguments
POINTVAR=0
# |-- For descriptive arguments
DESCPOINT=0
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
    while [ "$RUNPROMPT" = true ] ; do
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
    done
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
if [ "$#" -ne "0" ] ; then
    # Sets up value for looping
    LOOPCOUNT=0
    until [ "$LOOPCOUNT" -eq "$#" ] ; do
        # Starts Loop
        LOOPCOUNT=$(( $LOOPCOUNT + 1 ))
        # Only installs updates from the OSs official package manager
        if [ "$ARGPOS" = "--custom-domain" -o "$ARGPOS" = "-cd" ] ; then
            POINTVAR=$(( $POINTVAR + 1 ))
            INPUTDOMAIN=true
        # Skip connection testing
        elif [ "$ARGPOS" = "--no-test" -o "$ARGPOS" = "-nt" ] ; then
            POINTVAR=$(( $POINTVAR + 2 ))
        # Make decisions of automatically updating or not
        elif [ "$ARGPOS" = "--manual-all" -o "$ARGPOS" = "-ma" ] ; then
            POINTVAR=$(( $POINTVAR + 4 ))
        # Skip alternative package managers
        elif [ "$ARGPOS" = "--disable-alt-managers" -o "$ARGPOS" = "-dam" ] ; then
            POINTVAR=$(( $POINTVAR + 8 ))
        # Uses yum instead of dnf on Red-Hat based Linux distros
        elif [ "$ARGPOS" = "--yum-update" -o "$ARGPOS" = "-yu" ] ; then
            POINTVAR=$(( $POINTVAR + 16 ))
        # Only updates alternative package managers
        elif [ "$ARGPOS" = "--alt-only" -o "$ARGPOS" = "-ao" ] ; then
            POINTVAR=$(( $POINTVAR + 32 ))
        # Display help message
        elif [ "$ARGPOS" = "--help" -o "$ARGPOS" = "-h" ] ; then
            DESCPOINT=$(( $DESCPOINT + 1 ))
        # Display conditions message
        elif [ "$ARGPOS" = "--conditions" -o "$ARGPOS" = "-c" ] ; then
            DESCPOINT=$(( $DESCPOINT + 2 ))
        # Display warranty message
        elif [ "$ARGPOS" = "--warranty" -o "$ARGPOS" = "-w" ] ; then
            DESCPOINT=$(( $DESCPOINT + 4 ))
        # Display privacy policy
        elif [ "$ARGPOS" = "--privacy-policy" -o "$ARGPOS" = "-pp" ] ; then
            DESCPOINT=$(( $DESCPOINT + 8 ))
        # Save stats log
        elif [ "$ARGPOS" = "--save-statistics" -o "$ARGPOS" = "-ss" ] ; then
            SAVECONFIRM=true
            DESC_LOG=" and saving in log"
        # Checks for errors
        else
            echo "Invalid arguments, relaunch script with legitimate arguments."
            exit 1
        fi
        # Changes the position of argument and check for duplicate arguments.
        if [ $LOOPCOUNT -gt 5 ] ; then
            echo "ERROR LOOPCOUNT = $LOOPCOUNT"
            if [ "$SAVECONFIRM" = true ] ; then
                SAVESTATTOOMANYARGS=true
                SaveStats
            else
                exit 1
            fi
        elif [ $LOOPCOUNT -gt 4 ] ; then
            ARGPOS="$6"
            if [ "$6" = "$5" -o "$6" = "$4" -o "$6" = "$3" -o "$6" = "$2" -o "$6" = "$1" ] ; then
                echo "No duplicate arguments, relaunch script with legitimate arguments!"
                if [ "$SAVECONFIRM" = true ] ; then
                    SAVESTATDUPARGS=true
                    SaveStats
                else
                    exit 1
                fi
            fi
        elif [ $LOOPCOUNT -gt 3 ] ; then
            ARGPOS="$5"
            if [ "$5" = "$4" -o "$5" = "$3" -o "$5" = "$2" -o "$5" = "$1" ] ; then
                echo "No duplicate arguments, relaunch script with legitimate arguments!"
                if [ "$SAVECONFIRM" = true ] ; then
                    SAVESTATDUPARGS=true
                    SaveStats
                else
                    exit 1
                fi
            fi
        elif [ $LOOPCOUNT -gt 2 ] ; then
            ARGPOS="$4"
            if [ "$4" = "$3" -o "$4" = "$2" -o "$4" = "$1" ] ; then
                echo "No duplicate arguments, relaunch script with legitimate arguments!"
                if [ "$SAVECONFIRM" = true ] ; then
                    SAVESTATDUPARGS=true
                    SaveStats
                else
                    exit 1
                fi
            fi
        elif [ $LOOPCOUNT -gt 1 ] ; then
            ARGPOS="$3"
            if [ "$3" = "$2" -o "$3" = "$1" ] ; then
                echo "No duplicate arguments, relaunch script with legitimate arguments!"
                if [ "$SAVECONFIRM" = true ] ; then
                    SAVESTATDUPARGS=true
                    SaveStats
                else
                    exit 1
                fi
            fi
        elif [ $LOOPCOUNT -gt 0 ] ; then
            ARGPOS="$2"
            if [ "$2" = "$1" ] ; then
                echo "No duplicate arguments, relaunch script with legitimate arguments!"
                if [ "$SAVECONFIRM" = true ] ; then
                    SAVESTATDUPARGS=true
                    SaveStats
                else
                    exit 1
                fi
            fi
        fi
    done
fi
# If there was no descriptive argument point, use the functional arguments
if [ "$DESCPOINT" -gt "0" ] ; then
    PointDecideDesc
else
    PointDecideFunc
fi
printf "Running \e[4mUpdate_Full [GENERIC UNIX]\e[01;m script\e[1m$DESC$DESC_LOG"
printf "\e[0m:\nDate and Time is:\n\t$(date)\n"
# Begins the package manager checker function
CHECK_PKG=true
CheckPkgAuto
SaveStats

# Update_full-unix.sh  Copyright (C) 2023  Mikhail Patricio Ortiz-Lunyov
#   This program comes with ABSOLUTELY NO WARRANTY; for details add argument `-w' or `--warranty'.
#   This is free software, and you are welcome to redistribute it
#   under certain conditions; add argument `-c' or `--conditions' for details.
