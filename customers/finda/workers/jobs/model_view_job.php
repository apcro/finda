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
	header('Location: /projects/view/'.$args[0]);
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
$job['jobcard_type'] = Jobs::GetDefinedJobTypeForModel($job, User::UserID());

// this is a model viewing her own job - if she's not  in this array, something's gone wrong elsewhere.
if (!isset($job['models'][User::UserID()])) {
	header('Location: /jobs');
	die();
}
$job['status'] = $job['models'][User::UserID()]['job_status'];
$job['startdate_formatted'] = date('d-m-Y', $job['startdate']).' at '.date('H:i', $job['startdate']);

foreach($job['models'] as $k => $v) {
	if ($v['id'] == User::UserID()) {
		$job['model_desired_rate'] = $job['models'][$k]['model_desired_rate'];
		$job['client_offered_rate'] = $job['models'][$k]['client_offered_rate'];
		$job['agreed_rate'] = $job['models'][$k]['agreed_rate'];
		unset($job['models'][$k]);
		Core::Assign('model', $v);
	}
	if ($v['job_status'] != 2) {
		unset($job['models'][$k]);
	}
}
if (!empty($job['usage'])) {
	unset($job['usage']['jobid']);
	foreach($job['usage'] as $k => $v) {
		if ($v == 0) {
			unset ($job['usage'][$k]);
		}
	}
}

Core::Assign('job', $job);

Core::AddCSS('jobcard_large.css');
Core::AddJavascript('vendor/cleave.js');
Core::AddJavascript('jobs/joboffers.js');

Core::Assign('pagemessage', $pagemessage);
Core::Assign('body_class', 'body-blue');

$template = 'jobs/model_view_job.tpl';

$page_title = "View project ".$job['id'].' - '.$job['name'];

Core::Assign('grid_background', 'grid-bg-white-green');

// display invoice details, possibly
$invoiceid = 0;
$invoices = Finance::RetrieveModelInvoices(User::UserID());
foreach($invoices as $data) {
	if ($data['jobid'] == $jobid) {
		$invoiceid = $data['id'];
	}
}

if ($invoiceid != 0) {
	$invoice = Finance::RetrieveInvoiceDetails($invoiceid);
	$fees = Jobs::GetJobValueByInvoiceId($invoiceid);

	if ($invoice) {
		$client = User::LoadUser($invoice['modelid']);
		Core::Assign('client', $client);
		$modelfees = $fees['modelfees'][User::UserID()];
		$modelfees['findafee'] = $modelfees['modelfee'];
		$modelfees['motheragencycommission'] = $modelfees['agencycommission'];
		$modelfees['fee'] = $modelfees['total'] - $modelfees['motheragencycommission'];
		Core::Assign('modelfees', $modelfees);
		Core::Assign('jobdetails', $job);
		$assignment = Model::GetJobAssignmentStatus($jobid);
		Core::Assign('assignmentstatus', $assignment);
	}
	
} else {
	$fees = Jobs::GetJobValueByJobId($jobid);
}
$totalfee = $fees['modelfees'][User::UserID()]['modelcost'];
Core::Assign('feetotal', $totalfee);
Core::Assign('modeltotal', $fees['modelfees'][User::UserID()]['total']);

if ($job['project_tid'] == 75 || $job['project_tid'] == 78) {
	Core::Assign('jobtype', 'casting');
} else {
	Core::Assign('jobtype', 'booking');
}
Core::Assign('invoice', $invoice);