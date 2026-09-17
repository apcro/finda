<?php
/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
namespace Croissant;

$os = strtolower(php_uname());
$pos = strpos($os, 'windows');

if ($pos === false) {
	$seperator = '/';
} else {
	$seperator = '\\';
}

defined('SEPERATOR') || define('SEPERATOR', $seperator);

$path = explode($seperator, dirname(__FILE__));

// lose the current path - /configuration
array_pop($path);

// this is the actual customer
$client = array_pop($path);
define('CLIENT', $client);

// this is the subfolder we're storing customer code ine
$store = array_pop($path);

// reset the path
$rootpath = implode($seperator, $path);
$path = $rootpath.$seperator.$store.$seperator.$client;
require_once('local.configuration.php');

defined('USE_SHARED_CORE') || define('USE_SHARED_CORE', false);

define('ROOTPATH', $rootpath);
define('BASEPATH', $path);

define('DOCROOT', BASEPATH.'/docroot');

define('SMARTY_TEMPLATE',	BASEPATH.'/templates');
define('SMARTY_COMPILE',	CACHEPATH.'/templates_c');
define('SMARTY_CACHE',		CACHEPATH.'/smarty_cache');

define('NOTFOUND',		'shared/error/404.tpl');
define('SERVERERROR',	'shared/error/500.tpl');
define('NOTEMPLATE',	'shared/error/notemplate.tpl');
define('NOVIDEO',		'shared/error/video404.tpl');

defined('ENABLE_IPAD') || define('ENABLE_IPAD', 1);
defined('ENABLE_IPHONE') || define('ENABLE_IPHONE', 1);

// should we use browser caching?
defined('USE_CACHING') || define('USE_CACHING', false);

const OK	= 0;
const NOTOK	= 1;

// File caching definitions
define('FILECACHE', CACHEPATH);

define('STATELESS', 0); // 0 == normal, 1 = load session data from the dataserver

// Default Text for META data
define('DEFAULT_PAGE_TITLE',	'');
define('DEFAULT_PAGE_META',		'');
define('DEFAULT_PAGE_KEYWORDS',	'');

// Base template
defined('BASE_TEMPLATE') || define('BASE_TEMPLATE', 'shared/default.tpl');
define('IPINFODB_KEY' , '' ) ;

define('IS_AJAX_REQUEST', (!empty($_SERVER['HTTP_X_REQUESTED_WITH']) && strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest'));

// now we get can the core library, if not a CSS file
if (!strpos($_SERVER['SCRIPT_NAME'], 'images')) {
	require_once(ROOTPATH.'/libraries/core/core.library.php');

	// define any external libraries used in this application
	Core::UsesClass('Smarty', ROOTPATH.'/libraries/external/Smarty-3.1.10/libs/Smarty.class.php');
}

// Specific to Finda
defined('TYPE_MODEL') || define('TYPE_MODEL', 1);
defined('TYPE_CLIENT') || define('TYPE_CLIENT', 2);
defined('TYPE_MOTHERAGENCY') || define('TYPE_MOTHERAGENCY', 3);

defined('FINDA_CLIENT_MARKUP') || define ('FINDA_CLIENT_MARKUP', 10);	// expressed as a percentage
defined('FINDA_MODEL_MARKUP') || define ('FINDA_MODEL_MARKUP', 10);	// expressed as a percentage
defined('FINDA_PAYMENT_DUE_DAYS') || define ('FINDA_PAYMENT_DUE_DAYS', 14);
defined('FINDA_MINIMUM_DAYS_AHEAD') || define ('FINDA_MINIMUM_DAYS_AHEAD', 0);
defined('VAT_RATE') || define ('VAT_RATE', 20/100);
defined('DEFAULT_AVATAR') || define('DEFAULT_AVATAR', '/images/user/avatars/default_profile.png');

defined('MESSAGE_TYPE_OFFER') || define('MESSAGE_TYPE_OFFER', 1);
defined('MESSAGE_TYPE_ACCEPT') || define('MESSAGE_TYPE_ACCEPT', 2);
defined('MESSAGE_TYPE_REJECT') || define('MESSAGE_TYPE_REJECT', 3);
defined('MESSAGE_TYPE_NEGOTIATE') || define('MESSAGE_TYPE_NEGOTIATE', 4);
defined('MESSAGE_TYPE_COMPLETE') || define('MESSAGE_TYPE_COMPLETE', 5);
defined('MESSAGE_TYPE_NORMAL') || define('MESSAGE_TYPE_NORMAL', 6);
defined('MESSAGE_TYPE_PAYMENT') || define('MESSAGE_TYPE_PAYMENT', 7);
defined('MESSAGE_TYPE_CANCEL') || define('MESSAGE_TYPE_CANCEL', 8);
defined('MESSAGE_TYPE_CANCELACCEPTANCE') || define('MESSAGE_TYPE_CANCELACCEPTANCE', 9);
defined('MESSAGE_TYPE_ADDED_CALLSHEET') || define('MESSAGE_TYPE_ADDED_CALLSHEET', 10);
defined('MESSAGE_TYPE_REJECT_OPTION') || define('MESSAGE_TYPE_REJECT_OPTION', 11);
defined('MESSAGE_TYPE_CONFIRMED') || define('MESSAGE_TYPE_CONFIRMED', 12);
defined('MESSAGE_TYPE_COMPOSED') || define('MESSAGE_TYPE_COMPOSED', 14);
defined('MESSAGE_TYPE_COMPOSED_FLAGGED') || define('MESSAGE_TYPE_COMPOSED_FLAGGED', 15);

// chat attachment types
defined('MESSAGE_TYPE_COMPOSED_IMAGE') || define('MESSAGE_TYPE_COMPOSED_IMAGE', 16);
defined('MESSAGE_TYPE_COMPOSED_PDF') || define('MESSAGE_TYPE_COMPOSED_PDF', 17);

// for tracking message secondary states
defined('MESSAGE_TYPE_OFFER_NEGOTIATED') || define('MESSAGE_TYPE_OFFER_NEGOTIATED', 7);
defined('MESSAGE_TYPE_OFFER_ACCEPTED') || define('MESSAGE_TYPE_OFFER_ACCEPTED', 8);
defined('MESSAGE_TYPE_OFFER_REJECTED') || define('MESSAGE_TYPE_OFFER_REJECTED', 9);

// for tracking job statuses
defined('JOB_ASSIGNMENT_STATUS_PENDING') || define('JOB_ASSIGNMENT_STATUS_PENDING', 0);
defined('JOB_ASSIGNMENT_STATUS_OFFERED') || define('JOB_ASSIGNMENT_STATUS_OFFERED', 1);
defined('JOB_ASSIGNMENT_STATUS_ACCEPTED') || define('JOB_ASSIGNMENT_STATUS_ACCEPTED', 2);
defined('JOB_ASSIGNMENT_STATUS_MODEL_CANCELLED') || define('JOB_ASSIGNMENT_STATUS_MODEL_CANCELLED', 3);
defined('JOB_ASSIGNMENT_STATUS_CLIENT_CANCELLED') || define('JOB_ASSIGNMENT_STATUS_CLIENT_CANCELLED', 4);
defined('JOB_ASSIGNMENT_STATUS_MODEL_COMPLETED') || define('JOB_ASSIGNMENT_STATUS_MODEL_COMPLETED', 5);
defined('JOB_ASSIGNMENT_STATUS_CLIENT_COMPLETED') || define('JOB_ASSIGNMENT_STATUS_CLIENT_COMPLETED', 6);
defined('JOB_ASSIGNMENT_STATUS_COMPLETED') || define('JOB_ASSIGNMENT_STATUS_COMPLETED', 7);

defined('JOB_ASSIGNMENT_STATUS_CLIENT_SELECTED') || define('JOB_ASSIGNMENT_STATUS_CLIENT_SELECTED', 9);
defined('JOB_ASSIGNMENT_STATUS_CLIENT_OPTIONED') || define('JOB_ASSIGNMENT_STATUS_CLIENT_OPTIONED', 10);
defined('JOB_ASSIGNMENT_STATUS_SHARE_SELECTED') || define('JOB_ASSIGNMENT_STATUS_SHARE_SELECTED', 11);
defined('JOB_ASSIGNMENT_STATUS_MODEL_REJECTED_OPTION') || define('JOB_ASSIGNMENT_STATUS_MODEL_REJECTED_OPTION', 12);

defined('JOB_ASSIGNMENT_STATUS_MODEL_ACCEPTED_OPTION') || define('JOB_ASSIGNMENT_STATUS_MODEL_ACCEPTED_OPTION', 14);
defined('JOB_ASSIGNMENT_STATUS_ACCEPTED_CONFIRMED') || define('JOB_ASSIGNMENT_STATUS_ACCEPTED_CONFIRMED', 16);
defined('JOB_ASSIGNMENT_STATUS_CLIENT_REMOVED') || define('JOB_ASSIGNMENT_STATUS_CLIENT_REMOVED', 20);
