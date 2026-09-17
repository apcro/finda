{extends "user/layout.tpl"}

{block name="main"}
<div class="col col_2">
	<div class="block">
		<a class="button small" href="/user/inbox"><span class="back">Back to Messages</span></a>
		<div class="message-controls">
			{if $single_msg.data.type eq 'folder'}
			<a class="button small copy" href="/copy" msg-id="{$single_msg.data.nid}"><span class="save">Copy</span></a>
			{/if}
			
			{*<a class="button small delete" href="/user/msg/delete/{$single_msg.id}"><span class="delete">Delete</span></a>*}
			<a class="button small delete" href="{$single_msg.id}"><span class="delete">Delete</span></a>
			
		</div>
		<h3>{$single_msg.subject}</h3>
		<div class="message-details">From <strong>{$single_msg.sender_name}</strong><span>on {$single_msg.timestamp|date_format:"%d %B %Y"}</span></div>
		{include file="user/msg/message.tpl"}
		<a class="button small reply right" href="/user/msg/reply/{$single_msg.id}/{$single_msg.sender}">Reply</a>
	</div>
</div>
{/block}
