# Linux OS
FROM elasticsearch:2.3.5

# Maintainer
MAINTAINER lmangani <lorenzo.mangani@gmail.com>

# Update
# RUN yum -y update && yum clean all

# Create volume for graph data
RUN apt-get update && apt-get clean \
 && curl -sL https://deb.nodesource.com/setup_4.x | bash - \
 && apt-get install -y nodejs \
 && cd /opt && wget http://bit.do/kibi-4-4-2-linux-x64-demo-full-zip \
 && unzip kibi-4-4-2-linux-x64-demo-full-zip \
 && ln -s kibi-4-4-2-linux-x64 kibi \
 && /usr/share/elasticsearch/bin/plugin install https://github.com/QXIP/siren-join/releases/download/2.3.5/siren-join-2.3.5.zip

COPY entrypoint.sh /opt/
RUN chmod 755 /opt/entrypoint.sh
 
# Exec on start
ENTRYPOINT ["/bin/bash", "/opt/entrypoint.sh"]

# Expose Default Port
EXPOSE 9200 9300 5601
