<?php
/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */

namespace Croissant;

class MailGun extends Core {

	static $core;

	static $_url = 'https://api.mailgun.net/v2/samples.mailgun.org/messages';

	public static function initialise() {
		if (!isset(self::$core)) {
			if (DEBUG) _log(__CLASS__.'::'.__FUNCTION__);
			self::$core = parent::initialise();
		}
		return self::$core;
	}

	private static function _post($data) {
		$ch = curl_init();
		curl_setopt($ch, CURLOPT_HTTPAUTH, CURLAUTH_BASIC);
		curl_setopt($ch, CURLOPT_USERPWD, 'api:key-'.MAILGUN_API_KEY);
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
		curl_setopt($ch, CURLOPT_CUSTOMREQUEST, 'POST');
		curl_setopt($ch, CURLOPT_URL, self::$_url);
		curl_setopt($ch, CURLOPT_POSTFIELDS, $data);
		$result = curl_exec($ch);
		curl_close($ch);
		return $result;
	}

	static function Send($subject, $body, $recipient, $from) {
		$data = array();
		$data['from'] = $from;
		$data['to'] = $recipient;
		$data['subject'] = $subject;
		$data['text'] = $body;
		self::_post($data);
	}

}