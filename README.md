## Welcome to Update_Full-UNIX (1.3.3)!

Update_Full is a suite of Free & Open-Source scripts written in several shell scripts that allows for simple, customisable, and full updating of a wide variety of Operating Systems through their respective package managers.

This simple script can be used for standard home users, power users with home labs, and even enterprise servers if desired.

---

### To quickly try it out without installing, use
(Following template does not work on **KSH**)
#### `$SHELL <(curl https://raw.githubusercontent.com/mportizlunyov/update_full-unix/main/update_full-unix.sh) [ARGUMENTS]`

---

### (For more information, check the wiki: https://github.com/mportizlunyov/update_full-unix/wiki)

This script uses three types of arguments:
 - Functional (changes how the script works)
 - Modifiers (modifies aspects of a functional argument)
 - Descriptive (gives information about the script)

#### **Functional arguments:**

 - `--no-test` / `-nt` Disable ping testing
    - *<ins>Not compatible</ins> with `-cd`
 - `--custom-domain` / `-cd` Use a custom domain (manual input by default)
	- *<ins>Not compatible</ins> with `-nt`
	- ^_Modifier available_
 - `--yum-update` / `-yu` Use YUM instead of DNF on Red-Hat
	- *<ins>Not compatible</ins> with `-ao`
 - `--disable-alt-managers` / `-dam` Skip alternative package managers
	- *<ins>Not compatible</ins> with `-ao`
 - `--alt-only` / `-ao` Skip native package managers
	- *<ins>Not compatible</ins> with `-ao`
 - `--custom-log-path` / `-clp` Define a custom PATH for the log-file
	- *<ins>Must be run</ins> with `-ss`
	- ^_Modifier available_
 - `--manual-all / -ma` Leaves package manager prompts unanswered, and asks for custom domain and log file PATH is not preloaded
	- ***Will make script unable to be run in a cronjob**
 - `--save-statistics` / `-ss` Save a log file (and add comments!)
	- ^_Modifier available_

#### **Modifiers:**
 - `:<DOMAIN>`		 Preload custom domain for -cd
 - `:no-comment` / `:nc`	 Skip commenting for -ss
 - `:<LOG FILE PATH>`	 Preload custom PATH for log-file for -clp

#### **Descriptive arguments:**
 - `--help` / `-h` 		 Print Help statement
 - `--conditions` / `-c`	 Print Conditions of redistribution
 - `--warrenty` / `-w` 	 Print Warranty
 - `--privacy-policy` / `-pp`	 Print Privacy Policy

This UNIX script is designed especially for Linux, but are also compatible with BSD and Mac OS (due to them being UNIX-based).
This script is **_compatible_ and _tested_** with:
> - BASH (Bourne-Again SHell)
> - SH   (SHell)
> - KSH  (Korne SHell)
> - ASH  (Almquist SHell)
> - DASH (Debian Almquist Shell)
> - ZSH  (Z SHell)

The following are **NOT supported**:
> - CSH  (C SHell)
> - TCSH (Tenex Command SHell)
> - FISH (FIsh SHell)
> - PWSH (PowerSHell)
> - More exotic shells

 The script **supports** the following _native_ package managers (Full list below):
> - apt-get  (Advanced Package Manager)     [Debian]
> - dnf      (Dandified YUM)                [Red Hat]
> - yum      (Yellow Dog Updator, Modified) [Red Hat]
> - rpm-ostree (RPM-Ostree)                 [Red Hat]
> - pacman   (pacman)                       [Arch]
> - apk      (Alpine Linux Package Keeper)  [Alpine Linux]
> - Zypper   (Zypper)                       [OpenSUSE]
> - xbps     (X Binary Package System)      [Void Linux]
> - swupd    (swupd)                        [Clear Linux]
> - nix      (Nix)                          [NixOS Linux]
> - slackpkg (Slackpkg)                     [Slackware Linux]
> - eopkg    (Eopkg)                        [Solus Linux]
> - pkg      (Pkg)                          [FreeBSD]
> - pkg_add  (Pkg_Add)                      [OpenBSD]

Besides the native package managers, Update_Full also supports these _additional_ package managers:
> - flatpak  (Flatpak)
> - snapd    (Snapcraft)
> - brew     (Brew)
> - portsnap (Portsnap)
> - rubygem  (RubyGems)
> - yarn     (yarn)
> - pipx     (pipx)
> - npm      (Node.JS Package Manager)

 ### Of course, **more package managers coming soon!**


 ## I hope you enjoy using this program!
 ### Please leave a star if you liked it!

 > Copyright (C) 2023  Mikhail Patricio Ortiz-Lunyov
 > Update_Full-UNIX is a script that allows for automatic updating of many
 > different UNIX (Linux, BSD, etc) distros across many different shells (see details).
 > This program is free software: you can redistribute it and/or modify
 > it under the terms of the GNU General Public License as published by
 > the Free Software Foundation, either version 3 of the License, or
 > (at your option) any later version.

 > This program is distributed in the hope that it will be useful,
 > but WITHOUT ANY WARRANTY; without even the implied warranty of
 > MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 > GNU General Public License for more details.
 
 > You should have received a copy of the GNU General Public License
 > along with this program.  If not, see <https://www.gnu.org/licenses/>.
