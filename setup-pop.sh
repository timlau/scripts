#!/bin/bash
# Setup script for Pop OS 19.04

# install packages if not installed already
# install "package" "extrapkg1 extrapkg2 .. "
pkg_install () {
    color_label="\e[32m$1\e[00m"
    dpkg -l | grep -qw $1; 
    if [ $? -eq 0 ] ; then
        echo -e "--> Skipping $color_label (already installed)"
        return 0;
    else
        echo -e "--> Installing $color_label "
        sudo DEBIAN_FRONTEND=noninteractive apt-get install -qq $1 $2 < /dev/null > /dev/null  
        return 1;
    fi
}

# Install flatpaks
fp_install () {
    color_label="\e[32m$1\e[00m"
    echo -e "--> Installing $color_label"
    echo -n -e "    \e[94m"
    flatpak install -y --noninteractive $1
    echo -n -e "\e[00m"
}

start_packages () {
    echo "===================================================================="
    echo " Installing packages"
    echo "===================================================================="
}

start_flatpaks () {
    #Install flatpak support and add flathub repo
    echo "===================================================================="
    echo " Installing flatpaks"
    echo "===================================================================="
    pkg_install "flatpak" "gnome-software-plugin-flatpak"
    echo "--> Adding flathub repo"
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
}

start_ge () {
    echo "===================================================================="
    echo " Installing Gnome Extension"
    echo "===================================================================="
}


ge_install () {
    if [ ! -x gnome-shell-extension-installer ]; then
        wget -O gnome-shell-extension-installer "https://github.com/brunelli/gnome-shell-extension-installer/raw/master/gnome-shell-extension-installer"
        chmod +x gnome-shell-extension-installer
    fi
    id=$(echo $1 | cut -d "/" -f 5 -)
    name=$(echo $1 | cut -d "/" -f 6 -)
    color_label="\e[32m$name ($id)\e[00m"
    echo -e "--> Installing $color_label"
    (IFS='
'
    for i in $(./gnome-shell-extension-installer $id --yes --update)
    do
        echo -e "    \e[94m$i"
    done)
    echo -n -e "\e[00m"  
}

# Packages to install
start_packages
pkg_install "htop"
pkg_install "virtualbox" "virtualbox-guest-additions-iso virtualbox-ext-pack"
pkg_install "vlc"

# Flatpak's to install
start_flatpaks
fp_install "org.gimp.GIMP"
fp_install "org.olivevideoeditor.Olive"

# Install gnome extensions
start_ge
ge_install "https://extensions.gnome.org/extension/307/dash-to-dock/"

