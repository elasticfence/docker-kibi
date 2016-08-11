# Linux OS
FROM elasticsearch:2.3.5

# Maintainer
MAINTAINER lmangani <lorenzo.mangani@gmail.com>

RUN groupadd -r kibi && useradd -r -m -g kibi kibi

# Setup Packages & Permissions
RUN apt-get update && apt-get clean \
 && wget -O /dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.1.3/dumb-init_1.1.3_amd64 \
 && chmod +x /dumb-init \
 && curl -sL https://deb.nodesource.com/setup_4.x | bash - \
 && apt-get install -y nodejs \
 && /usr/share/elasticsearch/bin/plugin install https://github.com/QXIP/siren-join/releases/download/2.3.5/siren-join-2.3.5.zip \
 && apt-get autoremove \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
 
RUN cd /opt && wget http://bit.do/kibi-4-4-2-linux-x64-demo-full-zip \
 && unzip kibi-4-4-2-linux-x64-demo-full-zip \
 && rm -rf /opt/kibi-4-4-2-linux-x64-demo-full-zip \
 && mv kibi-4.4.2-1-linux-x64-demo-full kibi \
 && chown -R kibi:kibi /opt/kibi \
 && mv /opt/kibi/elasticsearch/data/kibi-demo /var/lib/elasticsearch/ \
 && chown -R elasticsearch:elasticsearch /var/lib/elasticsearch/ \
 && cp /opt/kibi/elasticsearch/config/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml
 
RUN perl -p -i -e "s/9220/9200/" /opt/kibi/kibi/config/kibi.yml
RUN perl -p -i -e "s/localhost/0.0.0.0/" /opt/kibi/kibi/config/kibi.yml

RUN perl -p -i -e "s/9220/9200/" /etc/elasticsearch/elasticsearch.yml
RUN perl -p -i -e "s/9330/9300/" /etc/elasticsearch/elasticsearch.yml
 
COPY entrypoint.sh /opt/
RUN chmod 755 /opt/entrypoint.sh
ENV PATH /opt/kibi/kibi/bin:$PATH

# Expose Default Port
EXPOSE 5601 5606
EXPOSE 9200
EXPOSE 9300

# Exec on start
ENTRYPOINT ["/dumb-init", "--"]
CMD ["/opt/entrypoint.sh"]
