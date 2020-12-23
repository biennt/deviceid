# deviceid
## build and run the elk as container
Before we start, add the following line into /etc/sysctl.conf
```
vm.max_map_count=262144
```
Then
```
sudo sysctl -p
```
If using Docker for Mac, then you will need to start the container with the MAX_MAP_COUNT environment variable.
```
docker run... -e MAX_MAP_COUNT=262144..
```
Clone this repo and build the image

(information about the base image is here https://elk-docker.readthedocs.io/)
```
docker build -t biennt/deviceidelk .
```
Create an empty directory to store the indexes/data (eg: /elk) and run the docker image

```
docker run -d -p 5601:5601 -p 9200:9200 -p 5044:5044 -p 5140:5140 -p 5140:5140/udp -v /elk:/var/lib/elasticsearch --name elk biennt/deviceidelk
```
Accessing Kibana interface
- Create Index patterns (find the one start with logstash-devid*)
- Go to "Discover" to see the raw/parsed log
- Import the dashboard under "Stack Management --> Saved Objects --> Import" (use deviceid_dashboard.ndjson file)

Sample nginx configurations, bigip irules are located in nginx/bigip directory

## putting nginx in front of elk, so you can accessing as https://your-elk.com 
Basic authentication - create users file 
```
sudo htpasswd -c /etc/nginx/users elkadmin
```
then apply the below config to nginx
```
server {
    server_name     elk.bienlab.com;
    auth_basic "F5 Users Only";
    auth_basic_user_file /etc/nginx/users;

    location / {
      proxy_pass  http://localhost:5601;
    }

    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/elk.bienlab.com/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/elk.bienlab.com/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot

}

  server {
    if ($host = elk.bienlab.com) {
        return 301 https://$host$request_uri;
    } # managed by Certbot


    listen          80;
    server_name     elk.bienlab.com;
    return 404; # managed by Certbot
}
```
Have fun!
