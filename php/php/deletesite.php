<?php
header("Content-Type: text/plain");
if (isset($_POST['sitename'])) {
    $filename = $_POST['sitename'];
    $jsfile = str_replace(".conf", "", $filename);
    $jsfile = str_replace("-", "", $jsfile);
    $jsfile = str_replace(".", "", $jsfile);
    $logfile = $jsfile . ".conf";
    $jsfile = $jsfile . ".js";

    echo "deleting " . "/etc/nginx/conf.d/sites/" . $filename . "\n";
    unlink("/etc/nginx/conf.d/sites/" . $filename);

    echo "deleting " . "/etc/nginx/conf.d/logformat/" . $logfile . "\n";
    unlink("/etc/nginx/conf.d/logformat/" . $logfile);

    echo "deleting " . "/etc/nginx/conf.d/js/" . $jsfile . "\n";
    unlink("/etc/nginx/conf.d/js/" . $jsfile);  
    echo "DONE";
}
?>

