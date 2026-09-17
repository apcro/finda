{* model homepage *}
{* some housekeeping first *}
{if $hasleadimage eq 0 || $canverify eq 0}
<div class="row">
	<div class="column notice">
		{if $hasleadimage eq 0}
		<p>You have not selected a <a href="/user/portfolio">main portfolio image</a>. Without this image you will not appear in search results.</p>
		{/if} {if $canverify eq 0}
		<p>You have not completed your account yet. We still need your {$verifyfails} before you will appear in searches.</p>
		{/if}
	</div>
</div>
{/if}
{if $canverify eq 1}
{if $offered}
<div class="row text-center">
	<div class="column">
		<h2>New job offers</h2>
	</div>
</div>
<div class="row jobcards_offered">
{foreach from=$offered item=job name=jobs}
{if $smarty.foreach.jobs.index eq 5}{break}{/if}
{include file="user/offers/job_card_new.tpl"}
{/foreach}
</div>
<div class="seperator" data-gap="2"></div>
{/if}

{if $pending}
<div class="row text-center jobcards_accepted">
	<div class="column">
		<h2>Upcoming bookings</h2>
	</div>
</div>
<div class="row">
{foreach from=$pending item=job name=jobs}
{include file="user/offers/job_card.tpl"}
{/foreach}
</div>
{/if}

<div class="seperator" data-gap="2"></div>
<div class="row">
	<div class="column text-center">
		<h2>Do you know a talented model?<br />Send her your unique referral code!</h2>
		<a class="spaced button hvr white bg-black hvr-white-textblack" href="" data-space="1" data-open="referrer-code">Invite a friend</a>
	</div>
</div>
{/if}
{* /canverify *}
