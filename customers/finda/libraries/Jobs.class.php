<?php
/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
namespace Croissant;

/**
 *
 */
class Jobs extends Core {

	static $core;
	
	// job_assignments table
	const OFFERED = 1;
	const ACCEPTED = 2;
	const MODEL_CANCELLED = 3;
	const CLIENT_CANCELLED = 4;
	const MODEL_COMPLETED = 5;
	const CLIENT_COMPLETED = 6;
	const COMPLETED = 7;
	const CLIENT_SELECTED = 9;
	const CLIENT_OPTIONED = 10;	// hide from model, not an offer
	const SHARE_SELECTED = 11;
	const MODEL_REJECTED_OPTION = 12;
	const MODEL_ACCEPTED_OPTION = 14;
	const SHARE_OPTIONED = 15;	// this is the new shareselected
	const ACCEPTED_CONFIRMED = 16;
	const CLIENT_REMOVED = 20;	// form job assignment

	/**
	 *
	 */
	public static function Initialise() {
		if (!isset(self::$core)) {
			self::$core = parent::Initialise();
		}

		return self::$core;
	}

	public static function ClientCreateJob(Array $jobdetails) {
		if (User::UserType() != TYPE_MODEL) {
			$response = ds('jobs_ClientCreateJob', array('jobdetails' => $jobdetails));
			if (isset($response['statusCode']) && $response['statusCode'] == 0) {
				if ($jobdetails['projectbookingtype'] != 'direct') {
					SendGrid::SendClientCreatedProjectConfirmation($response['result']);
				}
				if (!DEBUG) {
					SendGrid::SendInternal('new project', $response['result']);
				}
				return $response['result'];	// jobid/insert id
			} else {
				CroissantError::RecordError('Job creation error', json_encode($response));
				return false;
			}
		}
		return false;
	}
	
	public static function ClientCreateJobFromTemplate(Int $templateid, String $projectname = "Unnamed", $projectdate = "") {
		
		$result = array('status' => 0);
		if (User::UserType() != TYPE_MODEL) {
			
			$startdate = time() + (60*60*24);
			if ($projectdate != "") {
				$startdate = strtotime($projectdate);
			}

			$response = ds('companies_LoadJobTemplate', array('templateid' => $templateid));
			
			if (isset($response['statusCode']) && $response['statusCode'] == 0) {
				
				$template = $response['result'];
			
				$formdata = array();
				$formdata['name'] = $projectname;
				$formdata['description'] = $template['description'];
				$formdata['location'] = $template['location'];
				$formdata['project_tid'] = $template['project_tid'];
				$formdata['offered_rate'] = $template['offered_rate']; // must be a number, comes with a prefix
				$formdata['altrate'] = $template['altrate'];
				// if altrate (product) is selected, set offered_rate to 0
				if (!empty($formdata['altrate'])) {
					$formdata['offered_rate'] = 0;
				}
				$formdata['altrate_unitstype'] = $template['units_type'];	// this is an enum, requires some input
				
				$formdata['time_units'] = $template['time_units'];
				$formdata['units_type'] = $template['units_type'];
				$formdata['modelcount'] = 0;
				$formdata['startdate'] = $startdate;
				$formdata['starttime'] = $startdate;
				
				$formdata['sharepass'] = substr(hash('sha512',rand()), 0, 6);	// 6 character simple password
				$formdata['shareuri'] = substr(str_shuffle(str_repeat("0123456789abcdefghijklmnopqrstuvwxyz", 12)), 0, 12);
				
				$formdata['request_address'] = 0;
				
				$usage = array();
				$usage['uk'] = 1;
				$usage['europe'] = 0;
				$usage['international'] = 0;
				
				// the basic usage types
				$formdata['baseusage'] = '';
				$formdata['extrarights'] = '';
				
				// this goes into the job_rights table
				$formdata['usage'] = $usage;
				
				// the individual taxonomy rights
				if ($formdata['project_tid'] == 12) {
					$usagerights[] = 63;
				}
				$formdata['usagerights'] = $usagerights;
				
				$advanced = array();
				$formdata['advanced'] = $advanced;
				
				$response = ds('jobs_ClientCreateJob', array('jobdetails' => $formdata));
				if (isset($response['statusCode']) && $response['statusCode'] == 0) {
					if (!DEBUG) {
						SendGrid::SendClientCreatedProjectConfirmation($response['result']);
						SendGrid::SendInternal('new project', $response['result']);
					}
					$result['status'] = 1;
					$result['id'] = $response['result'];
				} else {
					CroissantError::RecordError('Job creation error', json_encode($response));
				}
			}
		}
		return $result;
	}

	public static function ClientUpdateJob(Array $jobdetails) {
		if (User::UserType() != TYPE_MODEL) {
			$job = self::GetJobDetails($jobdetails['id']);
			
			
			if (!Companies::CanAccessProject($job['id'])) {
				return false;
			}
			
			// we have both job and job update now, check if we want to send updates
			$updateModels = false;
			$matchFields = array('project_tid', 'location', 'startdate', 'starttime', 'duration', 'description', 'usagerights', 'units_type');
			
			foreach($matchFields as $k) {
				if ($job[$k] != $jobdetails[$k]) {
					$updateModels = true;
				}
			}
			
			$response = ds('jobs_ClientUpdateJob', array('jobdetails' => $jobdetails));
			if (isset($response['statusCode']) && $response['statusCode'] == 0) {

				if ($updateModels) {
					// send updates to all models
					foreach($job['models'] as $model) {
						if (in_array($model['job_status'], array(1, 2))) {		// offered, accepted only
							SendGrid::SendJobChanged($model['id'], $job['id']);
							
							$pushMessage = '';
							if (User::CompanyName() != '') {
								$pushMessage = User::CompanyName().' has made an update to the job '.$job['name'].'. Check out the new details in the App.';
							} else {
								$pushMessage = 'There has been an update to the job '.$job['name'].'. Check out the new details in the App.';
							}
							Notification::SendPushMessage($model['id'], $pushMessage);	// \u1f50D
							
// 							Notification::SendPushMessage($model['id'], 'Your '.$job['name'].' job has been updated \uD83D\uDD0D');	// \u1f50D
						}
					}
				}
				return $response['result'];
			}
		}
		return false;
	}

	public static function ClientGetModelForJob(Int $jobid, Int $modelid) {
		if (User::UserType() != TYPE_MODEL) {
			$job = self::GetJobDetails($jobid);
			
			if ($job['client_uid'] != User::UserID()) {
				return false;
			}
			
			$response = ds('jobs_ClientGetModelForJob', array('jobid' => $jobid, 'modelid' => $modelid));
			
			if (isset($response['statusCode']) && $response['statusCode'] == 0) {
				return $response['result'];
			}
		}
		return false;
	}

	public static function ClientUpdateModelForJob(Int $jobid, Int $modelid, Int $status): Bool {
		if (User::UserType() != TYPE_MODEl) {
			$job = self::GetJobDetails($jobid);
			
			if ($job['client_uid'] != User::UserID()) {
				// is this a company job?
				$client = User::LoadUser($job['client_uid']);
				if ($client['companyid'] != User::CompanyId()) {
					return false;
				}
			}

			// we load the model details before the change so we have a snapshot of the old state
			$model = self::ClientGetModelForJob($jobid, $modelid);
			
			if (!$model) {
				$job = self::GetJobDetails($jobid);
				self::AddModelToJob($modelid, $jobid, $job['offered_rate']);
				$model = User::Loaduser($modelid);
				$model['job_status'] = 0;
			} else {
				// ClientGetModelForJob returns an array
				if (is_array($model)) {
					$model = array_shift($model);
				}
			}
			
			$response = ds('jobs_ClientUpdateModelForJob', array('jobid' => $jobid, 'modelid' => $modelid, 'status' => $status));
			
			self::SendStatusChangeEmail($model, $jobid, $status);
			
			return true;
		} else {
			return false;
		}
	}

	public static function ExternalUpdateModelForJob(Int $jobid, Int $modelid, Int $status) {
		$response = ds('jobs_ClientGetModelForJob', array('jobid' => $jobid, 'modelid' => $modelid));
		
		if (isset($response['statusCode']) && $response['statusCode'] == 0) {
			$model = $response['result'];
			$response = ds('jobs_ClientUpdateModelForJob', array('jobid' => $jobid, 'modelid' => $modelid, 'status' => $status));
			if (isset($response['statusCode']) && $response['statusCode'] == 0) {
				return $response['result'];
			}
		}
		return false;
	}
	
	/**
	 * SendStatusChangeEmail
	 * Sends an email on certain defined status changes
	 *
	 * @param array $model 		An array containing model information. This is a snapshot of the model record
	 * 							before update so that we can access the old status value
	 * @param int 	$jobid 		a unique ID representing the ID of a created project
	 * @param int	$newstatus	The new status that a model is changing to in relation to the jobid
	 *
	 * see https://docs.google.com/document/d/1XGEufcLkumMVO5_EzJI2QhIn-6s1i30bRMIkXdIhhp8/edit
	 *
	 */
	public static function SendStatusChangeEmail(Array $model, Int $jobid, Int $newstatus) {
		$oldstatus = $model['job_status'];
		$modelid = $model['id'];

		// for these states, we don't care about the previous state
		// Notifications are sent elsewhere in the process
		if (in_array($newstatus, array(3,4,5,6,7))) {
			switch($newstatus) {
				case 3:
					// send model cancelled email
					SendGrid::SendModelCancelledEmail($modelid, $jobid);
					Model::RemoveJobFromModelCalendar($jobid, $modelid);
					break;
				case 4:
					// send client cancelled email
					SendGrid::SendBookingCancelledEmail($modelid, $jobid);
					Notification::SendJobCancelModel($jobid, $modelid);
					Model::RemoveJobFromModelCalendar($jobid, $modelid);
					break;
				case 5:
					// no email
					break;
				case 6:
					// no email
					break;
				case 7:
					// no email
					break;
			}
		} else {

			// for these states, we care about the previous state
			switch($oldstatus) {
				case 0:
					switch($newstatus) {
						case 10:	// was 1
							break;
						case 9:
							break;
					}
					break;
				case 14:
					switch($newstatus) {
						case 0:
							// send offer cancellation email
							SendGrid::SendBookingCancelledEmail($modelid, $jobid);
							Notification::SendJobCancelModel($jobid, $modelid);
							Model::RemoveJobFromModelCalendar($jobid, $modelid);
							break;
						case 2:
							// send job confirmation
							SendGrid::SendModelJobConfirmed($jobid, $modelid);
							Notification::SendModelJobConfirmed($jobid, $modelid);
							Model::AddJobToModelCalendar($jobid, $modelid, 'busy');
							break;
					}
					break;
				case 2:
					switch($newstatus) {
						case 0:
							// send offer cancellation email
							SendGrid::SendBookingCancelledEmail($modelid, $jobid);
							Notification::SendJobCancelModel($jobid, $modelid);
							Model::RemoveJobFromModelCalendar($jobid, $modelid);
							break;
					}
					break;
				case 10:
					switch($newstatus) {
						case 0:
							Notification::SendPushMessage($modelid, 'Better luck next time! Your job option has been released \u1F611');
							break;
						case 1:
							// send offer email
							$job = self::GetJobDetails($jobid);
							Notification::SendJobOffer($jobid, $modelid, $job['offered_rate']);	// also sends email
							break;
						case 12:
							SendGrid::SendModelRejectOption($modelid);
							break;
						case 15:
							// none
							break;
					}
					break;
				default:
					break;
			}
		}
		return;
	}

	public static function GetNewJobsCount() {
		$response = ds('jobs_ModelGetNewJobsCount');
		return genericResponse($response);
	}

	public static function ClientGetAllJobs($modelid = 0) {
		$response = ds('jobs_ClientGetJobs', array('jobtype' => 'all', 'modelid' => $modelid));
		return genericResponse($response);
	}

	public static function ClientAcceptRate($jobid, $modelid) {
		$response = ds('jobs_ClientAcceptRate', array('jobid' => $jobid, 'modelid' => $modelid));
		return genericResponse($response);
	}

	public static function ClientGetJobsList($type) {
		$response = ds('jobs_ClientGetJobsList', array('type' => $type));
		return genericResponse($response);
	}

	public static function ClientGetModelsForJob($jobid) {
		$response = ds('jobs_ClientGetModelsForJob', array('jobid' => $jobid));
		return genericResponse($response);
	}

	public static function ModelGetAllJobs() {
		$response = ds('jobs_ModelGetJobs', array('jobtype' => 'all'));
		return genericResponse($response);
	}

	public static function ModelGetJobs($jobtype = 'all') {
		$response = ds('jobs_ModelGetJobs', array('jobtype' => $jobtype));
		return genericResponse($response);
	}
	
	public static function GetJobsForModel($modelid) {
		$response = ds('jobs_ModelGetJobs', array('jobtype' => 'all', 'modelid' => $modelid));
		return genericResponse($response);
	}

	public static function ModelGetJobStatus($jobid) {
		$job = self::GetJobDetails($jobid);
		$job_status = 0;
		if (!empty($job['models'])) {
			foreach($job['models'] as $k => $v) {
				if ($k == User::UserID()) {
					$job_status = $v['job_status'];
				}
			}
		}
		return $job_status;
	}

	public static function ModelAcceptJob($jobid) {
		$response = ds('jobs_ModelAcceptJob', array('jobid' => $jobid));
		if (isset($response['statusCode']) && $response['statusCode'] == 0) {
			Model::AddJobToCalendar($jobid);
			SendGrid::SendModelAccept($jobid);
			$response = Notification::SendJobAcceptance($jobid);
			
			$job = self::GetJobDetails($jobid);
			if ($job['bookingtype'] == 'casting') {
				// make it confirmed immediately
				$response = ds('jobs_ClientUpdateModelForJob', array('jobid' => $jobid, 'modelid' => User::UserID(), 'status' => 2));
			}
			
			return $response;
		}
		return false;
	}
	
	public static function ModelRejectJob($jobid, $reasons = '') {
		$response = ds('jobs_ModelRejectJob', array('jobid' => $jobid));
		if (isset($response['statusCode']) && $response['statusCode'] == 0) {
			Model::RemoveJobFromCalendar($jobid);
			$response = Notification::SendJobRejection($jobid, $reasons);
			SendGrid::SendModelReject($jobid, $reasons);
			return $response;
		}
		return false;
	}

	public static function ModelRejectOption($jobid) {
		$response = ds('jobs_ModelRejectOption', array('jobid' => $jobid));
		if (isset($response['statusCode']) && $response['statusCode'] == 0) {
			$response = Notification::SendOptionRejection($jobid);
			SendGrid::SendModelRejectOption($jobid);
			return $response;
		}
		return false;
	}

	public static function ModelCancelAcceptance($jobid) {
		$response = ds('jobs_ModelCancelAcceptance', array('jobid' => $jobid));
		if (isset($response['statusCode']) && $response['statusCode'] == 0) {
			Notification::SendJobCancelAcceptance($jobid);
			SendGrid::SendModelCancelledEmail(User::userID(), $jobid);
			self::ReopenJobIfNeeded($jobid);
			return $response['result'];
		}
		return false;
	}

	public static function ModelCompleteJob($jobid) {
		$response = ds('jobs_ModelCompleteJob', array('jobid' => $jobid));
		if (isset($response['statusCode']) && $response['statusCode'] == 0) {

			$status = Model::GetJobAssignmentStatus($jobid);
			$jobdetails = Jobs::GetJobDetails($jobid);

			if ($status == JOB_ASSIGNMENT_STATUS_COMPLETED) {	// both model and client have completed
				$invoiceid = Finance::CreateModelInvoiceForJob(User::UserID(), $jobid);	// this returns the actual invoiceid or false if assignment status is not 7

				if ($invoiceid) {
					Notification::SendJobComplete($jobid, User::UserID());
					if ($jobdetails['invoice_id'] != 0 && $jobdetails['invoice_paid'] != 0) {	// and the Client invoice has been created
						Finance::ReleasePaymentToModel(User::UserID(), $jobid, $invoiceid);
					}
				}

			}
			return $response['result'];
		}
		return false;

	}
	
	/**
	 * 
	 * reasons is a string of terms, used for messaging setup. does not need to be stored.
	 * 
	 * @param int $jobid
	 * @param int $rate
	 * @param string $reasons
	 * @return boolean
	 */
	
	public static function RateCounterOffer($jobid, $rate, $reasons = '') {
		$response = ds('jobs_ModelRateCounterOffer', array('jobid' => $jobid, 'rate' => $rate));
		if (isset($response['statusCode']) && $response['statusCode'] == 0) {
			Notification::SendRateCounterOffer($jobid, $rate, $reasons);
			SendGrid::SendModelNegotiateRate($jobid, User::UserID(), $reasons);
			return $response['result'];
		}
		return false;
	}

	public static function GetJobDetails($jobid) {
		$response = ds('jobs_GetJobDetails', array('jobid' => $jobid));
		return genericResponse($response);
	}

	public static function ClientDeleteJob($jobid, $notify = true) {
		if (User::UserType() != TYPE_MODEL) {
			$job = self::GetJobDetails($jobid);
			if ($job['client_uid'] != User::UserId()) {
				return false;
			}
			$response = ds('jobs_ClientDeleteJob', array('jobid' => $jobid));
			if (isset($response['statusCode']) && $response['statusCode'] == 0) {
				if ($notify) {
					Notification::SendJobCancellation($jobid);
				}
				Model::RemoveJobFromCalendar($jobid);
				return $response['result'];
			}
		}
		return false;
	}

	public static function GetJobByShareURI($shareuri) {
		$response = ds('jobs_GetJobByShareURI', array('shareuri' => $shareuri));
		return genericResponse($response);;
	}

	/**
	 * This is the OPTION process, not the OFFER process
	 *
	 * @param int $modelid
	 * @param int $jobid
	 * @param int $offeredrate
	 * @return boolean
	 */
	public static function AddModelToJob($modelid, $jobid, $offeredrate) {
		if (empty($offeredrate)) {
			$offeredrate = 0;
		}
		
		// a check, as we're adding clients to jobs for some reason
		$model = User::LoadUser($modelid);
		if ($model['usertype'] == TYPE_MODEL) {
			$response = ds('jobs_AddModelToJob', array('modelid' => $modelid, 'jobid' => $jobid, 'offeredrate' => $offeredrate));
			if (isset($response['statusCode']) && $response['statusCode'] == 0) {
				return $response['result'];
			}
		}
		return false;
	}
	
	public static function RemoveModelFromJob($modelid, $jobid) {

		// we only want to send these notifications if the model has been offered the job, not just selected
		// but we need the status before the model is removed
		$status = Model::GetJobAssignmentStatus($jobid, $modelid);

		$response = ds('jobs_RemoveModelFromJob', array('modelid' => $modelid, 'jobid' => $jobid));
		if (isset($response['statusCode']) && $response['statusCode'] == 0) {
			if (
				$status == JOB_ASSIGNMENT_STATUS_ACCEPTED || 
				$status == JOB_ASSIGNMENT_STATUS_MODEL_ACCEPTED_OPTION ||
				$status == JOB_ASSIGNMENT_STATUS_ACCEPTED_CONFIRMED
				) {
					Notification::SendJobCancelModel($jobid, $modelid);
					SendGrid::SendBookingCancelledEmail($modelid, $jobid);
			}
			// always try and remove the item from the calendar
			Model::RemoveJobFromModelCalendar($jobid, $modelid);
			return $response['result'];
		}
		return genericResponse($response);
	}

	public static function GetModelForJob($modelid, $jobid) {
		$response = dsro('jobs_ClientGetModelForJob', array('jobid' => $jobid, 'modelid' => $modelid));
		return genericResponse($response);
	}
	/*
	 * New function, varies the state (optioned, offered, cancelled) for a model on a per-job basis
	 */
	public static function ChangeModelStatus($jobid, $modelid, $newstatus) {
		$job = self::GetJobDetails($jobid);
		$modelassignment = self::GetModelForJob($modelid, $jobid);
		$oldstatus = $modelassignment['job_status'];

		// model moved from optioned to offered
		if ($oldstatus == JOB_ASSIGNMENT_STATUS_CLIENT_OPTIONED && $newstatus == JOB_ASSIGNMENT_STATUS_OFFERED) {
			Model::NotifyNewJob($modelid, $jobid, $job['offered_rate']);
			Model::AddJobToModelCalendar($jobid, $modelid, 'tentative');
		}
		if ($newstatus = JOB_ASSIGNMENT_STATUS_CLIENT_OPTIONED) {
			// client removed model
		}
	}

	public static function ClientUpdateRate($jobid, $modelid, $rate) {
		$response = ds('jobs_ClientUpdateRateForModel', array('jobid' => $jobid, 'modelid' => $modelid, 'rate' => $rate));
		if (isset($response['statusCode']) && $response['statusCode'] == 0) {
			Notification::SendClientUpdateRate($jobid, $modelid, $rate);
			return $response['result'];
		}
		return false;
	}

	public static function FinaliseJobAssignments($jobid, $data) {
		$response = ds('jobs_FinaliseJobAssignments', array('jobid' => $jobid, 'data' => $data));
		if (isset($response['statusCode']) && $response['statusCode'] == 0) {
			return $response['result'];
		}
		return false;
	}

	public static function RemoveCallsheet($jobid) {
		$response = ds('jobs_RemoveCallsheet', array('jobid' => $jobid));
		if (isset($response['statusCode']) && $response['statusCode'] == 0) {
			return $response['result'];
		}
		return false;
	}


	/* ****************************************************************************************************************
	 * Finance related functions
	 * ****************************************************************************************************************/
	public static function GetJobValueByInvoiceId($invoiceid) {
		$invoice = Finance::RetrieveInvoiceDetails($invoiceid);
		return self::GetJobValueByJobId($invoice['jobid']);
	}

	public static function GetJobValueByJobId($jobid) {
		$jobdetails = Jobs::GetJobDetails($jobid);
		return self::GetJobValue($jobdetails);
	}
	
	// includes new field for individual model mother agency commission deduction
	public static function GetJobValue($jobdetails) {

		// work out some stuff
		$modelcharge = 0;
		$modelsubtotal = 0;
		$totalfee = 0;
		$modelfees = array();
		$agencycommissionsubtotal = 0;
		$agencycommissions = array();
		foreach ($jobdetails['models'] as $k => $model) {
			// we only want this if the model has accepted or closed
			if (in_array($model['job_status'], array(JOB_ASSIGNMENT_STATUS_ACCEPTED, JOB_ASSIGNMENT_STATUS_MODEL_COMPLETED, JOB_ASSIGNMENT_STATUS_CLIENT_COMPLETED, JOB_ASSIGNMENT_STATUS_COMPLETED))) {

				// NOTES
				// findafee_discount is the discount granted to CLIENTS for their fee
				// jobfee_discount is the discount granted to MODELS for their fee deducation
				if ($jobdetails['time_units'] == 0.5) {
					$calc_timeunits = 1;
				} else {
					$calc_timeunits = $jobdetails['time_units'];
					
				}
				
				$modelcost = ($model['agreed_rate'] * $calc_timeunits);
				$modelsubtotal = $modelsubtotal + $modelcost;
				$modelfee = $modelcost * (FINDA_MODEL_MARKUP/100);
				
				// adjust if the model is part of a Mother Agency
				$agencycommission = 0;

				if ($model['mother_agency'] != 0) {
					$agencycommission = $modelcost * ($model['motheragency_commission']/100); 	// defaults to 0
					$agencycommissionsubtotal += $agencycommission;
					$agencycommissions[$model['mother_agency']] += $agencycommission;
				}

				if ($jobdetails['jobfee_discount'] != 0) {
					$modelfee = $modelfee * (1-($jobdetails['jobfee_discount']/100));
				}

// 				$totalfee = $modelfee + $findafee;

				$vatnumber = User::GetVATNumber($model['id']);
				if (!empty($vatnumber)) {
					$vat = $totalfee * ($jobdetails['vat_value']/100);	// per-job VAT
				} else {
					$vat = 0;
				}
				$jobdetails['models'][$k]['vatnumber'] = $vatnumber;

				// make sure to add the updated fee
				$modelcost = $modelcost - $modelfee + $vat;

				$modelfees[$k]['model'] = $model;
				$modelfees[$k]['modelcost'] = ($model['agreed_rate'] * $calc_timeunits);
				$modelfees[$k]['modelfee'] = $modelfee;
				$modelfees[$k]['agencycommission'] = $agencycommission;
				$modelfees[$k]['mother_agency'] = $model['mother_agency'];
				$modelfees[$k]['vat'] = $vat;
				$modelfees[$k]['total'] = $modelcost;
				$modelfees[$k]['status'] = $model['job_status'];
				
				// total model cost to the client
				$modelcharge = $modelcharge + ($model['agreed_rate'] * $calc_timeunits);

			}
		}

		$findafee = $modelcharge * (FINDA_MODEL_MARKUP/100);

		if ($jobdetails['findafee_discount'] != 0) {
			$findafee = $findafee * (1-($jobdetails['findafee_discount']/100));
		}

		$subtotalfee = $modelcharge + $findafee;

		$vat = $subtotalfee * ($jobdetails['vat_value']/100);	// per-job VAT

		$totalfee = $subtotalfee + $vat;

		$return = array();
		$return['modelfees'] = $modelfees;
		$return['modelsubtotal'] = $modelsubtotal;
		$return['commission'] = $agencycommissionsubtotal;
		$return['agencycommissions'] = $agencycommissions;
		$return['findafee'] = $findafee;
		$return['subtotalfee'] = $subtotalfee;
		$return['vat'] = $vat;
		$return['totalfee'] = $totalfee;
		$return['vat_rate'] = $jobdetails['vat_value'];
		$return['findafee_discount'] = $jobdetails['findafee_discount'];
		$return['modelfee_discount'] = $jobdetails['modelfee_discount'];

		return $return;

	}

	public static function UpdateJobAsPaid($jobid) {
		$response = ds('jobs_UpdateJobAsPaid', array('jobid' => $jobid));
		return genericResponse($response);
	}

	public static function UpdateUsageRights($jobid, $data) {
		$response = ds('jobs_UpdateUsageRights', array('jobid' => $jobid, 'data' => $data));
		return genericResponse($response);
	}

	public static function GetShareCode($shareuri) {
		$response = ds('jobs_GetShareCode', array('shareuri' => $shareuri));
		return genericResponse($response);
	}

	// take a $job record, returns a defined JobType (ref: /projects.php in web)
	public static function GetDefinedJobTypeForClient($job) {

		$jobcard_type = '';
		// pending:
		if ($job['startdate'] > time() && $job['job_status'] == 0) {
			if ($job['optionedmodelcount'] == $job['acceptedcount'] && $job['job_status'] == 0 && $job['optionedmodelcount'] != 0) {
				$jobcard_type = 'confirmable';
			} else {
				$jobcard_type = 'pending';
			}
		}

		if ($job['startdate'] > time() && $job['job_status'] == 1) {
			$jobcard_type = 'confirmed';
		}

		if ($job['startdate'] < time() && $job['job_status'] == 1) {
			$jobcard_type = 'closed';
		}


		// unfinalised:
		if ($job['startdate'] < time() && $job['job_status'] == 1 && $job['optionedmodelcount'] != $job['completedcount']) {
			$jobcard_type = 'unfinalised';
		}

		// past unclosed:
		if ($job['startdate'] < time() && $job['job_status'] == 0 && $job['invoice_paid'] == 0) {
			$jobcard_type = 'past';
		}

		// with overdue invoices:
		if ($job['startdate'] < time() && $job['job_status'] == 2 && $job['invoice_paid'] == 0 && $job['invoice_id'] != 0) {
			$jobcard_type = 'overdue';
		}

		// waiting for models to complete:
		if ($job['startdate'] < time() && $job['job_status'] == 1 && $job['acceptedcount'] != $job['modelcompletedcount'] && $job['invoice_paid'] == 1) {
			$jobcard_type = 'waiting';
		}

		// completed:
		if ($job['startdate'] < time() && $job['job_status'] == 1 && $job['invoice_paid'] == 1) {
			$jobcard_type = 'complete';
		}

		// deleted:
		if ($job['job_status'] == 2) {
			$jobcard_type = 'deleted';
		}

		return $jobcard_type;
	}

	/*
	 * This is the same as jobs_GetDefinedJobTypeForModel from the Dataserver
	 */
	public static function GetDefinedJobTypeForModel($job, $modelid) {

		$jobcard_type = '';

		// find and set the individual job status for this model
		if (empty($job['models'])) {
			return $jobcard_type;
		}

		$job['status'] = $job['models'][$modelid]['job_status'];	// this needs to be moved as the names were mixed up in the database

		// offered:
		if ($job['startdate'] > time() && ($job['job_status'] == 0 || $job['job_status'] == 1) && $job['status'] == JOB_ASSIGNMENT_STATUS_OFFERED) {
			$jobcard_type = 'offered';
		} else

			if ($job['startdate'] > time() && $job['job_status'] == 0 && ($job['status'] == JOB_ASSIGNMENT_STATUS_CLIENT_OPTIONED || $job['status'] == JOB_ASSIGNMENT_STATUS_SHARE_SELECTED)) {
			$jobcard_type = 'optioned';
		} else

			if ($job['startdate'] < time() && $job['status'] == JOB_ASSIGNMENT_STATUS_OFFERED && ($job['job_status'] == 0 || $job['job_status'] == JOB_ASSIGNMENT_STATUS_OFFERED)) {
			$jobcard_type = 'expired';
		} else

			if ($job['startdate'] > time() && ($job['job_status'] == 0 || $job['job_status'] == 1) && $job['status'] == JOB_ASSIGNMENT_STATUS_MODEL_ACCEPTED_OPTION) {
			$jobcard_type = 'accepted';
		} else

			if ($job['startdate'] > time() && ($job['job_status'] == 0 || $job['job_status'] == 1) && $job['status'] == JOB_ASSIGNMENT_STATUS_ACCEPTED) {
			$jobcard_type = 'confirmed';
		} else

			if (($job['job_status'] == 0 || $job['job_status'] == 1) && $job['status'] == JOB_ASSIGNMENT_STATUS_MODEL_CANCELLED) {
			$jobcard_type = 'rejected';
		} else

			if (($job['job_status'] == 0 || $job['job_status'] == 1) && $job['status'] == JOB_ASSIGNMENT_STATUS_CLIENT_CANCELLED) {
			$jobcard_type = 'cancelled';
		} else

			if ($job['startdate'] < time() && ($job['job_status'] == 0 || $job['job_status'] == 1) && ($job['status'] == JOB_ASSIGNMENT_STATUS_MODEL_COMPLETED || $job['status'] == JOB_ASSIGNMENT_STATUS_CLIENT_COMPLETED || $job['status'] == JOB_ASSIGNMENT_STATUS_COMPLETED)) {
			$jobcard_type = 'finished';
		} else

			if ($job['startdate'] < time() && ($job['job_status'] == 0 || $job['job_status'] == 1) && $job['status'] == JOB_ASSIGNMENT_STATUS_ACCEPTED) {
			$jobcard_type = 'unfinalised';
		} else

			if (($job['job_status'] == 0 || $job['job_status'] == 1) && $job['status'] == JOB_ASSIGNMENT_STATUS_COMPLETED) {
			$jobcard_type = 'completed';
		}

		return $jobcard_type;
	}

	public static function GetUsageRights($jobid) {
		$response = ds('jobs_GetUsageRights', array('jobid' => $jobid));
		return genericResponse($response);
	}

	public static function SetUsageRights($jobid, $rights) {
		$response = ds('jobs_SetUsageRights', array('jobid' => $jobid, 'rights' => $rights));
		return genericResponse($response);
	}

	public static function UpdateModelDeliveryAddress($jobid, $address) {
		$response = ds('jobs_UpdateModelDeliveryAddress', array('jobid' => $jobid, 'address' => $address));
		return genericResponse($response);
	}

	public static function AddAdditionalInformation($jobid, $info) {
		$response = ds('jobs_AddAdditionalInformation', array('jobid' => $jobid, 'info' => $info));
		return genericResponse($response);
	}
	
	public static function ReopenJobIfNeeded($jobid) {
		$response = ds('jobs_ReopenJobIfNeeded', array('jobid' => $jobid));
		return genericResponse($response);
		
	}
	
	public static function SaveClientNotesAboutModel($modelid, $jobid, $notes) {
		$response = ds('jobs_SaveClientNotesAboutModel', array('modelid' => $modelid, 'jobid' => $jobid, 'notes' => $notes));
		return genericResponse($response);
	}
}
