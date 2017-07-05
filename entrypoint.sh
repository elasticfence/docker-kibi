#!/bin/bash

set -e

if [ "$1" = 'docker-kibi' ]; then
    if [ "$ELASTICSEARCH_URL" -o "$ELASTICSEARCH_PORT_9200_TCP" ]; then
        : ${ELASTICSEARCH_URL:='http://elasticsearch:9200'}
        sed -ri "s!^(\#\s*)?(elasticsearch\.url:).*!\2 '$ELASTICSEARCH_URL'!" /opt/kibi/config/kibi.yml
    else
        "No ES URL parameter, starting local instance... "
        service elasticsearch start
        sleep 5
    fi
else
        service elasticsearch start
        sleep 5
fi

# Patch demo kibi to use standard ES port
perl -p -i -e "s/9220/9200/" /opt/kibi/config/kibi.yml
perl -p -i -e "s/localhost/0.0.0.0/" /opt/kibi/config/kibi.yml

# Start Kibi
/opt/kibi/bin/kibi &
tail -f /var/log/elasticsearch/*.log
