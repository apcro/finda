<?php
/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
namespace Croissant;

Core::AddCSS('welcome.css');
Core::AddCSS('faq.css');
Core::Assign('body_class', 'bg-white');
$template = 'mobile/m.website.tpl';