<?php
header("Content-Type: text/plain");
if (isset($_POST['originfqdn']) && isset($_POST['jspath'])) {
	$originfqdn = $_POST['originfqdn'];
	$ipaddr = gethostbyname ($originfqdn);
	echo "FYI: resolved IP for $originfqdn is $ipaddr\n";
	echo "generating self-signed certificate for $originfqdn \n";
	$gencert = shell_exec('cd ../ssl/certs; ./gencert.sh ' . $originfqdn);
	echo $gencert;
	$upstream_name = "upstream_$originfqdn";
	$jspath = $_POST['jspath'];

	$configblock = "upstream $upstream_name {\n";
	$configblock = $configblock . "  zone $upstream_name 64k;\n";
	$configblock = $configblock . "  server $originfqdn:443 resolve;\n";
	$configblock = $configblock . "}\n";
	$configblock = $configblock . "server {\n";
	$configblock = $configblock . "  server_name $originfqdn;\n";
	$configblock = $configblock . "  listen 443 ssl;\n";
	$configblock = $configblock . "  ssl_dhparam /etc/nginx/ssl/dhparams.pem;\n";
	$configblock = $configblock . "  include /etc/nginx/ssl/sslparams.conf;\n";
	$configblock = $configblock . "  ssl_certificate /etc/nginx/ssl/certs/$originfqdn.crt;\n";
	$configblock = $configblock . "  ssl_certificate_key /etc/nginx/ssl/certs/$originfqdn.key;\n";
	$configblock = $configblock . "  access_log syslog:server=elk:5140,facility=local7,tag=nginx,severity=info didformat_$originfqdn;\n";
	$configblock = $configblock . "  location / {\n";
	$configblock = $configblock . "    sub_filter <head>\n";
	$configblock = $configblock . "    '<head>" . $jspath . "';\n";
	$configblock = $configblock . "    sub_filter_once on;\n";
	$configblock = $configblock . "    proxy_set_header Accept-Encoding \"\";\n";
	$configblock = $configblock . "    proxy_set_header Host \"$originfqdn\";\n";
	$configblock = $configblock . "    proxy_pass https://$upstream_name;\n";
	$configblock = $configblock . "    health_check;\n";
	$configblock = $configblock . "  }\n";
	$configblock = $configblock . "  location /__imp_apg__/ {\n";
	$configblock = $configblock . "    proxy_set_header Host \"dip.zeronaught.com\";\n";
	$configblock = $configblock . "    proxy_pass https://f5deviceid;\n";
	$configblock = $configblock . "  }\n";
	$configblock = $configblock . "}\n";
	$configblock = $configblock . "server {\n";
	$configblock = $configblock . "   server_name  $originfqdn;\n";
	$configblock = $configblock . "   listen 80;\n";
	$configblock = $configblock . "   location / {\n";
	$configblock = $configblock . "    return 301 https://\$host\$request_uri;\n";
	$configblock = $configblock . "   }\n";
	$configblock = $configblock . "}\n";

	if (isset($_POST['logformatspec'])) {
		$logformatblock = $_POST['logformatspec'];
	} else {
		$logformatblock = "log_format didformat_$originfqdn '<190>#\$msec_no_decimal#\$remote_user#$originfqdn#\$remote_addr#12345#\$xff_ip#\$upstream_addr#\$host#\$request_method#\$uri#\$status#nocontentype#0#\$deviceA#\$deviceB#\$http_user_agent#0#empty#';\n";
	}
	
	if (isset($_POST['customlogfields'])) {
		$jscontent = $_POST['customlogfields']; 
	} else {
		$jscontent = "";
	}

	$configfile = "../conf.d/sites/" . $originfqdn . ".conf";
	$logformatfile = "../conf.d/logformat/" . $originfqdn . ".conf";
	$jsfile = "../conf.d/js/" . str_replace(".","",$originfqdn) . ".js";

	echo "----------------------------------------------------\n";
	echo "writting below content to " . $configfile;
	echo "\n";
	echo $configblock;
	file_put_contents($configfile , $configblock);

	echo "----------------------------------------------------\n";
	echo "writting below content to " . $logformatfile;
	echo "\n";
	echo $logformatblock;
	echo "\n\n";
	file_put_contents($logformatfile , $logformatblock);

	echo "----------------------------------------------------\n";
	echo "writting below content to " . $jsfile;
	echo "\n";
	echo $jscontent;
	echo "\n\n";
	file_put_contents($jsfile , $jscontent);
	echo "----------------------------------------------------\n";

	echo "TODO: adding the below line to your /etc/hosts\n";
	echo "18.166.181.249  $originfqdn\n";
	echo "----------------------------------------------------\n\n";
	echo "if the configuration is fine, i'm going to reload nginx config within a minute\n";
	echo "if not please check the debug log at https://seemedemo.com/php/debug.txt\n";
	echo "and take a look at the dashboard as well http://nginxdashboard.seemedemo.com/dashboard.html#upstreams\n";
	echo "contact me if you need help or adding extra config - bien.nguyen@f5.com\n";

} else {
	echo "ERROR: please check your input..";
}

?>

