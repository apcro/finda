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
	$act = $secondary;
	switch($act) {
		case 'flagmessage':
			$message = Notification::LoadNotificationDetails($msgid); // this will load a deleted notification as well
			Notification::UpdateNotificationType($msgid, 5);	// mark it as flagged as well
			Core::Assign('message', $message);
			Core::Assign('name', User::FirstName().' '.User::Surname());
			$client = User::LoadUser($message['sender']);
			Core::Assign('client', $client);
			$modelid = User::UserID();
			Core::Assign('modelid', $modelid);
			$html = Core::Fetch('emails/modelflaggedmessage.tpl');
			SendGrid::SendCustomEmail('support@idal.co', 'A model flagged a received message', $html);
			Core::JSONWrite(true);
			break;
		case 'confirmmodel':
			$msg = Notification::LoadNotificationDetails($msgid);
			if ($msg) {
				// confirm the model for this job
				$response = Jobs::ClientUpdateModelForJob($msg['jobid'], $msg['recipient'], 1);
				$json = array();
				$json['status'] = $response;
				if ($response) {
					$model = User::LoadUser($msg['recipient']);
					$job = Jobs::GetJobDetails($msg['jobid']);
					$json['html'] = '<div class="row"><div class="column">'.$model['firstname'].' '.$model['lastname'].' has been confirmed for '.$job['name'].'</div></div>';
				}
				Core::JSONWrite($json);
			}
			break;
		case 'acceptrate':
			$msg = Notification::LoadNotificationDetails($msgid);
			if ($msg) {
				$result = Jobs::ClientAcceptRate($msg['jobid'], $msg['sender']);
				if ($result) {
					Notification::SendRateAcceptance($msg['jobid'], $msg['sender']);
					SendGrid::SendClientAcceptRate($msg['jobid'], $msg['sender']);
					Notification::DeleteNotification($msgid);
					Core::JSONWrite(true);
				} else {
					Core::JSONWrite(false);
				}
			}
			break;
		
		case 'rejectrate':
			$msg = Notification::LoadNotificationDetails($msgid);
			if ($msg) {
				$result = Notification::SendRateRejection($msg['jobid'], $msg['sender']);
				SendGrid::SendClientDeclineRate($msg['jobid'], $msg['sender']);
				Notification::DeleteNotification($msgid);
				Core::JSONWrite(true);
			} else {
				Core::JSONWrite(false);
			}
			break;

		case 'updaterate':
			$msg = Notification::LoadNotificationDetails($msgid);
			$result = Jobs::ClientUpdateRate($msg['jobid'], $msg['sender'], $rate);
			if ($result) {
				Notification::DeleteNotification($msgid);
				Core::JSONWrite(true);
			} else {
				Core::JSONWrite(false);
			}
			break;
			
		case 'rejectremove':
			$msg = Notification::LoadNotificationDetails($msgid);
			$result = Jobs::RemoveModelFromJob($msg['sender'], $msg['jobid']);
			if ($result) {
				$result = Notification::SendRateRejectionRemove($msg['jobid'], $msg['sender']);
				Notification::DeleteNotification($msgid);
				Core::JSONWrite(true);
			} else {
				Core::JSONWrite(false);
			}
			break;
	
		case 'delete':
			$result = Notification::DeleteNotification($msgid);
			if ($result) {
				Core::JSONWrite(true);
			} else {
				Core::JSONWrite(false);
			}
			break;
	}
	die();
} else {
	header('Location: /');
	die();
}