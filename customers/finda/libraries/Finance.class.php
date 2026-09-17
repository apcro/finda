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
class Finance extends Core {

	static $core;
	static $stripeEndpoint = 'https://api.stripe.com';
	
	/**
	 *
	 */
	public static function Initialise() {
		if (!isset(self::$core)) {
			self::$core = parent::Initialise();
		}
		
		require_once ROOTPATH.'/libraries/external/Stripe/init.php';
		
		\Stripe\Stripe::setApiKey(STRIPE_PRIVATEKEY);

		return self::$core;
	}

	// get all invoices for a client
	// includes pending, escrow and paid
	public static function RetrieveInvoices($clientid) {
		$response = ds('finance_RetrieveInvoices', array('clientid' => $clientid));
		return genericResponse($response);
	}

	public static function RetrieveModelInvoices($modelid) {
		$response = ds('finance_RetrieveModelInvoices', array('modelid' => $modelid));
		return genericResponse($response);
	}
	
	// get all invoices for a client
	// includes pending, escrow and paid
	public static function RetrieveInvoiceDetailsByJobId($jobid, $usertype = 'client') {
		$response = ds('finance_RetrieveInvoiceDetailsByJobId', array('jobid' => $jobid, 'usertype' => $usertype));
		return genericResponse($response);
	}
	
	public static function RetrieveMotherAgencyInvoices($agencyid) {
		$response = ds('finance_RetrieveMotherAgencyInvoices', array('agencyid' => $agencyid));
		return genericResponse($response);
	}

	public static function RetrieveInvoiceDetails($invoiceid) {
		$response = ds('finance_RetrieveInvoiceDetails', array('invoiceid' => $invoiceid));
		if (isset($response['statusCode']) && $response['statusCode'] == 0) {
			$companydetails = Companies::LoadCompanyForClient($response['result']['clientid']);
			$response['result']['company'] = $companydetails;
			return $response['result'];
		} else {
			
		}
		return genericResponse($response);
	}
	
	// change the status of a particular invoice to PAID
	// required before model confirmation?
	public static function MarkInvoicePaid($clientid, $invoiceid) {}
	
	// create a client invoice for a job
	// if the job is edited after the invoice in generated, a new workflow will be needed
	// value of job is calculated from all model fees automatically
	public static function CreateClientInvoiceForJob($clientid, $jobid) {
		// only create the invoice once
		$invoice = self::RetrieveInvoiceDetailsByJobId($jobid, 'client');
		if (!$invoice) {
		
			$job = Jobs::GetJobDetails($jobid);
			
			$fees = Jobs::GetJobValueByJobId($jobid);
			
			$details = array();
			$details['clientid'] = User::UserID();
			$details['jobid'] = $jobid;
			$details['value'] = $fees['totalfee'];
			$details['invoicetype'] = 'client';

			// calculate due date
			// this is 2 days before the job starts, or FINDA_PAYMENT_DUE_DAYS days, or User Invoice Terms whichever is sooner
			if (User::CanPayByInvoice()) {
				$duedate = $job['startdate']+(60 * 60 * 24 * User::InvoiceTerms());
			} else {
				$duedate = time()+(60 * 60 * 24 * FINDA_PAYMENT_DUE_DAYS);
				if ($duedate > $job['startdate']) {
					$duedate = $job['startdate'] - (60*60*24*2);	// 2 days before the job
				}
			}
			$details['duedate'] = $duedate;
			$details['description'] = $job['name'];
			$response = ds('finance_StoreNewInvoiceDetails', array('details' => $details));

			if (isset($response['statusCode']) && $response['statusCode'] == 0) {
				// store the Finda one as well, for the value retained from this client for this job
				$details['invoicetype'] = 'finda';
				$details['clientid'] = $job['client_uid'];
				$details['value'] = $fees['findafee'];
				$result = ds('finance_StoreNewInvoiceDetails', array('details' => $details));

				return $response['result'];
			} else {
				return false;
			}
		} else {
			return false;
		}
	}
	
	// create a model self-invoice for a job
	// if the job is edited after the invoice in generated, a new workflow will be needed
	// value of job is calculated from all model fees automatically
	// returns false if the job assignment is not marked COMPLETE (status 7)
	public static function CreateModelInvoiceForJob($modelid, $jobid) {
		
		// make sure that the status is 7 (ALL COMPLETE)
		$status = Model::GetJobAssignmentStatus($jobid, $modelid);
		if ($status != 7) {	// see jobs.library in Dataserver for value definitions
			return false;
		}
		// make sure we don't already have an invoice for the model
		$invoice = Finance::RetrieveInvoiceDetailsForJobForModel($modelid, $jobid);
		if (!$invoice) {
		
			$job = Jobs::GetJobDetails($jobid);

			$model = User::LoadUser($modelid);
			
			$fees = Jobs::GetJobValueByJobId($jobid);
			
			$modelfee = $fees['modelfees'][$modelid]['total'];
			$findamodelfee = $fees['modelfees'][$modelid]['findafee'];	// 10%
			
			$details = array();

			if ($model['mother_agency'] != 0) {
				// the agency fee will have already been calculated
				$agencyfee = $details['agencyfee'] = $fees['modelfees'][$modelid]['agencyfee'];
			}
			
			if (isset($model['bank_iban']) && !empty($model['bank_iban'])) {
				$details['currency_code'] = 2;
			} else {
				$details['currency_code'] = 1;
			}
			
			$details['modelfee'] = $modelfee;
			$details['modelid'] = $modelid;
			
			$details['jobid'] = $jobid;
			
			// final payment to model
			$details['value'] = $modelfee; // + ($modelfee * VAT_RATE);	// add VAT here for record?
			$details['invoicetype'] = 'model';
	
			// calculate due date. 
			// For models, this is now, and payment will be made immediately
			$duedate = time();
			$details['duedate'] = $duedate;
			$details['description'] = $job['name'].':'.$job['description'];
			
			$response = ds('finance_StoreNewInvoiceDetails', array('details' => $details));
			
			if (isset($response['statusCode']) && $response['statusCode'] == 0) {
				// store the Finda one as well, for the value retained from this model for this job
				$details['invoicetype'] = 'finda';
				$details['clientid'] = $job['client_uid'];
				$details['value'] = $findamodelfee;
				ds('finance_StoreNewInvoiceDetails', array('details' => $details));
				
				if ($model['mother_agency'] != 0) {
					$details['invoicetype'] = 'agency';
					$details['clientid'] = $model['mother_agency'];
					$details['value'] = $agencyfee;
					SendGrid::SendMACommissionPaidEmail($modelid, $jobid);
				}
				
				return $response['result'];
			} else {
				return false;
			}
		} else {
			return $invoice['id'];	// return the invoiceid if there is already an invoice generated
		}
	}
	
	public static function RetrieveInvoiceDetailsForJobForModel($modelid, $jobid) {
		$response = ds('finance_RetrieveInvoiceDetailsForJobForModel', array('modelid' => $modelid, 'jobid' => $jobid));
		if (isset($response['statusCode']) && $response['statusCode'] == 0) {
			return $response['result'];
		} else {
			return false;
		}
	}
	
	/**
	 * Release payment to model under the following conditions:
	 * 1: Job is complete
	 * 2: Client invoice has been paid; or
	 * 3: 30 days have passed (payment still needs to be approved)
	 * 
	 * @param int $modelid
	 * @param int $jobid
	 * @param int $invoiceid
	 * @return mixed
	 */
	public static function ReleasePaymentToModel($modelid, $jobid, $invoiceid = 0) {
		$job = Jobs::GetJobDetails($jobid);
		
		// check job status = if COMPLETE and Client Invoice paid, release payment
		if ($invoiceid != 0) {
			$modelinvoice = self::RetrieveInvoiceDetails($invoiceid);
		} else {
			$modelinvoice = self::RetrieveInvoiceDetailsForJobForModel($modelid, $jobid);
		}
		if ($modelinvoice && $job['invoice_paid'] == 1) {
			$transactionid = FireCom::MakeModelPayment($modelid, $modelinvoice['value'], $modelinvoice['id']);
			
			if ($transactionid) {
				Notification::SendPaymentComplete($modelinvoice);
				self::UpdateInvoiceDetailsAsPaid($modelinvoice['id'], $transactionid);
				return $transactionid;
			} else {
				return false;
			}
		} else {
			return false;
		}
	}
	
	// gets details of the invoice, process payment via the Escrow class
	public static function ClientPayInvoice($invoiceid) {
		$invoice = self::RetrieveInvoiceDetails($invoiceid);
		
		// this is a process flow end point - the result of this function call is a redirect to a third party website
		// which then redirects back to a returnUrl
		die();
	}
	
	// flag used for menus
	public static function CanReceivePayments() {
		$user = User::LoadUser(User::UserID());
		
		$result = true;
		$result = ($user['bank_sortcode'] != '') && $result;
		$result = ($user['bank_accountnumber'] != '') && $result;
		$result = ($user['firstname'] != '') && $result;
		$result = ($user['lastname'] != '') && $result;
		$result = ($user['dob'] != 0) && $result;
		return $result;
	}
	
	// returns a concatenate string with the data missing from a profile before payments can be accepted
	public static function MissingPaymentDetails($page = 'none') {
		$user = User::LoadUser(User::UserID());
		
		$missingFields = array();
		if ($page == 'none' || $page == 'profile') {
			if (empty($user['bank_iban']) && empty($user['bank_accountnumber'])) {
				$missingFields[] = array('bank account details','/user/profile');
			}
		}
		if ($page == 'all' || $page == 'payments') {
			if (empty($user['nationality'])) $missingFields[] = array('nationality','/user/profile');
			if (empty($user['residence_country'])) $missingFields[] = array('country of residence','/user/profile');
			if (empty($user['dob'])) $missingFields[] = array('date of birth','/user/profile');
		}
		
		return $missingFields;
	}
	
	public static function CreateCharge($jobid, $stripeToken) {
		$fees = Jobs::GetJobValueByJobId($jobid);
		$charge = self::StripeCreateCharge($fees['totalfee'], $jobid, $stripeToken);
		
		if ($charge !== false) {
			// save payment details
			if (isset($charge['id']) && $charge['outcome']->type == 'authorized') {
				$invoice = self::RetrieveInvoiceDetailsByJobId($jobid);
				if ($invoice) {
					$response = self::UpdateInvoiceDetailsAsPaid($invoice['id'], $charge['id']);
					if ($response) {
						$response = Jobs::UpdateJobAsPaid($jobid);
						SendGrid::SendInternal('successful payment in', $invoice['id']);
					}
					// stick in transaction table for records
					ds('finance_RecordTransaction', array('userid' => User::UserID(), 'invoiceid' => $invoice['id'], 'transactionid' => $charge['id'], 'value' => $fees['totalfee'], 'in', $charge));
					return $response;
				} else {
					return false;
				}
			} else {
				return false;
			}
		}
		
		return false;
	}
	
	public static function UpdateInvoiceDetailsAsPaid($invoiceid, $transactionid = 0) {
		$response = ds('finance_UpdateInvoiceDetailsAsPaid', array('invoiceid' => $invoiceid, 'transactionid' => $transactionid));
		return genericResponse($response);
	}
	
	
	public static function UpdateInvoiceValue($invoiceid, $newvalue) {
		$response = ds('finance_UpdateInvoiceValue', array('invoiceid' => $invoiceid, 'newvalue' => $newvalue));
		return genericResponse($response);
	}
	
	public static function ClientGetUnpaidInvoiceCount($userid) {
		$response = ds('finance_ClientGetUnpaidInvoiceCount', array('uid' => $userid));
		return genericResponse($response);
	}
	
	
	
	/*************************************************************************************************************************
	 * Stripe functionality
	 *************************************************************************************************************************/
	
	public static function StripeCreateCharge($value, $jobid, $stripeToken) {
		try {
			$charge = \Stripe\Charge::create(array(
					"amount" => $value*100,		// convert to pence
					"currency" => "gbp",
					"source" => $stripeToken,
			));
			
		} catch (\Exception $e) {
			// there was an error
			CroissantError::RecordError('Stripe error', json_encode($e));
			return false;
			die();
		}
		
		// need to deal with bad charges here?
		
		// stick in transaction table
		ds('finance_RecordTransaction', array('userid' => User::UserID(), 'invoiceid' => $jobid, 'transactionid' => $charge['id'], 'value' => $value, 'out', $charge));
		
		return $charge;
		
	}
	
}
