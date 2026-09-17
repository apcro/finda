<?php
/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
namespace Croissant;
/*
 * Finda API interface
 *
 */

// all allowed methods
$registeredMethods = array(
	// anonymous
	'login',
	'logout',
	'register',
	'checkEmail', 
	
	// private
	'userLoad',
	'updateProfile',
	'updateSettings',
	'updateAvatar',
	'updateModelAvatar',
	'getSearchParameters',

	'storeUserSession',
	'getUserSession',

	'toggleNotification',
	'getNotificationStatus',

	'sendFeedback',

	'updateDeviceToken',

	// model functions
	'getJobs',	// (type)
	'getClientJobs',
	'getJobDetails',
	'getClientJobDetails',
	'uploadPortfolio',
	'uploadPolaroid',
	'saveImageOrder',
	'uploadKYC',
	'uploadChatImage',
	'updateAvailability',
	'rejectOption',
	'acceptBooking',
	'rejectBooking',
	'negotiateBooking',
	'completeBooking',
	'cancelBooking',
	'rateClient',
	'getImages',	// by type
	'selectLeadImage',
	'removeImage',
	'getModelInvoices',
	'getClientInvoices',
	'inviteFriend',
	'getCalendar',
	'addCalendarEntry',
	'getCalendarEvents',
	'addCalendarEvent',
	'deleteCalendarEvent',
	'updateCalendarEvent',
	'getLastMinute',
	'setLastMinute',
	'getReferrals',

	
	// client functions
	'cancelModel',
	'confirmModel',
	'requestModel',
	'completeModel',
	'getModelImages',
	
	
	// shared functions
	'getNotifications',
	'deleteNotification',
	'flagNotification',
	'getChatMessages',
	'sendChatMessage',
	'getTerms',

	'support',

);

$requiredVersion = '1.0';
$privateKey = 'REDACTED_API_PRIVATE_KEY';
$publicKey =  'REDACTED_API_PUBLIC_KEY';
$salt = 'REDACTED_API_SALT';

// use new auth headers approach, taken from SAML
$headers = getallheaders();
$auth_elements = process_headers($headers);
$hash_source = $auth_elements['ts'] . $auth_elements['publicKey'] . $salt;
$hash = hash_hmac('sha256', $hash_source, $privateKey);

$version = array_shift($args);
$method = array_shift($args);

$anonymousMethods = array('login', 'logout', 'register', 'checkEmail');

if (empty($headers['Token']) && !in_array($method, $anonymousMethods)) {
	die('Missing token'); // no token
} else {
	$token = 'apitoken:'.$headers['Token'];
	if (!in_array($method, $anonymousMethods)) {
		if (!API::IsValidToken($token)) {
			header('HTTP/1.0 401 Unauthorized', 401);
			header('Content-Type: application/json');
			$response = array('status' => 0, 'errorMessage' => 'Authentication token is invalid');
			if (DEBUG) $response['inheaders'] = $headers;
			die(json_encode($response));
		}
	} else {
		if (!empty($headers['Token']) && $method == 'login') {
			API::userLogout($token);
		}
	}
}

if (isset($version) && isset($method) && ($hash == $auth_elements['hash'])) {
	if ($key != $apiKey) {
		$error['status'] = 1;
		$error['errorMessage'] = 'Invalid API key';
		header('HTTP/1.0 403 Forbidden', 403);
		die(json_encode($error));
	}
	if ($version == $requiredVersion) {
		if (in_array($method, $registeredMethods)) {
			$response = '';
			// make device ID available
			Finda::Token($token);

			// default country code
			Finda::$core->_countryCode = 'GB';

			// load user details right here
			if (API::IsValidToken(Finda::Token())) {
				$uid = Redis::Get($token);
				Finda::$core->_user = User::LoadUser($uid);
			}

			switch($method) {
				case 'login':
					if (!empty(Finda::Token())) {
						API::UserLogout(Finda::Token());
					}
					if (!empty($token)) {
						API::UserLogout($token);
					}
					if ($type == 'facebook') {
						$response = API::facebookLogin($username);
					} else if ($type == 'twitter') {
						$response = API::twitterLogin($username, $password);
					} else {
						$response = API::UserLogin($email, $password);
					}
					break;

				case 'twitterlogin':
					$response = API::twitterLogin($twitterid, $username, $authtoken, $authsecret);
					break;

				case 'logout':
					$response =  API::UserLogout($token);
					break;
					
				case 'getCalendar':
					$response = API::GetCalendar($token, $start, $end);
					break;
				case 'getCalendarEvents':
					$response = API::GetCalendarEvents($token, $date);
					break;
				case 'getLastMinute':
					$response = API::GetLastMinute($token);
					break;
				case 'setLastMinute':
					if ($type == 'android') {
						$availability = array();
						$availability['monday'] = $monday;
						$availability['tuesday'] = $tuesday;
						$availability['wednesday'] = $wednesday;
						$availability['thursday'] = $thursday;
						$availability['friday'] = $friday;
						$availability['saturday'] = $saturday;
						$availability['sunday'] = $sunday;
					}
					$response = API::SetLastMinute($token, $availability);
					break;
					
				case 'register':
					$response = array('status' => 0);
					// some sanity checking
					$error = false;
					$email = trim($email);
					$password = trim($password);
					$name = trim($name);
					if (empty($email)) {
						$error = true;
						$response['error'] = 'No email address entered';
					}
					if (empty($password)) {
						$error = true;
						$response['error'] = 'No password given';
					}
					if (!empty($email) && !preg_match("/^[_a-z0-9-]+(\.[_a-z0-9-]+)*(\+[a-z0-9-]+)?@[a-z0-9-]+(\.[a-z0-9-]+)*$/i", $email)) {
						$error = true;
						$response['error'] = 'The entered email address is invalid.';
					}
					if ( (User::CheckEmail($email)) && !empty($email)) {
						$error = true;
						$response['error'] = 'The entered email address has already been used.';
					}

					if (!$error) {
						$data['agree_terms'] = $agree_terms;
						$data['mail'] = $email;
						$data['pass'] = $password;
						$data['firstname'] = $firstname;
						$data['lastname'] = $lastname;
						$data['gender'] = isset($gender)?$gender:"other";
						$data['country'] = $country;
						
						$locationTid = Taxonomy::GetTermByLabelForSearch($userlocation, 18);
						if ($locationTid) {
							$data['location'] = $locationTid['tid'];
						} else {
							$data['location'] = 0;
						}
						$data['telephone'] = $telephone;
						$data['instagram_username'] = isset($instagram_username)?$instagram_username:"";
						$data['instagram_username'] = str_replace('@', '', $data['instagram_username']);
						$data['instagram_username'] = str_replace('https://instagram.com/', '', $data['instagram_username']);
						$data['instagram_username'] = str_replace('https://www.instagram.com/', '', $data['instagram_username']);
						$data['instagram_username'] = trim($data['instagram_username']);
						$data['referral_code'] = isset($referral_code)?$referral_code:"";
						$data['usertype'] = $usertype;
						$data['dob'] = isset($dob)?$dob:0;
						$data['entry_url'] = isset($entry_url)?$entry_url:'ios';
						
						if ($dob != 0) {
							$age = date("Y", time()) - date("Y", $data['dob']);
							
							$mthen = date("n", $data['dob']);
							$mnow = date("n", time());
							
							$dthen = date("j", $data['dob']);
							$dnow = date("j", time());
							
							if ($mnow < $mthen || ($mnow == $mthen && $dnow < $dthen)) {
								$age--;
							}
							$data['age'] = $age;
						} else {
							$data['age'] = 0;
						}

						$response =  API::UserRegister($data);
					}
					break;
				case 'checkEmail':
					$response['status'] = 1;
					if ((User::CheckEmail($email)) && !empty($email)) {
						$response['status'] = 0;
					}
					break;
				case 'userLoad':
					$response =  API::UserLoad($token);
					break;

				case 'updateProfile':
					$data = array();
					$data = $parameters;

					$response =  API::UserUpdate($token, $data);
					break;

				case 'toggleNotification':
					$response = API::ToggleNotification($type, $value);
					break;

				case 'getNotificationStatus':
					$response = API::GetNotificationStatus($type);
					break;

				case 'sessionStore':
					$response =  API::sessionStore($key, $data);
					break;
				case 'sessionGet':
					$response =  API::sessionStore($key);
					break;
				case 'updateAvatar':
					$response = API::UpdateAvatar($file);
					break;
				case 'updateModelAvatar':
					$response = API::UpdateModelAvatar($imageid, $data);
					break;
				case 'userSettings':
					$response = API::userSettings($token);
					break;

				case 'updateDeviceToken':
					$response = API::UpdateDeviceToken($token, $deviceToken, $deviceType);
					break;
					
				// also uses generic UserUpdate rather than a specific update function
				case 'updateSettings':
					$data = array();
					$data['currency_code'] = $currency;
					$data['locale'] = $locale;
					$response = API::UserUpdate($data);
					break;
					
				case 'getSearchParameters':
					$response['status'] = 1;
					$response['parameters'] = Core::LoadVariableByKey('searchsettings', '{"age":["18","60"],"height":["165","190"],"bustsize":["74","142"],"waistsize":["56","124"],"hipsize":["78","150"],"shoesize":["2","9"],"dresssize":["2","12"]}');
					break;

				// model-centric functions
				case 'getJobs':
					if ($platform == 'android') {
						$all = API::GetJobs('all');
						$response = array();
						$response['status'] = 1;
						$response['userdata'] = array();
						switch($type) {
							case 'all':
								$response['userdata'] = array_merge($all['userdata']['accepted'], $all['userdata']['offered'], $all['userdata']['history']);
								break;
							case 'accepted':
								$response['userdata'] = $all['userdata']['accepted'];
								break;
							case 'offered':
								$response['userdata'] = $all['userdata']['offered'];
								break;
							case 'history':
								$response['userdata'] = $all['userdata']['history'];
								break;
						}
						
					} else {
						$response = API::GetJobs($type);
					}
					break;
				case 'getClientJobs':
					if ($platform == 'android') {
						$all = API::GetClientJobs('all');
						$response = array();
						$response['status'] = 1;
						$response['userdata'] = array();
						switch($type) {
							case 'all':
								$response['userdata'] = array_merge($all['userdata']['upcoming'], $all['userdata']['past'], $all['userdata']['history']);
								break;
							case 'upcoming':
								$response['userdata'] = $all['userdata']['upcoming'];
								break;
							case 'past':
								$response['userdata'] = $all['userdata']['past'];
								break;
							case 'history':
								$response['userdata'] = $all['userdata']['history'];
								break;
						}
					} else {
						$response = API::GetClientJobs($type);
					}
					break;
				case 'getJobDetails':
					$response = API::GetJobDetails($token, $jobid);
					break;
				case 'getClientJobDetails':
					$response = API::ClientGetJobDetails($token, $jobid);
					break;
				case 'uploadPortfolio':
					$response = API::UploadImage($token, 'portfolio');
					break;
				case 'uploadPolaroid':
					$response = API::UploadImage($token, 'polaroids');
					break;
				case 'uploadChatImage':
					$response = API::UploadImage($token, 'chatAttachment');
					break;
				case 'saveImageOrder':
					$response = Finda::SaveImageOrder(implode(',', $order), $type);
					break;
				case 'uploadVerification':
					$_FILES['kyc'] = $_FILES['verification'];
				case 'uploadKYC':
					$response = API::UploadImage($token, 'kyc');
					break;
				case 'updateAvailability':
					$response = API::UpdateAvailability($token, $availability);
					break;
				case 'rejectOption':
					$response = API::RejectOption($jobid);
					break;
				case 'acceptBooking':
					$response = API::AcceptJob($jobid);
					break;
				case 'rejectBooking':
					$response = API::RejectJob($jobid);
					break;
				case 'negotiateBooking':
					$response = API::Negotiatejob($jobid, $rate, $reasons);
					break;
				case 'rateClient':
					break;
				case 'completeBooking':
					$response = API::CompleteJob($token, $jobid);
					break;
				case 'cancelBooking':
					$response = API::CancelJob($jobid);
					break;
				case 'getModelInvoices':
					$response = API::GetModelInvoices();
					break;
				case 'getClientInvoices':
					$response = API::GetClientInvoices();
					break;
				case 'inviteFriend':
					$response = API::InviteFriend($name, $email);
					break;
					
				case 'getImages':
					if (!isset($userid)) {
						$userid = 0;
					}
					switch($imagetype) {
						case 'portfolio':
						case 'polaroids':
							$response = API::GetUserImages($imagetype, $sefu);
							break;
						default:
							$response['status'] = 0;
					}
					break;
				case 'getModelImages':
					if (!isset($modelid)) {
						$modelid = 0;
						$imagetype = "";
					}
					switch($imagetype) {
						case 'portfolio':
						case 'polaroids':
							$response = API::GetModelImages($imagetype, $modelid);
							break;
						default:
							$response['status'] = 0;
					}
					break;
				case 'selectLeadImage':
					$response = API::MakeLeadImage($imageid);
					break;

				case 'removeImage':
					$response = API::RemoveImage($imageid);
					break;
					
					
				// client-centric functions
				
					
				// general functions
				case 'getNotifications':
					$response = API::GetNotifications($type, $count);
					break;
				case 'deleteNotification':
					$response = API::DeleteNotification($msgid);
					break;
				case 'flagNotification':
					$response = API::FlagNotification($msgid);
					break;
				case 'getChatMessages':
					$response = API::GetComposedNotifications($sender);
					break;
				case 'sendChatMessage':
					$response = API::SendComposedNotification($recipient, $message, $subject, $type);
					break;
					
				case 'getTerms':
					$response = API::GetTermData($vid);
					if ($type == 'android') {
						// post process it
						$newreturn = array();
						foreach($response['userdata'] as $k => $v) {
							$newreturn['userdata'][] = $v;
						}
						$newreturn['status'] = 1;
						$response = $newreturn;
					}
					break;
					
				case 'sendFeedback':
					$response = API::sendFeedback($token, $feedback);
					break;
					
				case 'support':
					// this is a direct function
					$uid = Redis::Get($token);
					$user = User::LoadUser($uid);
					Core::Assign('user', $user);
					Core::Assign('request', $request);
					switch ($reason) {
						case 1:
							$reasontext = 'My images for a job booked through iDAL are used outside its usage rights';
							break;
						case 2:
							$reasontext = 'I would like to take fresh polaroids in the London offices';
							break;
						case 3:
							$reasontext = 'I have a technical issue with the app';
							break;
						case 4:
							$reasontext = 'Payment for my iDAL job is overdue';
							break;
						case 5:
							$reasontext = 'Other';
							break;
					}
					Core::Assign('reason', $reasontext);
					$html = nl2br(Core::Fetch('emails/appsupportemail.tpl'));
					SendGrid::SendCustomEmail('support@idal.co', 'App Support Request', $html);
					$response = array('status' => 1);
					break;
					
				case 'addCalendarEvent':
					$uid = Redis::Get($token);
					$user = User::LoadUser($uid);
					
					$schedule = array();
					$schedule['scheduleId'] = Utilities::guid();
					$schedule['title'] = $title;
					$schedule['isAllDay'] = ($isAllDay == 1)?true:false;
					$schedule['isReadOnly'] = $isReadOnly;
					$schedule['starttime'] = $starttime;
					$schedule['endtime'] = $endtime;
					$schedule['category'] = $category;
					$schedule['dueDateClass'] = '';
					$schedule['location'] = $eventLocation;
					$schedule['state'] = $state;
					$schedule['notes'] = $notes;
					
					$response = Model::AddScheduleItem($schedule);
					break;
					
				case 'updateCalendarEvent':
					$uid = Redis::Get($token);
					$user = User::LoadUser($uid);
					
					$schedule = array();
					$schedule['scheduleId'] = $scheduleid;
					$schedule['title'] = $title;
					$schedule['isAllDay'] = ($isAllDay == 1)?true:false;
					$schedule['isReadOnly'] = $isReadOnly;
					$schedule['starttime'] = $starttime;
					$schedule['endtime'] = $endtime;
					$schedule['category'] = $category;
					$schedule['dueDateClass'] = '';
					$schedule['location'] = $eventLocation;
					$schedule['state'] = ucfirst(strtolower($state));
					
					$response = Model::UpdateScheduleItem($schedule);
					break;
					
				case 'deleteCalendarEvent':
					$uid = Redis::Get($token);
					$response = Model::RemoveScheduleItem($scheduleid, $uid);
					break;

				case 'cancelModel':
					$response = API::CancelModel($jobid, $modelid);
					break;
				case 'confirmModel':
					$response = API::ConfirmModel($jobid, $modelid);
					break;
				case 'requestModel':
					$response = API::RequestModel($jobid, $modelid);
					break;
				case 'completeModel':
					$response = API::CompleteModel($jobid, $modelid);
					break;
					
				case 'getReferrals':
					$response = API::GetReferrals($token);
					break;
					
				default:
					die('default method calls - there is probably a typo in the method name in api.php');
					break;
			}

			if (!empty($response)) {
				if (DEBUG) $point_timer[] = array('Finished "'.$method.'"', microtime(TRUE));

				if ($response === true) {
					$response = array('status' => 1);
				}

				if (!DEBUG) {
					unset($response['debug']);
				}

				$json = json_encode($response);
				header('Content-Type: application/json; charset=utf-8');
				header('HTTP/1.0 200 OK', 200);
				print $json;
				die();
			} else {
				$error['status'] = 0;
				$error['errorMessage'] = 'No data returned from method call';
				header('HTTP/1.0 204 No Content', 204);
				header('Content-Type: application/json; charset=utf-8');
				die(json_encode($error));
				die('2');
			}
		} else {
			$error['status'] = 0;
			$error['errorMessage'] = 'Invalid or unknown method';
			header('HTTP/1.0 400 Bad Request', 400);
			header('Content-Type: application/json; charset=utf-8');
			die(json_encode($error));
			die('3');
		}
	} else {
		$error['status'] = 0;
		$error['errorMessage'] = 'Unkown API version';
		header('HTTP/1.0 400 Bad Request', 400);
		die(json_encode($error));
		die('4');
	}
} else {
	$error['status'] = 0;
	$error['errorMessage'] = 'Invalid or missing parameters';

	header('HTTP/1.0 400 Bad Request', 400);
	die(json_encode($error));

}
die();

function process_headers($headers) {
	$auth_elements = array();
	if (isset($headers['Authorisation'])) {
		$parts = explode(' ', $headers['Authorisation']);

		if (count($parts) != 4 || $parts[0] != 'KeyAuth') {
			$response['error'] = 'Invalid Authorisation';
		}

		// Split the auth elements into an associative array.
		foreach ($parts as $part) {
			$segment_parts = explode('=', $part);
			if (count($segment_parts) == 2) {
				$auth_elements[$segment_parts[0]] = $segment_parts[1];
			}
		}
	}
	return $auth_elements;
}
