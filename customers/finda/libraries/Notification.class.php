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
 *
 */
class Notification extends Core {

	static $core;

	/**
	 *
	 */
	public static function Initialise() {
		if (!isset(self::$core)) {
			self::$core = parent::Initialise();
		}

		return self::$core;
	}

	// information notifications
	
	// retrieves notifications for the curently logged-in user
	public static function GetNewNotifications() {
		$response = ds('notifications_GetNotifications', array('type' => 'new'));
		return genericResponse($response);
	}
	
	public static function GetAllNotifications($paging = array()) {
		$response = ds('notifications_GetNotifications', array('type' => 'all', 'usertype' => User::UserType(), 'paging' => $paging));
		return genericResponse($response);
	}

	public static function GetComposedNotifications($modelid, $paging = array()) {
		$response = ds('notifications_GetComposedNotifications', array('modelid' => $modelid, 'paging' => $paging));
		return genericResponse($response);
	}
	
	public static function GetAllCompanyNotifications($companyid, $paging = array()) {
		$response = ds('notifications_GetCompanyNotifications', array('type' => 'all', 'companyid' => $companyid, 'paging' => $paging));
		return genericResponse($response);
	}
	
	
	public static function GetNotificationCount($type = 'new') {
		$response = ds('notifications_GetNotificationCount', array('type' => $type));
		return genericResponse($response, 0);
	}

	public static function GetNotificationCountForUser($uid, $type = 'new') {
		$response = ds('notifications_GetNotificationCountForUser', array('uid' => $uid, 'type' => $type));
		return genericResponse($response, 0);
	}
	
	public static function DeleteNotification($msgid) {
		$response = ds('notifications_DeleteNotification', array('msgid' => $msgid));
		return genericResponse($response);
	}

	// action notifications

	public static function SendRateCounterOffer($jobid, $rate, $reasons = '') {
		$job = Jobs::GetJobDetails($jobid);
		Core::Assign('job', $job);
		Core::Assign('newrate', $rate);
		Core::Assign('firstname', User::FirstName());
		Core::Assign('lastname', User::Surname());
		Core::Assign('company_name', User::CompanyName());
		
		// this is a negotiation, not a rejection. Vocabulary = 17
		if (!empty($reasons)) {
			$terms = Taxonomy::GetTermsByVocabulary(17);
			$reasons = explode(',', $reasons);
			$reasonText = array();
			foreach($terms as $k => $term) {
				if (in_array($k, $reasons)) {
					$reasonText[] = strtolower($term['name']);
				}
			}
			
			$msgText = join(' and ', array_filter(array_merge(array(join(', ', array_slice($reasonText, 0, -1))), array_slice($reasonText, -1)), 'strlen'));
			
			Core::Assign('reasons', array('count' => count($reasonText), 'text' => ucfirst($msgText)));
		}
		
		$template = 'notifications/counteroffer.tpl';
		$message = Core::Fetch($template);
		$response = ds('notifications_SendNotification', array('senderid' => User::UserID(), 'recipientid' => $job['client_uid'], 'jobid' => $jobid, 'message' => $message, 'type' => MESSAGE_TYPE_NEGOTIATE));
		
		return genericResponse($response);
	}
	
	public static function SendRateAcceptance($jobid, $modelid) {
		$job = Jobs::GetJobDetails($jobid);
		Core::Assign('job', $job);
		Core::Assign('firstname', User::FirstName());
		Core::Assign('lastname', User::Surname());
		Core::Assign('company_name', User::CompanyName());
		$template = 'notifications/acceptrate.tpl';
		$message = Core::Fetch($template);
		$response = ds('notifications_SendNotification', array('senderid' => User::UserID(), 'recipientid' => $modelid, 'jobid' => $jobid, 'message' => $message, 'type' => MESSAGE_TYPE_ACCEPT));
		self::SendPushMessage($modelid, 'Your proposed rate was accepted! \uD83E\uDD29 Make sure to confirm your job now!');
		
		// email?
		
		return genericResponse($response);
	}
	
	public static function SendRateRejection($jobid, $modelid) {
		$job = Jobs::GetJobDetails($jobid);
		Core::Assign('job', $job);
		Core::Assign('firstname', User::FirstName());
		Core::Assign('lastname', User::Surname());
		Core::Assign('company_name', User::CompanyName());
		$template = 'notifications/rejectrate.tpl';
		$message = Core::Fetch($template);
		$response = ds('notifications_SendNotification', array('senderid' => User::UserID(), 'recipientid' => $modelid, 'jobid' => $jobid, 'message' => $message, 'type' => MESSAGE_TYPE_REJECT));
		self::SendPushMessage($modelid, 'Oops! A client declined your negotiated rate, and the job is still pending \uD83E\uDD14');
		return genericResponse($response);
	}
	
	public static function SendRateRejectionRemove($jobid, $modelid) {
		$job = Jobs::GetJobDetails($jobid);
		Core::Assign('job', $job);
		Core::Assign('firstname', User::FirstName());
		Core::Assign('lastname', User::Surname());
		Core::Assign('company_name', User::CompanyName());
		$template = 'notifications/rejectrateremove.tpl';
		$message = Core::Fetch($template);
		$response = ds('notifications_SendNotification', array('senderid' => User::UserID(), 'recipientid' => $modelid, 'jobid' => $jobid, 'message' => $message, 'type' => MESSAGE_TYPE_REJECT));
		self::SendPushMessage($modelid, 'Oops! A client declined your negotiated rate, and have cancelled the job offer \uD83D\uDE41');
		return genericResponse($response);
	}
	
	public static function SendClientUpdateRate($jobid, $modelid, $rate) {
		$job = Jobs::GetJobDetails($jobid);
		Core::Assign('job', $job);
		Core::Assign('firstname', User::FirstName());
		Core::Assign('lastname', User::Surname());
		Core::Assign('rate', $rate);
		Core::Assign('company_name', User::CompanyName());
		$template = 'notifications/updaterate.tpl';
		$message = Core::Fetch($template);
		$response = ds('notifications_SendNotification', array('senderid' => User::UserID(), 'recipientid' => $modelid, 'jobid' => $jobid, 'message' => $message, 'type' => MESSAGE_TYPE_NEGOTIATE));
		
		SendGrid::SendClientUpdateRateEmail($jobid, $modelid);
		self::SendPushMessage($modelid, 'A client has proposed a different rate');
		
		return genericResponse($response);
	}
	
	public static function SendJobOffer($jobid, $modelid, $rate) {
		if (self::CanSendMessage($modelid, 'job_offered')) {
			$job = Jobs::GetJobDetails($jobid);
			Core::Assign('job', $job);
			Core::Assign('firstname', User::FirstName());
			Core::Assign('lastname', User::Surname());
			Core::Assign('rate', $rate);
			Core::Assign('company_name', User::CompanyName());
			if ($job['bookingtype'] == 'casting') {
				$template = 'notifications/castingoffer.tpl';
			} else {
				$template = 'notifications/joboffer.tpl';
			}
			$message = Core::Fetch($template);
			$response = ds('notifications_SendNotification', array('senderid' => User::UserID(), 'recipientid' => $modelid, 'jobid' => $jobid, 'message' => $message, 'type' => MESSAGE_TYPE_OFFER));
			SendGrid::SendNewBookingEmail($modelid, $jobid);
			if ($job['bookingtype'] == 'casting') {
				self::SendPushMessage($modelid, 'Yay! You have a new '.$job['jobtype_name'].' request! \uE312');
			} else {
				self::SendPushMessage($modelid, 'Yay! You have a new job request! \uE312');
			}
			return genericResponse($response);
		}
	}
	
	public static function SendPaymentComplete($invoicedetails) {
		if (self::CanSendMessage(User::UserID(), 'payment_made')) {
			$job = Jobs::GetJobDetails($invoicedetails['jobid']);
			$invoicedetails['jobname'] = $job['name'];
			$invoicedetails['jobdescription'] = $job['description'];
			Core::Assign('invoice', $invoicedetails);
			Core::Assign('firstname', User::FirstName());
			Core::Assign('lastname', User::Surname());
			$template = 'notifications/paymentmade.tpl';
			$message = Core::Fetch($template);
			$response = ds('notifications_SendNotification', array('senderid' => User::UserID(), 'recipientid' => $invoicedetails['clientid'], 'jobid' => $invoicedetails['jobid'], 'message' => $message, 'type' => MESSAGE_TYPE_PAYMENT));
			SendGrid::SendModelInvoicePaid($invoicedetails['jobid']);
			self::SendPushMessage($modelid, 'You have received payment for the '.$job['name'].' job \uD83D\uDCB0');
			return genericResponse($response);
		}
	}
	
	// model sends
	public static function SendJobAcceptance($jobid) {
		$job = Jobs::GetJobDetails($jobid);
		Core::Assign('job', $job);
		Core::Assign('firstname', User::FirstName());
		Core::Assign('lastname', User::Surname());
		Core::Assign('modelid', User::UserID());
		$template = 'notifications/acceptoffer.tpl';
		$message = Core::Fetch($template);
		$response = ds('notifications_SendNotification', array('senderid' => User::UserID(), 'recipientid' => $job['client_uid'], 'jobid' => $jobid, 'message' => $message, 'type' => MESSAGE_TYPE_ACCEPT));
		return genericResponse($response);
	}
	
	public static function SendJobRejection($jobid, $reasons = '') {
		$job = Jobs::GetJobDetails($jobid);
		Core::Assign('job', $job);
		Core::Assign('firstname', User::FirstName());
		Core::Assign('lastname', User::Surname());
		Core::Assign('modelid', $modelid);
		Core::Assign('rate', $rate);
		
		// this is a rejection, not a negotiation. Vocabulary = 16
		if (!empty($reasons)) {
			$terms = Taxonomy::GetTermsByVocabulary(16);
			$reasons = explode(',', $reasons);
			$reasonText = array();
			foreach($terms as $k => $term) {
				if (in_array($k, $reasons)) {
					$reasonText[] = strtolower($term['name']);
				}
			}
			
			$msgText = join(' and ', array_filter(array_merge(array(join(', ', array_slice($reasonText, 0, -1))), array_slice($reasonText, -1)), 'strlen'));
			
			Core::Assign('reasons', array('count' => count($reasonText), 'text' => ucfirst($msgText)));
		}
		
		
		
		$template = 'notifications/rejectoffer.tpl';
		$message = Core::Fetch($template);
		$response = ds('notifications_SendNotification', array('senderid' => User::UserID(), 'recipientid' => $job['client_uid'], 'jobid' => $jobid, 'message' => $message, 'type' => MESSAGE_TYPE_REJECT));
		return genericResponse($response);
	}
	
	public static function SendOptionRejection($jobid) {
		$job = Jobs::GetJobDetails($jobid);
		Core::Assign('job', $job);
		Core::Assign('firstname', User::FirstName());
		Core::Assign('lastname', User::Surname());
		Core::Assign('modelid', $modelid);
		$template = 'notifications/rejectoption.tpl';
		$message = Core::Fetch($template);
		$response = ds('notifications_SendNotification', array('senderid' => User::UserID(), 'recipientid' => $job['client_uid'], 'jobid' => $jobid, 'message' => $message, 'type' => MESSAGE_TYPE_REJECT_OPTION));
		return genericResponse($response);
	}
	
	public static function SendJobCancelAcceptance($jobid) {
		$job = Jobs::GetJobDetails($jobid);
		Core::Assign('job', $job);
		Core::Assign('firstname', User::FirstName());
		Core::Assign('lastname', User::Surname());
		$template = 'notifications/cancelacceptance.tpl';
		$message = Core::Fetch($template);
		$response = ds('notifications_SendNotification', array('senderid' => User::UserID(), 'recipientid' => $job['client_uid'], 'jobid' => $jobid, 'message' => $message, 'type' => MESSAGE_TYPE_CANCELACCEPTANCE));
		return genericResponse($response);
	}
	
	public static function SendJobCancellation($jobid) {
		$job = Jobs::GetJobDetails($jobid);
		if ($job['startdate'] > time()) {
			if (isset($job['models'])) {
				foreach($job['models'] as $k => $model) {
					if (self::CanSendMessage($model['id'], 'job_cancelled') && $model['job_status'] == 2) {
						// only if the model has accepted or been confirmed
						if ($model['job_status'] == 2 || $model['job_status'] == 14) {
							Core::Assign('job', $job);
							Core::Assign('firstname', User::FirstName());
							Core::Assign('lastname', User::Surname());
							Core::Assign('modelid', $model['id']);
							Core::Assign('company_name', User::CompanyName());
							$template = 'notifications/canceloffer.tpl';
							$message = Core::Fetch($template);
							$response = ds('notifications_SendNotification', array('senderid' => User::UserID(), 'recipientid' =>  $model['id'], 'jobid' => $jobid, 'message' => $message, 'type' => MESSAGE_TYPE_CANCEL));
							SendGrid::SendBookingCancelledEmail($model['id'], $jobid);
							self::SendPushMessage($model['id'], 'We are sorry... Your job request was cancelled \uD83D\uDE41');
						}
					}
				}
			}
			return true;
		}
		return false;
	}
	
	
	public static function SendJobCancelModel($jobid, $modelid) {
		$job = Jobs::GetJobDetails($jobid);
		Core::Assign('job', $job);
		Core::Assign('firstname', User::FirstName());
		Core::Assign('lastname', User::Surname());
		Core::Assign('modelid', $modelid);
		Core::Assign('company_name', User::CompanyName());
		$template = 'notifications/canceloffer.tpl';
		$message = Core::Fetch($template);
		$response = ds('notifications_SendNotification', array('senderid' => User::UserID(), 'recipientid' =>  $modelid, 'jobid' => $jobid, 'message' => $message, 'type' => MESSAGE_TYPE_CANCEL));
		return true;
	}
	
	public static function SendJobComplete($jobid, $modelid) {
		$job = Jobs::GetJobDetails($jobid);
		Core::Assign('job', $job);
		Core::Assign('firstname', User::FirstName());
		Core::Assign('lastname', User::Surname());
		Core::Assign('modelid', $modelid);
		$template = 'notifications/jobcompleted.tpl';
		$message = Core::Fetch($template);
		$response = ds('notifications_SendNotification', array('senderid' => User::UserID(), 'recipientid' => $modelid, 'jobid' => $jobid, 'message' => $message, 'type' => MESSAGE_TYPE_COMPLETE));
		return genericResponse($response);
	}
	
	public static function SendClientAddedCallsheet($jobid) {
		$job = Jobs::GetJobDetails($jobid);
		Core::Assign('job', $job);
		Core::Assign('firstname', User::FirstName());
		Core::Assign('lastname', User::Surname());
		$template = 'notifications/callsheetadded.tpl';
		$message = Core::Fetch($template);
		
		foreach($job['models'] as $modelid => $model) {
			if ($model['job_status'] == 2) {	// model accepted
				$response = ds('notifications_SendNotification', array('senderid' => User::UserID(), 'recipientid' => $modelid, 'jobid' => $jobid, 'message' => $message, 'type' => MESSAGE_TYPE_ADDED_CALLSHEET));
				SendGrid::SendModelNewCallsheet($jobid, $modelid);
				self::SendPushMessage($modelid, 'A callsheet is now available to download for your upcoming job '.$job['name'].' \uD83D\uDCCB');
			}
		}
		return true;
	}
	
	public static function SendModelJobConfirmed($jobid, $modelid) {
		
		$job = Jobs::GetJobDetails($jobid);
		Core::Assign('job', $job);
		Core::Assign('firstname', User::FirstName());
		Core::Assign('lastname', User::Surname());
		Core::Assign('modelid', $modelid);
		Core::Assign('company_name', User::CompanyName());
		$template = 'notifications/confirmoffer.tpl';
		$message = Core::Fetch($template);
		$response = ds('notifications_SendNotification', array('senderid' => User::UserID(), 'recipientid' =>  $modelid, 'jobid' => $jobid, 'message' => $message, 'type' => MESSAGE_TYPE_CONFIRMED));
		self::SendPushMessage($modelid, 'Your job has been confirmed');
		return true;
		
	}
	
	public static function LoadNotificationDetails($noteid) {
		$response = ds('notifications_LoadNotificationDetails', array('noteid' => $noteid));
		return genericResponse($response);
	}
	
	public static function UpdateNotificationType($msgid, $typeid) {
		$response = ds('notifications_UpdateNotificationType', array('msgid' => $msgid, 'typeid' => $typeid));
		return genericResponse($response);
	}
	
	public static function CanSendMessage($uid, $preference) {
		$u = User::LoadUser($uid);
		$cansend = true;
		if ($u['prefs'][$preference] == 0) {
			$cansend = false;
		}
		return $cansend;
	}
	
	public static function SendPushMessage($uid, $message) {
// 		if (!DEBUG) {
			$deviceToken = User::GetDeviceToken($uid);
			if ($deviceToken) {
				$count = self::GetNotificationCountForUser($uid, 'new');
				if ($count) {
					$badge = $count;
				} else {
					$badge = '';
				}
// 				if (!LOCALDEV) {
					FCM::SendPushMessage($deviceToken['deviceToken'], $message, $badge);
// 				}
			}
// 		}
	}
	
	public static function SendComposedMessage($recipient, $message, $jobid = 0) {
		$response = ds('notifications_SendNotification', array('senderid' => User::UserID(), 'recipientid' =>  $recipient, 'jobid' => $jobid, 'message' => $message, 'type' => MESSAGE_TYPE_COMPOSED));
		// if the sender is a Client, send a push message to the recipient (model)
		if (isset($response['statusCode']) && $response['statusCode'] == 0) {
			if (User::UserType() == TYPE_CLIENT) {
				$companyName = User::CompanyName();
				if (!empty($companyName)) {
					$message = 'You have received a new message from '.$companyName;
				} else {
					$message = 'You have received a new message';
				}
				self::SendPushMessage($recipient, $message);

				// we also want to send an email to the recipient
				SendGrid::SendNewMessageEmail($response['result']);	// we send based on the messageID
				
				// override the returned response
				$response['result'] = true;
			}
		}
		return genericResponse($response);
	}

	public static function SendComposedImageMessage($recipient, $imageurl, $message) {
		$response = ds('notifications_SendNotification', array('senderid' => User::UserID(), 'recipientid' =>  $recipient, 'jobid' => 0, 'message' => $message, 'type' => MESSAGE_TYPE_COMPOSED_IMAGE, 'subject' => $imageurl));
		if (isset($response['statusCode']) && $response['statusCode'] == 0) {
			if (User::UserType() == TYPE_CLIENT) {
				$companyName = User::CompanyName();
				if (!empty($companyName)) {
					$message = 'You have received a new message from '.$companyName;
				} else {
					$message = 'You have received a new message';
				}
				self::SendPushMessage($recipient, $message);
				
				// we also want to send an email to the recipient
				SendGrid::SendNewMessageEmail($response['result']);	// we send based on the messageID
				
				// override the returned response
				$response['result'] = true;
			}
		}
		return genericResponse($response);
	}

	public static function SendComposedPDFMessage($recipient, $fileurl, $jobid = 0) {
		$response = ds('notifications_SendNotification', array('senderid' => User::UserID(), 'recipientid' =>  $recipient, 'jobid' => 0, 'message' => $fileurl, 'type' => MESSAGE_TYPE_COMPOSED_PDF));
		return genericResponse($response);
	}
	
	
	public static function FlagMessage($messageid, $reason) {
		$response = ds('notifications_UpdateNotificationType', array('msgid' => $msgid, 'typeid' => MESSAGE_TYPE_COMPOSED_FLAGGED));
		// send email to support@ with the details
		$message = self::LoadNotificationDetails(messageid);
		$u = User::LoadUser(User::UserID());
		Core::Assign('message', $message);
		Core::Assign('reason', $reason);
		Core::Assign('user', $u);
		$html = nl2br(Core::Fetch('emails/modelflaggedmessage.tpl'));
		SendGrid::SendCustomEmail('support@idal.co', 'Model Flagged Message', $html);
		
		return genericResponse($response);
	}
	

}
