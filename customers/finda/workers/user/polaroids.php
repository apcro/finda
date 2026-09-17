<?php
/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
namespace Croissant;

if (User::UserType() == TYPE_CLIENT) {
	header('Location: /');
	die();
}
// handle polaroid image uploads
if (!isset($action)) {
	if (isset($args[1])) {
		$action = $args[1];
	}
}
switch($action) {
	case 'rotate':
		$result = Finda::Rotateimage($imageid, $angle, 'polaroids');
		Core::JSONWrite($result);
		die();
		break;
	case 'upload':
		$imagetype = 'polaroids';
		include('user/fileupload.php');
		die();
		break;
	case 'delete':
		// mostly an AJAX function
		$response = Finda::RemoveUserImage($id);
		header('Content-Type: application/json; charset=utf-8');
		header('HTTP/1.0 200 OK', 200);
		print json_encode($response);
		die();
		break;
	case 'makeleader':
		// mostly an AJAX function
		$response = Finda::MakeImageLeader($id, 'polaroids');
		header('Content-Type: application/json; charset=utf-8');
		header('HTTP/1.0 200 OK', 200);
		print json_encode($response);
		die();
		break;
	case 'new':
		$template = 'user/polaroids/newupload.tpl';
		Core::AddCSS('vendor/dropzone/dropzone.css');

		// http://www.dropzonejs.com/
		Core::AddJavascript('vendor/dropzone/dropzone.js');
		Core::AddJavascript('polaroids/upload-form.js');
		Core::AddCSS('model/imageupload.css');
		$page_title = 'Upload new Polaroids';
		Core::Assign('body_class', 'body-blue');
		break;
	default:
		// show the default set of polaroids
		$polaroids = Finda::GetUserImages('polaroids');
		Core::Assign('polaroids', $polaroids);
		Core::Assign('sefu', User::Sefu());
		Core::AddCSS('polaroids/polaroids.css');
		Core::AddJavascript('vendor/sortable.min.js');
		Core::AddJavascript('polaroids/polaroids.js');
		$template = 'user/polaroids/polaroids.tpl';
		$page_title = 'Polaroids';
		Core::Assign('body_class', 'body-blue');
		Core::Assign('grid_background', 'grid-bg-green');
		Core::Assign('secondary', 'polaroids');
		break;
}
