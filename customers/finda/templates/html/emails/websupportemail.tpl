Support Request from the Website
================================

From: {$user.firstname} {$user.lastname}
{if $user.usertype eq 2}Company name: {$user.company_name}{/if}
ID: {$user.id}
Email: {$user.mail}
Date: {$smarty.now|date_format:"%d/%m/%Y %I:%M%p"}

Request:
========
{$request}