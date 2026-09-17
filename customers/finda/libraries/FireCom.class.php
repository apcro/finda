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
 * A lightweight wrapper for the fire.com sdk
 */
class FireCom extends Core {

	static $core;
	static $firecomUri = 'https://api.fire.com/business/v1/apps/';
	static $config = array();
	static $fireClient = null;
	static $accessToken;
	static $accessTokenExpiry;
	static $batchId = '';
	
	static $ican = array();
	
	
	/**
	 *
	 */
	public static function Initialise() {
		if (!isset(self::$core)) {
			self::$core = parent::Initialise();
		}
		
		self::$config['keyId'] = '';
		self::$config['secret'] = '';
		self::$config['clientId'] = FIRE_CLIENTID;
		self::$config['clientKey'] = FIRE_CLIENT_KEY;
		self::$config['refreshToken'] = FIRE_REFRESH_TOKEN;
		
		self::$ican['gbp'] = 27554;
		self::$ican['eur'] = 27553;
		
		require_once ROOTPATH.'/libraries/external/Fire/Starter.php';

		if (!isset(self::$fireClient)) {
			self::$fireClient = new \Fire\Business\Client();
			try {
				self::$fireClient->initialise(self::$config);
			} catch (\Exception $e) {
				print_r ($e->getCode() . ': ' . $e->getMessage() . "\n");
			}
		}

		return self::$core;
	}
	/* **********************************************************************************
	* PRIVATE Functions
	* **********************************************************************************/
	
	private static function CreateBatch() {
		
	}
	
	private static function AddPaymentToBatch() {}
	
	
	/* **********************************************************************************
	 * PUBLIC Functions
	 * **********************************************************************************/
	
	public static function TestFireCom() {
		

		
	}
	
	public static function MakeModelPayment($modelid, $value, $invoiceid) {
		
		$user = User::LoadUser($modelid);
		if ($user['usertype'] == TYPE_MODEL) {
			$usertype = 'model';
			$invoicekey = 'modelid';
		} else if ($user['usertype'] == TYPE_CLIENT) {
			$usertype = 'client';
			$invoicekey = 'clientid';
		} else {
			return false;
		}
	
		// dual use here - sortcode/account number or IBAN
		if ( (!empty($user['bank_sortcode']) && !empty($user['bank_accountnumber']) || !empty($user['bank_iban'])) ) {
			// we can may the payment
			$invoice = Finance::RetrieveInvoiceDetails($invoiceid);
			
			if ($invoice[$invoicekey] == $modelid && $invoice['invoicetype'] == $usertype && $invoice['date_paid'] == 0 && empty($invoice['transaction_id'])) {
				
				
				/*
				 * Implement FireCom batch creation & transfer here
				 * 
				 * We should already have a token from fire.com just from calling the library
				 * 
				 */
				
				try {
					// Bank Transfers - create a batch, add/remove transfers, submit
					// we do batches for individual payments, as we're not set up to do batched payments in reality
					
					// select currency based on destination account type for the time being
					
					if (empty(self::$batchId)) {
						$batchDetails = array(
							'type' => 'BANK_TRANSFER',
							'currency' => 'GBP',
							'batchName' => 'Payment to '.$user['firstname'].' '.$user['lastname'].' for Invoice '.$invoice['id'],
							'jobNumber' => date('Y-m-d', time()).'-FND-M'.$invoice['id'],
						);
	
						if (isset($user['bank_iban'])) {
							$batchDetails['currency'] = 'EUR';
						} else {
							$batchDetails['currency'] = 'GBP';
						}
						
						
						$batch = self::$fireClient->batches->create($batchDetails);
					
						self::$batchId = $batch['batchUuid'];
					}
					
					// Add a bank transfer using account details instead:
					
					// Undocumented: myRef has a 50 character limit
					$myRef = 'Payment to '.$user['firstname'].' '.$user['lastname'].' for Invoice '.$invoice['id'];
					if (strlen($myRef) > 50) {
						$myRef = 'Payment to user '.$user['firstname'].' '.substr($user['lastname'], 0, 1).' for Invoice '.$invoice['id'];
						if (strlen($myRef) > 50) {
							$myRef = 'Payment for Invoice '.$invoice['id'];
						}
					}
					
					$paymentdetails = array(
						'payeeType' => 'ACCOUNT_DETAILS',
						'destAccountHolderName' => $user['bank_accountname'],
						'amount' => ($value * 100),	// value is in pence or cents
						'myRef' => $myRef,
						'yourRef' => 'FINDA GLOBAL LTD - FND-M'.$invoice['id']
					);
					
					if (isset($user['bank_iban'])) {
						$paymentdetails['icanFrom'] = self::$ican['eur'];
						$paymentdetails['destIban'] = $user['bank_iban'];
					} else {
						$paymentdetails['icanFrom'] = self::$ican['gbp'];
						$paymentdetails['destNsc'] = str_replace('-', '', $user['bank_sortcode']);
						$paymentdetails['destAccountNumber'] = $user['bank_accountnumber'];
					}
					$transaction = self::$fireClient->batch(self::$batchId)->addBankTransfer($paymentdetails);
					SendGrid::SendInternal('firecomdebug', 0, $transaction);
					Finance::UpdateInvoiceDetailsAsPaid($invoice['id'], self::$batchId);
					
				} catch (\Exception $e) {
					
					CroissantError::RecordError('FireCom error', json_encode($e));
					SendGrid::SendInternal('firecomdebug', 0, $e);
					
					// handle exception here
					return false;
				}
				
				// all good!
				$response = self::$fireClient->batch(self::$batchId)->submit();
				
				// kill the batch ID so we don't accidentally reuse it
				unset(self::$batchId);
				
				// stick in transaction table
				ds('finance_RecordTransaction', array('userid' => User::UserID(), 'invoiceid' => $invoice['id'], 'transactionid' => $transaction['id'], 'value' => $value * 100, 'out', $transaction));

				return $transaction;
			} else {
				die('invoice details bad');
				return false;
			}

		}
	}

	public static function RequestPaymentLink() {
		
	}
	
	/*
	 * retrieves a list of payments made to the fire.com account in the past 24 hours
	 * and matches them against provided invoice numbers
	 * 
	 */
	public static function CheckRecentInvoicePayments() {
		// step 1, get account details
		$transactions = self::$fireClient->account(self::$ican['gbp'])->transactions();
		
		// check limit: 1 hour or 1 day
		$oldest = time() - (60*60*24);
		
		// we may in future want to loop this - see the docs
		
		foreach($transactions['transactions'] as $transaction) {
			if (strtotime($transaction['date']) > $oldest) {
				if ($transaction['type'] == 'LODGEMENT') {
					
					$paymentReference = str_replace('-', '', strtolower(trim($transaction['myRef'])));
					$paymentValue = $transaction['amountBeforeCharges']/100;
					
					// does the reference match an invoice number?
					if (strstr($paymentReference, 'fndc')) {
						
						$invoiceid = str_replace('fndc', '', $paymentReference);
						$invoice = Finance::RetrieveInvoiceDetails($invoiceid);
						if ($invoice) {
							// we have a matching invoice - has it been paid?
							if ($invoice['status'] == 1) {
								if ($invoice['value'] == $paymentValue) {
									// we can mark this invoice as paid now, and release payments
									$response = Finance::UpdateInvoiceDetailsAsPaid($invoiceid, 'invoice-payment-via-fire-com: '.$transaction['txnId']);
									if ($response) {
										$response = Jobs::UpdateJobAsPaid($invoice['jobid']);
									}
									// stick in transaction table for records
									ds('finance_RecordTransaction', array('userid' => $invoice['clientid'], 'invoiceid' => $invoice['id'], 'transactionid' => 'invoice-payment-via-fire-com: '.$transaction['txnId'], 'value' => $paymentValue, 'in', json_encode($transaction)));
									SendGrid::SendInternal('successful payment in', $invoice['id'], $transaction);
								}
								
							}
						}
					} else {
						// send email to Tom & Mariya with unknown-payment detail
						SendGrid::SendInternal('unrecognised payment in', 0, $transaction);
					}
				}
			}
		}
	}
	
	public static function ListBatches() {
		$transaction = self::$fireClient->batches->read();
	}
	
	public static function DeleteBatch($batchid) {
		$transaction = self::$fireClient->batch($batchid)->cancel();
	}

	public static function SubmitBatch($batchid) {
		$transaction = self::$fireClient->batch($batchid)->submit();
	}
}
