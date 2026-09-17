<?php
/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
namespace Croissant;

$template = 'podcast/podcast.tpl';
$html = Core::Fetch($template);
header("Content-type: text/xml");
echo $html;
die();
