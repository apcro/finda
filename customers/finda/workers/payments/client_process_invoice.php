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

// here we process a payment POSTed to us from the Stripe handler
// received parameters:
// $jobid - Job ID
// $stripeToken - needed to create the charge
// stripeEmail - email entered

// let's make sure we have everything
if (empty($jobid)) {
	header('Location: /invoices');
}
if (empty($stripeToken)) {
	header('Location: /invoices');
}
if (empty($stripeTokenType)) {
	header('Location: /invoices');
}
if (empty($stripeEmail)) {
	header('Location: /invoices');
}

// we need some more details
$response = Finance::CreateCharge($jobid, $stripeToken);
if ($response) {
	// payment successful
	// send emails
	SendGrid::SendClientInvoicePaid($jobid);
	Session::SetVariable('payment', 'success');
} else {
	// payment unsuccessful
	Session::SetVariable('payment', 'failed');
	
}
header('Location: /invoices');
die();