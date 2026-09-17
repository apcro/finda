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
Core::Assign('body_class', 'body-white');
Core::Assign('grid_background', 'grid-bg-green');


switch($args[1]) {
	case 'upload':
		$imagetype = 'kyc';
		if (DEBUG) _log(__CLASS__.'::'.__FUNCTION__);
		$uid = User::UserID();
		if ($uid != 0) {
			$response = array('status' => 1);
			if (!empty($_FILES)) {
				if ($_FILES[$imagetype]['error'] != UPLOAD_ERR_OK) {
					switch ($_FILES[$imagetype]['error']) {
						case UPLOAD_ERR_INI_SIZE:
						case UPLOAD_ERR_FORM_SIZE:
							//too big
							$response['status'] = 0;
							$response['error'] = 'Please make sure your file is less than 10mb.';
							break;
						case UPLOAD_ERR_PARTIAL:
						case UPLOAD_ERR_NO_TMP_DIR:
						case UPLOAD_ERR_CANT_WRITE:
						case UPLOAD_ERR_EXTENSION:
							//various failures
							$response['status'] = 0;
							$response['error'] = 'An error occurred during upload, please refresh the page and try again.';
							Core::Assign('error', $response);
							$template = 'user/verify-error.tpl';
							break;
						case UPLOAD_ERR_NO_FILE:
							//no file
							$response['status'] = 0;
							$response['error'] = 'Please select a file to upload.';
							Core::Assign('error', $response);
							$template = 'user/verify-error.tpl';
							break;
					}
				} else {
					if (!in_array(strtolower(pathinfo($_FILES[$imagetype]['name'], PATHINFO_EXTENSION)), array('jpg','jpeg','png','bmp','gif'))) {
						$imageint = exif_imagetype($_FILES[$imagetype]['tmp_name']);
						if (!in_array($imageint, array(IMAGETYPE_BMP, IMAGETYPE_GIF, IMAGETYPE_JPEG, IMAGETYPE_JPEG2000, IMAGETYPE_PNG))) {
							$response['status'] = 0;
							$response['error'] = 'Sorry, we can only accept jpeg, jpg, png, bmp, or gif image file.';
							Core::Assign('error', $response);
							if ($ismobile == 'yes') {
								$template = 'mobile/m.verify-error.tpl';
								Core::AddCSS('m.loggedin.css');
								Core::Assign('grid_background', '');
								Core::Assign('body_class', '');
							} else {
								$template = 'user/verify-error.tpl';
							}
						} else {
							$filename = Finda::UploadImage($imagetype);
							if ($filename) {
								$response['status'] = 1;
								$response['message'] = 'Your image has been saved.';
								$response['filename'] = $filename['filename'];
								$response['response'] = $filename;
	
								$userDetails = array();
								$userDetails['kyc_document'] = $filename['imageid'];
								User::UpdateUser($userDetails);
								if ($ismobile == 'yes') {
									$template = 'mobile/m.verify-thanks.tpl';
									Core::AddCSS('m.loggedin.css');
									Core::Assign('grid_background', '');
									Core::Assign('body_class', '');
								} else {
									$template = 'user/verify-thanks.tpl';
								}
							} else {
								$response['status'] = 0;
								$response['uploaderror'] = $filename;
								$response['error'] = 'An upload error occurred, please try again.';
								Core::Assign('error', $response);
								if ($ismobile == 'yes') {
									$template = 'mobile/m.verify-error.tpl';
									Core::AddCSS('m.loggedin.css');
									Core::Assign('grid_background', '');
									Core::Assign('body_class', '');
								} else {
									$template = 'user/verify-error.tpl';
								}
							}
						}
					} else {
						$filename = Finda::UploadImage($imagetype);
						if ($filename) {
							$response['status'] = 1;
							$response['message'] = 'Your image has been saved.';
							$response['filename'] = $filename['filename'];
							$response['response'] = $filename;
							
							$userDetails = array();
							$userDetails['kyc_document'] = $filename['imageid'];
							User::UpdateUser($userDetails);
							if ($ismobile == 'yes') {
								$template = 'mobile/m.verify-thanks.tpl';
								Core::AddCSS('m.loggedin.css');
								Core::Assign('grid_background', '');
								Core::Assign('body_class', '');
							} else {
								$template = 'user/verify-thanks.tpl';
							}
						} else {
							$response['status'] = 0;
							$response['uploaderror'] = $filename;
							$response['error'] = 'An upload error occurred, please try again.';
							Core::Assign('error', $response);
							if ($ismobile == 'yes') {
								$template = 'mobile/m.verify-error.tpl';
								Core::AddCSS('m.loggedin.css');
								Core::Assign('grid_background', '');
								Core::Assign('body_class', '');
							} else {
								$template = 'user/verify-error.tpl';
							}
						}
					}
				}
			} else {
				$response['status'] = 0;
				$response['error'] = 'Please select a file to upload.';
				Core::Assign('error', $response);
				if ($ismobile == 'yes') {
					$template = 'mobile/m.verify-error.tpl';
					Core::AddCSS('m.loggedin.css');
					Core::Assign('grid_background', '');
					Core::Assign('body_class', '');
				} else {
					$template = 'user/verify-error.tpl';
				}
			}
		} else {
			$response['status'] = 0;
			$response['uploaderror'] = $filename;
			$response['error'] = 'Something went wrong, please try again.';
			Core::Assign('error', $response);
			if ($ismobile == 'yes') {
				$template = 'mobile/m.verify-error.tpl';
				Core::AddCSS('m.loggedin.css');
				Core::Assign('grid_background', '');
				Core::Assign('body_class', '');
			} else {
				$template = 'user/verify-error.tpl';
			}
		}
		break;
	default:
		// show the default set of portfolio
		$u = User::LoadUser(User::UserID());
		Core::Assign('kycdoc', $u['originalname']);
		Core::Assign('is_founding_member', $u['is_founding_member']);
		$template = 'user/verify.tpl';
		$page_title = 'Please verify your account';
		break;
}
