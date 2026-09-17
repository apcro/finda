<?php
/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
namespace Croissant;

if ($args[0] != 'share' && $args[0] != 'shareauth') {
	if (User::UserID() == 0) {
		header('Location: /');
		die();
	}
	
	if (User::UserType() == TYPE_MODEL && !IS_AJAX_REQUEST) {
		header('Location: /user');
		die();
	}
	
	if (User::UserStatus() == 0) {
		header('Location: /user');
		die();
	}
}
$filter = $args[0];
switch ($filter) {
	case 'newproject':
		// this is for when we want to immediately create a job via a link, and leave the user on that page
		// we may also pass in a model ID to automatically shortlist that model
		// we will always have a timestamp, or error
		if (isset($ts)) {
			$formdata = array();
			$formdata['name'] = isset($projectname)?$projectname:"Unnamed";
			$formdata['description'] = '';
			$formdata['location'] = '';
			$formdata['project_tid'] = 58;
			$formdata['offered_rate'] = !empty($rate_input)?$rate_input:0;
			$formdata['time_units'] = 1;
			$formdata['units_type'] = 'day';
			$formdata['modelcount'] = 1;
			$formdata['startdate'] = $ts; // two days
			$formdata['starttime'] = $ts;
			$formdata['request_address'] = 0;
			
			$usage = array();
			$usage['uk'] = 1;
			$usage['europe'] = 0;
			$usage['international'] = 0;
			
			// the basic usage types
			$formdata['baseusage'] = 'standard';
			$formdata['extrarights'] = array();
			
			// this goes into the job_rights table
			$formdata['usage'] = $usage;

			$formdata['usagerights'] = array();
			
			$advanced = array();
			$advanced['model_to_bring'] = '';
			$advanced['transport_methods'] = '';
			$advanced['model_expenses'] = '';
			$advanced['model_meeting_point'] = '';
			$advanced['makeup_provided'] = '';
			$advanced['contact_number'] = '';
			$advanced['contact_name'] = '';
			$formdata['advanced'] = $advanced;
			
			$response = Jobs::ClientCreateJob($formdata);
			if (isset($args[1])) {
				// add this model as shortlisted to this new job
				Jobs::AddModelToJob($args[1], $response, 500);
				
			}
			if ($response !== false) {
				header('Location: /projects/edit/'.$response);
				die();
			} else {
				header('Location: /projects');
				die();
			}
		} else {
			header('Location: /projects');
			die();
		}
		break;
	case 'savenotes':
		if (IS_AJAX_REQUEST) {
			$json = Jobs::SaveClientNotesAboutModel($modelid, $jobid, $notes);
			Core::JSONWrite($json);
		}
		die();
	case 'confirmdetails':
		$job = Jobs::GetJobDetails($jobid);
		$model = $job['models'][$modelid];
		$fees = Jobs::GetJobValueByJobId($jobid);
		if ($acceptingrate == 1) {
			$model['agreed_rate'] = $model['model_desired_rate'];
		}
		if ($job['time_units'] == 0.5) {
			$calcunits = 1;
		} else {
			$calcunits = $job['time_units'];
		}
		if ($modelcount == $confirmedcount + 1) {
			// we need to adjust fees
			// as we're trying to display a future fee, not a current fee
			// so we add this model's fee to the total, and recalculate the
			// VAT and finda fee solely for display
			// model.agreed_rate is always set at this point
			$fees['subtotalfee'] += ($model['agreed_rate'] * $calcunits);
			$fees['subtotalfee'] = $fees['subtotalfee'] - $fees['findafee'];	// findafee is now wrong
			$fees['findafee'] = $fees['subtotalfee'] * .1;	// so recalculate
			$fees['subtotalfee'] += $fees['findafee'];	// and add back
			$fees['vat'] = $fees['subtotalfee'] * .2;
			$fees['totalfee'] = $fees['subtotalfee'] + $fees['vat'];
		}
		
		Core::Assign('job', $job);
		Core::Assign('model', $model);
		Core::Assign('fees', $fees);
		Core::Assign('modelcount', $modelcount);
		Core::Assign('confirmedcount', $confirmedcount);
		Core::Assign('calcunits', $calcunits);
		
		$template = 'jobs/confirmpopup.tpl';
		$html = Core::Fetch($template);
		Core::JSONWrite($html);
		die();

	case 'acceptrate':
		if (IS_AJAX_REQUEST) {
			$result = Jobs::ClientAcceptRate($jobid, $modelid);
			if ($result) {
				Notification::SendRateAcceptance($jobid, $modelid);
				SendGrid::SendClientAcceptRate($jobid, $modelid);
				Core::JSONWrite(true);
			} else {
				Core::JSONWrite(false);
			}
			die();
		}
		break;
	case 'updaterate':
		if (IS_AJAX_REQUEST) {
			$result = Jobs::ClientUpdateRate($jobid, $modelid, $rate);
			Core::JSONWrite($result);
			die();
		}
		break;
	case 'addinfo':
		if (IS_AJAX_REQUEST) {
			$response = Jobs::AddAdditionalInformation($jobid, $info);
			if ($response) {
				// send updates
				$job = Jobs::GetJobDetails($jobid);
				if ($job) {
					foreach($job['models'] as $model) {
						if (in_array($model['job_status'], array(JOB_ASSIGNMENT_STATUS_OFFERED, JOB_ASSIGNMENT_STATUS_ACCEPTED))) {		// offered, accepted only
							SendGrid::SendJobInfoAdded($model['id'], $job['id']);
							Notification::SendPushMessage($model['id'], 'Your upcoming job '.$job['name'].' has been updated with additional information \u2757');
						}
					}
				}
			}
			Core::JSONWrite($response);
		}
		die();
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
	case 'share':
		include_once('jobs/share_job.php');
		break;
	case 'shareauth':
		if (IS_AJAX_REQUEST) {
			if (isset($code)) {
				$check = Jobs::GetShareCode($shareuri);
				if ($check == $code) {
					Cookie::SetCookie('projectshare'.$shareuri, true);
					Core::JSONWrite(true);
				} else {
					Cookie::SetCookie('projectshare'.$shareuri, false);
					Core::JSONWrite(false);
				}
			}
		
		}
		die();
		break;
	case 'removecallsheet':
		if (IS_AJAX_REQUEST) {
			$response = Jobs::RemoveCallsheet($jobid);
			if ($response) {
				$html = true;
			} else {
				$html = false;
			}
			Core::JSONWrite($html);
			die();
		}
		break;
	// used in model views
	case 'accept':
		if (IS_AJAX_REQUEST) {
			$response = Jobs::ModelAcceptJob($jobid);
			if (!empty($address)) {
				Jobs::UpdateModelDeliveryAddress($jobid, $address);
			}
			if ($response) {
				$html = true;
			} else {
				$html = false;
			}
			Core::JSONWrite($html);
		}
		die();
		break;	
	case 'reject':
		if (IS_AJAX_REQUEST) {
			$response = Jobs::ModelRejectJob($jobid, $reasons);
			if ($response) {
				$html = true;
			} else {
				$html = false;
			}
			Core::JSONWrite($html);
		}
		die();
		break;
	case 'rejectoption':
		if (IS_AJAX_REQUEST) {
			$response = Jobs::ModelRejectOption($jobid);
			if ($response) {
				$html = true;
			} else {
				$html = false;
			}
			Core::JSONWrite($html);
		}
		die();
		break;
	case 'cancelacceptance':
		if (IS_AJAX_REQUEST) {
			$response = Jobs::ModelCancelAcceptance($jobid);
			if ($response) {
				$html = true;
			} else {
				$html = false;
			}
			Core::JSONWrite($html);
		}
		die();
		break;
	case 'more-info':
		if (IS_AJAX_REQUEST) {
			$job = Jobs::GetJobDetails($jobid);
			Core::Assign('job', $job);
			$template = 'jobs/jobdetails_modal.tpl';
			$html = Core::Fetch($template);
			Core::JSONWrite($html);
		}
		die();
		break;
	case 'modelinfo':
		if (IS_AJAX_REQUEST) {
			$job = Jobs::GetJobDetails($jobid);
			Core::Assign('job', $job);
			$template = 'jobs/modeldetails_modal.tpl';
			$html = Core::Fetch($template);
			Core::JSONWrite($html);
		}
		die();
		break;
	case 'negotiate':
		if (IS_AJAX_REQUEST) {
			$rate = str_replace('£', '', $rate);	// ffs, this should have been removed by the JS
			$response = Jobs::RateCounterOffer($jobid, $rate, $reasons);
			if ($response) {
				$html = true;
			} else {
				$html = false;
			}
			Core::JSONWrite($html);
		}
		die();
		break;
		
	case 'completejob':
		// only ever called from Model pages, by a model
		if (IS_AJAX_REQUEST) {
			$response = Jobs::ModelCompleteJob($jobid);
			if ($response) {
				$html = true;
			} else {
				$html = false;
			}
			Core::JSONWrite($html);
		}
		die();
		break;
		
	case 'completeform':
		// only ever called from Agent pages
		if (IS_AJAX_REQUEST) {
			$models = Jobs::ClientGetModelsForJob($jobid);
			foreach($models as $k => $v) {
				if ($v['job_status'] != JOB_ASSIGNMENT_STATUS_ACCEPTED && $v['job_status'] != JOB_ASSIGNMENT_STATUS_MODEL_COMPLETED) {	// exclude CLIENT_COMPLETED and COMPLETED
					unset($models[$k]);
				}
			}
			Core::Assign('models', $models);
			$job = Jobs::GetJobDetails($jobid);
			Core::Assign('job', $job);
			Core::Assign('jobid', $jobid);
			$html = Core::Fetch('jobs/completejobform.tpl');
			Core::JSONWrite($html);
		}
		die();
		break;
	case 'finaliseassignments':
		if (IS_AJAX_REQUEST) {
			foreach($value as $k => $v) {
				if (substr_count($v['name'], 'completed') > 0) {
					$modelid = str_replace('completed', '', $v['name']);
					$modelids[] = $modelid;
					$data[$modelid]['modelid'] = $modelid;
					$data[$modelid]['completed'] = $v['value'];
				}
				if (substr_count($v['name'], 'clientnotes') > 0) {
					$modelid = str_replace('clientnotes', '', $v['name']);
					$data[$modelid]['clientnotes'] = $v['value'];
				}
				if (substr_count($v['name'], 'rating') > 0) {
					$modelid = str_replace('rating', '', $v['name']);
					$data[$modelid]['rating'] = $v['value'];
				}
				if ($v['name'] == 'jobid') {
					$jobid = $v['value'];
				}
			}
			// we'll check this data independently
			$result = Jobs::FinaliseJobAssignments($jobid, $data);
			if ($result) {
				foreach($data as $model) {
					if ($model['completed'] == 1) {
						// we need to check if the model has also marked this as complete
						// before generating the invoice
						$invoiceid = Finance::CreateModelInvoiceForJob($model['modelid'], $jobid);	// this returns the actual invoiceid or false if assignment status is not 7
						if ($invoiceid) {
							Notification::SendJobComplete($jobid, $model['modelid']);
							// check if payment can be released
							$job = Jobs::GetJobDetails($jobid);
							if ($job['invoice_id'] != 0 && $job['invoice_paid'] != 0) {
								Finance::ReleasePaymentToModel($model['modelid'], $jobid, $invoiceid);
							}
						}
					}
				}
				
				$job = Jobs::GetJobDetails($jobid);
				if ($job['request_address'] == 1) {
					SendGrid::SendClientDeliveryAddresses($jobid);
				}
			}
			Core::JSONWrite($result);
		}
		die();
		break;
	case 'closejob':
		if (IS_AJAX_REQUEST) {
			Model::RemoveUnacceptedModelsFromJob($jobid);

			$response = ds('jobs_ClientCloseJob', array('jobid' => $jobid));
			if (isset($response['statusCode']) && $response['statusCode'] == 0) {
				
				if ($bookingtype != 'casting') {
					// this is where we generate the invoice, as the job is closed and accepted by all parties
					// and the status in the database has been updated
					$result = Finance::CreateClientInvoiceForJob(User::UserID(), $jobid);
				}

				// send emails to the Client and Models
				SendGrid::SendClientJobConfirmed($jobid);

				// return the invoice ID
				$invoice = Finance::RetrieveInvoiceDetailsByJobId($jobid, 'client');
				
				Core::JSONWrite($invoice['id']);
			} else {
				Core::JSONWrite(false);
			}
		}
		die();
		break;
	case 'canceljob':
		if (IS_AJAX_REQUEST) {
			$response = Jobs::ClientDeleteJob($jobid);
			Core::JSONWrite($response);
		}
		die();
		break;
	case 'wizardcreate':
	case 'create':
		include ('jobs/create_job.php');
		break;
	case 'createfromtemplate':
		$result = Jobs::ClientCreateJobFromTemplate($templateid, $projectname, $startdate);
		Core::JSONWrite($result);
		die();
		break;
	case 'edit':
	case 'update':
		include ('jobs/edit_job.php');
		break;
	case 'view':
		Session::SetVariable('workflowStep', '');
		include ('jobs/view_job.php');
		break;
	default:
		if (!IS_AJAX_REQUEST) {
			Session::SetVariable('workflowStep', '');
			// do we have any messages to show?
			$message = Session::GetVariable('message');
			$errormessage = Session::GetVariable('errormessage');
			Session::SetVariable('message', '');
			Session::SetVariable('errormessage', '');
			Core::Assign('message', $message);
			Core::Assign('errormessage', $errormessage);
		
			$template = 'jobs/list_jobs.tpl';
			
			$jobs = Jobs::ClientGetJobsList('all');
			

			$u = User::LoadUser(User::UserID());

			$allowInvoice = $u['profile']['allow_invoice'];
			$creditTerms = $u['profile']['credit_terms'];
			
			if ($jobs) {
				Core::Assign('jobscount', count($jobs));
				
				$pending = array();
				$closed = array();
				$unfinalised = array();
				$past = array();
				$complete = array();
				$waiting = array();
				$due = array();			// for Clients on post-pay
				$overdue = array();
				$deleted = array();
				$incomplete = array();
				
				foreach($jobs as $jobk => $job) {
					$jobs[$jobk]['completedcount'] = 0;
					$jobs[$jobk]['acceptedcount'] = 0;
					$jobs[$jobk]['rejectedcount'] = 0;
					$jobs[$jobk]['offeredcount'] = 0;
					$jobs[$jobk]['optionedcount'] = 0;
					$jobs[$jobk]['modelcompletedcount'] = 0;
					$jobs[$jobk]['confirmedcount'] = 0;
					$jobs[$jobk]['negotiatingcount'] = 0;
					
					foreach($job['models'] as $k => $v) {
						if ($v['job_status'] == JOB_ASSIGNMENT_STATUS_CLIENT_COMPLETED || $v['job_status'] == JOB_ASSIGNMENT_STATUS_COMPLETED) {
							$jobs[$jobk]['completedcount']++;
						}
						if ($v['job_status'] == JOB_ASSIGNMENT_STATUS_MODEL_COMPLETED || $v['job_status'] == JOB_ASSIGNMENT_STATUS_COMPLETED) {
							$jobs[$jobk]['modelcompletedcount']++;
						}
						
						if ($v['job_status'] == JOB_ASSIGNMENT_STATUS_MODEL_ACCEPTED_OPTION) {
							$jobs[$jobk]['acceptedcount']++;
						}
						if ($v['job_status'] == JOB_ASSIGNMENT_STATUS_MODEL_CANCELLED) {
							$jobs[$jobk]['rejectedcount']++;
						}
						if ($v['job_status'] == JOB_ASSIGNMENT_STATUS_OFFERED) {
							$jobs[$jobk]['offeredcount']++;
							if (($v['model_desired_rate'] != $v['client_offered_rate']) && $v['agreed_rate'] == 0 && $v['model_desired_rate'] != 0) {
								$jobs[$jobk]['negotiatingcount']++;
							}
						}
						if ($v['job_status'] == JOB_ASSIGNMENT_STATUS_CLIENT_OPTIONED) {
							$jobs[$jobk]['optionedcount']++;
						}
						if ($v['job_status'] == JOB_ASSIGNMENT_STATUS_ACCEPTED || $v['job_status'] == JOB_ASSIGNMENT_STATUS_CLIENT_COMPLETED || $v['job_status'] == JOB_ASSIGNMENT_STATUS_MODEL_COMPLETED || $v['job_status'] == JOB_ASSIGNMENT_STATUS_COMPLETED) {	// model confirmed or completed
							$jobs[$jobk]['confirmedcount']++;
						}
					}
					
					$jobs[$jobk]['optionedmodelcount'] = count($job['models']);
					$jobs[$jobk]['totalselectedcount'] = count($job['models']);
					
					/*
					 * now we split these into their various arrays based on the current ruleset
					 */
					
					// need to calc totalfee now...
					$feetotal = 0;
					foreach($jobs[$jobk]['models'] as $feek => $feev) {
						if ($feev['agreed_rate'] != 0) {
							// @TODO rewrite, as this reloads the job data 
							$fees = Jobs::GetJobValue($jobs[$jobk]);
							$feetotal = $fees['totalfee'];
						}
					}
					$jobs[$jobk]['feetotal'] = $feetotal;
					
					// we need 'today'
					$todaytimestamp = strtotime('today') + (60*60*24);
					
					// pending: 
					if ($job['startdate'] >= $todaytimestamp && $job['job_status'] == JOB_ASSIGNMENT_STATUS_PENDING) {
						if ($jobs[$jobk]['modelcount'] == $jobs[$jobk]['acceptedcount'] && $jobs[$jobk]['job_status'] == JOB_ASSIGNMENT_STATUS_PENDING && $jobs[$jobk]['optionedmodelcount'] != 0) {
							$jobs[$jobk]['jobcard_type'] = 'confirmable';
							
						} else {
							$jobs[$jobk]['jobcard_type'] = 'pending';
						}
						
						$pending[] = $jobs[$jobk];
						unset($jobs[$jobk]);
					} else 
					// with overdue invoices:
					if ($job['startdate'] < $todaytimestamp && ($job['job_status'] == JOB_ASSIGNMENT_STATUS_MODEL_ACCEPTED_OPTION || $job['job_status'] == JOB_ASSIGNMENT_STATUS_OFFERED) && $job['invoice_paid'] == 0) {

						if ($allowInvoice) {
							if (($job['startdate'] + (60 * 60 * 24 * $creditTerms)) < $todaytimestamp) {
								$jobs[$jobk]['jobcard_type'] = 'overdue';
								$overdue[] = $jobs[$jobk];
								unset($jobs[$jobk]);
							} else {
								$jobs[$jobk]['jobcard_type'] = 'due';
								$due[] = $jobs[$jobk];
								unset($jobs[$jobk]);
							}
						} else {
							$jobs[$jobk]['jobcard_type'] = 'overdue';
							$overdue[] = $jobs[$jobk];
							unset($jobs[$jobk]);
						}
					} else 

					if ($job['startdate'] > $todaytimestamp && $job['job_status'] == 1) {
						$jobs[$jobk]['jobcard_type'] = 'confirmed';
						
						$closed[] = $jobs[$jobk];
						unset($jobs[$jobk]);
					} else
							
					// unfinalised: 
					if ($job['startdate'] < $todaytimestamp && $job['job_status'] == JOB_ASSIGNMENT_STATUS_OFFERED && $jobs[$jobk]['optionedmodelcount'] != $jobs[$jobk]['completedcount']) {
						$jobs[$jobk]['jobcard_type'] = 'unfinalised';
						$unfinalised[] = $jobs[$jobk];

						unset($jobs[$jobk]);
					} else 
					
					// past unclosed: 
					if ($job['startdate'] < $todaytimestamp && $job['job_status'] == JOB_ASSIGNMENT_STATUS_PENDING && $job['invoice_paid'] == 0) {
						$jobs[$jobk]['jobcard_type'] = 'rate models';
						$incomplete[] = $jobs[$jobk];
						unset($jobs[$jobk]);
					} else 
					
					// completed: 
					if ($job['startdate'] <= $todaytimestamp && $job['job_status'] == JOB_ASSIGNMENT_STATUS_OFFERED && $job['invoice_paid'] == 1) {
						$jobs[$jobk]['jobcard_type'] = 'complete';
						$complete[] = $jobs[$jobk];
						unset($jobs[$jobk]);
					} else 
					
					
					// waiting for models to complete: 
					if ($job['startdate'] <= $todaytimestamp && $job['job_status'] == JOB_ASSIGNMENT_STATUS_OFFERED && $jobs[$jobk]['acceptedcount'] != $jobs[$jobk]['modelcompletedcount'] && $job['invoice_paid'] == 1) {
						$jobs[$jobk]['jobcard_type'] = 'waiting';
						$waiting[] = $jobs[$jobk];
						unset($jobs[$jobk]);
					} else

					if ($job['startdate'] <= $todaytimestamp && $job['job_status'] == JOB_ASSIGNMENT_STATUS_PENDING && $jobs[$jobk]['modelcompletedcount'] == $jobs[$jobk]['totalselectedcount'] && $job['invoice_paid'] == 1) {
						$jobs[$jobk]['jobcard_type'] = 'unfinalised';
						$unfinalised[] = $jobs[$jobk];
						unset($jobs[$jobk]);
					} else
						
					// deleted: 
					if ($job['job_status'] == 2) {
						$jobs[$jobk]['jobcard_type'] = 'deleted';
						$deleted[] = $jobs[$jobk];
						unset($jobs[$jobk]);
					} else {
						// anything uncategorised, in-test or with unexpected data sets
						if (DEBUG) {
							$jobs[$jobk]['jobcard_type'] = 'DEBUG';
							$past[] = $jobs[$jobk];
							unset($jobs[$jobk]);
							
						}
					}
					
				}
				$jobs['upcoming'] = array_merge($pending, $waiting, $due, $closed);
				$jobs['past'] = array_merge($unfinalised, $incomplete, $due, $overdue);
				$jobs['history'] = array_merge($complete, $past, $deleted);
				
				// welcome for our new affiliates
				if ($u['referral_code'] != '' && count($jobs) == 0) {
					Core::Assign('show_client_affiliate_welcome', 1);
				} else {
					Core::Assign('show_client_affiliate_welcome', 0);
				}

				Core::Assign('jobs', $jobs);
				
				Core::AddCSS('jobcard.css');
			} else {
				// show no jobs template
				$template = 'jobs/nojobs.tpl';
			}
			$page_title = 'List Projects';
			
			Core::AddJavascript('jobs/joblist.js');
			Core::AddCSS('joblist.css');
			
			// notifications
			$notificationpopup = Session::GetVariable('notificationpopup');
			Session::SetVariable('notificationpopup', '');
			if (!empty($notificationpopup)) {
				Core::Assign('notificationpopup', $notificationpopup);
			}
			
			
			
			// companies/mother agencies extension
			// filter into the same buckets as jobs, but remove any for the logged-in client
			
			if (User::MotherAgency() != 0) {
				
				Core::Assign('companyprojects', $companyprojects);
			} else {
				$companyDetails = User::GetUserCompanyDetails();
				if ($companyDetails['id'] != 0) {
					Core::Assign('companyprojects', Companies::GetCompanyProjectsForDisplay($companyDetails['id']));
					$jobtemplates = Companies::LoadCompanyTemplates();
					Core::Assign('jobtemplates', $jobtemplates);
				}
			}
			
			Core::Assign('user', $u);
			Core::AddCSS('jobs/companyprojects.css');
			
			Core::AddJavascript('vendor/zebra_datepicker.min.js');
			Core::AddCSS('vendor/zebra/zebra_datepicker.css');
			
		} else {
			echo 'forbidden';
			header('HTTP/1.0 403 Forbidden', 403);
			die();
		}
		break;
}

