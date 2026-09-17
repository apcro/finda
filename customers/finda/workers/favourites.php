<?php
/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
namespace Croissant;
/*
 * Client favourite models
 */
if (User::UserID() == 0) {
	header('Location: /');
	die();
}

if (User::UserType() != TYPE_CLIENT) {
	header('Location: /');
	die();
}

$favourites = Model::GetFavouriteModels();
Core::Assign('favourites', $favourites);
Core::AddCSS('clients/favourites.css');
Core::AddCSS('search.css');
Core::AddCSS('jobedit.css');

Core::Assign('body_class', 'body-blue');

Core::AddJavascript('clients/favourites.js');

$template = 'clients/favourites.tpl';