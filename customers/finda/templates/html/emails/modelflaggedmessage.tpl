MODEL FLAGGED MESSAGE<br />
=====================<br />
Date: {$smarty.now|date_format:"%d/%m/%Y %I:%M%p"}<br />
<br /><br />
{$name} (userid: {$modelid}:{$userid}) flagged the following message from {$client.firstname} {$client.lastname} (https://cms.idal.co/user/edit/{$client.id}).<br />
REASON: {$reason}<br />
----------------------<br />
<br /><br />
{$message|print_r}<br />