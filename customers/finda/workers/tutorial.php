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
Core::AddCSS('tutorial.css');

Core::AddJavascript('tutorial.js');

$template = 'tutorial.tpl';
$page_title = 'How to book with iDAL';
Core::Assign('body_class', 'body-blue tutorial-body');