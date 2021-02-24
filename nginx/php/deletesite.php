<?php
header("Content-Type: text/plain");
if (isset($_POST['sitename'])) {
    $filename = $_POST['sitename'];
    $jsfile = str_replace(".conf", "", $filename);
    $jsfile = str_replace(".", "", $jsfile) . ".js";

    echo "deleting " . "../conf.d/sites/" . $filename . "\n";
    unlink("../conf.d/sites/" . $filename);

    echo "deleting " . "../conf.d/logformat/" . $filename . "\n";
    unlink("../conf.d/logformat/" . $filename);

    echo "deleting " . "../conf.d/js/" . $jsfile . "\n";
    unlink("../conf.d/js/" . $jsfile);  
    echo "DONE";
}
?>

