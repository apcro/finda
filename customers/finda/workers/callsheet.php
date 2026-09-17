<?php
/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
namespace Croissant;

if (User::UserType() != TYPE_CLIENT && !IS_AJAX_CALL) {
	header('Location: /user');
	die();
}
switch($args[0]) {
	case 'query':
		if (IS_AJAX_REQUEST) {
			$job = Jobs::GetJobDetails($jobid);
			$json = false;
			if (isset($job['models'][User::UserID()])) {
				$json = true;
			}
			Core::JSONWrite($json);
			die();
		}
	case 'upload':
		if ($_FILES['callsheet']['type'] == 'application/pdf') {
			if (empty($_FILES) && !empty($jobid)) {
				$template = 'jobs/callsheet_nofile.tpl';
			} else {
				$filename = File2::Upload(DOCROOT.'/callsheets');
				if (isset($filename['errorMessage'])) {
					// error
				} else {
					// store the details against the jobid
					$response = ds('jobs_ClientAddCallsheetToJob', array('jobid' => $jobid, 'callsheet' => str_replace(DOCROOT, '', $filename['newname'])));
					if (isset($response['statusCode']) && $response['statusCode'] == 0) {
						// sends to all models associated with the job
						Notification::SendClientAddedCallsheet($jobid);
					}
				}
				Session::SetVariable('notificationpopup', 'Callsheet uploaded');
				header('Location: /projects');
				die();
			}
		} else {
			Core::Assign('banner_title', 'Upload callsheet for:');
			$job = Jobs::GetJobDetails($jobid);
			Core::Assign('job', $job);
			Core::Assign('body_class', 'body-white');
			Core::Assign('grid_background', 'grid-bg-white');
			Core::Assign('jobid', $jobid);
			$template = 'jobs/callsheet_nofile.tpl';
			Core::AddCSS('jobcard.css');
		}
		
		
		break;
	default:
		if (!empty($args[0])) {
			// show the default set of portfolio
			$job = Jobs::GetJobDetails($args[0]);
			Core::Assign('job', $job);
			$models = $job['models'];
			foreach($models as $k => $v) {
				$names[] = $v['firstname'];
			}
			Core::Assign('modelnames', join(' and ', array_filter(array_merge(array(join(', ', array_slice($names, 0, -1))), array_slice($names, -1)), 'strlen')));
			$template = 'jobs/callsheet.tpl';
			$page_title = 'Upload callsheet';
			Core::Assign('banner_title', 'Upload callsheet for:');
			Core::Assign('body_class', 'body-white');
			Core::Assign('grid_background', 'grid-bg-white');
			Core::AddCSS('jobcard.css');
		} else {
			header('location: /');
			die();
		}
		break;
}
