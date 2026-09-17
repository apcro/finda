<div class="message-subject">{if $message.status == 0}<span class="newmessage">New!</span> {/if}<a href="/user/msg/{$message.id}">{$message.sender} has shared
		{if $message.data.type}
		a {if $message.data.type eq 'programme'}video{else}{$message.data.type}{/if}
		{else}
		content
		{/if}
		with you</a><br /><span>{$message.timestamp|date_format:"%d %B %Y"}</span></div>
<div class="message-controls">
{*	<a class="button small reply" href="/user/msg/reply/{$message.id}/{$message.senderid}">Reply</a> *}
	<a class="button small delete" href="{$message.id}"><span class="delete">Delete</span></a>
</div>

<div class="message-details">
{*	from {$message.sender} *}{* [<a href="/user/blockuser/{$message.senderid}">block user</a>]*}
</div>
