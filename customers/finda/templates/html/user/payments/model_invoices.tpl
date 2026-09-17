{extends "user/layout_wide.tpl"}

{block name="main"}
<div class="row mobile">
	<div class="column">
		<p class="notice">Please use your desktop or laptop to enjoy all our features. The iDAL app is coming soon!</p>
	</div>
</div>
{if $missingdetails != ''}
<div class="row">
	<div class="column">
		<div class="notice">
			<h4>We still need some information from you</h4>
			<p>We're missing some important information before we can pay your self-invoices. Please visit your <a href="/user/profile">profile page</a> and update your {$missingdetails}.</p>
		</div>
	</div>
</div>
{/if}

{if $invoices}
<div class="row" style="margin: 0; padding: 0;">
	<div class="column">
		<h4>Self-Invoices for completed bookings</h4>
	</div>
</div>

<div class="row">
	<div class="column text-left text-bold narrow">Invoice Number</div>
	<div class="column text-left text-bold narrow">Company Name</div>
	<div class="column text-left text-bold narrow">Project Name</div>
	<div class="column text-right text-bold narrow">Amount</div>
	<div class="column text-right text-bold narrow">Paid On</div>
	<div class="column text-right text-bold narrow">&nbsp;</div>
</div>

{foreach from=$invoices item=invoice name=invoice}
{if $invoice.status neq 0}
<div class="row rounded-row">
			<div class="column text-left narrow">Idal-M{$invoice.id|sprintf:"'%05d\n'"}</div>
			<div class="column text-left narrow">{$invoice.company_name}</div>
			<div class="column text-left narrow">{$invoice.project_name}</div>
			<div class="column text-right narrow">£{$invoice.value|number_format:2:".":","}</div>
			<div class="column text-right narrow">
				{if $invoice.date_paid neq 0}
				{$invoice.date_paid|date_format:"%d %b, %Y"}
				{else}
				-
				{/if}
			</div>
			<div class="column text-right narrow" style="max-width: 100%">
				<a href="/jobs/view/{$invoice.jobid}" class="money button small burgundy" style="margin: 0.5em; display: inline-block">View Job</a><br /><a href="/generate/invoice/{$invoice.id}" class="button small" data-balloon="Printable Invoice" data-balloon-pos="up" style="margin: 0.5em; display: inline-block">Print</a>
			</div>
</div>
{/if}
{/foreach}
{else}
<div class="row">
	<div class="column">
		<h4>There are no invocies to show yet.</h4>
	</div>
</div>
{/if}
{/block}