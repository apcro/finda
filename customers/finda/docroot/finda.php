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
 * Customer-specific code to be used just prior to display rendering. Can be completely blank.
 * The filename must exactly match (including case) the "customer" folder name.
 *
 * Typically used to handle logged-in/logged-out variations
 */

Core::Assign('userid', User::UserID());
Core::Assign('userType', User::UserType());
Core::Assign('usertype', User::UserType());
Core::Assign('userStatus', User::UserStatus());
Core::Assign('userstatus', User::UserStatus());

/* ****************************************************************************************************
* Load user toolbar data
* only needed if we get to the display stage
******************************************************************************************************/
if (User::UserID() != 0) {

	if (!DEBUG) {
		$user_session = User::GetSessionID(User::UserID());
		// and a check
		if (User::$core->_user['sessionid'] != $user_session) {
			Session::SetVariable('logoutmessage', 'You have logged in to iDAL from another computer, so this session has been ended.');
			User::Logout(true);	// local session only
			header('location: /');
			die();
		}
	}

	if (DEBUG) $point_timer[] = array('Start Userdata', microtime(TRUE));

	// fill in some of the personalisation stuff
	Core::Assign('username', User::Username());
	Core::Assign('firstname', User::FirstName());
	Core::Assign('surname', User::Surname());
	Core::Assign('is_founding_member', Core::$core->_user['is_founding_member']);
	Core::Assign('gender', Core::$core->_user['gender']);
	Core::Assign('user_avatar', User::Avatar());
	Core::Assign('user_status', User::UserStatus());
	Core::Assign('default_avatar', DEFAULT_AVATAR);
	Core::Assign('referrer_code', User::ReferrerCode());

	if (User::UserType() == 1) {
		// get model offers count
		$offerscount = Jobs::GetNewJobsCount();
		Core::Assign('newoffers', $offerscount);

		// get payments count
		Core::Assign('new_payments', 0);
	}
	// load messages count
	Core::AddJavascript('user/msgpoller.js');

	$canVerify = User::CanVerify();
	if (!$canVerify) {
		$verifyFails = User::VerifyFails();
	}
	Core::Assign('canverify', $canVerify);
	Core::Assign('verifyfails', join(' and ', array_filter(array_merge(array(join(', ', array_slice($verifyFails, 0, -1))), array_slice($verifyFails, -1)), 'strlen')));


	$unreadcount = Notification::GetNotificationCount('new');
	if (DEBUG) $point_timer[] = array('Got inbox count', microtime(TRUE));
	Core::Assign('unread_messages', $unreadcount);
	if (DEBUG) $point_timer[] = array('End user data', microtime(TRUE));

	/* ****************************************************************************************************
	* user tracking
	******************************************************************************************************/
	if (DEBUG) $point_timer[] = array('Storing page tracking', microtime(TRUE));

	if (DEBUG) $point_timer[] = array('Getting notifications', microtime(TRUE));

	// any alert messages sent through?
	$notification = Session::GetVariable('notification');
	$notificationbad = Session::getVariable('notificationbad');
	Core::Assign('notification', $notification);
	Core::Assign('notificationbad', $notificationbad);
	Session::SetVariable('notification', '');
	Session::SetVariable('notificationbad', '');

	/* ****************************************************************************************************
	* Footer content
	******************************************************************************************************/
	if (DEBUG) $point_timer[] = array('Got footer taxonomy', microtime(TRUE));

} else {

	// set up data for the marketing site

}