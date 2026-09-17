<?php
/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
namespace Croissant;

Core::AddCSS('register/register-modal.css');
Core::AddCSS('modellaw.css');
$page_title = 'Model Law x iDAL - Coming soon';
$template = 'modellaw.tpl';

if (User::UserID() == 0) {
	Core::AddCSS('register/register-modal.css');
	Core::AddJavascript('vendor/cleave.js');
	Core::AddJavascript('vendor/cleave-phone.gb.js');
	Core::AddJavascript('mission.js');
	Core::AddJavascript('register-modal.js');
}