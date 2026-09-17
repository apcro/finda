<div class="row confirm_popup">
	<div class="column">
		<h2>Are you sure?</h2>
		<p>This will confirm the project with {$model.firstname}. The agreed fee for {$model.firstname} is <b>£{if $model.agreed_rate neq 0}{($model.agreed_rate * $calcunits)|number_format:2:".":","}{else}{($job.offered_rate * $calcunits)|number_format:2:".":","}{/if}</b>.</p>
		<p>By confirming, you are accepting the<br /><a class="text-bold" href="/projects/bookingterms" target="_blank">Booking Terms and Conditions</a>.</p>
		{if $modelcount eq ($confirmedcount+1)}
		<p>Confirming {$model.firstname} will also confirm the project and generate your invoice. The total fee for this job will be <b>£{$fees.totalfee|number_format:2:".":","}</b>, including £{$fees.vat|number_format:2:".":","} in VAT{if $fees.findafee neq 0} and £{$fees.findafee|number_format:2:".":","} iDAL's fees{/if}.</p>
		<p>Please pay your invoice on the the <em>invoices</em> page.</p>
		{/if}
		<p>If you need to cancel the project, please do so no later than<br /><b>48 hours</b> before the start of the project to respect each model's time.</p>
		<a class="button inverted offer_confirm" id="offer_confirm">Confirm</a>
	</div>
</div>