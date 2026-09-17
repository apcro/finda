<?php
/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
namespace Croissant;

/**
 * User Profile Viewing controller
 */
if (empty($action)) {
	$userid = User::UserID();
}
if ($userid != User::UserID()) {
	header('Location: /user');
	die();
}
$u = User::LoadUser($userid);

// format instagam followers
$u['instagram_followers'] = Utilities::ThousandsFormat($u['instagram_followers']);

$details = array (
		'register_name' => isset($register_name) ? $register_name : $u['name'],
		'register_mail' => isset($register_mail) ? $register_mail : $u['mail'],
		'confirm_email' => isset($register_mail) ? $confirm_email : $u['mail'],
		'register_firstname' => isset($register_firstname) ? $register_firstname : $u['firstname'],
		'register_lastname' => isset($register_lastname) ? $register_lastname : $u['lastname'],
		'register_telephone' => isset($register_telephone) ? $register_telephone : $u['telephone'],
		'register_allow_email' => isset($register_allow_email) ? intval($register_allow_email[0]) : $u['allow_email'],
		'register_allow_thirdparty' => $u['allow_thirdparty'],
		'register_allow_notification' => $u['allow_notification'],
		
		'country' => (isset($country)) ? $country : $u['country'],
		
		'telephone' => (isset($telephone)) ? $telephone : $u['telephone'],
		'occupation' => (isset($occupation)) ? $occupation : $u['occupation'],
		'company_name' => (isset($company_name)) ? $company_name : $u['company_name'],
		'company_website' => (isset($company_website)) ? $company_website : $u['company_website'],
		'gender' => (isset($gender)) ? $gender : $u['gender'],
		'age' => (isset($age)) ? $age : $u['age'],
		'usertype' => $u['usertype'] 
);

foreach ($details as $k => $v)
	Core::Assign($k, $v);

if (User::UserType() == 1) {
	$offered = Jobs::ModelGetJobs('offered');
	$pending = Jobs::ModelGetJobs('accepted');
	Core::Assign('offered', $offered);
	Core::AddJavascript('jobs/joboffers.js');
	Core::AddJavascript('modeldashboard.js');
	Core::AddJavascript('vendor/masonry.pkgd.js');
} else {
	$pending = Jobs::ClientGetJobsList('pending');
	Core::AddJavascript('user/profile.js');
	Core::AddCSS('search.css');
	Core::AddCSS('jobedit.css');
	Core::AddCSS('vendor/rater.css');
	$models = Model::GetModelsWorkedWith();
	Core::Assign('models', $models);
	
	$invoices = Finance::RetrieveInvoices(User::UserID());
	foreach($invocies as $k => $v) {
		if ($invoice['due_date'] > time()) {
			unset($invoices[$k]);
		}
	}
	Core::Assign('invoices', $invoices);
	
}
Core::Assign('pending', $pending);
Core::Assign('user_data', $u);

Core::Assign('hasleadimage', Model::HasLeadImage());
Core::AddCSS('jobcard.css');

$page_title = 'Dashboard';
$template = 'user/profile.view.tpl';
