<?php
/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
namespace Croissant;

class Mailchimp3 extends Core {

	private static $_url = 'https://us17.api.mailchimp.com/3.0/';

	static $core;
	
	public static function Initialise() {
		if (!isset(self::$core)) {
			self::$core = parent::initialise();
		}
		
		$parts = explode('-', MAILCHIMP_API_KEY);
		self::$_url = 'https://'.$parts[1].'.api.mailchimp.com/3.0/';
		
		return self::$core;
	}

	private static function _curl($url, $params) {

		$ch = curl_init();
		// Set query data here with the URL
		curl_setopt($ch, CURLOPT_HTTPHEADER, array('Content-Type: application/json','Accept: application/json'));
		curl_setopt($ch, CURLOPT_HEADER, 1);
		curl_setopt($ch, CURLOPT_HTTPAUTH, CURLAUTH_BASIC);
		curl_setopt($ch, CURLOPT_USERPWD, 'findaglobal:'.MAILCHIMP_API_KEY);
		curl_setopt($ch, CURLOPT_TIMEOUT, 30);
		curl_setopt($ch, CURLOPT_POST, 1);
		curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($params));
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, TRUE);
		curl_setopt($ch, CURLOPT_URL, $url);
		$data = trim(curl_exec($ch));

        if(curl_errno($ch)) {
			_log('error: '.curl_error($ch));
		}
		$status = curl_getinfo($ch, CURLINFO_HTTP_CODE);
		curl_close($ch);

		if ($status == 200) {
			return true;
		} else {
			if (DEBUG) {
				list($inheaders, $data) = explode("\r\n\r\n", $data, 2);
				_log('Error subscribing to Mailchimp');
				_log(print_r($inheaders, true));
				_log(print_r(json_decode($data), true));
			}
			return false;
		}
	}

	// a simplistic implementation of Mailchimp's listSubscribe in v3
	public static function ListSubscribe($listid, $email, $merge_vars, $source = 'internal') {

		if (DEBUG) _log('Subscribe to mailchimp from '.$source.': '.$email);

		if (!empty($email)) {
			$data = array();
			$data['email_address'] = $email;
			$data['status'] = 'subscribed';
			if (empty($merge_vars['LNAME'])) {
				unset($merge_vars['LNAME']);
			}
			if (empty($merge_vars['FNAME'])) {
				unset($merge_vars['FNAME']);
			}
			if (!empty($merge_vars)) {
				$data['merge_fields'] = $merge_vars;
			}

			$response = self::_curl(self::$_url.'lists/'.$listid.'/members/', $data);
			if (DEBUG) _log(print_r($response, true));
			return $response;
		} else {
			return false;
		}
	}
}