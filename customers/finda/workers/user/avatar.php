<?php
/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
namespace Croissant;

switch($args[1]) {
	case 'upload':
		
		$imagetype = 'avatar';
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
							$template = 'user/avatar-error.tpl';
							break;
						case UPLOAD_ERR_NO_FILE:
							//no file
							$response['status'] = 0;
							$response['error'] = 'Please select a file to upload.';
							Core::Assign('error', $response);
							$template = 'user/avatar-error.tpl';
							break;
					}
				} else {
					if (!in_array(strtolower(pathinfo($_FILES[$imagetype]['name'], PATHINFO_EXTENSION)), array('jpg','jpeg','png','bmp','gif'))) {
						$response['status'] = 0;
						$response['error'] = 'Only jpeg, jpg, png, bmp, and gif files allowed.';
					} else {
						$filename = Finda::UploadImage($imagetype);
						header('Location: /user');
						die();
					}
				}
			} else {
				$response['status'] = 0;
				$response['error'] = 'Please select a file to upload.';
				Core::Assign('error', $response);
				$template = 'user/avatar-error.tpl';
			}
		}
		
		break;
	case 'edit':

		$u = User::LoadUser(User::UserID());
		if (User::UserType() == TYPE_MODEL) {
			Core::Assign('avatar', '/portfolio/source'.$u['leadimage']);
			Core::Assign('imageid', $u['leadimage_id']);
			Core::AddJavascript('user/avatar_edit.js');
			$page_title = 'Edit your profile image';
		} else {
			Core::Assign('avatar', '/avatar/thumb'.$u['avatar']);
			Core::AddJavascript('user/avatar_client_edit.js');
			$page_title = 'Edit your Avatar';
		}
		$template = 'user/avatar_edit.tpl';
		Core::AddCSS('user/avatar_edit.css');
		Core::AddCSS('vendor/jquery.guillotine.css');
		Core::AddJavascript('vendor/jquery.guillotine.js');
		Core::Assign('body_class','body-white');
		Core::Assign('grid_background', 'grid-bg-green');
		break;
	case 'update':
		if (IS_AJAX_REQUEST) {
			$response = Model::CreateAvatarFromSource($imageid, $data);
			Core::JSONWrite($response);
			die();
		}
		break;
	default:
		// show the default set of portfolio
		$template = 'user/avatar.tpl';
		Core::Assign('body_class','body-white');
		Core::Assign('grid_background', 'grid-bg-green');
		break;
}
