#!/bin/bash
set -e

echo "Getting certificates..."
certbot certonly \
	--no-self-upgrade -n --text --standalone \
	-d "$DOMAINS" --keep --expand --agree-tos --email "$EMAIL"
ln -s `ls -1dA /etc/letsencrypt/live/*/ | head -n1` /certs
echo "Done"

echo "Starting nginx..."
nginx
echo "Done"

echo ""
echo ""
echo ""

export TIMEOUT="3d"

while [ true ]
do
	echo "Waiting ${TIMEOUT}..."
	sleep $TIMEOUT
	echo "Done"
	
	echo "Trying renew certificates..."
	certbot renew --allow-subset-of-names \
		--standalone \
		--pre-hook "nginx -s stop" \
		--post-hook "nginx"
	echo "Done"
done