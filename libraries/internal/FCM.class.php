<?php
/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
namespace Croissant;

class FCM extends Core {
	
	public static $core;
	/**
	 * Initialise
	 *
	 * @return
	 */
	public static function Initialise() {
		if (!isset(self::$core)) {
			if (DEBUG) _log(__CLASS__.'::'.__FUNCTION__);
			self::$core = parent::Initialise();
		}
		return self::$core;
	}

	public static function SendPushMessage($to, $message, $badge = '', $custom = '') {
		if (DEBUG && LOCALDEV) {
			return;
		}
		
		$headers = array (
			'Authorization: key='.FCM_API_ACCESS_KEY,
			'Content-Type: application/json'
		);

		$fields = array (
			'to'		=> $to,
			'notification'	=> array('title' => '', 'body' => $message)
		);
		
		if (!empty($badge)) {
			$fields['notification']['badge'] = $badge;
		}
		
		if (!empty($custom)) {
			$fields['notification']['custom'] = $custom;
		} else {
			// let's update the custom field anyway
			$custom = array();
			
			$jobscount = Jobs::GetNewJobsCount();
			if (!empty($jobscount)) {
				$custom['jobscount'] = $jobscount;
			}

			$msgcount = Notification::GetNotificationCount('new');
			
			if (!empty($msgcount)) {
				$custom['msgcount'] = $msgcount;
			}
			
			// if now not empty
			if (!empty($custom)) {
				$fields['notification']['custom'] = $custom;
			}
		}
		
		
		$fields = json_encode($fields);
		// this sorts out the double-encoding of the \ by json_encode, needed for emoji support
		$fields = str_replace("\\\\", "\\", $fields);
		
		$ch = curl_init();
		curl_setopt( $ch,CURLOPT_URL, 'https://fcm.googleapis.com/fcm/send');
		curl_setopt( $ch,CURLOPT_POST, true);
		curl_setopt( $ch,CURLOPT_HTTPHEADER, $headers);
		curl_setopt( $ch,CURLOPT_RETURNTRANSFER, true);
		curl_setopt( $ch,CURLOPT_SSL_VERIFYPEER, false);
		curl_setopt( $ch,CURLOPT_POSTFIELDS, $fields);
		curl_exec($ch );
		curl_close( $ch );
	}
	
}