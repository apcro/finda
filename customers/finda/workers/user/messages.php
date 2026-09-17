<?php
/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
namespace Croissant;

/*
 * Retrieves notification messages and provides a limited number of pre-determined responses
 * 
 */
if (IS_AJAX_REQUEST) {
	$json = array();
	switch ($args[1]) {
		case 'getnew':
			$unreadcount = Notification::GetNotificationCount('new');
			$json['unread'] = $unreadcount;
			if (User::UserType() == 1) {
				$offerscount = Jobs::GetNewJobsCount();
				$json['offers'] = $offerscount;
			}
			if (User::UserType() == 2) {
				// get number of outstanding invoices
				$invoicecount = Finance::ClientGetUnpaidInvoiceCount(User::UserID());
				$json['invoices'] = $invoicecount;
			}
			break;
		default:
			die();
	}
	Core::JSONWrite($json);
	die();
} else {
	// load the details into the form
	$paging = array();
	if (isset($args[1])) {
		$paging[0] = (int)$args[1];
		$paging[1] = 20;
	}  else {
		$paging[0] = 0;
		$paging[1] = 20;
	}
	$count = Notification::GetNotificationCount('all');
	Core::Assign('count', $count);
	$messages = Notification::GetAllNotifications($paging);
	Core::Assign('messages', $messages);
	Core::Assign('nextpage', $paging[0]+1);
	if ($paging[0] > 0) {
		Core::Assign('prevpage', $paging[0]-1); 
	} else {
		Core::Assign('prevpage', 0);
	}
	Core::Assign('pagelimit', $paging[1]);
	$template = 'user/inbox/notifications.tpl';
	Core::AddJavascript('msg.js');
	$page_title = 'Updates';
	Core::AddCSS('notifications.css');
	Core::Assign('grid_background', 'grid-bg-white');

	if (User::UserType() == TYPE_CLIENT) {
		$companyDetails = User::GetUserCompanyDetails();
		$companymessages = Notification::GetAllCompanyNotifications($companyDetails['id'], array(0,20));
		Core::Assign('companyupdates', $companymessages);
	}

	Core::AddJavascript('messaging.js');
	Core::AddCSS('messaging.css');


}