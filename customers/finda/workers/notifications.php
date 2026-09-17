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
	$json = array();
	$json['result'] = false;
	// handle composed messaging
	$result = Notification::SendComposedMessage($recipient, $message);
	$json['result'] = $result;
	if ($result) {
		$messages = Notification::GetComposedNotifications($recipient);
		Core::Assign('messages', $messages);
		Core::Assign('userid', User::UserID());
		$html = Core::Fetch('user/inbox/messages_list.tpl');
		$json['html'] = Core::Fetch('user/inbox/messages_list.tpl');
	}
	
	Core::JSONWrite($json);
	die();
} else {
	$args = array();
	$args[0] = 'notifications';
	include('user.php');
}