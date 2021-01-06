function doStuff() {
const axios = require('axios');
const now = Date.now();
const last10min = now - 6000000
var deviceAs = [];
var deviceBs = [];
var md5 = require('md5');

var queryObj = {
 "aggs": {
    "2": {
      "terms": {
        "field": "xff_ip.keyword",
        "order": {
          "1": "desc"
        },
        "size": 5
      },
      "aggs": {
        "1": {
          "cardinality": {
            "field": "deviceA.keyword"
          }
        }
      }
    }
  },
  "size": 0,
  "stored_fields": [
    "*"
  ],
  "script_fields": {},
  "docvalue_fields": [
    {
      "field": "@timestamp",
      "format": "date_time"
    }
  ],
  "_source": {
    "excludes": []
  },
  "query": {
    "bool": {
      "must": [],
      "filter": [
        {
          "match_all": {}
        },
        {
          "range": {
            "@timestamp": {
              "gte": last10min
            }
          }
        }
      ],
      "should": [],
      "must_not": [
        {
          "bool": {
            "minimum_should_match": 1,
            "should": [
              {
                "match_phrase": {
                  "deviceA.keyword": "NoDID"
                }
              },
              {
                "match_phrase": {
                  "deviceA.keyword": "-"
                }
              },
              {
                "match_phrase": {
                  "deviceA.keyword": "undefined"
                }
              }
            ]
          }
        },
        {
          "bool": {
            "minimum_should_match": 1,
            "should": [
              {
                "match_phrase": {
                  "deviceB.keyword": "NoDID"
                }
              },
              {
                "match_phrase": {
                  "deviceB.keyword": "-"
                }
              },
              {
                "match_phrase": {
                  "deviceB.keyword": "undefined"
                }
              }
            ]
          }
        }
      ]
    }
  }
}

async function makePostRequest() {

    let res = await axios.post('http://localhost:9200/logstash-devid*/_search?size=1000', queryObj);

    console.log(`Status code: ${res.status}`);
    console.log(`Status text: ${res.statusText}`);
    console.log(`Path: ${res.request.path}`);
    resObj = res.data;

    entries1 = resObj.aggregations;    
    entries2= entries1["2"];
    entries= entries2.buckets;

    entries.forEach(updateBig);
    function updateBig(item, index, array) {
      clientip = item.key
      countdid1 = item["1"];
      countdid = countdid1.value
      console.log(clientip)
      console.log(countdid)
    }
	/*
    for (var i = 0; i < deviceAs.length; i++) {
	 const axiosbig = require('axios');
         axiosbig.get('http://172.31.4.133:8888/insert?type=A&key=' + deviceAs[i]).then(resp => {
         console.log(resp.data);
         });
    }
    for (var i = 0; i < deviceBs.length; i++) {
     	 const axiosbig = require('axios');
         axiosbig.get('http://172.31.4.133:8888/insert?type=B&key=' + deviceBs[i]).then(resp => {
         console.log(resp.data);
         });
    }
    console.log("Number of entries in BIG-IP: ");
    const axiosbigcount = require('axios');
    axiosbigcount.get('http://172.31.4.133:8888/count').then(resp => {
    console.log(resp.data);
    });
*/
}

makePostRequest();

}
setInterval(doStuff, 2000); //time is in ms
