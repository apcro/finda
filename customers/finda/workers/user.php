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
		case 'getbyemail':
			if (IS_AJAX_REQUEST) {
				$register_mail = strtolower($email);
				$result = User::LoadUserByMail($register_mail, true);
				Core::JSONWrite($result);
			}
			die();
		case 'register':
			include('user/register.php');
			break;
		case 'login':
			include('user/login.php');
			break;
		case 'resetpasswd':
			include('user/resetpwd.php');
			break;
		case 'forgotpasswd':
			include('user/forgotpwd.php');
			break;
		case 'logout':
			include('user/logout.php');
			break;
		case 'forgot-password':
			include 'user/forgot-password.php';
			break;
		case 'reset-password':
			$reset_key = $secondary;
			Core::Assign('reset_key', $reset_key);
			include 'user/reset-password.php';
			break;
		default:
			header('Location: /');
			die();
	}

} else if (User::UserID() != 0) {

	$secondary = isset($args[1])?$args[1]:null;

	switch($args[0]) {
		case 'getbyemail':
			if (IS_AJAX_REQUEST) {
				$register_mail = strtolower($email);
				$result = User::LoadUserByMail($register_mail, true);
				Core::JSONWrite($result);
			}
			die();
		case 'checkemail':
			$register_mail = strtolower($email);
			$result = User::CheckEmail($register_mail, true);
			Core::JSONWrite((bool)$result);
			die();
			break;
		case 'sendinvite':
			if (IS_AJAX_REUQUEST) {
				if (User::UserType() == TYPE_CLIENT) {
					$invitecode = Companies::CreateInviteCode($email);
					Core::Assign('invitecode',$invitecode);
					Core::Assign('name', User::FirstName().' '.User::Surname());
					Core::Assign('companyname', User::CompanyName());
					$html = Core::Fetch('emails/toclient/invited_to_finda.tpl');
					SendGrid::SendCustomEmail($email, 'You\'ve been invited to join iDAL', $html);
					Core::JSONWrite(true);
				}
			}
			die();
			break;
		case 'requestcompany':
			if (IS_AJAX_REUQUEST) {
				if (User::UserType() == TYPE_CLIENT) {
					Core::Assign('userid', User::UserID());
					Core::Assign('name', User::FirstName().' '.User::Surname());
					Core::Assign('companyname', User::CompanyName());
					$html = nl2br(Core::Fetch('emails/companyrequestemail.tpl'));
					SendGrid::SendCustomEmail('support@idal.co', 'Company Request', $html);
					Core::JSONWrite(true);
					die();
				}
			}
			die();
			break;
		case 'updateavailability':
			$response = Model::UpdateModelAvailability($availability);
			Core::JSONWrite($response);
			die();
			break;
		case 'checkverification':
			$u = User::LoadUser(User::UserID());
			Session::SetVariable('status', $u['status']);
			if ($u['status'] == 1) {
				Core::JSONWrite(true);
			} else {
				Core::JSONWrite(false);
			}
			die();
			break;
		case 'avatar':
			include('user/avatar.php');
			break;
		case 'logout':
			include('user/logout.php');
			break;
		case 'inbox':
			include('user/inbox.php');
			break;
		case 'msg':
			include 'user/msg.php';
			break;
		case 'forgot-password':
			include 'user/forgot-password.php';
			break;
		case 'reset-password':
			$reset_key = $secondary;
			Core::Assign('reset_key', $reset_key);
			include 'user/reset-password.php';
			break;
		case 'updates':
		case 'notifications':
			include 'user/messages.php';
			break;
		case 'dashboard':
			Core::Assign('secondary', $secondary);
			include 'user/dashboard.php';
			break;
		case 'portfolio':
			include 'user/portfolio.php';
			break;
		case 'polaroids':
			include 'user/polaroids.php';
			break;
		case 'experience':
			include 'user/experience.php';
			break;
		case 'calendar':
			include 'user/calendar.php';
			break;
			
		case 'delete':
			include 'user/delete.php';
			break;
		case 'verify':
			include 'user/verify.php';
			break;
		case 'deleteconfirm':
			if (IS_AJAX_REQUEST) {
				// actually set the account to 'disabled';
				$formData = array();
				$formData['status'] = 2;
				User::UpdateUser($formData);
				User::Logout();
				Core::JSONWrite(true);
			}
			die();
			break;
			
		case 'profile':
			if ($secondary == null) {
				$secondary = 'details';
			}
			if ($secondary == 'm') {
				$secondary = 'm.details';
			}
			Core::Assign('secondary', $secondary);
			

			$template = 'user/profile.tpl';
			if (file_exists(BASEPATH.'/workers/user/profile/'.$secondary.'.php')) {
				include 'user/profile/'.$secondary.'.php';
			} else $template = NOTFOUND;
			
			break;
			
		case 'comcard':
			include 'user/comcard.php';
			break;
		default:
			if (User::UserID() != 0) {
				if (User::UserStatus() == 1) {
					if (User::UserType() == TYPE_MODEL) {
						header('Location: /jobs');
					} else if (User::UserType() == TYPE_CLIENT) {
						$redirect = Session::GetVariable('redirect');
						Session::SetVariable('redirect', '');
						if (!empty($redirect)) {
							header('Location: '.$redirect);
						} else {
							header('Location: /search');
						}
					} else if (User::UserType() == TYPE_MOTHERAGENCY) {
						header('Location: /dashboard');
					}
				} else {
					header('Location: /user/verify');
				}
				die();
				
			} else {
				header('Location: /');
				die();
			}
			break;
	}
} else {
	header('Location: /');
	die();
}