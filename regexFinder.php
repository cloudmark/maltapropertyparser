<?php
$subject = file_get_contents($argv[1]); 
$pattern = $argv[2];
preg_match($pattern,$subject,$matches, PREG_OFFSET_CAPTURE);
print $matches[0][0]; 
?>
