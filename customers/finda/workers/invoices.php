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

if (User::UserType() != 2 && User::UserType() != 99 && User::UserType() != 3) {
	header('Location: /');
	die();
}

$data = Session::GetVariable('payment');
if ($data == 'success') {
	Core::Assign('paymentsuccess', 1);
} else if ($data == 'failed') {
	Core::Assign('paymentsuccess', 2);
} else {
	Core::Assign('paymentsuccess', 0);
}
Session::SetVariable('payment', '');

Core::Assign('body_class', 'body-white');
switch ($args[0]) {
	case 'accept':
		break;	
	case 'reject':
			break;
	case 'more-info':
		break;
	case 'negotiate':
		break;
	case 'create':
		break;
	case 'process':
		include('payments/client_process_invoice.php');
		break;
	case 'pay':
		include('payments/client_pay_invoice.php');
		break;
	case 'view':
		include('payments/client_view_invoice.php');
		break;
	default:
		if (!IS_AJAX_REQUEST) {
			
			$template = 'user/invoices/client_invoices.tpl';
			$invoices = Finance::RetrieveInvoices(User::UserID());
			foreach($invoices as $k => $v) {
				$invoices[$k]['jobdetails'] = Jobs::GetJobDetails($v['jobid']);
			}
			Core::Assign('invoices', $invoices);
			
			$unpaid = array();
			$paid = array();
			$outstanding = 0;
			foreach($invoices as $k => $v) {
				if ($v['status'] == 1) {
					$outstanding += $v['value'];
					$unpaid[] = $v;
				} else {
					$paid[] = $v;
				}
			}
			Core::Assign('outstanding', $outstanding);
			Core::Assign('paid', $paid);
			Core::Assign('unpaid', $unpaid);
			
			$companyDetails = User::GetUserCompanyDetails();
			if ($companyDetails['id'] != 0) {
				$companyinvoices = Companies::RetrieveCompanyInvoices($companyDetails['id']);
				foreach($companyinvoices as $k => $v) {
					if ($v['clientid'] == User::UserID()) {
						unset($companyinvoices[$k]);
					}
				}
				
				if (!empty($companyinvoices)) {
					foreach($companyinvoices as $k => $v) {
						$companyinvoices[$k]['jobdetails'] = Jobs::GetJobDetails($v['jobid']);
					}
					Core::Assign('companyinvoices', $companyinvoices);
					$companyunpaid = array();
					$companypaid = array();
					$companyoutstanding = 0;
					foreach($companyinvoices as $k => $v) {
						if ($v['clientid'] != User::UserID()) {
							if ($v['status'] == 1 && $v['clientid'] != User::UserID()) {
								$companyoutstanding += $v['value'];
								$companyunpaid[] = $v;
							} else {
								$companypaid[] = $v;
							}
						}
					}
					Core::Assign('companyoutstanding', $companyoutstanding);
					Core::Assign('companypaid', $companypaid);
					Core::Assign('companyunpaid', $companyunpaid);
				}
			}
			
			Core::AddCSS('user/invoices.css');
			Core::AddCSS('user/companyinvoices.css');
			Core::AddJavascript('clients/invoices.js');
			
			Core::Assign('grid_background', 'grid-bg-white');
			
			$page_title = 'Invoices';
			Core::Assign('banner_title', 'Invoices');
		} else {
			header('HTTP/1.0 403 Forbidden', 403);
			die();
		}
		break;
}

