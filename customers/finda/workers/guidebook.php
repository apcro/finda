<?php
/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
namespace Croissant;
if (User::UserID() == 0) {
	header('Location: /');
	die();
}

if (!isset($args[0])) {
	header('Location: /');
	die();
}

$response = ds('wordpress_GetWordpressPost', array('postname' => $args[0]));
if (isset($response['statusCode']) && $response['statusCode'] == 0) {
	
	$template = 'wordpress/post.tpl';
	Core::AddCSS('wordpress.css');
	Core::Assign('body_class', 'body-lightgreen');
	Core::Assign('grid_background', 'grid-bg-white');

	$page_title = $response['result']['post_title'];
	Core::Assign('post_title', $page_title);
	Core::Assign('post_content', $response['result']['post_content']);
} else {
	header('Location: /');
	die();
}