
# Resource: https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh

main() {
  name="Gimptoshop"
  errorNotStarted="Error : Cannot uninstall $name. Please start Gimp for the first time before installing and retry\n"
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
    printf "${RED}"
    printf "$errorNotStarted"
    exit 1
  fi
fi
 # installed from the repositories (this includes official repositories or third-party repositories like a PPA, AUR, and so on)
 if [[ ! ${gimp_path_version_string} = *"2.8"* ||  ${gimp_path_version_string} = *"2.10"* ]];  then

# Check if directory exist
if [ -d "$HOME/.config/GIMP/" ]; then
  Gimptoshop_directory="$HOME/.config/GIMP/$version"
else
  printf "${RED}"
  printf "$errorNotStarted"
  exit 1
fi
fi

if [ -d "$HOME/.config/GIMP" ]; then
      backup="$Gimptoshop_directory.backup"

printf "${BLUE}Uninstalling $name...\n"
rm -r -f "$Gimptoshop_directory"
mv -T "$backup" "$Gimptoshop_directory"
fi

if [ -d "$HOME/snap/gimp" ]; then
  snapd="$HOME/snap/gimp/current/.config/GIMP/$version"

  backup="$snapd.backup"

  rm -r -f "$snapd"
  mv -T "$backup" "$snapd"
  sudo cp "$Gimptoshop_directory/original-icon/gimp_gimp.desktop" "$HOME/.local/share/applications/gimp_gimp.desktop"
fi

if [ "/usr/share/gimptoshop.xpm" ]; then

sudo rm -f "/usr/share/gimptoshop.xpm"
fi

  sudo rm -f "$HOME/.local/share/applications/gimp.desktop"
update-desktop-database ~/.local/share/applications/
  printf "${GREEN}$name successfully uninstalled\n"


}

main
