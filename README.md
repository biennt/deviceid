# deviceid
Clone this repo and build the image
```
docker build -t biennt/deviceidelk .
```
Create an empty directory to store the indexes/data (eg: /elk) and run the docker image

```
docker run -d -p 5601:5601 -p 9200:9200 -p 5044:5044 -p 5140:5140 -p 5140:5140/udp -v /elk:/var/lib/elasticsearch --name elk biennt/deviceidelk
```
Accessing Kibana interface
- Create Index patterns (find the one start with logstash-devid*)
- Go to discover to see the raw/parsed log
- Import the dashboard under Stack Management --> Saved Objects --> Import (use deviceid_dashboard.ndjson file)

Sample nginx configurations, bigip irules are located in nginx/bigip directory

Have fun!
