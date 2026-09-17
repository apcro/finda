<?php
/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
namespace Croissant;

if (User::UserType() == TYPE_CLIENT) {
	header('Location: /');
	die();
}


switch($args[1]) {
	case 'toggle':
		$userDetails = array();
		$userDetails['available'] = $available;
		$response = User::UpdateUser($userDetails);
		die();
		break;
	case 'addSchedule':
		$response = Model::AddScheduleItem($schedule);
		die();
		break;
	case 'removeSchedule':
		$response = Model::RemoveScheduleItem($scheduleid);
		die();
		break;
	case 'updateSchedule':
		$response = Model::UpdateScheduleItem($schedule);
		die();
		break;
	default:

		Model::RefreshSchedule();
		
		$cal = Model::GetModelSchedule();
		Core::Assign('schedules', json_encode($cal, JSON_FORCE_OBJECT));
		
		Core::AddJavascript('vendor/moment.js');
		Core::AddJavascript('vendor/chance.min.js');
		Core::AddJavascript('vendor/tui-code-snippet.js');
		Core::AddJavascript('vendor/tui-time-picker.js');
		Core::AddJavascript('vendor/tui-date-picker.js');
		Core::AddJavascript('vendor/tui.calendar-master/tui-calendar.js');
		Core::AddJavascript('calendar.js');
		Core::AddCSS('tui-calendar.css');
		Core::AddCSS('tui-date-picker.css');
		Core::AddCSS('tui-time-picker.css');
		Core::AddCSS('vendor/calendar_icons.css');
		Core::AddCSS('calendar.css');
		Core::Assign('userAvailable', User::UserAvailable());
		$template = 'user/calendar.tpl';
		$page_title = 'Availability';
		Core::Assign('body_class', 'body-blue');
		Core::Assign('grid_background', 'grid-bg-white');
		Core::Assign('secondary', 'calendar');
		break;
}