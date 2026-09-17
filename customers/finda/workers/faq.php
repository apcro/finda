<?php
/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
namespace Croissant;

$template = 'faq.tpl';
$page_title = 'Frequently Asked Questions';
Core::AddCSS('register/register-modal.css');
Core::Assign('body_class', 'body-white');
Core::AddCSS('faq.css');

if ($args[0] == 'model') {
	$template = 'faq_model.tpl';
}
if ($args[0] == 'models') {
	$template = 'faq_model.tpl';
	Core::Assign('is_app', 1);
}