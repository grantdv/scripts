#!/usr/bin/php -q

<?
function dir_size($dir)
{
   $handle = opendir($dir);
   
   while ($file = readdir($handle)) {
       if ($file != '..' && $file != '.' && !is_dir($dir.'/'.$file)) {
           $mas += filesize($dir.'/'.$file);
           } else if (is_dir($dir.'/'.$file) && $file != '..' && $file != '.') {
           $mas += dir_size($dir.'/'.$file);
       }
   }
   return $mas;
}
echo dir_size('DIRECTORIO').' Bytes';
?>
