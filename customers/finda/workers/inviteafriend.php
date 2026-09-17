<?php
/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
namespace Croissant;

if (User::UserType() == 1) {
	// model base
	Core::Assign('body_class', 'body-purple');
} else {
	// client base
}

Core::AddCSS('model/offers.css');
$page_title = "Invite a Friend";
$template = "mobile/inviteafriend.tpl";