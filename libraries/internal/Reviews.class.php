<?php
/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
namespace Croissant;

class Reviews extends Core {
	static $core;
	public static function Initialise() {
		if (!isset(self::$core)) {
			if (DEBUG) _log(__CLASS__.'::'.__FUNCTION__);
			self::$core = parent::Initialise();
		}
		return self::$core;
	}

	public static function LoadReview($id) {
		return ds('review_Loadreview', array('id' => $id));
	}


	/**
	 * Add review
	 *
	 * Adds a sanitised review to a given item, identified by the meta id 'nid'
	 *
	 * @param $newreview array an array of review data
	 * @return mixed
	 */
	static function AddReview($newreview = array()) {
		if (empty($newreview['type']) || !isset($newreview['type'])) {
			$type = 1;	// default to type=review
		} else {
			$type = $newreview['type'];
		}

		// and a last spam check, if the review has more than 3 HTTP in it, reject it silently
		if (substr_count($newreview['review'], 'http') < 2) {
			// save the review, default unpublished
			$response = ds('review_Addreview', array(
				'recipientid' => $newreview['recipientid'],
				'review' => nl2br($newreview['review']),
				'subject' => $newreview['subject'],
				'type' => $type,
			));
		} else {
			return false;
		}

		return Core::GenericResponse($response);
	}

	

	/**
	 * Load Reviews for a given node (or programme) ID
	 *
	 * @param nid integer a node or programme ID
	 * @param int $start
	 * @param int $limit
	 * @return array
	 */
	static final public function LoadReviews($id = 0, $start = 0, $limit = null) {
		if ($id == 0) return false;

		$response = ds('review_LoadReviews', array('id' => $id, 'start' => $start, 'limit' => $limit));

		if (isset($response['statusCode']) && $response['statusCode'] == 0) {
			return $response['result'];
		} else {
			return array();
		}
	}

	/**
	 * Update the status of an individual review
	 * @param int $cid the new review id
	 * @param int $status the new status
	 * @return mixed - array on success, false on failure
	 */
	static function UpdateReviewstatus($id = 0, $status) {
		if ($id == 0) return false;
		$response = ds('review_UpdateReviewStatus', array('id' => $id, 'status' => $status));
		if (isset($response['statusCode']) && $response['statusCode'] == 0) {
			return true;
		} else {
			return false;
		}
	}

	/**
	 * Load Reviews for a given user ID
	 *
	 * @param nid integer a node or programme ID
	 * @param limit integer if want unlimit assign 0
	 * @return array
	 */
	static final public function LoadReviewsByUser($id = 0, $limit = 5) {
		if ($id == 0) {
			return false;
		}

		$response = ds('review_LoadReviewsByUser', array('id' => $id, 'limit' => $limit) );
		return Core::GenericResponse($response);
	}
	
	static final public function LoadReviewsForUser($id = 0, $limit = 5) {
		if ($id == 0) {
			return false;
		}
		
		$response = ds('review_LoadReviewsForUser', array('id' => $id, 'limit' => $limit) );
		return Core::GenericResponse($response);
	}

	/**
	 * review::CountReviews()
	 * 
	 * @param int $nid
	 * @return
	 */
	public static function CountReviews($nid) {
		$response = ds('review_CountReviews', array('nid' => $nid));
		return Core::GenericResponse($response);
	}
}