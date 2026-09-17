<div class="row">
	<div class="column">
		<h2>{if $job.bookingtype eq 'casting'}Invite {$model.firstname} to this casting?{else}Request {$model.firstname} for this project?{/if}</h2>
		<p>{if $model.gender eq 'female'}Sh{else}H{/if}e will receive the request and respond shortly</p>
	</div>
</div>
<div class="row">
	<div class="column">
		{include file="jobs/job_card_small.tpl"}
	</div>
</div>
<div class="seperator" data-gap="2"></div>
<div class="row">
	<div class="column">
		<a class="confirmoffer button burgundy">Confirm {if $job.bookingtype eq 'casting'}Invitation{else}Request{/if}?</a>
	</div>
</div>