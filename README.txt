Update_Full is a suite of Free & Open-Source scripts written in several shell scripts that allows for simple, customisable, and full updating of a wide variety of popular UNIX distributions through their respective package managers.
This simple script can be used for standard home users, power users with home labs, and even enterprise servers if desired.

These scripts are designed especially for Linux, but are also compatible with BSD and Mac OS, due to them being UNIX-based.
This script is compatible and tested with:
 - BASH (Bourne-Again SHell)
 - SH   (SHell)
 - KSH  (Korne SHell)
 - ASH  (Almquist SHell)
 - DASH (Debian Almquist Shell)
 - ZSH  (Z SHell)
The following are not supported:
 - CSH  (C SHell)
 - TCSH (Tenex Command SHell)
 - FISH (FIsh SHell)
 - PWSH (PowerSHell)
 - More exotic shells

The script supports the following package managers (Full list below):
 - apt-get  (Advanced Package Manager)     [Debian]
 - dnf      (Dandified YUM)                [Red Hat]
 - yum      (Yellow Dog Updator, Modified) [Red Hat]
 - pacman   (pacman)                       [Arch]
 - apk      (Alpine Linux Package Keeper)  [Alpine Linux]
 - Zypper   (Zypper)                       [OpenSUSE]
 - xbps     (X Binary Package System)      [Void Linux]
 - swupd    (swupd)                        [Clear Linux]
 - nix      (Nix)                          [NixOS Linux]
 - slackpkg (Slackpkg)                     [Slackware Linux]
 - eopkg    (Eopkg)                        [Solus Linux]
 - pkg      (Pkg)                          [FreeBSD]
 - pkg_add  (Pkg_Add)                      [OpenBSD]

Besides the built-in package managers, Update_Full also supports these additional package managers:
 - flatpak  (Flatpak)
 - snapd    (Snapcraft)
 - brew     (Brew)
 - portsnap (Portsnap)
 - rubygem  (RubyGems)
 - yarn     (yarn)
 - npm      (Node.JS Package Manager)

This bash script allows for a full update on most UNIX systems, on most package managers.
This script uses two different kinds of arguments: 
    Functional (changes how the script works) and Descriptive (gives information about the script).
    If both types of arguments are used, only the Descriptive arguments are used (meaning no updates performed).

Functional Arguments:
    To disable ping testing, add the --no-test or -nt.*
    To use a custom domain for ping testing, add the --custom-domain or -cd argument.*
        To pre-load a custom argument, add the :no-comment or :nc argument.
    To make all package manager options manual, add the --manual-all or -ma argument.
    To use YUM instead of DNF, add the --yum-update or -yu argument.**
    To only update alternative pacakge managers, add the --alt-only or -ao argument.**
    To only update naticve package managers, add the --disable-alt-managers or -dam argument.
    To save a log file (and even add comments!), add the --save-statistics or -ss argument.
        To disable commenting, add the :no-comment or :nc argument.

*Incompatible with each other (custom domain cannot be used if no ping tests are performed)
**Incompatible with each other (YUM cannot be updated if native package managers are not used at all)

Descriptive arguments:
    To print the help statement, add the --help or -h argument.
    To print the conditions of redistribution, add the --conditions or -c argument.
    To print the warranty of the program, add the --warranty or -w argument.
    To print the privacy policy of the program, add the --privacy-policy or -pp argument.
    It is safest to limit writing permissions to avoid malicious/accidental tampering!


I hope you enjoy using this program!

    Copyright (C) 2023  Mikhail Patricio Ortiz-Lunyov
    Update_Full-UNIX is a script that allows for automatic updating of many
    different UNIX (Linux, BSD, etc) distros across many different shells (see details).
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
