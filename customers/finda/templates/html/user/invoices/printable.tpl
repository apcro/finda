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
<table>
	<tr>
		<td  colspan=5 valign=top align=center><img src="{$smarty.const.DOCROOT}/images/IDAL_black.png" width="200px" /></td>
	</tr>
	<tr>
		<td colspan=2>
			<p style="text-align: left">
				<strong>Invoice Date: </strong>{$invoice.date_created|date_format:"%d/%m/%Y"}
			</p>
			<p style="text-align: left">
				<strong>Invoice/Reference Number: FND-C{$invoice.id}</strong><br />
				When paying by bank transfer, use this number as the payment reference
			</p>
			<p style="text-align: left">
			{if $jobdetails.po_number neq ''}
				<strong>Purchase Order Number: <span style="border-bottom: 2px solid #000">{$jobdetails.po_number}</span></strong>
			{/if}
			</p>
		</td>
		<td colspan=3>
			<p style="text-align: right">
			<strong>FINDA Global Ltd</strong><br />
			1st Floor South,<br />
			107-109 Great Portland Street,<br />
			London W1W 6QG
			United Kingdom<br /><br />
			support@idal.co<br /><br /><br />
			VAT Number: <b>308 6782 78</b><br />
			Sort Code: <b>23-22-22</b><br />
			Account Number: <b>73964507</b>
			</p>
		</td>
	</tr>
	
	<tr>
		<td colspan=2 valign="top">
			{if $invoice.company && $invoice.company.invoicedetails neq ""}
			<p><b>For the attention of:</b><br />
			{$invoice.company.invoicedetails|nl2br}</p>
			{else}
			<p><b>{$client.firstname} {$client.lastname}
			{if $invoice.invoicetype eq 'client'}<br />{$client.company_name}{/if}</b></p>
			{/if}
		</td>
		<td colspan=3 valign="top">
			{if $jobdetails.order_number}<p style="text-align: right"><b>Order Number: {$jobdetails.order_number}</b></p>{/if}
		</td>
	</tr>
	<tr>
		<td colspan=5>
			<p><strong>Project at iDAL:</strong></p>
			<p class="jobname">{$jobdetails.name}</p>
			<p>{$jobdetails.description}</p>
		</td>
	</tr>
	<tr>
		<td>
			<p><strong>Models</strong></p>
		</td>
		<td>
			<p><strong>Models Rate</strong></p>
		</td>
		<td>
			<p><strong>Duration</strong></p>
		</td>

		<td>
		</td>
		<td align="right"><strong>Amount GBP</strong></td>
	</tr>
	{foreach from=$jobdetails.models item=model name=model}
	{if $model.job_status eq 2 || $model.job_status eq 5 || $model.job_status eq 6 || $model.job_status eq 7}
	<tr>
		<td>{$model.firstname} {$model.lastname}</td>
		<td>£{$model.agreed_rate|number_format:0:".":","}/{$jobdetails.units_type}</td>
		<td>{$jobdetails.time_units} {$jobdetails.units_type}{if $jobdetails.time_units gt 1}s{/if}</td>
		<td></td>
		{if $jobdetails.time_units >= 1}
		<td align="right">£{($model.agreed_rate*$jobdetails.time_units)|number_format:2:".":","}</td>
		{else}
		<td align="right">£{$model.agreed_rate|number_format:2:".":","}</td>
		{/if}
	</tr>
	{/if}
	{/foreach}
	</tr>
	<tr><td></td></tr>
	<tr>
		<td></td>
		<td></td>
		<td></td>
		<td>Booking fee{if $jobdetails.findafee_discount gt 0}
			{if $jobdetails.findafee_discount eq 100}
			<br /><em>waived</em>
			{else}
			<br /><em>discounted {$jobdetails.findafee_discount|ceil}%</em>
			{/if}
			{/if}
		</td>
		<td align="right">
			{if $jobdetails.findafee_discount eq 100}
			<em>-</em>
			{else}
			£{$fees.findafee|number_format:2:".":","}
			{/if}
		</td>
	</tr>
	<tr>
		<td></td>
		<td></td>
		<td></td>
		<td>
			{if $jobdetails.jobfee_discount neq 0}
			<em>Discount: </em>
			{/if}
		</td>
		<td align="right">
			{if $jobdetails.jobfee_discount neq 0}
			<em>{$jobdetails.jobfee_discount}%</em>
			{/if}
		</td>
	</tr>
	
	<tr>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td colspan="2">
			<table  style="border-collapse: collapse; width: 100%; border-bottom: 1px dashed #000000;">
				<tbody>
					<tr>
						<td style="padding: 0;">Subtotal</td>
						{if $jobdetails.jobfee_discount neq 0}
						<td style="text-align: right; padding: 0;">£{$fees.discountedfee|number_format:2:".":","}</td>
						{else}
						<td style="text-align: right; padding: 0;">£{$fees.subtotalfee|number_format:2:".":","}</td>
						{/if}
					</tr>
				</tbody>
			</table>
		</td>
	</tr>
	<tr>
		<td></td>
		<td></td>
		<td></td>
		<td>VAT ({$jobdetails.vat_value|number_format:0:".":","}%)</td>
		<td align="right">£{$fees.vat|number_format:2:".":","}</td>
	</tr>
	
	
	
	<tr>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td colspan="2" style="padding-bottom: 0;">
			<table style="border-collapse: collapse; width: 100%; margin: 0;border-bottom: 2px solid #000000;">
				<tbody>
					<tr>
						<td style="font-size: 120%; padding: 0;"><b>Total</b></td>
						<td style="text-align: right; font-size: 120%; padding: 0;"><b>£{$fees.totalfee|number_format:2:".":","}</b></td>
					</tr>
				</tbody>
			</table>
		</td>
	</tr>
	<tr style="margin-top:0; padding: 0;">
		<td></td>
		<td></td>
		<td></td>
		<td colspan="2" style="padding-top: 0;">
			<table style="border-collapse: collapse; width: 100%; margin: 0; padding: 0;border-top: 2px solid #000000;">
				<tbody>
					<tr style="margin: 0;">
						<td></td>
						<td></td>
					</tr>
				</tbody>
			</table>
		</td>
	</tr>
	
	
	<tr>
		<td colspan=5>
			<p><strong>Payment Strictly 30 Days</strong><br />
			FINDA Global Ltd charges interest on unpaid invoices under the terms of the Late Payment of Commercial Debt (Interest) Act, 1998<br /><br /></p>
		</td>
	</tr>
</table>