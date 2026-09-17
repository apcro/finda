<?php
/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
namespace Croissant;

// page-specific settings
$page_title = 'iDAL is a platform and a community for talent';

$template = 'homepage/welcome.tpl';

// if the user is not logged in, we don't run any of the following
if (User::UserID() != 0) {

	header('Location: /user');
	die();

} else {
	Core::AddCSS('welcome.css');
	Core::AddCSS('finda-mobile.css');
	Core::AddJavascript('register-modal.js', 'footer');
	Core::AddCSS('register/register-modal.css');
	Core::AddJavascript('vendor/glide.min.js');
	Core::AddJavascript('vendor/rgbaster.js');
	Core::AddJavascript('welcome.js');
	
	Core::AddJavascript('vendor/cleave.js');
	Core::AddJavascript('vendor/cleave-phone.gb.js');
	Core::AddCSS('vendor/glide.core.min.css');
	Core::Assign('body_class', 'body-blue');
	
	$modelcount = Finda::GetVerifiedModelCount();
	Core::Assign('modelcount', $modelcount);
	
	$user_locations = Taxonomy::GetTermsByVocabulary(18);	// locations
	Core::Assign('user_locations', $user_locations);
}
