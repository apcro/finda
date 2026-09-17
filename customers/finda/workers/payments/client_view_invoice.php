<?php
/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
namespace Croissant;


$template = 'user/invoices/client_view_invoice.tpl';
// display invoice details
$invoice = Finance::RetrieveInvoiceDetails($args[1]);
$jobdetails = Jobs::GetJobDetails($invoice['jobid']);
$fees = Jobs::GetJobValueByInvoiceId($args[1]);


Core::Assign('fees', $fees);

Core::Assign('invoice', $invoice);
Core::Assign('jobdetails', $jobdetails);
Core::Assign('mail', User::Email());

Core::AddCSS('user/invoices.css');

Core::Assign('grid_background', 'grid-bg-green');

$page_title = 'Invoice: '.$jobdetails['name'];
