<?php
/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
namespace Croissant;

class User extends Core {
	static $core;
	public static function Initialise() {
		if (!isset(self::$core)) {
			if (DEBUG) _log(__CLASS__.'::'.__FUNCTION__);
			self::$core = parent::Initialise();
		}
		return self::$core;
	}

	/**
	 * Login process
	 *
	 * @param string $mail
	 * @param string $password
	 * @param bool $remember
	 * @param string $sessionid
	 * @param integer $timestamp
	 * @param integer $override
	 * @return
	 */
	static public function Login($mail, $password, $remember = false, $sessionid = '', $timestamp = 0, $override = 0) {
		if (DEBUG) _log(__CLASS__.'::'.__FUNCTION__);
		$mail = (string)$mail;
		$password = (string)$password;

		if (strlen($password) != 32) {
			$password = md5($password);
		}

		$response = ds('user_Login', array('mail' => $mail, 'password' => $password, 'remember' => $remember, 'sessionid' => $sessionid, 'timestamp' => $timestamp, 'override' => $override));
		if (isset($response['status'])) {
			if ($response['statusCode'] == 0) {
				self::$core->_user = $response['result'];

				foreach(Core::$core->_user_session as $k) {
					Session::SetVariable($k, self::$core->_user[$k]);
				}

				return $response['result'];
			} else {
				if (isset($response['errorData']) && $response['errorData'] == 'loggedin') {
					return $response;
				} else {
// 					return $response;
					return false;
				}
			}
		}
	}

    static public function FBLogin($login_data) {
		if (DEBUG) _log(__CLASS__.'::'.__FUNCTION__);
		// $mail = (string)$mail;
		// $password = (string)$password;
		// if (strlen($password) != 32) {
		// 	$password = md5($password);
		// }

		$response = ds('user_FBLogin', array('login_data' => $login_data));
		if (isset($response['status'])) {
			if ($response['statusCode'] == 0) {
				self::$core->_user  = $response['result'];

				foreach(Core::$core->_user_session as $k) {
					Session::SetVariable($k, self::$core->_user[$k]);
				}
				return $response['result'];
			} else {
				if (isset($response['errorData']) && $response['errorData'] == 'loggedin') {
					return $response;
				} else {
					return false;
				}
			}
		}
	}

	/**
	 * Get logged in user id
	 *
	 * @return
	 */
	static public function UserID() {
		if (DEBUG) _log(__CLASS__.'::'.__FUNCTION__);
		if (isset(self::$core->_user['id'])) {
			if (empty(self::$core->_user['id'])) {
				return 0;
			}
			return self::$core->_user['id'];
		} else {
			return 0;
		}
	}
	
	static public function Sefu() {
		if (DEBUG) _log(__CLASS__.'::'.__FUNCTION__);
		if (isset(self::$core->_user['sefu'])) {
			if (empty(self::$core->_user['sefu'])) {
				return 0;
			}
			return self::$core->_user['sefu'];
		} else {
			return 0;
		}
	}
	
	/**
	 * Checks to see if a passed string is an Instagram Handle
	 * @param String $handle
	 * 
	 * @Return bool
	 */
	static public function IsInstagramHandle($handle) {
		$response = ds('user_IsInstagramHandle', array('handle' => $handle));
		if (isset($response['statusCode']) && $response['statusCode'] == 0) {
			return $response['result'];
		} else {
			return false;
		}
	}
	
	/**
	 * Checks to see if a passed string is an internal referrer_code
	 * @param String $handle
	 *
	 * @Return bool
	 */
	static public function IsReferrerCode($handle) {
		$response = ds('user_IsReferrerCode', array('handle' => $handle));
		if (isset($response['statusCode']) && $response['statusCode'] == 0) {
			return $response['result'];
		} else {
			return false;
		}
	}
	
	static public function Email() {
		if (DEBUG) _log(__CLASS__.'::'.__FUNCTION__);
		return self::$core->_user['mail'];
	}
	
	static public function StripeID() {
		if (DEBUG) _log(__CLASS__.'::'.__FUNCTION__);
		return self::$core->_user['stripe_id'];
	}

	/**
	 * Get logged in user property
	 *
	 * @param string $attribute
	 * @return
	 */
	static public function GetAttribute($attribute) {
		if (DEBUG) _log(__CLASS__.'::'.__FUNCTION__);
		return self::$core->_user[$attribute];
	}


	/**
	 * Set User Hash
	 */
	static final public function setUserHash() {
		if (DEBUG) _log(__CLASS__.'::'.__FUNCTION__);
		Session::SetVariable('user_hash', md5(uniqid(rand(), true)));
	}

	/**
	 * Get User Hash
	 *
	 * @return user hash
	 */
	static final public function getUserHash() {
		return Session::GetVariable('user_hash');
	}

	/**
	 * Get User session id
	 *
	 * @param mixed $userid
	 * @return
	 */
	static function GetSessionID($userid) {
		if (DEBUG) _log(__CLASS__.'::'.__FUNCTION__);
		$response = ds('user_GetSessionID', array('userid' => $userid));
		return Core::GenericResponse($response);
	}

	/**
	 * Load user data by userid.
	 *
	 * @param integer $userid
	 * @return mixed
	 */
	static public function LoadUser($userid = 0) {
		if (DEBUG) _log(__CLASS__.'::'.__FUNCTION__);
		$userid = (int)$userid;
		if ($userid != 0) {
			$response = ds('user_LoadUser', array('userid' => $userid));
			// @TODO this workaround needs to be done differently
			/*
			 * Implement an email replacement when loading a user's details
			 * For one specific user - Jake Hall
			 * Jake Hall Client ID: 740
			 * Jake Hall Model ID: 894
			 */
			
			if ($userid == 894) {
				$response['result']['mail'] = 'jake@prevustudio.com';
			}
			
			return Core::GenericResponse($response);
		} else {
			return false;
		}
	}

	/**
	 * Load user by email.
	 *
	 * @param string $email
	 * @return
	 */
	static public function LoadUserByMail($email = '') {
		if (DEBUG) _log(__CLASS__.'::'.__FUNCTION__);
		if ($email != '') {
			$response = ds('user_LoadUserByEmail', array('email' => $email));
			return Core::GenericResponse($response);
		} else {
			return false;
		}
	}

	/**
	 * Load current user
	 *
	 * @return
	 */
	static public function LoadCurrentUser() {
		if (DEBUG) _log(__CLASS__.'::'.__FUNCTION__);
		$userid = self::UserID();
		if ($userid != 0) {
			if (empty(self::$core->_user)) {
				$response = ds('user_Loaduser', array('userid' => $userid));
				if (isset($response['statusCode']) && $response['statusCode'] == 0) {
					self::$core->_user = $response['result'];
				}
			}
		}

		return self::$core->_user;
	}

	/**
	 * Logout
	 *
	 * @param bool $local
	 * @return
	 */
	static final public function Logout($local = false) {
		if (DEBUG) _log(__CLASS__.'::'.__FUNCTION__);
		if ($local === false) {
			// ds('user_Logout');
		}
		foreach(Core::$core->_user_session as $k) {
			Session::Setvariable($k, '');
		}

		setcookie(PERSISTENT_LOGIN_COOKIE, -1);
		unset(Core::$core->_user);

		$cookie_domain = ini_get('session.cookie_domain');
		if ($cookie_domain) {
			$session_name = $cookie_domain;
		} else {
			$session_name = $_SERVER['HTTP_HOST'];
			if (!empty($_SERVER['HTTP_HOST'])) {
				$cookie_domain = $_SERVER['HTTP_HOST'];
			}
		}
		$cookie_domain = explode(':', $cookie_domain);
		$cookie_domain = $cookie_domain[0];
		if (count(explode('.', $cookie_domain)) > 2 && !is_numeric(str_replace('.', '', $cookie_domain))) {
			ini_set('session.cookie_domain', $cookie_domain);
		}
		Cookie::SetCookie('SESS'.md5($session_name), '', -1);
		session_destroy();
		return;
	}

	/**
	 * Check Username
	 *
	 * @param $username
	 * @param bool $inverse - invert the response (this would make the presence of NO matching username return TRUE and vice versa)
	 * @return int or boolean The users id or false for failure
	 */
	static final public function CheckUsername($username, $inverse = false) {
		if (DEBUG) _log(__CLASS__.'::'.__FUNCTION__);
		if (!$username) return false;

		$response = ds('user_CheckUsername', array('username' => $username));
		if ($response['statusCode']==0) {
			return ($inverse) ? ! $response['result'] : $response['result'];
		} else {
			return false;
		}
	}

	/**
	 * Check Email
	 *
	 * @param $email
	 * @param bool $inverse - invert the response (this would make the presence of NO matching email return TRUE and vice versa)
	 * @return array or boolean
	 */
	static final public function CheckEmail($email, $inverse = false) {
		if (DEBUG) _log(__CLASS__.'::'.__FUNCTION__);
		if (!$email) return false;

		$response = ds('user_CheckEmail', array('email' => $email));
		if ($response['statusCode'] == 0) {
			return ($inverse) ? !$response['result'] : $response['result'];
		} else {
			return $response;
		}
	}

    /**
	 * Check Facebook ID
	 *
	 * @param $email
	 * @param bool $inverse - invert the response (this would make the presence of NO matching facebook_id return TRUE and vice versa)
	 * @return array or boolean
	 */
	static final public function CheckFacebookID($facebookid, $inverse = false) {
		if (DEBUG) _log(__CLASS__.'::'.__FUNCTION__);
		if (!$facebookid) return false;

		$response = ds('user_CheckFacebookID', array('facebookid' => $facebookid));
		if ($response['statusCode'] == 0) {
			return ($inverse) ? !$response['result'] : $response['result'];
		} else {
			return false;
		}
	}

	static final function CheckTwitterID($twitterID, $inverse = false) {
		if (DEBUG) _log(__CLASS__.'::'.__FUNCTION__);
		if (!$twitterID) return false;

		$response = ds('user_CheckTwitterID', array('twitterid' => CheckTwitterID));
		if ($response['statusCode']==0) {
			return ($inverse) ? !$response['result'] : $response['result'];
		} else {
			return false;
		}
	}

	/**
	 * Check if the password entered is the current user's password
	 *
	 * @param string $password - the string to check against the password
	 * @return bool - true for a match or false
	 */
	static public function CheckPassword($password) {
		if (DEBUG) _log(__CLASS__.'::'.__FUNCTION__);
		ds('passwordhash_InitHash', array('iteration_count_log2' => 8, 'portable_hashes' => false));
		$password = md5($password);
		$result = ds('user_CheckPassword', array('password' => $password, 'stored_hash' => User::Password()));
		if ($password == User::Password() || $result['result']) {
			return true;
		} else {
			return false;
		}
	}

	/**
	 * Generate a random string for a temporary password
	 * @param int $length - the length of the created password
	 * @return string
	 */
	public static function CreateTempPassword($length = 10) {
		if (DEBUG) _log(__CLASS__.'::'.__FUNCTION__);
		$characters = "0123456789abcdefghijklmnopqrstuvwxyz";
		$pass = '';
		for ($p = 0; $p < $length; $p++) {
			$pass .= $characters[mt_rand(0, strlen($characters))];
		}
		return $pass;
	}

	/**
	 * Change user password.
	 *
	 * @param string $newpassword
	 * @param bool $userid
	 * @return
	 */
	public static function ChangePassword($newpassword, $userid = false) {
		if (DEBUG) _log(__CLASS__.'::'.__FUNCTION__);
		$data = array('data' => array('pass' => $newpassword));
		if ($userid) {
			$data['data']['userid'] = (int)$userid;
		}
		$result = ds('user_UpdateUser', $data);
		return $result;
	}

	/**
	 * Get User Mail
	 *
	 * @param $email
	 * @return array or boolean
	 */
	static final public function GetUserMail($email) {
		if (DEBUG) _log(__CLASS__.'::'.__FUNCTION__);
		if (!$email) {
			return false;
		}
		$response = ds('user_GetUserMail', array('email' => $email));
		return Core::GenericResponse($response);
	}


	/**
	 * Check banned on current user
	 *
	 * @return
	 */
	function isBanned() {
		if (DEBUG) _log(__CLASS__.'::'.__FUNCTION__);
		return self::$core->banned;
	}

	/**
	 * Create a new user
	 * @param array $data - the data to use
	 * @return array
	 */
	public static function CreateUser($data) {
		if (DEBUG) _log(__CLASS__.'::'.__FUNCTION__);

		if (isset($data['agree_terms']) && $data['agree_terms']) {

			$password = (string)$data['pass'];
			if (strlen($password) != 32) {
				$password = md5($password);
			}
			$data['password'] = $data['pass'];
			$data['pass'] = $password;
			
			if ($data['usertype'] == 'model') {
				$data['usertype'] = 1;
			} else if ($data['usertype'] == 'agent' || $data['usertype'] == 'brand' || $data['usertype'] == 'client') {
				$data['usertype'] = 2;
				
				// mother agencies register like a client, so only a client account can be a mother agency
				if ($data['ismotheragency'] == 1) {
					$data['usertype'] = 3;
				}
			} else {
				$data['usertype'] = 0;
			}
			

			$response = ds('user_CreateUser', array('data' => $data));
			if (isset($response['statusCode']) && $response['statusCode'] == 0) {
				self::$core->_user['id'] = $response['result']['userid'];
				$userSettings = array();
				$userSettings['haircolour'] = 0;
				$userSettings['hairtype'] = 0;
				$userSettings['hairlength']= 0;
				$userSettings['willingtodye'] = 0;
				$userSettings['willingtocut'] = 0;
				$userSettings['eyecolour'] = 0;
				$userSettings['location'] = $data['location'];
				
				User::UpdateUserProfile($userSettings);
			} else {
				unset($data['password']);
				CroissantError::RecordError('User register issue', array('data' => $data, 'response' => $response));
			}
			
		}

		return $response;
	}

	/**
	 * Remove user
	 *
	 * @param int $userid
	 * @param bool $soft
	 * @return
	 */
	public static function RemoveUser($userid, $soft = false) {
		if (DEBUG) _log(__CLASS__.'::'.__FUNCTION__);
		$response = ds('user_RemoveUser', array('userid' => $userid, 'soft' => $soft));
		return $response;
	}

	/**
	 * @param array $data
	 * @return array
	 */
	public static function UpdateUser(array $data) {
		if (DEBUG) _log(__CLASS__.'::'.__FUNCTION__);
		if (!isset($data['data'])) {
			$data['data'] = $data['userdata'];
		}
		$response = ds('user_UpdateUser', array(
			'data' => $data
		));
		// we really need to reload user data at this point too
		// if the logged-in user is the same as the just-saved user
		if (isset($data['userid']) && $data['userid'] == User::UserID()) {
			foreach($data as $k => $v) {
				self::$core->_user[$k] = $v;
			}
			self::StoreUserInSession($data);
		}

		if (isset($data['oldpassword']) && isset($data['newpassword2'])  && isset($data['newpassword'])) {
			if (!empty($data['newpassword'])) {
				if ($data['newpassword'] == $data['newpassword2']) {
					$response = ds('user_UpdateUserPassword', array('data' => $data));
				}
			}
		}

		return $response;
	}

	public static function ResetUserPassword(array $data) {
		if (DEBUG) _log(__CLASS__.'::'.__FUNCTION__);
		$response = ds('user_ResetUserPassword', array('data' => $data));
		return genericResponse($response);
	}
	
	
	public static function UpdateUserProfile(array $data) {
		if (DEBUG) _log(__CLASS__.'::'.__FUNCTION__);
		$response = ds('user_UpdateUserProfile', array('data' => $data));
		return $response;
	}
	
	public static function UpdateUserEmailPreferences(array $data) {
		if (DEBUG) _log(__CLASS__.'::'.__FUNCTION__);
		$response = ds('user_UpdateUserEmailPreferences', array(
				'data' => $data
		));
		
		// self::StoreUserProfileInSession($data);
		
		return $response;
	}

	/**
	 * Send request for reset password
	 *
	 * @param int $userid
	 * @param int $time
	 * @param string $key
	 * @return
	 */
	static function RequestPwdReset($userid, $time, $key) {
		if (DEBUG) _log(__CLASS__.'::'.__FUNCTION__);
		$response = ds('user_RequestPwdReset', array('userid' => $userid, 'time'=> $time, 'key'=>$key));
		return Core::GenericResponse($response);
	}

	/**
	 * Check reset key is expired.
	 *
	 * @param string $key
	 * @return bool
	 */
	static function CheckPwdResetExpire($key) {
		if (DEBUG) _log(__CLASS__.'::'.__FUNCTION__);
		$result = ds('user_CheckPwdResetExpire', array($key));
		if (isset($result['statusCode']) && $result['statusCode'] == 0) {
			$time = $result['result']['pwdreset_time'];
			$expire_time = $time+(60*60*24*5); // 5 days
			if (time() < $expire_time) {
				return $result['result']['id'];
			} else {
				return false;
			}
		} else {
			return false;
		}
	}

	/**
	 * Generate password reset
	 *
	 * @return array
	 */
	static function GenKeyForPwdReset() {
		if (DEBUG) _log(__CLASS__.'::'.__FUNCTION__);
		$key = md5(uniqid(mt_rand(), true));
		return array('key' => $key, 'ec_key' => base64_encode($key));
	}

	/**
	 * Generate key for password reset
	 *
	 * @param string $key
	 * @return array
	 */
	static function GetKeyForPwdReset($key) {
		if (DEBUG) _log(__CLASS__.'::'.__FUNCTION__);
		return array('ec_key' => $key, 'key' => base64_decode($key));
	}


	public static function LoadUsersByFacebookIDS($facebookids){
		if (DEBUG) _log(__CLASS__.'::'.__FUNCTION__);
		$response = ds('user_LoadUsersByFacebookIDS', array('facebookids' => $facebookids ));
		return Core::GenericResponse($response);
	}

	private static function StoreUserInSession($data) {
		
		require_once(BASEPATH.'/configuration/user.configuration.php');
		foreach(self::$core->_user_session as $k) {
			
			if (isset($data[$k])) {
				Session::SetVariable($k, $data[$k]);
			}
	}

	public static function UserType() {
		return self::$core->_user['usertype'];
	}
	
	public static function UserAvailable() {
		return self::$core->_user['available'];
	}
	
	public static function UserStatus() {
		if (self::$core->_user['status'] == 99) {
			return 1;
		}
		return self::$core->_user['status'];
	}

	static public function FirstName() {
		return self::$core->_user['firstname'];
	}

	static public function Surname() {
		return self::$core->_user['lastname'];
	}

	static public function Username() {
		return self::$core->_user['username'];
	}
	
	static public function CompanyName() {
		return self::$core->_user['company_name'];
	}
	
	static public function CompanyWebsite() {
		return self::$core->_user['company_website'];
	}
	
	
	static public function ReferrerCode() {
		return self::$core->_user['referrer_code'];
	}
	
	static public function VATNumber() {
		return self::$core->_user['vat_number'];
	}
	
	static public function MotherAgency() {
		return self::$core->_user['mother_agency'];
	}

	static public function Avatar($userid = 0) {
		if ($userid = 0) {
			$userid = User::UserID();
		}
		
		$avatar = self::$core->_user['avatar'];
		if (!empty($avatar)) {
			$avatar = '/avatar/thumb'.$avatar;
		} else {
			$avatar = '/images/user/avatars/default_profile.png';
		}
		
		return $avatar;
	}
	
	public static function CanVerify() {
		$canVerify = true;
		if (self::$core->_user['dob'] == 0) {
			$canVerify = false;
		}
		if (self::$core->_user['nationality'] == '') {
			$canVerify = false;
		}
		if (self::$core->_user['residence_country'] == '') {
			$canVerify = false;
		}
		return $canVerify;
	}
	
	public static function VerifyFails() {
		$verifyFails = [];
		if (self::$core->_user['dob'] == 0) {
			$verifyFails[] ='date of birth';
		}
		if (self::$core->_user['nationality'] == '') {
			$verifyFails[] = 'nationality';
		}
		if (self::$core->_user['residence_country'] == '') {
			$verifyFails[] = 'country of residence';
		}
		return $verifyFails;
	}
	
	public static function GetDeviceToken($uid) {
		$response = ds('user_GetDeviceToken', array('uid' => $uid));
		if (isset($response['statusCode']) && $response['statusCode'] == 0) {
			return $response['result'];
		} else {
			return false;
		}
	}
	
	public static function GetVATNumber($userid) {
		$response = ds('user_GetVATStatus', array('uid' => $userid));
		if (isset($response['statusCode']) && $response['statusCode'] == 0) {
			return $response['result'];
		} else {
			return false;
		}
	}
	
	/**
	 * CanPayByInvoice
	 *
	 * Returns the stored state for `allow_invoice`
	 *
	 * @return Int
	 */
	public static function CanPayByInvoice() {
		// allow_invoice is in `user_profile`, not `user`
		// `user_profile` is not stored in the singleton
		$u = User::LoadUser(User::UserID());
		return $u['profile']['allow_invoice'];
	}
	
	/**
	 * InvoiceTerms
	 * 
	 * Loads the payment terms for the currently logged-in user
	 * If there is no set payment terms, return the FINDA default instead
	 * 
	 * @return Int
	 */
	public static function InvoiceTerms() {
		// credit_terms is in `user_profile`, not `user`
		// `user_profile` is not stored in the singleton
		$u = User::LoadUser(User::UserID());
		return ($u['profile']['credit_terms']!=0)?$u['profile']['credit_terms']:FINDA_PAYMENT_DUE_DAYS;
	}
	
	public static function GetUserCompanyDetails() {
		if (self::$core->_user['companyid'] != 0) {
			if (!isset(self::$core->_user['companydetails'])) {
				$response = ds('user_LoadCompanyDetails', array('cid' => self::$core->_user['companyid']));
				if (isset($response['statusCode']) && $response['statusCode'] == 0) {
					self::$core->_user['companydetails'] = $response['result'];
				} else {
					unset(self::$core->_user['companydetails']);
				}
			}
		}
		return self::$core->_user['companydetails'];
	}
	
	public static function CompanyId() {
		if (DEBUG) _log(__CLASS__.'::'.__FUNCTION__);
		return self::$core->_user['companyid'];
	}

}