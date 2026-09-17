<?php
/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
namespace Croissant;

if (isset($args[1])) {
	$jobid = $args[1];
}
if (isset($args[2]) && !isset($step)) {
	$step = $args[2];
}

Core::Assign('jobid', $jobid);

$pagemessage = array();

if (isset($step)) {
	$step = strtolower($step);
}

switch($step) {
	case 'getjobcardconfirm':
		$job = Jobs::GetJobDetails($jobid);
		if ($job) {
			$model = User::LoadUser($modelid);
			if ($model) {
				Core::Assign('model', $model);
				Core::Assign('job', $job);
				$template = 'jobs/jobcard_confirm.tpl';
				$html = Core::Fetch($template);
				Core::JSONWrite($html);
			} else {
				Core::JSONWrite(false);
			}
		} else {
			Core::JSONWrite(false);
		}
		die();
	case 'deletejob':
		if (IS_AJAX_REQUEST) {
			$result = Jobs::ClientDeleteJob($jobid, false);
			Core::JSONWrite($result);
			die();
		}
		break;
	case 'searchmodal':
		if (IS_AJAX_REQUEST) {
			if ($jobid == 'open') {
				Session::SetVariable('workflowStep', 'fromeditsearch');
			} else {
				Session::SetVariable('workflowStep', 'editjob');
			}
		}
		die();
		break;
	case 'removemodel':
		if (IS_AJAX_REQUEST) {
			$response = Jobs::RemoveModelFromJob($modelid, $jobid);
			header('Content-Type: application/json; charset=utf-8');
			header('HTTP/1.0 200 OK', 200);
			print json_encode($response);
		}
		die();
		break;
	case 'cancel':
		header('Location: /projects');
		die();
	case 'delete':
		$response = Jobs::ClientDeleteJob($jobid);
		if ($response) {
			Header('Location: /');
			die();
		}
		$pagemessage['message'] = 'Could not delete job';
		$pagemessage['type'] = 'alert';
		$job = Jobs::ClientGetJobDetails($args[1]);
		$job['startdate_formatted'] = date('d-m-Y at H:i', $job['startdate']);
		Core::Assign('job', $job);

		$jobtypes = Taxonomy::GetTermsByVocabulary(1, true);
		Core::Assign('jobtypes', $jobtypes);

		// Custom Javascript elements
		Core::AddJavascript('createjob-form.js');

		// Custom CSS elements

		Core::Assign('pagemessage', $pagemessage);
		$template = 'jobs/edit_job.tpl';
		break;
	case 'update':

		// sanitise the offered rate input
		$offeredrate_input = str_replace('£', '', $offeredrate_input);
		
		// the short way
		$offeredrate_input = str_replace(',', '', $offeredrate_input);
		
		$formdata = array();
		$formdata['id'] = $jobid;
		$formdata['name'] = $name_input;
		$formdata['description'] = $description_input;
		$formdata['location'] = $location_input;
		$formdata['project_tid'] = $jobtype_input;
		$formdata['order_number'] = isset($ordernumber_input)?$ordernumber_input:'';
		
        $offeredrate_input = str_replace('£', '', $offeredrate_input);
        $formdata['offered_rate'] = !empty($offeredrate_input)?$offeredrate_input:0;
        $formdata['units_type'] = !empty($unitstype_input)?$unitstype_input:'';
        $formdata['altrate_unitstype'] = !empty($unitstype_input)?$unitstype_input:'';
		
		$formdata['altrate'] = $altrate_input;
		
		$formdata['time_units'] = !empty($length_input)?$length_input:1;
		$formdata['modelcount'] = !empty($modelcount_input)?$modelcount_input:1;	// set a default when switching from a non-model type
		
		$formdata['startdate'] = strtotime($startdate_input);
		$formdata['starttime'] = strtotime($starttime_input);
		
		$formdata['baseusage'] = $baseusage;
		$formdata['additionalrights'] = $extrarights_input;
		
		$formdata['request_address'] = ($model_address == 'on'?1:0);
		
		if (!empty($sharepass)) {
			$formdata['sharepass'] = $sharepass;
		} else {
			$formdata['sharepass'] = substr(hash('sha512',rand()), 0, 6);
		}
		
		if (!empty($shareuri)) {
			$formdata['shareuri'] = $shareuri;
		} else {
			$formdata['shareuri'] = substr(str_shuffle(str_repeat("0123456789abcdefghijklmnopqrstuvwxyz", 12)), 0, 12);
		}
		
		$advanced = array();
		if ($model_to_bring_check == 'on') $advanced['model_to_bring'] = !empty($model_to_bring)?$model_to_bring:'yes';
		if ($transport_methods_check == 'on') $advanced['transport_methods'] = !empty($transport_methods)?$transport_methods:'yes';
		if ($model_expenses_check == 'on') $advanced['model_expenses'] = !empty($model_expenses)?$model_expenses:'yes';
		if ($model_meeting_point_check == 'on') $advanced['model_meeting_point'] = !empty($model_meeting_point)?$model_meeting_point:'yes';
		if ($makeup_provided_check == 'on') $advanced['makeup_provided'] = !empty($makeup_provided)?$makeup_provided:'yes';
		$advanced['contact_number'] = $contact_number_input;
		$advanced['contact_name'] = $contact_name_input;
		$formdata['advanced'] = $advanced;
		
		$usage = array();
		$usage['uk'] = ($ukrights == 'on'?1:0);
		$usage['europe'] = ($eurights == 'on'?1:0);
		$usage['international'] = ($intrights == 'on'?1:0);
		
		$formdata['usage'] = $usage;
		
		$formdata['usagerights'] = $usagerights;
		
		$response = Jobs::ClientUpdateJob($formdata);
		
	default:
		if ($jobid == 0) {
			header('Location: /');
			die();
		}
		$job = Jobs::GetJobDetails($args[1]);
		if ($job['job_status'] != 0) {
			header('Location: /projects');
			die();
		}
		
		if (!Companies::CanAccessProject($job['id'])) {
			header('Location: /projects');
			die();
		}
		
        $companyDetails = User::GetUserCompanyDetails();
        Core::Assign('companyid', $companyDetails['id']);

		if ($job['sharepass'] == '') {
			$job['sharepass'] = substr(hash('sha512',rand()), 0, 6);
		}
		
		if ($job['shareuri'] == '') {
			$job['shareuri'] = substr(str_shuffle(str_repeat("0123456789abcdefghijklmnopqrstuvwxyz", 12)), 0, 12);
		}
		
		Core::Assign('job', $job);

		$unconfirmed = 0;
		$confirmed = 0;
		$optioned = 0;
		$selected = 0;
		
		// split models into confirmed and unconfirmed
		if (isset($job['models']) && !empty($job['models'])) {
			foreach($job['models'] as $k => $v) {
				if ($v['job_status'] == 1) {
					$unconfirmed++;
				}
				if ($v['job_status'] == 2) {
					$confirmed++;
				}
				if ($v['job_status'] == 10 || $v['job_status'] == 12 || $v['job_status'] == 14 || $v['job_status'] == 15) {
					$optioned++;
				}
				if ($v['job_status'] == 9 || $v['job_status'] == 11) {
					$selected++;
				}
			}
			Core::Assign('confirmed', $confirmed);
			Core::Assign('unconfirmed', $unconfirmed);
			Core::Assign('optioned', $optioned);
			Core::Assign('selected', $selected);
		}

		Core::Assign('models', $job['models']);
		
		if ($job['projectbookingtype'] == 'direct') {
			Core::Assign('directmodel', array_shift($job['models']));
		}
		
		$hairlengths = Taxonomy::GetTermsByVocabulary(5, true);	// hair length VID
		Core::Assign('hairlengths', $hairlengths);
		$hairtypes = Taxonomy::GetTermsByVocabulary(3, true);	// hair types VID
		Core::Assign('hairtypes', $hairtypes);
		$haircolours = Taxonomy::GetTermsByVocabulary(6, true);	// hair colours VID
		Core::Assign('haircolours', $haircolours);
		$eyecolours = Taxonomy::GetTermsByVocabulary(4, true);	// eye colours VID
		Core::Assign('eyecolours', $eyecolours);
		
		$categories = Taxonomy::GetTermsByVocabulary(11, true);	// eye colours VID
		Core::Assign('categories', $categories);
		
		$user_locations = Taxonomy::GetTermsByVocabulary(18, true);	// locations VID
		Core::Assign('user_locations', $user_locations);
		
		$jobtypes = Finda::GetMinimumJobRates(1);
		Core::Assign('jobtypes', $jobtypes);
		
		foreach($jobtypes as $k => $v) {
			if ($v['tid'] == $job['project_tid']) {
				Core::Assign('minhourly', $v['hourly']);
				Core::Assign('mindaily', $v['daily']);
			}
		}
		
		$usagerights = Taxonomy::GetTermsByVocabulary(10, true);
		Core::Assign('usagerights', $usagerights);
		
		if ($job['project_tid'] == 75 || $job['project_tid'] == 78) {
			Core::Assign('jobtype', 'casting');
		} else {
			Core::Assign('jobtype', 'booking');
		}
		

		// Custom Javascript elements
		Core::AddJavascript('vendor/jquery-ui.js');
		Core::AddJavascript('vendor/select2/select2.min.js');
		Core::AddJavascript('vendor/zebra_datepicker.min.js');
		Core::AddJavascript('vendor/clockpicker-gh-pages/dist/jquery-clockpicker.js');
		Core::AddJavascript('vendor/cleave.js');
		Core::AddJavascript('jobs/editjob.js');
		Core::AddJavascript('vendor/awesomplete.min.js');
		Core::AddJavascript('jobedit_search.js');

		// Custom CSS elements
		Core::AddCSS('vendor/jquery-ui.css');
		Core::AddCSS('vendor/zebra/zebra_datepicker.css');
		Core::AddCSS('vendor/jquery-clockpicker.css');
		Core::AddCSS('select2.min.css');
		Core::AddCSS('vendor/awesomplete.css');
		Core::AddCSS('search.css');
		Core::AddCSS('jobedit.css');
		Core::AddCSS('jobcard.css');
		
		Core::Assign('pagemessage', $pagemessage);
		
		$searchparameters = Core::LoadVariableByKey('searchsettings', '{"gender":"female","age":["18","60"],"height":["165","200"],"bustsize":["74","142"],"waistsize":["55","124"],"hipsize":["78","150"],"shoesize":["2","14"],"collarsize":["35","55"],"dresssize":["2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","18","17","18","19","20","21","22"],"suitsize":["36","37","38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53","54"]}');

		// adding new data
		$params = json_decode($searchparameters);
		
		if (!isset($params->suitsize)) {
			$params->suitsize = array("36","37","38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53","54");
		}
		if (!isset($params->collarsize)) {
			$params->collarsize = array("35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55");
		}
		
		if (!isset($params->waistsize)) {
			$params->waistsize = array(55, 124);
		}
		
		if (!isset($params->hipsize)) {
			$params->hipsize = array(50, 150);
		}
		
		if (!isset($params->dresssizes)) {
			$params->dresssizes = array((int) current($params->dresssize), end($params->dresssize));
		}
		if (!isset($params->suitsizes)) {
			$params->suitsizes = array((int) current($params->suitsize), end($params->suitsize));
		}
		if (!isset($params->cupsizes)) {
			$params->cupsizes = array('AA', 'A', 'B', 'C', 'D', 'DD', 'E', 'F', 'FF', 'G', 'H', 'HH', 'I', 'J', 'JJ', 'K');
		}
		
		if (!isset($params->followercounts)) {
			$params->followercounts = array('0', '5k', '10k', '15k', '20k', '25k', '30k', '35k', '40k', '45k', '50k', '55k', '60k', '65k', '70k', '75k', '80k', '85k', '90k', '95k', '100k', '200k', '300k', '400k', '500k', '600k', '700k', '800k', '900k', '1m');
		}
		
		// used by smarty template
		$params->collarsizes = array((int) current($params->collarsize), end($params->collarsize));
		
		$searchparameters = json_encode($params);
		Core::Assign('parameters', $searchparameters);
		Core::Assign('smartyparams', (array) $params);
		
		$searchsettings = Session::GetVariable('searchsettings');
		
		if (empty($searchsettings)) {
			$searchsettings = $searchparameters;
			Session::SetVariable('searchsettings', $searchsettings);
		} else {
			$settings = json_decode($searchsettings, true);
			$recode = false;
			if (empty($settings['height'])) {
				$settings['height'] = array(165, 190);
				$recode = true;
			}
			if (empty($settings['boardtype'])) {
				$settings['boardtype'] = 'all';
				$recode = true;
			}
			if (empty($settings['sortorder'])) {
				$settings['sortorder'] = 'all';
				$recode = true;
			}
			if ($recode) {
				$searchsettings = json_encode($settings);
			}
		}
		Core::Assign('searchsettings', $searchsettings);
		
		
		Core::Assign('jobcount', 1); // to hide the notice - since we're editing there's at least one job

		$template = 'jobs/edit_job.tpl';
		
		$page_title = 'Edit project: '.$job['name'];
		
		// we need some workflow handling
		// at this point we have a 'back' for search that needs to come back to this project, with the models page open
		Session::SetVariable('workflowData', $job);
		Session::SetVariable('workflowStep', 'editjob');
		
		// and some share handling so we can test properly in various environments
		if (isset($_SERVER["HTTPS"]) && $_SERVER["HTTPS"] == "on") {
			$method = 'https';
		} else {
			$method = 'http';
		}
		Core::Assign('method', $method);
		
		Core::Assign('body_class', 'body-white');
		Core::Assign('grid_background', 'grid-bg-white-green');
		
		$modelnames = Finda::LoadAllModelNames();
		Core::Assign('searchnames', json_encode($modelnames));

		break;
}
