<div class="job_card job{$job.id}{if $job.jobcard_type eq 'rejected' || $job.jobcard_type eq 'unconfirmed'} faded{/if}">

	<div class="job_card_info">
		<p class="text-bold {$job.jobcard_type}">
		{if $job.bookingtype eq 'casting'}
		{if $job.jobcard_type eq 'offered'}INVITED{else if $job.jobcard_type eq 'confirmed'}INVITATION ACCEPTED{else}{$job.jobcard_type|upper}{/if}
		{else}
		{if $job.jobcard_type eq 'accepted'}WAITING{else}{$job.jobcard_type|upper}{/if}
		{/if}
		</p>
		<p>&nbsp;</p>
		<div style="font-size: 75%; font-weight: normal;">
		{* these are currently client definitions *}
		{if $job.jobcard_type eq 'pending'}Project is open, can be edited. Shortlist, request and book models.{/if}
		{if $job.jobcard_type eq 'unfinalised'}Project has happened, not all models have completed.{/if}
		{if $job.jobcard_type eq 'past'}Project start is in the past, it's not closed, invoice unpaid.{/if}
		{if $job.jobcard_type eq 'overdue'}Project has been completed, and the invoice is now overdue{/if}
		{if $job.jobcard_type eq 'waiting'}Project is completed, waiting for models to complete{/if}
		{if $job.jobcard_type eq 'complete'}Project is completed{/if}
		{if $job.jobcard_type eq 'deleted'}Project has been deleted. Shown only for reference.{/if}
		{if $job.jobcard_type eq 'accepted'}You have accepted this job. Please wait for client to confirm your acceptance.{/if}
		{if $job.jobcard_type eq 'unconfirmed'}You were not confirmed for this job. Shown only for reference.{/if}
		</div>
	</div>
	
	<div class="card_row">
		<div class="card_jobname">{if $job.jobtype neq ''}{$job.jobtype|upper} | {/if}{if $job.jobcard_type neq 'deleted' && $job.jobcard_type neq 'unconfirmed'}{$job.name}{else}{$job.name}{/if}</div>
		<div class="card_clientname"><a href="{$job.company_website}">{$job.company_name}</a></div>
		<div class="card_jobdetails">
			<div class="card_jobtype"><i class="fas fa-clipboard-list text-center"></i> {$job.jobtype}</div>
			<div class="card_location"><i class="fas fa-map-marker-alt text-center"></i> {$job.location}</div>
			<div class="card_jobdates"><i class="fas fa-calendar-alt text-center"></i> {$job.startdate|date_format:"%d/%m/%Y"}</div>
			{if $job.bookingtype eq 'casting'}
			<div class="card_jobdates"><i class="fas fa-clock text-center"></i> Casting starts at {$job.starttime|date_format:"%I:%M%p"} and lasts for {$job.time_units} {$job.units_type}{if $job.time_units neq 1}s{/if}. You may arrive at any time during this period.</div>
			{else}
			<div class="card_jobdates"><i class="fas fa-clock text-center"></i> Call time: {$job.starttime|date_format:"%I:%M%p"}</div>
			<div class="card_jobdates"><i class="fas fa-stopwatch text-center"></i> Duration: {if $job.time_units eq 0.5}Half {else}{$job.time_units}{/if} {if $job.offered_rate eq 0}{$job.altrate_unitstype}{else}{$job.units_type}{/if}{if $job.calc_units > 1}s{/if}</div>
			{/if}
		</div>
		{if $job.bookingtype neq 'casting'}
			{if $job.jobcard_type eq 'offered' || $job.jobcard_type eq 'optioned'}
				{if $job.altrate neq '' && $job.units_type eq 'unpaid'}
				<div class="card_rate"><i class="fas fa-gift text-center"></i> Offered consideration:</div>
				<div class="card_rate"><i class="fas text-center"></i> <a href="/jobs/view/{$job.id}">{$job.altrate|truncate:30:"..."}</a></div>
				{else}
					{if $job.agreed_rate eq 0}
					<div class="card_rate">
						<i class="fas fa-pound-sign text-center"></i> Base offer: £{$job.offered_rate|number_format:2:".":","}/{if $job.time_units eq 0.5}half {/if}{$job.units_type} (<em>£{($job.offered_rate*$job.calc_units) * 0.9|number_format:2:".":","} total to you{if $user.mother_agency neq 0}, less £{($job.offered_rate*$job.calc_units) * $commissionrate|number_format:2:".":","} Mother Agency commission{/if}</em>)<br />
						{if $job.model_desired_rate neq 0}
						<i class="fas text-center"></i> You requested £{$job.model_desired_rate|number_format:0:".":","}/{if $job.time_units eq 0.5}half {/if}{$job.units_type} (<em>£{(($job.model_desired_rate*$job.calc_units) * 0.9)|number_format:2:".":","} total to you{if $user.mother_agency neq 0}, less £{($job.offered_rate*$job.calc_units) * $commissionrate|number_format:2:".":","} Mother Agency commission{/if}</em>){if $job.client_offered_rate neq 0 && $job.client_offered_rate neq $job.offered_rate},<br /><span style="margin-left: 20px; display: inline-block;"> <em>{$job.company_name}</em> has offered £{$job.client_offered_rate|number_format:0:".":","}/{if $job.time_units eq 0.5}half {/if}{$job.units_type}.</span>{/if}
						{/if}
						</div>
					{else}
					<div class="card_rate">
						<i class="fas fa-pound-sign text-center"></i> Agreed rate: £{$job.agreed_rate|number_format:0:".":","}/{if $job.time_units eq 0.5}half {/if}{$job.units_type}<br />
						{if $job.time_units >= 1}
						<i class="fas fa-pound-sign text-center"></i> Total to you: £{(($job.agreed_rate * $job.time_units) * 0.9)|number_format:2:".":","}
						{else}
						<i class="fas fa-pound-sign text-center"></i> Total to you: £{($job.agreed_rate * 0.9)|number_format:2:".":","}
						{/if}
					</div>
					<div class="card_rate"><i class="fas text-center">&nbsp;</i> <i>{$job.company_name} has agreed to your desired rate.</i><br /><br /></div>
					{/if}
				{/if}
			
			{else if $job.jobcard_type eq 'optioned'}
				{if $job.altrate neq ''}
				<div class="card_rate"><i class="fas fa-gift text-center"></i> Offered consideration:<br />
				<i class="fas text-center"></i> <a href="/jobs/view/{$job.id}">{$job.altrate|truncate:30:"..."}</a></div>
				{else}
				<div class="card_rate"><i class="fas fa-pound-sign text-center"></i> Offered rate: <span data-balloon="Fee negotiable in case of booking request" data-balloon-pos="left" data-balloon-length="medium">£{$job.offered_rate|number_format:2:".":","}/{if $job.time_units eq 0.5}half {/if}{$job.units_type}</span></div>
				{/if}
				<div class="text-center"><span class="card_button card_buttonsmall job_negotiate" data-jobid="{$job.jobid}" data-jobrate="{$job.offered_rate}" data-jobunits="{$job.units_type}" data-msgid="{$message.id}" data-open="negotiateJob" >Negotiate</span></div>
			{else}
				{if $job.altrate neq ''}
				<div class="card_rate"><i class="fas fa-gift text-center"></i>Agreed consideration:<br />
				<i class="fas text-center"></i> <a href="/jobs/view/{$job.id}">{$job.altrate|truncate:30:"..."}</a></div>
				{else}
					{if $job.agreed_rate neq 0}
					<div class="card_rate"><i class="fas fa-pound-sign text-center"></i> Total fee: £{($job.agreed_rate*$job.calc_units)|number_format:2:".":","}<br />
						<i class="fas fa-pound-sign text-center"></i> <em>Total to you: £{(($job.agreed_rate*$job.calc_units) * 0.9)|number_format:2:".":","}
						{if $user.mother_agency neq 0}, less Mother Agency commission of: £{(($job.agreed_rate*$job.calc_units) * $commissionrate)|number_format:2:".":","}
						{/if}</em>
					</div>
					{else}
					<div class="card_rate"><i class="fas fa-pound-sign text-center"></i> Offered rate: £{$job.offered_rate|number_format:2:".":","}/{if $job.time_units eq 0.5}half {/if}{$job.units_type}</div>
					{/if}
				{/if}
			{/if}
			{if $job.advanced.contact_number neq ''}
			{if $job.startdate gte ($smarty.now + (60*60*24))}
			<div class="card_rate"><i class="fas fa-phone text-center"></i>Contact Details: <em>Will be available 24 hours before job start</em></div>
			{else}
			<div class="card_rate"><i class="fas fa-phone text-center"></i>Contact Details: {$job.advanced.contact_number}</div>
			{/if}
			{/if}
		{/if}
		<div class="card_jobdescription">
			<a href="/jobs/view/{$job.id}" data-balloon="See all information" data-balloon-pos="up">All Details</a>
		</div>
		
	</div>
	<div class="job_card_actions">
		{if $job.jobcard_type eq 'offered'}
		{if $job.agreed_rate eq 0 && $job.bookingtype neq 'casting'}
		<div class="text-center"><span class="button inverted job_negotiate" data-jobid="{$job.jobid}" data-jobrate="{if $job.client_offered_rate neq 0}{$job.client_offered_rate}{else if $job.model_desired_rate neq 0}{$job.model_desired_rate}{else}{$job.offered_rate}{/if}" data-jobunits="{$job.units_type}" data-timeunits="{if $job.time_units >= 1}{$job.time_units}{else}1{/if}" data-msgid="{$message.id}" data-open="negotiateJob" >Negotiate</span></div>
		{/if}
		<div class="button burgundy jobaccept" data-jobid="{$job.id}" data-msgid="{$message.id}" data-requestaddress="{$job.request_address}" data-bookingtype="{$job.bookingtype}">Accept</div>
		<div class="button cancel jobreject" data-jobid="{$job.id}"data-msgid="{$message.id}" data-bookingtype="{$job.bookingtype}" data-open="rejectJob">Reject</div>
		{else if $job.jobcard_type eq 'optioned'}
		<div class="button inverted jobaccept" data-jobid="{$job.id}" data-msgid="{$message.id}" data-bookingtype="{$job.bookingtype}">Accept</div>
		<div class="button rejectoption" data-jobid="{$job.id}"data-msgid="{$message.id}" data-bookingtype="{$job.bookingtype}">Decline</div>
		
		{* else if $job.jobcard_type eq 'accepted' || $job.jobcard_type eq 'confirmed' *}
		{else if $job.jobcard_type eq 'confirmed'}
		{if $job.callsheet neq ''}
		<div class="job_callsheet text-center">
			<a class="button" href="/download/callsheet/{$job.id}">Download Callsheet</a>
		</div>
		{/if}
		<div data-balloon="Messages between you and {$job.client_firstname}{if $job.company_name neq ''} from {$job.company_name}{/if}" data-balloon-pos="up" style="margin-bottom: 2em;"><a href="/messages/{$job.client_sefu}" class="button burgundy"><i class="fa fa-comment-dots"></i> Messages</a></div>
		<div data-balloon="Cancel acceptance" data-balloon-pos="up"><div class="button errorbutton jobcancel" data-jobid="{$job.id}">Cancel</div></div>
		{else if $job.jobcard_type eq 'finished' || $job.jobcard_type eq 'to complete'}
		{if $job.status neq 5 && $job.status neq 7}
		<div  data-balloon="Mark this job as complete. This is needed for you to receive payment." data-balloon-length="medium" data-balloon-pos="up"><div class="button inverted completed" data-jobid="{$job.jobid}" data-msgid="{$message.id}">Complete</div></div>
		{else}
		{if $job.status neq 7}
		<p class="text-blue">Waiting for Client to complete</p>
		{/if}
		{/if}
		{else if $job.jobcard_type eq 'unfinalised'}
		<div data-balloon="Mark this job as Complete. This is needed for you to receive payment." data-balloon-length="medium" data-balloon-pos="up"><div class="button inverted completed" data-jobid="{$job.jobid}" data-msgid="{$message.id}">Complete</div></div>
		{else if $job.jobcard_type eq 'completed'}
		{else if $job.jobcard_type eq 'expired'}
		{else if $job.jobcard_type eq 'unconfirmed'}
			<p>Another model has been confirmed</p>
		{/if}
	</div>
</div>
