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
 *
 */
class Finda extends Core {

	static $core;

	/**
	 *
	 */
	public static function Initialise() {
		if (!isset(self::$core)) {
			self::$core = parent::Initialise();
		}

		return self::$core;
	}

	public static function Token($token = null) {
		if (is_null($token)) {
			return self::$core->_token;
		} else {
			self::$core->_token = $token;
		}
	}

	

	final static public function UploadAvatar($userid = 0) {
		if (DEBUG) _log(__CLASS__.'::'.__FUNCTION__);
		$destination = DOCROOT.'/images/user/avatars/source';
		$destt = $destination;
		$uploadfile = File2::Upload(DOCROOT.'/images/user/avatars/source');

		if (!$uploadfile) {
			return array('errorMessage' => 'uploadfile failed', 'uploadfile' => $uploadfile, 'destination' => $destination);
		}
		$filename = str_replace(DOCROOT.'/images/user/avatars/source', '', $uploadfile);

		if (!Image2::resize($uploadfile, DOCROOT.'/images/user/avatars/'.$filename, 300, 300, 'crop')) {
			return array('errorMessage' => 'no resize 300');
		}

		$data = array() ;
		$data['avatar'] = $filename ;
		if ($userid != 0) {
			$data['userid'] = $userid ;
			$data['avatar_status'] = 1;
			$response = User::UpdateUser($data);
			if (isset($response['statusCode']) && $response['statusCode'] == 0) {
				$reply = array();
				$reply['response'] = $response;
				$reply['filename'] = $filename;
				return $reply;
			} else {
				return array('errorMessage' => 'UPDATEUSER FAILED', 'response' => $response);
			}
		}
	}

	public static function TwitterLoginOrRegister($twitterid, $username) {
		if (DEBUG) _log(__CLASS__.'::'.__FUNCTION__);
		$response = ds('user_TwitterLoginOrRegister', array('twitter_id' => $twitterid, 'username' => $username));
		if (isset($response['statusCode']) && $response['statusCode'] == 0) {
			return $response['result']['id'];
		} else {
			return false;
		}

	}

	public static function SetTwitterProfile($twitterid, $uid) {

		// @TODO move these to the local config file
		$authtoken = TWITTER_AUTH_TOKEN;
		$authsecret = TWITTER_AUTH_SECRET;

		$authtoken = urlencode($authtoken);
		$authsecret = urlencode($authsecret);
		$key = $authtoken.':'.$authsecret;
		$encodedKey = base64_encode($key);

		$url = 'https://api.twitter.com/oauth2/token';
		$postdata = 'grant_type=client_credentials';

		$ch = curl_init();
		// Set query data here with the URL
		curl_setopt($ch, CURLOPT_URL, $url);
		curl_setopt($ch, CURLOPT_POST, 1);                                                                     
		curl_setopt($ch, CURLOPT_POSTFIELDS, $postdata);
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
		curl_setopt($ch, CURLOPT_TIMEOUT, '30');
		curl_setopt($ch, CURLOPT_HTTPHEADER, array(
			'Content-Type: application/x-www-form-urlencoded;charset=UTF-8',
			'Authorization: Basic '.$encodedKey,
			'Content-Length: 29'
		));
		$data = trim(curl_exec($ch));
		$info = curl_getinfo($ch);

		if ($info['http_code'] != 200) {
			return false;
		} else {

			$result = json_decode($data);
			$bearer = $result->access_token;

			$url = 'https://api.twitter.com/1.1/users/show.json?user_id='.$twitterid;

			// $url = 'https://api.twitter.com/1.1/account/verify_credentials.json';

			$ch = curl_init();
			curl_setopt($ch, CURLOPT_URL, $url);
			curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
			curl_setopt($ch, CURLOPT_TIMEOUT, '30');
			curl_setopt($ch, CURLOPT_HTTPHEADER, array(
				'Accept: application/json',
				'Authorization: Bearer '.$bearer
			));
			$data = trim(curl_exec($ch));


			$info = curl_getinfo($ch);
			if ($info['http_code'] != 200) {
				return false;
			} else {
				$data = json_decode($data);
				

				$name = $data->name;
				$avatarUri = str_replace('_normal', '_bigger', $data->profile_image_url_https);
				$data = array();
				$data['name'] = $name;
				$data['avatar'] = self::FetchAvatar($avatarUri);
				$data['avatar_status'] = 1;
				$data['userid'] = $uid;
				$response = User::UpdateUser($data);
				return $response;

			}

		}
	}

	private static function FetchAvatar($imageUri) {
		// fetch it
		$sourcename = basename($imageUri);
		$destination = DOCROOT.'/images/user/avatars';

		$fileext = pathinfo($sourcename, PATHINFO_EXTENSION);
		$filename = strrev(uniqid()).'.'.$fileext;
		$newdir = $destination.'/'.substr($filename,0,2).'/'.substr($filename,2,2);
		mkdir($newdir, 0777, true);
		$newname = $newdir . '/' . $filename;

	    $file = fopen($imageUri, 'rb');
	    if ($file) {
	        $newf = fopen ($newname, 'wb');
	        if ($newf) {
	            while(!feof($file)) {
	                fwrite($newf, fread($file, 1024 * 8), 1024 * 8);
	            }
	        } else {
	        	die('failed to open new local file '.$newname);
	        }
	    } else {
	    	die('failed to open remote file '.$imageUri);
	    }
	    if ($file) {
	        fclose($file);
	    }
	    if ($newf) {
	        fclose($newf);
	    }

		return str_replace($destination, '', $newname);

	}

	final static public function UploadImage($imagetype = 'polaroid', $foruid = 0) {
		if (DEBUG) _log(__CLASS__.'::'.__FUNCTION__);
		$basepath = DOCROOT.'/'.$imagetype;
		$destination = $basepath.'/source';
		$thumbpath = $basepath.'/thumb';
		$uploadfile = File2::Upload($destination);

		if (!$uploadfile) {
			$errorData = array('errorMessage' => 'uploadfile failed', 'uploadfile' => $uploadfile, 'destination' => $destination);
		}
		$filename = str_replace($destination, '', $uploadfile['newname']);

		if ($imagetype != 'kyc') {
			if (!Image2::resize($uploadfile['newname'], $thumbpath.$filename, 300, 300, 'crop')) {
				$errorData =  array('errorMessage' => 'no resize 300');
			}
		}

		$data = array() ;
		$data['filename'] = $filename;
		if ($foruid == 0) {
			$data['userid'] = User::UserID();
		} else {
			if (User::UserType() == 3) {
				$data['userid'] = $foruid;
			} else {
				return false;
			}
		}
		$data['imagetype'] = $imagetype;
		$data['originalname'] = $uploadfile['originalname'];
		if ($imagetype == 'avatar') {
			$data = array();
			$data['avatar'] = $filename;
			$response = User::UpdateUser($data);
		} else {
// 			if ($imagetype != 'chatAttachment') {
				$data['vipsresponse'] = self::AddUserImage($data);
// 			}
			$response = $data;
			$response['statusCode'] = 0;
		}
		if (isset($response['statusCode']) && $response['statusCode'] == 0) {
			$reply = array();
			$reply['result'] = $response['result'];
			$reply['response'] = $response;
			$reply['imageid'] = $reply['insertid'];
			$reply['filename'] = $filename;
			$reply['errorData'] = $errorData;
			$reply['uploadfile'] = $uploadfile;
			
			// if VIPS is not installed, or fails, but we still insert the original, return that ID
			if ($reply['response']['vipsresponse']['statusCode'] == 1 && !empty($reply['response']['vipsresponse']['insertid'])) {
				$reply['imageid'] = $reply['response']['vipsresponse']['insertid'];
			}
			
			return $reply;
		} else {
			return array('errorMessage' => 'UPLOADIMAGE FAILED', 'response' => $response, 'errorData' => $errorData);
		}
	}

	final public static function AddUserImage($data) {
		// create the large file using VIPS only if the upload succeeded
		$result = self::vipsProcessImage($data['imagetype'], $data['filename']);
		$response = ds('finda_AddUserimage', array('data' => $data));
		if ($result['status'] == false) {
			$response['statusCode'] = 1;
			$response['vipsError'] = 'There was a problem creating the LARGE file';
			$response['vips'] = $result;
			CroissantError::RecordError('VIPS Errors', array('response' => $response, 'data' => $data));
		}
		return $response;
	}

	final static function GetUserImages($imagetype, $modelid = 0) {
		$response = ds('finda_GetUserImages', array('imagetype' => $imagetype, 'modelid' => $modelid));
		return genericResponse($response);
	}

	final public static function RemoveUserImage($id, $userid = 0) {
		$response = ds('finda_RemoveUserImage', array('id' => $id, 'userid' => $userid));
		return genericResponse($response);
	}
	
	final public static function MakeImageLeader($id, $userid = 0) {
		$response = ds('finda_MakeImageLeader', array('id' => $id, 'userid' => $userid));
		return genericResponse($response);
	}

	final public static function GetLeadImage($imagetype) {
		$response = ds('finda_GetUserImages', array('imagetype' => $imagetype));
		if (isset($response['statusCode']) && $response['statusCode'] == 0) {
			return $response['result'][0];
		} else {
			return false;
		}
	}
	
	final public static function GetInstagramImages() {
		// check Redis first
		$data = Redis::Get('instaimages');

		if (substr($data, 0, 1) == 'a') {
			unset($data);
		}

		if (substr($data, 0, 1) == '0') {
			unset($data);
		}
		
		if (empty($data)) {
			$insta_source = file_get_contents('https://instagram.com/finda.co');
			$shards = explode('window._sharedData = ', $insta_source);
			$insta_json = explode(';</script>', $shards[1]);
			$insta_array = json_decode($insta_json[0], TRUE);
			
			$latest_array = $insta_array['entry_data']['ProfilePage'][0]['graphql']['user']['edge_owner_to_timeline_media']['edges'];
			$images = array();
			foreach($latest_array as $k => $values) {
				$images[] = $values['node']['thumbnail_resources'][2]['src'];
			}
			$data = array_slice($images, 0, 8);
			if (!empty($data)) {
				Redis::Set('instaimages', $data, (60*60*30), true);
			}
		}
		return $data;
	}
	
	final public static function GetInviteDetails($hash) {
		$response = ds('finda_GetInviteDetails', array('hash' => $hash));
		return genericResponse($response);
	}
	
	final public static function UpdateInvite($rsvp, $hash) {
		$response = ds('finda_UpdateInvite', array('rsvp' => $rsvp, 'hash' => $hash));
		return genericResponse($response);
	}
	
	public static function GetUserByName($name) {
		$response = ds('user_LoadUserByName', array('name'=> $name));
		return genericResponse($response);
	}
	
	public static function GetUserBySefu($sefu, $usertype = TYPE_MODEL) {
		$response = ds('user_LoadUserBySefu', array('sefu'=> $sefu, 'usertype' => $usertype));
		return genericResponse($response);
	}
	
	public static function LoadUserByInstagramHandle($handle, $usertype = TYPE_MODEL) {
		$response = ds('user_LoadUserByInstagramHandle', array('handle'=> $handle, 'usertype' => $usertype));
		return genericResponse($response);
	}
	
	public static function GetImageDetails($imageid) {
		$response = ds('finda_GetImageDetails', array('imageid'=> $imageid));
		return genericResponse($response);
	}
	
	public static function RotateImage($imageid, $angle, $type) {
		if ($angle == 0) {
			return true;
		}
		
		$response = ds('user_GetModelImage', array('imageid' => $imageid));
		if (isset($response['statusCode']) && $response['statusCode'] == 0) {
			$imageData = $response['result'];

			// source first
			$filename = DOCROOT.'/'.$type.'/source'.$imageData['filename'];
			$result = self::doRotate($filename, $angle);
			
			if ($result) {
				// then thumb
				$filename = DOCROOT.'/'.$type.'/thumb'.$imageData['filename'];
				$result = self::doRotate($filename, $angle);
				if ($result) {
					return true;
				}
			}
		}
		return false;
	}
	
	private static function doRotate($filename, $angle) {
		$ext = pathinfo($filename, PATHINFO_EXTENSION);

		switch (strtolower($ext)) {
			case 'jpeg':
			case 'jpg':
				$source = imagecreatefromjpeg($filename);
				break;
			case 'png':
				$source = imagecreatefrompng($filename);
				break;
		}
		
		$rotate = imagerotate($source, $angle, 0);
		
		$result = imagejpeg($rotate, $filename, 100);
		
		imagedestroy($source);
		imagedestroy($rotate);
		return $result;
	}
	
	public static function GetMinimumJobRates() {
		$jobtypes = Taxonomy::GetTermsByVocabulary(1);
		foreach($jobtypes as $k => $jobtype) {
			$response = ds('finda_GetMinRatesForTID', array('tid' => $jobtype['tid']));
			if ($response['statusCode'] == 0) {
				$jobtypes[$k]['hourly'] = $response['result']['hourly'];
				$jobtypes[$k]['daily'] = $response['result']['daily'];
			}
		}
		return $jobtypes;
	}
	
	/* Affiliate functions */
	
	/*
	 * Set a cookie if there's an affiliate code in the URL, but don't overwrite an existing one
	 * This function is only called if there's a code
	 */
	public static function SetAffiliate(String $code):void {
		if (Cookie::GetCookie('finda_affiliate', 'string') == '') {
			Cookie::SetCookie('finda_affiliate', $code, time() + (10 * 365 * 24 * 60 * 60), true);
		}
		$aff = self::LoadUserByReferrerCode($code);
		if ($aff) {
			Core::Assign('trk', $code);
			Core::Assign('affuser', $aff['firstname']);
		}
	}
	
	/**
	 * 
	 * @return string
	 */
	public static function GetAffiliateCode():string {
		$code = Cookie::GetCookie('finda_affiliate');
		if ($code != 0) {
			Core::Assign('trk', $code);
			return $code;
		} else {
			Core::Assign('trk', '');
			return '';
		}
	}
	
	public static function GetAffiliates():array {
		$response = ds('finda_GetAffiliates');
		if (isset($response['statusCode']) && $response['statusCode'] == 0) {
			return $response['result'];
		}
		return array();
	}
	
	public static function LoadUserByReferrerCode($code) {
		$response = ds('finda_LoadUserByReferrerCode', array('code' => $code));
		if (isset($response['statusCode']) && $response['statusCode'] == 0) {
			return $response['result'];
		} else {
			return false;
		}
	}
	
	public static function SaveImageOrder($order, $type, $userid = 0) {
		$response = ds('finda_SaveImageOrder', array('order' => $order, 'type' => $type, 'userid' => $userid));
		if (isset($response['statusCode']) && $response['statusCode'] == 0) {
			return $response['result'];
		} else {
			return false;
		}
	}
	
	public static function GetImageOrder($type) {
		$response = ds('finda_LoadUserByReferrerCode', array('type' => $type));
		if (isset($response['statusCode']) && $response['statusCode'] == 0) {
			return $response['result'];
		} else {
			return false;
		}
	}
	
	public static function GetVerifiedModelCount() {
// 		Redis::Delete('modelcount');
		$count = Cache::Retrieve('modelcount', 'redis');
		if (empty($count)) {
			$response = ds('finda_LoadVerifiedModelCount');
			if (isset($response['statusCode']) && $response['statusCode'] == 0) {
				$modelcount = ceil($response['result']/10)*10;
				Cache::Store('modelcount', $modelcount, 'redis');
				return $response['result'];
			} else {
				Cache::Store('modelcount', 0, 'redis');
				return 0;
			}
		} else {
			return $count;
		}
	}
	
	public static function vipsProcessImage($type, $filename, $redo = false) {
		// they are stored in this form
		// 	$filename = '/a5/4e/a54ebd3d778c5.jpg';
		
		// our deploy system uses odd paths for revisions, this needs to point to the shared folder
		$DOCROOT = '/var/www/finda/shared/customers/finda/docroot';

		$response = array();
		$response['type'] = $type;
		$response['filename'] = $filename;
		
		$infilepath = $DOCROOT.'/'.$type.'/source';
		$infile = $infilepath.$filename;
		$response['infile'] = $infile;
		$response['infilepath'] = $infilepath;
		
		if (file_exists($infile)) {
// 			echo 'Processing '.$type.$filename;
			$outfilepath = $DOCROOT.'/'.$type.'/large';
			$outfile = $outfilepath.$filename;
			
			$response['outfile'] = $outfile;
			$response['outfilepath'] = $outfilepath;
			
			
			if (!file_exists($outfile) || $redo) {
				
				// generate the folder if needed
				$destpath = pathinfo($outfile, PATHINFO_DIRNAME);
				@mkdir($destpath, 0777, true);
				
				$image = \Vips\Image::thumbnail($infile, 1280);
				$image->writeToFile($outfile);
// 				echo ' ... Done.'."\n";
				$response['status'] = true;
			} else {
				$response['status'] = true;
			}
			// 	} else {
			// 		echo 'File not found: '.$infile."\n";
		} else {
			$response['status'] = false;
			$response['error'] = 'infile file not found';
		}
		return $response;
	}
	
	public static function AddToWaitList($data) {
		$response = ds('finda_AddToWaitList', array('data' => $data));
		if (isset($response['statusCode']) && $response['statusCode'] == 0) {
			return $response['result'];
		} else {
			return false;
		}
	}
	
	public static function LoadAllModelNames() {
		$response = dsro('modelsearch_LoadAllModelNames', array('type' => $type));
		if (isset($response['statusCode']) && $response['statusCode'] == 0) {
			return $response['result'];
		} else {
			return false;
		}
	}
}
