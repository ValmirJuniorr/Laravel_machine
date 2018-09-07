#!/usr/bin/env bash
echo 'Requiring laravel'
composer global require "laravel/installer"

echo 'export PATH="$PATH:$HOME/.config/composer/vendor/bin"' >> ~/.bashrc
echo 'export PATH="$PATH:$HOME/.config/composer/vendor/bin"' >> ~/.bash_profile

echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile
echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc

#Replace with your user:group and home/user
sudo chown -R $USER:$USER $HOME
