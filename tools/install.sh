# Resource: https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh
#!/bin/bash
main() {
  name="Gimptoshop"
  errorNotStarted="Error : Cannot install $name. Please start Gimp for the first time before installing and retry\n"
  # Use colors, but only if connected to a terminal, and that terminal
  # supports them.
  if which tput >/dev/null 2>&1; then
  	ncolors=$(tput colors)
  fi
  if [ -t 1 ] && [ -n "$ncolors" ] && [ "$ncolors" -ge 8 ]; then
  	RED="$(tput setaf 1)"
  	GREEN="$(tput setaf 2)"
  	YELLOW="$(tput setaf 3)"
  	BLUE="$(tput setaf 4)"
  	BOLD="$(tput bold)"
  	NORMAL="$(tput sgr0)"
  else
  	RED=""
  	GREEN=""
  	YELLOW=""
  	BLUE=""
  	BOLD=""
  	NORMAL=""
  fi
  # Only enable exit-on-error after the non-critical colorization stuff,
  # which may fail on systems lacking tput or terminfo
  set -e

  if ! [ -x "$(command -v gimp)" ]; then
  	printf "${YELLOW}Gimp is not installed!${NORMAL} Please install Gimp first!\n"
  	exit 1
  fi

  gimp_path_version_string=$(gimp --version)


  if [[ ${gimp_path_version_string} = *"2.8"* ]];  then

    version=$(echo "$gimp_path_version_string" | grep -oP  "2.8")

  fi
  if [[ ${gimp_path_version_string} = *"2.10"* ]];  then

    version=$(echo "$gimp_path_version_string" | grep -oP  "2.10")

  fi

  if echo "$gimp_path_version_string" | grep  -qvF -e "2.8" -e "2.10"; then
    printf "${YELLOW}Gimp version is not installed!${NORMAL} Please install Gimp 2.8 or 2.10 first!\n"
    exit 1
  fi

  hash git >/dev/null 2>&1 || {
  	echo "${RED}Error: git is not installed"
  	exit 1
  }

 if [[ ${gimp_path_version_string} = *"2.8"* || ! ${gimp_path_version_string} = *"2.10"* ]];  then
   if [ -d "$HOME/.gimp-$version" ]; then

    Gimptoshop_directory="$HOME/.gimp-$version"
  else
    echo "** GIMP will be run one time (so it creates its config files), **"
   echo "** when launched fully, the app will exit **"
   command gimp -b '(gimp-quit 0)' >& /dev/null
       Gimptoshop_directory="$HOME/.gimp-$version"

  fi
fi
 # installed from the repositories (this includes official repositories or third-party repositories like a PPA, AUR, and so on)
 if [[ ! ${gimp_path_version_string} = *"2.8"* ||  ${gimp_path_version_string} = *"2.10"* ]];  then

# Check if directory exist
if [ -d "$HOME/.config/GIMP/$version" ]; then
  Gimptoshop_directory="$HOME/.config/GIMP/$version"
else
   echo "** GIMP will be run one time (so it creates its config files), **"
   echo "** when launched fully, the app will exit **"

   command gimp -b '(gimp-quit 0)' >& /dev/null
  Gimptoshop_directory="$HOME/.config/GIMP/$version"
fi
fi

  # Backup previous directory, if any
  if [ -d "$HOME/.config/GIMP/" ]; then
  	backup="$Gimptoshop_directory.backup"
  	mv "$Gimptoshop_directory" "$backup"
fi
# Download the patch
  printf "${BLUE}Downloading $name...${NORMAL}\n"

env git clone --depth=1 https://github.com/Gimptoshop/Gimptoshop.git $Gimptoshop_directory || {
 printf "${RED}Error: git clone of $name repo failed\n"
}
snapd="$HOME/snap/gimp/current/.config/GIMP/$version"

  # Backup previous directory, if any
  if [ -d "$HOME/snap/gimp/current/.config/GIMP" ]; then
  	backup="$snapd.backup"
  	mv "$snapd" "$backup"
  fi
env git clone --depth=1 https://github.com/Gimptoshop/Gimptoshop.git $snapd || {
 printf "${RED}Error: git clone of $name repo failed\n"
}
# backup
if [ ! -f "/usr/share/gimptoshop.xpm" ]; then
 sudo cp "$Gimptoshop_directory/custom-icon/gimptoshop.xpm" "/usr/share/gimptoshop.xpm"
fi
if [ -d "$HOME/snap/gimp" ]; then
  sudo cp "$Gimptoshop_directory/custom-icon/gimp_gimp.desktop" "$HOME/.local/share/applications/gimp_gimp.desktop"
fi
if [ ! -d "$HOME/snap/gimp" ]; then
  sudo cp "$Gimptoshop_directory/custom-icon/gimp_gimp.desktop" "$HOME/.local/share/applications/gimp.desktop"
fi
update-desktop-database ~/.local/share/applications/
# Replace preexisting files from original installation
# in case of missing files
cp -rn "$backup/." "$Gimptoshop_directory"
printf "${GREEN}"
printf "$name successfully installed\n"
printf "${NORMAL}"



}

main
