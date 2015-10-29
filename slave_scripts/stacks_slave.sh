#!/usr/bin/env bash
## Add extra ppas slave script
## Author: Andrew Krohn
## Date: 2015-10-28
## License: MIT
## Version 0.0.1
set -e

## Define variables from inputs
stdout="$1"
stderr="$2"
log="$3"
homedir="$4"
scriptdir="$5"
email="$6"
date0=`date`

## Install Stacks
	stackstest=`command -v cstacks 2>/dev/null | wc -l`
	if [[ $stackstest -ge 1 ]]; then
echo "Stacks already installed.  Skipping.
"
echo "Stacks already installed.  Skipping.
" >> $log
	else
echo "Installing Stacks for RADseq applications.
"
echo "Installing Stacks for RADseq applications.
" >> $log
cd $homedir/akutils_ubuntu_installer
tar -xzvf stacks-1.34.tar.gz  1>$stdout 2>$stderr || true
cd stacks-1.34/
./configure  1>$stdout 2>$stderr || true
make  1>$stdout 2>$stderr || true
wait
sudo make install 1>$stdout 2>$stderr || true
echo "***** stdout:" >> $log
cat $stdout >> $log
echo "***** stderr:" >> $log
cat $stderr >> $log
echo "" >> $log
	fi
wait
## Edit MySQL config file
echo "Configuring mysql and apache webserver.
"
echo "Configuring mysql and apache webserver.
" >> $log
echo "---Copy mysql.cnf file." >> $log
sudo cp /usr/local/share/stacks/sql/mysql.cnf.dist /usr/local/share/stacks/sql/mysql.cnf 1>$stdout 2>$stderr || true
echo "***** stdout:" >> $log
cat $stdout >> $log
echo "***** stderr:" >> $log
cat $stderr >> $log
echo "" >> $log
echo "---Change mysql permissions." >> $log
mysql> GRANT ALL ON *.* TO 'stacks'@'localhost' IDENTIFIED BY 'stacks';
echo "***** stdout:" >> $log
cat $stdout >> $log
echo "***** stderr:" >> $log
cat $stderr >> $log
echo "" >> $log
sed -i "s/password=\w+/password=\"\"/" /usr/local/share/stacks/sql/mysql.cnf
echo "***** stdout:" >> $log
cat $stdout >> $log
echo "***** stderr:" >> $log
cat $stderr >> $log
echo "" >> $log
sed -i "s/user=\w\+/user=${userid}/" /usr/local/share/stacks/sql/mysql.cnf
echo "***** stdout:" >> $log
cat $stdout >> $log
echo "***** stderr:" >> $log
cat $stderr >> $log
echo "" >> $log
## Enable Stacks web interface in Apache webserver
echo "---Build stacks.conf file for Apache webserver." >> $log
sudo echo '<Directory "/usr/local/share/stacks/php">
        Order deny,allow
        Deny from all
        Allow from all
	Require all granted
</Directory>

Alias /stacks "/usr/local/share/stacks/php"
' > /etc/apache2/conf-available/stacks.conf 2>$stderr || true
echo "***** stdout:" >> $log
cat $stdout >> $log
echo "***** stderr:" >> $log
cat $stderr >> $log
echo "" >> $log
echo "---Symlink to Apache2 stacks.conf file." >> $log
ln -s /etc/apache2/conf-available/stacks.conf /etc/apache2/conf-enabled/stacks.conf 1>$stdout 2>$stderr || true
echo "***** stdout:" >> $log
cat $stdout >> $log
echo "***** stderr:" >> $log
cat $stderr >> $log
echo "" >> $log
echo "---Restart Apache webserver" >> $log
sudo apachectl restart 1>$stdout 2>$stderr || true
echo "***** stdout:" >> $log
cat $stdout >> $log
echo "***** stderr:" >> $log
cat $stderr >> $log
echo "" >> $log
wait
## Provide access to MySQL database from web interface
echo "---Copy php constants file and change permissions." >> $log
cp /usr/local/share/stacks/php/constants.php.dist /usr/local/share/stacks/php/constants.php 1>$stdout 2>$stderr || true
echo "***** stdout:" >> $log
cat $stdout >> $log
echo "***** stderr:" >> $log
cat $stderr >> $log
echo "" >> $log
sudo sed -i 's/dbuser/stacks/' /usr/local/share/stacks/php/constants.php 1>$stdout 2>$stderr || true
echo "***** stdout:" >> $log
cat $stdout >> $log
echo "***** stderr:" >> $log
cat $stderr >> $log
echo "" >> $log
sudo sed -i 's/dbpass/stacks/' /usr/local/share/stacks/php/constants.php 1>$stdout 2>$stderr || true
echo "***** stdout:" >> $log
cat $stdout >> $log
echo "***** stderr:" >> $log
cat $stderr >> $log
echo "" >> $log
## Enable web-based exporting from MySQL database
chown stacks /usr/local/share/stacks/php/export 1>$stdout 2>$stderr || true
cd

exit 0