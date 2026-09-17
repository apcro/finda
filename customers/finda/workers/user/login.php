<?php
/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
namespace Croissant;

if (IS_AJAX_REQUEST) {
	$json = false;
	$data = User::Login($email, $pass, isset($remember) ? $remember : FALSE);
	if ($data) {
		$json = true;
	}
	Core::JSONWrite($json);
	die();
} else {
	if (User::UserID() != 0) {
		header('Location: /');
		die();
	}
	
	$template = 'user/login.tpl';
	$page_title = 'Log in';
	Core::Assign('body_class', 'bg-white');
	if (isset($submit) && $submit == 'Log in') {
		$data = User::Login($mail_input, $password_input, isset($remember) ? $remember : FALSE);

		if (!$data) {
			Core::Assign('message', 'error');
		} else {
			header('Location: /m/loggedin');
			die();
		}
	}
}