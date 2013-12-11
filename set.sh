#!/bin/bash

# $1: nginx port
# $2: app path
# $3: app port
# $4: app name

# copy a temp file
cp ./nginx_conf ./nginx_tmp

#sed -i "s!APP_PATH!$2!g" ./nginx_tmp

# detect if there's duplicated nginx_conf filename
if [ -f /etc/nginx/sites-enabled/$4 ]
then 
	echo "app name duplicated"
else 
	# set nginx_port, app_folder and app_port
	sed -i "s!NGINX_PORT!$1!g" ./nginx_tmp
 	sed -i "s!APP_PATH!$2!g" ./nginx_tmp
 	sed -i "s!APP_PORT!$3!g" ./nginx_tmp
 	sudo cp ./nginx_tmp /etc/nginx/sites-available/$4
	sudo ln -nfs /etc/nginx/sites-available/$4 /etc/nginx/sites-enabled/$4
	
	sudo service nginx restart
fi

if [ -f ./nginx_tmp ]; then
	rm ./nginx_tmp
fi
