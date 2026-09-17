<?php
/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */

namespace Croissant;

class Google {
	
	public static function PlaceTextSearch($text) {
		$url = 'https://maps.googleapis.com/maps/api/place/textsearch/json';
		$url .= '?query=' . urlencode($text);
		$url .= '&key='.GOOGLE_PLACES; 
	
		$curl = curl_init();
		curl_setopt_array($curl, array(
				CURLOPT_RETURNTRANSFER => true,
				CURLOPT_URL => $url,
		));
		
		$result = curl_exec($curl);
	
		$return = null;
		if (!$result) {
			$return = array('error' => curl_error($curl) . ' (code ' . curl_errno($curl) . ')');
		} else {
			$return = json_decode($result, true);
		}
	
		curl_close($curl);
	
		return $return;
	}
	
	public static function PlaceDetails($placeId) {
		$url = 'https://maps.googleapis.com/maps/api/place/details/json';
		$url .= '?placeid=' . $placeId;
		$url .= '&key='.GOOGLE_PLACES; 
	
		$curl = curl_init();
		curl_setopt_array($curl, array(
				CURLOPT_RETURNTRANSFER => true,
				CURLOPT_URL => $url,
		));
		
		$result = curl_exec($curl);
	
		$return = null;
		if (!$result) {
			$return = array('error' => curl_error($curl) . ' (code ' . curl_errno($curl) . ')');
		} else {
			$return = json_decode($result, true);
		}
	
		curl_close($curl);
	
		return $return;
	}
	
	public static function GetLocation($placeId) {
		$response = array();
		
		$placeDetails = Google::PlaceDetails($placeId);
		$location = $placeDetails['result']['geometry']['location'];
		if (!empty($location)) {
			$response['lat'] = $location['lat'];
			$response['lon'] = $location['lng'];
		} else {
			$response['error'] = 'no location found with given placeId';
		}
		
		return $response;
	}
	
}