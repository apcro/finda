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
	header('Location: /jobs/view/'.$args[0]);
	die();
}

if (isset($args[1])) {
	$jobid = $args[1];
}

Core::Assign('jobid', $jobid);

$pagemessage = array();

if ($jobid == 0) {
	header('Location: /');
	die();
}
$job = Jobs::GetJobDetails($args[1]);
$job['jobcard_type'] = Jobs::GetDefinedJobTypeForClient($job);


if (!Companies::CanAccessProject($job['id'])) {
	header('Location: /projects');
	die();
}

$job['startdate_formatted'] = date('d-m-Y', $job['startdate']).' at '.date('H:i', $job['startdate']);

if ($job['findafee_discount'] > 0 || $job['modelfee_discount'] > 0) {
	$discounts = array();
	if ($job['findafee_discount'] > 0) {
		if (ceil($job['findafee_discount']) != $job['findafee_discount']) {
			$discounts[] = 'Booking fee: '.$job['findafee_discount'].'%';
		} else {
			$discounts[] = 'Booking fee: '.ceil($job['findafee_discount']).'%';
		}
	}
	if ($job['modelfee_discount'] > 0) {
		if (ceil($job['modelfee_discount']) != $job['modelfee_discount']) {
			$discounts[] = 'Model fee: '.$job['modelfee_discount'].'%';
		} else {
			$discounts[] = 'Model fee: '.ceil($job['modelfee_discount']).'%';
		}
	}
	Core::Assign('discounts', implode(',', $discounts));
}

$job['completedcount'] = 0;
$job['acceptedcount'] = 0;
$job['rejectedcount'] = 0;
$job['offeredcount'] = 0;
$job['optionedcount'] = 0;
$job['modelcompletedcount'] = 0;
$job['confirmedcount'] = 0;

foreach($job['models'] as $k => $v) {
	if ($v['job_status'] == 6 || $v['job_status'] == 7) {
		$job['completedcount']++;
	}
	if ($v['job_status'] == 5 || $v['job_status'] == 7) {
		$job['modelcompletedcount']++;
	}
	
	// 5 & 7 count as accepted along with 2 for display purposes
	if ($v['job_status'] == 14 || $v['job_status'] == 5 || $v['job_status'] == 7) {
		$job['acceptedcount']++;
	}
	if ($v['job_status'] == 3) {
		$job['rejectedcount']++;
	}
	if ($v['job_status'] == 1) {
		$job['offeredcount']++;
	}
	if ($v['job_status'] == 10) {
		$job['optionedcount']++;
	}
	if ($v['job_status'] == 2) {
		$job['confirmedcount']++;
	}
}

$job['optionedmodelcount'] = count($job['models']);

Core::Assign('job', $job);


// 10 = SHORTLISTED, not requested
// 1 = REQUESTED, not accepted
// 14 = ACCEPTED
// 2 = CONFIRMED
// split models into confirmed and unconfirmed
if (isset($job['models']) && !empty($job['models'])) {
	$feetotal = 0;
	foreach($job['models'] as $k => $v) {
		if ($v['job_status'] == 14) {
			$accepted[] = $v;
		}

		if ($v['job_status'] == 10) {
			$shortlisted[] = $v;
		}
		
		if ($v['job_status'] == 1) {
			$requested[] = $v;
		}
		if ($v['job_status'] == 2 || $v['job_status'] == 5 || $v['job_status'] == 7) {
			$confirmed[] = $v;
		}
		if ($v['agreed_rate'] != 0) {
			// confirmed only
			if ($v['job_status'] == 2) {
				$feetotal = $feetotal + $v['agreed_rate'];
			}
		}
	}
	Core::Assign('requested', $requested);
	Core::Assign('accepted', $accepted);
	Core::Assign('confirmed', $confirmed);
	Core::Assign('shortlisted', $shortlisted);
	Core::Assign('feetotal', $feetotal);
}
Core::AddCSS('jobedit.css');

Core::Assign('pagemessage', $pagemessage);

$template = 'jobs/view_job.tpl';
Core::AddCSS('jobcard_large.css');

Core::Assign('body_class', 'body-blue');
Core::AddJavascript('jobs/jobview.js');

$page_title = "View project ".$job['id'].' - '.$job['name'];

Core::Assign('grid_background', 'grid-bg-white-green');

// display invoice details, possibly
$invoice = Finance::RetrieveInvoiceDetailsByJobId($job['id'], 'client');
if ($invoice) {
	$jobdetails = Jobs::GetJobDetails($job['id']);
	if (!isset($jobdetails['models'])) {
		Core::Assign('invoice', '');	// hide invoice tab
	} else {
		foreach($jobdetails['models'] as $k => $v) {
			if ($v['job_status'] != 1 && $v['job_status'] != 2 && $v['job_status'] != 5 && $v['job_status'] != 6 && $v['job_status'] != 7) {
				unset($jobdetails['models'][$k]);
			}
		}
		if (!empty($jobdetails['models'])) {
			$fees = Jobs::GetJobValueByJobId($job['id']);
			Core::Assign('fees', $fees);
			Core::Assign('invoice', $invoice);
			Core::Assign('jobdetails', $jobdetails);
		
		} else {
			Core::Assign('invoice', '');	// hide invoice tab
		}
	}
}