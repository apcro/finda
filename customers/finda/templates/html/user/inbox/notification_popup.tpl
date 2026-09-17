<div id="notificationContainer">
	<div id="notificationsBody" class="notifications">
		{if $messages}
		{if $usertype eq 1}
		<div class="row row-heading">
			<div class="column narrow">From</div>
			<div class="column">Notification</div>
			<div class="column narrow10">&nbsp;</div>
		</div>
		{else}
		<div class="row row-heading">
			<div class="column modelimage"><span style="width: 75px; display: block;">From</span></div>
			<div class="column narrow">&nbsp;</div>
			<div class="column">Notification</div>
			<div class="column narrow10">&nbsp;</div>
		</div>
		{/if}
		{foreach from=$messages item=message name=message}
		{if $usertype eq 1}
		<div class="row notes msg{$message.id}{if $smarty.foreach.message.iteration%2 eq 0} alternate{/if}{if $message.status eq 1} read{/if}" data-jobid="{$message.jobid}" data-msgtype="{$message.type}" data-usertype="{$usertype}" data-msgid="{$message.id}">
			<div class="column narrow">{$message.firstname} {$message.lastname}</div>
			<div class="column"><span class="datetime">{$message.timestamp|date_format:"%d %B %Y"}</span><br />{$message.message}</div>
			<div class="column message-controls narrow10 text-right">
{*				<a class="success money" href="/jobs" data-balloon="View open offers" data-balloon-pos="up" ></a> *}
				<a class="delete cancel" href="delete" data-msgid="{$message.id}" data-balloon="Delete message" data-balloon-pos="left" ></a>
			</div>
		</div>
		{else}
		<div class="row notes msg{$message.id}{if $smarty.foreach.message.iteration%2 eq 0} alternate{/if}" data-jobid="{$message.jobid}" data-msgtype="{$message.type}" data-usertype="{$usertype}" data-msgid="{$message.id}">
			<div class="column modelimage"><a href="/view/{$message.sender}"><img src="{if $message.filename}{$smarty.const.CDN_ROOT}/{$message.imagetype}/large{$message.filename}{else}{$default_avatar}{/if}" /></a></div>
			<div class="column modelname narrow"><span><a class="modelname" href="/view/{$message.sender}">{$message.firstname} {$message.lastname}</a></span></div>
			<div class="column"><span class="datetime">{$message.timestamp|date_format:"%d %B %Y"}</span><br />{$message.message}</div>
			<div class="column message-controls narrow10 text-right">
				<a class="delete cancel" href="delete" data-msgid="{$message.id}" data-balloon="Delete message" data-balloon-pos="up"></a>
			</div>
		</div>
		{/if}
		{/foreach}
		{else}
		<div class="row">
			<div class="column">
				<p>You have no messages</p>
			</div>
		</div>
		{/if}
	</div>
	<div id="notificationFooter"><a href="/updates">See All</a></div>
</div>