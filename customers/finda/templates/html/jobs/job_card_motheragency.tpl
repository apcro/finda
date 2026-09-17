<div class="job_card {$job.jobcard_type} job{$job.id}{if $job.jobcard_type eq 'deleted'} faded{/if}" 
	data-jobid="{$job.id}"
	data-modelcount="{$job.modelcount}"
	data-selectedcount="{$job.totalselectedcount}"
	data-optionedcount="{$job.optionedcount}"
	data-offeredcount="{$job.offeredcount}"
	data-negotiatingcount="{$job.negotiatingcount}"
	data-confirmablecount="{$job.acceptedcount}"
	data-confirmedcount="{$job.confirmedcount}">
	<div class="job_card_info">
		<p class="text-bold {$job.jobcard_type}">{if $job.jobcard_type eq 'deleted'}ARCHIVED{else}{$job.jobcard_type|upper}{/if}</p>
		<p>&nbsp;</p>
		<div style="font-size: 75%; font-weight: normal;">
		{if $job.jobcard_type eq 'pending' && $job.bookingtype eq 'booking'}Click ‘Edit project’ or ‘Book models’ to continue.{/if}
		{if $job.jobcard_type eq 'pending' && $job.bookingtype eq 'casting'}Click ‘Edit project’ or ‘Cast models’ to continue.{/if}
		{if $job.jobcard_type eq 'confirmable'}Click ‘Book models’ and confirm models to complete the booking.{/if}
		{if $job.jobcard_type eq 'confirmed'}Project is finalised, all models confirmed, invoice has been generated.{/if}
		{if $job.jobcard_type eq 'unfinalised'}Project has happened.{/if}
		{if $job.jobcard_type eq 'past'}This booking was not finalised in time.{/if}
		{if $job.jobcard_type eq 'due'}Project has been completed, and the invoice is now due{/if}
		{if $job.jobcard_type eq 'overdue'}Your completed booking is waiting for payment.{/if}
		{if $job.jobcard_type eq 'waiting'}Project is completed, waiting for models to complete{/if}
		{if $job.jobcard_type eq 'complete'}Project is completed{/if}
		{if $job.jobcard_type eq 'deleted'}Project has been archived. Shown only for reference.{/if}
		</div>
	</div>

	<div class="card_row">
		
		<div class="card_jobname">{$job.jobtype|upper} | {if !$sharepage}{if $job.name eq ''}Unnamed Project{else}{$job.name}{/if}{else}{if $job.name eq ''}Unnamed Project{else}{$job.name}{/if}{/if}</div>
		<div class="card_clientname"><a href="{$job.company_website}">{$job.company_name}</a></div>
		<div class="card_jobdetails">
			<div class="card_jobtype">{$job.jobtype}</div>
			<div class="row">
				<div class="column" style="padding: 0;">
					<div class="card_location"><i class="fas fa-map-marker-alt text-center"></i> {$job.location}</div>
				</div>
			</div>
			<div class="row">
				<div class="column" style="padding: 0;"><i class="fas fa-calendar-alt text-center"></i> {$job.startdate|date_format:"%d/%m/%Y %I:%M%p"}<br /><i class="fas fa-stopwatch text-center"></i> {$job.time_units} {$job.units_type}{if $job.time_units neq 1}s{/if}</div>
				{if $job.bookingtype neq 'casting'}
				<div class="column">
					{if $job.offered_rate eq 0 && $job.altrate neq ''}
					<div class="card_modelsneeded"><i class="fas fa-gift text-center"></i> <b>{$job.altrate|truncate:25:"..."}</b></div>
					{else}
					<div class="card_modelsneeded">
						<i class="fas fa-pound-sign text-center"></i> Per model: £{$job.offered_rate|number_format:2:".":","} (before negotiation)<br />
						{if $job.feetotal neq 0}<i class="fas fa-pound-sign text-center"></i> <b>Project Total: £{$job.feetotal|number_format:2:".":","}</b> including Booking fee and VAT{/if}
					</div>
					{/if}
					{if $job.agencycommission neq 0}
					<i class="fas fa-pound-sign text-center"></i> Commission: £{$job.agencycommission|number_format:2:".":","} excluding VAT
					{else}
					<i class="fas fa-pound-sign text-center"></i> Commission: <i>TBD</i>
					{/if}
				</div>
				{/if}
			</div>
			{if $job.findafee_discount gt 0 || $job.jobfee_discount gt 0}
			{if $job.findafee_discount gt 0 && $job.jobfee_discount gt 0}
			{assign "s" "s"}
			{else}
			{assign "s" ""}
			{/if}
			<div class="row">
				<div class="column" style="padding: 0;">
					<div class="card_modelsneeded">
						{if $job.findafee_discount gt 0}
						{if $job.findafee_discount eq 100}
						<i class="fas fa-tag{$s} text-center"></i>Booking fee waived
						{else}
						<i class="fas fa-tag{$s} text-center"></i>Booking fee discounted by {$job.findafee_discount|ceil}% {* only if discount is greater than 0 *}
						{/if}
						{/if}
					</div>
					<div class="card_modelsneeded">
						{if $job.jobfee_discount gt 0}<i class="fas fa-tag{$s} text-center"></i>Job discounted by {$job.jobfee_discount|ceil}%{/if}
					</div>
				</div>
			</div>
			{/if}
			
		</div>
		
	</div>

	<div class="job_card_actions">
		<a href="/dashboard/manage/{$job.model.id}">{$job.model.firstname} {$job.model.lastname}</a><br />
	</div>
	
</div>
{if $smarty.const.DEBUG}
		<span style="font-size: 8px; text-align: left;">
		<br />job ID: {$job.id}
		<br />job status: {$job.job_status}
		<br />jobcard_type: {$job.jobcard_type}
		{if $job.job_status eq 1}
			{if $job.jobcard_type neq 'complete'}
			<br />show callsheet
			{/if}
		{/if}
		{if $job.jobcard_type eq 'pending'}
		{if $job.invoice_paid neq 1}
			DEBUG:<br />Job status: {$job.job_status_text}
			{if $job.invoice_paid neq 1}
			<br />invoice not paid
			{if $job.job_status eq 0}
			<br />job status 0
			<br />show edit button
			<br />show models button
			{/if}
			{if $job.optionedmodelcount eq $job.acceptedcount && $job.job_status eq 0}
			<br />optioned count = accepted count - show close button
			{/if} 
			<br />show cancel button
			{/if}
		{else}
			<br />invoice paid<br />show finda-cancel button
		{/if}
		{/if}
		</span>
		{/if}
