{extends "user/layout.tpl"}

{block name="main"}
<div class="col col_2">
	{include file='shared/notification.tpl'}
	<div class="block">
		{* compose message *}
		{if $lastpage}
		<a class="button small" href="{$lastpage.url}"><span class="back">Back to {$lastpage.desc}</a></a>
		{else}
		<a class="button small" href="/user/inbox"><span class="back">Back to Messages</a></a>
		{/if}

		<form id="post_comment" action="/user/msg/group/send" method="post">
			{if $message.composetype eq 'new'}
				<div class="row subject">
					<label for="recipientn">To:</label>
					<input type="text" disabled="disabled" value="{$msgto}" />
					<input type="hidden" name="groupid" value="{$groupid}" />
					<input type="hidden" name="returl" value="{$lastpage.url}" />
				</div>
			{else}
				<h3>{$message.subject}</h3>
				<div class="message-details">
					From <strong>{$message.sender_name}</strong><span>{$message.timestamp|date_format:"%d %B %Y"}</span>
				</div>
				{include file="user/msg/message.tpl"}
			{/if}

			<div class="row subject">
				<label for="subject">Subject:</label><input type="text" name="subject" value="{$subject}" required/>
			</div>
			<div class="row">
				<label for="message">Message:</label>
				<textarea class="tinymce compose" name="compose_message"></textarea>
			</div>

			{if $message.composetype eq 'reply'}
				<input type="hidden" name="recipientid" value="{$message.sender}">
				<input type="hidden" name="messageid" value="{$message.id}">
			{/if}

			<div class="row submit">
				<input type="submit" value="{if $message.composetype eq 'new'}Send{else}Reply{/if}"/>
			</div>
		</form>
	</div>
</div>
{/block}