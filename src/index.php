<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" dir="ltr" lang="en">
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
  <title>Space Tools</title>
</head>
<body>
<h1>Space Tools</h1>
<?php

$d = @dir('.') or die("getFileList: Failed opening directory $dir for reading");

while(false !== ($entry = $d->read())) {
  // skip hidden files
  if($entry[0] == ".") continue;
  if(is_dir("$entry")) {
    echo '<a href="/'.$entry.'">'.$entry.'</a><br>';
  }
}
$d->close();

?>
</body>
</html>
