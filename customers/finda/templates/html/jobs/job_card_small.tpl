<div class="job_card {$job.jobcard_type} job{$job.id}{if $job.jobcard_type eq 'deleted'} faded{/if}" data-jobid="{$job.id}">
	<div class="card_row">
		<div class="card_jobname"><a href="/projects/view/{$job.id}" data-balloon="see all information" data-balloon-pos="up">{$job.name}</a></div>
{*		<div class="card_clientname"><a href="{$job.company_website}">{$job.company_name}</a></div> *}
		<div class="card_jobdetails">
			<div class="card_jobtype">{$job.jobtype}</div>
			<div class="card_location"><i class="fas fa-map-marker-alt text-center"></i> {$job.location}</div>
			{if $job.bookingtype neq 'casting'}
			{if $job.offered_rate eq 0 && $job.altrate neq ''}
			<div class="card_modelsneeded"><i class="fas fa-gift text-center"></i> <b>{$job.altrate|truncate:25:"..."}</b></div>
			{else}
			<div class="card_modelsneeded">
				{if $job.jobcard_type eq 'confirmed'}
				<i class="fas fa-pound-sign text-center"></i> <b>Total: £{$job.feetotal|number_format:0:".":","}</b>
				{else}
				<i class="fas fa-pound-sign text-center"></i> <b>£{$job.offered_rate|number_format:0:".":","}</b>/{$job.units_type}{if $job.invoice_paid neq 0} - <em><b>invoice paid</b></em>{/if}
				{/if}
			</div>
			{/if}
			
			{if $job.findafee_discount gt 0 || $job.jobfee_discount gt 0}
			{if $job.findafee_discount gt 0 && $job.jobfee_discount gt 0}
			{assign "s" "s"}
			{else}
			{assign "s" ""}
			{/if}
			<div class="card_modelsneeded">
				{if $job.findafee_discount gt 0}
				{if $job.findafee_discount eq 100}
				<i class="fas fa-tag{$s} text-center"></i>Booking fee waived
				{else}
				<i class="fas fa-tag{$s} text-center"></i>Booking fee discounted by {$job.findafee_discount|ceil}%
				{/if}
				{/if}
			</div>
			<div class="card_modelsneeded">
				{if $job.jobfee_discount gt 0}<i class="fas fa-tag{$s} text-center"></i>Job discounted by {$job.jobfee_discount|ceil}%{/if}
			</div>
			{/if}
			{/if}
		</div>
	</div>
</div>