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
class MotherAgencies extends Core {

	static $core;

	/**
	 *
	 */
	public static function Initialise() {
		if (!isset(self::$core)) {
			self::$core = parent::Initialise();
		}

		return self::$core;
	}

	
	public static function LoadProjectsByMotherAgency($jobtype, $companyid) {
		$response = ds('motheragencies_MotherAgencyGetJobsList', array('jobtype' => 'all', 'companyid' => $companyid));
		if (isset($response['statusCode']) && $response['statusCode'] == 0) {
			return $response['result'];
		} else {
			return false;
		}
	}
	
	public static function LoadInvoicesByMotherAgency($companyid) {}
	
	public static function LoadMotherAgencyDetails($companyid) {
		$response = ds('motheragencies_LoadMotherAgencyDetails', array('companyid' => $companyid));
		if (isset($response['statusCode']) && $response['statusCode'] == 0) {
			return $response['result'];
		} else {
			return false;
		}
	}
	
	public static function LoadMotherAgencyForClient($clientid) {
		$response = ds('motheragencies_LoadMotherAgencyForClient', array('clientid' => $clientid));
		if (isset($response['statusCode']) && $response['statusCode'] == 0) {
			return $response['result'];
		} else {
			return false;
		}
	}
	
	public static function LoadMotherAgencyForModel($modelid) {
		$response = ds('motheragencies_LoadMotherAgencyForModel', array('modelid' => $modelid));
		if (isset($response['statusCode']) && $response['statusCode'] == 0) {
			return $response['result'];
		} else {
			return false;
		}
	}
	
	public static function IsClientInMotherAgency($clientid, $companyid) {}
	
	public static function IsModelInMotherAgency($modelid, $agencyid) {
		$user = User::LoadUser($modelid);
		return ($user['mother_agency'] == $agencyid);
	}
	
	public static function CanAccessProject($projectid) {
		$job = Jobs::GetjobDetails($projectid);
		if ($job['client_uid'] != User::UserID()) {
			$client = User::LoadUser($job['client_uid']);
			$companyDetails = User::GetUserCompanyDetails();
			if ($client['companyid'] != $companyDetails['id']) {
				return false;
			}
		}
		return true;
	}
	
	public static function RetrieveMotherAgencyInvoices($companyid) {
		$response = ds('motheragencies_RetrieveMotherAgencyInvoices', array('companyid' => $companyid));
		return genericResponse($response);
	}
	
	
	public static function UpdateMotherAgencyDetails($data) {
		$response = ds('motheragencies_UpdateMotherAgencyDetails', array($data));
		if (isset($response['statusCode']) && $response['statusCode'] == 0) {
			return $response['result'];
		} else {
			return false;
		}
	}
	
	public static function LoadModelsForMotherAgency($agencyid) {
		$response = ds('motheragencies_LoadModelsForMotherAgency', array('agencyid' => $agencyid));
		if (isset($response['statusCode']) && $response['statusCode'] == 0) {
			return $response['result'];
		} else {
			return false;
		}
	}
	
	public static function GetMotherAgencyStats($agencyid) {
		$response = ds('motheragencies_GetMotherAgencyStats', array('agencyid' => $agencyid));
		if (isset($response['statusCode']) && $response['statusCode'] == 0) {
			return $response['result'];
		} else {
			return false;
		}
	}
	
	public static function LoadJobsForMotherAgency($agencyid) {
		
		// process
		// get all models for mother agency
		// get all jobs for each model
		// aggregate and return list
		
		$alljobs = array();
		$models = self::LoadModelsForMotherAgency($agencyid);
		foreach($models as $model) {
			$modeljobs = Jobs::GetJobsForModel($model['id']);
			foreach($modeljobs as $k => $job) {
				$modeljobs[$k]['model'] = $model;
			}
			$alljobs = array_merge($alljobs, $modeljobs);
		}
		
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
			
			$fees = Jobs::GetJobValueByJobId($job['id']);
			$job['agencycommission'] = $fees['modelfees'][$job['model']['id']]['agencycommission'];
			
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
		$jobs = array();
		$jobs['upcoming'] = array_merge($confirmed, $offered, $accepted);
		$jobs['past'] = array_merge($tocomplete);
		$jobs['history'] = array_merge($completed, $finished, $unconfirmed, $rejected, $expired, $debug);
		
		return $jobs;
	}
	
	public static function GetMotherAgencyProjectsForDisplay($motheragency) {
		$companyProjects = MotherAgencies::LoadJobsForMotherAgency($motheragency);
		foreach($companyProjects['upcoming'] as $k => $v) {
			if ($v['client_uid'] == User::UserID()) {
				unset($companyProjects['upcoming'][$k]);
			}
		}
		foreach($companyProjects['past'] as $k => $v) {
			if ($v['client_uid'] == User::UserID()) {
				unset($companyProjects['past'][$k]);
			}
		}
		foreach($companyProjects['history'] as $k => $v) {
			if ($v['client_uid'] == User::UserID()) {
				unset($companyProjects['history'][$k]);
			}
		}
		
		if ($companyProjects && count($companyProjects) > 0) {
			
			$companypending = array();
			$companyclosed = array();
			$companyunfinalised = array();
			$companypast = array();
			$companycomplete = array();
			$companywaiting = array();
			$companydue = array();			// for Clients on post-pay
			$companyoverdue = array();
			$companydeleted = array();
			$companyincomplete = array();
			
			foreach($companyProjects as $jobk => $job) {
				if ($job['client_uid'] == User::UserID()) {
					unset($companyProjects[$jobk]);
				} else {
					$companyProjects[$jobk]['completedcount'] = 0;
					$companyProjects[$jobk]['acceptedcount'] = 0;
					$companyProjects[$jobk]['rejectedcount'] = 0;
					$companyProjects[$jobk]['offeredcount'] = 0;
					$companyProjects[$jobk]['optionedcount'] = 0;
					$companyProjects[$jobk]['modelcompletedcount'] = 0;
					$companyProjects[$jobk]['confirmedcount'] = 0;
					$companyProjects[$jobk]['negotiatingcount'] = 0;
					
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
					
					$companyProjects[$jobk]['optionedmodelcount'] = count($job['models']);
					$companyProjects[$jobk]['totalselectedcount'] = count($job['models']);
					
					/*
					 * now we split these into their various arrays based on the current ruleset
					 */
					
					// need to calc totalfee now...
					$feetotal = 0;
					foreach($companyProjects[$jobk]['models'] as $feek => $feev) {
						if ($feev['agreed_rate'] != 0) {
							// confirmed only
							if ($feev['job_status'] == 2 || $feev['job_status'] == 5 || $feev['job_status'] == 6 || $feev['job_status'] == 7) {
								$feetotal = $feetotal + $feev['agreed_rate'];
								$feetotal = $feetotal * 1.1;	// add finda fee
								$feetotal = $feetotal * 1.2;	// add vat
							}
						}
					}
					$companyProjects[$jobk]['feetotal'] = $feetotal;
					
					
					// pending:
					if ($job['startdate'] > time() && $job['job_status'] == JOB_ASSIGNMENT_STATUS_PENDING) {
						if ($companyProjects[$jobk]['modelcount'] == $companyProjects[$jobk]['acceptedcount'] && $companyProjects[$jobk]['job_status'] == JOB_ASSIGNMENT_STATUS_PENDING && $companyProjects[$jobk]['optionedmodelcount'] != 0) {
							$companyProjects[$jobk]['jobcard_type'] = 'confirmable';
							
						} else {
							$companyProjects[$jobk]['jobcard_type'] = 'pending';
						}
						
						$companypending[] = $companyProjects[$jobk];
						unset($companyProjects[$jobk]);
					} else
						// with overdue invoices:
						if ($job['startdate'] < time() && ($job['job_status'] == JOB_ASSIGNMENT_STATUS_MODEL_ACCEPTED_OPTION || $job['job_status'] == JOB_ASSIGNMENT_STATUS_OFFERED) && $job['invoice_paid'] == 0) {
							
							if ($allowInvoice) {
								if (($job['startdate'] + (60 * 60 * 24 * $creditTerms)) < time()) {
									$companyProjects[$jobk]['jobcard_type'] = 'overdue';
									$companyoverdue[] = $companyProjects[$jobk];
									unset($companyProjects[$jobk]);
								} else {
									$companyProjects[$jobk]['jobcard_type'] = 'due';
									$companydue[] = $companyProjects[$jobk];
									unset($companyProjects[$jobk]);
								}
							} else {
								$companyProjects[$jobk]['jobcard_type'] = 'overdue';
								$companyoverdue[] = $companyProjects[$jobk];
								unset($companyProjects[$jobk]);
							}
						} else
							
							if ($job['startdate'] > time() && $job['job_status'] == 1) {
								$companyProjects[$jobk]['jobcard_type'] = 'confirmed';
								
								$companyclosed[] = $companyProjects[$jobk];
								unset($companyProjects[$jobk]);
							} else
								
								// unfinalised:
								if ($job['startdate'] < time() && $job['job_status'] == JOB_ASSIGNMENT_STATUS_OFFERED && $companyProjects[$jobk]['optionedmodelcount'] != $companyProjects[$jobk]['completedcount']) {
									$companyProjects[$jobk]['jobcard_type'] = 'unfinalised';
									$companyunfinalised[] = $companyProjects[$jobk];
									
									unset($companyProjects[$jobk]);
								} else
									
									// past unclosed:
									if ($job['startdate'] < time() && $job['job_status'] == JOB_ASSIGNMENT_STATUS_PENDING && $job['invoice_paid'] == 0) {
										$companyProjects[$jobk]['jobcard_type'] = 'rate models';
										$companyincomplete[] = $companyProjects[$jobk];
										unset($companyProjects[$jobk]);
									} else
										
										// completed:
										if ($job['startdate'] < time() && $job['job_status'] == JOB_ASSIGNMENT_STATUS_OFFERED && $job['invoice_paid'] == 1) {
											$companyProjects[$jobk]['jobcard_type'] = 'complete';
											$companycomplete[] = $companyProjects[$jobk];
											unset($companyProjects[$jobk]);
										} else
											
											
											// waiting for models to complete:
											if ($job['startdate'] < time() && $job['job_status'] == JOB_ASSIGNMENT_STATUS_OFFERED && $companyProjects[$jobk]['acceptedcount'] != $companyProjects[$jobk]['modelcompletedcount'] && $job['invoice_paid'] == 1) {
												$companyProjects[$jobk]['jobcard_type'] = 'waiting';
												$companywaiting[] = $companyProjects[$jobk];
												unset($companyProjects[$jobk]);
											} else
												
												if ($job['startdate'] < time() && $job['job_status'] == JOB_ASSIGNMENT_STATUS_PENDING && $companyProjects[$jobk]['modelcompletedcount'] == $companyProjects[$jobk]['totalselectedcount'] && $job['invoice_paid'] == 1) {
													$companyProjects[$jobk]['jobcard_type'] = 'unfinalised';
													$companyunfinalised[] = $companyProjects[$jobk];
													unset($companyProjects[$jobk]);
												} else
													
													// deleted:
													if ($job['job_status'] == 2) {
														$companyProjects[$jobk]['jobcard_type'] = 'deleted';
														$companydeleted[] = $companyProjects[$jobk];
														unset($companyProjects[$jobk]);
													} else {
														// anything uncategorised, in-test or with unexpected data sets
														if (DEBUG) {
															$companyProjects[$jobk]['jobcard_type'] = 'DEBUG';
															$companypast[] = $companyProjects[$jobk];
															unset($companyProjects[$jobk]);
															
														}
													}
				}
			}
			
			$companyProjects['upcoming'] = array_merge($companypending, $companywaiting, $companydue, $companyclosed);
			$companyProjects['past'] = array_merge($companyunfinalised, $companyincomplete, $companydue, $companyoverdue);
			$companyProjects['history'] = array_merge($companycomplete, $companypast, $companydeleted);
		}
		return $companyProjects;
	}
	

}
