{extends "user/layout.tpl"}

{block name="main"}

<section class="worko-tabs viewjob">
	<input class="tabstate" type="radio" title="Project Details" name="tabs-state" id="tab-project" checked />
	{if $invoice neq ''}
	<input class="tabstate" type="radio" title="Project Invoice" name="tabs-state" id="tab-invoice" />
	{/if}

	<div class="tabs flex-tabs">
		<div class="tab-holder">
			<div class="half-tab">
				<label for="tab-project" id="tab-project-label" class="tab text-center">Project Details</label>
			</div>
			{if $invoice neq ''}
			<div class="half-tab second">
				<label for="tab-invoice" id="tab-invoice-label" class="tab text-center">Project Invoice</label>
			</div>
			{/if}
		</div>

		<div class="panel active viewjob" id="tab-project-panel">
			<div class="job_card large job{$job.id}">
				<div class="card_row">
					<div class="card_type_topper {$job.jobcard_type}">{$job.jobcard_type|upper}</div>
					<div class="card_type">{if $job.jobcard_type eq 'rejected'} on {$job.modified|date_format:"%d/%m/%Y"}{/if}</div>
				
					<div class="card_jobname">{$job.name}</div>
					<div class="card_clientname"><a href="{$job.company_website}">{$job.company_name}</a></div>
					<div class="card_jobdetails">
						{if $job.jobtype_name neq ''}<div class="card_jobtype"><i class="fas fa-clipboard-list text-center"></i> {$job.jobtype_name}</div>{/if}
						<div class="card_location"><i class="fas fa-map-marker-alt text-center"></i> {$job.location}</div>
						{if $jobtype eq 'casting'}
						<div class="card_jobdates"><i class="fas fa-calendar-alt text-center"></i> Casting starts on <b>{$job.startdate|date_format:"%d/%m/%Y"}</b> at <b>{$job.starttime|date_format:"%I:%M%p"}</b>, and lasts for {$job.time_units} {$job.units_type}{if $job.time_units neq 1}s{/if}</div>
						{else}
						<div class="card_jobdates"><i class="fas fa-calendar-alt text-center"></i> Start on <b>{$job.startdate|date_format:"%d/%m/%Y"}</b> at <b>{$job.starttime|date_format:"%I:%M%p"}</b>, for {$job.time_units} {$job.units_type}{if $job.time_units neq 1}s{/if}</div>
						{/if}
						{if $jobtype neq 'casting'}
						<div class="card_modelsneeded">
							<i class="fas fa-pound-sign text-center"></i> {if $feetotal neq 0}Rate: <b>£{$feetotal|number_format:2:".":","}</b>{else}Offered rate: <b>£{$job.offered_rate|number_format:2:".":","}</b>/{$job.units_type}{/if}<br />
							<i class="fas fa-pound-sign text-center"></i> <em>Total to you: £{if $modeltotal neq 0}{$modeltotal|number_format:2:".":","}{else}{if $job.agreedrate neq 0}{if $job.time_units gte 1}{($job.agreed_rate * $job.time_units * 0.9)|number_format:2:".":","}{else}{($job.agreed_rate * 0.9)|number_format:2:".":","}{/if}{else}{($job.offered_rate * 0.9)|number_format:2:".":","}{/if}{/if}</em>
						</div>
						{/if}
						<h3>Description</h3>
						<div class="card_jobdescription">{$job.description|nl2br}</div>
					</div>
					{if $job.additional_information neq '' || $job.advanced.model_to_bring neq '' || $job.advanced.transport_methods neq '' || $job.advanced.model_expenses neq '' || $job.advanced.model_meeting_point neq '' || $job.advanced.makeup_provided neq ''}
					<div class="additional_information">
						<div class="extra_info">
							<h3>Additional Information</h3>
							{if $job.additional_information}<em>Notes:</em> {$job.additional_information}<br />{/if}
							{if $jobtype eq 'casting'}
							{if $job.advanced.model_to_bring}Please bring your Com cards<br />{/if}
							{if $job.advanced.transport_methods}Please bring your iPad (if you have one) with your iDAL images on it<br />{/if}
							{if $job.advanced.model_expenses}<em>Please bring the following footwear:</em> {$job.advanced.model_expenses}<br />{/if}
							{if $job.advanced.makeup_provided}<em>Hair & Makeup:</em> {$job.advanced.makeup_provided}<br />{/if}
							{else}
							{if $job.advanced.model_to_bring}<em>Please bring:</em> {$job.advanced.model_to_bring}<br />{/if}
							{if $job.advanced.transport_methods}<em>Transport:</em> {$job.advanced.transport_methods}<br />{/if}
							{if $job.advanced.model_expenses}<em>Expenses:</em> {$job.advanced.model_expenses}<br />{/if}
							{if $job.advanced.model_meeting_point}<em>Meeting point:</em> {$job.advanced.model_meeting_point}<br />{/if}
							{if $job.advanced.makeup_provided}<em>Makeup:</em> {$job.advanced.makeup_provided}<br />{/if}
							{/if}
						</div>
					</div>
					{/if}
					{if $job.usage && $jobtype neq 'casting'}
					<div class="usage_rights">
						<h3>Usage</h3>
						<b><i class="fas fa-globe"></i>Regions</b>
						<ul>
							{if $job.usage.uk eq 1}<li>UK</li>{/if}
							{if $job.usage.europe eq 1}<li>Europe</li>{/if}
							{if $job.usage.international eq 1}<li>International</li>{/if}
						</ul>
						{if $job.usagerights}
						<b><i class="fas fa-file-contract"></i> Granted Usage Rights</b>
						<ul>
						{foreach from=$job.usagerights item=right}
						<li>{$right.name}</li>
						{/foreach}
						</ul>
						{/if}
					</div>
					{/if}
					<div class="working_with">
						{if $optioned|count > 0 || $confirmed|count > 0 || $unconfirmed|count > 0}
						<div class="card_models">Models</div>
						
						{if $confirmed}
						<h3>Confirmed</h3>
						<div class="row">
							{foreach from=$confirmed item=model name=model}
							<div class="column">
								<div class="modelView clientview">
									<div class="image">
										<a href="/view/{$model.sefu}"><img src="{if $model.avatar neq '/default_profile.png'}{$CDN_ROOT}/avatar/thumb{$model.avatar}{else}{if $model.filename}{$CDN_ROOT}/{$model.imagetype}/large{$model.filename}{else}{$default_avatar}{/if}{/if}" /></a>
										<div class="model_name">{$model.firstname}.{$model.lastname|substr:0:1}</div>
									</div>
									<div class="model_stars stars text-center" style="margin: auto 0">{for $star=1 to 5}<i class="{if $star > $model.rating}no{/if}star fas fa-star"></i>{/for}</div>
									{if $job.offered_rate eq 0 && $job.altrate neq ''}
									<div class="text-center">Agreed: {$job.altrate}</div>
									{else}
									<div class="text-center">Agreed: £{$model.agreed_rate|number_format:2:".":","}/{$job.units_type}</div>
									{/if}
									<div class="text-center">{if $model.client_notes}{$model.client_notes}{else}-{/if}</div>
									
								</div>
							</div>
							{/foreach}
						</div>
						{/if}
						{/if}
					</div>		
				</div>
				
				<div class="text-center" style="margin-top: 3em;">
					{if $job.jobcard_type eq 'offered'}
					{if $job.agreed_rate eq 0 && $job.bookingtype neq 'casting'}
					<div class="button inverted job_negotiate" data-jobid="{$job.id}" data-jobrate="{if $job.client_offered_rate neq 0}{$job.client_offered_rate}{else if $job.model_desired_rate neq 0}{$job.model_desired_rate}{else}{$job.offered_rate}{/if}" data-jobunits="{$job.units_type}" data-msgid="{$message.id}" data-open="negotiateJob" >Negotiate</div>
					{/if}
					<div class="button burgundy jobaccept" data-jobid="{$job.id}" data-msgid="{$message.id}" data-requestaddress="{$job.request_address}" data-bookingtype="{$job.bookingtype}">Accept</div>
					<div class="button cancel jobreject" data-jobid="{$job.id}"data-msgid="{$message.id}" data-bookingtype="{$job.bookingtype}">Reject</div>
					{else if $job.jobcard_type eq 'optioned'}
					<div class="button inverted jobaccept" data-jobid="{$job.id}" data-msgid="{$message.id}" data-bookingtype="{$job.bookingtype}">Accept</div>
					<div class="button rejectoption" data-jobid="{$job.id}"data-msgid="{$message.id}" data-bookingtype="{$job.bookingtype}">Decline</div>
					
					{else if $job.jobcard_type eq 'accepted'}
					{if $job.callsheet neq ''}
					<div class="job_callsheet" style="display: inline-block">
						<a class="button burgundy" href="/download/callsheet/{$job.id}">Download Callsheet</a>
					</div>
					{/if}
					<div data-balloon="Cancel acceptance" data-balloon-pos="up" style="display: inline-block"><div class="button errorbutton jobcancel" data-jobid="{$job.id}">Cancel</div></div>
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
					{/if}
				</div>
				<input type="hidden" name="jobid" value="{$job.id}" />
			</div>
		</div>
		
		<div class="panel active viewjob" id="tab-invoice-panel">
			<div class="invoicewrapper">
				{include file="user/invoices/modelprintable.tpl"}
				<div class="row">
					<div class="column text-center">
						<a href="/generate/invoice/{$invoice.id}" class="printer button burgundy" data-balloon="Printable Invoice" data-balloon-pos="up" style="margin: 0.5em; display: inline-block">Print</a>
					</div>
				</div>
			</div>
		</div>
	</div>
</section>

<div class="reveal modalWhite" data-reveal id="negotiateJob">
	<h2>Negotiate Rate</h2>
	<p>The current offered rate<br />is £<span class="jobrate">x</span> per <span class="jobunit">x</span>.</p>
	<input type="text" name="negotiation" placeholder="Desired Rate" class="input-group-field"/>
	<a class="button success negotiateButton">negotiate</a>
	<input type="hidden" name="negotiate-jobid" value="{$job.id}" />
	<input type="hidden" name="currentrate" value="" />
</div>
<div class="reveal modalWhite text-white" id="moreInfo" data-reveal></div>
{/block}