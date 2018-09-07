#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

apt-get autoremove
apt-get update && apt-get upgrade

locale-gen en_US en_US.UTF-8 pt_BR.UTF-8
dpkg-reconfigure locales

apt-get -y install expect

apt-get -y install curl unzip

apt-get -y install git

#echo "Coppying and make exp executable ........."

#cp /vagrant/exp /usr/bin/exp

#chmod +x /usr/bin/exp

echo "Installing mysql........."

debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'

apt-get -y install mysql-server mysql-client


echo "Configuring mysql........."

sed -i 's/skip-external-locking/#skip-external-locking/g' /etc/mysql/mysql.conf.d/mysqld.cnf 
sed -i 's/bind-address/#bind-address/g' /etc/mysql/mysql.conf.d/mysqld.cnf 

service mysql restart

echo "Creating user remote ......"

echo "CREATE USER 'remote'@'localhost' IDENTIFIED BY 'remote'" | mysql -uroot -proot
echo "GRANT ALL PRIVILEGES ON *.* TO 'remote'@'localhost' WITH GRANT OPTION" | mysql -uroot -proot
echo "CREATE USER 'remote'@'%' IDENTIFIED BY 'remote'" | mysql -uroot -proot
echo "GRANT ALL PRIVILEGES ON *.* TO 'remote'@'%' WITH GRANT OPTION" | mysql -uroot -proot
echo "FLUSH PRIVILEGES" | mysql -uroot -proot

echo "intalling Apache2  .........."

apt-get -y install apache2

a2enmod rewrite

service apache2 restart

echo "intalling php.........."

#apt-get -y install php7.0 php7.0-dev php-pear libapache2-mod-php7.0 php7.0-mbstring php7.0-zip php7.0-xml php7.0-mysql php7.0-sqlite3


apt-get -y install python-software-properties
add-apt-repository ppa:ondrej/php
apt-get update
apt-get -y install php7.2 php7.2-dev php-pear libapache2-mod-php7.2 php7.2-mbstring php7.2-zip php7.2-xml php7.2-mysql php7.2-sqlite3

#configure file size upload
sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 128M/g' /etc/php/7.2/apache2/php.ini

service apache2 restart

echo "intalling php myadmin .........."

apt-get install -q -y phpmyadmin 

echo 'phpmyadmin phpmyadmin/dbconfig-install boolean true' | debconf-set-selections
echo 'phpmyadmin phpmyadmin/mysql/app-pass password root' | debconf-set-selections
echo 'phpmyadmin phpmyadmin/app-password-confirm password root' | debconf-set-selections
echo 'phpmyadmin phpmyadmin/mysql/admin-pass password root' | debconf-set-selections
echo 'phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2' | debconf-set-selections

echo "include /etc/phpmyadmin/apache.conf" >> /etc/apache2/apache2.conf

systemctl restart apache2

curl -sS https://getcomposer.org/installer | php

mv composer.phar /usr/local/bin/composer

chmod +x /usr/local/bin/composer
