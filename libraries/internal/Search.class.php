<?php
/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
namespace Croissant;

class Search extends Core {
	static $core;
	public static function Initialise() {
		if (!isset(self::$core)) {
			if (DEBUG) _log(__CLASS__.'::'.__FUNCTION__);
			self::$core = parent::Initialise();
		}
		return self::$core;
	}

	/**
	 * Find results
	 *
	 * By default, terms are applied as AND. Set $solrparams['alltids'] = 'OR' to swap this behaviour
	 */

	// simplified version using the database initially
	public static function Find($data = array()) {
		if (empty($data)) {
			//get default data set
			$data = array();
			$data['height'] = array(150, 200);
			$data['bustsize'] = array(70, 140);
			$data['waistsize'] = array(50, 124);
			$data['hipsize'] = array(50, 150);
			$data['dresssize'] = array();
			$data['suitsize'] = array();
			$data['collarsize'] = array();
			$data['shoesize'] = array(2, 14);
			$data['favouritesonly'] = 0;
			$data['ringsize'] = array();
			$data['instafollowers'] = 0;
			$data['categories'] = array();
			$data['boardtype'] = 'All';
			$data['sortorder'] = 'nameatoz';
			$data['lastminute'] = array();
			$data['locations'] = array();
			$data['willingtodye'] = 0;
			$data['willingtocut'] = 0;
			$data['driverslicense'] = 0;
		}
		
		if (!isset($data['pagerstart'])) {
			$data['pagerstart'] = 0;
			$data['pagerend'] = 100;
		}
		
		$data['usertype'] = User::UserType();
		$data['motheragency'] = User::MotherAgency();
		
		$response = ds('modelsearch_Find', array('data' => $data));
		if (isset($response['statusCode']) && $response['statusCode'] == 0) {
			if (isset($data['jobid']) && $data['jobid'] != 0) {
				$response['result'] = self::AnnotateModels($data['jobid'], $response['result'] /*, $data['lastminute'] */);
			}
			$response['result'] = self::UpdateLastMinute($response['result']);
			$response['result']['count'] = $response['count'];
			return $response['result'];
		} else {
			return false;
		}
	}
	
	/* 
	 * takes the jobid and the search results and annotates the results based on the current details of the job
	 */
	public static function AnnotateModels($jobid, $searchresult /*, $selectedtimes = array() */) {
		$job = Jobs::GetJobDetails($jobid);

		// first we check if the job is in the next 6 days
		$lastminute = array();
		if ($job['startdate'] > time() && $job['startdate'] <= time()+(60*60*24*6)) {
			
			$days = self::ReorderDays();
			
			// lose today
			array_shift($days);
			$positions = array_flip(array_keys($days));
			
			$i = 0;
			foreach($days as $key => $day) {
				if ($job['startdate'] >= (time() + $i) && $job['startdate'] <= (time() +($i + 60*60*24))) {
					$lastminute[$day] = 1;
				} else {
					$lastminute[$day] = 0;
				}

				$i = $i + (60*60*24);
			}
		}

			
		// i'm sure there's a faster way
		foreach($searchresult as $k => $v) {
			$searchresult[$k]['job_status'] = 0;
			$searchresult[$k]['searchweight'] = 0;
			
			if (!empty($lastminute)) {
				foreach($lastminute as $day => $isday) {
					if ($isday == 1 && $searchresult[$k][$day] == 1) {
						$searchresult[$k]['searchweight'] = 1;	// available tomorrow
					} else if ($isday == 1 && $searchresult[$k][$day] == 2) {
						unset($searchresult[$k]);			// definitely not available tomorrow
					}
					
				}
			}
			// store these in an array in the result
			
			
			if (!empty($job['models'])) {
				$models = $job['models'];
				foreach($models as $kk => $vv) {
					if ($vv['id'] == $v['id']) {
						// match
						$searchresult[$k]['job_status'] = $vv['job_status'];
						$searchresult[$k]['model_desired_rate'] = $vv['model_desired_rate'];
						$searchresult[$k]['client_offered_rate'] = $vv['client_offered_rate'];
					}
				}
			}
			
		}
			
		// last step, move definitely available models to the top
		if (!empty($lastminute)) {
			$newresults = array();
			foreach($searchresult as $k => $v) {
				if ($v['searchweight'] == 1) {
					array_unshift($newresults, $v);
				} else {
					array_push($newresults, $v);
				}
			}
			$searchresult = $newresults;
		}
		return $searchresult;
	}
	
	public static function UpdateLastMinute($users) {
		$days = self::ReorderDays();
		foreach($users as $k => $v) {
			$users[$k]['lastminute'] = array();
			foreach($days as $day) {
				$users[$k]['lastminute'][$day] = !empty($users[$k][$day])?$users[$k][$day]:0;
			}
		}
		return $users;
	}
	
	public static function ReorderDays() {
		// set up days array - this is effectively an array rotation left x number of days
		$days = array('sunday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday');
		$todayis = strtolower(date('l', time()));
		// redo the array order for keys
		foreach($days as $day) {
			if ($day != $todayis) {
				$swap = array_shift($days);
				array_push($days, $swap);
			} else {
				break;
			}
		}
		return $days;
	}

}