<?php
/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
namespace Croissant;

// temporary again
header('Location: /');
die();

Core::AddCSS('register/register-modal.css');
Core::AddCSS('team.css');

Core::AddJavascript('vendor/rgbaster.js');
Core::AddJavascript('team.js');

$template = 'team.tpl';
$page_title = 'About the team';
Core::Assign('body_class', 'body-blue team-body');