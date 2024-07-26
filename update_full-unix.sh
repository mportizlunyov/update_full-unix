# Written by Mikhail P. Ortiz-Lunyov (mportizlunyov)
#
# Version 2.0.0 (July 25th, 2024)
#
# This script is licensed under the GNU Public License Version 3 (GPLv3).
# Compatible and tested with BASH, SH, KSH, ASH, DASH and ZSH[Not Working].
#
#
# Not compatible with CSH, TCSH, or Powershell.
# More information about license in README and bottom.
# Best practice is to limit writing permissions to this script in
#  order to avoid accidental or malicious tampering.
# Checking the hashes from the github can help to check for tampering.

# Critical variables
## Version variables
VERSION_NUMB="2.0.0"
VERSION_NAME="July 25th, 2024"
VERSION_NAME_FULL="v$VERSION_NUMB ($VERSION_NAME)"
## Dependencies
DEPENDENCY_LIST="ping curl wget"
CHECKSUM_CHECKER_PATH="00_CHECKSUM_CHECKER.sh"
## Package managers
## Names are appended to strings, since arrays are not POSIX compliant
### Official
OFFICIAL_PKG_MAN="apt yum"
OFFICIAL_PLG_MAN="$OFFICIAL_PKG_MAN transactional-update"
OFFICIAL_PKG_MAN="$OFFICIAL_PLG_MAN dnf rpm-ostree"
OFFICIAL_PKG_MAN="$OFFICIAL_PLG_MAN pacman apk"
OFFICIAL_PKG_MAN="$OFFICIAL_PLG_MAN zypper pacman"
OFFICIAL_PKG_MAN="$OFFICIAL_PLG_MAN xbps swupd"
OFFICIAL_PKG_MAN="$OFFICIAL_PLG_MAN slackpkg eopkg"
OFFICIAL_PKG_MAN="$OFFICIAL_PLG_MAN pkg pkg_add"
### Alternative
ALTERNATIVE_PKG_MAN="$ALTERNATIVE_PKG_MAN flatpak snapd"
ALTERNATIVE_PKG_MAN="$ALTERNATIVE_PKG_MAN brew portsnap"
ALTERNATIVE_PKG_MAN="$ALTERNATIVE_PKG_MAN rubygem yarn"
ALTERNATIVE_PKG_MAN="$ALTERNATIVE_PKG_MAN pipx npm"
### Ambiguous
AMBIGUOUS_PKG_MAN="$AMBIGUOUS_PKG_MAN nix guix"
### Split string
IFS=" "


# Prints Exit Statement
ExitStatement () {
  printf "\t* I hope this program was useful for you!\n\n"
  printf "\t\e[3m* Please give this project a star on github!\e[0m\n"
}

# Deals with errors in an organized fashion
AllErrorsMethod () {
  # Initialise error code
  ERROR_CODE=1
  # Deal with value of $1
  case "$1" in
    # Missing dependencies
    "0")
      echo "!!Dependency for Checksum-Checker NOT FOUND!!"
      echo "!!Missing: $2"
      ;;
    # Curl failed, even with --insecure
    "1")
      echo "!!CURL with --insecure flag failed!"
      echo "!!Check connection to internet"
      ;;
    # Raw Curl failed, refused --insecure flag
    "2")
      echo "!!Understood, QUITting"
      echo "!!Please diagnose Curl not working"
      ERROR_CODE=2
      ;;
    # Wget failed
    "3")
      echo "!!WGET failed!"
      echo "!!Check connection to internet"
      ;;
    # Checksum-Checker script Failed
    "4")
      echo "!!Checksum-Checker script FAILED!"
      echo "!!Investigate the script's checksums"
      ;;
    # Official package manager NOT found
    "5")
      echo "!!OFFICIAL package manager NOT Found"
      echo "!!Please check package manager compatibility"
      ;;
    # Alternative package manager NOT found, forced --alt-only
    "6")
      echo "!!ALTERNATIVE package manager NOT found with --alt-only"
      echo "!!Please check package manager compatibility"
      ;;
    "7"|"8"|"10")
      echo "!!Argument [ $2 ] NOT RECOGNISED"
      printf "* Try \e[1m--help\e[0m or \e[1m-h\e[0m?\n"
      ;;
    "9")
      echo "!!Modifier [ $3 ] does not match argument [ $2 ]"
      printf "* Try \e[1m--help\e[0m or \e[1m-h\e[0m?\n"
      ;;
    # Missing Root
    "11")
      # Specific reason
      case "$2" in
        "MISSING_TOOL") printf "\t\e[3;5m!!Neither sudo nor doas detected!\e[0m\n" ;;
        "NO_PERMS") printf "\t\e[3;5m!!User $(whoami) has no root privileges!\e[0m\n" ;;
      esac
      echo "!!Root missing, check user permissions"
      printf "\n\tUpdate_Full is intended for SysAdmins to fully (or partially)\n\tupdate different systems.\n"
      ;;
    # ChecksumCheck method failed
    "12")
      echo "* Investigate what is going in!"
      ;;
    # Missing error code
    *) ERROR_CODE=44 ;; # Reference to HTTP error 404
  esac
  # Run exit statements
  ExitStatement
  # Return number
  echo $ERROR_CODE
}

# Verifies existance of programs
ExistanceCheck () {
  # Execute program, hiding output
  $1 $2 > /dev/null 2>&1
  echo "$?"
}

# Checks for CURL/WGET dependency
DependencyTest () {
  for i in $DEPENDENCY_LIST ; do
    case "$(ExistanceCheck "$i" "--help")" in
      "127")
        echo "$i missing"
        case "$i" in
          "ping"|"wget") AllErrorsMethod "0" $i ; exit $? ;;
        esac
        ;;
      *)
        echo "* $i found, resuming"
        case "$i" in
          "curl"|"wget") TOOLUSE=$i ; break ;;
        esac
        ;;
    esac
  done
}

# Extracts the Checksum-Checker and runs it
ChecksumCheck () {
  # Declare local variables
  local CURL_INSECURE=false
  # Decide which tools to use to extract the Checksum-checker
  case $1 in
    "curl")
      # By default, attempt to use secure CURL requests
      $ROOTUSE curl --silent --remote-name https://raw.githubusercontent.com/mportizlunyov/uf-CHECKSUM_STORAGE/main/Update_Full-UNIX/$CHECKSUM_CHECKER_PATH || {
        # If it fails, ask to use --insecure option of not
        while [ "$LOOP_INPUT" = "true" ] ; do
          printf "!!CURL did not work, try again with --insecure option?\n!RISKY, check what is going on!\n\n[Y]es/[N]o"
          read INSECURE_OPTION
          case $INSECURE_OPTION in
            "Y"|"y"|"Yes"|"yes")
              LOOP_INPUT=false
              printf "* Understood, retrying with --insecure option"
              CURL_INSECURE=true
              $ROOTUSE curl --remote-name --insecure https://raw.githubusercontent.com/mportizlunyov/uf-CHECKSUM_STORAGE/main/Update_Full-UNIX/$CHECKSUM_CHECKER_PATH || {
                # If CURL fails again, QUIT
                AllErrorsMethod "1"
                exit $?
              }
              ;;
            "N"|"n"|"No"|"no")
              LOOP_INPUT=false
              printf "!!Understood, quitting. Please diagnose the problem!!\n"
              AllErrorsMethod "2"
              exit $?
              ;;
            *) printf "Please select one of the two options. Otherwise, quit and re-leanch the script.\n\n" ;;
          esac
        done
      }
      ;;
    "wget")
      $ROOTUSE wget --quiet https://raw.githubusercontent.com/mportizlunyov/uf-CHECKSUM_STORAGE/main/Update_Full-UNIX/$CHECKSUM_CHECKER_PATH || {
        AllErrorsMethod "3"
        exit $?
      }
      ;;
    *)
      printf "\t!!! INTERNAL PROGRAM ERROR !!!"
      echo "Tool is [ $1 ]"
      exit 1
      ;;
  esac
  $ROOTUSE $SHELL ./$CHECKSUM_CHECKER_PATH $VERSION_NUMB $TOOLUSE $CURL_INSECURE
  if [ "$?" = "1" ] ; then
    echo "Checksum-Checker FAILED! Investigate!!"
    case "$RISKYOPERATION" in
      "true")
        echo "!!!Running despite Checksum-Checker FAILING!!!"
        WarrantyMessage
        ;;
      *)
        printf "Check what is going on!\n"
        $ROOTUSE rm ./$CHECKSUM_CHECKER_PATH
        AllErrorsMethod "4"
        exit $?
        ;;
    esac
  fi
  $ROOTUSE rm ./$CHECKSUM_CHECKER_PATH
}

# Tests internet connectivity using PING
NetworkTest () {
  ping -q -c 3 $1 || {
    # Define error message based on domain
    case "$1" in
      "raw.githubusercontent.com")
        printf "\e[1;1m\e[1;40m--\e[1;31mx\e[1;0m\e[1;1m\e[1;40m-->\e[1;0m "
        echo "!!No Connection to checksum repository, diagnose the problem and relaunch script."
        ;;
      *)
        echo "* Performing network connectivity test using ($PING_TARGET):"
        echo "=-=-=-=-="
        printf "\e[1;1m\e[1;40m--\e[1;31mx\e[1;0m\e[1;1m\e[1;40m-->\e[1;0m "
        echo "!!No Connection to CUSTOM URL, diagnose the problem and relaunch script in event of failure."
        ;;
    esac
    EXIT1=true
  }
}

# For Debian/Ubuntu-based operating systems
AptUpdate () {
  APTFLAG=true
  printf "\n\t* \e[1mAPT detected under $DISTRO_NAME!\e[0m\n"
  $ROOTUSE apt-get update
  $ROOTUSE apt-get $APT_UPGRADE $MANQ
  $ROOTUSE apt-get -f install $MANQ
  $ROOTUSE apt-get autoremove $MANQ
  $ROOTUSE apt-get autoclean $MANQ
}

# For Red-Hat based Linux Operating Systems
RedHatUpdate (){
  printf "\n\t* \e[1mRED HAT ($1) detected under $DISTRO_NAME!\e[0m\n"
  case $1 in
    # For YUM (legacy)
    "YUM")
      YUMFLAG=true
      $ROOTUSE yum check-update $MANQ
      $ROOTUSE yum update $MANQ
      $ROOTUSE yum autoremove $MANQ
      ;;
    # For DNF (modern)
    "DNF")
      DNFFLAG=true
      $ROOTUSE dnf check-update $MANQ
      $ROOTUSE dnf update $MANQ
      $ROOTUSE dnf autoremove $MANQ_DEB1
      ;;
    # For RPM-OSTREE (found in Fedora SilverBlue, Kinoite, and CoreOS)
    "RPM-OSTREE")
      OSTREEFLAG=true
      rpm-ostree cancel
      rpm-ostree upgrade --check
      rpm-ostree upgrade
      ;;
  esac
}

# For Slackware Linux-based operating systems
SlackpkgUpdate () {
  if [ "$MANUAL_ALL" != "true" ] ; then
    MANQ="-batch=on -default_answer=y"
  fi
  SLACKFLAG=true
  printf "\n\t* \e[1mSLACKWARE detected!\e[0m\n"
  $ROOTUSE slackpkg $MANQ update
  $ROOTUSE slackpkg $MANQ install-new
  $ROOTUSE slackpkg $MANQ upgrade-all
  $ROOTUSE slackpkg $MANQ clean-system
}

# For Solus Linux-based operating systems
EopkgUpdate () {
  EOPKGFLAG=true
  printf "\n\t* \e[1mSOLUS detected!\e[0m\n"
  $ROOTUSE eopkg update-repo
  $ROOTUSE eopkg upgrade $MANQ
}

# For Flatpaks
FlatpakUpdate () {
  FLATPAKFLAG=true
  printf "\n\t* \e[1mFLATPAK detected under $DISTRO_NAME!\e[0m\n"
  flatpak update $MANQ
  flatpak uninstall --unused $MANQ
}

# For Snaps
SnapUpdate () {
  SNAPFLAG=true
  printf "\n\t* \e[1mSNAP detected under $DISTRO_NAME!\e[0m\n"
  snap refresh
}

# For Clear Linux
SwupdUpdate () {
  SWUPDFLAG=true
  printf "\n\t* \e[1mCLEAR LINUX detected!\e[0m\n"
  echo "By default, Clear Linux automatically updates its packages. You may need to disable auto-update."
  $ROOTUSE swupd check-update $MANQ
  $ROOTUSE swupd update $MANQ
}

# For Alpine Linux
ApkUpdate () {
  APKFLAG=true
  printf "\n\t* \e[1mALPINE LINUX detected!\e[0m\n"
  $ROOTUSE apk update
  $ROOTUSE apk upgrade
  $ROOTUSE apk fix
}

# For Arch Linux
PacmanUpdate () {
  PACMANFLAG=true
  printf "\n\t* \e[1mPACMAN detected under $DISTRO_NAME!\e[0m\n"
  case "$MANUAL_ALL" in
    "false") yes | $ROOTUSE pacman -Syu ;;
    "true") $ROOTUSE pacman -Syu ;;
  esac
}

# For OpenSUSE Linux
OpenSuseUpdate () {
  printf "\n\t* \e[1mOpenSUSE ($1) detected under $DISTRO_NAME!\e[0m\n"
  case $1 in
    # For OpenSUSE Tumbleweed and LEAP
    "ZYPPER")
      ZYPPERFLAG=true
      $ROOTUSE zypper list-updates
      $ROOTUSE zypper patch-check
      $ROOTUSE zypper $SUSE_UPGRADE $MANQ
      $ROOTUSE zypper patch $MANQ
      $ROOTUSE zypper purge-kernels
      ;;
    # For MicroOS
    "TRANSACTIONAL-UPDATE")
      TRANUPDATEFLAG=true
      $ROOTUSE transactional-update $SUSE_UPGRADE
      $ROOTUSE transactional-update patch
      ;;
  esac
}

# For Nix OS Linux
NixUpdate () {
  NIXFLAG=true
  printf "\n\t* \e[1mNIX PACKAGE MANAGER detected under $DISTRO_NAME!\e[0m\n"
  $ROOTUSE nix-channel --update
  $ROOTUSE nix-env -u '*'
  $ROOTUSE nix-env --delete-generations old
  $ROOTUSE nix-collect-garbage
}

# For FreeBSD-based operating systems
PkgUpdate () {
  PKGFLAG=true
  printf "\n\t* \e[1mFREEBSD detected!\e[0m\n"
  $ROOTUSE pkg update
  $ROOTUSE pkg upgrade $MANQ
  $ROOTUSE pkg autoremove $MANQ
  $ROOTUSE pkg clean
  $ROOTUSE pkg audit -F
}

# For OpenBSD
Pkg_addUpdate () {
  PKG_ADDFLAG=true
  printf "\n\t* \e[1mOPENBSD detected!\e[0m\n"
  $ROOTUSE pkg_add -Uuvm
  $ROOTUSE syspatch
}

# For Portsnaps
PortsnapUpdate () {
  PORTSNAPFLAG=true
  printf "\n\t* \e[1mPORTSNAP detected under $DISTRO_NAME!\e[0m\n"
  $ROOTUSE portsnap auto
}

# For Homebrew
BrewUpdate () {
  BREWFLAG=true
  printf "\n\t* \e[1mHOMEBREW detected under $DISTRO_NAME!!\e[0m\n"
  $ROOTUSE brew update
  $ROOTUSE brew upgrade -v
  $ROOTUSE brew cleanup -v
}

# For Void Linux
XbpsUpdate () {
  XBPSFLAG=true
  printf "\n\t* \e[1mVOID LINUX detected!\e[0m\n"
  $ROOTUSE xbps-install -u xbps
  $ROOTUSE xbps-install -Su
}

# For RubyGems
GemUpdate () {
  GEMFLAG=true
  printf "\n\t* \e[1mRUBYGEM detected under $DISTRO_NAME!\e[0m\n"
  $ROOTUSE gem update
  $ROOTUSE gem cleanup
}

# For Node.Js Package Manager
NpmUpdate () {
  NPMFLAG=true
  printf "\n\t* \e[1mNODE.JS PACKAGE MANAGER detected under $DISTRO_NAME!\e[0m\n"
  $ROOTUSE npm update
}

# For Yarn Package Manager
YarnUpdate () {
  YARNFLAG=true
  printf "\n\t* \e[1mYARN detected under $DISTRO_NAME!\e[0m\n"
  $ROOTUSE yarn upgrade
  $ROOTUSE yarn install
}

# For Pip and subsequent Versions
PipxUpdate () {
  PIPxFLAG=true
  printf "\n\t* \e[1mPIPx detected under $DISTRO_NAME!\e[0m\n"
  # Will Make version for pip3 and pip2 (for legacy support), Pipx for now
  pipx upgrade-all
}

# For Guix Package Manager
GuixUpdate() {
  GUIXFLAG=true
  printf "\n\t* \e[1mGuix detected under $DISTRO_NAME!\e[0m\n"
  $ROOTUSE guix pull
  $ROOTUSE guix upgrade
}

# Check official package managers
CheckOfficialPkgMan () {
  # Iterate through OFFICIAL_PKG_MAN array
  for i in $OFFICIAL_PKG_MAN ; do
    case "$(ExistanceCheck "$i" "--help")" in
      "127") ;; # Skip package manager
      *)
        case "$i" in
          "apt") AptUpdate ; return ;;
          "yum")
            case "$YUM_UPDATE" in
              "true") RedHatUpdate "YUM" ; return ;;
            esac
            ;;
          "transactional-update") OpenSuseUpdate "TRANSACTIONAL-UPDATE" ; return ;;
          "dnf") RedHatUpdate "DNF" ; return ;;
          "rpm-ostree") RedHatUpdate "RPM_OSTREE" ; return ;;
          "pacman") PacmanUpdate ; return ;;
          "apk") ApkUpdate ; return ;;
          "zypper") OpenSuseUpdate "ZYPPER" ; return ;;
          "pacman") PacmanUpdate ; return ;;
          "xbps") XbpsUpdate ; return ;;
          "swupd") SwupdUpdate ; return ;;
          "slackpkg") SlackpkgUpdate ; return ;;
          "eopkg") EopkgUpdate ; return ;;
          "pkg") PkgUpdate ; return ;;
          "pkg_add") Pkg_addUpdate ; return ;;
        esac
        # Exit with error if no Official Package manager is found
        AllErrorsMethod "5"
        exit $?
        ;;
    esac
  done
}

# Check alternative package managers
CheckAlternativePkgMan () {
  # Initialise local method variable
  local PKG_RAN=false
  for i in $ALTERNATIVE_PKG_MAN ; do
    case "$(ExistanceCheck "$i" "--help")" in
      "127") ;; # Skip package manager
      *)
        case "$i" in
          "flatpak") FlatpakUpdate ; PKG_RAN=true ;;
          "snapd") SnapUpdate ; PKG_RAN=true ;;
          "brew") BrewUpdate ; PKG_RAN=true ;;
          "portsnap") PortsnapUpdate ; PKG_RAN=true ;;
          "rubygem") GemUpdate ; PKG_RAN=true ;;
          "yarn") YarnUpdate ; PKG_RAN=true ;;
          "pipx") PipxUpdate ; PKG_RAN=true ;;
          "npm") NpmUpdate ; PKG_RAN=true ;;
        esac
        ;;
    esac
  done
  # If no alternative package managers are run,
  #  and the --alt-only flag is run, exit in an error
  if [ "$PKG_MAN" = "false" ] && [ "$ALTONLY" = "true" ] ; then
    AllErrorsMethod "6"
    exit $?
  fi
}

 # Prints a Help message
 HelpMessage () {
  echo ' = = ='
  echo 'This bash script allows for a full update on most UNIX systems, on most package managers.'
  # Explain two types of arguments for script
  printf "This script uses three types of arguments: \e[1mFunctional (changes how the script works)\e[0m, \e[1mModifiers (modifies aspects of a functional argument)\e[0m, and \e[1mDescriptive (gives information about the script)\e[0m.\n"
  # Begin Functional arguments
  printf "\nFunctional arguments:\n"
  printf "\e[1m--override-checksum / -oc\e[0m\t Overrides any warning of mis-matching latest checksums\n"
  printf "\t!!! Dangerous, could mean OUTDATED or otherwise MODIFIED script (INTENTIONALLY or MALICIOUSLY) !!!\n"
  printf "\e[1m--custom-domain / -cd\e[0m\t Use a custom domain (manual input by default)\n"
  printf "\t^Modifier available\n"
  printf "\e[1m--yum-update / -yu\e[0m\t Use YUM instead of DNF on Red-Hat\n"
  printf "\t*Not compatible with \e[1m-ao\e[0m\n"
  printf "\e[1m--official-only / -oo\e[0m\t Skip alternative package managers\n"
  printf "\t*Not compatible with \e[1m-ao\e[0m\n"
  printf "\e[1m--alt-only / -ao\e[0m\t Skip native package managers\n"
  printf "\t*Not compatible with \e[1m-oo\e[0m\n"
  printf "\e[1m--custom-log-path / -clp\e[0m\t Define a custom PATH for the log-file\n"
  printf "\t*Must be run with \e[1m-ss\e[0m\n"
  printf "\t^Modifier available\n"
  printf "\e[1m--manual-all / -ma\e[0m\t Leaves package manager prompts unanswered, and asks for custom domain and log file PATH is not preloaded\n"
  printf "\t*Will make script unable to be run in a cronjob\n"
  printf "\e[1m--save-statistics / -ss\e[0m\t Save a log file (and add comments!)\n"
  printf "\t^Modifier available\n"
  # Begin Modifiers
  printf "\nModifiers:\n"
  printf "\e[1m:<DOMAIN>\e[0m\t\t Preload custom domain for \e[1m-cd\e[0m\n"
  printf "\e[1m:no-comment / :nc\e[0m\t Skip commenting for \e[1m-ss\e[0m\n"
  printf "\e[1m:<LOG FILE PATH>\e[0m\t Defines custom PATH for log-file for \e[1m-clp\e[0m\n"
  # Begin Descriptive arguments
  printf "\nDescriptive arguments:\n"
  printf "\e[1m--help / -h \t\e[0m\t Print Help statement\n"
  printf "\e[1m--conditions / -c\e[0m\t Print Conditions of redistribution\n"
  printf "\e[1m--warrenty / -w \e[0m\t Print Warranty\n"
  printf "\e[1m--privacy-policy / -pp\e[0m\t Print Privacy Policy\n"
  # Begin Security Advisories
  printf "\n\nTo prevent tempering, change the PERMISSIONS."
  printf "\nThis can easily be done by launching the \e[1muf-first-setup.sh\e[0m script that comes in the repository."
  printf "\nIf you do not end up using it DELETE IT. Otherwise, it will delete itself after first usage."
  printf "\n\nAdditionally, verify the script using the checksums found at https://github.com/mportizlunyov/uf-CHECKSUM_STORAGE\n\n"
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
  case $NOCOMMENT in
    "true") $ROOTUSE $SHELL -c '( echo "!= = NO COMMENTS = =!" ) >> $(cat ./tempfile_LOGFILEPATH)' ;;
    *)
      printf "\n\n\e[1m* Type in the letters \"~esc~\" to exit the comments bar\n= = =\n"
      COMMENTINPUT=""
      # Loops until user types in 'esc'
      until [ "$COMMENTINPUT" = "~esc~" ] ; do
        ( echo "$COMMENTINPUT" ) >> ./tempfile_COMMENTS
        printf "* \e[0mTYPE:\e[1m "
        read COMMENTINPUT
      done
      printf "= = =\n\e[0m"
      case $tempfileISSUEFLAG in
        "true")
          LOGCOMMENTS="!!tempfile PREMATURELY DELETED, USER COMMENTS NOT SAVED!!"
          ( echo "$LOGCOMMENTS" ) > ./tempfile_COMMENTS
          ;;
        *)
          LOGCOMMENTS="$(sed '1d' ./tempfile_COMMENTS)"
          ( echo "$LOGCOMMENTS" ) > ./tempfile_COMMENTS
          if [ "$LOGCOMMENTS" = "" ] ; then
            LOGCOMMENTS="* No comments by user*"
            ( echo "$LOGCOMMENTS" ) > ./tempfile_COMMENTS
          fi
          ;;
      esac
      $ROOTUSE $SHELL -c '( echo "User-Generated Comments: = =" && echo "$(cat ./tempfile_COMMENTS)" && echo "= = = = = = = = = =" ) >> $(cat ./tempfile_LOGFILEPATH)'
      $ROOTUSE rm ./tempfile_COMMENTS > /dev/null 2>&1
      ;;
  esac
}

# This function records and sets up the package managers used by the script for the save-statistics argument.
SaveStatsPkgLog () {
  # Begins to prepare adding the used package managers in log
  OFFICIALPKGMAN="No official package managers used"
  ( echo "$OFFICIALPKGMAN" ) > ./tempfile_OFFICIALPKG
  ALTPKGMAN="No alternative package managers used"
  ( echo "$ALTPKGMAN" ) > ./tempfile_ALTPKG
  STATUSFLATPAK="NOT USED"
  ( echo "$STATUSFLATPAK" ) > ./tempfile_FLATPAK
  STATUSSNAP="NOT USED"
  ( echo "$STATUSSNAP" ) > ./tempfile_SNAP
  STATUSPORTSNAP="NOT USED"
  ( echo "$STATUSPORTSNAP" ) > ./tempfile_PORTSNAP
  STATUSBREW="NOT USED"
  ( echo "$STATUSBREW" ) > ./tempfile_BREW
  STATUSGEM="NOT USED"
  ( echo "$STATUSGEM" ) > ./tempfile_GEM
  STATUSYARN="NOT USED"
  ( echo "$STATUSYARN" ) > ./tempfile_YARN
  STATUSNPM="NOT USED"
  ( echo "$STATUSNPM" ) > ./tempfile_NPM
  STATUSPIPx="NOT USED"
  ( echo "$STATUSPIPx" ) > ./tempfile_PIPx
  # For official Package Managers
  if [ "$APTFLAG" = true ] ; then
    OFFICIALPKGMAN="APT package manager used."
    ( echo "$OFFICIALPKGMAN" ) > ./tempfile_OFFICIALPKG
  elif [ "$PACMANFLAG" = true ] ; then
    OFFICIALPKGMAN="PACMAN package manager used."
    ( echo "$OFFICIALPKGMAN" ) > ./tempfile_OFFICIALPKG
  elif [ "$DNFFLAG" = true ] ; then
    OFFICIALPKGMAN="DNF package manager used."
    ( echo "$OFFICIALPKGMAN" ) > ./tempfile_OFFICIALPKG
  elif [ "$YUMFLAG" = true ] ; then
    OFFICIALPKGMAN="YUM package manager used."
    ( echo "$OFFICIALPKGMAN" ) > ./tempfile_OFFICIALPKG
  elif [ "$SWUPDFLAG" = true ] ; then
    OFFICIALPKGMAN="SWUPD package manager used."
    ( echo "$OFFICIALPKGMAN" ) > ./tempfile_OFFICIALPKG
  elif [ "$APKFLAG" = true ] ; then
    OFFICIALPKGMAN="APK package manager used."
    ( echo "$OFFICIALPKGMAN" ) > ./tempfile_OFFICIALPKG
  elif [ "$GUIXFLAG" = true ] ; then
    OFFICIALPKGMAN="GUIX package manager used."
    ( echo "$OFFICIALPKGMAN" ) > ./tempfile_OFFICIALPKG
  elif [ "$ZYPPERFLAG" = true ] ; then
    OFFICIALPKGMAN="ZYPPER package manager used."
    ( echo "$OFFICIALPKGMAN" ) > ./tempfile_OFFICIALPKG
  elif [ "$NIXFLAG" = true ] ; then
    OFFICIALPKGMAN="NIX package manager used."
    ( echo "$OFFICIALPKGMAN" ) > ./tempfile_OFFICIALPKG
  elif [ "$PKGFLAG" = true ] ; then
    OFFICIALPKGMAN="PKG package manager used."
    ( echo "$OFFICIALPKGMAN" ) > ./tempfile_OFFICIALPKG
  elif [ "$PKG_ADDFLAG" = true ] ; then
    OFFICIALPKGMAN="PKG_ADD package manager used."
    ( echo "$OFFICIALPKGMAN" ) > ./tempfile_OFFICIALPKG
  elif [ "$XBPSFLAG" = true ] ; then
    OFFICIALPKGMAN="XBPS package manager used."
    ( echo "$OFFICIALPKGMAN" ) > ./tempfile_OFFICIALPKG
  elif [ "$SLACKFLAG" = true ] ; then
    OFFICIALPKGMAN="Slackware package manager used."
    ( echo "$OFFICIALPKGMAN" ) > ./tempfile_OFFICIALPKG
  elif [ "$EOPKGFLAG" = true ] ; then
    OFFICIALPKGMAN="Eopkg package manager used."
    ( echo "$OFFICIALPKGMAN" ) > ./tempfile_OFFICIALPKG
  elif [ "$OSTREEFLAG" = true ] ; then
    OFFICIALPKGMAN="RPM-Ostree package manager used."
    ( echo "$OFFICIALPKGMAN" ) > ./tempfile_OFFICIALPKG
  elif [ "$TRANUPDATEFLAG" = true ] ; then
    OFFICIALPKGMAN="Transactional-Update package manager used."
    ( echo "$OFFICIALPKGMAN" ) > ./tempfile_OFFICIALPKG
  fi
  # Changes variable ALTPKGMAN as nessesary
  if [ "$FLATPAKFLAG" = true -o "$SNAPFLAG" = true -o "$PORTSNAPFLAG" = true -o "$BREWFLAG" = true -o "$GEMFLAG" = true -o "$YARNFLAG" = true -o "$NPMFLAG" = true -o "$PIPxFLAG" = true ] ; then
    ALTPKGMAN="Alternative package managers used"
    ( echo "$ALTPKGMAN" ) > ./tempfile_ALTPKG
  fi
  # For alternative package managers
  if [ "$FLATPAKFLAG" = true ] ; then
    STATUSFLATPAK="USED"
    ( echo "$STATUSFLATPAK" ) > ./tempfile_FLATPAK
    FLATPAKFLAG=false
  fi
  if [ "$SNAPFLAG" = true ] ; then
    STATUSSNAP="USED"
    ( echo "$STATUSSNAP" ) > ./tempfile_SNAP
    FLATPAKFLAG=false
  fi
  if [ "$PORTSNAPFLAG" = true ] ; then
    STATUSPORTSNAPSNAP="USED"
    ( echo "$STATUSPORTSNAP" ) > ./tempfile_PORTSNAP
    PORTSNAPFLAG=false
  fi
  if [ "$BREWFLAG" = true ] ; then
    STATUSBREW="USED"
    ( echo "$STATUSBREW" ) > ./tempfile_BREW
    BREWFLAG=false
  fi
  if [ "$GEMFLAG" = true ] ; then
    STATUSGEM="USED"
    ( echo "$STATUSGEM" ) > ./tempfile_GEM
    GEMFLAG=false
  fi
  if [ "$YARNFLAG" = true ] ; then
    STATUSYARN="USED"
    ( echo "$STATUSYARN" ) > ./tempfile_YARN
    YARNFLAG=false
  fi
  if [ "$NPMFLAG" = true ] ; then
    STATUSNPM="USED"
    ( echo "$STATUSNPM" ) > ./tempfile_NPM
    NPMFLAG=false
  fi
  if [ "$PIPxFLAG" = true ] ; then
    STATUSPIPx="USED"
    ( echo "$STATUSPIPx" ) > ./tempfile_PIPx
    PIPxFLAG=false
  fi
  # Changes logfile depending on if 
  if [ "$OFFICIALPKGMAN" = "No official package managers used" -a "$ALTPKGMAN" = "No alternative package managers used" ] ; then
    $ROOTUSE $SHELL -c '( echo "No package managers at all detected!" ) >> $(cat ./tempfile_LOGFILEPATH)'
  else
    $ROOTUSE $SHELL -c '( echo "$(cat ./tempfile_OFFICIALPKG)" && printf "$(cat ./tempfile_ALTPKG)\n FLATPAK:  $(cat ./tempfile_FLATPAK)\n SNAP:   $(cat ./tempfile_SNAP)\n PORTSNAP: $(cat ./tempfile_PORTSNAP)\n BREW:   $(cat ./tempfile_BREW)\n GEM:    $(cat ./tempfile_GEM)\n NPM:    $(cat ./tempfile_NPM)\n PIPx:   $(cat ./tempfile_PIPx)\n" ) >> $(cat ./tempfile_LOGFILEPATH)'
    # Removes unneeded tempfiles
    $ROOTUSE rm ./tempfile_OFFICIALPKG > /dev/null 2>&1
    $ROOTUSE rm ./tempfile_ALTPKG > /dev/null 2>&1
    $ROOTUSE rm ./tempfile_FLATPAK > /dev/null 2>&1
    $ROOTUSE rm ./tempfile_SNAP > /dev/null 2>&1
    $ROOTUSE rm ./tempfile_PORTSNAP > /dev/null 2>&1
    $ROOTUSE rm ./tempfile_BREW > /dev/null 2>&1
    $ROOTUSE rm ./tempfile_GEM > /dev/null 2>&1
    $ROOTUSE rm ./tempfile_YARN > /dev/null 2>&1
    $ROOTUSE rm ./tempfile_NPM > /dev/null 2>&1
    $ROOTUSE rm ./tempfile_PIPx > /dev/null 2>&1
  fi
}

# This function sets up the Save Statistics action
SaveStats () {
  if [ "$LOG_DIR_PATH" != "" ] ; then
    LOGFILEPATH="$LOG_DIR_PATH"
  else
    #LOGFILEPATH="$($ROOTUSE find $(pwd) -type d -name "update_full-unix")"
    LOGFILEPATH="$(pwd)"
  fi
  #LOG_FILE="$LOGFILEPATH/uf-unix-log.txt"
  ( echo "$LOGFILEPATH/uf-unix-log.txt" ) > ./tempfile_LOGFILEPATH
  # Checks if save-stat is enabled
  if [ "$SAVECONFIRM" = true ] ; then
    # Ends counting time
    TIMEEND=$(date +%s)
    TIMETOTAL=$(( $TIMEEND - $TIMEBEGIN ))
    ( echo "$TIMETOTAL" ) > ./tempfile_TIME
    # If ping scan fails
    if [ "$SAVESTATSNOPING" = "true" ] ; then
      DESCNOPING="Ping test failed, check domain ($PING_TARGET)"
      ( echo "$DESCNOPING" ) > ./tempfile_DESCNOPING
      $ROOTUSE $SHELL -c '( echo "--- Failed Operation ---\\" && printf "Generated $(date)\nTime took: $(cat ./tempfile_TIME) sec.\n\n$(cat tempfile_DESCNOPING))\n\n" ) >> $(cat ./tempfile_LOGFILEPATH)'
      SaveStatsComments
      $ROOTUSE $SHELL -c '( printf "Version 2.0.0 (July 25th 2024)\n--- Exit 1 ---/\n\n" ) >> $(cat ./tempfile_LOGFILEPATH)'
      # Remove leftover tempfiles
      $ROOTUSE rm ./tempfile_DESCNOPING > /dev/null 2>&1
      $ROOTUSE rm ./tempfile_TIME > /dev/null 2>&1
      $ROOTUSE rm ./tempfile_LOGFILEPATH > /dev/null 2>&1
      # Ending phrase
      printf "* Log Saved...\nAll done!\n"
      ExitStatement
      exit 1
    # If two or more incompatible functional arguments are detected
    elif [ "$SAVESTATINCOMPARGS" = "true" ] ; then
      DESCINCOPARGS="Incompatible arguments detected($INCOMPARGS_DETAIL)"
      ( echo "$DESCINCOPARGS" ) > ./tempfile_DESCINCOPARGS
      $ROOTUSE $SHELL -c '( echo "--- Failed Operation ---\\" && printf "Generated $(date)\nTime took: $(cat ./tempfile_TIME) sec.\n\n$(cat ./tempfile_DESCINCOPARGS)\n\n" ) >> $(cat ./tempfile_LOGFILEPATH)'
      SaveStatsComments
      $ROOTUSE $SHELL -c '( printf "Version 2.0.0 (July 25th 2024)\n--- Exit 1 ---/\n\n" ) >> $(cat ./tempfile_LOGFILEPATH)'
      # Remove leftover tempfiles
      $ROOTUSE rm ./tempfile_DESCINCOPARGS > /dev/null 2>&1
      $ROOTUSE rm ./tempfile_TIME > /dev/null 2>&1
      $ROOTUSE rm ./tempfile_LOGFILEPATH > /dev/null 2>&1
      # Ending phrase
      printf "* Log Saved...\nAll done!\n"
      ExitStatement
      exit 1
    else
      #SaveStatsPkgLog
      $ROOTUSE $SHELL -c '( echo "--- Successful Operation ---\\" && printf "Generated $(date)\nTime took: $(cat ./tempfile_TIME) sec.\n\n" ) >> $(cat ./tempfile_LOGFILEPATH)'
      SaveStatsPkgLog
      SaveStatsComments
      $ROOTUSE $SHELL -c '( printf "Version 2.0.0 (July 25th 2024)\n--- Exit 0 ---/\n\n" ) >> $(cat ./tempfile_LOGFILEPATH)'
      # Remove leftover tempfiles
      $ROOTUSE rm ./tempfile_TIME > /dev/null 2>&1
      $ROOTUSE rm ./tempfile_LOGFILEPATH > /dev/null 2>&1
      # Ending phrase
      printf "* Log Saved...\nAll done!\n"
      ExitStatement
      exit 0
    fi
  else
    # Remove leftover tempfiles
    $ROOTUSE rm ./tempfile_TIME > /dev/null 2>&1
    $ROOTUSE rm ./tempfile_LOGFILEPATH > /dev/null 2>&1
    echo "* All done!"
    ExitStatement
    exit 0
  fi
  
}

# Action Flag Function
ActionFlag () {
  # Functional arguments
  case $1 in
    "-"* | "--"*)
      MAIN_ARG=$1
      # Strip initial dashes -- or -
      case $MAIN_ARG in
        "--"*"") MAIN_ARG=$(echo "$MAIN_ARG" | cut -c "3-") ;;
        "-"*"") MAIN_ARG=$(echo "$MAIN_ARG" | cut -c "2-") ;;
      esac
      # Read actual arguments
      case $MAIN_ARG in
        # Functional Arguments
        "save-statistics"|"ss")
          DESC_SS=" and saving in log"
          SAVECONFIRM=true
          ;;
        "custom-domain"|"cd")
          DESC_CD=" using custom domain"
          CUSTOM_DOMAIN=true
          ;;
        "manual-all"|"ma")
          DESC_MA=" using manual setting"
          MANUAL_ALL=true
          ;;
        "official-only"|"oo")
          DESC_OO=" using only official package managers"
          OFFICIALONLY=true
          ;;
        "yum-update"|"yu")
          DESC_YU=" using YUM over DNF"
          YUM_UPDATE=true
          ;;
        "alt-only"|"ao")
          DESC_AO=" using only alternative package managers"
          ALTONLY=true
          ;;
        "custom-log-path"|"clp")
          DESC_CLP=" using custom log PATH"
          CUSTOMLOGPATH=true
          ;;
        "override-checksum"|"oc")
          RISKYOPERATION=true
          ;;
        *) AllErrorsMethod "7" "$1" ; exit $? ;;
      esac
      ;;
    # Modifiers
    ":"*)
      ARG_MOD="$(echo "$1" | cut -c "2-")"
      case $MAIN_ARG in
        # Modifiers for --save-statistics
        "save-statistics" | "ss")
          case $ARG_MOD in
            "no-comment" | "nc")
              NOCOMMENT=true
              DESC_SS=" and saving in log(no comments)"
              ;;
            *) AllErrorsMethod "8" "$1" ; exit $? ;;
          esac
          ;;
        # Modifiers for --custom-domain
        "custom-domain" | "cd")
          PRELOADED_CUSTOM_DOMAIN=$ARG_MOD
          PRE_CD=true
          ;;
        # Modifiers for --custom-log-path
        "custom-log-path" | "clp")
          LOG_DIR_PATH=$ARG_MOD
          PRE_CLP=true
          DESC_CLP=" using custom log PATH ($LOG_DIR_PATH)"
          ;;
        # If no matching Functional argument is detected
        *) AllErrorsMethod "9" "$1" "$ARG_MOD" ; exit $? ;;
      esac
      ;;
    # Ignore whitespace
    "") ;;
    # If no arguments are recogninzed at all
    *) AllErrorsMethod "10" "$1" ; exit $? ;;
  esac
}

# Preperation Function
ActionPrep () {
  # Attempts to find the specific UNIX Distribution
  case "$(uname)" in
    # If uname returns 'Linux', attempt to filter out specific distro
    "Linux")
      if [ -f "/etc/os-release" ] ; then
        DISTRO_NAME="$(cat /etc/os-release | grep "PRETTY_NAME=" | cut -c 13-)"
      else
        DISTRO_NAME="*Unknown Linux*"
      fi
      ;;
    "OpenBSD") DISTRO_NAME="OpenBSD" ;;
    "FreeBSD") DISTRO_NAME="FreeBSD" ;;
    *) DISTRO_NAME="*Unknown*" ;;
  esac
  # Functional argument ERRORS
  # Error if all arguments are attempted
  if [ "$SAVECONFIRM" = "true" ] && [ "$CUSTOM_DOMAIN" = "true" ] && [ "$MANUAL_ALL" = "true" ] && [ "$OFFICIALONLY" = "true" ] && [ "$YUM_UPDATE" = "true" ] && [ "$ALTONLY" = "true" ] ; then
    echo "!!All Possible Arguments attempted! Not all functional variables are compatible with one-another!"
    echo "!!Invalid argument combination (likely -ao/--alt-only and -dam/--disable-alt-managers). Relaunch script with valid combination."
    if [ "$SAVECONFIRM" = "true" ] ; then
      SAVESTATINCOMPARGS=true
      INCOMPARGS_DETAIL="Likely all possible arguments attempted."
      SaveStats
    else
      exit 1
    fi
  fi
  # Error for mixed -ao/--alternate-only and -dam/--disable-alt-managers
  if [ "$OFFICIALONLY" = "true" ] && [ "$ALTONLY" = "true" ] ; then
    echo "!!Invalid argument combination (likely -ao/--alt-only and -dam/--disable-alt-managers). Relaunch script with valid combination."
    if [ "$SAVECONFIRM" = "true" ] ; then
      SAVESTATINCOMPARGS=true
      INCOMPARGS_DETAIL="Likely -dam / --disable-alt-managers and -ao / --alt-only mixed."
      SaveStats
    else
      exit 1
    fi
  fi
  # Error for mixed -yu/--yum-update and -ao/--alt-only
  if [ "$YUM_UPDATE" = "true" ] && [ "$ALTONLY" = "true" ] ; then
    echo "!!Invalid argument combination (likely -ao/--alt-only and -yu/--yum-update). Relaunch script with valid combination."
    if [ "$SAVECONFIRM" = "true" ] ; then
      SAVESTATINCOMPARGS=true
      INCOMPARGS_DETAIL="Likely -yu / --yum-update and -ao / --alt-only mixed."
      SaveStats
    else
      exit 1
    fi
  fi
  # Error for mixed -ss/--save-statistics and -clp/--custom-log-path
  if [ "$SAVECONFIRM" = "false" ] && [ "$CUSTOMLOGPATH" = "true" ] ; then
    echo "!!Missing partner argument (likely --save-statistics / -ss). Relaunch script with valid combination."
    if [ "$SAVECONFIRM" = "true" ] ; then
      SAVESTATINCOMPARGS=true
      INCOMPARGS_DETAIL="Likely -ss / --save-statistics and -clp / --custom-log-path mixed."
      SaveStats
    else
      exit 1
    fi
  fi
  # Functional argument working
  # Manual controls
  if [ "$MANUAL_ALL" = "true" ] ; then
    # Defines loops for program
    MANQ_DEB1=true
    MANQ_DEB2=true
    MANQ_SUSE1=true
    MANQ_SUSE2=true
    # Makes all package manager questions manual
    MANQ=" "
    while [ "$MANQ_DEB1" = "true" ] ; do
      printf "* Are you updating a \e[3mDebian/Ubuntu-based system\e[0m?\n"
      printf "\t[Y/y]es/[N/n]o < "
      read MANQ_R1
      case $MANQ_R1 in
        "N"|"n"|"No"|"No"|"NO"|"no")
          MANQ_DEB1=false
          ;;
        "Y"|"y"|"Yes"|"yes"|"YES")
          while [ "$MANQ_DEB2" = "true" ] ; do
            printf "* Would you like to run: \n\t[1] dist-upgrade (\e[1mdefault\e[0m)\n\tor\n\t[2] upgrade\n\t"
            printf " < "
            read MANQ_R2
            case $MANQ_R2 in
              "1")
                APT_UPGRADE="dist-upgrade"
                MANQ_DEB1=false
                MANQ_DEB2=false
                # Below two lines added to prevent SUSE loop from starting
                MANQ_SUSE1=false
                MANQ_DEB2=false
                ;;
              "2")
                APT_UPGRADE="upgrade"
                MANQ_DEB1=false
                MANQ_DEB2=false
                MANQ_SUSE1=false
                MANQ_DEB2=false
                ;;
              *)
                printf "!!Please select one of the two options. Otherwise, quit and re-leanch the script.\n\n"
                ;;
            esac
          done
        ;;
        *)
          printf "!!Please select one of the two options. Otherwise, quit and re-leanch the script.\n\n"
          ;;
      esac
    done
    while [ "$MANQ_SUSE1" = "true" ] ; do
      printf "* Are you updating an \e[3mOpenSUSE\e[0m system?\n"
      printf "\t[Y/y]es/[N/n]o < "
      read MANQ_R1
      case $MANQ_R1 in
        "N" | "n" | "No" | "no" | "NO")
          MANQ_SUSE1=false
          MANQ_R1=false
          ;;
        "Y" | "y" | "Yes" | "yes" | "YES")
          while [ "$MANQ_SUSE2" = true ] ; do
            printf "* Would you like to run: \n\t[1] dist-upgrade (\e[1mdefault\e[0m)\n\tor\n\t[2] update\n\t"
            printf " < "
          read MANQ_R2
            case $MANQ_R2 in
              # Abbreviations for compatibility with OpenSuse MicroOS
              "1")
                SUSE_UPGRADE="dup"
                MANQ_SUSE1=false
                MANQ_SUSE2=false
                ;;
              "2")
                SUSE_UPGRADE="up"
                MANQ_SUSE1=false
                MANQ_SUSE2=false
                ;;
              *) printf "!!Please select one of the two options. Otherwise, quit and re-launch the script.\n\n" ;;
            esac
          done
          ;;
        *) printf "!!Please select one of the two options. Otherwise, quit and re-launch the script.\n\n" ;;
      esac
    done
    if [ "$CUSTOMLOGPATH" = "true" ] && [ "$PRE_CLP" != "true" ] ; then
      printf "Type custom log path: < "
      read LOG_DIR_PATH
      DESC_CLP=" using custom log PATH ($LOG_DIR_PATH)"
    fi
    if [ "$CUSTOM_DOMAIN" = "true" ] && [ "$PRE_CD" != "true" ] ; then
      printf "Type domain: < "
      read PING_TARGET
    fi
    printf "\tContinuing...\n"
  fi
  # Custom Log PATH
  if [ "$CUSTOMLOGPATH" = "true" ] ; then
    if [ "$PRE_CLP" != "true" ] && [ "$MANUAL_ALL" = "false" ] ; then
      printf "Type custom log path: < "
      read LOG_DIR_PATH
    fi
  fi
  # Network Test
  if [ "$CUSTOM_DOMAIN" = "false" ] ; then
    NetworkTest raw.githubusercontent.com
    if [ "$EXIT1" = "true" ] ; then
      if [ "$SAVECONFIRM" = "true" ] ; then
        SAVESTATSNOPING=true
        SaveStats
      else
        exit 1
      fi
    fi
  # Using custom domain
  elif [ "$CUSTOM_DOMAIN" = "true" ] ; then
    if [ "$PRE_CD" = "true" ] ; then
      PING_TARGET=$PRELOADED_CUSTOM_DOMAIN
    elif [ "$PRE_CD" != "true" ] && [ "$MANUAL_ALL" = "false" ] ; then
      printf "Type domain: < "
      read PING_TARGET
    fi
    DESC_CD=" using custom domain($PING_TARGET)"
    NetworkTest raw.githubusercontent.com &
    NetworkTest $PING_TARGET &
    wait
    if [ "$EXIT1" = "true" ] ; then
      if [ "$SAVECONFIRM" = "true" ] ; then
        SAVESTATSNOPING=true
        SaveStats
      else
        exit 1
      fi
    fi
  fi
  # Check if Log-file PATH exists
  if [ "$LOG_DIR_PATH" != "" ] ; then
    if [ ! -d "$LOG_DIR_PATH"  ] ; then
      # If not, exit
      printf "!!LOG-FILE PATH DOES NOT EXIST, QUITting!\n"
      exit 1
    fi
  fi
}


# Pre-Main section, used to use informational arguments
case "$@" in
  *"--conditions"*|*"-c"*|*"--help"*|*"-h"*|*"--privacy-policy"*|*"-pp"*|*"--version"*|*"-v"*|*"--warranty"*|*"-w"*)
    for INFORMATIONAL_ARGS in "$@" ; do
      case "${INFORMATIONAL_ARGS}" in
        "-c"|"--conditions") ConditionMessage ;;
        "-pp"|"--privacy-policy") PrivacyPolicyMessage ;;
        "-v"|"--version")
          echo " = = ="
          echo "$0 $VERSION_NAME_FULL"
          ;;
        "-h"|"--help") HelpMessage ;;
        "-w "|"--warranty") WarrantyMessage ;;
      esac
    done
    exit 0
    ;;
esac

# Main
clear
## Starts counting time
TIMEBEGIN=$(date +%s)
## Sets up initial variables
### Root-related variables
ROOTUSE=""
NOROOT=0
### Flag-related variables
RISKYOPERATION=false
DISTRO_NAME=""
MANUAL_ALL=false
MANQ="-y"
SAVECONFIRM=false
CUSTOM_DOMAIN=false
OFFICIALONLY=false
ALTONLY=false
### Variables used by methods
APT_UPGRADE="dist-upgrade"
SUSE_UPGRADE="dup"
LOOP_INPUT=true
### Variables used for errors
SAVESTATSNOPING=false
SAVESTATTOOMANYARGS=false
## Checks for root privileges
case $(whoami) in
  "root") printf "\t* Script is run as root\n" ;;
  *)
    # Prints status message
    printf "\e[3m* Script not executed as root, checking if user $(whoami) has sudo/doas permission...\e[0m\n"
    # Test SUDO presence
    sudo > /dev/null 2>&1
    case "$?" in
      "127")
        echo "* sudo not found..."
        NOROOT=$(( $NOROOT + 1 ))
        NOSUDO=true
        ;;
      *)
        case $(sudo -l | grep "ALL") in
          "")
            echo "* no doas privileges detected..."
            NOROOT=$(( $NOROOT + 1 ))
            ;;
          *)
            printf "\t\e[3m* User $(whoami) has sudo permissions, continuing...\e[0m\n"
            ROOTUSE="sudo"
            ;;
        esac
        ;;
    esac
    # Test DOAS presence
    doas > /dev/null 2>&1
    case "$?" in
      "127")
        echo "* doas not found..."
        NOROOT=$(( $NOROOT + 1 ))
        NODOAS=true
        ;;
      *)
        case "$(groups $(whoami) | grep "wheel")" in
          "")
            echo "* no doas privileges detected..."
            NOROOT=$(( $NOROOT + 1 ))
            ;;
          *)
            printf "\t\e[3m* User $(whoami) has doas permissions, continuing...\e[0m\n"
            ROOTUSE="doas"
            ;;
        esac
        ;;
    esac
    # If neither SUDO or DOAS is not present
    if [ "$NOSUDO" = true ] && [ "$NODOAS" = true ] ; then
      AllErrorsMethod "11" "MISSING_TOOL" ; exit $?
    # If user has no permissions in neither SUDO nor DOAS
    elif [ "$NOROOT" = "2" ] ; then
      AllErrorsMethod "11" "NO_PERMS" ; exit $?
    fi
    ;;
esac
## Checks that at least one of the two dependencies, CURL and WGET, are met
DependencyTest
## Collects and filters functional arguments
while [ "$#" -gt 0 ]; do
  ActionFlag $1
  shift
done
## Prepares appropriate functions and variables for action
ActionPrep
## Runs the checksum-checker
ChecksumCheck $TOOLUSE
case "$?" in
  "1")
    printf "!!Checksum-Checker FAILED!\n"
    case $RISKYOPERATION in
      "true")
        printf "!!!Running despite Checksum-Checker FAILING!!!\n"
        WarrantyMessage
        ;;
      *) AllErrorsMethod "12" ; exit $? ;;
    esac
    ;;
esac

# Description
DESC_LOG="$DESC_CD$DESC_MA$DESC_OO$DESC_YU$DESC_AO$DESC_SS$DESC_CLP"
printf "* Running \e[4mUpdate_Full [UNIX] $VERSION_NUMB\e[01;m script\e[1m$DESC_LOG"
printf "\e[0m:\n* Date and Time is:\t$(date)\n"
## Begin running package manager
if [ "$OFFICIALONLY" = "true" ] ; then
  CheckOfficialPkgMan
elif [ "$ALTONLY" = "true" ] ; then
  CheckAlternativePkgMan
else
  CheckOfficialPkgMan
  CheckAlternativePkgMan
fi
## Checks if commenting was enabled
SaveStats

# Update_full-unix.sh  Copyright (C) 2024  Mikhail P. Ortiz-Lunyov (mportizlunyov)
#   This program comes with ABSOLUTELY NO WARRANTY; for details add argument `-w' or `--warranty'.
#   This is free software, and you are welcome to redistribute it
#   under certain conditions; add argument `-c' or `--conditions' for details.
