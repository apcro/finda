<?php
/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
namespace Croissant;

// logged out
if (User::UserID() == 0) {
	switch($args[0]) {
		case 'team':
			include('m/team.php');
			break;
		case 'register':
			include('m/register.php');
			break;
		case 'enquire':
			include('m/enquire.php');
			break;
		case 'welcome':
			Core::Assign('body_class', 'body-white');
			$template = 'mobile/welcome.tpl';
			break;
		default:
			header('Location: /');
			die();
	}
} else if (User::UserID() != 0) {
	switch($args[0]) {
		case 'team':
			include('m/team.php');
			break;
		case 'loggedin':
			include('m/loggedin.php');
			break;
		case 'welcome':
			Core::Assign('body_class', 'body-white');
			$template = 'mobile/welcome.tpl';
			break;
		default:
			header('Location: /');
			die;
	}
} else {
	header('Location: /');
	die();
}