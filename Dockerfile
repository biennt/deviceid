FROM sebp/elk:latest
COPY *.conf /etc/logstash/conf.d/
COPY GeoLite2-City.mmdb /etc/logstash/
