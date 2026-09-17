{extends "motheragencies/layout_dashboard.tpl"}

{block name="main"}
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
		<h2>Commission Payment Invoices for completed bookings</h2>
	</div>
</div>

<table>
	<tr>
		<td colspan=2 class="text-left text-bold">Invoice Number</td>
		<td class="text-left text-bold">Company Name</td>
		<td class="text-left text-bold">Project Name</td>
		<td class="text-left text-bold">Model(s)</td>
		<td class="text-right text-bold">Amount</td>
		<td class="text-right text-bold">Paid On</td>
	
	</tr>

	{foreach from=$invoices.agency item=invoice name=invoice}
	{if $invoice.status neq 0}
	<tr class="rounded-row">
		<td class="text-right">
			<a href="/generate/invoice/{$invoice.id}" data-balloon="Printable Invoice" data-balloon-pos="up" style="margin: 0.5em; display: inline-block"><i class="fas fa-print"></i></a>
		</td>
		<td class="text-left"><a href="/dashboard/viewinvoice/{$invoice.id}">A{$invoice.id|sprintf:"'%05d\n'"}</a></td>
		<td class="text-left">{$invoice.company_name}</td>
		<td class="text-left">{$invoice.jobname}</td>
		<td class="text-left">
			{foreach from=$invoice.models item=model}
			<a href="/dashboard/manage/{$model.id}">{$model.firstname} {$model.lastname}</a><br />
			{/foreach}
		</td>
		<td class="text-right">£{$invoice.value|number_format:2:".":","}</td>
		<td class="text-right">
			{if $invoice.date_paid neq 0}
			{$invoice.date_paid|date_format:"%d %b, %Y"}
			{else}
			-
			{/if}
		</td>
	</tr>
	<tr>
		<td colspan=6>&nbsp;</td>
	</tr>
	{/if}
	{/foreach}
</table>

<div class="row" style="margin: 2em 0 0 0; padding: 0;">
	<div class="column">
		<h2>Model Invoices for completed bookings</h2>
	</div>
</div>

<table>
	<tr>
		<td colspan=2 class="text-left text-bold">Invoice Number</td>
		<td class="text-left text-bold">Company Name</td>
		<td class="text-left text-bold">Project Name</td>
		<td class="text-left text-bold">Model</td>
		<td class="text-right text-bold">Amount</td>
		<td class="text-right text-bold">Paid On</td>
	
	</tr>

	{foreach from=$invoices.model item=invoice name=invoice}
	{if $invoice.status neq 0}
	<tr class="rounded-row">
		<td class="text-right">
			<a href="/generate/invoice/{$invoice.id}" data-balloon="Printable Invoice" data-balloon-pos="up" style="margin: 0.5em; display: inline-block"><i class="fas fa-print"></i></a>
		</td>
		<td class="text-left">M{$invoice.id|sprintf:"'%05d\n'"}</td>
		<td class="text-left">{$invoice.company_name}</td>
		<td class="text-left">{$invoice.jobname}</td>
		<td class="text-left">
			<a href="/dashboard/manage/{$invoice.modelid}">{$invoice.model_firstname} {$invoice.model_lastname}</a><br />
		</td>
		<td class="text-right">£{$invoice.value|number_format:2:".":","}</td>
		<td class="text-right">
			{if $invoice.date_paid neq 0}
			{$invoice.date_paid|date_format:"%d %b, %Y"}
			{else}
			-
			{/if}
		</td>
	</tr>
	{/if}
	{/foreach}
</table>
{else}
<div class="row">
	<div class="column">
		<h4>There are no invocies to show yet.</h4>
	</div>
</div>
{/if}
{/block}