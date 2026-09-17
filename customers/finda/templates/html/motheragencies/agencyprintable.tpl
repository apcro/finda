<style>
	table {
		width: 100%;
	}
	td {
		padding: 10px;
	}
	
	* {
		font-family: Arial, Helvetica, sans-serif;
	}


</style>
<table  cellspacing="0" cellpadding="0" style="border: none;">
	<tr>
		<td colspan=2 valign=top><img src="{$smarty.const.DOCROOT}/images/IDAL_black.png" width="100px" /></td>
		<td colspan=2>
			<p style="text-align: right">
			<strong>FINDA Global Ltd</strong><br />
			1st Floor South,<br />
			107-109 Great Portland Street,<br />
			London W1W 6QG
			United Kingdom<br /><br />
			support@idal.co<br /><br />
			<strong>VAT Number: 308 6782 78</strong>
			</p>
		</td>
	</tr>
	
	<tr>
		<td colspan=4>
			<h2 style="text-align: center">Invoice FND-A{$invoice.id}</h2>
		</td>
	</tr>
	
	<tr valign=top>
		<td colspan=1><strong>Date of issue: {$invoice.date_created|date_format:"%d/%m/%Y"}</strong></td>
		<td colspan=3>&nbsp;</td>
	</tr>
	<tr valign=top>
		<td colspan=1><strong>Issued to:</strong></td>
		<td colspan=3>
			{$motheragency.agencyname}
		</td>
	<tr valign=top>
		<td colspan=1><strong>VAT Number:</strong></td>
		<td colspan=3>
			{if $motheragency.vat_number neq ''}{$motheragency.vat_number}{else}Not provided{/if}
		</td>
	</tr>
	</tr>
	<tr>
		<td>
			<p><strong>Project</strong></p>
		</td>
	</tr>
	<tr>
		<td colspan=4>
			<p class="jobname">{$jobdetails.name}</p>
			<p>{$jobdetails.description}</p>
			<p>{$jobdetails.time_units} {$jobdetails.units_type}s, starting on {$jobdetails.startdate|date_format:"%d/%m/%Y"}</p>
		</td>
	</tr>
	<tr>
		<td></td>
		<td><b>Model</b></td>
		<td></td>
	</tr>
	
	{foreach from=$fees.modelfees item=modelkey}
	{if $modelkey.model.mother_agency eq $motheragency.id}
	<tr>
		<td></td>
		<td style="padding-right: 0; padding-left: 0;">{$modelkey.model.firstname} {$modelkey.model.lastname}</td>
		<td></td>
	{/if}
	</tr>
	{/foreach}

	<tr>
		<td></td>
		<td></td>
		<td style="border-bottom: 1px solid #7f7f7f; padding-right: 0; padding-left: 0;">Subtotal</td>
		<td style="border-bottom: 1px solid #7f7f7f; padding-right: 0; padding-left: 0;" align="right">£{$fees.commission|number_format:2:".":","}</td>
	</tr>
	<tr>
		<td></td>
		<td></td>
		<td style="padding-right: 0; padding-left: 0;">VAT ({$jobdetails.vat_value}%)</td>
		<td align="right" style="padding-right: 0; padding-left: 0;">£{($fees.commission * ($jobdetails.vat_value/100))|number_format:2:".":","}</td>
	</tr>
	<tr>
		<td></td>
		<td></td>
		<td style="border-bottom: 1px solid #000; padding-right: 0; padding-left: 0;"><p style="border-bottom: 1px solid #000; margin-bottom: 3px;"><strong>Total</strong></p></td>
		<td align="right" style="border-bottom: 1px solid #000; padding-right: 0; padding-left: 0;"><p style="border-bottom: 1px solid #000; margin-bottom: 3px;"><strong>£{($fees.commission * (1+($jobdetails.vat_value/100)))|number_format:2:".":","}</strong></p></td>
	</tr>
</table>