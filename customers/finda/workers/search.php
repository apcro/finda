<?php
/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
namespace Croissant;

if (User::UserID() == 0) {
	header('Location: /');
	die();
}

if (User::UserType() == 0) {
	header('Location: /');
	die();
}

if (User::UserStatus() == 0) {
	header('Location: /');
	die();
}
// client model search
switch($args[0]) {
	case 'ajax-find':
		// ajax find
		if (IS_AJAX_REQUEST) {
			$data = array();
			$data['height'] = $height;
			$data['dresssize'] = $dresssize;
			$data['suitsize'] = $suitsize;
			$data['collarsize'] = $collarsize;
			$data['favouritesonly'] = $favouritesonly == 'yes'?1:0;
			
			$data['ringsize'] = $ringsize;
			
			// optional
			if ($hairtype != 0) {
				$data['hairtype'] = $hairtype;
			}

			if ($haircolour != 0) {
				$data['haircolour'] = $haircolour;
			}

			if ($hairlength != 0) {
				$data['hairlength'] = $hairlength;
			}

			if ($eyecolour != 0) {
				$data['eyecolour'] = $eyecolour;
			}

			if ($willcolour != 'n/a') {
				$data['willingtodye'] = $willcolour == 'yes'?1:0;
			}

			if ($willcut != 'n/a') {
				$data['willingtocut'] = $willcut == 'yes'?1:0;
			}

			if ($driverslicense != 'n/a') {
				$data['driverslicense'] = $driverslicense == 'yes'?1:0;
			}

			if ($tattoo != 'n/a') {
				$data['tattoo'] = $tattoo == 'yes'?1:0;
			}
			
			
			if (isset($offeredrate)) {
				$data['offeredrate'] = $offeredrate;
			}
			if (isset($unitstype)) {
				$data['unitstype'] = $unitstype;
			}
			if (isset($altrate)) {
				$data['altrate'] = $altrate;
				if (!empty($altrate)) {
					$data['offeredrate'] = 0;
				}
			}
			
			$instafollowercounts = array('5k', '10k', '15k', '20k', '25k', '30k', '35k', '40k', '45k', '50k', '55k', '60k', '65k', '70k', '75k', '80k', '85k', '90k', '95k', '100k', '200k', '300k', '400k', '500k', '600k', '700k', '800k', '900k', '1m');
			if ($instafollowers != 0) {
				if ($instafollowercounts[$instafollowers] == '1m') {
					$data['instafollowers'] = 1000000;
				} else {
					$data['instafollowers'] = str_replace('k', '', $instafollowercounts[$instafollowers]) * 1000;
				}
			}
			
			$searchparameters = Core::LoadVariableByKey('searchsettings', '{"cupsizes":["AA","A","B","C","D","DD","E","F","FF","G","H","HH","I","J","JJ","K"],"height":[165,200],"bustsize":[74,142],"waistsize":[55,124],"hipsize":[50,150],"shoesize":[2,14],"collarsize":[35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55],"dresssize":[2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,18,17,18,19,20,21,22],"suitsize":[36,38,40,42,44,46,48,50,52,54],"boardtype":"all"}');
			
			// @TODO update these numbers from the stored parameters in the CMS
			if ($bustsize[0] != 70 || $bustsize[1] != 140) {
				$data['bustsize'] = $bustsize;
			}

			if ($waistsize[0] != 50 || $waistsize[1] != 124) {
				$data['waistsize'] = $waistsize;
			}

			if ($shoesize[0] != 2 || $shoesize[1] != 14) {
				$data['shoesize'] = $shoesize;
			}
			
			if ($cupsize[0] != 0 || $cupsize[1] != 15) {
				$data['cupsize'] = $cupsize;
			}
			
			if ($hipsize[0] != 50 || $hipsize[1] != 150) {
				$data['hipsize'] = $hipsize;
			}
			
			if ($skintones[0] != -1) {
				$data['skintones'] = $skintones;
			}
			
			$data['boardtype'] = $boardtype;
			
			$data['sortorder'] = $sortorder;
			
			$data['jobid'] = $jobid;
			
			if (isset($starttime) && isset($endtime)) {
				$data['starttime'] = $starttime;
				$data['endtime'] = $endtime;
			}
			
			// lastminute availability
			if (!empty($lastminute) && !in_array(-1, $lastminute)) {
				$data['lastminute'] = $lastminute;
				$availableonly = true;
			} else {
				$data['lastminute'] = array();
			}
			
			// location
			if (!empty($locations) && $locations != 0) {
				$data['locations'] = array($locations);
			}
			
			if (!empty($categories) && !in_array('any', $categories)) {
				$data['categories'] = $categories;
			}
			
			if (isset($pagerstart)) {
				$data['pagerstart'] = $pagerstart;
			}
			
			if (isset($pagerend)) {
				$data['pagerend'] = $pagerend;
			}
			
			$data['availableonly'] = $availableonly;
			
			Session::SetVariable('searchsettings', json_encode($data));
			$results = Search::Find($data);
			
			$modelcount = $results['count'];
			unset($results['count']);
			Core::Assign('models', $results);
			
			if ($jobedit) {
				$job = Jobs::GetJobDetails($jobid);
				if ($job['project_tid'] == 75 || $job['project_tid'] == 78) {
					Core::Assign('jobtype', 'casting');
				} else {
					Core::Assign('jobtype', 'booking');
				}
				Core::Assign('job', $job);
				Core::Assign('unitstype', $unitstype);
				$html = Core::Fetch('search/jobedit_results.tpl');
			} else {
				$html = Core::Fetch('search/results.tpl');
			}

			header('Content-Type: application/json; charset=utf-8');
			header('HTTP/1.0 200 OK', 200);
			print json_encode(array('html' => $html, 'modelcount' => $modelcount, 'filteredcount' => count($results)));
			if (json_last_error() == 5) {
				// one of the entries is incorrectly encoded?
				$html = utf8_encode($html);
				print json_encode(array('html' => $html, 'modelcount' => $modelcount, 'filteredcount' => count($results)));
			}
		}
		die();
		break;
	case 'toggle-favourite':
		if (IS_AJAX_REQUEST) {
			$favourites = Model::GetFavouriteModels();
			$toggled = false;
			foreach($favourites as $k => $v) {
				if ($v['sefu'] == $modelid) {
					Model::RemoveFavouriteModel($modelid);
					$toggled = true;
				}
			}
			if (!$toggled) {
				Model::AddFavouriteModel($modelid);
			}
		}
		die();
	default:
		
		$hairlengths = Taxonomy::GetTermsByVocabulary(5, true);	// hair length VID
		Core::Assign('hairlengths', $hairlengths);
		$hairtypes = Taxonomy::GetTermsByVocabulary(3, true);	// hair types VID
		Core::Assign('hairtypes', $hairtypes);
		$haircolours = Taxonomy::GetTermsByVocabulary(6, true);	// hair colours VID
		Core::Assign('haircolours', $haircolours);
		$eyecolours = Taxonomy::GetTermsByVocabulary(4, true);	// eye colours VID
		Core::Assign('eyecolours', $eyecolours);

		$categories = Taxonomy::GetTermsByVocabulary(11, true);	// categories colours VID
		Core::Assign('categories', $categories);

		$user_locations = Taxonomy::GetTermsByVocabulary(18, true);	// locations VID
		Core::Assign('user_locations', $user_locations);

		$jobtypes = Taxonomy::GetTermsByVocabulary(1, true);
		Core::Assign('jobtypes', $jobtypes);

		$skintones = Taxonomy::GetTermsByVocabulary(22, true);
		Core::Assign('skintones', $skintones);
		
		
		Core::AddCSS('vendor/jquery-ui.css');
		Core::AddCSS('jobedit.css');
		Core::AddCSS('select2.min.css');
		Core::AddCSS('vendor/awesomplete.css');
		Core::AddCSS('search.css');
		
		Core::AddJavascript('vendor/jquery-ui.js');
		Core::AddJavascript('vendor/select2/select2.min.js');
		Core::AddJavascript('vendor/awesomplete.min.js');
		Core::AddJavascript('search.js');

		$searchparameters = Core::LoadVariableByKey('searchsettings', '{"cupsizes":["AA","A","B","C","D","DD","E","F","FF","G","H","HH","I","J","JJ","K"],"height":[165,200],"bustsize":[74,142],"waistsize":[55,124],"hipsize":[50,150],"shoesize":[2,14],"collarsize":[35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55],"dresssize":[2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,18,17,18,19,20,21,22],"suitsize":[36,38,40,42,44,46,48,50,52,54],"boardtype":"all"}');

		// adding new data
		$params = json_decode($searchparameters);
		
		if (!isset($params->suitsize)) {
			$params->suitsize = array(36,38,40,42,44,46,48,50,52,54,56);
		}
		if (!isset($params->collarsize)) {
			$params->collarsize = array(35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55);
		}
		if (!isset($params->boardtype)) {
			$params->boardtype = 'all';
		}
		if (!isset($params->sortorder)) {
			$params->sortorder = 'nameatoz';
		}
		
		if (!isset($params->waistsize)) {
			$params->waistsize = array(55, 124);
		}
		
		if (!isset($params->hipsize)) {
			$params->hipsize = array(50, 150);
		}
		
		if (!isset($params->dresssizes)) {
			$params->dresssizes = array((int) current($params->dresssize), end($params->dresssize));
		}
		if (!isset($params->suitsizes)) {
			$params->suitsizes = array((int) current($params->suitsize), end($params->suitsize));
		}
		if (!isset($params->cupsizes)) {
			$params->cupsizes = array('AA', 'A', 'B', 'C', 'D', 'DD', 'E', 'F', 'FF', 'G', 'H', 'HH', 'I', 'J', 'JJ', 'K');
		}
		
		if (!isset($params->followercounts)) {
			$params->followercounts = array('0', '5k', '10k', '15k', '20k', '25k', '30k', '35k', '40k', '45k', '50k', '55k', '60k', '65k', '70k', '75k', '80k', '85k', '90k', '95k', '100k', '200k', '300k', '400k', '500k', '600k', '700k', '800k', '900k', '1m');
		}
		
		$params->collarsizes = array((int) current($params->collarsize), end($params->collarsize));
		$searchparameters = json_encode($params);
		
		Core::Assign('parameters', $searchparameters);
		Core::Assign('smartyparams', (array) $params);
		
		$searchsettings = Session::GetVariable('searchsettings');
		
		if (empty($searchsettings)) {
			$searchsettings = $searchparameters;
			Session::SetVariable('searchsettings', $searchsettings);
		} else {
			$settings = json_decode($searchsettings, true);
			$recode = false;
			if (empty($settings['height'])) {
				$settings['height'] = array(165, 200);
				$recode = true;
			}
			if (empty($settings['boardtype'])) {
				$settings['boardtype'] = 'all';
				$recode = true;
			}
			if (empty($settings['sortorder'])) {
				$settings['sortorder'] = 'nameatoz';
				$recode = true;
			}
			$recode = true;
			if ($recode) {
				$searchsettings = json_encode($settings);
				Session::SetVariable('searchsettings', $searchsettings);
			}
		}
		
		// need to reset this
		// @TODO sort out the merging of server-set searchparameters and user-specific searchsettings
		$settings['sortorder'] = 'nameatoz';
		
		
		Core::Assign('searchsettings', $searchsettings);
		
		$jobs = Jobs::ClientGetJobsList('all');
		Core::Assign('jobcount', count($jobs));
		
		$defaultSearch = array();
		$defaultSearch['height'] = array(165, 200);
		$defaultSearch['boardtype'] = 'all';
		$defaultSearch['sortorder'] = 'nameatoz';
		$defaultSearch['instagram'] = 0;
		
		$results = Search::Find($defaultSearch);
		$modelcount = $results['count'];
		unset($results['count']);
		Core::Assign('modelcount', $modelcount);
		Core::Assign('models', $results);
		$template = 'search/search.tpl';
		$page_title = 'Find models';
		Core::Assign('body_class', 'body-blue');
		Core::Assign('grid_background', 'grid-bg-white');
		
		// we need some workflow handling
		// at this point we have a 'back' that goes nowhere
		Session::SetVariable('workflowStep', '');
		Session::SetVariable('workflowData', '');
		
		$modelnames = Finda::LoadAllModelNames();
		Core::Assign('searchnames', json_encode($modelnames));
		
		
		break;
}

