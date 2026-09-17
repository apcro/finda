<?php
/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
namespace Croissant;

error_reporting(E_ALL & ~E_WARNING & ~E_NOTICE & ~E_STRICT);

require_once('../configuration/configuration.php');

if (isset($_SERVER['REQUEST_URI'])) {
	if (strstr($_SERVER['REQUEST_URI'], 'croissant=')) {
		header('location: /');
		die('5');
	}
}

$_REQUEST = Sanitiser::FILTER_XSS_CLEAN($_REQUEST);
$_POST = Sanitiser::FILTER_XSS_CLEAN($_POST);
$_GET = Sanitiser::FILTER_XSS_CLEAN($_GET);
$_COOKIE = Sanitiser::FILTER_XSS_CLEAN($_COOKIE);

extract($_REQUEST, EXTR_PREFIX_SAME, '__');    // stops overwriting existing variable values
if (!DEBUG) {
	unset($_REQUEST);unset($_POST);unset($_GET);
}

// if the browser is IE6, drop out completely
if (strstr($_SERVER['HTTP_USER_AGENT'], 'MSIE 6') || $ie6 == 1) {
	$template = 'shared/error/ie6.tpl';
	Core::Assign('ie6', true);
	Core::Assign('nocookie', 1);
	Core::Display($template);
	die();
} else {
	Core::Assign('ie6', false);
}

if (DEBUG) {
	$page_start = microtime(TRUE);
	$_SESSION['last'] = $page_start;
}

$croissant = isset($croissant)?$croissant:''; // from .httaccess
$response = Core::ParseURL($croissant);

if (isset($aff_id) && !empty($aff_id)) {
	Finda::SetAffiliate($aff_id);
}

$function = $response['function'];

if ($response['redirect'] == 1) {
	if (isset($response['code'])) {
		header('Location: '.$response['location'], true, $response['code']);
	} else {
		header('Location: '.$response['location']);
	}
	die();
}

foreach($response as $k => $v) {
	${$k} = $v;
	Core::Assign($k, $v);
}

$template = NOTEMPLATE;
if (DEBUG) $point_timer[] = array('Start:', microtime(TRUE));


if (file_exists(BASEPATH.'/workers/'.$function.'.php')) {
	try {
		// we're going to load a worker, so even if we don't display a page,
		// push this onto the top of the JS output list
		
		Core::AddJavascript('croissant.js');
		Core::AddJavascript('croissant/tinymodal.js');
		Core::AddJavascript('croissant/tinygrowl.js');
		
		// this is bad, but is for testing
		Core::AddJavascript('/vendor/slideout.js');
		
		Core::AddJavascript('app.js');
		
		Core::AddCSS('croissant.css');
		Core::AddCSS('balloon.css');
		Core::AddCSS('finda.css');

		if ($function != 'invite') {
			Core::AddCSS('finda-mobile.css');
		}

		// are we in holding mode?
		if (HOLDING) {
			$function = 'holding';
		} else {
			if (User::UserID() == 0 && !IS_AJAX_REQUEST) {
				if ($function == 'user') {
					if ($args[0] != 'forgotpasswd' && $args[0] != 'resetpasswd') {
						Core::AddJavascript('login.js');
						Core::Assign('resetpassword', 0);
					} else {
						Core::Assign('resetpassword', 1);
					}
				} else {
					Core::AddJavascript('login.js');
				}
			}
			
			if (User::UserID() != 0 && User::UserStatus() != 1) {
				Core::AddJavascript('user/verifypoller.js');
			}
		}
		
		if (DEBUG) $controller_start = microtime(TRUE);
		include(BASEPATH.'/workers/'.$function.'.php');
		if (DEBUG) $controller_end = microtime(TRUE);
		Core::PageTitle(!empty($page_title)?$page_title:DEFAULT_PAGE_TITLE);
		Core::PageMeta(!empty($page_meta)?$page_meta:DEFAULT_PAGE_META);
		Core::PageKeywords(!empty($page_keywords)?$page_keywords:DEFAULT_PAGE_KEYWORDS);
		
		// we actually ran the function and returned, so set any user company info into the template for menu display
		if (User::UserID() != 0) {
			if (User::UserType() == TYPE_CLIENT) {
				$company = User::GetUserCompanyDetails();
				if (!empty($company)) {
					Core::Assign('usercompany', $company);
				}
			}
		}
	} catch (\Exception $e) {
		$e_code = $e->getCode();
		switch ($e_code) {
			case 103:
				Core::Assign('errorMessage', 'Communication error with the data server.');
				if (DEBUG) {
					Core::Assign('errorData', nl2br($e));
				}
				Core::Display('errorpages/showerror.tpl');
				die();
				break;
			case 7997:
				Core::Display_override('errorpages/nodataserver.tpl');
				die();
				break;
			default:
				die();
				break;
		}
	}
} else {
	// we might have a sefu
	
	
	
	$template = NOTFOUND;
}
if (DEBUG) $point_timer[] = array('Finished function', microtime(TRUE));

/* ****************************************************************************************************
 * Include client-specific code
 ******************************************************************************************************/
include(DOCROOT.'/'.CLIENT.'.php');


/* ****************************************************************************************************
 * Include iPad support, if needed
******************************************************************************************************/
if (Core::$core->_iPad || Core::$core->_iPhone) {
	Core::Assign('iPad', 1);
} else {
	Core::Assign('iPad', 0);
}

// Include the 404 worker
if ($template == NOTFOUND || $template == SERVERERROR) {
	Core::AddCSS('croissant.css');
	Core::AddCSS('balloon.css');
	Core::AddCSS('finda.css');
	Core::AddCSS('finda-mobile.css');
	
	if ($template == NOTFOUND) {
		$page_title = 'Not Found';
		Core::AddCSS('notfound.css');
	} else {
		$page_title = 'Server Error';
		Core::AddCSS('servererror.css');
	}
	
	// we need to override the previously set data
	Core::PageTitle(!empty($page_title)?$page_title:DEFAULT_PAGE_TITLE);
	Core::PageMeta(!empty($page_meta)?$page_meta:DEFAULT_PAGE_META);
	Core::PageKeywords(!empty($page_keywords)?$page_keywords:DEFAULT_PAGE_KEYWORDS);
}
Core::Assign('nocookie', Cookie::GetCookie('allowcookies'));

/* ****************************************************************************************************
 * Debugging output
 ******************************************************************************************************/
if (DEBUG) include('debug.php');

/* ****************************************************************************************************
 * This is the final call made by every page - display the selected template.
 ******************************************************************************************************/

Core::Display($template);