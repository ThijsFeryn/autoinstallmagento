#!/bin/sh
read -ep"Database hostname: " DBHOST
read -ep"Database: " DBNAME
read -ep"Database username: " DBUSER
read -ep"Database password: " DBPASS
read -ep"Magento URL: http://" URL
read -ep"Magento admin firstname: " FIRSTNAME
read -ep"Magento admin lastname: " LASTNAME
read -ep"Magento admin e-mail: " EMAIL
read -ep"Magento admin username: " USERNAME
read -ep"Magento admin password: " PASSWORD
read -ep"Install sample data? [y/n]: " SAMPLE

if [ "$SAMPLE" == "y" ]
then
	wget http://www.magentocommerce.com/downloads/assets/1.7.0.2/magento-1.7.0.2.tar.gz
	tar -zxvf magento-1.7.0.2.tar.gz
	wget http://www.magentocommerce.com/downloads/assets/1.6.1.0/magento-sample-data-1.6.1.0.tar.gz
	tar -zxvf magento-sample-data-1.6.1.0.tar.gz
	mv magento-sample-data-1.6.1.0/media/* magento/media/
	mv magento-sample-data-1.6.1.0/magento_sample_data_for_1.6.1.0.sql magento/data.sql
	mv magento/* magento/.htaccess* .
	chmod -R o+w media var
	mysql -h $DBHOST -u $DBUSER -p$DBPASS $DBNAME < data.sql
	chmod o+w var var/.htaccess app/etc
	rm -rf magento/ magento-sample-data-1.6.1.0/ magento-1.7.0.2.tar.gz magento-sample-data-1.6.1.0.tar.gz data.sql
elif [ "$SAMPLE" == "n" ]
then
	wget http://www.magentocommerce.com/downloads/assets/1.7.0.2/magento-1.7.0.2.tar.gz
	tar -zxvf magento-1.7.0.2.tar.gz
	mv magento/* magento/.htaccess .
	chmod -R o+w media var
	chmod o+w app/etc
	rm -rf magento/ magento-1.7.0.2.tar.gz	
else
	echo "Unknown value for sample data. Should be 'y' or 'n', exiting ..."
	exit
fi	
php install.php -- \
--license_agreement_accepted "yes" \
--locale "nl_BE" \
--timezone "Europe/Brussels" \
--default_currency "EUR" \
--db_host $DBHOST \
--db_name $DBNAME \
--db_user $DBUSER \
--db_pass $DBPASS \
--url "http://"$URL \
--use_rewrites "yes" \
--use_secure "no" \
--secure_base_url "" \
--use_secure_admin "no" \
--admin_firstname $FIRSTNAME \
--admin_lastname $LASTNAME \
--admin_email $EMAIL \
--admin_username $USERNAME \
--admin_password $PASSWORD