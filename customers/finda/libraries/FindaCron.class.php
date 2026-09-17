<?php
/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
namespace Croissant;

class FindaCron extends Core {
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
	
	
	/**
	 * Finds all projects that finished yesterday
	 * If the invoice for the project has been paid, it 'completes' the project,
	 * generates invoices for all the models, and releases payment to them
	 * 
	 * $jobid = 223;
	 * $modelid = 355;
	 * $invoiceid = Finance::CreateModelInvoiceForJob($modelid, $jobid);	// this returns the actual invoiceid or false if assignment status is not 7
	 * if ($invoiceid) {
	 * 		Notification::SendJobComplete($jobid, $modelid);
	 * 		// check if payment can be released
	 * 		Finance::ReleasePaymentToModel($modelid, $jobid, $invoiceid);
	 * }
	 */
	public static function SettlePastProjects() {
		
		$jobs = ds('jobs_GetJobsFromTwoDaysAgo');
		
		if (isset($jobs['statusCode']) && $jobs['statusCode'] == 0) {
			foreach($jobs['result'] as $job) {
				
				foreach($job['models'] as $model) {
					
					// complete the job for the model
					if ($model['job_status'] == JOB_ASSIGNMENT_STATUS_ACCEPTED || $model['job_status'] == JOB_ASSIGNMENT_STATUS_ACCEPTED_CONFIRMED || $model['job_status'] == JOB_ASSIGNMENT_STATUS_MODEL_COMPLETED || $model['job_status'] == JOB_ASSIGNMENT_STATUS_CLIENT_COMPLETED) {
						Jobs::ClientUpdateModelForJob($job['id'], $model['id'], JOB_ASSIGNMENT_STATUS_COMPLETED);
						SendGrid::SendInternal('job autoclosed', $job['id']);

						$invoiceid = Finance::CreateModelInvoiceForJob($model['id'], $job['id']);
						
						if ($invoiceid) {
							Notification::SendJobComplete($job['id'], $model['id']);
							// check if payment can be released
							if ($job['invoice_id'] != 0 && $job['invoice_paid'] != 0) {	// if the Client invoice has been created & paid
								Finance::ReleasePaymentToModel($model['id'], $job['id'], $invoiceid);
							}
						}
					}
				}
				
			}
			
		}
	}
	

}
