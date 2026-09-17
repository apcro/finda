<?php
/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
namespace Croissant;

if (IS_AJAX_REQUEST) {
	$inputs = array();
	if (!empty($data)) {
		foreach($data as $k => $v) {
			$key = str_replace('_input', '', $v[0]);
			$key = str_replace('register_', '', $key);
			$inputs[$key] = $v[1];
		}
	}
	
	// yes, I know I'm doing this the long way
	$userSettings = array();
	
	// for each of these, we might get in feeet, inches or centimeters
	if ($inputs['height_type'] == 'cm') {
		$userSettings['height'] = $inputs['height'];
	} else {
		$userSettings['height'] = Utilities::FeetToCentimeters($inputs['height']);
	}
	if ($inputs['bust_type'] == 'cm') {
		$userSettings['bust'] = $inputs['bust'];
	} else {
		$userSettings['bust'] = Utilities::InchesToCentimeters($inputs['bust']);
	}
	if ($inputs['waist_type'] == 'cm') {
		$userSettings['waist'] = $inputs['waist'];
	} else {
		$userSettings['waist'] = Utilities::InchesToCentimeters($inputs['waist']);
	}
	if ($inputs['hips_type'] == 'cm') {
		$userSettings['hips'] = $inputs['hips'];
	} else {
		$userSettings['hips'] = Utilities::InchesToCentimeters($inputs['hips']);
	}
	if ($inputs['collar_type'] == 'cm') {
		$userSettings['collar_size'] = $inputs['collar'];
	} else {
		$userSettings['collar_size'] = Utilities::InchesToCentimeters($inputs['collar']);
	}
	
	$userSettings['cupsize'] = !empty($inputs['cupsize'])?$inputs['cupsize']:-1;
	
	$userSettings['skintone'] = !empty($inputs['skintone'])?$inputs['skintone']:0;
	
	$userSettings['shoesize'] = $inputs['shoesize'];
	
	// only store depending on gender
	switch($inputs['gender']) {
		case 'female':
			$userSettings['dresssize'] = $inputs['dresssize'];
			break;
		case 'male':
			$userSettings['suitsize'] = $inputs['suitsize'];
			break;
		case 'other':
			$userSettings['dresssize'] = $inputs['dresssize'];
			$userSettings['suitsize'] = $inputs['suitsize'];
			break;
	}
	$userSettings['tattoo'] = ($inputs['tattoo'] == 'yes'?1:0);
	$userSettings['drivinglicense'] = ($inputs['drivinglicense'] == 'yes'?1:0);
	$userSettings['haircolour'] = $inputs['haircolour'];
	$userSettings['ringsize'] = $inputs['ringsize'];
	$userSettings['hairtype'] = $inputs['hairtype'];
	$userSettings['hairlength']= $inputs['hairlength'];
	$userSettings['willingtodye'] = ($inputs['willingtodye'] == 'yes'?1:0);
	$userSettings['willingtocut'] = ($inputs['willingtocut'] == 'yes'?1:0);
	$userSettings['eyecolour'] = $inputs['eyecolour'];
	$userSettings['eyebrowshape'] = $inputs['eyebrowshape'];
	$userSettings['hourlyrate'] = (!empty($inputs['hourly']))?$inputs['hourly']:0;
	$userSettings['dailyrate'] =(!empty($inputs['daily']))?$inputs['daily']:0;
	$userSettings['location'] =(!empty($inputs['user_location']))?$inputs['user_location']:93;	// London
	
	// we may need the posted userid
	if (User::UserType() == TYPE_MOTHERAGENCY) {
		$userSettings['userid'] = $inputs['userid'];
	}
	
	$response = User::UpdateUserProfile($userSettings);
	if (isset($response['statusCode']) && $response['statusCode'] == 0) {
		$success = $response['result'];
	}

	// email settings
	$userEmailSettings = array();
	$userEmailSettings['friend_registers'] = ($inputs['friend_registers'] == 'on'?1:0);
	$userEmailSettings['job_offered'] = ($inputs['job_offered'] == 'on'?1:0);
	$userEmailSettings['job_cancelled'] = ($inputs['job_cancelled'] == 'on'?1:0);
	$userEmailSettings['job_changed'] = ($inputs['job_changed'] == 'on'?1:0);
	$userEmailSettings['payment_made'] = ($inputs['payment_made'] == 'on'?1:0);
	$userEmailSettings['notifications'] = ($inputs['notifications'] == 'on'?1:0);
	
	$response = User::UpdateUserEmailPreferences($userEmailSettings);
	if (isset($response['statusCode']) && $response['statusCode'] == 0) {
		$success = $response['result'];
	}
	
	$userDetails = array();
	$userDetails['firstname'] = $inputs['firstname'];
	$userDetails['lastname'] = $inputs['lastname'];
	$userDetails['mail'] = $inputs['mail'];
	$userDetails['country'] = $inputs['country'];
	$userDetails['gender'] = $inputs['gender'];
	$userDetails['age'] = $inputs['age'];
	$userDetails['ethnicity'] = $inputs['ethnicity'];
	$userDetails['instagram'] = $inputs['instagram'];
	$userDetails['occupation'] = $inputs['occupation'];
	$userDetails['telephone'] = $inputs['telephone'];
	$userDetails['company_name'] = $inputs['company'];
	$userDetails['company_website'] = $inputs['website'];
	$userDetails['postal_address'] = $inputs['postal_address'];
	
	if (!empty($inputs['sortcode'])) {
		$userDetails['bank_sortcode'] = $inputs['sortcode'];
	}
	if (!empty($inputs['accountnumber'])) {
		$userDetails['bank_accountnumber'] = $inputs['accountnumber'];
	}
	if (!empty($inputs['iban'])) {
		$userDetails['bank_iban'] = $inputs['iban'];
	}
	$userDetails['bank_accountname'] = $inputs['firstname'].' '.$inputs['lastname'];
	$userDetails['motheragency_commission'] =(!empty($inputs['commission']))?$inputs['commission']:10;	// 10%

	
	$userDetails['dob'] = !empty($inputs['dob'])?strtotime(str_replace('/', '-', $inputs['dob'])):0;
	
	$userDetails['nationality'] = $inputs['nationality'];
	$userDetails['residence_country'] = $inputs['residence_country'];
	$userDetails['vat_number'] =(!empty($inputs['vatnumber']))?$inputs['vatnumber']:'';
	
	$userDetails['oldpassword'] = $inputs['oldpassword'];
	$userDetails['newpassword'] = $inputs['newpassword'];
	$userDetails['newpassword2'] = $inputs['confirmpassword'];
	
	if ($userDetails['dob'] != 0) {
		
		$age = date("Y", time()) - date("Y", $userDetails['dob']);

		$mthen = date("n", $userDetails['dob']);
		$mnow = date("n", time());

		$dthen = date("j", $userDetails['dob']);
		$dnow = date("j", time());

		if ($mnow < $mthen || ($mnow == $mthen && $dnow < $dthen)) {
			$age--;
		}
		
		$userDetails['age'] = $age;
	} else {
		$userDetails['age'] = 0;
	}
	
	// we may need the posted userid
	if (User::UserType() == TYPE_MOTHERAGENCY) {
		$userDetails['userid'] = $inputs['userid'];
	}
	
	$response = User::UpdateUser($userDetails);
	
	if (isset($response['statusCode']) && $response['statusCode'] == 0) {
		$success = $success && $response['result'];
	}
	
	
	if (User::UserType() == TYPE_CLIENT) {
		$thisuser = User::LoadUser(User::UserID());
		if ($thisuser['is_companyadmin']) {
			$companyData = array();
			$companyData['vatnumber'] = $inputs['companyvatnumber'];
			$companyData['invoicedetails'] = $inputs['companyinvoicedetails'];
			$companyData['companyid'] = $thisuser['companyid'];
			Companies::UpdateCompanyDetails($companyData);
		}
	}
	
	Core::JSONWrite($success);
	die();
} else {
	header('Location: /user');
	die();
}