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
if (!IS_AJAX_REQUEST) {
	// register against a company with autoverify, given an invitation link
	if (isset($args[0]) && !empty($args[0])) {
		// now we check the invite is valid and hasn't been used
		$invite = Companies::CheckInviteCode($args[0]);
		if ($invite) {
			$company = Companies::LoadCompanyDetails($invite['companyid']);
			$inviter = '';
			foreach ($company['members'] as $k => $v) {
				if ($v['id'] == $invite['invite_userid']) {
					$inviter = $v['firstname'];
				}
			}
			Core::Assign('inviter', $inviter);
			$template = 'user/register/companyregisterpage.tpl';
			Core::Assign('invitecode', $args[0]);
			Core::AddCSS('companyinvite.css');
			Core::AddJavascript('companyinviteregister.js');
			Core::AddJavascript('vendor/cleave.js');
			Core::AddJavascript('vendor/cleave-phone.gb.js');
			Core::Assign('company', $company);
		} else {
			header('Location: /');
			die();
		}
	}

} else {
	// this is the ajax POST from the form, which will be a single page not a popup
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
			
			// check the invite code again
			$companyinvite = Companies::CheckInviteCode($inputs['invitecode']);
			if ($companyinvite['companyid'] != 0) {
				$company = Companies::LoadCompanyDetails($companyinvite['companyid']);
				$company_website = (isset($inputs['website']))? $inputs['website'] : '';
				if (!empty($company_website)) {
					// prepend the http portion
					$company_website = parse_url($company_website, PHP_URL_SCHEME) === null?'http://'.$company_website:$company_website;
				}
				
				$formData = array(
					'mail' => (isset($inputs['mail']))? $inputs['mail'] : '',
					'pass' => (isset($inputs['password']))? $inputs['password'] : null,
					'firstname' => (isset($inputs['firstname']))? $inputs['firstname'] : '',
					'lastname' => (isset($inputs['lastname']))? $inputs['lastname'] : '',
					'telephone' => (isset($inputs['telephone']))? $inputs['telephone'] : '',
					'occupation' => (isset($inputs['occupation']))? $inputs['occupation'] : '',
					'company_name' => $company['company_name'],
					'company_website' => $company['company_website'],
					'usertype' => 'brand',
					'agree_terms' => (isset($inputs['terms']) && $inputs['terms'] == 'on') ? 1 : 0,
					// required in the database
					'gender' => (isset($inputs['gender']))? $inputs['gender'] : 'other',
					'age' => (isset($inputs['age']))? $inputs['age'] : 0,
					'entry_url' => 'companyinvitation',
					'dob' => 0,
					'companyid' => $companyinvite['companyid']
				);
				$listid = MAILCHIMP_BRAND_LIST;
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
				
				if (!DEBUG) {
					// add to Mailchimp list here
					$email = $formData['mail'];
					$merge_vars = array('FNAME' => $formData['firstname'], 'LNAME' => $formData['lastname']);
					$result = Mailchimp3::ListSubscribe($listid, $email, $merge_vars);
				}
				
				// log the user in in the background
				User::Login($inputs['mail'], $inputs['password'], false);
				
				if ($companyinvite['companyid'] != 0) {
					$userupdate = array();
					$userupdate['userid'] = $response['result']['userid'];
					$userupdate['companyid'] = $companyinvite['companyid'];
					$userupdate['status'] = 1;
					User::UpdateUser($userupdate);
					Companies::UseInviteCode($inputs['invitecode'], $response['result']['userid']);
				}
				
				
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


