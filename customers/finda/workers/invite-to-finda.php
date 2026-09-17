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
	if (!empty($name) && !empty($mail)) {
		$response = SendGrid::SendReferrerEmail($name, $mail, User::UserID());
		if ($response) {
		    SendGrid::SendReferrerEmailSent($name, User::UserID());
			$json = true;
		}
	} else {
		$json = false;
	}
	Core::JSONWrite($json);
} else {
	if (DEBUG) {
		
		$model = User::LoadUser(1);
		
		// well, SendGrid's template failed, so...
		Core::Assign('subject', $model['firstname'].' '.$model['lastname'].' invited you to join a booking platform for models!');
		Core::Assign('model', $model);
		$html = Core::Fetch('emails/referrer_email.tpl');
		print($html);
		die();
	}
	
}
die();