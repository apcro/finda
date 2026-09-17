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

// this is the models payments handler
if (User::UserType() != 1) {
	header('Location: /');
	die();
}
// this, this is the long way
$model = User::Loaduser(User::UserID());
$page_title = 'Payments';

if (User::UserType() == 1) {
	// model base
	Core::Assign('body_class', 'body-blue');
} else {
	// client base
}

// we have 4 states
// updating data
// clearing data ahead of update
// got bank details but not profile details
// got profile details but not bank details

	switch ($args[0]) {
		case 'releasepayment':
			if (IS_AJAX_REQUEST) {
				$invoice = Finance::RetrieveInvoiceDetails($invoiceid);
				$job = Jobs::GetJobDetails($invoice['jobid']);
				if ($job['invoice_id'] != 0 && $job['invoice_paid'] != 0) {
					$response = Finance::ReleasePaymentToModel(User::UserID(), $invoice['jobid']);
					if ($response != false) {
						Core::JSONWrite(true);
					} else {
						Core::JSONWrite(false);
					}
				} else {
					Core::JSONWrite(false);
				}
			}
			die();
			break;
		case 'update':
			$userDetails = array();
			if (!empty($input_sortcode) && !empty($input_accountnumber)) {
				$userDetails['bank_sortcode'] = $input_sortcode;
				$userDetails['bank_accountnumber'] = $input_accountnumber;
				$userDetails['bank_accountname'] = $input_accountname;
				$response = User::UpdateUser($userDetails);
				if (isset($response['statusCode']) && $response['statusCode'] == 0) {
				} else {
					Session::SetVariable('errorMessage', $response);
				}
			}
			header('Location: /payments');
			die();
			break;
		case 'accept':
			break;	
		case 'reject':
			break;
		case 'more-info':
			break;
		case 'negotiate':
			break;
		case 'create':
			break;
		case 'pay':
			include('payments/client_pay_invoice.php');
			break;
		default:
			if (!IS_AJAX_REQUEST) {
				
				// we now have a second piece, if user is verified but KYC documents not uploaded, show a different page
				if (($model['status'] == 1 || $model['status'] == 99) && $model['kyc_on'] == '' && $model['kyc_by'] == '') {
					$template = 'user/payments/verified_no_id.tpl';
				} else {
					
					
					
					$template = 'user/payments/model_invoices.tpl';
					$invoices = Finance::RetrieveModelInvoices(User::UserID());
					
					foreach($invoices as $k => $invoice) {
						
						$job = Jobs::GetJobDetails($invoice['jobid']);
						$invoices[$k]['company_name'] = $job['company_name'];
						$invoices[$k]['project_name'] = $job['name'];
						// get individual status codes for each job by invoice
						if (empty($invoice['transaction_id']) && $invoice['due_date'] < time()) {
							$jobstatus = Jobs::ModelGetJobStatus($invoice['jobid']);
							$invoices[$k]['job_status'] = $jobstatus;
							
							// check, just in case there was an error
							if ($invoice['value'] == 0) {
								$fees = Jobs::GetJobValueByJobId($invoice['jobid']);
								$modelfee = $fees['modelfees'][User::UserID()];
								if ($modelfee['fee'] != 0) {
									// we need to udpate this invoice
									Finance::UpdateInvoiceValue($invoice['id'], $modelfee['fee']);
									if (!empty(User::VATNUmber())) {
										// include VAT
										$invoices[$k]['value'] = $modelfee['total'];
									} else {
										$invoices[$k]['value'] = $modelfee['fee'];
									}
								}
							}
						}
					}
					
					Core::Assign('invoices', $invoices);
					
					foreach($invoices as $k => $v) {
						if ($v['status'] == 1) {
							$outstanding += $v['value'];
						}
					}
					Core::Assign('outstanding', $outstanding);
					
					Core::AddJavascript('user/paymentslist.js');
					Core::AddJavascript('jobs/joblist.js');
					Core::AddCSS('user/invoices.css');
					Core::Assign('user', $model);
					Core::Assign('body-class', 'body-white');
					
					Core::Assign('banner_title', 'My Payments');
				}
				
			} else {
				header('HTTP/1.0 403 Forbidden', 403);		
				die();
			}
			
			break;
	}
