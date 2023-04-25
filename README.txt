Welcome to Update_Full-UNIX!

Update_Full is a suite of Free & Open-Source scripts written in several shell scripts that allows for simple, customisable, and full updating of a wide variety of Operating Systems through their respective package managers.

This simple script can be used for standard home users, power users with home labs, and even enterprise servers if desired.
(For more information, check the wiki: https://github.com/mportizlunyov/update_full-unix/wiki)

This UNIX script is designed especially for Linux, but are also compatible with BSD and Mac OS (due to them being UNIX-based).
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

The script supports the following native package managers (Full list below):
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

Besides the native package managers, Update_Full also supports these additional package managers:
 - flatpak  (Flatpak)
 - snapd    (Snapcraft)
 - brew     (Brew)
 - portsnap (Portsnap)
 - rubygem  (RubyGems)
 - yarn     (yarn)
 - pipx     (pipx)
 - npm      (Node.JS Package Manager)

This script uses three types of arguments:
    Functional (changes how the script works),
    Modifiers (modifies aspects of a functional argument), and
    Descriptive (gives information about the script).

Functional arguments:
--no-test / -nt	 Disable ping testing
	*Not compatible with -cd
--custom-domain / -cd	 Use a custom domain (manual input by default)
	*Not compatible with -nt
	^Modifier available
--yum-update / -yu	 Use YUM instead of DNF on Red-Hat
	*Not compatible with -ao
--disable-alt-managers / -dam	 Skip alternative package managers
	*Not compatible with -ao
--alt-only / -ao	 Skip native package managers
	*Not compatible with -ao
--custom-log-path / -clp	 Define a custom PATH for the log-file
	*Must be run with -ss
	^Modifier available
--manual-all / -ma	 Leaves package manager prompts unanswered, and asks for custom domain and log file PATH is not preloaded
	*Will make script unable to be run in a cronjob
--save-statistics / -ss	 Save a log file (and add comments!)
	^Modifier available

Modifiers:
:<DOMAIN>		 Preload custom domain for -cd
:no-comment / :nc	 Skip commenting for -ss
:<LOG FILE PATH>	 Defines custom PATH for log-file for -clp

Descriptive arguments:
--help / -h 		 Print Help statement
--conditions / -c	 Print Conditions of redistribution
--warrenty / -w 	 Print Warranty
--privacy-policy / -pp	 Print Privacy Policy


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
