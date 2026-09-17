<div class="row">
	<div class="column">
		<h1 style="transform-origin: left top;">Model Affiliate Programme</h1>
	</div>
</div>

<div class="row">
	<div class="column affiliates">
		<span style="float: right" class="text-right"><a class="affiliateinfo button burgundy small" data-open="referralInfo">How does it work?</a></span>
		<h2 style="transform-origin: left top;">Join our Model Affiliate Programme</h2>
		<p>Your personal affiliate code is: <span class="text-bold" data-balloon="Click to copy" data-balloon-pos="up"><span class="copyme" data-code="{$user.referrer_code}">{$user.referrer_code}</span></span></p>
		<p>Your personal affiliate URL is: <span class="text-bold" data-balloon="Click to copy" data-balloon-pos="up"><span class="copyme" data-code="https://idal.co/?aff_id={$user.referrer_code}">https://idal.co/?aff_id={$user.referrer_code}</span></span></p>
		<p>Click either of these to copy to your clipboard, so you can share it with your friends.</p>
	</div>
</div>

<div class="row">
	<div class="column text-center">
		<div style="display: inline-block; margin-right: 2em;">
			<a href="https://wa.me/?text=I would like to invite you to iDAL, a smart and transparent model booking platform I have started using for my projects, where you can discover talent on the go and book talent directly. You can sign up using my link to waive the commission for your first booking: https://idal.co/?aff_id={$user.referrer_code}" target="_blank"><i class="fab fa-whatsapp-square"></i><br />WhatsApp</a>
		</div>
		<div style="display: inline-block; margin-left: 2em;">
			<a href="mailto:?subject=Invitation to iDAL&body=I would like to invite you to iDAL a smart and transparent model booking platform I have started using for my projects, where you can discover talent on the go and book talent directly. You can sign up using my link to waive the commission for your first booking: https://idal.co/?aff_id={$user.referrer_code}"><i class="fas fa-envelope"></i><br />Email</a>
		</div>
	</div>
	<div class="column"></div>
</div>
<div class="row">
	<div class="column affiliates">
		<h2 style="transform-origin: left top;">Stats</h2>
		<table style="width: 100%">
		{*
			<tr>
				<td>Verified this month</td><td class="text-right">{if $affiliatesmonth neq ''}{$affiliatesmonth}{else}-{/if}</td>
			</tr>
		*}
			<tr>
				<td>Total Verified</td><td class="text-right">{$affiliates|count}</td>
			</tr>
		{*	
			<tr>
				<td>Bookings this month</td><td class="text-right">{if $jobscountmonth neq ''}{$jobscountmonth}{else}-{/if}</td>
			</tr>
		*}
			<tr>
				<td>Total bookings</td><td class="text-right">{if $jobscount neq ''}{$jobscount}{else}-{/if}</td>
			</tr>
		{*
			<tr>
				<td>Commission earned this month</td><td class="text-right">{if $jobstotalmonth neq 0}{$jobstotalmonth}{else}-{/if}</td>
			</tr>
		*}
			<tr>
				<td>Total commission earned</td><td class="text-right">£{$jobstotal|number_format:2:".":","}</td>
			</tr>

		</table>
	</div>
</div>


<div class="row">
	<div class="column affiliates">
		<h2>Your Affiliates</h2>
	</div>
</div>
{if $affiliates}
<div class="row">
	<table>
		<tr>
			<td><b>Name</b></td>
			<td><b>Joined on</b></td>
			<td></td>
			<td class="text-center"><b>Verified</b></td>
		</tr>
		
		{foreach from=$affiliates item=affiliate}
		<tr>
			{if $affiliate.usertype eq 1}
			<td><a href="/view/{$affiliate.sefu}">{$affiliate.firstname} {$affiliate.lastname}</a></td>
			{else}
			<td>{$affiliate.firstname} {$affiliate.lastname}</td>
			{/if}
			<td>{$affiliate.created|date_format:"d/M/Y"}</td>
			<td>{if $affiliate.usertype eq 1}{else if $affiliate.usertype eq 2}<a href="{$affiliate.company_website}" target="_blank">{$affiliate.company_name}</a>{/if}</td>
			<td class="text-center">{if $affiliate.status eq 1}<i class="fas fa-check text-green"></i>{else}<i class="fas fa-times text-red"></i>{/if}</td>
		</tr>
		{/foreach}
	</table>
</div>	
{else}
<div class="row">
	<div class="column">
		<p>You haven't signed any affiliates yet</p>
	</div>
</div>
{/if}
{include file="user/popups/model.referral_program.tpl"}