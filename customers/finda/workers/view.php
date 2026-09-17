<?php
/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
namespace Croissant;

// view model page

if (isset($args[1])) {
	// we might be in sharing mode
	$auth = Cookie::GetCookie('projectshare'.$args[1]);
	if ($auth) {
		// set the shareuri into the session
		Session::SetVariable('shareuri', $args[1]);
		$shareuri = $args[1];
	}
}
$shareuri = Session::GetVariable('shareuri');

// logged out
if (User::UserID() == 0 && !$auth && empty($shareuri)) {
	// are we loading a model view?
	if (strpos($args[0], '-') != false) {
		$viewuser = Finda::GetUserBySefu($args[0], TYPE_MODEL);
		if ($viewuser) {
			Session::SetVariable('redirect', '/view/'.$args[0]);
			header('Location: /#signin');
		}
	} else {
		header('Location: /');
	}
	die();

} else {

	switch($args[1]) {
		case 'optionmodel':
		case 'offer-job':
			if (IS_AJAX_REQUEST) {
				// this has a data response, with messages
				$model = User::LoadUser($modelid);
				$offeredrate = str_replace(',', '', $offeredrate);
				$response = Jobs::AddModelToJob($modelid, $jobid, $offeredrate);
				if (empty($response['message'])) {
					$html['message'] = '<h2>'.$model['firstname'].' shortlisted</h2>';
				} else {
					$html['message'] = '<h3>There was a problem shortlisting '.$model['firstname'].'</h3><p>'.$response['message'].'</p>';
				}
				Core::Assign('model', $model);
				Core::Assign('jobid', $jobid);
				Core::Assign('jobtype', $bookingtype);
				switch($bookingtype) {
					case 'casting':
						$html['modelcard'] = Core::Fetch('jobs/modelsearch_modelcard_casting.tpl');
						break;
					case 'booking':
						$html['modelcard'] = Core::Fetch('jobs/modelsearch_modelcard_optioned.tpl');
						break;
					default:
						$html['modelcard'] = Core::Fetch('jobs/modelsearch_modelcard_optioned.tpl');
						break;
				}
				Core::JSONWrite($html);
			}
			die();
			break;
		case 'updateModelStatus':
			// requires $modelid, $jobid, $status
			if (IS_AJAX_REQUEST) {
				$response = Jobs::ClientUpdateModelForJob($jobid, $modelid, $status);
				Core::JSONWrite($response);
			}
			die();
			break;
		default:
			
			// do we have a shareuri?

			if (!empty($shareuri)) {
				$sharejob = Jobs::GetJobByShareURI($shareuri);
				$modelOnJob = false;
				foreach($sharejob['models'] as $k => $v) {
					if ($v['sefu'] == $args[0]) {
						$modelOnJob = true;
					}
				}
				if (!$modelOnJob) {
					Session::SetVariable('redirect', '/view/'.$args[0]);
					Session::SetVariable('shareuri', '');
					header('Location: /#signin');
					die();
				}
			}
			
			// this is always SEFU now
			$viewid = $args[0];
			$viewuser = array('status' => 0);
			if (strpos($viewid, '-') != false) {
				$viewuser = Finda::GetUserBySefu($viewid, TYPE_MODEL);
			}
			if ($viewuser['status'] == 1 || $viewuser['status'] == 99) {
				if ($viewuser['usertype'] == 1) {
					$model = $viewuser;
					$modelid = $model['id'];
					if (User::UserType() == TYPE_MODEL && $modelid != User::UserID()) {
						header('Location: /');
						die();
					}
				
					$action = $args[1];
					switch ($action) {
						case 'polaroids':
						case 'portfolio':
							break;
						default:
							$action = '';
							break;
					}
		
					// we want the sefu if it exists for use in the template links
					Core::Assign('modelid', $modelid);
					if (!is_numeric($modelid)) {
						$modelid = User::GetIdFromSefu($modelid);
					}
					
					// this loads more data than Finda::GetuserByName
					$model = User::LoadUser($modelid);
					$model['instagram_followers'] = Utilities::ThousandsFormat($model['instagram_followers']);
					
					// set up the workflow, if any
					$workflowStep = Session::GetVariable('workflowStep');
					if (!empty($workflowStep)) {
						$workflowData = Session::GetVariable('workflowData');
						// we don't have models in this dataset
						$models = Jobs::ClientGetModelsForJob($workflowData['id']);
						$workflowData['models'] = $models;
						foreach($workflowData['models'] as $k => $v) {
							if ($v['id'] == $modelid) {
								Core::Assign('job_status', $v['job_status']);
							}
						}
						Core::Assign('workflowData', $workflowData);
					}
					Core::Assign('workflowStep', $workflowStep);
					
					if (!empty($action)) {
						$polaroids = Finda::GetUserimages('polaroids', $modelid);
						$polaroids = array_values($polaroids);
						if (!empty($polaroids)) {
							foreach($polaroids as $k => $v) {
								$gallerypolaroids[] = $v['id'];
							}
							$gallerypolaroids = '['.implode(',', $gallerypolaroids).']';
							Core::Assign('gallerypolaroids', $gallerypolaroids);
							$polaroids[0]['prev'] = $polaroids[count($polaroids)-1]['id'];
							$polaroids[0]['next'] = $polaroids[1]['id'];
							for ($i = 1; $i < count($polaroids); $i++) {
								$polaroids[$i]['prev'] = $polaroids[$i-1]['id'];
								$polaroids[$i]['next'] = $polaroids[$i+1]['id'];
							}
							$polaroids[count($polaroids)-1]['next'] = $polaroids[0]['id'];
						} else {
							$polaroids = array();
							Core::Assign('gallerypolaroids', array());
						}
						Core::Assign('polaroids', $polaroids);

						$portfolio = Finda::GetUserimages('portfolio', $modelid);
						// given the way we move stuff about, we now need to remove the keys from this array
						$portfolio = array_values($portfolio);
						if (!empty($portfolio)) {
							foreach($portfolio as $k => $v) {
								$galleryportfolio[] = $v['id'];
							}
							$galleryportfolio = '['.implode(',', $galleryportfolio).']';
							Core::Assign('galleryportfolio', $galleryportfolio);
							$portfolio[0]['prev'] = $portfolio[count($portfolio)-1]['id'];
							$portfolio[0]['next'] = $portfolio[1]['id'];
							for ($i = 1; $i < count($portfolio); $i++) {
								$portfolio[$i]['prev'] = $portfolio[$i-1]['id'];
								$portfolio[$i]['next'] = $portfolio[$i+1]['id'];
							}
							$portfolio[count($portfolio)-1]['next'] = $portfolio[0]['id'];
						} else {
							$portfolio = array();
							Core::Assign('galleryportfolio', array());
						}
						Core::Assign('portfolio', $portfolio);
						Core::Assign('body_class', 'model-images');
						
						$template = 'jobs/viewmodel_images.tpl';
						Core::Assign('imagetype', $action);
						Core::Assign('banner_title', $model['firstname'].' '.substr($model['lastname'], 0, 1).'.');
						
						Core::AddCSS('models/viewmodel_images.css');
						
						Core::AddCSS('vendor/jquery.scrollindicatorbullets.css');
						Core::AddJavascript('vendor/notify.js');
						Core::AddJavascript('vendor/waypoints/noframework.waypoints.min.js');
						Core::AddJavascript('vendor/scrollindicatorbullets/scrollindicatorbullets.min.js');
						
						Core::AddJavascript('jobs/modelimages.js');
					} else {
						$days = Search::ReorderDays();
						array_shift($days);
						foreach($days as $day) {
							$model['lastminute'][$day] = !empty($model[$day])?$model[$day]:0;
						}
						
						$template = 'jobs/viewmodel.tpl';
						$calendar = Model::GetModelSchedule($model['id'], time(), time()+(60*60*24*28));
						// convert to a display array, starting with today
						$todayis = date('j', time()); // + 1;
						$monthis = date('m', time());
						$yearis = date('Y', time());
						
						$begin = new \DateTime($yearis.'-'.$monthis.'-'.$todayis);
						$end = new \DateTime($yearis.'-'.$monthis.'-'.$todayis);
						$end = $end->modify('+7 day');
						
						$interval = new \DateInterval('P1D');
						$daterange = new \DatePeriod($begin, $interval ,$end);
						
						$days = array();
						foreach($daterange as $date) {
							$dayentry = array();
							$dayis = $date->format("j");
							$dayname = strtolower($date->format("l"));
							$dayentry['day'] = $dayis;
							$matchdate = $date->format("d-M-Y");
							$dayentry['state'] = 'free';
							$dayentry['month'] = $date->format("M");
							$dayentry['monthlongname'] = $date->format("F");
							$dayentry['dayname'] = $date->format("D");
							$dayentry['available'] = isset($model['lastminute'][$dayname])?$model['lastminute'][$dayname]:0;
							unset($model['lastminute'][$dayname]);
							foreach($calendar as $calk => $calv) {
								if ($calv['startDate'] == $matchdate) {
									$dayentry['state'] = strtolower($calv['state']);
								}
							}
							if ($dayentry['available'] == 2) {
								$dayentry['state'] = 'busy';
							}
							$dayentry['timestamp'] = $date->getTimestamp();
							$days[] = $dayentry;
						}
						Core::Assign('calendar', $days);
						Core::Assign('thismonth', $monthis);
						
					}
					Core::AddJavascript('models/viewmodel.js');
					Core::AddJavascript('messaging.js');
					Core::AddCSS('messaging.css');
					Core::Assign('model', $model);
					
					$messages = Notification::GetComposedNotifications($model['id']);
					Core::Assign('messages', $messages);
	
					$jobs = Jobs::ClientGetJobsList('pending');
					foreach($jobs as $k => $v) {
						if ($v['job_status'] != 0) {    // from job table
							unset($jobs[$k]);
						}
						if ($v['startdate'] < time()) {
							unset($jobs[$k]);
						}
						if (isset($v['models'][$modelid])) {
							unset($jobs[$k]);
						}
					}
					if (!empty($jobs)) {
						// get first job
						$defaultjob = array_shift($jobs);
						// retain keyed index
						$jobs[$defaultjob['id']] = $defaultjob;
						Core::Assign('defaultjob', $defaultjob);
						Core::Assign('jobs', $jobs);
					} else {
						Core::Assign($jobs, '');
					}
					
					$jobtypes = Taxonomy::GetTermsByVocabulary(1, true);
					Core::Assign('jobtypes', $jobtypes);
					
					if (User::UserType() == TYPE_CLIENT) {
						if ($workflowStep == 'fromeditsearch') {
							Core::AddJavascript('jobs/jobshandler.js');
						} else {
							Core::AddJavascript('jobs/jobsviewhandler.js');
						}
					}
	
					Core::AddCSS('model/viewmodel.css');
					
					$page_title = $model['firstname'].' '.$model['lastname'].' '.$action;
				} else {
					Core::Assign('client', $viewuser);
					$template = 'client/viewclient.tpl';
				}
			} else {
				header('Location: /');
				die();
			}
			break;
	}
}

