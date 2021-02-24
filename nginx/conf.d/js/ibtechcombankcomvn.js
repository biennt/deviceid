function techcomuName(r) {
    var host = r.headersIn['Host'];
    var requestText = r.requestText;
    var techcomuName = "empty";
    var method = r.method;
    var uri = r.uri;
    var tmparr1, tmparr2, tmpstr;
    if (host === "ib.techcombank.com.vn") {
      if ((method === "POST") && (uri === "/servlet/BrowserServlet")) {
        tmparr1 = requestText.split("&");
        tmpstr = tmparr1[6];
        tmparr2 = tmpstr.split("=");
        techcomuName = String(decodeURIComponent(tmparr2[1]));
      }
    }
    return techcomuName;
}
export default {techcomuName};
