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

if (User::UserType() == TYPE_CLIENT) {
	header('Location: /projects');
	die();
}

if (IS_AJAX_REQUEST) {
	$job = Jobs::GetJobDetails($jobid);
	switch($args[0]) {
		case 'accept':
			$response = Jobs::ModelAcceptJob($jobid);
			Core::JSONWrite($response);
			break;
		case 'reject':
			$response = Jobs::ModelRejectJob($jobid, $reasons);
			Core::JSONWrite($response);
			break;
	}
	die();

} else {
	switch($args[0]) {
		case 'bookingterms':
			$filename = BASEPATH.'/documents/Finda-ClientModelTerms.pdf';
			header('Content-Description: File Transfer');
			header('Content-Type: application/pdf');
			header('Content-Disposition: attachment; filename=Finda-ClientModelTerms.pdf');
			header('Content-Transfer-Encoding: binary');
			header('Expires: 0');
			header('Cache-Control: must-revalidate');
			header('Pragma: public');
			ob_clean();
			flush();
			readfile($filename);
			die();
			break;
		case 'view':
			include ('jobs/model_view_job.php');
			break;
		default:

			$alljobs = Jobs::ModelGetJobs();


			// we need to sort these, for now this is the quickest
			// we sort by jobcard_type
			$offered = array();
			$optioned = array();
			$expired = array();
			$accepted = array();
			$confirmed = array();
			$rejected = array();
			$cancelled = array();
			$finished = array();
			$expired = array();
			$tocomplete = array();
			$completed = array();
			$debug = array();
			$unconfirmed = array();
			
			foreach($alljobs as $job) {
				
				$job['calc_units'] = ($job['time_units'] >=1?$job['time_units']:1);
				
				switch($job['jobcard_type']) {
					case 'offered':
						$offered[] = $job;
						break;
					// deprecated
					case 'optioned':
						$optioned[] = $job;
						break;
					case 'expired':
						$expired[] = $job;
						break;
					case 'accepted':
						$accepted[] = $job;
						break;
					case 'confirmed':
						$confirmed[] = $job;
						break;
					case 'rejected':
						$rejected[] = $job;
						break;
					case 'cancelled':
						$cancelled[] = $job;
						break;
					case 'finished':
						$finished[] = $job;
						break;
					case 'to complete':
						$tocomplete[] = $job;
						break;
					case 'completed':
						$completed[] = $job;
						break;
					case 'unconfirmed':
						$unconfirmed[] = $job;
						break;
					default:
						$debug[] = $job;
				}
			}

			$jobs = array_merge($offered, $accepted, $confirmed, $tocomplete, $completed, $finished, $rejected, $expired);

			$jobs['upcoming'] = array_merge($confirmed, $offered, $accepted);
			$jobs['past'] = array_merge($tocomplete);
			$jobs['history'] = array_merge($completed, $finished, $unconfirmed, $rejected, $expired, $debug);
			
			Core::Assign('jobs', $jobs);
			Core::Assign('jobscount', count($jobs));

			Core::AddJavascript('vendor/cleave.js');

			Core::AddJavascript('modeldashboard.js');
			Core::AddJavascript('jobs/joboffers.js');

			Core::AddCSS('model/offers.css');
			Core::AddCSS('jobcard.css');

			if (User::UserType() == 1) {
				// model base
				Core::Assign('body_class', 'body-blue');
			} else {
				// client base
			}
			
			// get negotiation reasons
			$terms = Taxonomy::GetTermsByVocabulary(17, true);
			Core::Assign('negotiationreasons', $terms);

			// get rejection reasons
			$terms = Taxonomy::GetTermsByVocabulary(16, true);
			Core::Assign('rejectreasons', $terms);
			
			// get current user availability
			$lastminute = Model::GetModelAvailability();
			unset($lastminute['uid']);
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
			
			foreach($days as $day) {
				$neworder[$day] = $lastminute[$day];
			}
			
			$neworder[$todayis] = 0;
			Core::Assign('days', $neworder);
			
			$u = User::LoadUser(User::UserID());
			if ($u['mother_agency'] != 0) {
				$commissionrate = $u['motheragency_commission']/100;
				Core::Assign('commissionrate', $commissionrate);
			}
			Core::Assign('user', $u);
			
			Core::AddCSS('jobcard.css');
			Core::Assign('grid_background', 'grid-bg-white');
			$page_title = 'Job Offers';
			$template = 'user/offers/offers.tpl';
		}
	}