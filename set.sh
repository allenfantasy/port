#!/bin/bash
#
# usage: ./set.sh [NGINX_PORT] [APP_PORT] [APP_PATH] [APP_NAME]

function help()
{
	echo "Usages: ./set.sh [NGINX_PORT] [APP_PORT] [APP_PATH] [APP_NAME]"
}

NGINX_PORT=$1
APP_PORT=$2
APP_PATH=$3
APP_NAME=$4

if [ $# -ne 4 ] || [ "$1" == "help" ]; then
	# detect argument numbers
	help;
else
	# detect if there's duplicated nginx_conf filename
	if [ -f /etc/nginx/sites-enabled/$APP_NAME ]; then
		echo "app name duplicated"
	else
		# copy a temp file
		cp ./nginx_conf ./nginx_tmp
		# set nginx_port, app_folder and app_port
		sed -i "s!NGINX_PORT!$NGINX_PORT!g" ./nginx_tmp
		sed -i "s!APP_PORT!$APP_PORT!g" ./nginx_tmp
		sed -i "s!APP_PATH!$APP_PATH!g" ./nginx_tmp
		sudo cp ./nginx_tmp /etc/nginx/sites-available/$APP_NAME
		sudo ln -nfs /etc/nginx/sites-available/$APP_NAME /etc/nginx/sites-enabled/$APP_NAME

		# accept port to firewalls
		sudo iptables -I INPUT -p tcp --dport $NGINX_PORT -j ACCEPT
		sudo iptables -I INPUT -p tcp --dport $APP_PORT -j ACCEPT

		sudo service nginx restart
	fi

	if [ -f ./nginx_tmp ]; then
		rm ./nginx_tmp
	fi
fi
