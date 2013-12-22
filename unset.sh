#!/bin/bash
#
# usage: ./set.sh [NGINX_PORT] [APP_PORT] [APP_NAME]

function help()
{
	echo "Usage: ./unset.sh [NGINX_PORT] [APP_PORT] [APP_NAME]"
}

NGINX_PORT=$1
APP_PORT=$2
APP_NAME=$3

if [ $# -ne 3 ] || [ "$1" == "help" ]; then
	help;
else
	# remove nginx configuration file
	if [ -f /etc/nginx/sites-enabled/$APP_NAME ]
	then
		sudo rm /etc/nginx/sites-enabled/$APP_NAME
	fi

	if [ -f /etc/nginx/sites-available/$APP_NAME ]
	then
		sudo rm /etc/nginx/sites-available/$APP_NAME
	fi

	# ban port in firewalls
	sudo iptables -D INPUT -p tcp --dport $NGINX_PORT -j ACCEPT
	sudo iptables -D INPUT -p tcp --dport $APP_PORT -j ACCEPT

	sudo service nginx restart
fi
