<?php
/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
namespace Croissant;
/**
 * User Profile Email controller
 *
 *
 */

switch ($args[2]) {
	case 'add':
		$formData = array();
		$formData ['client'] = $client_input;
		$formData ['details'] = $details_input;
		$formData ['work_type'] = $jobtype_input;
		$formData ['date_worked'] = strtotime($dateworked_input);
		Model::AddExperience($formData);
		header('location: /user/profile#experience');
		die();
		break;
	case 'update':
		if (!empty($args[3]) && ($args[3] == $experienceid)) {
			$exp = Model::GetExperienceDetails($args[3]);
			if ($exp['modelid'] == User::UserID()) {
				$formData = array();
				$formData ['client'] = $client_input;
				$formData ['details'] = $details_input;
				$formData ['work_type'] = $jobtype_input;
				$formData ['date_worked'] = strtotime($dateworked_input);
				$formData ['id'] = $experienceid;
				$response = Model::UpdateExperience($formData);
			}
		}
		header('location: /user/profile#experience');
		die();
	case 'remove':
		if (!empty($args[3])) {
			$exp = Model::GetExperienceDetails($args[3]);
			if ($exp['modelid'] == User::UserID()) {
				Model::RemoveExperience($args[3]);
			}
		}
		header('location: /user/profile#experience');
		die();
		break;
	case 'edit':
		if (!empty($args[3])) {
			$exp = Model::GetExperienceDetails($args[3]);
			if ($exp['modelid'] == User::UserID()) {
				$jobtypes = Taxonomy::GetTermsByVocabulary(1, true);
				Core::Assign('jobtypes', $jobtypes);
				Core::Assign('experience', $exp);
				$template = 'user/profile/editexperience.tpl';
			} else {
				header('location: /user/profile#experience');
				die();
			}
		} else {
			header('location: /user/profile#experience');
			die();
		}
		break;
}