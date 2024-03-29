#!/usr/bin/env bash
####################################################################################
# NAME               : php-install.sh
# AUTHOR             : Ryan C.
# DESCRIPTION        : Install a Version of PHP and set as the default version.
# VERSIONS SUPPORTED : 7.2, 7.4, 8.0, 8.1
# COMPATABILITY      : Ubuntu Server 20.04 Focal
####################################################################################
reqs=( software-properties-common gnupg2 )
base_mods=(fpm mysql cli common)
current=$(php -v | grep ^PHP | cut -d' ' -f2)

function header() {
    clear
    echo "#################################"
    echo "#         PHP Installer         #"
    echo "#################################"
    echo ""
}

if [[ $EUID -ne 0 ]]; then
    header
    echo -e "\e[1;31mMust be root or execute with sudo command!\e[0m"
    sleep 3
    exit 1
fi

if [[ $OSTYPE != linux-gnu ]]; then
    echo -e "\e[0;31mScript not Compatible with your Operating System!\e[0m"
    sleep 3
    exit 1
fi

header
echo -e "Checking current PHP version.."
sleep 3
php -v &>/dev/null
if [[ $? -eq 0 ]]; then
    echo -e "\e[0;32mFound PHP Version ${current}..\e[0m"
    switch=true
else
    echo -e "\e[0;31mPHP not found!\e[0m"
    sleep 3
    switch=false
fi

echo -e "Updating Server Repositories..\n"
apt update &>/dev/null

if [[ $switch == true ]]; then
    echo -e "What version of PHP do you want to switch to?\n"
    read version
else
    echo -e "What version of PHP do you want to install?\n"
    read version
fi

case "${version}" in
    7.2)        php_version=7.2;;
    7.4)        php_version=7.4;;
    8.0|8)     php_version=8.0;;
    8.1)        php_version=8.1;;
    *)           echo -e "\e[1;31m$version is not a recognized PHP version!\e[0m\n"
                  sleep 3
                  exit 1;;
esac

dpkg -l | grep software-properties-common &>/dev/null
if [[ $? -ne 0 ]]; then
    dpkg -l | grep gnupg2 &>/dev/null
    if [[ $? -ne 0 ]]; then
        echo -e "Installing required modules..\n"
        apt install "${reqs[@]}" -y &>/dev/null
    else
        echo -e "Installing required modules..\n"
        apt install software-properties-common -y &>/dev/null
    fi
else
    echo -e "Installing required modules..\n"
    apt install gnupg2 -y &>/dev/null
fi

if [[ ! -f /etc/apt/sources.list.d/ondrej-ubuntu-php-*.list ]]; then
    echo -e "Configuring PHP PPA..\n"
    add-apt-repository ppa:ondrej/php -y &>/dev/null
    apt update &>/dev/null
fi

echo -e "Installing PHP version $php_version and setting as the  default command line version..\nPlease be patient, this may take a minute.\n"
apt install php"${php_version}" -y &>/dev/null

for mod in "${base_mods[@]}"
do
    apt install php"${php_version}"-"${mod}" -y &>/dev/null
done

update-alternatives --set php /usr/bin/php"${php_version}" &>/dev/null

php -v | grep "${php_version}" &>/dev/null
if [[ $? != 0 ]]; then
    echo -e "\e[1;31mInstallation of PHP version $php_version failed!\e[0m"
    sleep 3
    exit 1
else
    echo -e "\e[1;32mInstallation succeeded and the default PHP version is ${php_version}!\e[0m"
    sleep 3
    exit 0
fi
