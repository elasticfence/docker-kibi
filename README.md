<img src="https://avatars3.githubusercontent.com/u/12463357?v=3" />
# docker-kibi
Docker container running ```ES 2.4.1``` + ```Siren.join 2.4.1``` + ```Kibi 4.5.4```

## About
Kibi enhances Kibana with features for complex "relational" data.<br>
To demonstrate this, this instance is loaded with 4 kinds of interconnected entities:

```Articles (n---1) Companies (1---n) Investments (n---1) Investors```

Kibi allows set to set navigation. One can start from a set (e.g., Articles this month that mentions "hadoop") , then rotate to the "companies mentioned here" then again rotate to the "investments they have received" (and see the total), and finally see the "investors who backed these" (revealing where they're mostly located), and so on.

#### Usage

Run the image using local Elastic instance (w/ siren-join)
```
$ docker run -i -t -p 9200:9200 -p 5601:5606 qxip/docker-kibi
```

Run the image using remote Elastic instance
```
$ docker run -i -t -e ELASTICSEARCH_URL=http://192.168.10.20:9200 -p 5601:5606 qxip/docker-kibi
```
