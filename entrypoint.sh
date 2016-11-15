#!/bin/bash

set -e

if [ "$ELASTICSEARCH_URL" -o "$ELASTICSEARCH_PORT_9200_TCP" ]; then
        : ${ELASTICSEARCH_URL:='http://elasticsearch:9200'}
        sed -ri "s!^(\#\s*)?(elasticsearch\.url:).*!\2 '$ELASTICSEARCH_URL'!" /opt/kibi/config/kibi.yml
else
        echo "No ES URL parameter, starting local instance... "
        # Patch demo ES to listen to all interfaces using elasticfence authentication
        echo "network.host: 0.0.0.0" >> /etc/elasticsearch/elasticsearch.yml
        echo "elasticfence.disabled: false" >> /etc/elasticsearch/elasticsearch.yml
        echo "elasticfence.root.password: elasticFence" >> /etc/elasticsearch/elasticsearch.yml 
        echo "elasticfence.whitelist: [\"127.0.0.1\", \"172.17.0.2\"]" >> /etc/elasticsearch/elasticsearch.yml 
        service elasticsearch start
        sleep 5
fi

# Patch demo kibi to use standard ES port
perl -p -i -e "s/9220/9200/" /opt/kibi/config/kibi.yml
perl -p -i -e "s/localhost/0.0.0.0/" /opt/kibi/config/kibi.yml

# Start Kibi
/etc/ini.d/kibi start
tail -f /var/log/elasticsearch/*.log
