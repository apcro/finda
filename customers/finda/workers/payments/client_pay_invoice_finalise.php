<?php
/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
namespace Croissant;

if (!isset($step)) {
	$step = 0;
}
$template = 'user/invoices/client_pay_invoice_step'.$step.'.tpl';
switch ($step) {
	case 0:
		// display invoice details
		$invoice = Finance::RetrieveInvoiceDetails($args[1]);
		$jobdetails = Jobs::GetJobDetails($invoice['jobid']);
		
		// work out some stuff
		$modelfee = 0;
		foreach ($jobdetails['models'] as $k => $v) {
			if ($jobdetails['time_units'] == 0.5) {
				$calcunits = 1;
			} else {
				$calcunits = $jobdetails['time_units'];
			}
			$modelfee = $modelfee + ($v['agreed_rate'] * $calcunits);
		}
		
		$findafee = $modelfee * .1;
		$subtotalfee = $modelfee + $findafee;
		$vat = $subtotalfee * .2;
		$totalfee = $subtotalfee + $findafee + $vat;
		Core::Assign('findafee', $findafee);
		Core::Assign('subtotalfee', $subtotalfee);
		Core::Assign('vat', $vat);
		Core::Assign('totalfee', $totalfee);
		Core::Assign('invoice', $invoice);
		Core::Assign('jobdetails', $jobdetails);
		
		Core::AddCSS('user/invoices.css');
		break;
	case 1:
		// redirect to mangopay?
		break;
	case 2:
		// payment received
		break;
	default:
		header('Location: /');
		die();
}