<?php
/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
namespace Croissant;


// generates various HTML - mostly invoices
switch($args[0]) {
	case 'invoice':
		$invoice = Finance::RetrieveInvoiceDetails($args[1]);
		// check the appropriate user is logged in
		if ($invoice['invoicetype'] == 'client' || $invoice['invoicetype'] == 'agency') {
			if ($invoice['clientid'] != User::UserID() && !DEBUG) {
				header('Location: /');
				die();
			}
		} else {
			if ($invoice['modelid'] != User::UserID() && !DEBUG) {
				header('Location: /');
				die();
			}
		}
		
		$jobdetails = Jobs::GetJobDetails($invoice['jobid']);
		$model = $jobdetails['models'][$invoice['modelid']];
		$fees = Jobs::GetJobValueByInvoiceId($args[1]);

		// @TODO remove this override
		if ($args[1] == 124) {
			foreach($fees['modelfees'] as $k => $v) {
				$fees['modelfees'][$k]['modelcost'] = 100;
			}
			foreach($jobdetails['models'] as $k => $v) {
				$jobdetails['models'][$k]['agreed_rate'] = 100;
			}
			$fees['subtotalfee'] = 1000;
			$fees['vat'] = 1000 * .2;
			$fees['totalfee'] = 1000 * 1.2;
			$fees['findafee'] = 0;
		}
		// END TODO
		Core::Assign('fees', $fees);
		if ($invoice['invoicetype'] == 'client') {
			$client = User::LoadUser($invoice['clientid']);
			$template = 'user/invoices/printable.tpl';
			$company = Companies::LoadCompanyForClient($client['companyid']);
			if ($company) {
				$invoice['company'] = $company;
			}
		} else if ($invoice['invoicetype'] == 'model') {
			$client = User::LoadUser($invoice['modelid']);
			$template = 'user/invoices/modelprintable.tpl';
			$modelfees = $fees['modelfees'][$invoice['modelid']];
			$modelfees['findafee'] = $modelfees['modelfee'];
			$modelfees['motheragencycommission'] = $modelfees['agencycommission'];
			$modelfees['fee'] = $modelfees['total'] - $modelfees['motheragencycommission'];
			Core::Assign('modelfees', $modelfees);
		} else if ($invoice['invoicetype'] == 'agency') {
			$client = User::LoadUser($invoice['modelid']);
			$template = 'motheragencies/agencyprintable.tpl';
			Core::Assign('fees', $fees);
			$motheragency = MotherAgencies::LoadMotherAgencyForClient(User::UserID());
			Core::Assign('motheragency', $motheragency);
		} else {
			// do nothing
		}
		
		Core::Assign('client', $client);
		
		Core::Assign('invoice', $invoice);
		Core::Assign('jobdetails', $jobdetails);
		Core::Assign('model', $model);
		Core::Assign('mail', User::Email());
		
		Core::AddCSS('user/invoices.css');
		
		$html = Core::Fetch($template);
		
		echo $html;die();
		
		\Dompdf\Autoloader::register();
		
		$dompdf = new \Dompdf\Dompdf();
		$dompdf->loadHtml($html);
		
		// (Optional) Setup the paper size and orientation
		$dompdf->setPaper('A4', 'portrait');
		$dompdf->set_option('defaultFont', 'Gotham');
		$dompdf->set_option('isHtml5ParserEnabled', true);
		
		
		
		// Render the HTML as PDF
		$dompdf->render();
		
		// Output the generated PDF to Browser
		$pdfname = 'Idal-Invoice-';
		if (User::UserType() == TYPE_MODEL) {
			$pdfname .= 'M';
		} else {
			$pdfname .= 'C';
		}
		$pdfname .= $invoice['id'];
		$dompdf->stream($pdfname);
		break;
	case 'comcard':
		
		$model = User::LoadUser($args[1]);
		if ($model) {
			$modelid = $args[1];
			$model['profile']['height'] = Utilities::CentimetersToFeet($model['profile']['height']).' /'.$model['profile']['height'].'cm';
			$model['profile']['bust'] = Utilities::CentimetersToInches($model['profile']['bust']).'"/ '.$model['profile']['bust'].'cm';
			$model['profile']['waist'] = Utilities::CentimetersToInches($model['profile']['waist']).'" /'.$model['profile']['waist'].'cm';
			$model['profile']['hips'] = Utilities::CentimetersToInches($model['profile']['hips']).'" /'.$model['profile']['hips'].'cm';
			
			Core::Assign('model', $model);
			
			list($width, $height) = getimagesize(CDN_ROOT.'/portfolio/thumb'.$model['filename']);
			
			$marginLeft = 0;
			$marginTop = 0;
			$frameWidth = 450;
			$frameHeight = 480;
			if ($width >= $height) {
				$orientation = 'landscape';
				
				$proportion = $frameHeight / $height;
				$correctedWidth = $proportion * $width;
				
				$marginLeft = ($frameWidth - $correctedWidth) / 2;
			} else {
				$orientation = 'portrait';
				$proportion = $frameWidth / $width;
				$correctedHeight = $proportion * $height;
				$marginTop = ($frameHeight - $correctedHeight) / 2;
			}
			
			Core::Assign('marginTop', $marginTop);
			Core::Assign('marginLeft', $marginLeft);
			Core::Assign('orientation', $orientation);
			
			\Dompdf\Autoloader::register();
			
			$options = new \Dompdf\Options();
			$options->set('defaultFont', 'Gotham');
			$options->set('isRemoteEnabled', true);
			$options->set('isHtml5ParserEnabled', true);
			
			$dompdf = new \Dompdf\Dompdf($options);
			
			$portfolio = Finda::GetUserImages('portfolio', $modelid);
			Core::Assign('portfolio', $portfolio);

			$polaroids = Finda::GetUserImages('polaroids', $modelid);
			Core::Assign('polaroids', $polaroids);
			
			$html = Core::Fetch('models/comcard_download.tpl');
			
			
			$dompdf->setProtocol(DOCROOT);
			$dompdf->setBasePath('/');
			
			
			set_time_limit(120);
			$dompdf->setPaper('A4', 'portrait');
			$dompdf->loadHtml($html);
			$dompdf->render();
			
			// Output the generated PDF to Browser
			$pdfname = 'Idal-comcard-'.$model['firstname'].'-'.substr(0, 1, $model['lastname']);
			$dompdf->stream($pdfname);
			
			die();
			
		}
		
		
		break;
}

die();