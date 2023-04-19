#!/bin/bash

if (( $EUID != 0 )); then
    echo "Please run as root"
    exit
fi

clear

installTheme(){
    cd /var/www/
    tar -cvf MinecraftPurpleThemebackup.tar.gz pterodactyl
    echo "Sedang Menginstall Tema..."
    cd /var/www/pterodactyl
    rm -r MinecraftPurpleTheme
    git clone https://github.com/NdraHosting/TemaNdraHosting
    cd MinecraftPurpleTheme
    rm /var/www/pterodactyl/resources/scripts/MinecraftPurpleTheme.css
    rm /var/www/pterodactyl/resources/scripts/index.tsx
    mv index.tsx /var/www/pterodactyl/resources/scripts/index.tsx
    mv MinecraftPurpleTheme.css /var/www/pterodactyl/resources/scripts/MinecraftPurpleTheme.css
    cd /var/www/pterodactyl

    curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash -
    apt update
    apt install -y nodejs

    npm i -g yarn
    yarn

    cd /var/www/pterodactyl
    yarn build:production
    sudo php artisan optimize:clear


}

installThemeQuestion(){
    while true; do
        read -p "Apakah Anda yakin ingin menginstal [y/n]? " yn
        case $yn in
            [Yy]* ) installTheme; break;;
            [Nn]* ) exit;;
            * ) echo "Tolong jawab y(iya)/n(tidak)";;
        esac
    done
}

repair(){
    bash <(curl https://raw.githubusercontent.com/NdraHosting/TemaNdraHosting/main/repair.sh)
}

restoreBackUp(){
    echo "Memulihkan cadangan..."
    cd /var/www/
    tar -xvf MinecraftPurpleThemebackup.tar.gz
    rm MinecraftPurpleThemebackup.tar.gz

    cd /var/www/pterodactyl
    yarn build:production
    sudo php artisan optimize:clear
}
echo "Copyright (c) 2023 NdraHosting"
echo "Tema Ini Adalah Tema Premium Milik NdraHosting"
echo "Dilarang Keras Untuk Menjual Belikan Tema Ini Tanpa Izin Dari NdraHosting"
echo "Tiktok : Xyn.dra_"
echo "Instagram : xyn.dra_"
echo "<==============================||============================>"
echo "[1] Instal tema"
echo "[2] Pulihkan cadangan"
echo "[3] Perbaiki Panel (gunakan jika Anda memiliki kesalahan dalam pemasangan tema)"
echo "[4] Keluar"
echo "<==============================||============================>
echo "Script Buatan NdraHosting"

read -p ".Harap Masukkan Salah Satu Nomor Di Atas" choice
if [ $choice == "1" ]
    then
    installThemeQuestion
fi
if [ $choice == "2" ]
    then
    restoreBackUp
fi
if [ $choice == "3" ]
    then
    repair
fi
if [ $choice == "4" ]
    then
    exit
fi
