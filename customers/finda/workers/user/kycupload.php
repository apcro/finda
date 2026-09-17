<?php
/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
namespace Croissant;

// this is an AJAX file

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
					break;
				case UPLOAD_ERR_NO_FILE:
					//no file
					$response['status'] = 0;
					$response['error'] = 'Please select a file to upload.';
					break;
			}
		} else {
			if (!in_array(strtolower(pathinfo($_FILES[$imagetype]['name'], PATHINFO_EXTENSION)), array('jpg','jpeg','png','bmp','gif'))) {
				$response['status'] = 0;
				$response['error'] = 'Only jpeg, jpg, png, bmp, and gif files allowed.';
			} else {
				$filename = Finda::UploadImage($imagetype);
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
	die();
}
