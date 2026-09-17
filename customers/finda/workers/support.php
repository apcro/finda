<?php
/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
namespace Croissant;

$template = 'support.tpl';
$page_title = 'iDAL Support';
Core::AddCSS('support.css');
Core::AddJavascript('support.js');
Core::Assign('body_class', 'body-white');
if ($args[0] == 'call') {
	Core::Assign('subject', "I would like to learn more about iDAL.\n\nName: \n\nEmail: \n\nTelephone: \n\n");
}

if (IS_AJAX_REQUEST) {
	$user = User::LoadUser(user::UserID());
	Core::Assign('user', $user);
	Core::Assign('request', $request);
	$html = nl2br(Core::Fetch('emails/websupportemail.tpl'));
	SendGrid::SendCustomEmail('support@idal.co', 'Web Support Request', $html);
	Core::JSONWrite(true);
	die();
}