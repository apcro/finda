<?php
/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
/**
 * Finda API class
 *
 * implements only allowed methods for API calls.
 *
 * see api.php for allowed method names
 *
 * This class makes heavy use of Redis
 *
 */

namespace Croissant;

Class API extends Core {
	/* *****************************************************************************************************************************
	 * Basic initialisation functions. Every class that extends the provided classes must include this header block
	 * *****************************************************************************************************************************/
	static $core;
	public static function initialise() {
		if (DEBUG) _log(__CLASS__.'::'.__FUNCTION__);
		if (!isset(self::$core)) {
			self::$core = parent::initialise();
		}
		return self::$core;
	}
	/* *****************************************************************************************************************************
	 * End basic initialisation function
	 * *****************************************************************************************************************************/

	/* *****************************************************************************************************************************
	 * Internal use functions
	* *****************************************************************************************************************************/
	// is the passed token valid?
	public static function IsValidToken($token) {
		if (DEBUG) _log(__CLASS__.'::'.__FUNCTION__);
		$key = Redis::Get($token);
		if ($key) {
			return true;
		} else {
			return false;
		}
	}

	private static function GetToken($token) {
		if (DEBUG) _log(__CLASS__.'::'.__FUNCTION__);
		if (self::_validToken($token)) {
			$uid = Redis::Get($token);
			return $uid;
		} else {
			return false;
		}
	}

	// makes a new token for the given $uid
	private static function SetToken($uid) {
		if (DEBUG) _log(__CLASS__.'::'.__FUNCTION__);
		$token = md5(time());
		$token = str_rot13($token);
		Redis::Set('apitoken:'.$token, $uid, 0, true);
		return $token;
	}

	// expires (deletes) a token
	public static function ExpireToken($token) {
		if (DEBUG) _log(__CLASS__.'::'.__FUNCTION__);
		Redis::Delete($token);
	}

	// sets the userID for calls to the dataserver as well
	private static function GetUserID($token) {
		$uid = Redis::Get($token);
		self::$core->_user['id'] = $uid;
		return $uid;
	}
	private static function SetSessionKey($token, $sessionKey) {
		if (DEBUG) _log(__CLASS__.'::'.__FUNCTION__);
		$token = str_replace('apitoken:', 'sessionKey:', $token);
		Redis::Set($token, $sessionKey, 0, true);
		return $token;
	}

	private static function GetSessionKey($token) {
		if (DEBUG) _log(__CLASS__.'::'.__FUNCTION__);
		if (self::_validToken($token)) {
			$token = str_replace('apitoken:', 'sessionKey:', $token);
			$sessionKey = Redis::Get($token);
			return $sessionKey;
		} else {
			return false;
		}
	}

	/* *****************************************************************************************************************************
	 * API functions
	* *****************************************************************************************************************************/

	/*
	 * userLogin
	 * required: username, password as MD5
	 * returns: token to be used for all other calls
	 */
	static function UserLogin($username, $password) {
		if (DEBUG) _log(__CLASS__.'::'.__FUNCTION__);
		$response = array('status' => 0);
		if (empty($username)) {
			$response['error'] = 'Login Failed. Please enter a valid email address.';
			return $response;
		}
		$data = User::Login($username, $password, false);
		if (!$data) {
			$response['error'] = 'Login Failed. Please enter a valid email address and password.';
			$response['returndata'] = $data;
		} else {
		
			// yes, this is doubled
			$userdata = User::LoadUser($data['id']);
			
			// unset what we don't need
			$fields = array(
					'id', 'mail', 'firstname', 'lastname', 'gender', 'sefu', 'status', 'avatar', 'usertype', 'instagram_username', 'instagram_followers', 'occupation',
					'company_name', 'company_website', 'dob', 'country', 'nationality', 'residence_country', 'bank_sortcode',
					'bank_accountname', 'bank_accountnumber', 'vat_number', 'referrer_code', 'lead_image', 'ethnicity', 'available', 'profile', 'prefs'
			);
			
			$returndata = array();
			foreach($fields as $k) {
				$returndata[$k] = $userdata[$k];
			}

			// tidy up default data before sending it back, so that fields are not null
			// if the user is a client or unverified
			// data sanity needed for Android
			if ($returndata['status'] == 0 ||$returndata['usertype'] == 2) {
				$returndata = self::SetDefaultUserData($returndata);
			}
			
			$token = self::SetToken($data['id']);
			$returndata['token'] = $token;
			$response['status'] = 1;
			$response['userdata'] = $returndata;
		}
		return $response;
	}
	
	static function SetDefaultUserData($userdata) {
		if (empty($userdata["nationality"])) $userdata['nationality'] = "";
		if (empty($userdata["residence_country"])) $userdata['residence_country'] = "";
		if (empty($userdata["bank_sortcode"])) $userdata['bank_sortcode'] = "";
		if (empty($userdata["bank_accountname"])) $userdata['bank_accountname'] = "";
		if (empty($userdata["bank_accountnumber"])) $userdata['bank_accountnumber'] = "";
		if (empty($userdata["vat_number"])) $userdata['vat_number'] = "";
		if (empty($userdata["referrer_code"])) $userdata['referrer_code'] = "";
		if (empty($userdata["lead_image"])) $userdata['lead_image'] = 0;
		
		if (empty($userdata['profile']["height"])) $userdata['profile']['height'] = 0;
		if (empty($userdata['profile']["waist"])) $userdata['profile']['waist'] = 0;
		if (empty($userdata['profile']["hips"])) $userdata['profile']['hips'] = 0;
		if (empty($userdata['profile']["shoesize"])) $userdata['profile']['shoesize'] = 0;
		if (empty($userdata['profile']["hairlength"])) $userdata['profile']['hairlength'] = 0;
		if (empty($userdata['profile']["eyebrowshape"])) $userdata['profile']['eyebrowshape'] = 0;
        if (empty($userdata['profile']["suitsize"])) $userdata['profile']['suitsize'] = 0;
		if (empty($userdata['profile']["bodytype"])) $userdata['profile']['bodytype'] = 0;
		if (empty($userdata['profile']["hairtype"])) $userdata['profile']['hairtype'] = 0;
		if (empty($userdata['profile']["eyecolour"])) $userdata['profile']['eyecolour'] = 0;
		if (empty($userdata['profile']["eyebrowshape"])) $userdata['profile']['eyecolour'] = 0;
		if (empty($userdata['profile']["eyeshape"])) $userdata['profile']['eyeshape'] = 0;
		if (empty($userdata['profile']["lipshape"])) $userdata['profile']['lipshape'] = 0;
		if (empty($userdata['profile']["faceclear"])) $userdata['profile']['faceclear'] = 0;
		if (empty($userdata['profile']["facefreckles"])) $userdata['profile']['facefreckles'] = 0;
		if (empty($userdata['profile']["facebirthmark"])) $userdata['profile']['facebirthmark'] = 0;
		if (empty($userdata['profile']["cheekdimples"])) $userdata['profile']['cheekdimples'] = 0;
		if (empty($userdata['profile']["facepiercing"])) $userdata['profile']['facepiercing'] = 0;
		if (empty($userdata['profile']["otherpiercing"])) $userdata['profile']['otherpiercing'] = 0;
		if (empty($userdata['profile']["skintone"])) $userdata['profile']['skintone'] = 0;
		if (empty($userdata['profile']["hairlength_tid"])) $userdata['profile']['hairlength_tid'] = 0;
		if (empty($userdata['profile']["hairtype_tid"])) $userdata['profile']['hairtype_tid'] = 0;
		if (empty($userdata['profile']["eyecolour_tid"])) $userdata['profile']['eyecolour_tid'] = 0;
		if (empty($userdata['profile']["eyebrowshape_tid"])) $userdata['profile']['eyebrowshape_tid'] = 0;
		if (empty($userdata['profile']["eyeshape_tid"])) $userdata['profile']['eyeshape_tid'] = 0;
		if (empty($userdata['profile']["lipshape_tid"])) $userdata['profile']['lipshape_tid'] = 0;
		
		return $userdata;
	}

	static function UserLogout($token) {
		if (DEBUG) _log(__CLASS__.'::'.__FUNCTION__);
		$uid = Redis::Get($token);
		User::Logout($uid);
		UserFacebook::Logout();
		self::ExpireToken($token);

		if (!empty(self::$core->_deviceID)) {
			Redis::Delete($key);
		}
		$response['status'] = 1;
		return $response;
	}

	static function twitterLogin($twitterid, $username) {
		// convert the 4 parameters to an internal userid
		// if it exists, log the user in
		// if it doesn't, register the user and log them in

		$uid = Finda::TwitterLoginOrRegister($twitterid, $username);

		if ($uid != 0) {
			$result = User::Loaduser($uid);
			$token = self::SetToken($uid);

			Finda::SetTwitterProfile($twitterid, $uid);

			$response['token'] = $token;
			$response['status'] = 1;
			$response['data'] = $result;
			return $response;
		} else {
			return false;
		}

	}

	/*
	 * userLogin
	* required: username, password as MD5
	* returns: token to be used for all other calls
	*/
	static function facebookLogin($facebook_token) {
		if (DEBUG) _log(__CLASS__.'::'.__FUNCTION__);
		// we need make sure token is valid and long live one.
		$newToken = UserFacebook::ExchangeToken($facebook_token) ;
		$response = array('status' => 0);
		if (empty($newToken)) {
			$response['error'] = 'Login Failed. Invalid faceboook token. (Exchange Token)';
			$response['retAuth'] = $retAuth;
			$response['token'] = $facebook_token;
			$response['newtoken'] = $newToken;
			return $response;
		}
		// call old facebook function
		$retAuth = UserFacebook::CheckAuthen($facebook_token);
		if ($retAuth['status'] == 0) {
			$response['error'] = 'Login Failed. Invalid faceboook token.';
			$response['retAuth'] = $retAuth;
			$response['token'] = $facebook_token;
			$response['newtoken'] = $newToken;
		} else {
			$token = self::SetToken($retAuth['data']['id']);
			$response['token'] = $token;
			$response['status'] = 1;
			$response['retAuth'] = $retAuth;
		}
		return $response;
	}

	/*
	 * userRegister
	 * @param data mixed
	 * @return mixed
	 */
	static function UserRegister($data) {
		if (DEBUG) _log(__CLASS__.'::'.__FUNCTION__);
		$response = array('status' => 0);
		$user = User::CreateUser($data);

		if ($user['statusCode'] == 0) {
			
			// sign up to mailchimp list depending on type
			$listid = '';
			switch($data['usertype']) {
				case 1:
				case 'model':
					$listid = MAILCHIMP_MODEL_LIST;
					break;
				case 2:
				case 'brand':
					$listid = MAILCHIMP_BRAND_LIST;
					break;
			}
			
			if (!empty($listid)) {
				$merge_vars = array('FNAME' => $data['firstname'], 'LNAME' => $data['lastname']);
				Mailchimp3::ListSubscribe($listid, $data['mail'], $merge_vars);
			}
			return self::UserLogin($data['mail'], $data['pass']);
		} else {
			$response['status'] = 0;
			$response['error'] = 'User could not be created';
			$response['errorData'] = $user;
			return $response;
		}
	}

	// loads user details based on the userID stored with the token
	static function UserLoad($token) {
		if (DEBUG) _log(__CLASS__.'::'.__FUNCTION__);
		$response = array('status' => 0);
		$uid = Redis::Get($token);
		$data = User::LoadUser($uid);
		$response['status'] = 1;

		// unset what we don't need - this array holds all fields we actually return
		$fields = array(
				'id', 'mail', 'telephone', 'firstname', 'lastname', 'avatar', 'filename', 'gender', 'usertype', 'status', 'instagram_username', 'instagram_followers', 'occupation', 
				'company_name', 'company_website', 'dob', 'country', 'nationality', 'residence_country', 'bank_sortcode',
				'bank_accountname', 'bank_accountnumber', 'vat_number', 'referrer_code', 'lead_image', 'ethnicity', 'available', 'profile', 'prefs',
				'kyc_by', 'kyc_on', 'kyc_document', 'location'
		);
		
		$returndata = array();
		foreach($fields as $k) {
			$returndata[$k] = !empty($data[$k])?$data[$k]:0;
		}
		
		if ($returndata['status'] == 0 ||$returndata['usertype'] == 2) {
			$returndata = self::SetDefaultUserData($returndata);
		}
		
		$response['userdata'] = $returndata;
		
		return $response;
	}

	static function UserSettings($token) {
		if (DEBUG) _log(__CLASS__.'::'.__FUNCTION__);
		$response = array('status' => 0);
		$uid = Redis::Get($token);
		$data = User::LoadUser($uid);
		$response['status'] = 1;
		if (DEBUG) {
			$response['calledUID'] = $uid;
			$response['token'] = $token;
		}
		$response['userdata'] = $data;
		return $response;
	}

	static function UserUpdate($token, $inputs) {
		if (DEBUG) _log(__CLASS__.'::'.__FUNCTION__);
		$response = array('status' => 0);

		$uid = Redis::Get($token);
		if ( $uid == 0) {
			$response['error'] = 'token not found.' ;
			return $response ;
		}

		$success = true;
		
		$userSettings = array();
		if (isset($inputs['height'])) $userSettings['height'] = $inputs['height'];
		if (isset($inputs['bust'])) $userSettings['bust'] = $inputs['bust'];
		if (isset($inputs['waist'])) $userSettings['waist'] = $inputs['waist'];
		if (isset($inputs['hips'])) $userSettings['hips'] = $inputs['hips'];
		if (isset($inputs['shoesize'])) $userSettings['shoesize'] = $inputs['shoesize'];
		if (isset($inputs['collarsize'])) $userSettings['collar_size'] = $inputs['collarsize'];
		if (isset($inputs['dresssize'])) $userSettings['dresssize'] = $inputs['dresssize'];
		if (isset($inputs['suitsize'])) $userSettings['suitsize'] = $inputs['suitsize'];
		if (isset($inputs['haircolour'])) $userSettings['haircolour'] = $inputs['haircolour'];
		if (isset($inputs['hairtype'])) $userSettings['hairtype'] = $inputs['hairtype'];
		if (isset($inputs['hairlength'])) $userSettings['hairlength']= $inputs['hairlength'];
		if (isset($inputs['willingtodye'])) $userSettings['willingtodye'] = ($inputs['willingtodye'] == 'yes'?1:0);
		if (isset($inputs['willingtocut'])) $userSettings['willingtocut'] = ($inputs['willingtocut'] == 'yes'?1:0);
		if (isset($inputs['drivinglicense'])) $userSettings['drivinglicense'] = ($inputs['drivinglicense	'] == 'yes'?1:0);
		if (isset($inputs['tattoo'])) $userSettings['tattoo'] = ($inputs['tattoo'] == 'yes'?1:0);
		if (isset($inputs['eyecolour'])) $userSettings['eyecolour'] = $inputs['eyecolour'];
		if (isset($inputs['eyebrowshape'])) $userSettings['eyebrowshape'] = $inputs['eyebrowshape'];
		if (isset($inputs['ringsize'])) $userSettings['ringsize'] = $inputs['ringsize'];
		if (isset($inputs['hourlyrate'])) $userSettings['hourlyrate'] = (!empty($inputs['hourlyrate']))?$inputs['hourlyrate']:0;
		if (isset($inputs['dailyrate'])) $userSettings['dailyrate'] =(!empty($inputs['dailyrate']))?$inputs['dailyrate']:0;
		if (isset($inputs['location'])) $userSettings['location'] =(!empty($inputs['location']))?$inputs['location']:93;
		if (isset($inputs['cupsize'])) $userSettings['cupsize'] =(!empty($inputs['cupsize']))?$inputs['cupsize']:-1;
		if (isset($inputs['skintone'])) $userSettings['skintone'] =(!empty($inputs['skintone']))?$inputs['skintone']:0;
		
		if (!empty($userSettings)) {
			$result = User::UpdateUserProfile($userSettings);
			if (isset($result['statusCode']) && $result['statusCode'] == 0) {
				$success = $result['result'];
			}
			$response['debug'][] = $result;
		}
		
		// email settings
		$userEmailSettings = array();
		if (isset($inputs['friend_registers'])) $userEmailSettings['friend_registers'] = ($inputs['friend_registers'] == 'on'?1:0);
		if (isset($inputs['job_offered'])) $userEmailSettings['job_offered'] = ($inputs['job_offered'] == 'on'?1:0);
		if (isset($inputs['job_cancelled'])) $userEmailSettings['job_cancelled'] = ($inputs['job_cancelled'] == 'on'?1:0);
		if (isset($inputs['job_changed'])) $userEmailSettings['job_changed'] = ($inputs['job_changed'] == 'on'?1:0);
		if (isset($inputs['payment_made'])) $userEmailSettings['payment_made'] = ($inputs['payment_made'] == 'on'?1:0);
		if (isset($inputs['notifications'])) $userEmailSettings['notifications'] = ($inputs['notifications'] == 'on'?1:0);
		
		if (!empty($userEmailSettings)) {
			$result = User::UpdateUserEmailPreferences($userEmailSettings);
			if (isset($result['statusCode']) && $result['statusCode'] == 0) {
				$success = $success && $result['result'];
			}
			$response['debug'][] = $result;
		}
		
		$userDetails = array();
		if (isset($inputs['firstname'])) $userDetails['firstname'] = $inputs['firstname'];
		if (isset($inputs['lastname'])) $userDetails['lastname'] = $inputs['lastname'];
		if (isset($inputs['mail'])) $userDetails['mail'] = $inputs['mail'];
		if (isset($inputs['country'])) $userDetails['country'] = $inputs['country'];
		if (isset($inputs['gender'])) $userDetails['gender'] = $inputs['gender'];
		if (isset($inputs['age'])) $userDetails['age'] = $inputs['age'];
		if (isset($inputs['ethnicity'])) $userDetails['ethnicity'] = $inputs['ethnicity'];
		if (isset($inputs['instagram'])) $userDetails['instagram'] = $inputs['instagram'];
		if (isset($inputs['occupation'])) $userDetails['occupation'] = $inputs['occupation'];
		if (isset($inputs['telephone'])) $userDetails['telephone'] = $inputs['telephone'];
		if (isset($inputs['company_name'])) $userDetails['company_name'] = $inputs['company'];
		if (isset($inputs['company_website'])) $userDetails['company_website'] = $inputs['website'];
		if (isset($inputs['dob'])) $userDetails['dob'] = !empty($inputs['dob'])?strtotime(str_replace('/', '-', $inputs['dob'])):0;
		if (isset($inputs['nationality'])) $userDetails['nationality'] = $inputs['nationality'];
		if (isset($inputs['residence_country'])) $userDetails['residence_country'] = $inputs['residence_country'];
		if (isset($inputs['vat_number'])) $userDetails['vat_number'] =(!empty($inputs['vatnumber']))?$inputs['vatnumber']:'';
		if (isset($inputs['oldpassword'])) $userDetails['oldpassword'] = $inputs['oldpassword'];
		if (isset($inputs['newpassword'])) $userDetails['newpassword'] = $inputs['newpassword'];
		if (isset($inputs['confirmpassword'])) $userDetails['newpassword2'] = $inputs['confirmpassword'];
		
		if (isset($inputs['bank_sortcode'])) $userDetails['bank_sortcode'] = $inputs['bank_sortcode'];
		if (isset($inputs['bank_accountnumber'])) $userDetails['bank_accountnumber'] = $inputs['bank_accountnumber'];
		if (isset($inputs['bank_accountname'])) $userDetails['bank_accountname'] = $inputs['bank_accountname'];
		if (isset($inputs['bank_iban'])) $userDetails['bank_iban'] = $inputs['bank_iban'];
		
		if (isset($userDetails['dob'])) {
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
		}
		if (!empty($userDetails)) {
			$result = User::UpdateUser($userDetails);
			if (isset($result['statusCode']) && $result['statusCode'] == 0) {
				$success = $success && $result['result'];
			}
			$response['debug'][] = $result;
		}
		
		if ($success) {
			$response['status'] = 1;
			$data = User::LoadUser($uid);
			self::$core->_user  = $data;
		} else {
			$response['status'] = 0;
		}
		return $response;
	}

	public static function UpdateAvatar($token) {
		if (DEBUG) _log(__CLASS__.'::'.__FUNCTION__);
		$response = array('status' => 0, 'No userid found');
		$uid = Redis::Get($token);
		if ($uid != 0) {
			$response = array('status' => 1);
			if (!empty($_FILES)) {
				if ($_FILES['avatar']['error'] != UPLOAD_ERR_OK) {
					switch ($_FILES['avatar']['error']) {
						case UPLOAD_ERR_INI_SIZE:
						case UPLOAD_ERR_FORM_SIZE:
							//too big
							$response['status'] = 0;
							$response['error'] = 'Please make sure your file is less than 2mb.';
							break;
						case UPLOAD_ERR_PARTIAL:
						case UPLOAD_ERR_NO_TMP_DIR:
						case UPLOAD_ERR_CANT_WRITE:
						case UPLOAD_ERR_EXTENSION:
							//various failures
							$response['status'] = 0;
							$response['error'] = 'An error occurred during upload, please refresh the page and try again.';
							break;
						case UPLOAD_ERR_NO_FILE:
							//no file
							$response['status'] = 0;
							$response['error'] = 'Please select a file to upload.';
							break;
					}
				} else {
					if (!in_array(strtolower(pathinfo($_FILES['avatar']['name'], PATHINFO_EXTENSION)), array('jpg','jpeg','png','bmp','gif'))) {
						$response['status'] = 0;
						$response['error'] = 'Only jpeg, jpg, png, bmp, and gif files allowed.';
					} else {
						$filename = Finda::UploadAvatar($uid);
						if ($filename) {
							$response['status'] = 1;
							$response['message'] = 'Your avatar has been changed.';
							$response['avatar'] = 'https://'.$_SERVER['HTTP_HOST'].'/images/user/avatars'.$filename['filename'];
							$response['filename'] = $filename['filename'];
							$response['response'] = $filename;
						} else {
							$response['status'] = 0;
							$response['uploaderror'] = $filename;
							$response['error'] = 'An upload error occurred, please try again.';
						}
					}
				}
			} else {
				$response['status'] = 0;
				$response['error'] = 'Please select a file to upload.';
			}
		}
		return $response;
	}

	public static function UpdateModelAvatar($imageid, $data) {
		$response = Model::CreateAvatarFromSource($imageid, $data);
		if ($response) {
			$response['status'] = 1;
		} else {
			$response['status'] = 0;
		}
		return $response;
	}
	
	
	public static function UpdateDeviceToken($token, $deviceToken, $deviceType) {
		$uid = Redis::Get($token);
		if ($uid != 0) {
			$response = ds('user_UpdateDeviceToken', array('uid' => $uid, 'deviceToken' => $deviceToken, 'deviceType' => $deviceType));
			return array('status' => 1, 'response' => $response);
		} else {
			return array('status' => 0, 'errorMessage' => 'error');
		}
	}

	public static function SendFeedback($token, $feedback) {
		$uid = Redis::Get($token);
		if ($uid != 0) {
			$response = ds('finda_SendFeedback', array('uid' => $uid, 'feedback' => $feedback));
			return array('status' => 1, 'response' => $response);
		} else {
			return array('status' => 0, 'errorMessage' => 'no userid provided with feedback request');
		}
	}

	public static function GetJobs($type) {
		$response['status'] = 0;
		$result = ds('jobs_ModelGetJobs', array('jobtype' => $type));
		if (isset($result['statusCode']) && $result['statusCode'] == 0) {
			$data = $result['result'];
			// run across the data and remove what we don't need
			foreach($data as $k => $v) {
				unset($data[$k]['id']);
				unset($data[$k]['job_status_text']);
				unset($data[$k]['model_ui']);
				unset($data[$k]['client_notes']);
				unset($data[$k]['modelid']);
				unset($data[$k]['model_uid']);
				unset($data[$k]['client_job_paid']);
				unset($data[$k]['modelcount']);
				// add the extra data we want
				if ($data[$k]['advanced']) {
					$adv = array();
					$data[$k]['contact_number'] = $data[$k]['advanced']['contact_number'];
					$data[$k]['contact_name'] = $data[$k]['advanced']['contact_name'];
					
					if (!empty($data[$k]['advanced']['model_to_bring'])) {
						$adv[] = 'Please bring: '.$data[$k]['advanced']['model_to_bring'];
					}
					if (!empty($data[$k]['advanced']['transport_methods'])) {
						$adv[] = 'Transport: '.$data[$k]['advanced']['transport_methods'];
					}
					if (!empty($data[$k]['advanced']['model_expenses'])) {
						$adv[] = 'Expenses: '.$data[$k]['advanced']['model_expenses'];
					}
					if (!empty($data[$k]['advanced']['model_meeting_point'])) {
						$adv[] = 'Meeting point: '.$data[$k]['advanced']['model_meeting_point'];
					}
					if (!empty($data[$k]['advanced']['makeup_provided'])) {
						$adv[] = 'Makeup: '.$data[$k]['advanced']['makeup_provided'];
					}
					$data[$k]['advanced'] = implode("\n", $adv);
				}
				if ($data[$k]['usage']) {
					foreach($data[$k]['usage'] as $kk => $vv) {
						$data[$k]['usage_'.$kk] = $vv;
					}
					unset($data[$k]['usage']);
				}
				
				// hide expired from the app
				if ($v['status_text'] == 'EXPIRED') {
					unset($data[$k]);
				}
			}
			
			
			$offered = array();
			$optioned = array();
			$expired = array();
			$accepted = array();
			$confirmed = array();
			$rejected = array();
			$cancelled = array();
			$finished = array();
			$expired = array();
			$tocomplete = array();
			$completed = array();
			$unconfirmed = array();
			foreach($data as $job) {
				switch($job['jobcard_type']) {
					case 'offered':
						$offered[] = $job;
						break;
						// deprecated
					case 'optioned':
						$optioned[] = $job;
						break;
					case 'expired':
						$expired[] = $job;
						break;
					case 'accepted':
						$accepted[] = $job;
						break;
					case 'confirmed':
						$confirmed[] = $job;
						break;
					case 'rejected':
						$rejected[] = $job;
						break;
					case 'cancelled':
						$cancelled[] = $job;
						break;
					case 'finished':
						$finished[] = $job;
						break;
					case 'to complete':
						$tocomplete[] = $job;
						break;
					case 'completed':
						$completed[] = $job;
						break;
				}
			}
			
			$jobs = array();
			
			switch($type) {
				// for App 1.0.16
				// 'accepted' -> 'Requests'
				// 'offered' -> 'Upcoming'
				// 'history' -> everything else
				case 'offered':
					$jobs['offered'] = array_merge($confirmed);
					break;
				case 'accepted':
					$jobs['accepted'] = array_merge($offered, $accepted);
					break;
				case 'all':
					$jobs['accepted'] = array_merge($offered, $accepted);
					$jobs['offered'] = array_merge($confirmed);
					$jobs['history'] = array_slice(array_merge($tocomplete, $completed, $finished, $unconfirmed, $rejected, $expired), 0, 50);
					break;
					
			}
			
			
			
			$response['status'] = 1;
			$response['userdata'] = $jobs;
		}
		$response['sql'] = $result['sql'];

		return $response;
	}
	
	public static function GetClientJobs($type) {
		$response['status'] = 0;
		$result = ds('jobs_ClientGetJobsList', array('jobtype' => $type));
		if (isset($result['statusCode']) && $result['statusCode'] == 0) {
			$jobs = $result['result'];
			
			$u = User::LoadUser(User::UserID());
			$allowInvoice = $u['profile']['allow_invoice'];
			$creditTerms = $u['profile']['credit_terms'];
			
			// run across the data and remove what we don't need
			foreach($jobs as $k => $v) {
				$jobs[$k]['jobid'] = $jobs[$k]['id'];
				// add the extra data we want
				if ($jobs[$k]['advanced']) {
					$adv = array();
					$jobs[$k]['contact_number'] = $jobs[$k]['advanced']['contact_number'];
					$jobs[$k]['contact_name'] = $jobs[$k]['advanced']['contact_name'];
					
					if (!empty($jobs[$k]['advanced']['model_to_bring'])) {
						$adv[] = 'Please bring: '.$jobs[$k]['advanced']['model_to_bring'];
					}
					if (!empty($jobs[$k]['advanced']['transport_methods'])) {
						$adv[] = 'Transport: '.$jobs[$k]['advanced']['transport_methods'];
					}
					if (!empty($jobs[$k]['advanced']['model_expenses'])) {
						$adv[] = 'Expenses: '.$jobs[$k]['advanced']['model_expenses'];
					}
					if (!empty($jobs[$k]['advanced']['model_meeting_point'])) {
						$adv[] = 'Meeting point: '.$jobs[$k]['advanced']['model_meeting_point'];
					}
					if (!empty($jobs[$k]['advanced']['makeup_provided'])) {
						$adv[] = 'Makeup: '.$jobs[$k]['advanced']['makeup_provided'];
					}
					$jobs[$k]['advanced'] = implode("\n", $adv);
				}
				if ($jobs[$k]['usage']) {
					foreach($jobs[$k]['usage'] as $kk => $vv) {
						$jobs[$k]['usage_'.$kk] = $vv;
					}
					unset($jobs[$k]['usage']);
				}
				
				// hide expired from the app
				if ($v['status_text'] == 'EXPIRED') {
					unset($jobs[$k]);
				}
			}
			
			
			$pending = array();
			$closed = array();
			$unfinalised = array();
			$past = array();
			$complete = array();
			$waiting = array();
			$due = array();			// for Clients on post-pay
			$overdue = array();
			$deleted = array();
			$incomplete = array();
			foreach($jobs as $jobk => $job) {
				$jobs[$jobk]['completedcount'] = 0;
				$jobs[$jobk]['acceptedcount'] = 0;
				$jobs[$jobk]['rejectedcount'] = 0;
				$jobs[$jobk]['offeredcount'] = 0;
				$jobs[$jobk]['optionedcount'] = 0;
				$jobs[$jobk]['modelcompletedcount'] = 0;
				$jobs[$jobk]['confirmedcount'] = 0;
				$jobs[$jobk]['negotiatingcount'] = 0;
				
				foreach($job['models'] as $k => $v) {
					if ($v['job_status'] == JOB_ASSIGNMENT_STATUS_CLIENT_COMPLETED || $v['job_status'] == JOB_ASSIGNMENT_STATUS_COMPLETED) {
						$jobs[$jobk]['completedcount']++;
					}
					if ($v['job_status'] == JOB_ASSIGNMENT_STATUS_MODEL_COMPLETED || $v['job_status'] == JOB_ASSIGNMENT_STATUS_COMPLETED) {
						$jobs[$jobk]['modelcompletedcount']++;
					}
					
					if ($v['job_status'] == JOB_ASSIGNMENT_STATUS_MODEL_ACCEPTED_OPTION) {
						$jobs[$jobk]['acceptedcount']++;
					}
					if ($v['job_status'] == JOB_ASSIGNMENT_STATUS_MODEL_CANCELLED) {
						$jobs[$jobk]['rejectedcount']++;
					}
					if ($v['job_status'] == JOB_ASSIGNMENT_STATUS_OFFERED) {
						$jobs[$jobk]['offeredcount']++;
						if (($v['model_desired_rate'] != $v['client_offered_rate']) && $v['agreed_rate'] == 0 && $v['model_desired_rate'] != 0) {
							$jobs[$jobk]['negotiatingcount']++;
						}
					}
					if ($v['job_status'] == JOB_ASSIGNMENT_STATUS_CLIENT_OPTIONED) {
						$jobs[$jobk]['optionedcount']++;
					}
					if ($v['job_status'] == JOB_ASSIGNMENT_STATUS_ACCEPTED || $v['job_status'] == JOB_ASSIGNMENT_STATUS_CLIENT_COMPLETED || $v['job_status'] == JOB_ASSIGNMENT_STATUS_MODEL_COMPLETED || $v['job_status'] == JOB_ASSIGNMENT_STATUS_COMPLETED) {	// model confirmed or completed
						$jobs[$jobk]['confirmedcount']++;
					}
				}
				
				$jobs[$jobk]['optionedmodelcount'] = count($job['models']);
				$jobs[$jobk]['totalselectedcount'] = count($job['models']);
				
				/*
				 * now we split these into their various arrays based on the current ruleset
				 */
				
				// need to calc totalfee now...
				$feetotal = 0;
				foreach($jobs[$jobk]['models'] as $feek => $feev) {
					if ($feev['agreed_rate'] != 0) {
						$fees = Jobs::GetJobValue($jobs[$jobk]);
						$feetotal = $fees['totalfee'];
					}
				}
				$jobs[$jobk]['feetotal'] = $feetotal;
				
				// we need 'today'
				$todaytimestamp = strtotime('today');
				
				// pending:
				if ($job['startdate'] >= $todaytimestamp && $job['job_status'] == JOB_ASSIGNMENT_STATUS_PENDING) {
					if ($jobs[$jobk]['modelcount'] == $jobs[$jobk]['acceptedcount'] && $jobs[$jobk]['job_status'] == JOB_ASSIGNMENT_STATUS_PENDING && $jobs[$jobk]['optionedmodelcount'] != 0) {
						$jobs[$jobk]['jobcard_type'] = 'confirmable';
						
					} else {
						$jobs[$jobk]['jobcard_type'] = 'pending';
					}
					
					$pending[] = $jobs[$jobk];
					unset($jobs[$jobk]);
				} else
				// with overdue invoices:
				if ($job['startdate'] < $todaytimestamp && ($job['job_status'] == JOB_ASSIGNMENT_STATUS_MODEL_ACCEPTED_OPTION || $job['job_status'] == JOB_ASSIGNMENT_STATUS_OFFERED) && $job['invoice_paid'] == 0) {
					
					if ($allowInvoice) {
						if (($job['startdate'] + (60 * 60 * 24 * $creditTerms)) < $todaytimestamp) {
							$jobs[$jobk]['jobcard_type'] = 'overdue';
							$overdue[] = $jobs[$jobk];
							unset($jobs[$jobk]);
						} else {
							$jobs[$jobk]['jobcard_type'] = 'due';
							$due[] = $jobs[$jobk];
							unset($jobs[$jobk]);
						}
					} else {
						$jobs[$jobk]['jobcard_type'] = 'overdue';
						$overdue[] = $jobs[$jobk];
						unset($jobs[$jobk]);
					}
				} else
						
				if ($job['startdate'] > $todaytimestamp && $job['job_status'] == 1) {
					$jobs[$jobk]['jobcard_type'] = 'confirmed';
					
					$closed[] = $jobs[$jobk];
					unset($jobs[$jobk]);
				} else
					
				// unfinalised:
				if ($job['startdate'] < $todaytimestamp && $job['job_status'] == JOB_ASSIGNMENT_STATUS_OFFERED && $jobs[$jobk]['optionedmodelcount'] != $jobs[$jobk]['completedcount']) {
					$jobs[$jobk]['jobcard_type'] = 'unfinalised';
					$unfinalised[] = $jobs[$jobk];
					
					unset($jobs[$jobk]);
				} else
					
				// past unclosed:
				if ($job['startdate'] < $todaytimestamp && $job['job_status'] == JOB_ASSIGNMENT_STATUS_PENDING && $job['invoice_paid'] == 0) {
					$jobs[$jobk]['jobcard_type'] = 'rate models';
					$incomplete[] = $jobs[$jobk];
					unset($jobs[$jobk]);
				} else
					
				// completed:
				if ($job['startdate'] <= $todaytimestamp && $job['job_status'] == JOB_ASSIGNMENT_STATUS_OFFERED && $job['invoice_paid'] == 1) {
					$jobs[$jobk]['jobcard_type'] = 'complete';
					$complete[] = $jobs[$jobk];
					unset($jobs[$jobk]);
				} else
					
					
				// waiting for models to complete:
				if ($job['startdate'] <= $todaytimestamp && $job['job_status'] == JOB_ASSIGNMENT_STATUS_OFFERED && $jobs[$jobk]['acceptedcount'] != $jobs[$jobk]['modelcompletedcount'] && $job['invoice_paid'] == 1) {
					$jobs[$jobk]['jobcard_type'] = 'waiting';
					$waiting[] = $jobs[$jobk];
					unset($jobs[$jobk]);
				} else
					
				if ($job['startdate'] <= $todaytimestamp && $job['job_status'] == JOB_ASSIGNMENT_STATUS_PENDING && $jobs[$jobk]['modelcompletedcount'] == $jobs[$jobk]['totalselectedcount'] && $job['invoice_paid'] == 1) {
					$jobs[$jobk]['jobcard_type'] = 'unfinalised';
					$unfinalised[] = $jobs[$jobk];
					unset($jobs[$jobk]);
				} else
					
				// deleted:
				if ($job['job_status'] == 2) {
					$jobs[$jobk]['jobcard_type'] = 'deleted';
					$deleted[] = $jobs[$jobk];
					unset($jobs[$jobk]);
				} else {
					// anything uncategorised, in-test or with unexpected data sets
					if (DEBUG) {
						$jobs[$jobk]['jobcard_type'] = 'DEBUG';
						$past[] = $jobs[$jobk];
						unset($jobs[$jobk]);
						
					}
				}
			}
			
			$data = array();
			$data['upcoming'] = array_merge($pending, $waiting, $due, $closed);
			$data['past'] = array_merge($unfinalised, $incomplete, $due, $overdue);
			$data['history'] = array_merge($complete, $past, $deleted);
			
			$response['status'] = 1;
			$response['userdata'] = $data;
		}
		
		return $response;
	}
	
	public static function GetJobDetails($token, $jobid) {
		$uid = Redis::Get($token);
		$response = array();
		$response['status'] = 1;
		$response['uid'] = $uid;
		$job = Jobs::GetJobDetails($jobid);
		
		// android is stupid sometimes
		foreach($job['models'] as $k => $model) {
			$response['models'][] = $model;
		}
		
		$job['jobid'] = $job['id'];
		
		// add the extra data we want
		if ($job['advanced']) {
			$adv = array();
			$job['contact_number'] = $job['advanced']['contact_number'];
			$job['contact_name'] = $job['advanced']['contact_name'];
			
			if (!empty($job['advanced']['model_to_bring'])) {
				$adv[] = 'Please bring: '.$job['advanced']['model_to_bring'];
			}
			if (!empty($job['advanced']['transport_methods'])) {
				$adv[] = 'Transport: '.$job['advanced']['transport_methods'];
			}
			if (!empty($job['advanced']['model_expenses'])) {
				$adv[] = 'Expenses: '.$job['advanced']['model_expenses'];
			}
			if (!empty($job['advanced']['model_meeting_point'])) {
				$adv[] = 'Meeting point: '.$job['advanced']['model_meeting_point'];
			}
			if (!empty($job['advanced']['makeup_provided'])) {
				$adv[] = 'Makeup: '.$job['advanced']['makeup_provided'];
			}
			$job['advanced'] = implode("\n", $adv);
		}
		if ($job['usage']) {
			foreach($job['usage'] as $kk => $vv) {
				$job['usage_'.$kk] = $vv;
			}
			unset($job['usage']);
		}
		
		
		// specific model!
		$job['status'] = $job['models'][$uid]['job_status'];
		
		$statustext = array();
		$statustext[0] = 'INVALID';
		$statustext[1] = 'REQUESTED';
		$statustext[2] = 'CONFIRMED';
		$statustext[3] = 'MODEL_CANCELLED';
		$statustext[4] = 'CLIENT_CANCELLED';
		$statustext[5] = 'MODEL_COMPLETED';
		$statustext[6] = 'CLIENT_COMPLETED';
		$statustext[7] = 'COMPLETED';
		$statustext[9] = 'SELECTED';
		$statustext[10] = 'OPTIONED';
		$statustext[11] = 'CLIENT SELECTED';
		$statustext[12] = 'MODEL REJECTED OPTION';
		$statustext[14] = 'ACCEPTED';
		$statustext[20] = 'CLIENT_REMOVED';
		
		$job['status_text'] = $statustext[$job['models'][$uid]['job_status']];

		// hide expired from the app
		if ($job['status_text'] == 'EXPIRED') {
			unset($job);
		}
		
		$response['userdata'] = $job;
		return $response;
	}
	
	public static function ClientGetJobDetails($token, $jobid) {
		$uid = Redis::Get($token);
		$response = array();
		$response['status'] = 1;
		$response['uid'] = $uid;
		$job = Jobs::GetJobDetails($jobid);
		$job['jobcard_type'] = Jobs::GetDefinedJobTypeForClient($job);
		
		$statustext = array();
		$statustext[0] = 'INVALID';
		$statustext[1] = 'REQUESTED';
		$statustext[2] = 'CONFIRMED';
		$statustext[3] = 'MODEL_CANCELLED';
		$statustext[4] = 'CLIENT_CANCELLED';
		$statustext[5] = 'MODEL_COMPLETED';
		$statustext[6] = 'CLIENT_COMPLETED';
		$statustext[7] = 'COMPLETED';
		$statustext[9] = 'SELECTED';
		$statustext[10] = 'OPTIONED';
		$statustext[11] = 'CLIENT SELECTED';
		$statustext[12] = 'MODEL REJECTED OPTION';
		$statustext[14] = 'ACCEPTED';
		$statustext[20] = 'CLIENT_REMOVED';

		// android is stupid sometimes
		foreach($job['models'] as $k => $model) {
			$model['status_text'] = $statustext[$model['job_status']];
			$response['models'][] = $model;
		}
		
		$job['jobid'] = $job['id'];
		
		// add the extra data we want
		if ($job['advanced']) {
			$adv = array();
			$job['contact_number'] = $job['advanced']['contact_number'];
			$job['contact_name'] = $job['advanced']['contact_name'];
			
			if (!empty($job['advanced']['model_to_bring'])) {
				$adv[] = 'Please bring: '.$job['advanced']['model_to_bring'];
			}
			if (!empty($job['advanced']['transport_methods'])) {
				$adv[] = 'Transport: '.$job['advanced']['transport_methods'];
			}
			if (!empty($job['advanced']['model_expenses'])) {
				$adv[] = 'Expenses: '.$job['advanced']['model_expenses'];
			}
			if (!empty($job['advanced']['model_meeting_point'])) {
				$adv[] = 'Meeting point: '.$job['advanced']['model_meeting_point'];
			}
			if (!empty($job['advanced']['makeup_provided'])) {
				$adv[] = 'Makeup: '.$job['advanced']['makeup_provided'];
			}
			$job['advanced'] = implode("\n", $adv);
		}
		if ($job['usage']) {
			foreach($job['usage'] as $kk => $vv) {
				$job['usage_'.$kk] = $vv;
			}
			unset($job['usage']);
		}
		
		$response['userdata'] = $job;
		return $response;
	}
	
	public static function RejectOption($jobid) {
		$response = array();
		$response['status'] = 0;
		$data = Jobs::ModelRejectOption($jobid);
		if ($data) {
			$response['status'] = 1;
		}
		return $response;
	}
	
	public static function UpdateAvailability($token, $available) {
		$response['status'] = 0;
		$uid = Redis::Get($token);
		if ( $uid == 0) {
			$response['error'] = 'token not found.' ;
			return $response ;
		}
		$userDetails = array();
		$userDetails['available'] = $available;
		$response = User::UpdateUser($userDetails);

		$result = User::UpdateUser($userDetails);
		if (isset($result['statusCode']) && $result['statusCode'] == 0) {
			$response['status'] = 1;
		}
		
		return $response;
	}
	
	public static function AcceptJob($jobid) {
		$response = array();
		$response['status'] = 0;
		$data = Jobs::ModelAcceptJob($jobid);
		if ($data) {
			$response['status'] = 1;
		}
		return $response;
	}
	
	public static function RejectJob($jobid, $reasons) {
		$response = array();
		$response['status'] = 0;
		$data = Jobs::ModelRejectJob($jobid, $reasons);
		if ($data) {
			$response['status'] = 1;
		}
		return $response;
	}
	
	public static function CompleteJob($token, $jobid) {
		$response = array();
		$response['status'] = 0;
		$data = Jobs::ModelCompleteJob($jobid);
		if (DEBUG) {
			$uid = Redis::Get($token);
			$response['calledUID'] = $uid;
			$response['jobid'] = $jobid;
			$response['data'] = $data;
		}
		if ($data) {
			$response['status'] = 1;
		}
		return $response;
	}
	
	public static function CancelJob($jobid) {
		$response = array();
		$response['status'] = 0;
		$data = Jobs::ModelCancelAcceptance($jobid);
		if ($data) {
			$response['status'] = 1;
		}
		return $response;
	}
	
	public static function GetModelInvoices() {
		$response = array();
		$response['status'] = 0;
		$invoices = Finance::RetrieveModelInvoices(User::UserID());
		if ($invoices) {
			$response['status'] = 1;
			$response['userdata'] = $invoices;
		}
		return $response;
	}
	
	public static function GetClientInvoices() {
		$response = array();
		$response['status'] = 0;
		$invoices = Finance::RetrieveInvoices(User::UserID());
		if ($invoices) {
			$response['status'] = 1;
			$response['userdata'] = $invoices;
		}
		return $response;
	}
	
	public static function Negotiatejob($jobid, $rate, $reasons) {
		$response = array();
		$response['status'] = 0;
		$data = Jobs::RateCounterOffer($jobid, $rate, implode(',', $reasons));
		if ($data) {
			$response['status'] = 1;
		}
		return $response;
	}
	
	/* *****************************************************************************************************************************
	 * Generic functions
	 * *****************************************************************************************************************************/
	public static function GetTermData($vid) {
		$response = array();
		$data = Taxonomy::GetTermsByVocabulary($vid);
		$response['status'] = 0;
		if ($data) {
			foreach($data as $k => $v) {
				unset($data[$k]['vid']);
				unset($data[$k]['description']);
				unset($data[$k]['weight']);
				unset($data[$k]['label']);
				unset($data[$k]['enabled']);
			}
			$response['status'] = 1;
			$response['userdata'] = $data;
		}
		return $response;
	}
	
	public static function GetComposedNotifications($sender) {
		$response = array();
		$response['status'] = 0;
		$data = Notification::GetComposedNotifications($sender);
		if ($data) {
			$returndata = array();
			foreach($data as $kk => $vv) {
				// strip <a> tags from the message field and replace with <b> tags
				$vv['message'] = preg_replace("/<a\s(.+?)>(.+?)<\/a>/is", "<b><em>$2</em></b>", $vv['message']);
				$returndata[] = $vv;
				
			}
			$response['status'] = 1;
			// we don't currently paginate notifications, so limit it to the most recent 20
			$response['userdata'] = $returndata; // array_slice($returndata, 0, 20);
		}
		return $response;
		
	}
	
	public static function SendComposedNotification($recipient, $message, $subject, $type) {
		$response = array();
		$response['status'] = 0;
		if (($message != '' && $message != 'Your message') || $subject != "") {
			if ($type == MESSAGE_TYPE_COMPOSED_IMAGE) {
				$result = Notification::SendComposedImageMessage($recipient, $subject, $message);
			} else {
				$result = Notification::SendComposedMessage($recipient, $message);
			}
			if ($result) {
				$response['status'] = 1;
			}
		}
		return $response;
		
	}
	
	public static function GetNotifications($type, $count = false) {
		$response = array();
		$response['status'] = 0;
		if ($count) {
			$data = Notification::GetNotificationCount($type);
			$response['status'] = 1;
			$response['userdata'] = $data;
		} else {
			switch($type) {
				case 'new':
					$data = Notification::GetNewNotifications();
					break;
				default:
					$data = Notification::GetAllNotifications();
					break;
			}
			if ($data) {
				$fields = array(
					'id', 'firstname', 'lastname', 'status', 'avatar', 'jobid', 'message', 'timestamp'
				);
				
				$returndata = array();
					foreach($data as $kk => $vv) {
						// strip <a> tags from the message field and replace with <b> tags
						$vv['message'] = preg_replace("/<a\s(.+?)>(.+?)<\/a>/is", "<b><em>$2</em></b>", $vv['message']);
						$returndata[] = $vv;
					 
					}
				$response['status'] = 1;
				// we don't currently paginate notifications, so limit it to the most recent 20
				$response['userdata'] = array_slice($returndata, 0, 20);
			}
		}
		return $response;
	}
	
	public static function DeleteNotification($msgid) {
		$response = array();
		$response['status'] = 0;
		$data = Notification::DeleteNotification($msgid);
		if ($data) {
			$response['status'] = 1;
		}
		return $response;
	}
	
	public static function FlagNotification($msgid) {
		$response = array();
		$response['status'] = 0;
		$data = Notification::FlagMessage($msgid, 'Flagged by user in the App');
		if ($data) {
			$response['status'] = 1;
		}
		return $response;
	}
	
	public static function GetUserImages($type, $sefu) {
		$response = array();
		$response['status'] = 0;
		
		if (!empty($sefu)) {
			$user = Finda::GetUserBySefu($sefu, TYPE_MODEL);
			$userid = $user['id'];
		} else {
			$userid = 0;
		}
		
		$data = Finda::GetUserImages($type, $userid);
		if ($data) {
			
			$returndata = array();
			foreach($data as $k => $v) {
				unset($data[$k]['uid']);
				unset($data[$k]['created']);
				unset($data[$k]['originalname']);
				unset($data[$k]['enabled']);
				$returndata[] = $v;
			}
			
			$response['status'] = 1;
			$response['userdata'] = $returndata;
		}
		return $response;
	}
	
	public static function GetModelImages($type, $userid) {
		$response = array();
		$response['status'] = 0;
		
		$data = Finda::GetUserImages($type, $userid);
		if ($data) {
			
			$returndata = array();
			foreach($data as $k => $v) {
				unset($data[$k]['uid']);
				unset($data[$k]['created']);
				unset($data[$k]['originalname']);
				unset($data[$k]['enabled']);
				$returndata[] = $v;
			}
			
			$response['status'] = 1;
			$response['userdata'] = $returndata;
		}
		return $response;
	}
	
	public static function MakeLeadImage($imageid) {
		$response = array();
		$response['status'] = 0;
		$response = Finda::MakeImageLeader($imageid);
		if ($response) {
			$response['status'] = 1;
		}
		return $response;
	}
	
	public static function RemoveImage($imageid) {
		$response = array();
		$response['status'] = 0;
		$response = Finda::RemoveUserImage($imageid);
		if ($response) {
			$response['status'] = 1;
		}
		return $response;
	}

	public static function UploadImage($token, $imagetype) {
		if (DEBUG) _log(__CLASS__.'::'.__FUNCTION__);
		$response = array('status' => 0, 'No userid found');
		$uid = Redis::Get($token);
		if ($uid != 0) {
			$response = array('status' => 1);
			if (!empty($_FILES)) {
				if ($_FILES[$imagetype]['error'] != UPLOAD_ERR_OK) {
					switch ($_FILES[$imagetype]['error']) {
						case UPLOAD_ERR_INI_SIZE:
						case UPLOAD_ERR_FORM_SIZE:
							//too big
							$response['status'] = 0;
							$response['error'] = 'Please make sure your file is less than 10mb.';
							break;
						case UPLOAD_ERR_PARTIAL:
						case UPLOAD_ERR_NO_TMP_DIR:
						case UPLOAD_ERR_CANT_WRITE:
						case UPLOAD_ERR_EXTENSION:
							//various failures
							$response['status'] = 0;
							$response['error'] = 'An error occurred during upload, please refresh the page and try again.';
							break;
						case UPLOAD_ERR_NO_FILE:
							//no file
							$response['status'] = 0;
							$response['error'] = 'Please select a file to upload.';
							break;
					}
				} else {
					if (!in_array(strtolower(pathinfo($_FILES[$imagetype]['name'], PATHINFO_EXTENSION)), array('jpg','jpeg','png','bmp','gif'))) {
						$imageint = exif_imagetype($_FILES[$imagetype]['tmp_name']);
						if (!in_array($imageint, array(IMAGETYPE_BMP, IMAGETYPE_GIF, IMAGETYPE_JPEG, IMAGETYPE_JPEG2000, IMAGETYPE_PNG))) {
							$response['status'] = 0;
							$response['error'] = 'Sorry, we can only accept jpeg, jpg, png, bmp, or gif image file.';
							$response['imageint'] = $imageint;
						} else {
							$filename = Finda::UploadImage($imagetype);
							if ($filename) {
								$response['status'] = 1;
								$response['message'] = 'Your image has been saved.';
								$response['filename'] = $filename['filename'];
								$response['response'] = $filename;
							} else {
								$response['status'] = 0;
								$response['uploaderror'] = $filename;
								$response['error'] = 'An upload error occurred, please try again.';
							}
						}
					} else {
						$filename = Finda::UploadImage($imagetype);
						if ($filename) {
							$response['status'] = 1;
							$response['message'] = 'Your image has been saved.';
							$response['filename'] = $filename['filename'];
							$response['response'] = $filename;
						} else {
							$response['status'] = 0;
							$response['uploaderror'] = $filename;
							$response['error'] = 'An upload error occurred, please try again.';
						}
					}
				}
			} else {
				$response['status'] = 0;
				$response['error'] = 'Please select a file to upload.';
			}
		}
		
		return $response;
	}
	
	public static function GetCalendar($token, $start, $end) {
		$uid = Redis::Get($token);
		if ($uid != 0) {
			$response = ds('model_GetModelSchedule', array('modelid' => $uid, 'start' => $start, 'end' => $end));
			if (isset($response['statusCode']) && $response['statusCode'] == 0) {
				return array('status' => 1, 'userdata' => $response['result']);
			}
			return array('status' => 0, 'uid' => $uid, 'error' => $response);
		}
		return array('status' => 0, 'uid' => $uid);
		
	}
	
	public static function GetCalendarEvents($token, $date) {
		$uid = Redis::Get($token);
		if ($uid != 0) {
			$response = ds('model_LoadScheduleItemsForDate', array('modelid' => $uid, 'date' => $date));
			if (isset($response['statusCode']) && $response['statusCode'] == 0) {
				return array('status' => 1, 'userdata' => $response['result'], 'sql' => $response['sql']);
			}
			return array('status' => 0, 'error' => $response);
		}
		return array('status' => 0);
		
	}
	
	public static function GetLastMinute($token) {
		$response = array('status' => 0);
		$uid = Redis::Get($token);
		if ($uid != 0) {
			// get current user availability
			$lastminute = Model::GetModelAvailability($uid);
			unset($lastminute['uid']);
			$response['status'] = 1;
			$response['availability'] = $lastminute;
		}
		return $response;
	}
	
	public static function SetLastMinute($token, $availability) {
		$response = array('status' => 0);
		$uid = Redis::Get($token);
		if ($uid != 0) {
			$response = Model::UpdateModelAvailability($availability, $uid);
			if (isset($response['statusCode']) && $response['statusCode'] == 0) {
				$response['status'] = 1;
				$response['userdata'] = $response['result'];
			}
		}
		return $response;
	}
	
	
	public static function CancelModel($jobid, $modelid) {
		$response = array();
		$response['status'] = 0;
		$data = Jobs::ClientUpdateModelForJob($jobid, $modelid, 4);
		if ($data) {
			$response['status'] = 1;
		}
		return $response;
	}
	
	public static function CompleteModel($jobid, $modelid) {
		$response = array();
		$response['status'] = 0;
		$data = Jobs::ClientUpdateModelForJob($jobid, $modelid, 6);
		if ($data) {
			$response['status'] = 1;
		}
		return $response;
	}
	
	public static function ConfirmModel($jobid, $modelid) {
		$response = array();
		$response['status'] = 0;
		$data = Jobs::ClientUpdateModelForJob($jobid, $modelid, 2);
		if ($data) {
			$response['status'] = 1;
		}
		return $response;
	}
	
	public static function RequestModel($jobid, $modelid) {
		$response = array();
		$response['status'] = 0;
		$data = Jobs::ClientUpdateModelForJob($jobid, $modelid, 1);
		if ($data) {
			$response['status'] = 1;
		}
		return $response;
	}
	
	public static function GetReferrals($token) {
		$response = array();
		$response['status'] = 0;
		$uid = Redis::Get($token);
		if ($uid != 0) {
			$userdata = array();
			$affiliates = Finda::GetAffiliates();
			$userdata['referrals'] = $affiliates;
			$verified = 0;
			foreach($affiliates as $affiliate) {
				if ($affiliate['status'] == 1) {
					$verified++;
				}
			}
			$userdata['verified'] = $verified;
			$response['status'] = 1;
			$response['userdata'] = $userdata;
		}
		return $response;
	}
}
