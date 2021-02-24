<?php
print_header();
print_newsite_form();
echo "<hr>\n";
print_manage_site();
print_footer();

#####################################################
function print_newsite_form() {
	$jspath = '<script async defer src="https://dip.zeronaught.com/__imp_apg__/js/f5cs-a_aabz35oIkM-6b92a1c3.js" id="_imp_apg_dip_"  ></script>';
	echo "<b>To create a new site, input your site detail:</b><br><br>\n";
	echo "<form method='POST' action='./createsite.php'>\n";
	echo "Original FQDN: <input type='text' name='originfqdn' value='ib.techcombank.com.vn' size=50><br><br>\n";
	echo "JS Snippet to insert: <br>(you may need to replace <i>dip.zeronaught.com</i> with your own FQDN to avoid Content-Security-Policy warning)<br>\n";
	echo "<input type='text' name='jspath' value='" . $jspath . "' size=150><br><br>\n";
	echo "<input type='submit'><br><br>\n";
	echo "Log format specification:<br>\n";
	echo "(if you don't want to log username or other stuff, just need to change the FQDN accordingly)<br>\n";
	echo "<textarea name='logformatspec' rows='6' cols='250'>\n";
	echo "#js_import /etc/nginx/conf.d/js/ibtechcombankcomvn.js;\n";
	echo "#js_set \$techcomuName ibtechcombankcomvn.techcomuName;\n";
	echo "#log_format didformat_ib.techcombank.com.vn '<190>#\$msec_no_decimal#\$techcomuName#ib.techcombank.com.vn#\$remote_addr#12345#\$xff_ip#\$upstream_addr#\$host#\$request_method#\$uri#\$status#nocontentype#0#\$deviceA#\$deviceB#\$http_user_agent#0#empty#';\n";
	echo "log_format didformat_ib.techcombank.com.vn '<190>#\$msec_no_decimal#\$remote_user#ib.techcombank.com.vn#\$remote_addr#12345#\$xff_ip#\$upstream_addr#\$host#\$request_method#\$uri#\$status#nocontentype#0#\$deviceA#\$deviceB#\$http_user_agent#0#empty#';\n";
	echo "</textarea>\n<br><br>\n";

	echo "JavaScript to log other fields such as username:<br>\n";
	echo "(the sample below is how you can collect username from a form-based POST login)<br>\n";
	echo "<textarea name='customlogfields' rows='30' cols='100'>\n";
	echo "function techcomuName(r) {\n";
	echo "    var host = r.headersIn['Host'];\n";
	echo "    var requestText = r.requestText;\n";
	echo "    var techcomuName = \"empty\";\n";
	echo "    var method = r.method;\n";
	echo "    var uri = r.uri;\n";
	echo "    var tmparr1, tmparr2, tmpstr;\n";
	echo "    if (host === \"ib.techcombank.com.vn\") {\n";
	echo "      if ((method === \"POST\") && (uri === \"/servlet/BrowserServlet\")) {\n";
	echo "        tmparr1 = requestText.split(\"&\");\n";
	echo "        tmpstr = tmparr1[6];\n";
	echo "        tmparr2 = tmpstr.split(\"=\");\n";
	echo "        techcomuName = String(decodeURIComponent(tmparr2[1]));\n";
	echo "      }\n";
	echo "    }\n";
	echo "    return techcomuName;\n";
	echo "}\n";
	echo "export default {techcomuName};\n";
    echo "</textarea>\n";
	echo "</form>\n";
}

#####################################################
function print_header() {
	echo "<!DOCTYPE html>\n";
	echo "<html lang=\"en\">\n";
	echo "  <head>\n";
	echo "<meta charset=\"utf-8\">\n";
	echo "  <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">\n";
	echo "  </head>\n";
	echo "  <body>\n";
	echo "<br>\n";
}

#####################################################
function print_footer(){
	echo "</body>\n";
	echo "</html>\n";
}
#####################################################
function print_manage_site(){
	echo "<b>Below is the list of existing site's configs:</b><br><br>\n";
	$dir = "../conf.d/sites";
	$filearr = scandir($dir);
	foreach ($filearr as $i) {
	  if(strpos($i, ".conf") !== false) {
            echo "<form method='POST' action='./deletesite.php'>\n";
	    echo $i . "\n";
	    echo "<input type='hidden' name='sitename' value='" . $i . "'>\n";
	    echo "<input type='submit' value='delete'><br>";
	    echo "</form>\n";
	  }
	}
}
?>

