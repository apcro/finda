<?php
/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
namespace Croissant;

// force-downloads files from a given path
$filename = '';
switch($args[0]) {
	case 'callsheet':
		$job = Jobs::GetJobDetails($args[1]);
		if (!empty($job['callsheet'])) {
			$filename = DOCROOT.$job['callsheet'];
			$jobname = str_replace(' ', '', $job['name']);
			header("Content-Disposition: attachment; filename=$jobname.pdf;");
			header('Content-Type: application/pdf');
			File2::Stream($filename);
			die();
		} else {
			$template = 'jobs/nocallsheet.tpl';
		}
		break;
}
