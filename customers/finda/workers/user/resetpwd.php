<?php
/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
namespace Croissant;
Core::Assign('body_class', 'body-white');
Core::Assign('grid_background', 'grid-bg-green');
$key = isset($key)? $key : $args[1];
if ($key == ''){
	session_write_close();
	header('Location: /');
	die();
} else {
	Core::Assign('key', $key);
}
$req_key = User::GetKeyForPwdReset($key);
$chk_expire = User::CheckPwdResetExpire($req_key['key']);

if (!$chk_expire) {
	session_write_close();
	header('Location: /user/forgotpasswd');
	die();
} else {
	$res_userid = $chk_expire;
}
$profile = User::LoadUser($res_userid);
if ($action && $action == 'reset') {
	if (isset($mail) && !empty($mail)
	&& isset($passwd1) && !empty($passwd1)
	&& isset($passwd2) && !empty($passwd2)
	&& $passwd1 == $passwd2
	&& Email::ValidEmail($mail)
	&& $profile['mail'] == $mail) {
		$data = array(
			'pwdreset_time' => 0,
			'pwdreset_key'  => '',
			'pass'			=> $passwd1,
			'userid'		=> $res_userid
		);
		$result = User::ResetUserPassword($data);
		
		if ($result) {
			$template = "user/resetpwd_completed.tpl";
		} else {
			Core::Assign('error', 'Password reset incompleted');
			$template="user/resetpwd.tpl";
		}

	} else {
		Core::Assign('error', 'There were problems with the data you entered.');
		$template="user/resetpwd.tpl";
	}
} else {
	$template="user/resetpwd.tpl";
}
Core::AddJavascript('resetpassword.js');