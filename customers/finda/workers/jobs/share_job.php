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
 * This page is password protected
 */


$page_title = 'Share Option Board';
if (isset($args[1])) {
	$shareuri = $args[1];
} else {
	header('location: /');
	die();
}

if ($args[0] == 'share') {
	$auth = Cookie::GetCookie('projectshare'.$shareuri);

	if (!$auth) {
		$job = Jobs::GetJobByShareURI($shareuri);
		if ($job) {
			$jobid = $job['id'];
			Core::Assign('shareuri', $shareuri);
			$template = 'clients/shareauth.tpl';
			Core::AddJavascript('clients/shareauth.js');
		}
	
	} else {
			
		if (isset($args[2]) && !isset($step)) {
			$step = $args[2];
		}

		if (IS_AJAX_REQUEST && $step == 'updateModel') {
			$response = Jobs::ExternalUpdateModelForJob($jobid, $modelid, $status);
			Core::JSONWrite($response);
			die();
		} else if (IS_AJAX_REQUEST && $step == 'finished') {
			// this deletes the cookie
			Cookie::SetCookie('projectshare'.$shareuri, true, time() - 3600);
			Core::JSONWrite(true);
			die();
		} else {
			Core::Assign('jobid', $jobid);
			
			$pagemessage = array();
			
			$job = Jobs::GetJobByShareURI($shareuri);
			$job['jobcard_type'] = Jobs::GetDefinedJobTypeForClient($job);
			
			Core::Assign('shareuri', $shareuri);
			
			$client = User::LoadUser($job['client_uid']);
			Core::Assign('client', $client);
			
			if ($job['job_status'] != 0) {
				header('Location: /projects');
				die();
			}
			Core::Assign('job', $job);
			
			// only show optioned and selected, not offered
			if (isset($job['models']) && !empty($job['models'])) {
				foreach($job['models'] as $k => $v) {
		
					if ($v['job_status'] == 10 || $v['job_status'] == 15) {
						$optioned[] = $v;
					}
					if ($v['job_status'] == 1 || $v['job_status'] == 2) {
						$selected[] = $v;
					}
				}
				Core::Assign('optioned', $optioned);
				Core::Assign('selected', $selected);
			}

			$hairlengths = Taxonomy::GetTermsByVocabulary(5, true);	// hair length VID
			Core::Assign('hairlengths', $hairlengths);
			$hairtypes = Taxonomy::GetTermsByVocabulary(3, true);	// hair types VID
			Core::Assign('hairtypes', $hairtypes);
			$haircolours = Taxonomy::GetTermsByVocabulary(6, true);	// hair colours VID
			Core::Assign('haircolours', $haircolours);
			$eyecolours = Taxonomy::GetTermsByVocabulary(4, true);	// eye colours VID
			Core::Assign('eyecolours', $eyecolours);
			
			// Custom Javascript elements
			Core::AddJavascript('vendor/jquery-ui.js');
			Core::AddJavascript('clients/shareproject.js');
			
			// Custom CSS elements
			Core::AddCSS('vendor/jquery-ui.css');
			Core::AddCSS('search.css');
			Core::AddCSS('jobedit.css');
			Core::AddCSS('jobcard.css');
			Core::AddCSS('clients/shareproject.css');
			
			Core::Assign('pagemessage', $pagemessage);
			Core::Assign('sharepage', 'sharepage');	// used to hide elements in the jobcard template
			
			Core::Assign('grid_background', 'grid-bg-white');
			
			$template = 'clients/shareproject.tpl';
			
			$page_title = "Shared project ".$job['name'];
		}
	}
}