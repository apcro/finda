{extends "user/layout.tpl"}

{block name="main"}
<div class="row row-heading">
	<div class="column">
		<h2 style="transform-origin: left top;">Invoice Details<span style="float: right"><a class="printer" href="/generate/invoice/{$invoice.id}" data-balloon="printable invoice" data-balloon-pos="left"></a></span></h2>
		
	</div>
</div>

{* new cosntructor *}

<div class="row">
	<table style="width: 100%;" cellpadding="2">
		<tbody>
			<tr>
				<td colspan="4"><b>{$jobdetails.name}</b></td>
			</tr>
			<tr>
				<td colspan="4">{$jobdetails.name}</td>
			</tr>
			<tr>
				<td colspan="4"><em>For {$jobdetails.time_units} {$jobdetails.units_type}{if $jobdetails.time_units neq 1}s{/if}, starting on {$jobdetails.startdate|date_format:"%d/%m/%Y"}</em></td>
			</tr>
			<tr>
				<td colspan="4">&nbsp;</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td><b><em>Models</em></b></td>
				<td><b><em>Rate</em></b></td>
				<td style="text-align: right"><b><em>Fee</em></b></td>
			</tr>
			
			{foreach from=$jobdetails.models item=model name=model}
			{if $model.job_status eq 2 || $model.job_status eq 5 || $model.job_status eq 6 || $model.job_status eq 7}
			<tr>
				<td>&nbsp;</td>
				<td>{$model.firstname} {$model.lastname}</td>
				<td>£{$model.agreed_rate|number_format:2:".":","}/{$jobdetails.units_type}</td>
				{if $jobdetails.time_units >= 1}
				<td style="text-align: right">£{($model.agreed_rate * $jobdetails.time_units)|number_format:2:".":","}</td>
				{else}
				<td style="text-align: right">£{$model.agreed_rate|number_format:2:".":","}</td>
				{/if}
			</tr>
			{/if}
			{/foreach}
			
			<tr>
				<td colspan="4"></td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td colspan="2">
					<table  style="border-collapse: collapse; width: 100%">
						<tbody>
							<tr style="border-bottom: 1px dashed #000000">
								<td>Model fees total</td>
								<td style="text-align: right">£{$fees.modelsubtotal|number_format:2:".":","}</td>
							</tr>
						</tbody>
					</table>
				</td>
			</tr>
			<tr>
				<td colspan="4">&nbsp;</td>
			</tr>
			<tr>
				<td colspan="4">&nbsp;</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>Booking fee{if $jobdetails.findafee_discount gt 0}<br />(discounted: {$jobdetails.findafee_discount}%){/if}</td>
				<td style="text-align: right">£{$fees.findafee|number_format:2:".":","}</td>
			</tr>
			<tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td colspan="2">
					<table  style="border-collapse: collapse; width: 100%">
						<tbody>
							<tr style="border-bottom: 1px dashed #000000">
								<td>Subtotal</td>
								<td style="text-align: right">£{$fees.subtotalfee|number_format:2:".":","}</td>
							</tr>
						</tbody>
					</table>
				</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;VAT ({$jobdetails.vat_value}%)</td>
				<td style="text-align: right">£{$fees.vat|number_format:2:".":","}</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td colspan="2">
					<table style="border-collapse: collapse; width: 100%">
						<tbody>
							<tr style="border-bottom: 2px solid #000000">
								<td style="font-size: 120%"><b>Total</b></td>
								<td style="text-align: right; font-size: 120%"><b>£{$fees.totalfee|number_format:2:".":","}</b></td>
							</tr>
						</tbody>
					</table>
				</td>
			</tr>
			<tr style="margin-top:0; padding: 0;">
				<td></td>
				<td></td>
				<td colspan="2">
					<table style="border-collapse: collapse; width: 100%; margin: 0; padding: 0;">
						<tbody>
							<tr style="border-top: 2px solid #000000; margin: 0;">
								<td></td>
								<td></td>
							</tr>
						</tbody>
					</table>
				</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
			</tr>
		</tbody>
	</table>
</div>

<div class="row">
	<div class="column"></div>
	<div class="column text-center">
		<form action="/invoices/process" method="POST">
			<script
				src="https://checkout.stripe.com/checkout.js" class="stripe-button"
				data-key="{$smarty.const.STRIPE_PUBLICKEY}"
				data-amount="{$fees.total*100}"
				data-name="FINDA Global Ltd"
				data-description="{$jobdetails.name}"
				data-image="/images/logo_bw_70x.png"
				data-locale="auto"
				data-currency="gbp"
				data-label="Pay Now by Credit Card"
				data-email="{$mail}"
				data-allow-remember-me="false">
			</script>
			<input type="hidden" name="jobid" value="{$jobdetails.id}" />
		</form>
		{*
		<a href="https://www.stripe.com" class="stripebutton"><img src="/images/logos/powered_by_stripe_dark_sm.png" style="padding-top: 1em"/></a>
		*} 
	</div>
</div>
{if $allow_invoice}
<div class="row">
	<div class="column"></div>
	<div class="column text-center">
		<a class="button burgundy invoicebutton" href="/generate/invoice/{$invoice.id}">Pay by Invoice</a>
	</div>
</div>
{/if}

{if $smarty.const.DEBUG}
<div class="row">
	<div class="column"></div>
	<div class="column">
		<div class="testmode">
			<h4>TEST MODE - PAY NOW BUTTON</h4>
			<p>For testing purposes, please use the following details:</p>
			<p>4000000000000077 CVC: 123<br />
			Expiry Date: Any date in the future
			</p>
		</div>
	</div>
</div>
{/if}
{/block}