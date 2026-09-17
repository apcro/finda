<?php
/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
namespace Croissant;

$page_title = 'Apply to be a Founding Member!';
$template = 'fmp.tpl';
Core::Assign('body_class', 'body-white');
Core::AddCSS('faq.css');
Core::AddCSS('fmp.css');
Core::AddJavascript('fmp.js');

if (IS_AJAX_REQUEST) {
	$result = true;
	if (!empty($loc)) {
		$result = false;
	} else {
		// process post data
		Core::Assign('company', $company);
		Core::Assign('name', $name);
		Core::Assign('email', $email);
		Core::Assign('phone', $phone);
		Core::Assign('address', $address);
		Core::Assign('website', $website);
		$html = Core::Fetch('emails/staff/new_foundingmemberapplication.tpl');
		$emails = array();
		$emails[] = 'tom@idal.co';
		$emails[] = 'mariya@idal.co';
		$result = SendGrid::SendCustomEmail($emails, 'New founding member application', $html);
	}
	Core::JSONWrite($result);
	die();
}