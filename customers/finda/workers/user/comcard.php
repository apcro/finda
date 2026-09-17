<?php
/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
namespace Croissant;

// file for editing and viewing an model's comcard



$model = User::LoadUser(User::UserID());

$model['profile']['height'] = Utilities::CentimetersToFeet($model['profile']['height']).' /'.$model['profile']['height'].'cm';
$model['profile']['bust'] = Utilities::CentimetersToInches($model['profile']['bust']).'"/ '.$model['profile']['bust'].'cm';
$model['profile']['waist'] = Utilities::CentimetersToInches($model['profile']['waist']).'" /'.$model['profile']['waist'].'cm';
$model['profile']['hips'] = Utilities::CentimetersToInches($model['profile']['hips']).'" /'.$model['profile']['hips'].'cm';

Core::Assign('model', $model);

if ($args[1] == 'print') {
	
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
	$options->set('isRemoteEnabled',true);
	
	$dompdf = new \Dompdf\Dompdf($options);
	
	$html = Core::Fetch('models/comcard_print.tpl');

	
	$dompdf->setProtocol(DOCROOT);
	$dompdf->setBasePath('/');
	
	echo $html;die();
	
	// (Optional) Setup the paper size and orientation
	
	$dompdf->setPaper('A5', 'portrait');
	
	$dompdf->loadHtml($html);
	// Render the HTML as PDF
	$dompdf->render();
	
	// Output the generated PDF to Browser
	$pdfname = 'Idal-comcard-'.$model['firstname'].'-'.substr(0, 1, $model['lastname']);
	$dompdf->stream($pdfname);
	
	die();
} else {
	$template = 'models/comcard_view.tpl';
	$html = Core::Fetch($template);
	echo $html;
	die();
}
