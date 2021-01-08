function doStuff() {

const axios = require('axios');
const now = Date.now();
const last10min = now - 60000;
var deviceBs = [];
var langpref = [];
var md5 = require('md5');
var maxUserPerDevice = 50;

var queryObj = {
	"aggs": {
    "2": {
      "terms": {
        "field": "deviceB.keyword",
        "order": {
          "1": "desc"
        },
        "size": 5
      },
      "aggs": {
        "1": {
          "cardinality": {
            "field": "uName.keyword"
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

    console.log(`ELK code: ${res.status}`);
    resObj = res.data;
    aggs = resObj.aggregations['2'];
    entries = aggs.buckets;
    entries.forEach(updateBig);
    function updateBig(item, index, array) {
	    var hashvalB = md5(item.key);
	    var numberofusername = item['1'].value;
	    console.log('DeviceID ' + item.key);
	    console.log('Number of username ' + numberofusername);
            if (numberofusername > maxUserPerDevice) {
	    	console.log('Block this device please')
	        const axiosslack = require('axios');
		const slackToken = 'removed';
		run().catch(err => console.log(err));
		async function run() {
    		const url = 'https://slack.com/api/chat.postMessage';
    		const res = await axiosslack.post(url, {
      		  channel: '#notifications',
      		  username: 'alerts',
      		  icon_emoji: ':+1:',
      		  text: 'Hey, ' + numberofusername + ' of different usernames are accessing your app from this SINGLE deviceID (didB) ' + item.key +'.\nIf you want to block, send a GET request to http://lockit.bienlab.com:8888/insert?type=K&key='+hashvalB+'\n' + 'I will block that device shortly',
    		}, { headers: { authorization: `Bearer ${slackToken}` } });
    		console.log('Done', res.data);
  		}
	    }

    }
}


makePostRequest();
}
setInterval(doStuff, 2000); //time is in ms

