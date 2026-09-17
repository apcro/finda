<?php
/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
namespace Croissant;

// Mother Agency Dashboard

if (User::UserID() == 0) {
	header('Location: /');
	die();
}

if (User::UserType() != TYPE_MOTHERAGENCY) {
	header('Location: /');
	die();
}

// used by every page, if not an AJAX request
if (!IS_AJAX_REQUEST) {
	Core::AddCSS('motheragencies.css');
}

$secondary = $args[0];
Core::Assign('secondary', $secondary);
switch ($secondary) {
	case 'upload':
		if (IS_AJAX_REQUEST) {
			$imagetype = $args[1];
			$uid = $args[2];

			$response = array('status' => 1);
			if (!empty($_FILES)) {
				if ($_FILES[$imagetype]['error'] != UPLOAD_ERR_OK) {
					switch ($_FILES[$imagetype]['error']) {
						case UPLOAD_ERR_INI_SIZE:
						case UPLOAD_ERR_FORM_SIZE:
							//too big
							$response['status'] = 0;
							$response['error'] = 'Please make sure your file is less than 20mb.';
							break;
						case UPLOAD_ERR_PARTIAL:
						case UPLOAD_ERR_NO_TMP_DIR:
						case UPLOAD_ERR_CANT_WRITE:
						case UPLOAD_ERR_EXTENSION:
							//various failures
							$response['status'] = 0;
							$response['error'] = 'An error occurred during upload, please refresh the page and try again.';
							break;
						case UPLOAD_ERR_NO_FILE:
							//no file
							$response['status'] = 0;
							$response['error'] = 'Please select a file to upload.';
							break;
					}
				} else {
					if (!in_array(strtolower(pathinfo($_FILES[$imagetype]['name'], PATHINFO_EXTENSION)), array('jpg','jpeg','png','bmp','gif', 'pdf'))) {
						$imageint = exif_imagetype($_FILES[$imagetype]['tmp_name']);
						if (!in_array($imageint, array(IMAGETYPE_BMP, IMAGETYPE_GIF, IMAGETYPE_JPEG, IMAGETYPE_JPEG2000, IMAGETYPE_PNG))) {
							$response['status'] = 0;
							$response['error'] = 'Sorry, we can only accept jpeg, jpg, png, bmp or gif image files, or PDF files.';
						} else {
							$filename = Finda::UploadImage($imagetype, $uid);
							if ($filename) {
								$response['status'] = 1;
								$response['message'] = 'Your image has been saved.';
								$response['filename'] = $filename['filename'];
								$response['response'] = $filename;
							} else {
								$response['status'] = 0;
								$response['uploaderror'] = $filename;
								$response['error'] = 'An upload error occurred, please try again.';
							}
						}
					} else {
						$filename = Finda::UploadImage($imagetype, $uid);
						if ($filename) {
							$response['status'] = 1;
							$response['message'] = 'Your image has been saved.';
							$response['filename'] = $filename['filename'];
							$response['response'] = $filename;
						} else {
							$response['status'] = 0;
							$response['uploaderror'] = $filename;
							$response['error'] = 'An upload error occurred, please try again.';
						}
					}
				}
			} else {
				$response['status'] = 0;
				$response['error'] = 'Please select a file to upload.';
			}
		}
		die();
		break;
	case 'images':
		$modelid = $args[1];
		$motheragency = MotherAgencies::LoadMotherAgencyForClient(User::UserID());
		$model = User::LoadUser($modelid);
		Core::Assign('model', $model);
		if (MotherAgencies::IsModelInMotherAgency($modelid, $motheragency['id'])) {
			Core::Assign('modelid', $args[1]);
			$template = 'motheragencies/newupload.tpl';
			Core::AddCSS('vendor/dropzone/dropzone.css');
			// http://www.dropzonejs.com/
			Core::AddJavascript('vendor/dropzone/dropzone.js');
			Core::AddJavascript('motheragencies/upload-form.js');
			$page_title = 'Upload new images';
		} else {
			header('Location: /');
			die();
		}
		break;
	case 'makeleader':
		if (IS_AJAX_REQUEST) {
			$response = Finda::MakeImageLeader($id, $modelid);
			Core::JSONWrite($response);
		}
		die();
		break;
	case 'removeimage':
		if (IS_AJAX_REQUEST) {
			$response = Finda::RemoveUserImage($id, $modelid);
			Core::JSONWrite($response);
		}
		die();
		break;
	case 'saveorder':
		if (IS_AJAX_REQUEST) {
			$response = Finda::SaveImageOrder(implode(',', $order), $type, $modelid);
			Core::JSONWrite($response);
		} else {
			Core::JSONWrite(false);
		}
		die();
	case 'viewinvoice':
		$invoiceid = $args[1];
		$invoice = Finance::RetrieveInvoiceDetails($invoiceid);
		$jobdetails = Jobs::GetJobDetails($invoice['jobid']);
		$fees = Jobs::GetJobValueByInvoiceId($invoiceid);
		
		Core::Assign('fees', $fees);
		
		Core::Assign('invoice', $invoice);
		Core::Assign('jobdetails', $jobdetails);
		$motheragency = MotherAgencies::LoadMotherAgencyForClient(User::UserID());
		Core::Assign('motheragency', $motheragency['id']);
		
		Core::AddCSS('user/invoices.css');
		
		$page_title = 'Invoice: '.$jobdetails['name'];
		$template = 'motheragencies/agency_view_invoice.tpl';
		
		break;
	case 'invoices':
		$page_title = 'Invoices';
		// get all agency invoices
		$motheragency = MotherAgencies::LoadMotherAgencyForClient(User::UserID());
		$invoices = Finance::RetrieveMotherAgencyInvoices($motheragency['id']);
		
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
				$models = Jobs::ClientGetModelsForJob($invoice['jobid']);
				foreach ($models as $mk => $model) {
					if ($model['mother_agency'] != $motheragency['id']) {
						unset($models[$mk]);
					}
				}
				$invoices[$k]['models'] = $models;
			}
			if ($invoice['status'] == 1) {
				$outstanding += $invoice['value'];
			}
		}
		Core::Assign('invoices', $invoices);
		
		Core::AddJavascript('user/paymentslist.js');
		Core::AddJavascript('jobs/joblist.js');
		Core::AddCSS('user/invoices.css');
		$template = 'motheragencies/agency_invoices.tpl';
		break;
	case 'modelinvoices':
		// get all invoices for agency models
		break;
	case 'assignments':
		$page_title = 'Model Assignments';
		$motheragency = MotherAgencies::LoadMotherAgencyForClient(User::UserID());
		Core::Assign('motheragency', $motheragency);
		$jobs = MotherAgencies::LoadJobsForMotherAgency($motheragency['id']);
		Core::Assign('jobs', $jobs);
		
		Core::AddJavascript('jobs/joblist.js');
		Core::AddCSS('jobcard.css');
		Core::AddCSS('joblist.css');
		$template = 'motheragencies/projects.tpl';
		break;
		
	case 'manage':
		$modelid = $args[1];
		
		$motheragency = MotherAgencies::LoadMotherAgencyForClient(User::UserID());
		if (MotherAgencies::IsModelInMotherAgency($modelid, $motheragency['id'])) {
			$model = User::LoadUser($modelid);
			Core::Assign('user', $model);
			
			$page_title = 'Manage '.$model['firstname'];
			
			$details['shoesizes'] = array();
			$details['shoesizes'][] = array('description' => 'UK 2 (US 4, EU 35)', 'value' => 2);
			$details['shoesizes'][] = array('description' => 'UK 2.5 (US 4,5, EU 35)', 'value' => 2.5);
			$details['shoesizes'][] = array('description' => 'UK 3 (US 5, EU 35-36)', 'value' => 3);
			$details['shoesizes'][] = array('description' => 'UK 3.5 (US 5.5, EU 36)', 'value' => 3.5);
			$details['shoesizes'][] = array('description' => 'UK 4 (US 6, EU 36-37)', 'value' => 4);
			$details['shoesizes'][] = array('description' => 'UK 4.5 (US 6.5, EU 37)', 'value' => 4.5);
			$details['shoesizes'][] = array('description' => 'UK 5 (US 7, EU 37-38)', 'value' => 5);
			$details['shoesizes'][] = array('description' => 'UK 5.5 (US 7.5, EU 38)', 'value' => 5.5);
			$details['shoesizes'][] = array('description' => 'UK 6 (US 8, EU 38-39)', 'value' => 6);
			$details['shoesizes'][] = array('description' => 'UK 6.5 (US 8.5, EU 39)', 'value' => 6.5);
			$details['shoesizes'][] = array('description' => 'UK 7 (US 9, EU 39-40)', 'value' => 7);
			$details['shoesizes'][] = array('description' => 'UK 7.5 (US 9.5, EU 40)', 'value' => 7.5);
			$details['shoesizes'][] = array('description' => 'UK 8 (US 10, EU 40-41)', 'value' => 8);
			$details['shoesizes'][] = array('description' => 'UK 8.5 (US 10.5, EU 41)', 'value' => 8.5);
			$details['shoesizes'][] = array('description' => 'UK 9 (US 11, EU 41-42)', 'value' => 9);
			$details['shoesizes'][] = array('description' => 'UK 9.5 (US 11.5, EU 42)', 'value' => 9.5);
			$details['shoesizes'][] = array('description' => 'UK 10 (US 12, EU 42-43)', 'value' => 10);
			$details['shoesizes'][] = array('description' => 'UK 10.5 (US 12.5, EU 42-43)', 'value' => 10.5);
			$details['shoesizes'][] = array('description' => 'UK 11 (US 13, EU 46)', 'value' => 11);
			$details['shoesizes'][] = array('description' => 'UK 12 (US 14, EU 47)', 'value' => 12);
			$details['shoesizes'][] = array('description' => 'UK 13 (US 15, EU 48)', 'value' => 13);
			$details['shoesizes'][] = array('description' => 'UK 14 (US 15, EU 49-50)', 'value' => 14);
			
			$details['dresssizes'] = array();
			$details['dresssizes'][] = array('description' => 'UK 4 (US 0, EU 32)', 'value' => 4);
			$details['dresssizes'][] = array('description' => 'UK 6 (US 4, EU 34)', 'value' => 6);
			$details['dresssizes'][] = array('description' => 'UK 8 (US 6, EU 36)', 'value' => 8);
			$details['dresssizes'][] = array('description' => 'UK 10 (US 8, EU 38)', 'value' => 10);
			$details['dresssizes'][] = array('description' => 'UK 12 (US 10, EU 40)', 'value' => 12);
			$details['dresssizes'][] = array('description' => 'UK 14 (US 12, EU 42)', 'value' => 14);
			$details['dresssizes'][] = array('description' => 'UK 16 (US 14, EU 44)', 'value' => 16);
			$details['dresssizes'][] = array('description' => 'UK 18 (US 16, EU 46)', 'value' => 18);
			$details['dresssizes'][] = array('description' => 'UK 20 (US 18, EU 48)', 'value' => 20);
			$details['dresssizes'][] = array('description' => 'UK 22 (US 20, EU 50)', 'value' => 22);
			
			$details['suitsize'] = array();
			$details['suitsize'][] = array('description' => 'UK/US 36, EU 46', 'value' => 36);
			$details['suitsize'][] = array('description' => 'UK/US 38, EU 48', 'value' => 38);
			$details['suitsize'][] = array('description' => 'UK/US 40, EU 50', 'value' => 40);
			$details['suitsize'][] = array('description' => 'UK/US 42, EU 52', 'value' => 42);
			$details['suitsize'][] = array('description' => 'UK/US 44, EU 54', 'value' => 44);
			$details['suitsize'][] = array('description' => 'UK/US 46, EU 56', 'value' => 46);
			$details['suitsize'][] = array('description' => 'UK/US 48, EU 58', 'value' => 48);
			$details['suitsize'][] = array('description' => 'UK/US 50, EU 60', 'value' => 50);
			$details['suitsize'][] = array('description' => 'UK/US 52, EU 62', 'value' => 52);
			$details['suitsize'][] = array('description' => 'UK/US 54, EU 64', 'value' => 54);
			$details['suitsize'][] = array('description' => 'UK/US 56, EU 66', 'value' => 56);
			
			if ($u['gender'] == 'other') {
				$merged = array_merge($details['dresssizes'], $details['suitsize']);
				$details['suitsize'] = $merged;
			}
			Core::Assign('details', $details);
			
			$user_locations = Taxonomy::GetTermsByVocabulary(18);	// locations
			Core::Assign('user_locations', $user_locations);
			
			$hairlengths = Taxonomy::GetTermsByVocabulary(5, true);	// hair length VID
			Core::Assign('hairlengths', $hairlengths);
			$hairtypes = Taxonomy::GetTermsByVocabulary(3, true);	// hair types VID
			Core::Assign('hairtypes', $hairtypes);
			$haircolours = Taxonomy::GetTermsByVocabulary(6, true);	// hair colours VID
			Core::Assign('haircolours', $haircolours);
			$eyecolours = Taxonomy::GetTermsByVocabulary(4, true);	// eye colours VID
			Core::Assign('eyecolours', $eyecolours);
			$jobtypes = Taxonomy::GetTermsByVocabulary(1, true);
			Core::Assign('jobtypes', $jobtypes);
			$ethnicity = Taxonomy::GetTermsByVocabulary(7, true);
			Core::Assign('ethnicity', $ethnicity);
			
			$skintones = Taxonomy::GetTermsByVocabulary(22, true);
			Core::Assign('skintones', $skintones);
			
			$data = Finda::GetUserImages('portfolio', $modelid);
			Core::Assign('portfolioimages', $data);
			
			$data = Finda::GetUserImages('polaroids', $modelid);
			Core::Assign('polaroids', $data);
			
			Core::AddJavascript('vendor/zebra_datepicker.min.js');
			
			Core::AddJavascript('user/profileedit.js');
			Core::AddJavascript('motheragencies/manageuser.js');
			Core::AddJavascript('vendor/cleave.js');
			Core::AddJavascript('vendor/cleave-phone.gb.js');
			Core::AddJavascript('vendor/sortable.min.js');
			
			Core::AddCSS('vendor/zebra/zebra_datepicker.css');
			Core::AddCSS('user/profileedit.css');
			Core::AddCSS('portfolio/portfolio.css');
			Core::AddCSS('polaroids/polaroids.css');
			
			$template = 'motheragencies/modeldetails.tpl';
		} else {
			header('Location: /');
			die();
		}
		break;
	default:
		$motheragency = MotherAgencies::LoadMotherAgencyForClient(User::UserID());
		if ($motheragency['id'] != 0) {
			Core::Assign('motheragency', $motheragency);
			
			$models = MotherAgencies::LoadModelsForMotherAgency($motheragency['id']);
			Core::Assign('agencymodels', $models);
			
			$stats = MotherAgencies::GetMotherAgencyStats($motheragency['id']);
			Core::Assign('stats', $stats);
			
			$page_title = $motheragency['agencyname']." Dashboard";
			$template = 'motheragencies/dashboard.tpl';
		} else {
			$page_title = "Mother Agency Dashboard";
			$template = 'motheragencies/notready_dashboard.tpl';
		}
		break;	
}
