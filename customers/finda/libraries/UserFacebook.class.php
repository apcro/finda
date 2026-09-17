<?php
/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
namespace Croissant;

class UserFacebook {

	public static $facebookObj = null;

	public static $cnt = 0;

	public static $CURL_OPTS = array(
		CURLOPT_CONNECTTIMEOUT => 10,
		CURLOPT_RETURNTRANSFER => true,
		CURLOPT_TIMEOUT        => 60,
		CURLOPT_USERAGENT      => 'facebook-php-3.1',
	);

	public static function init() {
		if (self::$facebookObj == null) {
			self::$facebookObj = new \Facebook(array(
					'appId'     => FACEBOOK_APP_ID,
					'secret'    => FACEBOOK_APP_SECRET,
					'cookie'    => false
			));
		}
		return self::$facebookObj;
	}

	private static function UploadAvatarFromFacebookProfileImage($facebookID){
		$url = 'http://graph.facebook.com/'.$facebookID.'/picture?type=large';

		$rray = get_headers($url);
		foreach($rray as $v) {
			$header = explode(':', $v);
			if ($header[0] == 'Location') {
				$facebook_pic = trim($header[1]).':'.trim($header[2]);
			}
		}

		$destination = DOCROOT.'/images/user/avatars/source';
		if (!file_exists($destination)) {
			mkdir($destination, 0777, true);
		}
		$filename = strrev(uniqid()).'.jpg';
		$newdir = $destination.'/'.substr($filename,0,2)."/".substr($filename,2,2);
		mkdir($newdir, 0777, true);

		$uploadfile = $newdir . '/' . $filename;

		copy($facebook_pic, $uploadfile);
		$filename = str_replace(DOCROOT.'/images/user/avatars/source', '', $uploadfile);

		Image2::resize($uploadfile, DOCROOT.'/images/user/avatars/'.$filename, 300, 300, 'crop');

		return $filename ;
	}

	public static function ExchangeToken($facebookToken){
		$response_params = array();
		$ch = curl_init();
		curl_setopt($ch, CURLOPT_URL, 'https://graph.facebook.com/oauth/access_token?grant_type=fb_exchange_token&client_id=' . FACEBOOK_APP_ID . '&client_secret='.FACEBOOK_APP_SECRET . '&fb_exchange_token=' . $facebookToken);
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
		curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, 0);
		curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
		$output = curl_exec($ch);
		$response_params = json_decode($output);
		return isset($response_params->access_token)? $response_params->access_token : null;

	}

	public static function CheckAuthen($auth_token) {
		$response = array('status' => 0);
		if (User::UserID() != 0) {
			User::Logout();
		}
		if (User::UserID() == 0) {

			// replace this with a call to MakeRequest('/me')
			// $facebook = self::init();
			// $response['facebook'] = (array)$facebook;
			// $facebook->setAccesstoken($auth_token);
			// $user_facebook = $facebook->getUser();

			$facebookdata = self::MakeRequest('/me', $auth_token);
			$user_facebook = $facebookdata->id;
			// end replace

			if ($user_facebook != 0) {

				$user_profile = self::MakeRequest('/me?fields=name,first_name,last_name,email,gender,picture,birthday,location', $auth_token);
				$user_profile->gender = substr($user_profile->gender, 0, 1);
				list($day,$month,$year) = explode( '/' , $user_profile->birthday);
				$user_profile->birthday = $year;


				$res = null;
				// Proceed knowing you have a logged in user who's authenticated.
				if (User::CheckFacebookID($user_profile->id)) {
					$login_data = array('facebook_id' => $user_profile->id);
					$res = User::FBLogin($login_data);
					if (trim( $res['firstname'] ) != '' ) {
						$data = array() ;
						$data['firstname'] = $user_profile->first_name;
						$data['lastname'] = $user_profile->last_name;
						$data['facebook_token'] = $auth_token;
						$data['userdata'] = array('gender' => $user_profile->gender, 'dob' => strtotime($user_profile->birthday));
						User::UpdateUser($data);
					}
				} elseif (User::CheckEmail($user_profile->email)) {
					echo 'matched email';
					$login_data = array('mail' => $user_profile->email);
					$res = User::FBLogin($login_data);
					// Update the facebook id. In case facebook_id is empty.
					$data = array();
					$data['facebook_id'] = $user_profile->id;
					$data['name'] = $user_profile->name;
					$data['firstname'] = $user_profile->first_name;
					$data['lastname'] = $user_profile->last_name;
					$avatar = self::UploadAvatarFromFacebookProfileImage($user_profile->id);
					$data['avatar'] = $avatar;
					$data['avatar_status'] = 1;
					$data['userdata'] = array('gender' => $user_profile->gender, 'dob' => strtotime($user_profile->birthday));
					$data['userdata'] = serialize($data['userdata']);
					$data['facebook_token'] = $auth_token;
					User::UpdateUser($data);
				} else {
					// create new user from facebook user details
					$data['agree_terms'] = 1;
					$data['name'] = $user_profile->name;
					$data['firstname'] = $user_profile->first_name;
					$data['lastname'] = $user_profile->last_name;
					$data['surname'] = $user_profile->last_name;
					$data['mail'] = $user_profile->email;
					$data['facebook_id']= $user_profile->id;
					$data['facebook_token'] = $auth_token;

					$userCreate = User::CreateUser($data);

					$login_data = array('facebook_id' => $user_profile->id);
					$res = User::FBLogin($login_data);

					$avatar = self::UploadAvatarFromFacebookProfileImage($user_profile->id);

					$data = array();
					$data['userid'] = $userCreate['result']['userid'];
					$data['avatar'] = $avatar;
					$data['avatar_status'] = 1;
					$data['facebook_token'] =  $auth_token;
					$data['userdata'] = array('gender' => $user_profile->gender, 'dob' => strtotime($user_profile->birthday));
					$data['userdata'] = serialize($data['userdata']);

					User::UpdateUser($data);

				}
				$response['status'] = 1;
				$response['data'] = $res;

			} else {
				// Double check .
				$response['error'] = 'Invalid faceboook token. (userauthen)';
				$response['user_facebook'] = $user_facebook;
			}
		}
		return $response ;
	}

	public static function getFriends() {
		$facebook = self::init();
		$user_facebook = $facebook->getUser();
		$response = array('status' => 0);
		if ($user_facebook != 0) {
			$friends = $facebook->api('/me/friends?limit=500');
			$facebook_ids = array() ;
			foreach($friends['data'] as $friend){
				$facebook_ids[] =  $friend['id'] ;
			}
			$response['data'] = User::LoadUsersByFacebookIDS($facebook_ids) ;
		}else{
			$response['error'] =  'Invalid faceboook token.' ;
		}
		return $response ;
	}

	public static function Logout() {
		$facebook = self::init();
		$user = $facebook->getUser();
		if ($user) {
			$here = 'http://' . $_SERVER['HTTP_HOST'] . $_SERVER['REQUEST_URI'];
			$next = preg_replace('~#.*$~s', '', $here);
			$next = preg_replace('~\?.*$~s', '', $next);
			$next = preg_replace('~/[^/]*$~s', '/logout.php', $next);
			$logoutUrl = $facebook->getLogoutUrl(array('next' => $next));

			header('Location: '.$logoutUrl);
			die();
		}
	}

	function makeRequest($path, $auth_token) {

		$ch = curl_init();

		$params['method'] = 'GET';
	    $params['api_key'] = FACEBOOK_APP_ID;
	    $params['format'] = 'json-strings';
		$params['access_token'] = $auth_token;

		$url = 'https://graph.facebook.com'.$path;

		$opts = self::$CURL_OPTS;
		$opts[CURLOPT_POSTFIELDS] = http_build_query($params, null, '&');
		$opts[CURLOPT_URL] = $url;

		// disable the 'Expect: 100-continue' behaviour. This causes CURL to wait
		// for 2 seconds if the server does not support this header.
		if (isset($opts[CURLOPT_HTTPHEADER])) {
			$existing_headers = $opts[CURLOPT_HTTPHEADER];
			$existing_headers[] = 'Expect:';
			$opts[CURLOPT_HTTPHEADER] = $existing_headers;
		} else {
			$opts[CURLOPT_HTTPHEADER] = array('Expect:');
		}

		curl_setopt_array($ch, $opts);
		$result = curl_exec($ch);

		if (curl_errno($ch) == 60) { // CURLE_SSL_CACERT
			// self::errorLog('Invalid or no certificate authority found, using bundled information');
			curl_setopt($ch, CURLOPT_CAINFO, dirname(__FILE__) . '/fb_ca_chain_bundle.crt');
			$result = curl_exec($ch);
		}

		if ($result === false) {
			$info = curl_getinfo($ch);
		}
		curl_close($ch);
		return json_decode($result);
	}
}