{extends "user/layout_invoices.tpl"}

{block name="main"}
<div class="blockmyinvoices active">
	<div class="row mobile">
		<div class="column">
			<p class="notice">Please use your desktop or laptop to enjoy all our features. The iDAL app is coming soon!</p>
		</div>
	</div>
	
	{if $unpaid}
	<div class="seperator" data-gap="2"></div>
	<div class="row sub-heading">
		<div class="column">
			<h2 style="transform-origin: left top;">Invoices to be paid</h2>
		</div>
	</div>
	<div class="row row-heading text-bold">
		<div class="column" style="max-width: 20%">Invoice <br class="mobile">Number</div>
		<div class="column" style="max-width: 30%">Project Name</div>
		<div class="column text-right" style="max-width: 10%">To Pay</div>
		<div class="column text-center" style="max-width: 20%">Due Date</div>
		<div class="column" style="max-width: 20%">&nbsp;</div>
	</div>
	{foreach from=$unpaid item=invoice name=invoice}
	<div class="row offerrow{if $invoice.due_date < $smarty.now} overdue{/if}">
		<div class="column" style="max-width: 20%">FND-C{$invoice.id}</div>
		<div class="column" style="max-width: 30%"><a href="/projects/view/{$invoice.jobid}">{$invoice.jobdetails.name}</a></div>
		<div class="column text-right" style="max-width: 10%"><b>£{$invoice.value|number_format:2:".":","}</b></div>
		<div class="column text-center" style="max-width: 20%">{if $invoice.due_date < $smarty.now}<span class="text-red"><strong>{$invoice.due_date|date_format:"%d/%m/%Y"}</strong></span>{else}{$invoice.due_date|date_format:"%d/%m/%Y"}{/if}</div>
		<div class="column" style="max-width: 20%">
			<a class="button small burgundy" href="/invoices/pay/{$invoice.id}">View/Pay</a>
		</div>
	</div>
	{/foreach}
	{/if}
	
	{if $paid}
	<div class="seperator" data-gap="3"></div>
	<div class="row sub-heading">
		<div class="column">
			<h2 style="transform-origin: left top;">Invoices Paid</h2>
		</div>
	</div>
	<div class="row row-heading text-bold desktop">
		<div class="column" style="max-width: 20%">Invoice Number</div>
		<div class="column" style="max-width: 30%">Project Name</div>
		<div class="column text-right" style="max-width: 10%">Amount</div>
		<div class="column text-center" style="max-width: 20%">Paid on</div>
		<div class="column" style="max-width: 20%"></div>
	</div>
	<div class="row row-heading text-bold mobile">
		<div class="column" style="max-width: 20%">Invoice<br />Number</div>
		<div class="column" style="max-width: 30%">Project<br />Name</div>
		<div class="column" style="max-width: 10%">Amount</div>
		<div class="column text-center" style="max-width: 20%">Paid on</div>
		<div class="column"></div>
	</div>
	{foreach from=$paid item=invoice name=invoice}
	<div class="row offerrow">
		<div class="column" style="max-width: 20%">FND-C{$invoice.id}</div>
		<div class="column" style="max-width: 30%"><a href="/projects/view/{$invoice.jobid}">{$invoice.jobdetails.name}</a></div>
		<div class="column text-right" style="max-width: 10%">£{$invoice.value|number_format:2:".":","}</div>
		<div class="column text-center" style="max-width: 20%">{$invoice.date_paid|date_format:"%d/%m/%Y"}</div>
		<div class="column text-right" style="max-width: 20%"><a class="printer button small" href="/generate/invoice/{$invoice.id}" data-balloon="printable invoice" data-balloon-pos="left">print</a></div>
	</div>
	{/foreach}
	{/if}
	<input type="hidden" name="paymentsuccess" value="{$paymentsuccess}" />
</div>
{/block}





{block name="companymain"}
<div class="blockcompanyinvoices">
	<div class="row mobile">
		<div class="column">
			<p class="notice">Please use your desktop or laptop to enjoy all our features. The iDAL app is coming soon!</p>
		</div>
	</div>
	
	{if $companyunpaid}
	<div class="seperator" data-gap="2"></div>
	<div class="row sub-heading">
		<div class="column">
			<h2 style="transform-origin: left top;">Invoices to be paid</h2>
		</div>
	</div>
	<div class="row row-heading text-bold">
		<div class="column" style="max-width: 20%">Invoice <br class="mobile">Number</div>
		<div class="column" style="max-width: 30%">Project Name</div>
		<div class="column text-right" style="max-width: 10%">To Pay</div>
		<div class="column text-center" style="max-width: 20%">Due Date</div>
		<div class="column" style="max-width: 20%">&nbsp;</div>
	</div>
	{foreach from=$companyunpaid item=invoice name=invoice}
	<div class="row offerrow{if $invoice.due_date < $smarty.now} overdue{/if}">
		<div class="column" style="max-width: 20%; position: relative;">FND-C{$invoice.id}<br /><br />
			<img style="border-radius: 20px" class="normal_site" src="/companylogos/{$usercompany.logo}" height=40 /><br />
			<span style="font-size: 80%;"><em>{$invoice.firstname} {$invoice.lastname}</em></span>
		</div>
		<div class="column" style="max-width: 30%"><a href="/projects/view/{$invoice.jobid}">{$invoice.jobdetails.name}</a></div>
		<div class="column text-right" style="max-width: 10%"><b>£{$invoice.value|number_format:2:".":","}</b></div>
		<div class="column text-center" style="max-width: 20%">{if $invoice.due_date < $smarty.now}<span class="text-red"><strong>{$invoice.due_date|date_format:"%d/%m/%Y"}</strong></span>{else}{$invoice.due_date|date_format:"%d/%m/%Y"}{/if}</div>
		<div class="column" style="max-width: 20%">
			<a class="button small burgundy" href="/invoices/pay/{$invoice.id}">View/Pay</a>
		</div>
	</div>
	{/foreach}
	{/if}
	
	{if $companypaid}
	<div class="seperator" data-gap="3"></div>
	<div class="row sub-heading">
		<div class="column">
			<h2 style="transform-origin: left top;">Invoices Paid</h2>
		</div>
	</div>
	<div class="row row-heading text-bold desktop">
		<div class="column" style="max-width: 20%">Invoice Number</div>
		<div class="column" style="max-width: 30%">Project Name</div>
		<div class="column text-right" style="max-width: 10%">Amount</div>
		<div class="column text-center" style="max-width: 20%">Paid on</div>
		<div class="column" style="max-width: 20%"></div>
	</div>
	<div class="row row-heading text-bold mobile">
		<div class="column" style="max-width: 20%">Invoice<br />Number</div>
		<div class="column" style="max-width: 30%">Project<br />Name</div>
		<div class="column" style="max-width: 10%">Amount</div>
		<div class="column text-center" style="max-width: 20%">Paid on</div>
		<div class="column"></div>
	</div>
	{foreach from=$companypaid item=invoice name=invoice}
	<div class="row offerrow">
		<div class="column" style="max-width: 20%">FND-C{$invoice.id}<br /><br />
			<img style="border-radius: 20px" class="normal_site" src="/companylogos/{$usercompany.logo}" height=40 /><br />
			<span style="fnt-size: 80%;"><em>{$invoice.firstname} {$invoice.lastname}</em></span>
		</div>
		<div class="column" style="max-width: 30%">
			<a href="/projects/view/{$invoice.jobid}">{$invoice.jobdetails.name}</a>
		</div>
		<div class="column text-right" style="max-width: 10%">£{$invoice.value|number_format:2:".":","}</div>
		<div class="column text-center" style="max-width: 20%">{$invoice.date_paid|date_format:"%d/%m/%Y"}</div>
		<div class="column text-right" style="max-width: 20%"><a class="printer button small" href="/generate/invoice/{$invoice.id}" data-balloon="printable invoice" data-balloon-pos="left">print</a></div>
	</div>
	{/foreach}
	{/if}
</div>
{/block}