{extends "user/layout.tpl"}

{block name="main"}
<div class="col col_2">
	{include file='shared/notification.tpl'}
	<div class="block">
		{* compose message *}
		<!--{if $lastpage}
		<a class="button small" href="{$lastpage.url}"><span class="back">Back to {$lastpage.desc|strtolower}</a></a>
		{else}
		<a class="button small" href="/user/inbox"><span class="back">Back to messages</a></a>
		{/if}-->
		<form id="post_comment" action="/user/msg/send" method="post">
			{if $message.composetype eq 'new'}
				<div class="row subject" id="cmesg">
					<label for="recipientn">To:</label><br />
					{if $recipientn}
					<input type="text" id="recipientn" name="recipientn" disabled="disabled" value="{$recipientn}" />
					<input type="hidden" name="recipientn_id" value="{$recipientid}">
					{else}
					<input type="text" id="recipientn" name="recipientn" class="form-autocomplete" required {if $recipientn}value="{$recipientn}" {/if}/>
					<input class="autocomplete" id="recipientn-autocomplete" value="/json/finduser+" type="hidden" />
					{/if}
				</div>
			{else}
				<h3>{if $subject}{$subject}{else}{$message.subject}{/if}</h3>
				<div class="message-details">
					To <strong>{$message.sender_name}</strong><span>{$smarty.const.now|date_format:"%d %B %Y"}</span>
				</div>
				{include file="user/msg/message.tpl"}
			{/if}

			<div class="row subject">
				<label for="subject">Subject:</label><br /><input type="text" name="subject" value="{$message.subject}" required/>
			</div>
			<div class="row">
				<label for="message">Message:</label><br />
				<textarea class="tinymce compose" name="compose_message"></textarea>
			</div>

			{if $message.composetype eq 'reply'}
				<input type="hidden" name="recipientid" value="{$message.sender}">
				<input type="hidden" name="messageid" value="{$message.id}">
			{/if}

			<div class="row submit">
            	<input type="hidden" name="pagetype" value="{$pagetype}">
				<input class="button" type="submit" value="{if $message.composetype eq 'new'}Send{else}Reply{/if}"/>
			</div>
		</form>
	</div>
</div>
{/block}