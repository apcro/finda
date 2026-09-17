<?php
/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
namespace Croissant;

if (!IS_AJAX_REQUEST) {
	if (User::UserType() == 2) {
		$recipient = Finda::GetUserBySefu($args[0], TYPE_MODEL);
		if (isset($args[1]) && is_numeric($args[1])) {
			// client chatting to model about a job
			$job = Jobs::GetJobDetails((int) $args[1]);
			if (!isset($job['models'][$recipient['id']])) {
				header('Location: /projects');
				die();
			}
			Core::Assign('thisjobid', $args[1]);
		}
	} else {
		$recipient = Finda::GetUserBySefu($args[0], TYPE_CLIENT);
	}
} else {
	$recipient = User::LoadUser($modelid);
}

Core::Assign('recipient', $recipient);
Core::Assign('avatar', User::Avatar());
Core::Assign('usertype', User::UserType());

if (IS_AJAX_REQUEST) {
	
	switch($args[0]) {
		case 'delete':
			$result = Notification::DeleteNotification($messageid);
			$messages = Notification::GetComposedNotifications($modelid);
			Core::Assign('messages', $messages);
			Core::Assign('userid', User::UserId());
			$html = Core::Fetch('user/inbox/messages_list.tpl');
			Core::JSONWrite($html);
			die();
			break;
		case 'upload':
			// image or pdf upload
			$imagetype = 'chatAttachment';
			include('user/fileupload.php');
			// we'll have a $response array once this is processed
			Core::JSONWrite($response);
			die();
			break;
	
		case 'update':
			switch($type) {
				case 'chatAttachment':
					$result = Notification::SendComposedImageMessage($modelid, $filename, $message);
					break;
				default:
					$result = Notification::SendComposedMessage($modelid, $message);
					break;
				
			}
			$messages = Notification::GetComposedNotifications($modelid);
			Core::Assign('messages', $messages);
			Core::Assign('userid', User::UserId());
			$html = Core::Fetch('user/inbox/messages_list.tpl');
			Core::JSONWrite($html);
			die();
			break;
	}
}
$messages = Notification::GetComposedNotifications($recipient['id']);
Core::Assign('messages', $messages);

Core::AddCSS('vendor/dropzone/dropzone.css');
Core::AddCSS('model/imageupload.css');
Core::AddCSS('messages.css');


Core::AddJavascript('vendor/dropzone/dropzone.js');
Core::AddJavascript('messages.js');
Core::AddJavascript('msg.js');
$template = 'user/inbox/messaging.tpl';

if (User::UserType() == 2) {
	$projects = Jobs::ClientGetAllJobs($recipient['id']);
} else {
	// slow way
	$projects = array();
	$jobs = Jobs::ModelGetJobs();
	foreach($jobs as $job) {
		if ($job['client_uid'] == $recipient['id']) {
			$projects[] = $job;
		}
	}
}
Core::Assign('projects', array_reverse($projects));

$page_title = 'Chat with '.$recipient['firstname'];