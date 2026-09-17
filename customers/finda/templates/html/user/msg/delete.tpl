{extends "user/layout.tpl"}

{block name="main"}
<div class="col col_2">
	<div class="block">
		<a class="button small" href="/user/inbox"><span class="back">Back to Messages</span></a>
		{if $result}
		<div class="message alert">
			Message was successfully deleted.
		</div>
		{else}
		<div class="message error">
			Could not delete message.
		</div>
		{/if}
	</div>
</div>
{/block}