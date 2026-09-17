<?php
/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
namespace Croissant;

$template = 'requestdemo.tpl';
$page_title = 'Request a Demo';
Core::Assign('body_class', 'body-burgundy');
Core::AddCSS('register/register-modal.css');
Core::AddCSS('shared/demo.css');

Core::AddJavascript('vendor/cleave.js');
Core::AddJavascript('vendor/cleave-phone.gb.js');
Core::AddJavascript('demo.js');
Core::AddJavascript('register-modal.js');

if (IS_AJAX_REQUEST) {
	Core::Assign('personname', $personname);
	Core::Assign('jobtitle', $jobtitle);
	Core::Assign('workemail', $workemail);
	Core::Assign('companyname', $companyname);
	$html = nl2br(Core::Fetch('emails/demorequestemail.tpl'));
	SendGrid::SendCustomEmail('support@idal.co', 'Demo Request', $html);
	Core::JSONWrite(true);
	die();
}