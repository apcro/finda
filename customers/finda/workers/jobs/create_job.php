<?php
/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
namespace Croissant;

if (User::UserType() == TYPE_MODEL) {
	header('Location: /');
	die();
}


// form validation

switch($step) {
	case 'validate':
		if (IS_AJAX_REQUEST) {
			
		}
		die();
	case 'wizardcreate':
	case 'create':
		$rate_input = str_replace('£', '', $modelsubtotal);
		$rate_input = str_replace(',', '', $rate_input);
		$formdata = array();
		$formdata['name'] = $name_input;
		$formdata['description'] = $description_input;
		$formdata['location'] = $location_input;
		$formdata['project_tid'] = $jobtype_input;
		$formdata['offered_rate'] = !empty($rate_input)?$rate_input:0; // must be a number, comes with a prefix
		$formdata['altrate'] = '';
		$formdata['time_units'] = !empty($length_input)?$length_input:1;
		$formdata['units_type'] = !empty($unitstype_input)?$unitstype_input:'day';
		$formdata['modelcount'] = str_replace(',', '', $modelcount_input);
		$formdata['startdate'] = strtotime($startdate_input);
		$formdata['starttime'] = strtotime($starttime_input);
		
		$formdata['sharepass'] = substr(hash('sha512',rand()), 0, 6);	// 6 character simple password
		$formdata['shareuri'] = substr(str_shuffle(str_repeat("0123456789abcdefghijklmnopqrstuvwxyz", 12)), 0, 12);
		
		$formdata['request_address'] = ($model_address == 'on'?1:0);
		
		$usage = array();
		$usage['uk'] = ($baseusage == 'ukrights'?1:0);
		$usage['europe'] = ($baseusage == 'eurights'?1:0);
		$usage['international'] = ($baseusage == 'intrights'?1:0);
		
		// the basic usage types
		$formdata['baseusage'] = $period;
		$formdata['extrarights'] = $extrarights_input;
		
		// this goes into the job_rights table
		$formdata['usage'] = $usage;

		// the individual taxonomy rights
		if ($formdata['project_tid'] == 12) {
			$usagerights[] = 63;
		}
		$formdata['usagerights'] = $usagerights;
		
		$advanced = array();
		if ($model_to_bring_check == 'on') $advanced['model_to_bring'] = $model_to_bring;
		if ($transport_methods_check == 'on') $advanced['transport_methods'] = $transport_methods;
		if ($model_expenses_check == 'on') $advanced['model_expenses'] = $model_expenses;
		if ($model_meeting_point_check == 'on') $advanced['model_meeting_point'] = $model_meeting_point;
		if ($makeup_provided_check == 'on') $advanced['makeup_provided'] = $makeup_provided;
		$advanced['contact_number'] = $contact_number_input;
		$advanced['contact_name'] = $contact_name_input;
		$formdata['advanced'] = $advanced;
		
		$formdata['_post'] = $_POST;
		
		if (!empty($formdata['name']) && !empty($formdata['description']) && !empty($formdata['location'])) {
			$response = Jobs::ClientCreateJob($formdata);
	
			if ($response != false) {
				Session::SetVariable('message', 'Project created');
			} else {
				Session::SetVariable('errormessage', 'Sorry, there was a problem creating your project.');
			}
			
			if ($step == 'wizardcreate' && $response != false) {
				header('Location: /projects/edit/'.$response.'#models');
			} else {
				header('Location: /projects');
			}
		} else {
			Session::SetVariable('errormessage', 'Sorry, there was a problem creating your project.');
			header('Location: /projects');
		}
		die();

		break;
	case 'option':
		
		$formdata = array();
		$formdata['name'] = $name_input;
		$formdata['description'] = $description_input;
		$formdata['location'] = $location_input;
		$formdata['project_tid'] = $jobtype_input;
		$formdata['offered_rate'] = !empty($rate_input)?$rate_input:100;
		$formdata['time_units'] = !empty($length_input)?$length_input:1;
		$formdata['units_type'] = $unitstype_input;
		$formdata['modelcount'] = $modelcount_input;
		$formdata['startdate'] = strtotime($startdate_input);
		$formdata['starttime'] = strtotime($starttime_input);
		
		$response = Jobs::ClientCreateJob($formdata);

		if ($response !== false) {
			header('Location: /projects/edit/'.$response.'#models');
			die();
		} else {
			header('Location: /projects');
			die();
		}
		break;
	case 'cancel':
		header('Location: /projects');
		die();
	case 'createform':
		if (IS_AJAX_REQUEST) {
			$json = array('steps' => 0, 'html' => '');
			switch($jobtype) {
				case 'casting':
					$json['html'] = '<div style="padding: 2em; max-width: 40em;"><div class="row"><div class="column"><h2>This feature is coming soon.</h2></div></div>';
					$json['html'] .= '<div class="row"><div class="column"><p>To book it now, simply choose "<b>Book models</b>", set the project type to "<b>casting</b>" and fill in the relevant details. Alternatively, email support@idal.co</p></div></div></div>';
					$json['steps'] = 6;
					$json['html'] = Core::Fetch('jobs/wizard3/create_casting.tpl');
					break;
				case 'booking':
					$jobtypes = Finda::GetMinimumJobRates(1);
					Core::Assign('jobtypes', $jobtypes);
					
					$usagerights = Taxonomy::GetTermsByVocabulary(10, true);
					Core::Assign('usagerights', $usagerights);
					
					$json['steps'] = 10;
					$json['html'] = Core::Fetch('jobs/wizard3/create_booking.tpl');
					break;

				default:
					$json['html'] = '<div style="padding: 2em; max-width: 40em;"><div class="row"><div class="column"><h2>This feature is coming soon.</h2></div></div>';
					break;
			}
			Core::JSONWrite($json);
			die();
		}
		break;
	default:
		
		// Custom Javascript elements
		Core::AddJavascript('vendor/jquery-ui.js');
		Core::AddJavascript('vendor/select2/select2.min.js');
		Core::AddJavascript('vendor/zebra_datepicker.min.js');
		Core::AddJavascript('vendor/clockpicker-gh-pages/dist/jquery-clockpicker.js');
		Core::AddJavascript('vendor/cleave.js');
		Core::AddJavascript('jobs/wizard/createjob-form.js');
		Core::AddJavascript('jobs/wizard/create_job.js');
		Core::AddJavascript('jobs/wizard/create_job_picker.js');

		// Custom CSS elements
		Core::AddCSS('vendor/zebra/zebra_datepicker.css');
		Core::AddCSS('vendor/jquery-clockpicker.css');
		Core::AddCSS('select2.min.css');
		
		$jobtemplates = Companies::LoadCompanyTemplates();
		Core::Assign('jobtemplates', $jobtemplates);
		
		$template = 'jobs/wizard2/create_new_job.tpl';
		$page_title = 'Create New Project';
		
		if (!empty($args[1])) {
			
			switch($args[1]) {
				case 'booking':
					$template = 'jobs/wizard4/create_booking.tpl';
					Core::AddJavascript('jobs/wizard/wizard4.js');
					$jobtypes = Finda::GetMinimumJobRates(1);
					Core::Assign('jobtypes', $jobtypes);
					
					$usagerights = Taxonomy::GetTermsByVocabulary(10, true);
					Core::Assign('usagerights', $usagerights);
					
					break;
				case 'casting':
					$template = 'jobs/wizard4/create_casting.tpl';
					Core::AddJavascript('jobs/wizard/wizard4.js');
					break;
			}
			Core::AddCSS('jobs/wizard4/create_job.css');
			Core::AddCSS('jobs/wizard4/create_job_picker.css');
		} else {
			Core::AddCSS('jobs/wizard/create_job.css');
			Core::AddCSS('jobs/wizard/create_job_picker.css');
		}
		Core::AddCSS('jobs/wizard/slick.css');
		
		break;
}
