<?php
/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
/**
 * Serves cached CSS & JS files passed in as parameters
 *
 * If requested cache file does not exist, returns a 404
 *
 */
namespace Croissant;

if (empty($args[0])) die();

$type = isset($args[0])?$args[0]:'';
$file = isset($args[1])?$args[1]:'';

if (empty($file)) die();

switch($type) {
    case 'css':
        $contenttype = 'text/css';
        break;
    case 'js':
        $contenttype = 'text/javascript';
        break;
    default:
        die();
}
$tplHeaders   = array();
$tplHeaders[] = 'HTTP/1.0 404 Not Found';
$filesize=0;
if ($file != '') {
	$filename = CACHE_PATH.'/'.$file;
	if (file_exists($filename)) {
		$fp = fopen($filename, 'r');
		$filesize = filesize($filename);
		$tplHeaders   = array();
		$tplHeaders[] = 'HTTP/1.0 200 OK';
		$tplHeaders[] = 'Expires: Mon, 26 Jul 1997 05:00:00 GMT';
		$tplHeaders[] = 'Last-Modified: ' . date('D, d M Y H:i:s', time()) . ' GMT';
		$tplHeaders[] = 'Cache-Control: public';
		$tplHeaders[] = 'Content-Type: '.$contenttype;
		$tplHeaders[] = 'Content-Length: '.@urldecode($filesize);

	}
}

ob_end_clean();
foreach($tplHeaders as $header) {
	header($header);
}
if ($filesize > 0) {
	while (!feof($fp)) {
		echo fread($fp, (1*(1024*1024)));
		@flush();
		@ob_flush();
	}
	fclose($fp);
}
die();