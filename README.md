Update_Full is a suite of Free & Open-Source scripts written in several shell scripts that allows for simple, customisable, and full updating of a wide variety of popular UNIX distributions through their respective package managers.
This simple script can be used for standard home users, power users with home labs, and even enterprise servers if desired.

These scripts are designed especially for Linux, but are also compatible with BSD and Mac OS, due to them being UNIX-based.
This script is compatible and tested with:
 - BASH (Bourne-Again SHell)
 - SH   (SHell)
 - KSH  (Korne SHell)
 - ASH  (Almquist SHell)
 - ZSH  (Z SHell)
The following are not yet supported:
 - CSH  (C SHell)
 - TCSH (Tenex Command SHell)
 - PWSH (PowerSHell)


The script supports the following package managers (Full list below):
 - Aptitude                     (apt-get) [Debian]
 - Dandified YUM                (dnf)     [Red Hat]
 - Yellow Dog Updator, Modified (yum)     [Red Hat]
 - Pacman                       (pacman)  [Arch]
 - Alpine Linux Package Keeper  (apk)     [Alpine Linux]
 - Zypper                       (zypper)  [OpenSUSE]
 - X Binary Package System      (xbps)    [Void Linux]
 - swupd                        (swupd)   [Clear Linux]
 - Nix                          (nix)     [NixOS Linux]
 - Pkg                          (pkg)     [FreeBSD]
 - Pkg_add                      (pkg_add) [OpenBSD]

Besides the built-in package managers, Update_Full also supports these additional package managers:
 - Flatpak                 (flatpak)
 - Snapcraft               (snapd)
 - Brew                    (brew)
 - Portsnap                (portsnap)
 - RubyGems                (gem)
 - Yarn                    (yarn)
 - Node.JS Package Manager (npm)

This bash script allows for a full update on most UNIX systems, on most package managers.
This script uses two different kinds of arguments: Functional (changes how the script works) and Descriptive (gives information about the script).
    Functional arguments:

By default, the script attempts to test the connection of the computer to the internet before attempting to update ay packages.
    To disable this, add the --no-test or -nt argument when running the script.

By default, the script uses the domain cloudflare.com in the ping test. One can also customise the domain that the update script attempts to contact.
    This can be done by adding --custom-domain or -cd argument.

One can make any questions the package manager makes to be manually decided. By default, any questions are answered with -y.
    To disable this, add the --manual-all or -ma argument.

By default, the script attempts to check the existence of and update packages from alternative package managers such as Flatpaks and Snaps.
    To disable this, add the --disable-alt-managers or -dam argument.

By default, the script uses the more modern DNF package manager instead of the older YUM package manager if the Linux distrobution is Red-Hat based.
    To use YUM instead of DNF, add the --yum-update or -yu argument.

By default, the script attempts to update both the official distrobution packag managers and any alternative package managers installed.
    To only update alternative package managers, add the --alt-only or -ao argument.

By default, the script does not save any statistics on errors or general usage.
    To save statistics into a log file (and even make comments for context!), add the --save-statistics or -ss argument.

   Descriptive arguments:
    To print the help statement, add the --help or -h argument.
    To print the conditions of redistribution, add the --conditions or -c argument.
    To print the warranty of the program, add the --warranty or -w argument.
    To print the privacy policy of the program, add the --privacy-policy or -pp argument.
    It is safest to limit writing permissions to avoid malicious/accidental tampering!

[certain arguments can be combined, in no strict order, in order to acheive the desired result*]

*Not all arguments can be combined.
Descriptive arguments are incompatible with any functional argument and doing so will run the inputted descriptive argument (including -save-statistics).
    Similarly, --no-test / -nt is incompatible with --custom-domain / -cd, and will result in error (cannot use custom domain if ping test was denied).
    --alt-only / -ao is incompatible with --disable-alt-managers / -dam, and will also result in an error (contratictory arguments).

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
