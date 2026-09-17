{extends "user/layout.tpl"}

{block name="main"}
<div class="row">
	<div class="column">
		<h2>Invoice Details</h2>
	</div>
</div>

<div class="row row-heading">
	<div class="column">
		<p>Description</p>
	</div>
	<div class="column">
		<p>Model Name</p>
	</div>
	<div class="column">
		<p>Agreed Rate</p>
	</div>
	<div class="column">
		<p>Fee</p>
	</div>
</div>
<div class="row invoicerow">
	<div class="column">
		<p class="jobname">{$jobdetails.name}</p>
		<p>{$jobdetails.description}</p>
		<p>{$jobdetails.time_units} {$jobdetails.units_type}s, starting on {$jobdetails.startdate|date_format:"%d/%m/%Y"}</p>
	</div>
</div>
{foreach from=$jobdetails.models item=model name=model}
<div class="row invoicerow">
	<div class="column"></div>
	<div class="column">{$model.firstname} {$model.lastname}</div>
	<div class="column">£{$model.agreed_rate|number_format:0:".":","}/{$jobdetails.units_type}</div>
	{if $jobdetails.time_units >= 1}
	<div class="column text-right">£{($model.agreed_rate * $jobdetails.time_units)|number_format:2:".":","}</div>
	{else}
	<div class="column text-right">£{$model.agreed_rate|number_format:2:".":","}</div>
	{/if}
</div>
{/foreach}
<div class="row invoicerow">
	<div class="column"></div>
	<div class="column"></div>
	<div class="column">Booking Fee</div>
	<div class="column text-right">£{$findafee|number_format:0:".":","}</div>
</div>

<div class="row invoicerow">
	<div class="column"></div>
	<div class="column"></div>
	<div class="column" style="border-bottom: 1px solid #7f7f7f;">Subtotal</div>
	<div class="column text-right" style="border-bottom: 1px solid #7f7f7f;">£{$subtotalfee|number_format:0:".":","}</div>
</div>
<div class="row invoicerow">
	<div class="column"></div>
	<div class="column"></div>
	<div class="column" style="padding-right: 0; padding-left: 0;">VAT (20%)</div>
	<div class="column text-right">£{$vat|number_format:0:".":","}</div>
</div>
<div class="row invoicerow">
	<div class="column"></div>
	<div class="column"></div>
	<div class="column" style="border-bottom: 1px solid #000; padding-right: 0; padding-left: 0;"><p style="border-bottom: 1px solid #000; margin-bottom: 3px;"><strong>Total</strong></p></div>
	<div class="column text-right" style="border-bottom: 1px solid #000; padding-right: 0; padding-left: 0;"><p style="border-bottom: 1px solid #000; margin-bottom: 3px;"><strong>£{$totalfee|number_format:0:".":","}</strong></p></div>
</div>
<div class="row">
	<div class="column"></div>
	<div class="column"></div>
	<div class="column"></div>
	<div class="column"><button name="paynow" id="paynow" class="button bg-black hvr hvr-purple white">Pay now</button></div>
</div>
{/block}