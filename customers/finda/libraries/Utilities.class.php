<?php
/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
namespace Croissant;

class Utilities extends Finda {

	static $core;

	public static function Initialise() {
		if (!isset(self::$core)) {
			self::$core = parent::Initialise();
		}

		return self::$core;
	}

	/* *****************************************************************************
	 * Helper functions
	 * *****************************************************************************/


	public static function ThousandsFormat($num) {
		$x = round($num);
		$x_number_format = number_format($x);
		$x_array = explode(',', $x_number_format);
		$x_parts = array('k', 'm', 'b', 't');
		$x_count_parts = count($x_array) - 1;
		$x_display = $x;
		$x_display = $x_array[0] . ((int) $x_array[1][0] !== 0 ? '.' . $x_array[1][0] : '');
		$x_display .= $x_parts[$x_count_parts - 1];
		return $x_display;
	}



	public static function guid() {
		
		$guid_pool = 'abcdef1234567890';
		$variant_pool = 'ab89';
		$version = 5;
		
		$guid = $guid.self::randString($guid_pool, 8).'-';
		$guid = $guid.self::randString($guid_pool, 4).'-';
		$guid = $guid.$version;
		$guid = $guid.self::randString($guid_pool, 3).'-';
		$guid = $guid.self::randString($variant_pool, 1);
		$guid = $guid.self::randString($guid_pool, 3).'-';
		$guid = $guid.self::randString($guid_pool, 12);
		return $guid;
	}
	
	private static function randString($source, $length) {
		$result = '';
		$sourcelength = strlen($source);
		for ($i = 0; $i < $length; $i++) {
			$result = $result.substr($source, rand(0, $sourcelength-1), 1);
		}
		return $result;
	}
	
	public static function GetNewReferrerCode($userid) {
		$breaker = 5;
		$user = User::LoadUser($userid);
		$code = self::makeCode($user['firstname'], $user['lastname']);
		$response = ds('model_CheckReferrerCode', array('userid' => $userid, 'code' => $code));
		while(!$response['result'] && $breaker > 0) {
			$breaker--;
			$code = self::makeCode($user['firstname'], $user['lastname']);
			$response = ds('model_CheckReferrerCode', array('userid' => $userid, 'code' => $code));
		}
		return $code;
	}
	
	private static function makeCode($f, $l) {
		$a = '';
		$a .= substr($f, 0, 3);
		$a .= mt_rand(0, 9);
		$a .= chr(mt_rand(65, 90));
		$a .= substr(str_rot13($l), mt_rand(0, strlen($l)), 1);
		$a = strtolower($a);
		return $a;
	}
	
	public static function FeetToCentimeters($length) {
		$parts = explode("'", $length);
		$feet = $parts[0];
		$inches = str_replace('"', '', $parts[1]);
		$total = $feet * 12 + $inches;
		return self::InchesToCentimeters($total);
	}
	
	public static function InchesToCentimeters($length) {
		return (int)floor($length * 2.54);
	}
	
	public static function CentimetersToInches($length) {
		return ceil($length*0.393700);
	}
	
	public static function CentimetersToFeet($length) {
		$realFeet = ($length*0.393700) / 12;
		$feet = floor($realFeet);
		$inches = round(($realFeet - $feet) * 12);
		$res = $feet . "'" . $inches . '"';
		return $res;
	}
}