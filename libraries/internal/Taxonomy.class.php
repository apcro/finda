<?php
/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
namespace Croissant;

class Taxonomy extends Core {
	static $core;

	public static function Initialise() {
		if (!isset(self::$core)) {
			if (DEBUG) _log(__CLASS__.'::'.__FUNCTION__);
			self::$core = parent::Initialise();
		}
		return self::$core;
	}

	/**
	 * Return the vocabulary object matching a vocabulary ID.
	 *
	 * @param integer $vid The vocabulary's ID
	 * @return mixed - array on success, false on failure
	 */
	static function GetVocabulary($vid) {
		$response = ds('taxonomy_GetVocabulary', array('vid' => $vid));

		if (isset($response['statusCode']) && $response['statusCode']==0) {
			$node_types = array();
			foreach($response['result'] as $voc) {
				$node_types[] = $voc['type'];
				unset($voc->type);
				$voc['nodes'] = $node_types;
			}
		}
		return $response;
	}

	/**
	 * Get all terms for a given node within one vocabulary
	 * @param $nid int the relevant node id
	 * @param $vid int the relevant vocabulary id
	 * @param $key string unused
	 * @return mixed - array on success, false on failure
	 * @todo check deprecated!
	 */
	static function NodeGetTermsByVocabulary($nid, $vid, $key = 'tid') {
		$response = ds('taxonomy_NodeGetTermsByVocabulary', array('nid' => $nid, 'vid' => $vid));
		$terms = array();
		if (isset($response['statusCode']) && ($response['statusCode'] == 0) && !empty($response['result'])) {
			foreach($response['result'] as $term) {
				$terms[$term[$key]] = $term;
			}
		}
		return $terms;
	}

	/**
	 * Get all terms for a given Taxonomy
	 * By default, this is cached to disk for speed. The Taxonomy cache expires every hour (60*60 seconds)
	 * A full refresh may be forced.
	 * @param int $vid the vocabulary term to search for
	 * @param boolean $refresh - force a refresh from the database if true
	 * @param boolean $all - should the method return all Taxonomy Terms? (default true)
	 * @return array $terms
	 */
	static function GetTermsByVocabulary($vid, $refresh = false, $all = true) {

		$path = CACHEPATH.'/taxonomy/';
		$file = $path.'vocab_'.$vid.'.cache';
		if (!file_exists($path)) {
			mkdir($path);
		}

		if ( ((file_exists($file) && filemtime($file) < (time()-(60*60)) ) || !file_exists($file)) || $refresh) {
			// update the cache
			$response = ds('taxonomy_GetTermsByVocabulary', array('vid' => $vid));

			// now convert to properly indexed array
			$terms = $response['result'];
			foreach($terms as $key => $value) {
				$newterms[$value['tid']] = $value;
			}
			$data = serialize($newterms);
			$fp = fopen($file, 'w');
			fwrite($fp, $data);
			fclose($fp);
			$terms = $newterms;
		} else {
			if ($fp = fopen($file, 'r')) {
				$data = '';
				while (!feof($fp)) {
					$data .= fread($fp, 1024);
				}
				fclose($fp);
				$terms = unserialize($data);
			}
		}

		return $terms;
	}

	/**
	 * Get all terms that have children by vocabulary $vid
	 * @param integer $vocab the vocabulary to search by
	 * @return mixed - array on success, false on failure
	 */
	static function GetParentsByVocabularyName($vocab) {
		$vid = self::GetVID($vocab);
		$response = ds('taxonomy_GetParentsByVocabulary', array('vid' => $vid));
		return Core::GenericResponse($response);
	}

		/**
	 * Return the term object matching a term ID.
	 *
	 * @param integer $tid A term's ID
	 * @return array
	 */
	static function GetTerm($tid = 0 ) {
		if (!$tid) return array();

		$terms = Session::GetVariable('taxonomy_terms');
		if(empty($terms)) $terms=array();
		if (!isset($terms[$tid])) {
			$response = ds('taxonomy_GetTerm', array('tid' => $tid));
			if (isset($response['statusCode']) && $response['statusCode']==0) {
				$terms[$tid] = $response['result'][0];
			}
		}
		Session::SetVariable('taxonomy_terms', $terms);
		return $terms[$tid];
	}


	/**
	 * Get all terms that have children
	 * @param integer $tid the term id to search by
	 * @return mixed - array on success, false on failure
	 */
	static function GetParents($tid = 0) {
		if (!$tid) return array();

		$response = ds('taxonomy_GetParents', array('tid' => $tid));
		return Core::GenericResponse($response);
	}

	/**
	 * Get all child terms of a given parent
	 * @param integer $tid the term id to search by
	 * @return mixed - array on success, false on failure
	 */
	static function GetChildren($tid = 0, $refresh = false) {
		return array();
		if (!$tid) {
			return array();
		}
		$path = CACHEPATH.'/taxonomy/';
		$file = $path.'term_'.$tid.'.cache';
		if (!file_exists($path)) {
			mkdir($path);
		}
		if (((file_exists($file) && filemtime($file) < (time()-(60*60*24)) ) || !file_exists($file)) || $refresh) {
			// update the cache
			$response = ds('taxonomy_GetChildren', array('tid' => $tid));
			if (isset($response['statusCode']) && $response['statusCode']==0) {
				// now convert to properly indexed array
				$terms = $response['result'];
				foreach($terms as $key => $value) {
					$terms[$value['tid']] = $value;
					unset($terms[$key]);
				}
				$fp = fopen($file, 'w');
				fwrite($fp, serialize($terms));
				fclose($fp);
				return $response['result'];
			} else {
				return false;
			}
		} else {
			if ($fp = fopen($file, 'r')) {
				$data = '';
				while (!feof($fp)) {
					$data .= fread($fp, 1024);
				}
				fclose($fp);
				if (strlen($data) > 0) {
					return unserialize($data);
				} else {
					return array();
				}
			}
		}
	}

	/**
	 * Identical to TaxonomyGetTermByLabel but matches against the 'label' column
	 * 
	 * @param string $label
	 * @param mixed $vid
	 * @return
	 */
	static function GetTermByLabelForSearch($name, $vid = array()) {
		if (empty($vid)) {
			$vid = explode(',', VOCABULARIES);
		}
		$response = ds('taxonomy_GetTermByNameForSearch', array('name' => $name, 'vid' => $vid));
		return Core::GenericResponse($response);
	}

	/**
	 *  Get first generation children 
	 * 
	 * @param int $vid
	 * @return
	 */
	public function TaxonomyGetFirstGenerationChildren($vid){
		$response = ds('taxonomy_TaxonomyGetFirstGenerationChildren', array('vid' => $vid));
		return Core::GenericResponse($response);
	}

	/**
	 * Find all terms associated with the given node, ordered by vocabulary and term weight.
	 * @param $nid int the relevant node id
	 * @param $vid int the relevant vocabulary id
	 * @return array
	 * @todo check deprecated!
	 */
	static function NodeGetTerms($nid, $key = 'tid') {
		if (!isset($terms[$nid][$key])) {
			$response = ds('taxonomy_NodeGetTerms', array('nid' => $nid));
			if (isset($response['statusCode']) && $response['statusCode']==0) {
				foreach($response['result'] as $k => $term) {
					if (is_numeric($k)) {
						$terms[$nid][$key][$term[$key]] = $term;
					} else {
						$terms[$nid][$key][$k] = $term;
					}
				}
			}
		}
		Session::SetVariable('taxonomy_terms', $terms);
		return $terms[$nid][$key];
	}

	/**
	 * Return vocabulary data by vocabulary id
	 * @param int $vid the vocabulary id
	 * @return array
	 */
	static function GetNameFromVID($vid) {
		switch($vid) {
			case SUBJECTS:
				return array('name' => 'Subjects', 'link' =>'subjects');
			case STAGES:
				return array('name' => 'Stages', 'link' => 'stages');
			case ROLES:
				return array('name' => 'Roles', 'link' => 'roles');
			case WHOLE_SCHOOL:
				return array('name' => 'Whole School', 'link' => 'whole-school');
			case MY_SCHOOL_LIFE:
				return array('name' => 'My School Life', 'link' => 'my-school-life');
			default:
				return array();
		}
	}

	/**
	 * Return a vocabulary id by name
	 * @param string $vocab the vocabulary name
	 * @return int
	 */
	static function GetVID($vocab) {
		switch(strtolower($vocab)) {
			case 'subjects':
				return SUBJECTS;
			case 'stages':
				return STAGES;
			case 'roles':
				return ROLES;
			case 'whole-school':
				return WHOLE_SCHOOL;
			case 'my-school-life':
				return MY_SCHOOL_LIFE;
			default:
				return 0;
		}
	}

	static function Flatten($termarray) {
		$output = array();
		$temp = array();
		foreach($termarray as $k => $v) {
			$vv = $v;
			unset($vv['children']);
			$temp[] = $vv;
			if (isset($v['children'])) {
				foreach($v['children'] as $ck => $cv) {
					$cvv = $cv;
					$temp[] = $cv;
				}
			}
		}
		foreach($temp as $k => $v) {
			$output[$v['tid']] = $v;
		}
		return $output;
	}
}