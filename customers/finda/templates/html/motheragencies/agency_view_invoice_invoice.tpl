<div class="row row-heading">
	<div class="column">
		<h2>Invoice Details<span style="float: right"><a class="printer" href="/generate/invoice/{$invoice.id}" data-balloon="printable invoice" data-balloon-pos="left"></a></span></h2>
	</div>
</div>

{* new constructor *}

<div class="row">
	<table style="width: 100%;" cellpadding="2">
		<tbody>
			<tr>
				<td colspan="4"><b>{$jobdetails.name}</b></td>
			</tr>
			<tr>
				<td colspan="4"><em>For {$jobdetails.time_units} {$jobdetails.units_type}{if $jobdetails.time_units gt 1}s{/if}, starting on {$jobdetails.startdate|date_format:"%d/%m/%Y"}</em></td>
			</tr>
			<tr>
				<td colspan="4"><em>Job performed by:</em></td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td colspan="2">
				{foreach from=$fees.modelfees item=modelkey}
				{if $modelkey.model.mother_agency eq $motheragency}
				{$modelkey.model.firstname} {$modelkey.model.lastname}<br />
				{/if}
				{/foreach}
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
				<td>Commission earned</td>
				<td style="text-align: right">£{$fees.commission|number_format:2:".":","}</td>
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
								<td style="text-align: right">£{$fees.commission|number_format:2:".":","}</td>
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
				<td style="text-align: right">£{($fees.commission * ($jobdetails.vat_value/100))|number_format:2:".":","}</td>
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
								<td style="text-align: right; font-size: 120%"><b>£{($fees.commission * (1+($jobdetails.vat_value/100)))|number_format:2:".":","}</b></td>
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
