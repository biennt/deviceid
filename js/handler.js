function deviceA(r) {
  var didcookies, didcookiestext, didcookiestextarr, didcookiestextarrLen, item, deviceA, obj;
  didcookies = r.headersIn['Cookie'];
  didcookiestext = String(decodeURIComponent(didcookies));
  didcookiestextarr = didcookiestext.split(";");
  didcookiestextarrLen = didcookiestextarr.length;
  deviceA = "NoDID";
  for (var i = 0; i < didcookiestextarrLen; i++) {
    if (didcookiestextarr[i].includes('_imp_apg_r_')) {
      item = didcookiestextarr[i].split("=");
      obj = JSON.parse(item[1]);
      deviceA = String(obj.diA);
    }
  }
  return deviceA;
}

function deviceB(r) {
  var didcookies, didcookiestext, didcookiestextarr, didcookiestextarrLen, item, deviceB, obj;
  didcookies = r.headersIn['Cookie'];
  didcookiestext = String(decodeURIComponent(didcookies));
  didcookiestextarr = didcookiestext.split(";");
  didcookiestextarrLen = didcookiestextarr.length;
  deviceB = "NoDID";
  for (var i = 0; i < didcookiestextarrLen; i++) {
    if (didcookiestextarr[i].includes('_imp_apg_r_')) {
      item = didcookiestextarr[i].split("=");
      obj = JSON.parse(item[1]);
      deviceB = String(obj.diB);
      if (deviceB.includes('undefined')) {
        deviceB = "NoDID";
      }
    }
  }
 return deviceB;
}

// getting X-Forwarded-For from the HTTP request header
// if not found, will take client_ip as xff_ip
function xff_ip(r) {
  var xff_header, xff_ip;
  xff_ip = r.remoteAddress;
  xff_header = r.headersIn['X-Forwarded-For'];
  if (xff_header) {
    xff_ip = xff_header;
  }
 return xff_ip;
}

export default {deviceA, deviceB, xff_ip};
