function doStuff() {

const axios = require('axios');
const now = Date.now();
const last10min = now - 60000
var deviceAs = [];
var deviceBs = [];
var md5 = require('md5');

var queryObj = {
"query": {
    "bool": {
      "must": [
        {
          "terms": {
            "virtual_name": ["ebookserver", "cloeapp" ,"elkserver"]
          }
        },
        {
           "query_string": {
            "query": "(NOT deviceA: NoDID) OR (NOT deviceB: NoDID)"
            }
        },
        {
          "range": {
            "timestamp": {
              "gte": last10min
            }
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

    numofentries = resObj.hits.total.value;
    entries = resObj.hits.hits    
    console.log('Number of entries: ' + numofentries);
    entries.forEach(updateBig);
    function updateBig(item, index, array) {

	    var hashvalA = md5(item._source.deviceA);
	    var hashvalB = md5(item._source.deviceB);

	    if (deviceAs.includes(hashvalA) !== true) {
		    if (  hashvalA !== "b09eb4a04b2e6cde54144d500e49434c" ) {
        		deviceAs.push(hashvalA);
		    }
	    }
            if (deviceBs.includes(hashvalB) !== true) {
                    if (  hashvalB !== "b09eb4a04b2e6cde54144d500e49434c" ) {
                        deviceBs.push(hashvalB);
                    }
            }
    }
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

}

makePostRequest();
}
setInterval(doStuff, 2000); //time is in ms

