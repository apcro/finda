<?php
/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
namespace Croissant;

if (User::UserID() == 0) {
	header('Location: /');
	die();
}
// model affiliates page
$template = 'user/affiliates.tpl';
Core::Assign('body_class', 'body-blue');
$page_title = 'Referrals';
Core::Assign('grid_background', 'grid-bg-green');
Core::AddCSS('user/affiliates.css');

Core::Assign('user', Core::$core->_user);

$affiliates = Finda::GetAffiliates();
foreach($affiliates as $k => $v) {
	$jobscount += $v['jobscount'];
	$jobstotal += $v['jobscount'];
}
$jobstotal = $jobstotal * 0.5;
Core::Assign('affiliates', $affiliates);
Core::Assign('jobscount', $jobscount);
Core::Assign('jobstotal', $jobstotal);

$verified = 0;
foreach($affiliates as $affiliate) {
	if ($affiliate['status'] == 1) {
		$verified++;
	}
}
Core::Assign('verifiedusers', $verified);
