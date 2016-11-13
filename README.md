<img src="https://avatars3.githubusercontent.com/u/12463357?v=3" />
# docker-elasticfence
Docker container running the Elasticfence Stack

- Elasticsearch 2.4.1 
- Kibi 4.5.4 + Siren 2.4.1
- Elasticfence Auth _(root/elasticFence)_
- Kibana-auth-elasticfence
- KiBrand 0.4.5
- KaaE 0.0.9
- Sense/Timelion

#### Usage

Install mixed ES container on new host w/ authentication (default: root/elasticFence)
```
docker pull qxip/docker-elasticfence
```
Create stateful data volume
```
docker volume create -o size=20GB --name esdata
```
Run container and map ports
```
docker run -tid --name elk -p 9200:9200 -p 5606:5606 -v esdata:/usr/share/elasticsearch qxip/docker-elasticfence
```
Connect shell to container
```
docker exec -ti elk /bin/bash
```

##### External ES Connector

Run the image using remote Elastic instance
```
$ docker run -i -t -e ELASTICSEARCH_URL=http://192.168.10.20:9200 -p 5601:5606 qxip/docker-kibi
```
