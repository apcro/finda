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
		$fees = Jobs::GetJobValueByInvoiceId($args[1]);
		if ($fees['totalfee'] == 0) {	// zero invoices don't need further processing
			$response = Finance::UpdateInvoiceDetailsAsPaid($invoice['id'], 'zero-value-invoice');
			$response = Jobs::UpdateJobAsPaid($invoice['jobid']);
			header('Location: /invoices');
			die();
		}
		
		Core::Assign('fees', $fees);
		
		Core::Assign('invoice', $invoice);
		Core::Assign('jobdetails', $jobdetails);
		Core::Assign('mail', User::Email());
		Core::Assign('allow_invoice', User::CanPayByInvoice());
		Core::AddCSS('user/invoices.css');
		
		Core::Assign('grid_background', 'grid-bg-green');
		
		$page_title = 'Invoice: '.$jobdetails['name'];
		break;
	case 1:
		
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
		
		break;
	case 2:
		// payment received
		break;
	default:
		header('Location: /');
		die();
}