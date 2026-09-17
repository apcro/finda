<?php
/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
namespace Croissant;


$job = Jobs::GetJobDetails(51);
Core::Assign('job', $job);
$html = Core::Fetch('emails/joboffer_rejected.tpl');

echo $html;
die();