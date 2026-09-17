<div class="job_card {$job.jobcard_type} job{$job.id}{if $job.jobcard_type eq 'deleted'} faded{/if}" data-jobid="{$job.id}">
	<div class="card_type_topper {$job.jobcard_type}">{$job.jobcard_type|upper}
		{if $shareproject neq 1}
		<div class="card_readmore" style="text-align: right; padding-right: 10px;">
			<a href="/projects/view/{$job.id}">{if $job.jobcard_type neq 'confirmed'}Full{else}View or add{/if} project details <i class="fas fa-caret-right"></i></a>
		</div>
		{/if}
	</div>
	<div class="card_row">
		<div class="card_type {$job.jobcard_type}">
			<div style="font-size: 75%; font-weight: normal;">
			{if $job.jobcard_type eq 'pending'}Project is open, can be edited. Shortlist, request and book models.{/if}
			{if $job.jobcard_type eq 'confirmable'}Project can be confirmed as enough models have accepted.{/if}
			{if $job.jobcard_type eq 'confirmed'}Project is confirmed, all models confirmed, invoice has been generated.{/if}
			{if $job.jobcard_type eq 'unfinalised'}Project has happened, not all models have completed.{/if}
			{if $job.jobcard_type eq 'past'}Project start is in the past, it is not confirmed, invoice unpaid.{/if}
			{if $job.jobcard_type eq 'due'}Project has been completed, and the invoice is now due{/if}
			{if $job.jobcard_type eq 'overdue'}Project has been completed, and the invoice is now overdue{/if}
			{if $job.jobcard_type eq 'waiting'}Project is completed, waiting for models to complete{/if}
			{if $job.jobcard_type eq 'complete'}Project is completed{/if}
			{if $job.jobcard_type eq 'deleted'}Project has been deleted. Shown only for reference.{/if}
			</div>
		</div>

		
		<div class="card_jobname"><a href="/projects/view/{$job.id}" data-balloon="see all information" data-balloon-pos="up">{$job.name}</a></div>
		<div class="card_clientname"><a href="{$job.company_website}">{$job.company_name}</a></div>
		<div class="card_jobdetails">
			<div class="card_jobtype">{$job.jobtype}</div>
			<div class="card_location"><i class="fas fa-map-marker-alt text-center"></i> {$job.location}</div>
{*			<div class="card_jobdates"><i class="fas fa-calendar-alt text-center"></i> {$job.startdate|date_format:"%d/%m/%Y"}
			<div class="card_jobdates"><i class="fas fa-clock text-center"></i> {$job.starttime|date_format:"%I:%M%p"} for {$job.time_units|number_format:0:".":","} {if $job.offered_rate eq 0}{$job.altrate_unitstype}{else}{$job.units_type}{/if}{if $job.time_units neq 1}s{/if}</div></div>
			<div class="card_modelsneeded"><i class="fas fa-users text-center"></i> {if $job.jobcard_type eq 'confirmed'}<b>{$job.confirmedcount}</b> model{if $job.confirmedcount neq 1}s{/if} confirmed{else}<b>{$job.modelcount}</b> model{if $job.modelcount neq 1}s{/if} needed{if $job.confirmedcount neq 0}, {$job.confirmedcount} confirmed{/if}{/if}{if $job.modelcount eq $job.confirmedcount}<i class="fas fa-check text-center" style="color: green"></i>{/if}</div>
*}			
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
			<div class="card_modelsneeded">
				<i class="fas fa-file-alt text-center"></i> Callsheet: 
				{* if $job.jobcard_type eq 'pending' *}
				<a data-jobid="{$job.id}" class="desktop button small" style="width: auto; min-width: 0; color: #fff; padding: 0.05em 0.5em;" data-balloon="Add callsheet" data-balloon-pos="up" href="/callsheet/{$job.id}">Upload <i class="fas fa-file-upload text-center" style="padding: 0 0.5em;"></i></a>
				{* /if *}
				{if $job.callsheet neq ''}
				<a class="card_buttonsmall" href="/download/callsheet/{$job.id}" data-balloon="Download" data-balloon-pos="up"><i class="fas fa-download text-center" style="padding: 0 1em;"></i></a>
				{if $job.jobcard_type neq 'complete'}
				<a class="removecallsheet" data-jobid="{$job.id}" data-balloon="Remove?" data-balloon-pos="up"><i class="fas fa-trash-alt" style="padding: 0 1em;"></i></a>
				{/if}
				{else if $job.jobcard_type neq 'pending'}- {* yes, this single dash should be here *}
				{/if}
			</div>
		</div>
		
		{*
		<div class="card_jobdescription">{$job.description|nl2br}</div>
		*}
		<div style="height: 1em; width: 100%; display: block;"></div>
		
		<div class="card_actions">
		{if $job.jobcard_type eq 'pending' || $job.jobcard_type eq 'confirmable'}
		
			{if $job.invoice_paid neq 1}
				{if $job.job_status eq 0}
				<a data-jobid="{$job.id}" class="button small edit" href="/projects/edit/{$job.id}" data-balloon="Edit project" data-balloon-pos="up">Edit</a>
				{/if}
				<a data-jobid="{$job.id}" class="cancel canceljob" data-balloon="Cancel project" data-balloon-pos="up" href=""></a>
			
				{if $job.models|count eq 0}
				<span class="desktop"><a href="/projects/edit/{$job.id}#models" class="button small completed" data-jobid="{$job.jobid}" data-msgid="{$message.id}">Find Models</a></span>
				{else}
				<span class="desktop"><a href="/projects/edit/{$job.id}#models" class="button small completed" data-jobid="{$job.jobid}" data-msgid="{$message.id}">Edit Models</a></span>
				{/if}
				{if $job.modelcount eq $job.confirmedcount && $job.job_status eq 0}
				<div style="width: 100%">
					<span class="desktop"><a data-jobid="{$job.id}" data-past="0" class="button closejob small burgundy success" href="">Confirm project and models</a></span>
				</div>
				{/if} 
			{else}
				{if $job.confirmedcount neq 0}
				<a class="button white small errorbutton alert disabled" data-balloon="You have paid your invoice, please contact iDAL by emailing support@idal.co to cancel this project" data-balloon-pos="up" data-balloon-length="medium" href="">!</a>
				{/if}
			{/if}
			<br />
			<p style="font-size: .75em; font-weight: normal;">{$job.offeredcount} offered, {$job.acceptedcount} accepted, {$job.confirmedcount} confirmed
			{if $job.rejectedcount > 0}, {$job.rejectedcount} rejected{/if}
			</p>
		{/if}
		
		{if $job.jobcard_type eq 'confirmed'}
			<div class="card_readmore" style="width: 100%; text-align: right; padding-right: 0px;"><a href="/invoices/{if $job.invoice_paid eq 0}pay{else}view{/if}/{$job.invoice_id}">{if $job.invoice_paid eq 0}Pay{else}View{/if} invoice <i class="fas fa-caret-right"></i></a></div>
			<a class="button small white alert errorbutton disabled" data-balloon="Contact iDAL by emailing support@idal.co to cancel this project" data-balloon-pos="up" href="">!</a>
		{/if}
		
		{if $job.jobcard_type eq 'unfinalised'}
			{if $job.confirmedcount neq 0}
			<a class="button small white alert" data-balloon="Contact iDAL by emailing support@idal.co to cancel this project" data-balloon-pos="up" href="">!</a>
			{/if}
			{if $job.invoice_paid eq 0 && $job.invoice_id neq 0}
			<a class="button small white money" href="/invoices{if $job.invoice_id neq 0}/pay/{$job.invoice_id}{/if}" data-balloon="Pay invoice" data-balloon-pos="up">pay invoice</a>
			{elseif $job.invoice_paid eq 0 && $job.invoice_id eq 0}
			<a data-jobid="{$job.id}" class="button small white check closejob tiny success" href="" data-past="0" data-balloon="Confirm job and generate invoice" data-balloon-pos="up">confirm</a>
			{else}
			{if $job.confirmedcount neq 0}
			<br /><a data-jobid="{$job.id}" data-open="completeJob" class="button small white completejob" href="">Complete Job</a>
			{else}
			<a data-jobid="{$job.id}" class="button small white cancel deletejob" data-balloon="Delete project" data-balloon-pos="up">delete</a>
			{/if}
			{/if}
		{/if}
		
		{if $job.jobcard_type eq 'past'}
			
			{if $job.invoice_paid eq 0 && $job.invoice_id neq 0}
			<a class="button white small money" href="/invoices{if $job.invoice_id neq 0}/pay/{$job.invoice_id}{/if}" data-balloon="Pay invoice" data-balloon-pos="up">pay invoice</a>
			{elseif $job.invoice_paid eq 0 && $job.invoice_id eq 0}
			<a data-jobid="{$job.id}" class="button white small check closejob tiny success" href="" data-past="1" data-balloon="Confirm job and generate invoice" data-balloon-pos="up">confirm</a>
			{else}
			{if $job.confirmedmodelcount neq 0}
			{if $job.confirmedcount neq $job.completedcount || $job.completedcount eq 0}<a data-jobid="{$job.id}" data-open="completeJob" class="button burgundy completejob" href="">Complete Job</a><br />{/if}
			{else}
			<a data-jobid="{$job.id}" class="button white small cancel deletejob" data-balloon="Delete project" data-balloon-pos="up">delete</a>
			{/if}
			{/if}

		{/if}
		{if $job.jobcard_type eq 'overdue' || $job.jobcard_type eq 'due'}
			<a class="button white small money" href="/invoices{if $job.invoice_id neq 0}/pay/{$job.invoice_id}{/if}" data-balloon="Pay invoice" data-balloon-pos="up">pay invoice</a>
		{/if}
		
		{if $job.jobcard_type eq 'waiting'}
			<p><em>Waiting for models to mark this job as completed</em></p>
			{if $job.optionedmodelcount neq 0}
			<a class="button white small alert" data-balloon="Contact iDAL to cancel this project" data-balloon-pos="up" href="">!</a>
			{/if}
		{/if}
		
		{if $job.jobcard_type eq 'complete'}
			{if $job.invoice_paid eq 0 && $job.invoice_id neq 0}
			<a class="button white small money" href="/invoices{if $job.invoice_id neq 0}/pay/{$job.invoice_id}{/if}" data-balloon="Pay invoice" data-balloon-pos="up">pay invoice</a>
			{/if}	
			<a data-jobid="{$job.id}" class="cancel deletejob" data-balloon="Delete project" data-balloon-pos="up"></a>
		
		{/if}
		{if $job.jobcard_type eq 'deleted'}
		{/if}
		</div>

		{if $smarty.const.DEBUG}
		<span style="font-size: 8px; text-align: left;">
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
	</div>
</div>