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
		{if $companyprojects && $job.client_uid neq $user.id}
		<span style="position: absolute; bottom: 20px;">
			<img style="border-radius: 20px" class="normal_site" src="/companylogos/{$usercompany.logo}" height=40 /><br />
			<span style="fnt-size: 80%;"><em>{$job.client_firstname} {$job.client_lastname}</em></span>
		</span>
		{/if}
	</div>

	<div class="card_row">
		
		<div class="card_jobname">{$job.projecttype|upper} | {if !$sharepage}<a href="/projects/view/{$job.id}" data-balloon="see all information" data-balloon-pos="up">{if $job.name eq ''}Unnamed Project{else}{$job.name}{/if}</a>{else}{if $job.name eq ''}Unnamed Project{else}{$job.name}{/if}{/if}</div>
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
						{if $job.projectbookingtype eq 'booking'}
						<i class="fas fa-pound-sign text-center"></i> Per model: £{$job.offered_rate|number_format:2:".":","} (before negotiation)<br />
						{if $job.feetotal neq 0}<i class="fas fa-pound-sign text-center"></i> <b>Project Total: £{$job.feetotal|number_format:2:".":","}</b> including Booking fee and VAT{/if}
						{/if}
					</div>
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
						<i class="fas fa-tag{$s} text-center"></i>Booking fee discounted by {$job.findafee_discount|ceil}%
						{/if}
						{/if}
					</div>
					<div class="card_modelsneeded">
						{if $job.jobfee_discount gt 0}<i class="fas fa-tag{$s} text-center"></i>Job discounted by {$job.jobfee_discount|ceil}%{/if}
					</div>
				</div>
			</div>
			{/if}
			{if !$sharepage}
			<div class="row">
				<div class="column" style="padding: 2em 0 0 0;">
					{if $job.callsheet neq ''}
					<i class="fas fa-file-alt text-center"></i> Callsheet: 
					<a class="card_buttonsmall button small" href="/download/callsheet/{$job.id}" style="margin-right: 3em; width: auto; min-width: 0; padding: 0.05em 0.5em;" data-balloon="Download" data-balloon-pos="up"><i class="fas fa-download text-center" style="padding: 0; margin-right: 0.5em;"></i>Download</a>
						{if $job.jobcard_type neq 'complete'}
						<a class="removecallsheet button small errorbutton" style="margin-right: 3em; width: auto; min-width: 0; padding: 0.05em 0.5em;" data-jobid="{$job.id}" data-balloon="Remove?" data-balloon-pos="up"><i class="fas fa-trash-alt" style="padding: 0; margin-right: 0.5em;"></i> Remove</a>
						{/if}
					{else if $job.jobcard_type neq 'pending'}
					{/if}
					 {if $job.jobcard_type eq 'pending' || $job.jobcard_type eq 'confirmed'}
					<a data-jobid="{$job.id}" class="desktop button small" style="width: auto; min-width: 0; padding: 0.05em 0.5em;" href="/callsheet/{$job.id}"><i class="fas fa-file-upload text-center" style="padding: 0; margin-right: 0.5em;"></i>Add Callsheet/Moodboard</a>
					{/if}
				</div>
			</div>
			{/if}
			
		</div>
		
	</div>

	{if !$sharepage}
	<div class="job_card_actions">
		<div class="dots_menu">
			{if $job.jobcard_type neq 'deleted' && !$sharepage}
			<div class="menudots"><i class="fas fa-ellipsis-h"></i></div>
			<div class="dotmenuitems">
				{if $job.jobcard_type eq 'complete'}
				<div><a data-jobid="{$job.id}" class="cancel deletejob" href="">Archive Project</a></div>
				{else}
				{if $job.job_status eq 0}<div><a href="/projects/edit/{$job.id}">Edit Project</a></div>{else}
				<div><a href="/projects/view/{$job.id}">View Project</a></div>{/if}
				{if $job.jobcard_type eq 'confirmed'}
				<div><a href="/invoices/{if $job.invoice_paid eq 0}pay{else}view{/if}/{$job.invoice_id}">{if $job.invoice_paid eq 0}Pay{else}View{/if} invoice</a></div>
				{/if}
				{if $job.job_status eq 0}
				<div><a data-jobid="{$job.id}" class="cancel canceljob" href="">Cancel Project</a></div>
				{/if}
				{/if}
			</div>
			{/if}
		</div>
		{if $job.bookingtype eq 'casting'}
		<p style="font-size: 120%">&nbsp;</p>
		{else}
		<p style="font-size: 120%"><span class="text-medium">{$job.modelcount} Model{if $job.modelcount neq 1}s{/if} needed</span></p>
		<table>
			<tr>
				<td >{$job.totalselectedcount} Selected</td>
				<td >{$job.optionedcount} Shortlisted</td>
			<tr>
				<td>{$job.offeredcount} Offered</td>
				<td>{$job.negotiatingcount} Negotiating</td>
			</tr>
			<tr>
				{if $job.acceptedcount neq 0}
				<td><a href="/projects/edit/{$job.id}#models">{$job.acceptedcount} Confirmable</a></td>
				{else}
				<td>{$job.acceptedcount} Confirmable</td>
				{/if}
				<td><span class="text-medium">{$job.confirmedcount} Confirmed</span></td>
			</tr>
		</table>
		
		{/if}
		{if $job.jobcard_type eq 'pending' || $job.jobcard_type eq 'confirmable'}
		
			{if $job.invoice_paid neq 1}
				{if $job.modelcount gte $job.confirmedcount && $job.job_status eq 0 && $job.confirmedcount neq 0}
				<div style="width: 100%; margin-top: 1em; margin-bottom: 1em;">
					<span class="desktop"><a data-jobid="{$job.id}" data-past="0" data-bookingtype="{$job.bookingtype}" class="button closejob burgundy small success">Confirm booking and models</a></span>
				</div>
				<span class="desktop"><a href="/projects/edit/{$job.id}#models" class="button small completed" data-jobid="{$job.jobid}" data-msgid="{$message.id}">{if $job.bookingtype eq 'casting'}Cast{else}Edit{/if} Models</a></span>
				{else}
				<span class="desktop"><a href="/projects/edit/{$job.id}#models" class="button small completed " data-jobid="{$job.jobid}" data-msgid="{$message.id}">{if $job.bookingtype eq 'casting'}Cast{else}Book{/if} Models</a></span>
				{/if}
				{if $job.job_status eq 0}
				<a data-jobid="{$job.id}" class="button small edit" href="/projects/edit/{$job.id}">Edit Project</a>
				{/if}
			
				{if $job.models|count eq 0}
				<span class="desktop"><a href="/projects/edit/{$job.id}#models" class="button small  completed " data-jobid="{$job.jobid}" data-msgid="{$message.id}">Find Models</a></span>
				{/if}
			{else}
				{if $job.confirmedcount neq 0}
				<a class="button  small errorbutton alert disabled" data-balloon="You have paid your invoice, please contact IDAL to cancel this project" data-balloon-pos="up" data-balloon-length="medium" href="">Cancel Project</a>
				{/if}
			{/if}
			<br />

		{/if}
		
		{if $job.jobcard_type eq 'confirmed' && !$sharepage}
			<a href="/invoices/{if $job.invoice_paid eq 0}pay{else}view{/if}/{$job.invoice_id}" class="button small  alert ">{if $job.invoice_paid eq 0}Pay{else}View{/if} invoice</a>
			<a class="button small  alert errorbutton disabled" data-balloon="Contact IDAL by emailing support@idal.co to cancel this project" data-balloon-length="medium" data-balloon-pos="up" href="">Cancel project</a>
			<a class="button small " href="/projects/view/{$job.id}">Add additional information</a>
		{/if}
		
		{if $job.jobcard_type eq 'unfinalised' || $job.jobcard_type eq 'rate models'}
			{if $job.confirmedcount neq 0}
			<a class="button small alert errorbutton" href="/support">Report a Problem</a>
			{/if}
			{if $job.invoice_paid eq 0 && $job.invoice_id neq 0 && $job.bookingtype neq 'casting'}
			<a class="button small  money errorbutton" href="/invoices{if $job.invoice_id neq 0}/pay/{$job.invoice_id}{/if}" data-balloon="Pay invoice" data-balloon-pos="up">Pay Invoice</a>
			{elseif $job.invoice_paid eq 0 && $job.invoice_id eq 0 && $job.bookingtype neq 'casting'}
			<a data-jobid="{$job.id}" class="button small  check closejob tiny success " href="" data-past="0" data-balloon="Finalise job, rate models and generate invoice" data-balloon-pos="up">Complete and Rate Models</a>
			{else}
			{if $job.confirmedcount neq 0 && $job.bookingtype neq 'casting'}
			<br /><a data-jobid="{$job.id}" data-open="completeJob" class="button small completejob" href="">Rate Models</a>
			{else}
			<a data-jobid="{$job.id}" class="button small  cancel deletejob" data-balloon="Delete project" data-balloon-pos="up">Delete</a>
			{/if}
			{/if}
		{/if}
		
		{if $job.jobcard_type eq 'past'}
			
			{if $job.invoice_paid eq 0 && $job.invoice_id neq 0 && $job.bookingtype neq 'casting'}
			<a class="button  small money errorbutton" href="/invoices{if $job.invoice_id neq 0}/pay/{$job.invoice_id}{/if}" data-balloon="Pay invoice" data-balloon-pos="up">Pay Invoice</a>
			{elseif $job.invoice_paid eq 0 && $job.invoice_id eq 0 && $job.bookingtype neq 'casting'}
			<a data-jobid="{$job.id}" class="button  small check closejob tiny success " href="" data-past="1" data-balloon="Finalise job, rate models and generate invoice" data-balloon-pos="up">Complete and Rate Models</a>
			{else}
			{if $job.confirmedmodelcount neq 0 && $job.bookingtype neq 'casting'}
			{if $job.confirmedcount neq $job.completedcount || $job.completedcount eq 0}<a data-jobid="{$job.id}" data-open="completeJob" data-bookingtype="{$job.bookingtype}" class="button completejob" href="">Complete Job</a><br />{/if}
			{else}
			<a data-jobid="{$job.id}" class="button  small cancel deletejob" data-balloon="Delete project" data-balloon-pos="up">Delete</a>
			{/if}
			{/if}

		{/if}
		{if $job.jobcard_type eq 'overdue' || $job.jobcard_type eq 'due'}
			{if $job.invoice_paid eq 0 && $job.invoice_id neq 0 && $job.bookingtype neq 'casting'}
			<a class="button  small money errorbutton" href="/invoices{if $job.invoice_id neq 0}/pay/{$job.invoice_id}{/if}" data-balloon="Pay invoice" data-balloon-pos="up">Pay Invoice</a>
			{elseif $job.invoice_paid eq 0 && $job.invoice_id eq 0 && $job.bookingtype neq 'casting'}
			<a data-jobid="{$job.id}" class="button  small check closejob tiny success " href="" data-past="1" data-balloon="Finalise job, rate models and generate invoice" data-balloon-pos="up">Complete and Rate Models</a>
			{else}
			{if $job.confirmedmodelcount neq 0 && $job.bookingtype neq 'casting'}
			{if $job.confirmedcount neq $job.completedcount || $job.completedcount eq 0}<a data-jobid="{$job.id}" data-open="completeJob" class="button completejob" href="">Complete Job</a><br />{/if}
			{else}
			<a data-jobid="{$job.id}" class="button  small cancel deletejob" data-balloon="Delete project" data-balloon-pos="up">Delete</a>
			{/if}
			{/if}
		{/if}
		
		{if $job.jobcard_type eq 'waiting'}
			<p><em>Waiting for models to mark this job as completed</em></p>
			{if $job.optionedmodelcount neq 0}
			<a class="button small alert errorbutton" href="/support">Report a Problem</a>
			{/if}
		{/if}
		
		{if $job.jobcard_type eq 'complete'}
			{if $job.invoice_paid eq 0 && $job.invoice_id neq 0 && $job.bookingtype neq 'casting'}
			<a class="button  small money errorbutton" href="/invoices{if $job.invoice_id neq 0}/pay/{$job.invoice_id}{/if}" data-balloon="Pay invoice" data-balloon-pos="up">Pay Invoice</a>
			{/if}	
			<a data-jobid="{$job.id}" class="cancel deletejob" data-balloon="Delete project" data-balloon-pos="up">Delete</a>
		
		{/if}
		{if $job.jobcard_type eq 'deleted'}
		{/if}
		
	</div>
	{/if}
	
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
