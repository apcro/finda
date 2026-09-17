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
class Model extends Core {

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

	/*
	 * send a notification to the model, if they have notifications turned on, of a new job
	 */
	public static function NotifyNewJob($modelid, $jobid, $offeredrate) {
		$response = Notification::SendJobOffer($jobid, $modelid, $offeredrate);
		return genericResponse($response);
	}
	
	/*
	 * send a notification to the model, if they have notifications turned on, of a job being cancelled
	 */
	public static function NotifyJobCancelled($jobid, $modelid) {
		return false;
	}

	
	public static function AddExperience($data) {
		$response = ds('finda_AddExperience', array('data' => $data));
		return genericResponse($response);
	}
	
	public static function UpdateExperience($data) {
		$response = ds('finda_UpdateExperience', array('data' => $data));
		return genericResponse($response);
	}
	
	public static function GetExperience($modelid) {
		$response = ds('finda_GetExperience', array('modelid' => $modelid));
		return genericResponse($response);
	}
	
	public static function GetExperienceDetails($id) {
		$response = ds('finda_GetExperienceDetails', array('id' => $id));
		return genericResponse($response);
	}
	
	// soft delete
	public static function RemoveExperience($id) {
		$response = ds('finda_RemoveExperience', array('id' => $id));
		return genericResponse($response);
	}
	
	// accepts a name-like string firstname-lastname and gets the ID from the database
	public static function GetModelByName($name) {
		$response = ds('modelsearch_GetModelByName', array('name'=> $name));
		return genericResponse($response);
	}
	
	public static function GetJobAssignmentStatus($jobid, $modelid = 0) {
		if ($modelid == 0) {
			$modelid = User::UserID();
			if ($modelid == 0) {
				return false;
			}
		}
		$response = ds('jobs_GetJobAssignmentStatus', array('jobid' => $jobid, 'modelid'=> $modelid));
		return genericResponse($response);
	}
	
	public static function RemoveUnacceptedModelsFromJob($jobid) {
		// get all models for job
		// for each model not confirmed, send cancellation
		// and cancel
		$job = Jobs::GetJobDetails($jobid);
		$models = $job['models'];
		
		// we want to remove all models with status: 1, 10, 14
		// 2 is confirmed, at this point the job is being closed/confirmed
		foreach($models as $model) {
			// this function will determine whether or not to send any emails
			if ($model['job_status'] != 2) {
				Jobs::RemoveModelFromJob($model['id'], $jobid);
			}
		}
		
	}
	
	public static function HasLeadImage($type = 'portfolio') {
		$response = ds('model_HasLeadImage', array('type' => $type));
		return genericResponse($response);
	}
	
	public static function GetModelsWorkedWith() {
		$response = ds('model_GetModelsWorkedWith');
		return genericResponse($response);
	}
	
	public static function GetModelSchedule($uid = 0, $start = 0, $end = 0) {
		if ($uid == 0) {
			$uid = User::UserID();
		}
		$response = ds('model_GetModelSchedule', array('uid' => $uid, 'start' => $start, 'end' => $end));
		return genericResponse($response);
	}
	
	// updates all calendar entries based on accepted jobs
	public static function RefreshSchedule() {
		$jobs = Jobs::ModelGetJobs('accepted');
		self::ModelClearSchedule(User::UserID());
		foreach($jobs as $k => $v) {
			self::RemoveJobFromModelCalendar($v['id'], User::UserID());
			self::AddJobToCalendar($v['jobid']);
		}
	}
	
	public static function AddJobToCalendar($jobid, $type = 'busy') {
		$job = Jobs::GetJobDetails($jobid);
		$schedule = array();
		$schedule['scheduleId'] = Utilities::guid();
		$schedule['title'] = $job['name'];
		$schedule['jobid'] = $jobid;
		$date = date('Y-m-d', $job['startdate']);
		$time = date('H:s', $job['starttime']);
		$start = strtotime($date.' '.$time);
		if ($job['units_type'] == 'day') {
			$end = $start + (60*60*24*$job['time_units']);
			$schedule['category'] = 'allday';
			$schedule['isAllDay'] = 'true';	// the JS library sends true as a string...
		} else {
			$end = $start + (60*60*$job['time_units']);
			$schedule['category'] = 'time';
			$schedule['isAllDay'] = 'false';
		}
		$schedule['isReadOnly'] = 1;
		$schedule['starttime'] = $start;
		$schedule['endtime'] = $end;

		$schedule['location'] = $job['location'];
		$schedule['state'] = ucfirst($type);
		$schedule['callsheet'] = $job['callsheet'];
		self::AddScheduleItem($modelid, $schedule);
	}
	
	public static function AddJobToModelCalendar($jobid, $modelid, $type = 'busy') {
		// remove any existing job first so we can update the type
		self::RemoveJobFromModelCalendar($jobid, $modelid);
		
		$job = Jobs::GetJobDetails($jobid);
		$schedule = array();
		$schedule['scheduleId'] = Utilities::guid();
		$schedule['title'] = $job['name'];
		$schedule['jobid'] = $jobid;
		$date = date('Y-m-d', $job['startdate']);
		$time = date('H:s', $job['starttime']);
		$start = strtotime($date.' '.$time);
		if ($job['units_type'] == 'day') {
			list($y, $m, $d) = explode('-', $date);
			$start = mktime(0, 0, 0, $m, $d, $y);
			$end = $start + (60*60*24*$job['time_units']);
			$schedule['category'] = 'allday';
			$schedule['isAllDay'] = 'true';	// the JS library sends true as a string...
		} else {
			$end = $start + (60*60*$job['time_units']);
			$schedule['category'] = 'time';
			$schedule['isAllDay'] = 'false';
		}
		$schedule['isReadOnly'] = 1;
		$schedule['starttime'] = $start;
		$schedule['endtime'] = $end;
		
		$schedule['location'] = $job['location'];
		$schedule['state'] = ucfirst($type);
		$schedule['callsheet'] = $job['callsheet'];
		self::AddModelScheduleItem($modelid, $schedule);
	}
	
	public static function RemoveJobFromCalendar($jobid) {
		$response = ds('model_RemoveScheduleItemByJobId', array('jobid' => $jobid));
		return genericResponse($response);
	}
	
	public static function RemoveJobFromModelCalendar($jobid, $modelid) {
		$response = ds('model_RemoveModelScheduleItemByJobId', array('jobid' => $jobid, 'modelid' => $modelid));
		return genericResponse($response);
	}
	
	public static function ModelClearSchedule($modelid) {
		$response = ds('model_ModelClearSchedule', array('modelid' => $modelid));
		return genericResponse($response);
	}
	
	
	
	
	
	public static function AddScheduleItem($schedule) {
		$response = ds('model_AddScheduleItem', array('data' => $schedule));
		return genericResponse($response);
	}
	
	public static function AddModelScheduleItem($modelid, $schedule) {
		$response = ds('model_AddModelScheduleItem', array('data' => $schedule, 'modelid' => $modelid));
		return genericResponse($response);
	}
	
	public static function RemoveScheduleItem($scheduleid, $userid = 0) {
		$response = ds('model_RemoveScheduleItem', array('scheduleid' => $scheduleid, 'userid' => $userid));
		return genericResponse($response);
	}
	
	public static function UpdateScheduleItem($schedule) {
		$response = ds('model_UpdateScheduleItem', array('schedule' => $schedule));
		return genericResponse($response);
	}
	
	// creates a new Avatar image for the user, based on parameters set server-side
	public static function CreateAvatarFromSource($imageid, $data) {
		$imagedetails = Finda::GetImageDetails($imageid);
		$sourcefilename = DOCROOT.'/'.$imagedetails['imagetype'].'/source'.$imagedetails['filename'];
		
		// determine the filetype of the source image
		$ext = strtolower(pathinfo($sourcefilename, PATHINFO_EXTENSION));
		if ($ext == 'png') {
			$sourceimage = imagecreatefrompng($sourcefilename);
		} else if ($ext == 'jpg' || $ext == 'jpeg') {
			$sourceimage = imagecreatefromjpeg($sourcefilename);
		}
		
		if ($sourceimage) {
			$dimens[0] = imagesx($sourceimage);
			$dimens[1] = imagesy($sourceimage);
			$newwidth = $dimens[0] * $data['scale'];
			$newheight = $dimens[1] * $data['scale'];
			
			$resizedimage = imagecreatetruecolor($newwidth, $newheight);
			
			imagecopyresampled($resizedimage, $sourceimage, 0, 0, 0, 0, $newwidth, $newheight, $dimens[0], $dimens[1]);
			
			$r_dimens[0] = imagesx($resizedimage);
			$r_dimens[1] = imagesy($resizedimage);
			
			$crop = array();
			$crop['x'] = $data['x'];
			$crop['y'] = $data['y'];
			$crop['width'] = $data['w'];
			$crop['height'] = $data['h'];
			$cropped = imagecrop($resizedimage, $crop);
	
			// save as new avatar, using original filename
			$destfilename = DOCROOT.'/avatar/thumb'.$imagedetails['filename'];
			$destpath = pathinfo($destfilename, PATHINFO_DIRNAME);
			mkdir($destpath, 0777, true);
			
			$result = imagejpeg($cropped, $destfilename, 100);
			if ($result) {
				$data = array();
				$data['avatar'] = $imagedetails['filename'];
				$data['userid'] = User::UserID();
				User::UpdateUser($data);
				return true;
			} else {
				CroissantError::RecordError('Error creating avatar image', array('imageid' => $imageid, 
						'indata' => $data, 
						'imagedetails' => $imagedetails, 
						'sourcefilename' => $sourcefilename,
						'destfilename' => $destfilename,
						'destpath' => $destpath
						
				));
				return false;
			}
		
		} else {
			CroissantError::RecordError('Error creating avatar image - imagecreatefrom($sourcefilename) failed using '.$ext, array('imageid' => $imageid,
				'indata' => $data,
				'imagedetails' => $imagedetails,
				'sourcefilename' => $sourcefilename,
				'destfilename' => $destfilename,
				'destpath' => $destpath
				
			));
			return false;
		}
		
	}
	
	public static function AddFavouriteModel($modelid) {
		if ($modelid != '') {
			$response = ds('model_AddFavouriteModel', array('modelsefu' => $modelid));
			return genericResponse($response);
		}
		return false;
	}
	
	public static function RemoveFavouriteModel($modelid) {
		if ($modelid != '') {
			$response = ds('model_RemoveFavouriteModel', array('modelsefu' => $modelid));
			return genericResponse($response);
		}
		return false;
	}
	
	public static function GetFavouriteModels() {
		$response = ds('model_GetFavouriteModels');
		return genericResponse($response);
	}
	
	public static function UpdateInstagramFollowers(Int $uid): bool {
		if ($uid == 0) {
			return false;
		}
		$u = User::Loaduser($uid);
		$instaname = 'https://www.instagram.com/'.str_replace('@', '', $u['instagram_username']).'/';
		$meta = get_meta_tags($instaname);
		
		if (!empty($meta)) {
			
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
			} else {
				
			}
			
			if ($followers != $u['instagram_followers']) {
				$u['instagram_followers'] = $followers;
				
				// and update it
				$userDetails = array();
				$userDetails['userid'] = $uid;
				$userDetails['followers'] = $followers;
				ds('user_UpdateUser', array(
					'data' => $userDetails
				));
				return true;
			}
		} else {
			// oops, bad instagram username
			return false;
		}
	}
	
	public static function UpdateModelAvailability($availability, $uid = 0) {
		if ($uid == 0) {
			$uid = User::UserID();
		}
		$response = ds('model_UpdateModelAvailabability', array('uid' => User::UserID(), 'availability' => $availability));
		return $response['result'];
	}
	public static function GetModelAvailability($uid = 0) {
		if ($uid == 0) {
			$uid = User::UserID();
		}
		$response = ds('model_GetModelAvailability', array('uid' => $uid));
		return $response['result'];
	}
}
