function doStuff() {

const axios = require('axios');
const now = Date.now();
const last10min = now - 60000;
var deviceBs = [];
var langpref = [];
var md5 = require('md5');

var queryObj = {
  "aggs": {
    "2": {
      "terms": {
        "field": "deviceB.keyword",
        "order": {
          "1": "desc"
        },
        "size": 10
      },
      "aggs": {
        "1": {
          "sum": {
            "script": {
              "source": "if (doc['http_request_uri.keyword'].value == '/eng') {\n    return 1;\n} else {\n    return 0;\n}",
              "lang": "painless"
            }
          }
        },
        "3": {
          "sum": {
            "script": {
              "source": "if (doc['http_request_uri.keyword'].value == '/vie') {\n    return 1;\n} else {\n    return 0;\n}",
              "lang": "painless"
            }
          }
        }
      }
    }
  },
  "size": 0,
  "stored_fields": [
    "*"
  ],
  "script_fields": {
    "deviceID": {
      "script": {
        "source": "doc['deviceB.keyword'].value+doc['deviceB.keyword'].value",
        "lang": "painless"
      }
    },
    "english": {
      "script": {
        "source": "if (doc['http_request_uri.keyword'].value == '/eng') {\n    return 1;\n} else {\n    return 0;\n}",
        "lang": "painless"
      }
    },
    "vie": {
      "script": {
        "source": "if (doc['http_request_uri.keyword'].value == '/vie') {\n    return 1;\n} else {\n    return 0;\n}",
        "lang": "painless"
      }
    }
  },
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
          "multi_match": {
            "type": "best_fields",
            "query": "ybaonline.com/",
            "lenient": true
          }
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
      "must_not": []
    }
  }
}          
async function makePostRequest() {

    let res = await axios.post('http://localhost:9200/logstash-devid*/_search?size=1000', queryObj);

    console.log(`ELK code: ${res.status}`);
    resObj = res.data;
    aggs = resObj.aggregations['2'];
    entries = aggs.buckets;
    entries.forEach(updateBig);
    function updateBig(item, index, array) {
	    var hashvalB = md5(item.key);
	    console.log(item.key);
	    var eng = item['1'].value;
	    var vie = item['3'].value;
	    var preflang = 0; // debug
	    if (vie > eng) { 
               console.log('Vietnamese');
	       preflang = 1;
	    } else {
               console.log('English');
	       preflang = 2;
	    }

            if (deviceBs.includes(hashvalB) !== true) {
                deviceBs.push(hashvalB);
                langpref.push(preflang);
            }

    }
    for (var i = 0; i < deviceBs.length; i++) {
      const axiosbig = require('axios');
      axiosbig.get('http://172.31.4.133:8888/insert?type=L&key=' + deviceBs[i] + '&value=' + langpref[i]).then(resp => {
         console.log(resp.data);
      });
    }
}


makePostRequest();
}
setInterval(doStuff, 2000); //time is in ms

