<?php
/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */

namespace Croissant;

class SendGrid extends Core {

	static $core;

	static $sendgrid;

	public static function Initialise() {

		if (!isset(self::$core)) {
			if (DEBUG) _log(__CLASS__.'::'.__FUNCTION__);
			require_once(ROOTPATH.'/libraries/external/php-http-client-master/loader.php');
			require_once(ROOTPATH.'/libraries/external/sendgrid-php-master/lib/loader.php');
			self::$core = parent::initialise();
			self::$sendgrid = new \SendGrid(SENDGRID_API_KEY);
		}
		return self::$core;
	}

	private static function Send($email) {
		try {
			$response = self::$sendgrid->send($email);
		} catch (\Exception $e) {
			$response->exception = $e;
			CroissantError::RecordError('SendGrid error', json_encode($response));
		}
		return $response;
	}

	public static function SendReferrerEmail($name, $mail, $modelid){

		$model = User::LoadUser($modelid);

		// well, SendGrid's template failed, so...
		$subject = $model['firstname'].' invited you to join a booking platform for models!';
		Core::Assign('subject', $subject);
		Core::Assign('model', $model);
		$html = Core::Fetch('emails/referrer_email.tpl');

		$email = new \SendGrid\Mail\Mail();
		$email->setFrom("hello@idal.co", "iDAL");
		$email->setSubject($subject);

		if (DEBUG && LOCALDEV) {
			$email->addTo('tom@idal.co');
		} else {
			$email->addTo($mail, $name, 0);
		}
		$email->addContent("text/html", $html);
		$response = self::Send($email);
		if (isset($response->exception)) {
			return false;
		}
		return true;
	}

	// sends the normal registration email
	public static function SendRegisterWelcomeEmail($name, $mail){

		Core::Assign('subject', $name.', Get to know iDAL!');
		$html = Core::Fetch('emails/toclient/register_welcome.tpl');

		$email = new \SendGrid\Mail\Mail();
		$email->setFrom("hello@idal.co", "iDAL");
		$email->setSubject($name.', Get to know iDAL!');

		if (DEBUG && LOCALDEV) {
			$email->addTo('tom@idal.co');
		} else {
			$email->addTo($mail, $name, 0);
		}
		$email->addContent("text/html", $html);
		$response = self::Send($email);
		if (isset($response->exception)) {
			return false;
		}
		return true;
	}
	
	// new Mother Agency Application welcome email
	public static function SendMARegisterWelcomeEmail($name, $mail){
		
		Core::Assign('subject', $name.', Thanks for joining iDAL!');
		$html = Core::Fetch('emails/tomotheragency/register_welcome.tpl');
		
		$email = new \SendGrid\Mail\Mail();
		$email->setFrom("hello@idal.co", "iDAL");
		$email->setSubject($name.', Thanks for joining iDAL!');
		
		if (DEBUG && LOCALDEV) {
			$email->addTo('tom@idal.co');
		} else {
			$email->addTo($mail, $name, 0);
		}
		$email->addContent("text/html", $html);
		$response = self::Send($email);
		if (isset($response->exception)) {
			return false;
		}
		return true;
	}
	
	// send Mother Agency Commission Paid email
	public static function SendMACommissionPaidEmail($modelid, $jobid) {
		
		$job = Jobs::GetJobDetails($jobid);
		
		$agreed_rate = $job['models'][$modelid]['agreed_rate'];
		Core::Assign('agreed_rate', $agreed_rate);
		Core::Assign('job', $job);

		$model = User::LoadUser($modelid);
		Core::Assign('model', $model);
		$commission = $agreed_rate * ($model['motheragency_commission']/100);
		Core::Assign('commission', $commission);
		
		$client = User::LoadUser($job['client_uid']);
		Core::Assign('client', $client);
		
		$subject = 'A booking was just paid by a client';
		$html = Core::Fetch('emails/tomotheragency/client_paid_commission_coming.tpl');
		
		$email = new \SendGrid\Mail\Mail();
		$email->setFrom("hello@idal.co", "iDAL");
		$email->setSubject($subject);
		
		if (DEBUG && LOCALDEV) {
			$email->addTo('tom@idal.co');
		} else {
			$email->addTo($client['mail'], $client['firstname'].' '.$client['lastname'], 0);
		}
		$email->addContent("text/html", $html);
		$response = self::Send($email);
		if (isset($response->exception)) {
			return false;
		}
		return true;
	}
	
	// sends custom email to clients who register through the direct booking workflow
	public static function SendDirectBookingRegisterWelcomeEmail($name, $mail){
		
		Core::Assign('subject', $name.', Welcome to iDAL!');
		Core::Assign('name', $name);
		$html = Core::Fetch('emails/toclient/direct_booking_register_welcome.tpl');
		
		$email = new \SendGrid\Mail\Mail();
		$email->setFrom("hello@idal.co", "iDAL");
		$email->setSubject($name.', Get to know iDAL!');
		
		if (DEBUG && LOCALDEV) {
			$email->addTo('tom@idal.co');
		} else {
			$email->addTo($mail, $name, 0);
		}
		$email->addContent("text/html", $html);
		$response = self::Send($email);
		if (isset($response->exception)) {
			return false;
		}
		return true;
	}
	
	public static function SendDirectBookingRegisterWelcomeEmailNoID($name, $mail){
		
		Core::Assign('subject', $name.', Welcome to iDAL!');
		Core::Assign('name', $name);
		$html = Core::Fetch('emails/toclient/created_new_direct_booking_no_id.tpl');
		
		$email = new \SendGrid\Mail\Mail();
		$email->setFrom("hello@idal.co", "iDAL");
		$email->setSubject($name.', Get to know iDAL!');
		
		if (DEBUG && LOCALDEV) {
			$email->addTo('tom@idal.co');
		} else {
			$email->addTo($mail, $name, 0);
		}
		$email->addContent("text/html", $html);
		$response = self::Send($email);
		if (isset($response->exception)) {
			return false;
		}
		return true;
	}

	public static function SendNewBookingEmail($modelid, $jobid) {

		$model = User::LoadUser($modelid);
		if ($model['prefs']['job_offered'] == 0) {
			return false;
		}

		$job = Jobs::GetJobDetails($jobid);
		
		$client = User::LoadUser($job['client_uid']);
		Core::Assign('client', $client);
		Core::Assign('job', $job);
		$email = new \SendGrid\Mail\Mail();
		$email->setFrom("hello@idal.co", "iDAL");
		
		// this needs to be modified for castings
		if ($job['bookingtype'] == 'casting') {
			$subject = $client['company_name'].' has sent you a '.$job['bookingtype'].' request';
			Core::Assign('subject', $subject);
			$html = Core::Fetch('emails/tomodel/casting_request.tpl');
		} else {
			$subject = $model['firstname'].', you have received a job offer on iDAL!';
			Core::Assign('subject', $subject);
			$html = Core::Fetch('emails/tomodel/selected_for_job.tpl');
			$file_encoded = base64_encode(file_get_contents(BASEPATH.'/documents/Idal-ClientModelTerms.pdf'));
			$email->addAttachment(
				$file_encoded,
				"application/pdf",
				"Idal-ClientModelTerms.pdf",
				"attachment"
			);
		}

		$email->setSubject($subject);


		if (DEBUG && LOCALDEV) {
			$email->addTo('tom@idal.co');
		} else {
			$email->addTo($model['mail'], $model['firstname'].' '.$model['lastname'], 0);
		}

		$email->addContent("text/html", $html);
		$response = self::Send($email);
		if (isset($response->exception)) {
			return false;
		}
		return true;
	}
	
	public static function SendBookingCancelledEmail($modelid, $jobid){

		$model = User::LoadUser($modelid);
		if ($model['prefs']['job_cancelled'] == 0) {
			return false;
		}

		$job = Jobs::GetJobDetails($jobid);
		$client = User::LoadUser($job['client_uid']);

		Core::Assign('client', $client);
		Core::Assign('job', $job);
		Core::Assign('model', $model);
		
		if ($job['bookingtype'] == 'casting') {
			$html = Core::Fetch('emails/tomodel/client_cancel_casting.tpl');
			$subject = 'Your upcoming '.$job['bookingtype'].' has been cancelled';
		} else {
			$html = Core::Fetch('emails/tomodel/client_cancel_job.tpl');
			$subject = 'Your job request has been cancelled';
		}

		Core::Assign('subject', $subject);

		$email = new \SendGrid\Mail\Mail();
		$email->setFrom("hello@idal.co", "iDAL");
		$email->setSubject($subject);

		if (DEBUG && LOCALDEV) {
			$email->addTo('tom@idal.co');
		} else {
			$email->addTo($model['mail'], $model['firstname'].' '.$model['lastname'], 0);
		}

		$email->addContent("text/html", $html);
		$response = self::Send($email);
		if (isset($response->exception)) {
			return false;
		}

		self::SendInternal('client cancelled model', $jobid, array('modelid' => $modelid));
		return true;
	}

	public static function SendModelCancelledEmail($modelid, $jobid){

		$model = User::LoadUser($modelid);
		if ($model['prefs']['job_cancelled'] == 0) {
			return false;
		}

		$job = Jobs::GetJobDetails($jobid);
		$client = User::LoadUser($job['client_uid']);

		$subject = 'A model had to cancel your booking';

		Core::Assign('client', $client);
		Core::Assign('job', $job);
		Core::Assign('model', $model);
		Core::Assign('subject', $subject);
		$html = Core::Fetch('emails/toclient/model_cancelled_job.tpl');

		$email = new \SendGrid\Mail\Mail();
		$email->setFrom("hello@idal.co", "iDAL");
		$email->setSubject($subject);

		if (DEBUG && LOCALDEV) {
			$email->addTo('tom@idal.co');
		} else {
			$email->addTo($client['mail'], $client['firstname'].' '.$client['lastname'], 0);
		}

		$email->addContent("text/html", $html);
		$response = self::Send($email);
		if (isset($response->exception)) {
			return false;
		}
		self::SendInternal('model cancelled job', $jobid, array('modelid' => $modelid));
		return true;
	}

	public static function SendFriendRegisteredEmail($modelid, $code){

		$model = User::LoadUser($modelid);
		if ($model['prefs']['friend_registers'] == 0) {
			return false;
		}

		// need to get the friendid from the code here
		$friend = Model::GetModelByCode($code);

		$subject = $friend['firstname'].', '.$model['firstname'].' '.$model['lastname'].' registered on iDAL';

		Core::Assign('friend', $friend);
		Core::Assign('model', $model);
		Core::Assign('subject', $subject);
		$html = Core::Fetch('emails/friendregister_email.tpl');

		$email = new \SendGrid\Mail\Mail();
		$email->setFrom("hello@idal.co", "iDAL");
		$email->setSubject($subject);

		if (DEBUG && LOCALDEV) {
			$email->addTo('tom@idal.co');
		} else {
			$email->addTo($mail, $friend['firstname'].' '.$friend['lastname'], 0);
		}

		$email->addContent("text/html", $html);
		$response = self::Send($email);
		if (isset($response->exception)) {
			return false;
		}
		return true;
	}

	public static function SendPaymentMadeEmail($modelid, $invoiceid){

		$model = User::LoadUser($modelid);
		if ($model['prefs']['payment_made'] == 0) {
			return false;
		}

		$invoice = Finance::RetrieveInvoiceDetails($invoiceid);

		$subject = 'You have received a payment from iDAL';

		Core::Assign('invoice', $invoice);
		Core::Assign('model', $model);
		Core::Assign('subject', $subject);
		$html = Core::Fetch('emails/paymentmade_email.tpl');

		$email = new \SendGrid\Mail\Mail();
		$email->setFrom("hello@idal.co", "iDAL");
		$email->setSubject($subject);

		if (DEBUG && LOCALDEV) {
			$email->addTo('tom@idal.co');
		} else {
			$email->addTo($mail, $model['firstname'].' '.$model['lastname'], 0);
		}

		$email->addContent("text/html", $html);
		$response = self::Send($email);

		if (isset($response->exception)) {
			return false;
		}
		return true;
	}

	public static function SendClientPaymentMadeEmail($clientid, $invoiceid){

		$client = User::LoadUser($clientid);
		if ($client['prefs']['payment_made'] == 0) {
			return false;
		}

		$invoice = Finance::RetrieveInvoiceDetails($invoiceid);

		$subject = 'Thank you for your payment';

		Core::Assign('invoice', $invoice);
		Core::Assign('client', $client);
		Core::Assign('subject', $subject);
		$html = Core::Fetch('emails/toclient/payment_made.tpl');

		$email = new \SendGrid\Mail\Mail();
		$email->setFrom("hello@idal.co", "iDAL");
		$email->setSubject($subject);

		if (DEBUG && LOCALDEV) {
			$email->addTo('tom@idal.co');
		} else {
			$email->addTo($mail, $client['firstname'].' '.$client['lastname'], 0);
		}

		$email->addContent("text/html", $html);
		$response = self::Send($email);

		if (isset($response->exception)) {
			return false;
		}
		return true;
	}

	public static function SendPasswordResetEmail($mail, $html){
		$subject = 'Reset your password on iDAL';
		$email = new \SendGrid\Mail\Mail();
		$email->setFrom("hello@idal.co", "iDAL");
		$email->setSubject($subject);

		if (DEBUG && LOCALDEV) {
			$email->addTo('tom@idal.co');
		} else {
			$email->addTo($mail);
		}

		$email->addContent("text/html", $html);
		$response = self::Send($email);

		if (isset($response->exception)) {
			return false;
		}
		return true;
	}

	public static function SendInternal($mail, $id, $data = array()) {
		
		if (DEBUG && LOCAL_DEV) {
			return;
		}
		
		$email = new \SendGrid\Mail\Mail();

		switch($mail) {
			case 'job autoclosed':
				$subject = 'Client project autocompleted after 3 days';
				$job = Jobs::GetJobDetails($id);
				Core::Assign('job', $job);
				$html = Core::Fetch('emails/staff/job_autoclosed.tpl');
				$email->addTo('mariya@idal.co');
				break;
				
			case 'client cancelled model':
				$subject = 'Client cancelled model';
				$job = Jobs::GetJobDetails($id);
				$model = User::LoadUser($data['modelid']);
				Core::Assign('job', $job);
				Core::Assign('model', $model);
				$html = Core::Fetch('emails/staff/client_cancelled_model.tpl');
				$email->addTo('mariya@idal.co');

				break;

			case 'model cancelled job':
				$subject = 'Model cancelled job';
				$job = Jobs::GetJobDetails($id);
				$model = User::LoadUser($data['modelid']);
				Core::Assign('job', $job);
				Core::Assign('model', $model);
				$html = Core::Fetch('emails/staff/model_cancelled_job.tpl');
				$email->addTo('mariya@idal.co');

				break;
				
			case 'new mother agency application':
				$subject = 'New mother agency application';
				$client = User::LoadUser($id);
				Core::Assign('client', $client);
				$html = Core::Fetch('emails/staff/new_ma_registered.tpl');
				$email->addTo('mariya@idal.co');
				break;
				
			case 'new client':
				$subject = 'New client application';
				$client = User::LoadUser($id);
				Core::Assign('client', $client);
				$html = Core::Fetch('emails/staff/new_client_registered.tpl');
				break;

			case 'new project':
				if (ENVIRONMENT == 'localdev' || ENVIRONMENT == 'dev') {
					$subject = 'New TEST project created on iDAL Dev';
				}
				Core::Assign('data', $data);
				$job = Jobs::GetJobDetails($id);
				$calcunits = $job['time_units'] >= 1?$job['time_units']:1;
				$job['total_value'] = $job['modelcount'] * $calcunits * $job['offered_rate'];
				Core::Assign('job', $job);
				
				$type = 'booking';
				if ($job['bookingtype'] == 'direct') {
					$type = 'direct booking';
				}
				if ($job['project_tid'] == 75 || $job['project_tid'] == 78) {
					$type = 'casting';
				}
				
				$subject = 'New '.$type.' created on iDAL by '.$job['client_firstname'].' '.$job['client_lastname'];
				
				
				if (!empty($job['company_name'])) {
					$subject .= ' ('.$job['company_name'].')';
				}
				$html = Core::Fetch('emails/staff/new_project_created.tpl');
				$email->addTo('mariya@idal.co');
				$email->addTo('natalia@idal.co');
				break;
			case 'system error':
				$subject = 'New system error on iDAL';
				$data['created'] = time();
				Core::Assign('error', $data);
				$html = Core::Fetch('emails/staff/new_system_error.tpl');
				break;
			case 'unrecognised payment in':
				$subject = 'Unrecognised Payment to Fire.com account';
				if (ENVIRONMENT == 'localdev' || ENVIRONMENT == 'dev') {
					$subject = 'New TEST project created on iDAL Dev';
				}
				Core::Assign('data', $data);
				$html = Core::Fetch('emails/staff/unrecognised_payment.tpl');
				$email->addTo('mariya@v');
				break;
			case 'successful payment in':
				$subject = 'Invoice Successfully Paid: '.$id;
				if (ENVIRONMENT == 'localdev' || ENVIRONMENT == 'dev') {
					$subject = 'New TEST project created on iDAL Dev';
				}
				$invoice = Finance::RetrieveInvoiceDetails($id);
				Core::Assign('invoice', $invoice);
				
				$job = Jobs::GetJobDetails($invoice['jobid']);
				Core::Assign('job', $job);
				
				Core::Assign('data', $data);
				$html = Core::Fetch('emails/staff/invoice_payment.tpl');
				$email->addTo('mariya@idal.co');
				break;
			case 'firecomdebug':
				$subject = 'firecom debug';
				Core::Assign('data', $data);
				$html = Core::Fetch('emails/staff/firecomdebug.tpl');
				break;

			default:
				return;
		}

		$email->setFrom("hello@idal.co", "iDAL");
		$email->setSubject($subject);
		$email->addTo('tom@idal.co');
		$email->addContent("text/plain", $html);
		$response = self::Send($email);

		if (isset($response->exception)) {
			return false;
		}
		return true;
	}

	public static function SendModelAccept($jobid, $modelid = 0) {
		if ($modelid == 0) {
			$modelid = User::UserID();
		}
		$model = User::LoadUser($modelid);

		$job = Jobs::GetJobDetails($jobid);
		$client = User::LoadUser($job['client_uid']);
		Core::Assign('model', $model);
		Core::Assign('job', $job);

		// since a model is accepting, we know the model record exists in the job array
		$agreed_rate = $job['models'][$model['id']]['agreed_rate'];
		Core::Assign('agreed_rate', $agreed_rate);

		if ($job['bookingtype'] == 'casting') {
			$subject = 'A model has confirmed attendance at your '.$job['bookingtype'];
			$html = Core::Fetch('emails/toclient/model_accepts_casting.tpl');
		} else {
			$subject = $model['firstname'].' '.$model['lastname'].' has accepted your offer!';
			$html = Core::Fetch('emails/toclient/model_accepts_job.tpl');
		}

		$email = new \SendGrid\Mail\Mail();
		$email->setFrom("hello@idal.co", "iDAL");
		$email->setSubject($subject);

		if (DEBUG && LOCALDEV) {
			$email->addTo('tom@idal.co');
		} else {
			$email->addTo($client['mail']);
		}

		$email->addContent("text/html", $html);
		$response = self::Send($email);
		
		// is this model in a mother agency?
		if ($model['mother_agency'] != 0 && $job['bookingtype'] == 'casting') {
			$client = User::LoadUser($job['client_uid']);
			Core::Assign('client', $client);
			$motheragency = MotherAgencies::LoadMotherAgencyForModel($model['id']);
			$email = new \SendGrid\Mail\Mail();
			$email->setFrom("hello@idal.co", "iDAL");
			$subject = 'One of your models is attending a casting';
			$html = Core::Fetch('emails/tomotheragency/model_accepted_casting.tpl');
			$email->setSubject($subject);
			
			if (DEBUG && LOCALDEV) {
				$email->addTo('tom@idal.co');
			} else {
				$email->addTo($motheragency['mail']);
			}
			$email->addContent("text/html", $html);
			$response = self::Send($email);
		}

		if (isset($response->exception)) {
			return false;
		}
		return true;
	}

	public static function SendModelAcceptConfirm($jobid){
		$model = user::Loaduser(USer::UserID());
		$job = Jobs::GetJobDetails($jobid);
		$client = User::LoadUser($job['client_uid']);
		Core::Assign('model', $model);
		Core::Assign('job', $job);

		if ($job['bookingtype'] == 'casting') {
			$subject = 'Your '.$client['company_name'].' '.$job['bookingtype'].' is confirmed.';
			$html = Core::Fetch('emails/tomodel/casting_confirmation.tpl');
		} else {
			$subject = $model['firstname'].' '.$model['lastname'].', you have confirmed a new job with '.$job['company_name'];
			$html = Core::Fetch('emails/accept_offer_model_confirm.tpl');
			
		}

		$email = new \SendGrid\Mail\Mail();
		$email->setFrom("hello@idal.co", "iDAL");
		$email->setSubject($subject);

		if (DEBUG && LOCALDEV) {
			$email->addTo('tom@idal.co');
		} else {
			$email->addTo($model['mail']);
		}

		$email->addContent("text/html", $html);
		$response = self::Send($email);

		if (isset($response->exception)) {
			return false;
		}
		return true;
	}

	public static function SendModelReject($jobid, $reasons = '') {
		$model = User::LoadUser(User::UserID());

		$job = Jobs::GetJobDetails($jobid);
		$client = User::LoadUser($job['client_uid']);
		Core::Assign('model', $model);
		Core::Assign('job', $job);
		
		// this is a rejection, not a negotiation. Vocabulary = 16
		if (!empty($reasons)) {
			$terms = Taxonomy::GetTermsByVocabulary(16);
			$reasons = explode(',', $reasons);
			$reasonText = array();
			foreach($terms as $k => $term) {
				if (in_array($k, $reasons)) {
					$reasonText[] = strtolower($term['name']);
				}
			}
			
			$msgText = join(' and ', array_filter(array_merge(array(join(', ', array_slice($reasonText, 0, -1))), array_slice($reasonText, -1)), 'strlen'));
			
			Core::Assign('reasons', array('count' => count($reasonText), 'text' => ucfirst($msgText)));
		}

		if ($job['bookingtype'] == 'casting') {
			$subject = $model['firstname'].' has declined your '.$job['bookingtype'].' invitation';
			$html = Core::Fetch('emails/toclient/model_rejects_casting.tpl');
		} else {
			$subject = $model['firstname'].' has rejected your offer';
			$html = Core::Fetch('emails/toclient/model_rejects_job.tpl');
		}
 
		$email = new \SendGrid\Mail\Mail();
		$email->setFrom("hello@idal.co", "iDAL");
		$email->setSubject($subject);

		if (DEBUG && LOCALDEV) {
			$email->addTo('tom@idal.co');
		} else {
			$email->addTo($client['mail']);
		}

		$email->addContent("text/html", $html);
		$response = self::Send($email);

		if (isset($response->exception)) {
			return false;
		}
		return true;
	}

	public static function SendModelRejectOption($jobid) {
		return;
		
		$model = User::LoadUser(User::UserID());

		$subject = $model['firstname'].' '.$model['lastname'].' has rejected your option';

		$job = Jobs::GetJobDetails($jobid);
		$client = User::LoadUser($job['client_uid']);
		Core::Assign('model', $model);
		Core::Assign('job', $job);

		$html = Core::Fetch('emails/joboption_rejected.tpl');

		$email = new \SendGrid\Mail\Mail();
		$email->setFrom("hello@idal.co", "iDAL");
		$email->setSubject($subject);

		if (DEBUG && LOCALDEV) {
			$email->addTo('tom@idal.co');
		} else {
			$email->addTo($client['mail']);
		}

		$email->addContent("text/html", $html);
		$response = self::Send($email);

		if (isset($response->exception)) {
			return false;
		}
		return true;
	}

	public static function SendClientCreatedProjectConfirmation($jobid) {
		$user = User::LoadUser(User::UserID());
		$job = Jobs::GetJobDetails($jobid);
		Core::Assign('job', $job);

		$subject = 'Start requesting models for your project '.$job['name'];

		$html = Core::Fetch('emails/toclient/created_new_project.tpl');

		$email = new \SendGrid\Mail\Mail();
		$email->setFrom("hello@idal.co", "iDAL");
		$email->setSubject($subject);

		if (DEBUG && LOCALDEV) {
			$email->addTo('tom@idal.co');
		} else {
			$email->addTo($user['mail']);
		}

		$email->addContent("text/html", $html);
		$response = self::Send($email);

		if (isset($response->exception)) {
			return false;
		}
		return true;
	}
	
	public static function SendClientCreatedDirectBookingConfirmation($jobid) {
		$user = User::LoadUser(User::UserID());
		Core::Assign('user', $user);
		$job = Jobs::GetJobDetails($jobid);
		Core::Assign('job', $job);
		
		$model = array_shift($job['models']);
		Core::Assign('model', $model);
		
		$subject = 'Your direct booking request was sent to '.$model['firstname'];
		
		$html = Core::Fetch('emails/toclient/created_new_direct_booking.tpl');
		
		$email = new \SendGrid\Mail\Mail();
		$email->setFrom("hello@idal.co", "iDAL");
		$email->setSubject($subject);
		
		if (DEBUG && LOCALDEV) {
			$email->addTo('tom@idal.co');
		} else {
			$email->addTo($user['mail']);
		}
		
		$email->addContent("text/html", $html);
		$response = self::Send($email);
		
		if (isset($response->exception)) {
			return false;
		}
		return true;
	}
	
	public static function SendJobChanged($modelid, $jobid) {
		$user = User::LoadUser($modelid);
		if ($user['prefs']['job_changed'] == 0) {
			return false;
		}
		$job = Jobs::GetJobDetails($jobid);
		$client = User::LoadUser($job['client_uid']);
		Core::Assign('job', $job);
		Core::Assign('client', $client);
		
		$subject = $client['company_name'].' has made an update to the job '.$job['name'];
		
		$html = Core::Fetch('emails/tomodel/job_details_changed.tpl');

		$email = new \SendGrid\Mail\Mail();
		$email->setFrom("hello@idal.co", "iDAL");
		$email->setSubject($subject);

		if (DEBUG && LOCALDEV) {
			$email->addTo('tom@idal.co');
		} else {
			$email->addTo($user['mail']);
		}

		$email->addContent("text/html", $html);
		$response = self::Send($email);

		if (isset($response->exception)) {
			return false;
		}
		return true;
	}

	public static function SendJobInfoAdded($modelid, $jobid) {
		$user = User::LoadUser($modelid);
		if ($user['prefs']['job_changed'] == 0) {
			return false;
		}
		$job = Jobs::GetJobDetails($jobid);

		$client = User::LoadUser($job['client_uid']);
		Core::Assign('client', $client);

		// this is only sent for CLOSED jobs
		$job['jobcard_type'] = 'closed';
		Core::Assign('job', $job);
		$subject = 'Additional information has been added to you job';

		$html = Core::Fetch('emails/job_info_added_old_job.tpl');
		$email = new \SendGrid\Mail\Mail();
		$email->setFrom("hello@idal.co", "iDAL");
		$email->setSubject($subject);

		if (DEBUG && LOCALDEV) {
			$email->addTo('tom@idal.co');
		} else {
			$email->addTo($user['mail']);
		}

		$email->addContent("text/html", $html);
		$response = self::Send($email);

		if (isset($response->exception)) {
			return false;
		}
		return true;
	}

	public static function SendClientJobConfirmed($jobid) {
		$job = Jobs::GetJobDetails($jobid);
		Core::Assign('job', $job);

		$fees = Jobs::GetJobValueByJobId($jobid);
		Core::Assign('fees', $fees);

		$client = User::LoadUser($job['client_uid']);

		$email = new \SendGrid\Mail\Mail();
		$email->setFrom("hello@idal.co", "iDAL");

		if ($job['bookingtype'] == 'casting') {
			$subject = 'Your casting on iDAL has been confirmed';
			$html = Core::Fetch('emails/client_casting_confirmation.tpl');
		} else {
			$subject = 'Your project on iDAL has been confirmed';
			$html = Core::Fetch('emails/client_job_confirmation.tpl');
			$file_encoded = base64_encode(file_get_contents(BASEPATH.'/documents/Idal-ClientModelTerms.pdf'));
			$email->addAttachment(
				$file_encoded,
				"application/pdf",
				"Idal-ClientModelTerms.pdf",
				"attachment"
				);
		}
		$email->setSubject($subject);

		if (DEBUG && LOCALDEV) {
			$email->addTo('tom@idal.co');
		} else {
			$email->addTo($client['mail']);
		}

		
		$email->addContent("text/html", $html);
		$response = self::Send($email);

		if (isset($response->exception)) {
			return false;
		}
		return true;
	}

	// this has been converted from sending to all models on a job (on close) to individual models
	// when individually confirmed
	public static function SendModelJobConfirmed($jobid, $modelid) {
		$job = Jobs::GetJobDetails($jobid);

		if ($job['models']) {
			Core::Assign('job', $job);

			Core::Assign('agreed_rate', $job['models'][$modelid]['agreed_rate']);
			
			$confirmed = array();
			foreach($job['models'] as $model) {
				if ($model['id'] != $modelid && $model['status'] == 2) {
					$confirmed[] = $model;
				}
			}
			Core::Assign('confirmed', $confirmed);
			$email = new \SendGrid\Mail\Mail();
			$email->setFrom("hello@idal.co", "iDAL");

			if ($job['bookingtype'] == 'casting') {
				$subject = 'YOU HAVE AN UPCOMING '.strtoupper($job['jobtype_name']).'!';
				$html = Core::Fetch('emails/tomodel/casting_confirmation.tpl');
			} else {
				$subject = 'Your job on iDAL has been confirmed';
				$html = Core::Fetch('emails/model_job_confirmation.tpl');
				
				$file_encoded = base64_encode(file_get_contents(BASEPATH.'/documents/Idal-ClientModelTerms.pdf'));
				$email->addAttachment(
					$file_encoded,
					"application/pdf",
					"Idal-ClientModelTerms.pdf",
					"attachment"
					);
			}

			// we need the email
			$user = User::LoadUser($modelid);

			$email->setSubject($subject);

			if (DEBUG && LOCALDEV) {
				$email->addTo('tom@idal.co');
			} else {
				$email->addTo($user['mail']);
			}

			$email->addContent("text/html", $html);
			$response = self::Send($email);
			
			// is this model in a mother agency?
			if ($user['mother_agency'] != 0) {
				Core::Assign('model', $user);
				$client = User::LoadUser($job['client_uid']);
				Core::Assign('client', $client);
				$motheragency = MotherAgencies::LoadMotherAgencyForModel($modelid);
				$email = new \SendGrid\Mail\Mail();
				$email->setFrom("hello@idal.co", "iDAL");
				$subject = 'One of your models just booked a job';
				$html = Core::Fetch('emails/tomotheragency/model_confirmed_for_booking.tpl');
				$email->setSubject($subject);
				
				if (DEBUG && LOCALDEV) {
					$email->addTo('tom@idal.co');
				} else {
					$email->addTo($motheragency['mail']);
				}
				$email->addContent("text/html", $html);
				$response = self::Send($email);
			}
			

		}

		if (isset($response->exception)) {
			return false;
		}
		return true;
	}

	public static function SendClientInvoicePaid($jobid) {
		$subject = 'Invoice Paid to iDAL';

		$invoice = Finance::RetrieveInvoiceDetailsByJobId($jobid, 'client');
		Core::Assign('invoiceid', $invoice['id']);
		$html = Core::Fetch('emails/invoice_paid_client.tpl');

		$client = User::LoadUser($invoice['clientid']);

		$email = new \SendGrid\Mail\Mail();
		$email->setFrom("hello@idal.co", "iDAL");
		$email->setSubject($subject);

		if (DEBUG && LOCALDEV) {
			$email->addTo('tom@idal.co');
		} else {
			$email->addTo($client['mail']);
		}

		$email->addContent("text/html", $html);
		$response = self::Send($email);

		if (isset($response->exception)) {
			return false;
		}
		return true;
	}

	public static function SendModelInvoicePaid($jobid) {
		$subject = 'Invoice Paid by iDAL';

		$invoice = Finance::RetrieveInvoiceDetailsByJobId($jobid, 'model');
		Core::Assign('invoiceid', $invoice['id']);
		$html = Core::Fetch('emails/invoice_paid_model.tpl');

		$model = User::LoadUser($invoice['modelid']);

		$email = new \SendGrid\Mail\Mail();
		$email->setFrom("hello@idal.co", "iDAL");
		$email->setSubject($subject);

		if (DEBUG && LOCALDEV) {
			$email->addTo('tom@idal.co');
		} else {
			$email->addTo($model['mail']);
		}

		$email->addContent("text/html", $html);
		$response = self::Send($email);

		if (isset($response->exception)) {
			return false;
		}
		return true;
	}

	public static function SendModelNewCallsheet($jobid, $modelid) {
		$subject = 'New Callsheet for one of your jobs';

		$job = Jobs::GetJobDetails($jobid);
		Core::Assign('job', $job);

		$client = User::LoadUser($job['client_uid']);
		Core::Assign('client', $client);

		$html = Core::Fetch('emails/model_download_callsheet.tpl');

		$model = User::LoadUser($modelid);

		$email = new \SendGrid\Mail\Mail();
		$email->setFrom("hello@idal.co", "iDAL");
		$email->setSubject($subject);

		if (DEBUG && LOCALDEV) {
			$email->addTo('tom@idal.co');
		} else {
			$email->addTo($model['mail']);
		}

		$email->addContent("text/html", $html);

		$filename = trim(basename($job['name'])).'.pdf';
		$filename = str_replace(' ', '_', $filename);
		$file_encoded = base64_encode(file_get_contents(DOCROOT.$job['callsheet']));

		$email->addAttachment(
			$file_encoded,
			"application/pdf",
			$filename,
			"attachment"
			);

		$response = self::Send($email);

		if (isset($response->exception)) {
			return false;
		}
		return true;
	}

	public static function SendModelNegotiateRate($jobid, $modelid) {
		$job = Jobs::GetJobDetails($jobid);
		$job['model_desired_rate'] = $job['models'][$modelid]['model_desired_rate'];
		$job['client_offered_rate'] = $job['models'][$modelid]['client_offered_rate'];
		Core::Assign('job', $job);
		$model = User::LoadUser($modelid);
		Core::Assign('model', $model);


		$html = Core::Fetch('emails/toclient/model_negotiated_rate.tpl');

		$client = User::LoadUser($job['client_uid']);

		$subject = 'A model would like to negotiate your offered rate';
		$email = new \SendGrid\Mail\Mail();
		$email->setFrom("hello@idal.co", "iDAL");
		$email->setSubject($subject);

		if (DEBUG && LOCALDEV) {
			$email->addTo('tom@idal.co');
		} else {
			$email->addTo($client['mail']);
		}

		$email->addContent("text/html", $html);
		$response = self::Send($email);
		if (isset($response->exception)) {
			return false;
		}
		return true;
	}

	public static function SendClientDeclineRate($jobid, $modelid) {
		$job = Jobs::GetJobDetails($jobid);
		Core::Assign('job', $job);
		$model = User::LoadUser($modelid);
		Core::Assign('model', $model);
		$client = User::LoadUser($job['client_uid']);
		Core::Assign('client', $client);

// 		$html = Core::Fetch('emails/tomodel/client_negotiation_reply.tpl');
		$html = Core::Fetch('emails/client_decline_negotiation.tpl');


		$subject = 'The client has rejected your rate negotiation';
		$email = new \SendGrid\Mail\Mail();
		$email->setFrom("hello@idal.co", "iDAL");
		$email->setSubject($subject);

		if (DEBUG && LOCALDEV) {
			$email->addTo('tom@idal.co');
		} else {
			$email->addTo($model['mail']);
		}

		$email->addContent("text/html", $html);
		$response = self::Send($email);
		if (isset($response->exception)) {
			return false;
		}
		return true;
	}

	public static function SendClientAcceptRate($jobid, $modelid) {
		$job = Jobs::GetJobDetails($jobid);
		$job['model_desired_rate'] = $job['models'][$modelid]['model_desired_rate'];
		$job['client_offered_rate'] = $job['models'][$modelid]['client_offered_rate'];
		$job['agreed_rate'] = $job['models'][$modelid]['agreed_rate'];
		Core::Assign('job', $job);
		$model = User::LoadUser($modelid);
		Core::Assign('model', $model);
		$client = User::LoadUser($job['client_uid']);
		Core::Assign('client', $client);

		$html = Core::Fetch('emails/client_accept_negotiation.tpl');

		$subject = 'Congratulations! The client has accepted your rate request!';
		$email = new \SendGrid\Mail\Mail();
		$email->setFrom("hello@idal.co", "iDAL");
		$email->setSubject($subject);

		if (DEBUG && LOCALDEV) {
			$email->addTo('tom@idal.co');
		} else {
			$email->addTo($model['mail']);
		}

		$email->addContent("text/html", $html);
		$response = self::Send($email);

		if (isset($response->exception)) {
			return false;
		}
		return true;
	}

	public static function SendClientUpdateRateEmail($jobid, $modelid) {
		$job = Jobs::GetJobDetails($jobid);
		$job['model_desired_rate'] = $job['models'][$modelid]['model_desired_rate'];
		$job['client_offered_rate'] = $job['models'][$modelid]['client_offered_rate'];
		$job['agreed_rate'] = $job['models'][$modelid]['agreed_rate'];
		Core::Assign('job', $job);
		$model = User::LoadUser($modelid);
		Core::Assign('model', $model);
		$client = User::LoadUser($job['client_uid']);
		Core::Assign('client', $client);

// 		$html = Core::Fetch('emails/tomodel/client_negotiation_reply_negotiate.tpl');
		$html = Core::Fetch('emails/tomodel/client_negotiation_reply.tpl');
		// 		$html = Core::Fetch('emails/client_accept_negotiation.tpl');


		$subject = 'An important update on your booking rate negotiation';
		$email = new \SendGrid\Mail\Mail();
		$email->setFrom("hello@idal.co", "iDAL");
		$email->setSubject($subject);

		if (DEBUG && LOCALDEV) {
			$email->addTo('tom@idal.co');
		} else {
			$email->addTo($model['mail']);
		}

		$email->addContent("text/html", $html);
		$response = self::Send($email);

		if (isset($response->exception)) {
			return false;
		}
		return true;
	}

	public static function SendClientDeliveryAddresses($jobid) {
		$job = Jobs::GetJobDetails($jobid);
		Core::Assign('job', $job);
		$client = User::LoadUser($job['client_uid']);
		Core::Assign('client', $client);

		$html = Core::Fetch('emails/client_send_model_delivery_address.tpl');


		$subject = 'iDAL Influencer Product Delivery Addresses';
		$email = new \SendGrid\Mail\Mail();
		$email->setFrom("hello@idal.co", "iDAL");
		$email->setSubject($subject);

		if (DEBUG && LOCALDEV) {
			$email->addTo('tom@idal.co');
		} else {
			$email->addTo($client['mail']);
		}

		$email->addContent("text/plain", $html);
		$response = self::Send($email);

		if (isset($response->exception)) {
			return false;
		}
		return true;
	}

	public static function SendCustomEmail($to, $subject, $html) {
		$email = new \SendGrid\Mail\Mail();
		$email->setFrom("hello@idal.co", "iDAL");
		$email->setSubject($subject);
		if (is_array($to)) {
			foreach($to as $address) {
				$email->addTo($address);
			}
		} else {
			$email->addTo($to);
		}
		$email->addContent("text/html", $html);
		$email->setClickTracking(false, false);
		$email->setOpenTracking(false);
		$response = self::Send($email);
		if (isset($response->exception)) {
			return false;
		}
		return true;
	}
	
	public static function SendNewMessageEmail($msgid) {
		$message = Notification::LoadNotificationDetails($msgid);
		Core::Assign('message', $message);
		$model = User::LoadUser($message['recipient']);
		Core::Assign('model', $model);
		
		if ($message['usertype'] == 1) {
			// from model
			$html = Core::Fetch('emails/toclient/new_chat_message_received.tpl');
		} else {
			// from client
			$html = Core::Fetch('emails/tomodel/new_chat_message_received.tpl');
		}
		
		$subject = 'You have received a new message';
		$email = new \SendGrid\Mail\Mail();
		$email->setFrom("hello@idal.co", "iDAL");
		$email->setSubject($subject);
		
		if (DEBUG && LOCALDEV) {
			$email->addTo('tom@idal.co');
		} else {
			$email->addTo($model['mail']);
		}
		
		$email->addContent("text/html", $html);
		$response = self::Send($email);
		
		if (isset($response->exception)) {
			return false;
		}
		return true;
	}
}
