{if $messages}
<h4>Messages</h4>
{foreach from=$messages item=message}
<div class="row">
	{if $message.sender neq $userid}
	<div class="column avatarholder recipient">
		<div class="box">
			<img src="{$CDN_ROOT}/avatar/thumb{$recipient.avatar}">
		</div>
	</div>
	{/if}
	<div class="column messageholder {if $message.sender eq $userid}sender{else}recipient{/if}">
		<div class="message">
			{if $usertype eq 1 && $message.sender neq $userid}<div class="messageflag flagcomposed" data-msgid="{$message.id}"><i class="fas fa-flag"></i></div>{/if}
			{if $message.sender eq $userid}<div class="messageflag deletecomposed" data-msgid="{$message.id}" data-balloon="Delete message" data-balloon-pos="up"><i class="fas fa-minus-circle"></i></div>{/if}
			{if $message.type eq 16}
			<div class="messagebody"><img src="{$smarty.const.CDN_ROOT}/chatAttachment/thumb{$message.subject}" data-filename="{$smarty.const.CDN_ROOT}/chatAttachment/large{$message.message}" class="chatAttachment" /></div>
			{else if $message.type eq 17}
			<div class="messagebody">{$message.subject}</div>
			{/if}
			{if $message.message neq ''}
			<div class="messagebody">{$message.message}</div>
			{/if}
			<div class="filler"></div>
			<div class="messagetime">{$message.timestamp|date_format:"d/m/Y, H:i"}</div>
		</div>
	</div>
	{if $message.sender eq $userid}
	<div class="column avatarholder sender">
		<div class="box">
			<img src="{$CDN_ROOT}{$avatar}">
		</div>
	</div>
	{/if}
</div>
{/foreach}
{else}
<div class="messageholder">
	<div class="message">
		There are no messages yet
	</div>
</div>
{/if}