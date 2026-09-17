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
 * User inbox
 *
 * retrieves and displays the content of the user's inbox
 *
 * @author Tom Gordon
 * @version 0.1
 *
 */

switch($act) {
	// Loads the sentbox instead
	// Does not display shared items
	case 'sent':
		$inbox = Friend::LoadSentbox();
		Core::Assign('inbox', $inbox);

		$title_bar['title'] = 'Sent Messages';

		$template = 'user/sentbox.tpl';
		break;

	default:
		$per_page = 10;

		$offset = isset($offset) ? $offset : 0;
		if (isset($offset)) {
			$page = ($offset / $per_page);
		}
		$inbox = Friend::LoadInbox($page);
		if (!empty($inbox['messages'])) {
			foreach($inbox['messages'] as $k => $v) {
				$inbox['messages'][$k]['message'] = unserialize($inbox['messages'][$k]['message']);
				if (strstr($inbox['messages'][$k]['message']['url'], 'folders')) {
					$inbox['messages'][$k]['data']['type'] = 'folder';
				}
				if (strstr($inbox['messages'][$k]['message']['url'], 'package')) {
					$inbox['messages'][$k]['data']['type'] = 'pack';
				}
			}
		}
		if ($is_json) {
			// if this is a JSON call, don't load irrelevant stuff
			print json_encode($inbox['messages']);
			die();
		}

		Core::Assign('inbox', $inbox);
		Core::Assign('counts', $counts);
		$template = 'user/inbox.tpl';


		$title_bar['title'] = 'Messages for '.User::Firstname().' '.User::Surname();
		$title_bar['subtitle'] = 'You have '.($counts['unread']>0?$counts['unread']:0).' unread message';
		if ($counts['unread'] != 1) {
			$title_bar['subtitle'] .= 's';
		}

		// Pager
		$page = ceil($offset/$per_page) + 1;
		$page_link = Core::_pager($counts['total'], $page, $per_page);
		Core::Assign('page_link', $page_link);
		Core::Assign('page', $page);

		break;
}