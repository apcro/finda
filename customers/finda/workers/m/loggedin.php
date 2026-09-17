<?php
/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
namespace Croissant;

//redirect if user is not logged in
if (User::UserID() == 0) {
	header('Location: /');
	die();
}

if (User::UserStatus() == 1) {
	$template = 'mobile/m.loggedin.tpl';
} else {
	$template = 'mobile/m.verify.tpl';
}
Core::Assign('usertype', User::UserType());
$page_title = 'Welcome to iDAL';
Core::AddCSS('m.loggedin.css');
$u = User::LoadUser(User::UserID());
Core::Assign('kycdoc', $u['originalname']);