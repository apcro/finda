<?php
/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
namespace Croissant;

// book model page

switch ($args[0]) {
	
	// create a project for an existing client
	case 'createproject':
		$json = array();
		$json['status'] = 0;
		$json['message'] = '';
		
		$client = User::LoadUser($userid);

		if ($client) {
			// check if the user is currently logged in
			if (User::UserID() == 0) {
				User::Login($client['mail'], $userpass);
			}
			
			$model = User::LoadUser($modelid);
			$friendlydate = date('d M Y', strtotime($startdate));
			// create the project
			$formdata = array();
			$formdata['name'] = 'Direct Booking for '.$model['firstname'].'.'.strtoupper(substr($model['lastname'], 0, 1)).' on '.$friendlydate;
			$formdata['description'] = $description;
			$formdata['location'] = $bookinglocation;
			$formdata['project_tid'] = $jobtype;
			$formdata['offered_rate'] = !empty($rate)?$rate:0; // must be a number, comes with a prefix
			$formdata['altrate'] = '';
			$formdata['time_units'] = !empty($length)?$length:1;
			$formdata['units_type'] = 'day';
			$formdata['modelcount'] = 1;
			$formdata['startdate'] = strtotime($startdate);
			$formdata['starttime'] = strtotime($starttime);
			
			$formdata['sharepass'] = substr(hash('sha512',rand()), 0, 6);	// 6 character simple password
			$formdata['shareuri'] = substr(str_shuffle(str_repeat("0123456789abcdefghijklmnopqrstuvwxyz", 12)), 0, 12);
			
			$formdata['request_address'] = 0;
			
			$usage = array();
			$usage['uk'] = 1;
			$usage['europe'] = 0;
			$usage['international'] = 0;
			
			// the basic usage types
			$formdata['baseusage'] = '6';	// 6 months
			$formdata['extrarights'] = '';
			
			// this goes into the job_rights table
			$formdata['usage'] = $usage;
			
			// the individual taxonomy rights
			if ($formdata['project_tid'] == 12) {
				$usagerights[] = 63;
			}
			$formdata['usagerights'] = $usagerights;
			
			$advanced = array();
			$advanced['contact_number'] = '';
			$advanced['contact_name'] = '';
			$formdata['advanced'] = $advanced;
			
			$formdata['projectbookingtype'] = 'direct';
			
			$jobid = Jobs::ClientCreateJob($formdata);
			
			if ($jobid === false) {
				$json['status'] = 3;
				$json['message'] = 'Could not create booking';
			} else {
				
				if ($client['status'] == 0) {
					$jobs = Jobs::ClientGetJobsList('all');
					if (count($jobs) > 0) {
						$json['status'] = 5;
						$json['message'] = 'You have already created a direct booking but have not been verified yet. Please wait until you are verified before requesting another model.';
					} else {
						// Add this model to this newly-created job
						// Equivalent of shortlisting
						Jobs::AddModelToJob($modelid, $jobid, $rate);
						$json['status'] = 5;
						$json['message'] = 'We have created your booking. Once you have been verified your request will be sent to '.$modelname;
					}
				} else {
					// Shortlist. This is needed to set state 10 on the model, so the update step triggers the emails properly
					Jobs::AddModelToJob($modelid, $jobid, $rate);
					
					// now we make the automatic request if the client is already verified
					Jobs::ClientUpdateModelForJob($jobid, $modelid, 1);
					
					// and send the confirmation
					SendGrid::SendClientCreatedDirectBookingConfirmation($jobid);
				}
				
			}
			
		} else {
			$json['status'] = 4;	// general error
		}
		Core::JSONWrite($json);
		die();
		break;
	
		
	// create a new client and a new project
	case 'newclient':
		if (IS_AJAX_REQUEST) {

			// we're creating a new user
			$formData = array(
				'mail' => (isset($usermail))? $usermail : '',
				'pass' => (isset($userpass))? $userpass : null,
				'firstname' => (isset($firstname))? $firstname : '',
				'lastname' => (isset($lastname))? $lastname : '',
				'telephone' => (isset($telephone))? $telephone : '',
				'occupation' => '',
				'company_name' => (isset($company))? $company : '',
				'company_website' => $company_website,
				'country' => '',
				'usertype' => 'client',
				'agree_terms' => 1,
				'referrer' => 'directbooking',
				// required in the database
				'gender' => 'other',
				'age' => 0,
				'entry_url' => 'website directbooking',
				'dob' => 0,
			);
			$listid = MAILCHIMP_BRAND_LIST;
			
			$json = array();
			$json['status'] = 0;
			$json['message'] = '';
			
			if ($usermail != '') {
				$response = User::CreateUser($formData);
			} else {
				$response = array('statusCode' => 1);
				$json['status'] = 98;
			}
			if ($response['statusCode'] == 0) {
				
				// log the user in in the background
				User::Login($usermail, $userpass, false);

				// update user with the referrer
				User::UpdateUser(array('referrer' => $referrer));
				
				// create referrer_code
				Utilities::GetNewReferrerCode($response['result']['userid']);
				
				if (!DEBUG) {
					// add to Mailchimp list here
					$email = $formData['mail'];
					$merge_vars = array('FNAME' => $formData['firstname'], 'LNAME' => $formData['lastname']);
					$result = Mailchimp3::ListSubscribe($listid, $email, $merge_vars);
				}

				// still send the emails, even if DEBUG
				if (!empty($_FILES)) {
					SendGrid::SendDirectBookingRegisterWelcomeEmail($formData['firstname'], $email);
				} else {
					SendGrid::SendDirectBookingRegisterWelcomeEmailNoID($formData['firstname'], $email);
				}
				
				$model = User::LoadUser($modelid);
				
				$friendlydate = date('d M Y', strtotime($startdate));
				// create the project anyway
				$formdata = array();
				$formdata['name'] = 'Direct Booking for '.$model['firstname'].'.'.strtoupper(substr($model['lastname'], 0, 1)).' on '.$friendlydate;
				$formdata['description'] = $description;
				$formdata['location'] = $location;
				$formdata['project_tid'] = $jobtype;
				$formdata['offered_rate'] = !empty($rate)?$rate:0; // must be a number, comes with a prefix
				$formdata['altrate'] = '';
				$formdata['time_units'] = !empty($length)?$length:1;
				$formdata['units_type'] = 'day';
				$formdata['modelcount'] = 1;
				$formdata['startdate'] = strtotime($startdate);
				$formdata['starttime'] = strtotime($starttime);
				
				$formdata['sharepass'] = substr(hash('sha512',rand()), 0, 6);	// 6 character simple password
				$formdata['shareuri'] = substr(str_shuffle(str_repeat("0123456789abcdefghijklmnopqrstuvwxyz", 12)), 0, 12);
				
				$formdata['request_address'] = 0;
				
				$usage = array();
				$usage['uk'] = 1;
				$usage['europe'] = 0;
				$usage['international'] = 0;
				
				// the basic usage types
				$formdata['baseusage'] = '6';
				$formdata['extrarights'] = '';
				
				// this goes into the job_rights table
				$formdata['usage'] = $usage;
				
				// the individual taxonomy rights
				if ($formdata['project_tid'] == 12) {
					$usagerights[] = 63;
				}
				$formdata['usagerights'] = $usagerights;
				
				$advanced = array();
				$advanced['contact_number'] = '';
				$advanced['contact_name'] = '';
				$formdata['advanced'] = $advanced;
				
				$formdata['projectbookingtype'] = 'direct';
				
				$jobid = Jobs::ClientCreateJob($formdata);
				if ($jobid === false) {
					$json['status'] = 3;
					$json['message'] = 'Could not create booking';
				} else {
					// Add this model to this newly-created job
					// Equivalent of shortlisting
					Jobs::AddModelToJob($modelid, $jobid, $rate);
					
					
					// upload KYC image
					if (!empty($_FILES)) {
						if ($_FILES['kyc']['error'] != UPLOAD_ERR_OK) {
							switch ($_FILES['kyc']['error']) {
								case UPLOAD_ERR_INI_SIZE:
								case UPLOAD_ERR_FORM_SIZE:
									//too big
									$json['status'] = 1;
									$json['message'] = 'Please make sure your file is less than 10mb.';
									break;
								case UPLOAD_ERR_PARTIAL:
								case UPLOAD_ERR_NO_TMP_DIR:
								case UPLOAD_ERR_CANT_WRITE:
								case UPLOAD_ERR_EXTENSION:
									//various failures
									$json['status'] = 1;
									$json['error'] = 'An error occurred during upload, please refresh the page and try again.';
									break;
								case UPLOAD_ERR_NO_FILE:
								default:
									//no file
									$json['status'] = 1;
									$json['error'] = 'Please select a file to upload.';
									break;
							}
						} else {
							if (!in_array(strtolower(pathinfo($_FILES['kyc']['name'], PATHINFO_EXTENSION)), array('jpg','jpeg','png','bmp','gif'))) {
								$imageint = exif_imagetype($_FILES['kyc']['tmp_name']);
								if (!in_array($imageint, array(IMAGETYPE_BMP, IMAGETYPE_GIF, IMAGETYPE_JPEG, IMAGETYPE_JPEG2000, IMAGETYPE_PNG))) {
									$json['status'] = 1;
									$json['error'] = 'Sorry, we can only accept jpeg, jpg, png, bmp, or gif image file.';
								} else {
									$filename = Finda::UploadImage('kyc');
									if ($filename) {
										$userDetails = array();
										$userDetails['kyc_document'] = $filename['imageid'];
										User::UpdateUser($userDetails);
									} else {
										$json['status'] = 1;
										$json['message'] = 'An upload error occurred, please try again.';
									}
								}
							} else {
								$filename = Finda::UploadImage('kyc');
								if ($filename) {
									$userDetails = array();
									$userDetails['kyc_document'] = $filename['imageid'];
									User::UpdateUser($userDetails);
								} else {
									$json['status'] = 1;
									$json['message'] = 'An upload error occurred, please try again.';
								}
							}
						}
					}
				}
			} else {
				$json['status'] = 2;	// user creation error
			}
			Core::JSONWrite($json);
		}
		die();
		
	case 'request':
		$viewid = $args[1];
		$viewuser = array('status' => 0);
		$viewuser = Finda::LoadUserByReferrerCode($viewid, TYPE_MODEL);
		
		if ($viewuser['status'] == 1 || $viewuser['status'] == 99) {
			Core::Assign('model', $viewuser);
			
			// can request the model, so show the form
			if (User::UserID() != 0) {
				// we have a logged-in user
				Core::Assign('userid', User::UserID());
			} else {
				Core::Assign('userid', 0);
			}
			$template = 'models/book/requestmodel.tpl';
			
			$jobtypes = Finda::GetMinimumJobRates(1);
			Core::Assign('jobtypes', $jobtypes);

			Core::AddJavascript('vendor/zebra_datepicker.min.js');
			Core::AddJavascript('vendor/clockpicker-gh-pages/dist/jquery-clockpicker.js');
			Core::AddJavascript('vendor/cleave.js');
			
			Core::AddJavascript('models/bookmodel.js');
			
			Core::AddCSS('vendor/zebra/zebra_datepicker.css');
			Core::AddCSS('vendor/jquery-clockpicker.css');
			
			Core::AddCSS('models/bookmodel.css');
			
			$page_title = "Book ".$viewuser['firstname'];
			
		}
		break;
	default:
		$viewid = $args[0];
		$viewuser = array('status' => 0);
		$viewuser = Finda::LoadUserByReferrerCode($viewid, TYPE_MODEL);
		if ($viewuser['status'] == 1 || $viewuser['status'] == 99) {
			if ($viewuser['usertype'] == 1) {
				$model = $viewuser;
				$modelid = $model['id'];
				if (User::UserType() == TYPE_MODEL && $modelid != User::UserID()) {
					header('Location: /');
					die();
				}
			
				// we want the sefu if it exists for use in the template links
				Core::Assign('modelid', $modelid);
				if (!is_numeric($modelid)) {
					$modelid = User::GetIdFromSefu($modelid);
				}
				
				// this loads more data than Finda::GetuserByName
				$model = User::LoadUser($modelid);
				$model['instagram_followers'] = Utilities::ThousandsFormat($model['instagram_followers']);
				
				Core::AddJavascript('models/viewmodel.js');
				Core::Assign('model', $model);
				
				$jobtypes = Taxonomy::GetTermsByVocabulary(1, true);
				Core::Assign('jobtypes', $jobtypes);
		
				Core::AddCSS('models/viewmodel_directbooking.css');
				
				$page_title = 'Book '.$model['firstname'].' '.strtoupper(substr($model['lastname'], 0, 1));
				
				$template = 'models/book/bookmodel.tpl';
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

