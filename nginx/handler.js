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
export default {deviceA, deviceB};

