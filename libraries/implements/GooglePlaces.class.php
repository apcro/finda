<?php
/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
namespace Croissant;


class GooglePlaces extends Core {
	static $_apiKey = GOOGLEPLACES_APIKEY_TAKEMEOUT;

	static $_endPoint = 'https://maps.googleapis.com/maps/api/place/photo';

	// use GET method instead of SOAP
	static function _curl($url) {
		if (DEBUG) _log(__CLASS__.'::'.__FUNCTION__);


		$ch = curl_init();
		// Set query data here with the
		curl_setopt($ch, CURLOPT_URL, $url);
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
		curl_setopt($ch, CURLOPT_TIMEOUT, '30');
		curl_setopt($ch, CURLOPT_HTTPHEADER, $header);
		$data = trim(curl_exec($ch));
		$info = curl_getinfo($ch);
		curl_close($ch);
		return $data;

	}

	function GetPlaceImage($reference) {

	}

	function GetPlaceDetails($lat, $lon) {
		$url = 'https://maps.googleapis.com/maps/api/place/details/json';
		$url .= '?key='.self::$_apiKey;

	}

	function FindPlaces($lat, $lon, $type = '', $language = 'en') {
		$url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json';
		$url .= '?location='.$lat.','.$lon;
		if (!empty($type)) {
			$url .= '&rankby=distance';
			$url .= '&type='.$type;	
		} else {
			$url .= '&rankby=prominence';
		}
		$url .= '&language='.$language;
		$url .= '&key='.self::$_apiKey;

		$data = self::_curl($url);

		return json_decode($data);
	}
}