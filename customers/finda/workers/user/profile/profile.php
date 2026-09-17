<?php
/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
namespace Croissant;
/**
 * User Profile controller
 *
 */

# use text global
include 'msg/global.php';

# user id
$userid = User::UserID();

# sub action
$sub_action = array_shift($args);

switch($sub_action) {
	case 'name':
		include 'user/profile/name.php';
		break;
	case 'email':
		include 'user/profile/email.php';
		break;
	case 'username':
		include 'user/profile/username.php';
		break;
	case 'password':
		include 'user/profile/password.php';
		break;
	case 'aboutme':
		include 'user/profile/aboutme.php';
		break;
	case 'avatar':
		include 'user/profile/avatar.php';
		break;
	case 'address':
		include 'user/profile/address.php';
		break;
	default:
		$user_data = User::LoadUser($userid);
		Core::Assign('user_data',$user_data);
		
		$template = 'user/profile.tpl';
		break;
}
