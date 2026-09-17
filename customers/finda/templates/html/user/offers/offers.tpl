{extends "user/layout_offers.tpl"}

{block name="main"}

{* last-minute settings *}
<div class="row">
	<div class="column">
		<div class="lastminute">
			<h4 class="text-center">Last minute jobs</h4>
			<ul>
				<li>Mark up to 6 days to set your availability for last minute jobs</li>
				<li>Guarantee to clients that you are free</li>
				<li>Increase your chances to be booked, end up on top for selected days</li>
				<li>Click twice to mark any unavailable days.</li>
			</ul>
			<div class="row">
				{foreach from=$days item=day key=k name=dayslist}
				{if $smarty.foreach.dayslist.first}
				{else}
				<div class="column text-center">
					<div class="tickbox_holder">
						<a class="rounded_tickbox {if $day eq 1}selected{else if $day eq 2}deselected{else}neutral{/if}" data-day="{$k}"></a>
						<span>{if $smarty.foreach.dayslist.iteration eq 2}<b>Tomorrow</b>{else}{$k|ucfirst}{/if}</span>
					</div>
				</div>
				{/if}
				{/foreach}
			
			</div>
				
		</div>
	
	</div>

</div>

{if $smarty.const.DEBUG}<p>DEBUG: Projects count across all tabs is {$jobscount}</p>{/if}
<div class="row mobile">
	<div class="column">
		<p class="notice">Please use your desktop or laptop to enjoy all our features. The iDAL app is coming soon!</p>
	</div>
</div>

{if $jobs}
<div class="row job_upcoming">
{foreach from=$jobs.upcoming item=job name=job}
{include file="user/offers/job_card.tpl"}
{/foreach}
</div>
<div class="row job_past">
{foreach from=$jobs.past item=job name=job}
{include file="user/offers/job_card.tpl"}
{/foreach}
</div>
<div class="row job_history">
{foreach from=$jobs.history item=job name=job}
{include file="user/offers/job_card.tpl"}
{/foreach}
</div>
{/if}

<div class="reveal modalWhite" data-reveal id="negotiateJob">
	<h2>Negotiate Rate</h2>
	<p>The current offered rate<br />is £<span class="jobrate">x</span> per <span class="jobunit">x</span>.</p>
	<input type="text" name="negotiation" placeholder="Desired Rate" class="input-group-field"/>
	<p style="font-size: 80%;"><em><span id="totaltomodel"></span></em></p>
	<h3>Reason for negotiation</h3>
	{foreach from=$negotiationreasons item=reason}
	<div class="row">
		<div class="column text-right">{$reason.name}</div>
		<div class="column text-right">
			<input class="tgl tgl-slider reason" id="reason-{$reason.tid}" type="radio" value="{$reason.tid}" name="reason" data-reason="{$reason.tid}"/>
			<label class="tgl-btn" for="reason-{$reason.tid}"></label>
		</div>
	</div>
	{/foreach}
	<div class="row">
		<div class="column"><a class="button success inverted negotiateButton">negotiate</a></div>
	</div>
	
	<input type="hidden" name="negotiate-jobid" value="" />
	<input type="hidden" name="currentrate" value="" />
</div>
<div class="reveal modalWhite" data-reveal id="rejectJob">
	<h2 class="text-center">Are you sure?</h2>
	<h3>Reason for rejection</h3>
	{foreach from=$rejectreasons item=reason}
	<div class="row">
		<div class="column text-right">{$reason.name}</div>
		<div class="column text-right">
			<input class="tgl tgl-slider rejectreason" id="reason-{$reason.tid}" type="radio" name="rejectreason" value="{$reason.tid}" data-reason="{$reason.tid}"/>
			<label class="tgl-btn" for="reason-{$reason.tid}"></label>
		</div>
	</div>
	{/foreach}
	<div class="row" style="margin-top: 2em">
		<div class="column"><button class="button white errorbutton" id="delete_confirm" type="button delete" value="Reject offer" >Reject</button></div>
		<div class="column"><button class="close button white cancel" id="delete_cancel" type="button cancel" value="Cancel" >Cancel</button></div>
	</div>
	
	<input type="hidden" name="reject-jobid" value="" />
</div>
<div class="reveal modalWhite text-white" id="moreInfo" data-reveal></div>
{/block}