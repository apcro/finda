<?php
/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
namespace Croissant;
// Load the current user (but not the cached/session version)
$u = User::LoadUser(User::UserID());

// fill in old data
if (empty($u['referrer_code'])) {
	$code = Utilities::GetNewReferrerCode($u['id']);
	$u['referrer_code'] = $code;
}

$details = array(
	'register_name'			=> isset($register_name) ? $register_name : $u['name'],
	'register_mail'			=> isset($register_mail) ? $register_mail : $u['mail'],
	'confirm_email'			=> isset($register_mail) ? $confirm_email : $u['mail'],
	'register_firstname'		=> isset($register_firstname) ? $register_firstname : $u['firstname'],
	'register_lastname'		=> isset($register_lastname) ? $register_lastname : $u['lastname'],
	'register_telephone'		=> isset($register_telephone) ? $register_telephone : $u['telephone'],
	'register_allow_email'		=> isset($register_allow_email) ? intval($register_allow_email[0]) : $u['allow_email'],
	'register_allow_thirdparty'	=> $u['allow_thirdparty'], 
	'register_allow_notification'	=> $u['allow_notification'], 

	'country' => (isset($country))? $country : $u['country'],
	
	'telephone' => (isset($telephone))? $telephone : $u['telephone'],
	'occupation' => (isset($occupation))? $occupation : $u['occupation'],
	'company_name' => (isset($company_name))? $company_name : $u['company_name'],
	'company_website' => (isset($company_website))? $company_website : $u['company_website'],
	'gender' => (isset($gender))? $gender : $u['gender'],
	'age' => (isset($age))? $age : $u['age'],
	'dob' => (isset($dob))? $dob : $u['dob'],
		
	'nationality' => (isset($nationality))? $nationality : $u['nationality'],
	'residence_country' => (isset($residence_country))? $residence_country : $u['residence_country'],
	'usertype' => $u['usertype'],
	'vat_number' => $u['vat_number'],
	'referral_code' => $u['referral_code'],
	'referrer_code' => $u['referrer_code'],
);

$hairlengths = Taxonomy::GetTermsByVocabulary(5, true);	// hair length VID
Core::Assign('hairlengths', $hairlengths);
$hairtypes = Taxonomy::GetTermsByVocabulary(3, true);	// hair types VID
Core::Assign('hairtypes', $hairtypes);
$haircolours = Taxonomy::GetTermsByVocabulary(6, true);	// hair colours VID
Core::Assign('haircolours', $haircolours);
$eyecolours = Taxonomy::GetTermsByVocabulary(4, true);	// eye colours VID
Core::Assign('eyecolours', $eyecolours);
$jobtypes = Taxonomy::GetTermsByVocabulary(1, true);
Core::Assign('jobtypes', $jobtypes);
$ethnicity = Taxonomy::GetTermsByVocabulary(7, true);
Core::Assign('ethnicity', $ethnicity);

foreach($details as $k => $v) Core::Assign($k, $v);

// get current IG followers
// since we now convert this for display in the backend, convert it back
if (!empty($u['instagram_username'])) {
	$instaname = 'https://www.instagram.com/'.str_replace('@', '', $u['instagram_username']).'/';
	$meta = get_meta_tags($instaname);
	$description = explode(', ', $meta['description']);
	
	// in case they move it
	foreach($description as $k => $v) {
		if (substr_count($v, 'Followers') > 0) {
			$followers = $v;
		}
		if (!empty($v)) {
			$followers = str_replace(' Followers', '', $followers);
			$followers = str_replace(',', '', $followers);
		}
	}
	
	if (strpos($followers, 'k') > 0) {
		$followers = str_replace('k', '', $followers);
		$followers = $followers * 1000;
	} else if (strpos($followers, 'm') > 0) {
		$followers = str_replace('k', '', $followers);
		$followers = $followers * 1000000;
	}
	
	if ($followers != $u['instagram_followers']) {
		$u['instagram_followers'] = $followers;
		
		// and update it
		$userDetails = array();
		$userDetails['followers'] = $followers;
		$response = User::UpdateUser($userDetails);
	}
}
$missingbank = Finance::MissingPaymentDetails('profile');
foreach($missingbank as $k => $v) {
	$md[] = $v[0];
}
Core::Assign('missingbank', join(' and ', array_filter(array_merge(array(join(', ', array_slice($md, 0, -1))), array_slice($md, -1)), 'strlen')));

$md = array();
$missingdetails = Finance::MissingPaymentDetails('payments');
foreach($missingdetails as $k => $v) {
	$md[] = $v[0];
}
Core::Assign('missingdetails', join(' and ', array_filter(array_merge(array(join(', ', array_slice($md, 0, -1))), array_slice($md, -1)), 'strlen')));

// missing measurements elements
$checkmeasurements = array('height', 'bust', 'waist', 'hips', 'shoesize', 'dresssize');
$mm = array();
foreach($checkmeasurements as $k) {
	if (empty($u['profile'][$k])) {
		$mm[] = $k;
	}
}
Core::Assign('missingmeasurements', join(' or ', array_filter(array_merge(array(join(', ', array_slice($mm, 0, -1))), array_slice($mm, -1)), 'strlen')));
Core::Assign('mmcount', count($mm));

if (empty($missingdetails) && empty($missingbank)) {
	if ($u['stripe_id'] == '') {
		// set up a Stripe ID for this user first, if we can
		$result = Finance::CreateStripeAccount($u);
		if ($result['result'] != true) {
			// we have an error that's not handled in the backend
			// @TODO handle this nicely, perhaps with a toast
			// for now, do nothing as this is likely caused by bad bank details, which will
			// have cleared the database
			// so let's recheck those details
			if ($result['errorMessage'] != '') {
				header('Location: /user/profile');
				die();
			} else {
				Core::Assign('errorMessage', $err['errorMessage']);
				$template = 'shared/error/500.tpl';
			}
		}
	}
}

$userDetails['followers_formatted'] = Utilities::ThousandsFormat($userDetails['followers']);

// set default email preferences
if (empty($u['prefs'])) {
	$u['prefs'] = array(
		'friend_registers' => 1,
		'job_offered' => 1,
		'job_cancelled' => 1,
		'payment_made' => 1,
		'notifications' => 0
	);
}

if (User::userType() == TYPE_MODEL) {
	$details['shoesizes'] = array(); 
	$details['shoesizes'][] = array('description' => 'UK 2 (US 4, EU 35)', 'value' => 2);
	$details['shoesizes'][] = array('description' => 'UK 2.5 (US 4,5, EU 35)', 'value' => 2.5);
	$details['shoesizes'][] = array('description' => 'UK 3 (US 5, EU 35-36)', 'value' => 3);
	$details['shoesizes'][] = array('description' => 'UK 3.5 (US 5.5, EU 36)', 'value' => 3.5);
	$details['shoesizes'][] = array('description' => 'UK 4 (US 6, EU 36-37)', 'value' => 4);
	$details['shoesizes'][] = array('description' => 'UK 4.5 (US 6.5, EU 37)', 'value' => 4.5);
	$details['shoesizes'][] = array('description' => 'UK 5 (US 7, EU 37-38)', 'value' => 5);
	$details['shoesizes'][] = array('description' => 'UK 5.5 (US 7.5, EU 38)', 'value' => 5.5);
	$details['shoesizes'][] = array('description' => 'UK 6 (US 8, EU 38-39)', 'value' => 6);
	$details['shoesizes'][] = array('description' => 'UK 6.5 (US 8.5, EU 39)', 'value' => 6.5);
	$details['shoesizes'][] = array('description' => 'UK 7 (US 9, EU 39-40)', 'value' => 7);
	$details['shoesizes'][] = array('description' => 'UK 7.5 (US 9.5, EU 40)', 'value' => 7.5);
	$details['shoesizes'][] = array('description' => 'UK 8 (US 10, EU 40-41)', 'value' => 8);
	$details['shoesizes'][] = array('description' => 'UK 8.5 (US 10.5, EU 41)', 'value' => 8.5);
	$details['shoesizes'][] = array('description' => 'UK 9 (US 11, EU 41-42)', 'value' => 9);
	$details['shoesizes'][] = array('description' => 'UK 9.5 (US 11.5, EU 42)', 'value' => 9.5);
	$details['shoesizes'][] = array('description' => 'UK 10 (US 12, EU 42-43)', 'value' => 10);
	
	$details['dresssizes'] = array();
	$details['dresssizes'][] = array('description' => 'UK 4 (US 0, EU 32)', 'value' => 4);
	$details['dresssizes'][] = array('description' => 'UK 6 (US 2, EU 34)', 'value' => 6);
	$details['dresssizes'][] = array('description' => 'UK 8 (US 4, EU 36)', 'value' => 8);
	$details['dresssizes'][] = array('description' => 'UK 10 (US 6, EU 38)', 'value' => 10);
	$details['dresssizes'][] = array('description' => 'UK 12 (US 8, EU 40)', 'value' => 12);
	$details['dresssizes'][] = array('description' => 'UK 14 (US 10, EU 32)', 'value' => 14);
	Core::Assign('details', $details);
}

Core::Assign('user', $u);

Core::AddJavascript('vendor/zebra_datepicker.min.js');

Core::AddJavascript('user/profileedit.js');
Core::AddJavascript('vendor/cleave.js');

Core::AddCSS('vendor/zebra/zebra_datepicker.css');

Core::AddCSS('user/profileedit.css');

Core::Assign('profile', true);

$page_title = "My Profile";