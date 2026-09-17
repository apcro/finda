<?php
/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
namespace Croissant;

$template = 'modelwithus.tpl';
$page_title = 'Model With Us';
Core::AddCSS('modelwithus.css');

if (User::UserID() == 0) {
	Core::AddCSS('register/register-modal.css');
	Core::AddJavascript('vendor/cleave.js');
	Core::AddJavascript('vendor/cleave-phone.gb.js');
	Core::AddJavascript('modelwithus.js');
	Core::AddJavascript('register-modal.js');
}