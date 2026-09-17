<?php
/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
namespace Croissant;

$page_title = 'How to use iDAL';
Core::AddCSS('register/register-modal.css');
Core::AddCSS('howitworks.css');

if (User::UserID() == 0) {
	$template = 'howitworks/howitworks.tpl';
	Core::AddJavascript('register-modal.js');
} else {
	if (User::UserType() == 1) {
		$template = 'howitworks/howitworks.tpl';
	} else {
		$template = 'howitworks/howitworks_client.tpl';
	}
}
