<?php
/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
namespace Croissant;

//redirect if user is logged in
if (User::UserID() != 0) {
	header('Location: /');
	die();
}

switch($step) {
	case 'account':
		
		$mail_input = strtolower($mail_input);
		switch($usertype) {
			case 'model':
				if ($instagram_input != '') {
					$instagram = 'https://www.instagram.com/'.str_replace('@', '', $instagram_input);
				} else {
					$instagram = '';
				}
				$formData = array(
					'mail' => (isset($mail_input))? $mail_input : '',
					'pass' => (isset($password_input))? $password_input : null,
					'firstname' => (isset($firstname_input))? $firstname_input : '',
					'lastname' => (isset($lastname_input))? $lastname_input : '',
					'gender' => (isset($register_gender_input))? $register_gender_input : 'female',
					'country' => (isset($country_input))? $country_input : '',
					'usertype' => (isset($usertype)) ? $usertype : '',
					'agree_terms' => (isset($terms_input) && $terms_input == 'on') ? 1 : 0,
					'instagram_username' => isset($instagram)?$instagram:'',
					'referral_code' => isset($referral_input)?$referral_input:'',
					'entry_url' => 'mobile',
					'dob' => 0
				);
				$listid = MAILCHIMP_MODEL_LIST;
				break;
			case 'brand':
			case 'agent':
				$formData = array(
					'mail' => (isset($mail_input))? $mail_input : '',
					'pass' => (isset($password_input))? $password_input : null,
					'firstname' => (isset($firstname_input))? $firstname_input : '',
					'lastname' => (isset($lastname_input))? $lastname_input : '',
					'telephone' => (isset($telephone_input))? $telephone_input : '',
					'occupation' => (isset($occupation_input))? $occupation_input : '',
					'company_name' => (isset($company_input))? $company_input : '',
					'company_website' => (isset($website_input))? $website_input : '',
					'country' => (isset($country_input))? $country_input : '',
					'usertype' => (isset($usertype)) ? $usertype : '',
					'agree_terms' => (isset($terms_input) && $terms_input == 'on') ? 1 : 0,
					'entry_url' => 'mobile',
					
					// required in the database
					'gender' => (isset($gender_input))? $gender_input : 'other',
					'age' => (isset($age_input))? $age_input : 0,
					'dob' => 0,
				);
				$listid = MAILCHIMP_BRAND_LIST;
				break;
			default:
				header('Location: /');
				die();
				break;
		}
		//create user
		if (empty($formData)) {
			header('Location: /');
			die();
		}
		$response = User::CreateUser($formData);
		if ($response['statusCode'] == 0) {
			
			// create referrer_code
			Utilities::GetNewReferrerCode($response['result']['userid']);
			
			// add to Mailchimp list here
			$email = $formData['mail'];
			$merge_vars = array('LNAME' => $formData['firstname'], 'FNAME' => $formData['lastname']);
			$result = Mailchimp3::ListSubscribe($listid, $email, $merge_vars);
			
			// redirect to user profile for initial editing
			// temporary as we don't support mobile
			header('location: /m/welcome');
			die();
		} else {
			header('Location: /');
			die();
		}
		break;

	case 'checkemail':

		if (IS_AJAX_REQUEST) {
			$register_mail = strtolower($email);
			//check email availability/uniqueness (return JSON)
			$result = User::CheckEmail($register_mail, true);
			Core::JSONWrite((bool)$result);
		}
		die();
		break;

	default:
		switch ($args[1]) {
			case 'model':
				$usertype = 'model';
				break;
			case 'agent':
				$usertype = 'agent';
				break;
			default:
				$usertype = 'unknown';
		}
		Core::Assign('usertype', $usertype);
		Core::AddJavascript('mobile/registerpage.js');
		$template = 'mobile/registerpage.tpl';
		if (isset($errorMessage)) {
			// do something with the data
		}
		
		Core::AddCSS('m.register.css');
		Core::AddCSS('finda-mobile.css');
		
		if (isset($aff_id)) {
			Core::Assign('trk', $aff_id);
		}
		break;
}


