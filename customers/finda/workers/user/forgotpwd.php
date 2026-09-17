<?php
/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
namespace Croissant;
$page_title = 'Forgot Password';
if ($action && $action == 'reset') {
	if (isset($mail) && !empty($mail) && Email::ValidEmail($mail)) {
		$result = User::LoadUserByMail($mail);
		if ($result) {
			if ($result['status'] == 1 || $result['status'] == 0) {
				$reqpwd_userid = $result['id'];
				$reqpwd_username = $result['firstname'];
				$key = User::GenKeyForPwdReset();
				$link_resetpwd = 'https://'.$_SERVER['HTTP_HOST'].'/user/resetpasswd/'.$key['ec_key'];
				
				$response = User::RequestPwdReset($reqpwd_userid, time(), $key['key']);
				if ($response) {
	
					Core::Assign('name', $reqpwd_username);
					Core::Assign('link', $link_resetpwd);
					$html = Core::Fetch('emails/forgot_password.tpl');
					SendGrid::SendPasswordResetEmail($mail, $html);
					
					$template = 'user/forgotpwd_completed.tpl';
				} else {
					$template = 'user/forgotpwd.tpl';
				}
			} else if ($result['status'] == 2) {
				$template = 'user/user_rejected.tpl';
			} else {
				$template = 'user/forgotpwd.tpl';
			}
		} else {
			$template = 'user/forgotpwd.tpl';
		}
	} else {
		$template = 'user/forgotpwd.tpl';
	}
} else {
	$template = 'user/forgotpwd.tpl';
}
Core::AddJavascript('resetpassword.js');