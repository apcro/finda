<?php
/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
namespace Croissant;

$template = 'user/account.delete.tpl';
Core::AddJavascript('user/deleteaccount.js');
Core::Assign('grid_background', 'grid-bg-delete');