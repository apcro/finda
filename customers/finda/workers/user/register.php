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

// this is now ajax-only
if (IS_AJAX_REQUEST) {
	$inputs = array();
	if (!empty($data)) {
		foreach($data as $k => $v) {
			$key = str_replace('_input', '', $v[0]);
			$key = str_replace('register_', '', $key);
			$inputs[$key] = $v[1];
		}
	}
	if (isset($step) && $step != '') {
		$inputs['step'] = $step;
	}
	
	switch($inputs['step']) {
		case 'account':
			
			switch($inputs['usertype']) {
				case 'model':
					if ($inputs['instagram'] != '') {
						// let's deal with this in a better way
						$instagram = str_replace('@', '', $inputs['instagram']);
						$instagram = str_replace('https://instagram.com/', '', $instagram);
						$instagram = str_replace('https://www.instagram.com/', '', $instagram);
						$instagram = trim($instagram);
					} else {
						$instagram = '';
						// we require an instagram username
						echo 'no insta';
						Core::JSONWrite(false);
						die();
					}
					$formData = array(
						'mail' => (isset($inputs['mail']))? $inputs['mail'] : '',
						'telephone' => (isset($inputs['telephone']))? $inputs['telephone'] : '',
						'pass' => (isset($inputs['password']))? $inputs['password'] : null,
						'firstname' => (isset($inputs['firstname']))? $inputs['firstname'] : '',
						'lastname' => (isset($inputs['lastname']))? $inputs['lastname'] : '',
						'gender' => (isset($inputs['gender']))? $inputs['gender'] : 'female',
						'country' => (isset($inputs['country']))? $inputs['country'] : '',
						'usertype' => (isset($inputs['usertype'])) ? $inputs['usertype'] : '',
						'agree_terms' => (isset($inputs['terms']) && $inputs['terms'] == 'on') ? 1 : 0,
						'instagram_username' => isset($instagram)?$instagram:'',
						'referral_code' => isset($inputs['referral'])?$inputs['referral']:'',
						'location' => isset($inputs['location'])?$inputs['location']:93,	// default to london
						'entry_url' => 'website',
						'dob' => 0
					);
					$listid = MAILCHIMP_MODEL_LIST;
					break;
				case 'brand':
				case 'agent':
					
					$company_website = (isset($inputs['website']))? $inputs['website'] : '';
					if (!empty($company_website)) {
						// prepend the http portion
						$company_website = parse_url($company_website, PHP_URL_SCHEME) === null?'http://'.$company_website:$company_website;
					}

					$ismotheragency = (isset($inputs['motheragency']) && $inputs['motheragency'] == 'on') ? 1 : 0;

					$formData = array(
						'mail' => (isset($inputs['mail']))? $inputs['mail'] : '',
						'pass' => (isset($inputs['password']))? $inputs['password'] : null,
						'firstname' => (isset($inputs['firstname']))? $inputs['firstname'] : '',
						'lastname' => (isset($inputs['lastname']))? $inputs['lastname'] : '',
						'telephone' => (isset($inputs['telephone']))? $inputs['telephone'] : '',
						'occupation' => (isset($inputs['occupation']))? $inputs['occupation'] : '',
						'company_name' => (isset($inputs['company']))? $inputs['company'] : '',
						'company_website' => $company_website,
						'country' => (isset($inputs['country']))? $inputs['country'] : '',
						'usertype' => (isset($inputs['usertype'])) ? $inputs['usertype'] : '',
						'agree_terms' => (isset($inputs['terms']) && $inputs['terms'] == 'on') ? 1 : 0,
						'referral_code' => isset($inputs['referral'])?$inputs['referral']:'',
						// required in the database
						'gender' => (isset($inputs['gender']))? $inputs['gender'] : 'other',
						'age' => (isset($inputs['age']))? $inputs['age'] : 0,
						'entry_url' => 'website',
						'dob' => 0,
						'ismotheragency' => $ismotheragency,
					);
					
					if ($ismotheragency == 1) {
						$listid = MAILCHIMP_MOTHERAGENCY_LIST;
					} else {
						$listid = MAILCHIMP_BRAND_LIST;
					}
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
				$merge_vars = array('FNAME' => $formData['firstname'], 'LNAME' => $formData['lastname']);
				$result = Mailchimp3::ListSubscribe($listid, $email, $merge_vars);
				
				// we've turned off the Client welcome email in MailChimp
				if ($listid == MAILCHIMP_BRAND_LIST) {
					// welcome email moved to CMS
					SendGrid::SendInternal('new client', $response['result']['userid']);
				} else if ($listid == MAILCHIMP_MOTHERAGENCY_LIST) {
					SendGrid::SendMARegisterWelcomeEmail($formData['firstname'], $email);
					SendGrid::SendInternal('new mother agency application', $response['result']['userid']);
				} else {
					// do nothing
				}
				
				// log the user in in the background
				User::Login($inputs['mail'], $inputs['password'], false);

				// show the welcome modal
				Core::JSONWrite(true);
				die();
			} else {
				Core::JSONWrite(false);
				die();
			}
			break;
	
		case 'checkemail':
			$register_mail = strtolower($email);
			//check email availability/uniqueness (return JSON)
			$result = User::CheckEmail($register_mail, true);
			Core::JSONWrite((bool)$result);
			die();
			break;
	
		default:
			Core::JSONWrite(false);
			die();
			break;
	}
}


