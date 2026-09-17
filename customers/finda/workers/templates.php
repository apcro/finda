<?php
/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
namespace Croissant;

if (User::UserID() == 0) {
	header('Location: /');
	die();
}

if (User::UserType() != TYPE_CLIENT) {
	header('Location: /user');
	die();
}

if (User::UserStatus() == 0) {
	header('Location: /user');
	die();
}

// templates are for company users only
if (User::CompanyId() == 0) {
	header('Location: /user');
	die();
}

$route = $args[0];
switch ($route) {
	case 'update':
		if (IS_AJAX_REQUEST) {
			
			$formdata = array();
			$formdata['templateid'] = $templateid;
			$formdata['templatename'] = $templatename;
			$formdata['description'] = $description;
			$formdata['location'] = $projectlocation;
			$formdata['project_tid'] = $jobtype;
			$offeredrate = str_replace('£', '', $offeredrate);
			$offeredrate = str_replace(',', '', $offeredrate);
			$formdata['offered_rate'] = !empty($offeredrate)?$offeredrate:0;
			$formdata['altrate'] = 0;
			$formdata['altrate_unitstype'] = 'day';	// this is an enum, requires some input
			
			$formdata['time_units'] = isset($timeunits)?$timeunits:0;
			$formdata['units_type'] = 'day';
			
			$formdata['request_address'] = isset($request_address)?$request_address:0;
			
			// the individual taxonomy rights
			if ($formdata['project_tid'] == 12) {
				$usagerights[] = 63;
			}
			$formdata['usagerights'] = $usagerights;
			
			$result = Companies::UpdateJobTemplate($formdata);
			$json = array();
			$json['result'] = $result;
			$jobtemplates = Companies::LoadCompanyTemplates();
			Core::Assign('jobtemplates', $jobtemplates);
			
			$html = Core::Fetch('jobs/templates/template_list.tpl');
			$json['html'] = $html;
			Core::JSONWrite($json);
		}
		die();
		break;
	case 'delete':
		if (IS_AJAX_REQUEST) {
			$json = Companies::DeleteJobTemplateById($templateid);
			Core::JSONWrite($json);
		}
		die();
		break;
	case 'load':
		if (IS_AJAX_REQUEST) {
			$template = Companies::LoadJobTemplate($templateid);
			if ($template) {
				$json['status'] = true;
				$json['content'] = $template;
			} else {
				$json['status'] = false;
			}
			Core::JSONWrite($json);
		}
		die();
		break;
	case 'createfrom':
		if (IS_AJAX_REQUEST) {
			$json = false;
			$job = Jobs::GetJobDetails($jobid);
			if ($job) {
				
				$formdata = array();
				$formdata['templatename'] = $templatename;
				$formdata['name'] = $projectname;
				$formdata['description'] = $job['description'];
				$formdata['location'] = $job['location'];
				$formdata['project_tid'] = $job['project_tid'];
				$formdata['offered_rate'] = $job['offered_rate']; // must be a number, comes with a prefix
				$formdata['altrate'] = $job['altrate'];
				// if altrate (product) is selected, set offered_rate to 0
				if (!empty($formdata['altrate'])) {
					$formdata['offered_rate'] = 0;
				}
				$formdata['altrate_unitstype'] = $job['units_type'];	// this is an enum, requires some input
				
				$formdata['time_units'] = $job['time_units'];
				$formdata['units_type'] = $job['units_type'];
				
				$formdata['request_address'] = $job['request_address'];
				
				// the individual taxonomy rights
				if ($formdata['project_tid'] == 12) {
					$usagerights[] = 63;
				}
				$formdata['usagerights'] = $job['usagerights'];
				
				$json = Companies::CreateJobTemplate($formdata);
				
			}
			
			Core::JSONWrite($json);
		}
		die();
		break;
	case 'edit':
		$templateid = $args[1];
		if (empty($templateid)) {
			header('Location: /templates');
			die();
		}
		$template = 'jobs/edit_template.tpl';
		
		$jobtemplate = Companies::LoadJobTemplate($templateid);
		Core::Assign('jobtemplate', $jobtemplate);
		
		break;
	default:
		// do we have any messages to show?
		$message = Session::GetVariable('message');
		$errormessage = Session::GetVariable('errormessage');
		Session::SetVariable('message', '');
		Session::SetVariable('errormessage', '');
		Core::Assign('message', $message);
		Core::Assign('errormessage', $errormessage);
	
		$template = 'jobs/edit_template_list.tpl';
		
		$jobtemplates = Companies::LoadCompanyTemplates();
		Core::Assign('jobtemplates', $jobtemplates);
			
		$jobtypes = Finda::GetMinimumJobRates(1);
		Core::Assign('jobtypes', $jobtypes);
		
		foreach($jobtypes as $k => $v) {
			if ($v['tid'] == $job['project_tid']) {
				Core::Assign('minhourly', $v['hourly']);
				Core::Assign('mindaily', $v['daily']);
			}
		}
		
		
		$page_title = 'List Editable Templates';
		
		Core::AddJavascript('jobs/edittemplate.js');
		Core::AddJavascript('vendor/cleave.js');
		Core::AddCSS('templates.css');
		Core::AddCSS('jobedit.css');
		
		Core::Assign('body_class', 'body-blue');
		Core::Assign('grid_background', 'grid-bg-white');
		
		// we may have an ID in $args[1]
		// if we do, check this user owns the template
		if (isset($args[0])) {
			$edittemplate = Companies::LoadJobTemplate($args[0]);
			if ($edittemplate) {
				Core::Assign('edittemplateid', $args[0]);
			}
		}
		break;
}

