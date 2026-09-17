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

// handle portfolio image uploads
if (!isset($action)) {
	if (isset($args[1])) {
		$action = $args[1];
	}
}
switch($action) {
	case 'saveorder':
		if (IS_AJAX_REQUEST) {
			$response = Finda::SaveImageOrder(implode(',', $order), $type);
			Core::JSONWrite($response);
		} else {
			Core::JSONWrite(false);
		}
		die();
	case 'upload':
		$imagetype = 'portfolio';
		include('user/fileupload.php');
		die();
		break;
	case 'delete':
		// mostly an AJAX function
		$response = Finda::RemoveUserImage($id);
		Core::JSONWrite($response);
		die();
		break;
	case 'makeleader':
		// mostly an AJAX function
		$response = Finda::MakeImageLeader($id);
		Core::JSONWrite($response);
		die();
		break;
	case 'new':
		$template = 'user/portfolio/newupload.tpl';
		Core::AddCSS('vendor/dropzone/dropzone.css');

		// http://www.dropzonejs.com/
		Core::AddJavascript('vendor/dropzone/dropzone.js');
		Core::AddJavascript('portfolio/upload-form.js');
		
		Core::AddCSS('model/imageupload.css');
		$page_title = 'Upload new Portfolio images';
		break;
	default:
		// show the default set of portfolio
		$portfolio = Finda::GetUserImages('portfolio');
		Core::Assign('portfolioimages', $portfolio);
		Core::Assign('sefu', User::Sefu());
		Core::AddCSS('portfolio/portfolio.css');
		Core::AddJavascript('vendor/sortable.min.js');
		Core::AddJavascript('portfolio/portfolio.js');
		$template = 'user/portfolio/portfolio.tpl';
		$page_title = 'Portfolio images';
		Core::Assign('body_class', 'body-blue');
		Core::Assign('grid_background', 'grid-bg-green');
		Core::Assign('secondary', 'portfolio');
		break;
}
