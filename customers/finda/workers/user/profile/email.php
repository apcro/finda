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
 * User Profile Email controller
 *
 *
 */

#JS For validate
Core::AddJavascript('jquery/plugins/jquery.validateNew.js');
Core::AddJavascript('edit_email.js');

# template for my settings name
$template = 'user/profile.email.tpl';

//Load data
$user = new user();

$userdetails = User::LoadUser($userid);
Core::Assign('field', $userdetails);
$mail = $userdetails['mail']; //Old email from database

// after click change email submit button
if(isset($submit)) {

	# check user submit form come from host
	if(strstr(Session::GetVariable('urisecure'), '/user/profile/email')){
		header('Location:/');
		die();
	}

	# default msg = array,status = string [error|notice]
	$msg['data'] = array();
	$msg['status'] = 'error';

	# valid field error
	$valid = array('email'=>array('status'=>0,'message'=>''),
					'password'=>array('status'=>0,'message'=>''));

	# validation
	if(!isset($txt_email) || empty($txt_email)){
		$msg['data'][0] = $MESSAGE['profNoticeForgotFill'];
		$valid['email'] = array('status'=>1,'message'=>$MESSAGE['profNoticeNoFill']);
	}else {
		# check format e-mail
		if(!isset($msg['data'][0]))
		if(!User::ValidEmail($txt_email)){
			$msg['data'][0] = $MESSAGE['profNoticeEmailIncomplete'];
			$valid['email'] = array('status'=>1,'message'=>$MESSAGE['profNoticeRecheckField']);
		} else {
			# check e-mail address duplicate
			if (($mail != $txt_email) && User::GetUserMail($txt_email)){
				$msg['data'][0] = $MESSAGE['profNoticeEmailDuplicate'];
				$valid['email'] = array('status'=>1,'message'=>$MESSAGE['profNoticeRecheckField']);
			}
		}
	}
	if((!isset($txt_password) || empty($txt_password)) && !isset($msg['data'][0])){
		$msg['data'][0] = $MESSAGE['profNoticeForgotFill'];
		$valid['password'] = array('status'=>1,'message'=>$MESSAGE['profNoticeNoFill']);
	}else {
		$pass = $userdetails['pass']; // Password from database
		$txt_pass = md5($txt_password); // Password from input
		if ($pass != $txt_pass) {
			$msg['data'][0] = $MESSAGE['profNoticeOldPassIncomplete'];
			$valid['password'] = array('status'=>1,'message'=>$MESSAGE['profNoticeOldPassIncompleteShort']);
		}
	}
	# store value
	$field['mail'] = $txt_email;
	$field['pass'] = $txt_password;

	# validate pass
	if (!isset($msg['data'][0]))
	{
		// Password correct
		if ($mail != $txt_email){
			$data['mail'] = $txt_email;
			// Update new email (if new email not dup)
			$result = User::UpdateUser($userid,$data);
			if($result){
				# if register complete redirect to profile
				header("Location: /user/profile?status_code=0&act=display_notice&notify_code=profileThanks");
				die();
			} else {
				# if register not complete will notification to user
				$msg['data'][0] = $MESSAGE['profNoticeProcIncomplete'];
			}
		}else {
			// if new email == old email
			header("Location: /user/profile?status_code=0&act=display_notice&notify_code=profileThanks");
			die();
		}
	}
	# var for message
	Core::Assign('field',$field);
	Core::Assign('msg',$msg);
	Core::Assign('valid',$valid);

} elseif(isset($submit_contact)) {// after click change contact submit button

	# check user submit form come from host
	if(strstr(Session::GetVariable('urisecure'), '/user/profile/email')){
		header('Location:/');
		die();
	}

	# store value
	$field['contact'] = $chk_contact;

	if(!isset($chk_contact) || empty($chk_contact)){
		$field['contact'] = 0 ;
	}

	$userdetails['data']['contact'] = $field['contact'];

	// Update contact
	$result = User::UpdateUser($userid,array('data'=>$userdetails['data']));

	if($result){
		# if association complete redirect to profile
		header("Location: /user/profile?status_code=0&act=display_notice&notify_code=profileThanks");
		die();
	} else {
		# if association not complete will notification to user
		$msg['data'][0] = $MESSAGE['profNoticeProcIncomplete'];
	}
} else {
	# use for check submit form
	if(!Session::GetVariable('urisecure')){
		Session::SetVariable('urisecure',md5($_SERVER['REQUEST_URI']));
	}
}