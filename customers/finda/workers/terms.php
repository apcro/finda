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
Core::AddCSS('faq.css');
$page_title = 'Terms and Conditions of use';
Core::Assign('body_class', 'body-white');
Core::Assign('grid_background', 'grid-bg-green');
switch($args[0]) {
	case 'model':
		$template = 'shared/model.terms.tpl';
		$page_title .= ' - Model Terms';
		break;
	case 'client':
	case 'booking':
		$template = 'shared/client.terms.tpl';
		$page_title .= ' - Client Terms';
		break;
	default:
		$template = 'shared/terms.tpl';
		break;
}