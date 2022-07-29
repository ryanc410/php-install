# php-install.sh

BASH script that makes it easy to switch from one version of PHP to another.

<br>

# How it Works

First the script does a few checks.. It looks for an already installed version of PHP, it looks for the PHP PPA, and it also looks for packages needed to install the PPA. If the required packages arent found, they are installed and if they are, the script will prompt you for the PHP version you want to install/switch to. The PHP versions offered by this script are 7.2, 7.4, 8.0, and 8.1. The version that is chosen is then installed and set as the default PHP version.

<br>

# Usage
Clone the Repository
````bash
git clone https://github.com/ryanc410/php-install.git
````

Move script inside bin directory
````bash
sudo mv php-install/php-install.sh /usr/bin/
````

Make executable
````bash
sudo chmod +x /usr/bin/php-install.sh
````

Run script
````bash
sudo bash php-install.sh
````
