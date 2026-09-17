Support Request from the Model App
==================================

From: {$user.firstname} {$user.lastname}
ID: {$user.id}
Email: {$user.mail}
Date: {$smarty.now|date_format:"%d/%m/%Y %I:%M%p"}

Reason:
=======
{$reason}

Request:
========
{$request}