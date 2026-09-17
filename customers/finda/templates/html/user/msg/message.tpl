{if $single_msg.type == $smarty.const.SHARE}
{*	<p class="message-body">From {$msg.sender_name}.</p> *}
	<p>&nbsp;</p>
	<div class="block">
	{if $single_msg.data.type eq "content"}
		<h3><a href="{$single_msg.data.url}">{$single_msg.subject}</a></h3>
	{elseif $single_msg.data.type eq "programme" || $single_msg.data.type eq "video"}
		{assign var="path" value="videos"}
		{assign var="thumb_path" value="captures/175"}
		{assign var="hit" value=$single_msg.data}

	{elseif $single_msg.data.type eq 'series'}
		{assign var="path" value="series"}
		{assign var="thumb_path" value="series_thumbnail"}
		{assign var="hit" value=$single_msg.data}

	{elseif $single_msg.data.type eq 'package'}
		{assign var="path" value='package'}
		{assign var="thumb_path" value="shared"}
		{assign var="hit" value=$single_msg.data}

	{elseif $single_msg.data.type eq 'folder'}
		{assign var="path" value='user/folders'}
		{assign var="thumb_path" value="shared"}
		{assign var="hit" value=$single_msg.data}

	{elseif $single_msg.data.type eq 'page'}
		{assign var="path" value='page'}
		{assign var="thumb_path" value="shared"}
		{assign var="hit" value=$single_msg.data}

	{elseif $single_msg.data.type eq 'interactive'}
		{assign var="path" value='page'}
		{assign var="thumb_path" value="shared"}
		{assign var="hit" value=$single_msg.data}

	{else}
		{assign var="path" value=''}
		{assign var="thumb_path" value='shared'}
		{assign var="hit" value=$single_msg.data}
	{/if}
	{include file='shared/teaser_horizontal_nodotline.tpl'}
</div>
{else}
	<p class="message-body">{$single_msg.message}</p>
{/if}