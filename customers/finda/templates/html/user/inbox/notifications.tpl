{extends "user/layout_updates.tpl"}

{block name="main"}
<div class="blockmyupdates active">
	{if $usertype eq 2}
	<div class="row mobile">
		<div class="column">
			<p class="notice">Please use your desktop or laptop to enjoy all our features. The iDAL app for Clients is coming soon!</p>
		</div>
	</div>
	{/if}
	{if $messages}
	<div class="row desktop">
	{if $usertype eq 1}
{*		<div class="column modelnamecol narrow">From</div> *}
		<div class="column modelnamecol"><span style="width: 75px; display: block;">From</span></div>
		<div class="column">Message</div>
		<div class="column narrow10">&nbsp;</div>
	</div>
	{else}
		<div class="column modelimage"><span style="width: 75px; display: block;">From</span></div>
		<div class="column modelnamecol narrow">&nbsp;</div>
		<div class="column">Update</div>
		<div class="column narrow10">&nbsp;</div>
	</div>
	{/if}
	{foreach from=$messages item=message name=message}
	{if $message.message neq ''}
	{if $usertype eq 1}
	<div class="row notes msg{$message.id}{if $message.status eq 0} new{/if}" data-jobid="{$message.jobid}" data-msgtype="{$message.type}" data-usertype="{$usertype}" data-sefu="{$message.sefu}">
		<div class="column modelimage modelnamecol narrow text-bold" style="flex-direction: column; justify-items: center;">
			<img src="{if $message.avatar neq '/default_profile.png'}{$CDN_ROOT}/avatar/thumb{$message.avatar}{else}{if $message.filename}{$CDN_ROOT}/{$message.imagetype}/large{$message.filename}{else}{$default_avatar}{/if}{/if}" />
			<div style="text-align: center;"><span class="mobile">From: </span>{$message.firstname} {$message.lastname}</div>
			{if $message.usertype eq 2}<hr class="inbox"><div style="text-align: center;">{$message.company_name}</div>{/if}
		</div>
		<div class="column"><span class="datetime">{$message.timestamp|date_format:"%d %B %Y"}</span>{if $message.status eq 0} <span class="text-burgundy"><i class="fas fa-exclamation-triangle"></i></span>{/if}<br />
			{if $message.type eq 16}
			<img src="{$smarty.const.CDN_ROOT}/chatAttachment/thumb{$message.message}" class="chatAttachment" />
			{else if $message.type eq 17}
			{else}
			{$message.message}
			{/if}
		</div>
		<div class="column message-controls text-right">
			{if $message.type eq $smarty.const.MESSAGE_TYPE_COMPOSED || $message.type eq 16 || $message.type eq 17}
			<a class="success button small burgundy" href="/messages/{$message.sefu}" data-balloon="Reply to this message" data-balloon-pos="up" data-senderid="{$message.sender}" data-sendername="{$message.firstname}">Reply</a>
			<a class="button small inverted flagcomposed" href="flag" data-balloon="Flag this message as inappropriate" data-balloon-pos="up" data-msgid="{$message.id}">Flag as Inappropriate</a>
			{else}
			<a class="success button small inverted" href="/jobs#upcoming" data-balloon="View open offers" data-balloon-pos="up" >Offers</a>
			{/if}
			<a class="delete cancel errorbutton button small" href="delete" data-msgid="{$message.id}">Delete Message</a>
		</div>
	</div>
	{else}
	<div class="row notes msg{$message.id}{if $message.status eq 0} new{/if}" data-jobid="{$message.jobid}" data-msgtype="{$message.type}" data-usertype="{$usertype}"data-msgtype="{$message.type}" data-sefu="{$message.sefu}">
		<div class="column modelimage desktop"><a href="/view/{$message.sefu}"><img src="{if $message.avatar neq '/default_profile.png'}{$CDN_ROOT}/avatar/thumb{$message.avatar}{else}{if $message.filename}{$CDN_ROOT}/{$message.imagetype}/large{$message.filename}{else}{$default_avatar}{/if}{/if}" /></a></div>
		<div class="column modelnamecol narrow desktop text-bold"><span class="mobile">From: </span><span><a class="modelname" href="/view/{$message.sefu}">{$message.firstname} {$message.lastname}</a></span></div>
		<div class="column messagecolumn"><span class="datetime">{$message.timestamp|date_format:"%d %B %Y"}</span>{if $message.status eq 0} <span class="text-burgundy"><i class="fas fa-exclamation-triangle"></i></span>{/if}<br />
			{if $message.type eq 16}
			<img src="{$smarty.const.CDN_ROOT}/chatAttachment/thumb{$message.message}" class="chatAttachment" />
			{else if $message.type eq 17}
			{else}
			{$message.message}
			{/if}
			{if $message.type eq $smarty.const.MESSAGE_TYPE_NEGOTIATE && $message.job_status eq 1}
			<p><i>This message is out of date as the project has been closed.</i></p>
			{/if}
		</div>
		<div class="column message-controls text-right">
			{if $message.type eq $smarty.const.MESSAGE_TYPE_NEGOTIATE && $message.job_status eq 0}
{*			<a class="msgreply check button small burgundy pad-top" href="acceptrate" data-msgid="{$message.id}" data-msgtype="{$message.type}" data-balloon="Accept rate offer" data-balloon-pos="up">Accept</a> *}
			<a class="updateoffer money button small pad-top burgundy" href="updaterate" data-balloon="Make counter offer" data-balloon-pos="up" data-modelrate="{$message.model_desired_rate}" data-msgid="{$message.id}">Negotiate</a>
{*			<a class="msgreply cancel button small errorbutton pad-top" href="rejectrate" data-msgid="{$message.id}" data-balloon="Reject rate offer" data-balloon-pos="up">Reject</a> *}
{*			<a class="msgreply button small errorbutton pad-top" href="rejectremove" class="cancel button small" data-msgid="{$message.id}" data-balloon="Reject offer and remove model" data-balloon-pos="up">Remove Model</a> *}
			<a href="/projects/edit/{$message.jobid}" class="edit button small pad-top">Edit Project</a>
			{/if}
			{if $message.type eq $smarty.const.MESSAGE_TYPE_ACCEPT && $message.job_status eq 1}
			<a class="button small inverted pad-top" href="/project/edit/{$message.jobid}#models" data-balloon="Confirm model for this job" data-balloon-pos="up">Confirm Model</a><br />
			{/if}
			{if $message.type eq $smarty.const.MESSAGE_TYPE_COMPOSED || $message.type eq 16 || $message.type eq 17}
			<a class="success button small burgundy replycomposed" href="reply" data-balloon="Reply to this message" data-balloon-pos="up" data-senderid="{$message.sender}" data-sendername="{$message.firstname}">Reply</a>
			{/if}
			<a class="delete cancel errorbutton button small pad-top" href="delete" data-msgid="{$message.id}">Delete Message</a>
		</div>
	</div>
	{/if}
	{/if}
	{/foreach}
	{if $count > $messages|count}
	<div class="row pager">
		<div class="column text-left">
			{if $nextpage neq 1}
			<a href="/updates{if $prevpage neq 0}/{$prevpage}{/if}"><i class="fas fa-caret-left"></i> Previous page</a>
			{else}
			&nbsp;
			{/if}
		</div>
		<div class="column text-center">
		{for $page=0 to $count}
		{if $page%20 eq 0}
		<a class="number{if ($page/20) eq $nextpage-1} current{/if}" href="/updates/{$page/20}">{($page/20)+1}</a>
		{/if}
		{/for}
		</div>
		<div class="column text-right">
			{if $nextpage * 20 lt $count}
			<a href="/updates/{$nextpage}">Next page <i class="fas fa-caret-right"></i></a>
			{else}
			&nbsp;
			{/if}
		</div>
	</div>
	{/if}
	
	{else}
	<div class="row">
		<div class="column">
			<p>You have no messages</p>
		</div>
	</div>
	{/if}
</div>
{/block}

{block name="companymain"}
<div class="blockcompanyupdates">
	{if $usertype eq 2}
	<div class="row mobile">
		<div class="column">
			<p class="notice">Please use your desktop or laptop to enjoy all our features. The iDAL app for Clients is coming soon!</p>
		</div>
	</div>
	{/if}
	{if $messages}
	<div class="row desktop">
	{if $usertype eq 1}
		<div class="column modelnamecol narrow">From</div>
		<div class="column">Message</div>
		<div class="column narrow10">&nbsp;</div>
	</div>
	{else}
		<div class="column modelimage"><span style="width: 75px; display: block;">From</span></div>
		<div class="column modelnamecol narrow">&nbsp;</div>
		<div class="column">Update</div>
		<div class="column narrow10">&nbsp;</div>
	</div>
	{/if}
	{foreach from=$companyupdates item=message name=message}
	{if $usertype eq 1}
	<div class="row notes msg{$message.id}{if $message.status eq 0} new{/if}" data-jobid="{$message.jobid}" data-msgtype="{$message.type}">
		<div class="column modelnamecol narrow text-bold"><span class="mobile">From: </span>{$message.firstname} {$message.lastname}</div>
		<div class="column"><span class="datetime">{$message.timestamp|date_format:"%d %B %Y"}</span>{if $message.status eq 0} <span class="text-burgundy"><i class="fas fa-exclamation-triangle"></i></span>{/if}<br />
			{if $message.type eq 16}
			<img src="{$smarty.const.CDN_ROOT}/chatAttachment/thumb{$message.message}" class="chatAttachment" />
			{else if $message.type eq 17}
			{else}
			{$message.message}
			{/if}
		</div>
		<div class="column message-controls text-right">
			{if $message.type eq $smarty.const.MESSAGE_TYPE_COMPOSED}
			<a class="success button small inverted" href="replycomposed" data-msgtype="{$message.type}" data-balloon="Reply to this message" data-balloon-pos="up" >Reply</a>
			<a class="delete button small inverted" href="flagcomposed" data-balloon="Flagthis message" data-balloon-pos="up" >Flag</a>
			{else}
			<a class="success button small inverted" href="/jobs#upcoming" data-balloon="View open offers" data-balloon-pos="up" >Offers</a>
			{/if}
			<a class="delete cancel button small" href="delete" data-msgid="{$message.id}">Delete Message</a>
		</div>
	</div>
	{else}
	<div class="row notes msg{$message.id}{if $message.status eq 0} new{/if}" data-jobid="{$message.jobid}" data-msgtype="{$message.type}">
		<div class="column modelimage desktop"><a href="/view/{$message.sefu}"><img src="{if $message.avatar neq '/default_profile.png'}{$CDN_ROOT}/avatar/thumb{$message.avatar}{else}{if $message.filename}{$CDN_ROOT}/{$message.imagetype}/large{$message.filename}{else}{$default_avatar}{/if}{/if}" /></a></div>
		<div class="column modelnamecol narrow desktop text-bold"><span class="mobile">From: </span><span><a class="modelname" href="/view/{$message.sefu}">{$message.firstname} {$message.lastname}</a></span></div>
		<div class="column messagecolumn"><span class="datetime">{$message.timestamp|date_format:"%d %B %Y"}</span>{if $message.status eq 0} <span class="text-burgundy"><i class="fas fa-exclamation-triangle"></i></span>{/if}<br />
			{if $message.type eq 16}
			<img src="{$smarty.const.CDN_ROOT}/chatAttachment/thumb{$message.message}" class="chatAttachment" />
			{else if $message.type eq 17}
			{else}
			{$message.message}
			{/if}
			{if $message.type eq $smarty.const.MESSAGE_TYPE_NEGOTIATE && $message.job_status eq 1}
			<p><i>This message is out of date as the project has been closed.</i></p>
			{/if}
		</div>
		<div class="column message-controls text-right">
			{if $message.type eq $smarty.const.MESSAGE_TYPE_NEGOTIATE && $message.job_status eq 0}
{*			<a class="msgreply check button small burgundy pad-top" href="acceptrate" data-msgid="{$message.id}" data-balloon="Accept rate offer" data-balloon-pos="up">Accept</a> *}
			<a class="updateoffer money button small pad-top" href="updaterate" data-balloon="Make counter offer" data-balloon-pos="up" data-modelrate="{$message.model_desired_rate}" data-msgid="{$message.id}">Negotiate</a>
{*			<a class="msgreply cancel button small errorbutton pad-top" href="rejectrate" data-msgid="{$message.id}" data-balloon="Reject rate offer" data-balloon-pos="up">Reject</a> *}
{*			<a class="msgreply button small errorbutton pad-top" href="rejectremove" class="cancel button small" data-msgid="{$message.id}" data-balloon="Reject offer and remove model" data-balloon-pos="up">Remove Model</a> *}
			<a href="/projects/edit/{$message.jobid}" class="edit button small pad-top" data-balloon="Edit project" data-balloon-pos="up">Edit</a>
			{/if}
			<a class="delete cancel button small pad-top" href="delete" data-msgid="{$message.id}">Delete Message</a>
		</div>
	</div>
	{/if}
	{/foreach}
	{* if $companycount > $companymessages|count}
	<div class="row pager">
		<div class="column text-left">
			{if $nextpage neq 1}
			<a href="/updates{if $prevpage neq 0}/{$prevpage}{/if}"><i class="fas fa-caret-left"></i> Previous page</a>
			{else}
			&nbsp;
			{/if}
		</div>
		<div class="column text-center">
		{for $page=0 to $count}
		{if $page%20 eq 0}
		<a class="number{if ($page/20) eq $nextpage-1} current{/if}" href="/updates/{$page/20}">{($page/20)+1}</a>
		{/if}
		{/for}
		</div>
		<div class="column text-right">
			{if $nextpage * 20 lt $count}
			<a href="/updates/{$nextpage}">Next page <i class="fas fa-caret-right"></i></a>
			{else}
			&nbsp;
			{/if}
		</div>
	</div>
	{/if *}
	
	{else}
	<div class="row">
		<div class="column">
			<p>You have no messages</p>
		</div>
	</div>
	{/if}
</div>
{/block}
