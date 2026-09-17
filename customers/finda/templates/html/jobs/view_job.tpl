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
			{if $job.jobcard_type eq 'pending' && $job.invoice_paid neq 1 && $job.job_status eq 0}
			<div style="float: right; margin: 0 1em 0 0; position: absolute; right: 5px; top: 6px;">
				<a href="/projects/edit/{$job.id}" class="button small inverted">Edit project</a>
			</div>
			{/if}
		</div>

		<div class="panel active viewjob" id="tab-project-panel">
			<div class="job_card large job{$job.id}">
				<div class="card_row">
					<div class="card_type_topper {$job.jobcard_type}">{$job.jobcard_type|upper}</div>
					<div class="card_type">{if $job.jobcard_type eq 'rejected'} on {$job.modified|date_format:"%d/%m/%Y"}{/if}
					{if $job.jobcard_type eq 'pending'}Project is open, can be edited. Shortlist, request and book models.{/if}
					{if $job.jobcard_type eq 'unfinalised'}Project has happened, not all models have completed.{/if}
					{if $job.jobcard_type eq 'past'}Project start is in the past, it's not confirmed, invoice unpaid.{/if}
					{if $job.jobcard_type eq 'overdue'}Project has been completed, and the invoice is now overdue{/if}
					{if $job.jobcard_type eq 'waiting'}Project is completed, waiting for models to complete{/if}
					{if $job.jobcard_type eq 'complete'}Project is completed{/if}
					{if $job.jobcard_type eq 'deleted'}Project has been deleted. Shown only for reference.{/if}
					</div>
				
					<div class="card_jobname">{$job.name}</div>
					<div class="card_jobdetails">
						<div class="card_jobtype"><i class="fas fa-clipboard-list text-center"></i> {$job.jobtype_name}</div>
						<div class="card_location"><i class="fas fa-map-marker-alt text-center"></i> {$job.location}</div>
						<div class="card_jobdates"><i class="fas fa-calendar-alt text-center"></i> Start on <b>{$job.startdate|date_format:"%d/%m/%Y"}</b> at <b>{$job.starttime|date_format:"%I:%M%p"}</b>, for {$job.time_units} {$job.units_type}{if $job.time_units neq 1}s{/if}</div>
						{if $jobtype eq 'booking'}
						<div class="card_modelsneeded" style="margin-top: 0.5em; margin-bottom: 0.5em;"><i class="fas fa-users text-center"></i> {if $job.jobcard_type eq 'pending'}<b>{$job.modelcount}</b> model{if $job.modelcount neq 1}s{/if} needed in total, <b>{$job.models|count}</b> currently shortlisted or confirmed{else}{$job.confirmedcount} confirmed{/if}</div>
						<div class="card_modelsneeded"><i class="fas fa-pound-sign text-center"></i> {if $feetotal neq 0}Fee: <b>£{$feetotal}</b> (excluding charges and VAT){else}Offered rate: <b>£{$job.offered_rate}</b>/{$job.units_type}{/if}</div>
						{if $job.findafee_discount gt 0 || $job.modelfee_discount gt 0}
						{if $job.findafee_discount gt 0 && $job.modelfee_discount gt 0}
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
							{if $job.modelfee_discount gt 0}<i class="fas fa-tag{$s} text-center"></i>Model fee discounted by {$job.modelfee_discount|ceil}%{/if}
						</div>
						{/if}
						{/if}
						{if $job.jobcard_type eq 'confirmed' || $jobtype eq 'casting'}
						<div class="card_modelsneeded" style="margin-top: 2em;">
							<i class="fas fa-folder-plus text-center"></i> <b>Add additional information</b>:
							<div class="job_additional_information">
							<p style="text-align: left; width: 100%;">Enter any additional information necessary. This will be sent to the models associated with this project immediately.</p>
								<textarea id="job_add_info">{if $job.additional_information}{$job.additional_information}{/if}</textarea>
								<div style="text-align: right; width: 100%"><a class="savebutton button burgundy small">Send</a></div>
							</div>
						</div>
						<hr class="cyan">
						{/if}
						<h3>Description</h3>
						<div class="card_jobdescription">{$job.description|nl2br}</div>
					</div>
					{if $job.advanced.model_to_bring neq '' || $job.advanced.transport_methods neq '' || $job.advanced.model_expenses neq '' || $job.advanced.model_meeting_point neq '' || $job.advanced.makeup_provided neq ''}
					<div class="additional_information">
						<div class="extra_info">
							<h3>Additional Information</h3>
							{if $job.advanced.model_to_bring}<i>Please bring:</i> {$job.advanced.model_to_bring}<br />{/if}
							{if $job.advanced.transport_methods}<i>Transport method:</i> {$job.advanced.transport_methods}<br />{/if}
							{if $job.advanced.model_expenses}<i>Covered expenses:</i> {$job.advanced.model_expenses}<br />{/if}
							{if $job.advanced.model_meeting_point}<i>Meeting point:</i> {$job.advanced.model_meeting_point}<br />{/if}
							{if $job.advanced.makeup_provided}<i>Makeup and hair info:</i> {$job.advanced.makeup_provided}<br />{/if}
						</div>
					</div>
					{/if}
					{if $job.usage && $job.bookingtype neq 'casting'}
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
						{if $requested|count > 0 || $confirmed|count > 0 || $accepted|count > 0}
						<div class="card_models">Models</div>
						
						{if $confirmed}
						<h3>Confirmed</h3>
						<div class="row">
							{foreach from=$confirmed item=model name=model}
							<div class="column">
								<div class="modelView clientview">
									<div class="image">
										<a href="/view/{$model.sefu}"><img src="{if $model.filename}{$CDN_ROOT}/{$model.imagetype}/large{$model.filename}{else}{$default_avatar}{/if}" /></a>
										<div class="model_name">{$model.firstname}.{$model.lastname|substr:0:1}</div>
									</div>
									<div class="model_stars stars text-center" style="margin: auto 0">{for $star=1 to 5}<i class="{if $star > $model.rating}no{/if}star fas fa-star"></i>{/for}</div>
									<div class="textblock">
										{if $job.bookingtype neq 'casting'}
										{if $job.offered_rate eq 0 && $job.altrate neq ''}
										<div class="text-center">Consideration offer: {$job.altrate}</div>
										{else}
										{if $model.model_desired_rate neq 0}
										{if $model.agreed_rate eq 0}
										<div class="text-center">Model requests: £{$model.model_desired_rate}/{$job.units_type}</div>
										<div class="text-center">Current offer: £{$model.client_offered_rate}/{$job.units_type}</div>
										{else}
										<div class="text-center">Agreed rate: £{$model.agreed_rate}/{$job.units_type}</div>
										{/if}
										{else}
										{if $job.units_type eq 'unpaid'}
										<div class="text-center">Rate: unpaid</div>
										{else}
										<div class="text-center">Rate offer: £{$job.offered_rate}/{$job.units_type}</div>
										{/if}
										{/if}
										{/if}
										{/if}
										<div class="text-center">{if $model.client_notes}{$model.client_notes}{else}-{/if}</div>
										<div class="text-center">{if $model.delivery_address}<b><em>Delivery address:</em></b><br />{$model.delivery_address}{/if}</div>
									</div>
								</div>
							</div>
							{/foreach}
						</div>
						{/if}
						{if $accepted}
						<h3>Model Accepted, not Confirmed</h3>
						<div class="row">
							{foreach from=$accepted item=model name=model}
							<div class="column">
								<div class="modelView clientview">
									<div class="image">
										<a href="/view/{$model.sefu}"><img src="{if $model.avatar neq '/default_profile.png'}{$CDN_ROOT}/avatar/large{$model.avatar}{else}{if $model.filename}{$CDN_ROOT}/{$model.imagetype}/large{$model.filename}{else}{$default_avatar}{/if}{/if}" /></a>
										<div class="model_name">{$model.firstname}.{$model.lastname|substr:0:1}</div>
									</div>
									<div class="model_stars stars text-center" style="margin: auto 0">{for $star=1 to 5}<i class="{if $star > $model.rating}no{/if}star fas fa-star"></i>{/for}</div>
									<div class="textblock">
										{if $job.bookingtype neq 'casting'}
										{if $job.offered_rate eq 0 && $job.altrate neq ''}
										<div class="text-center">Consideration offer: {$job.altrate}</div>
										{else}
										{if $model.model_desired_rate neq 0}
										{if $model.agreed_rate eq 0}
										<div class="text-center">Model requests: £{$model.model_desired_rate}/{$job.units_type}</div>
										<div class="text-center">Current offer: £{$model.client_offered_rate}/{$job.units_type}</div>
										{else}
										<div class="text-center">Agreed rate: £{$model.agreed_rate}/{$job.units_type}</div>
										{/if}
										{else}
										{if $job.units_type eq 'unpaid'}
										<div class="text-center">Rate: unpaid</div>
										{else}
										<div class="text-center">Rate offer: £{$job.offered_rate}/{$job.units_type}</div>
										{/if}
										{/if}
										{/if}
										{/if}
										<div class="text-center">{if $model.client_notes}{$model.client_notes}{else}-{/if}</div>
									</div>
									
								</div>
							</div>
							{/foreach}
						</div>
						{/if}
						
						{if $requested}
						<h3>Requested, Model hasn't Accepted</h3>
						<div class="row">
							{foreach from=$requested item=model name=model}
							<div class="column">
								<div class="modelView clientview">
									<div class="image">
										<a href="/view/{$model.sefu}"><img src="{if $model.avatar neq '/default_profile.png'}{$smarty.const.CDN_ROOT}/avatar/large{$model.avatar}{else}{if $model.filename}{$CDN_ROOT}/{$model.imagetype}/large{$model.filename}{else}{$default_avatar}{/if}{/if}" /></a>
										<div class="model_name">{$model.firstname}.{$model.lastname|substr:0:1}</div>
									</div>
									<div class="model_stars stars text-center" style="margin: auto 0">{for $star=1 to 5}<i class="{if $star > $model.rating}no{/if}star fas fa-star"></i>{/for}</div>
									<div class="textblock">
										{if $job.bookingtype neq 'casting'}
										{if $job.offered_rate eq 0 && $job.altrate neq ''}
										<div class="text-center">Consideration offer: {$job.altrate}</div>
										{else}
										{if $model.model_desired_rate neq 0}
										{if $model.agreed_rate eq 0}
										<div class="text-center">Model requests: £{$model.model_desired_rate}/{$job.units_type}</div>
										<div class="text-center">Current offer: £{$model.client_offered_rate}/{$job.units_type}</div>
										{else}
										<div class="text-center">Agreed rate: £{$model.agreed_rate}/{$job.units_type}</div>
										{/if}
										{else}
										{if $job.units_type eq 'unpaid'}
										<div class="text-center">Rate: unpaid</div>
										{else}
										<div class="text-center">Rate offer: £{$job.offered_rate}/{$job.units_type}</div>
										{/if}
				
										{/if}
										{/if}
										{/if}
									</div>
								</div>
							</div>
							{/foreach}
						</div>
						{/if}
						
						{if $shortlisted}
						<h3>Shortlisted, no Offer made</h3>
						<div class="row">
							{foreach from=$shortlisted item=model name=model}
							<div class="column">
								<div class="modelView clientview">
									<div class="image">
										<a href="/view/{$model.sefu}"><img src="{if $model.avatar neq '/default_profile.png'}{$smarty.const.CDN_ROOT}/avatar/large{$model.avatar}{else}{if $model.filename}{$CDN_ROOT}/{$model.imagetype}/large{$model.filename}{else}{$default_avatar}{/if}{/if}" /></a>
										<div class="model_name">{$model.firstname}.{$model.lastname|substr:0:1}</div>
									</div>
									<div class="model_stars stars text-center" style="margin: auto 0">{for $star=1 to 5}<i class="{if $star > $model.rating}no{/if}star fas fa-star"></i>{/for}</div>
									<div class="textblock">
										{if $job.bookingtype neq 'casting'}
										{if $job.offered_rate eq 0 && $job.altrate neq ''}
										<div class="text-center">Consideration offer: {$job.altrate}</div>
										{else}
										{if $model.model_desired_rate neq 0}
										{if $model.agreed_rate eq 0}
										<div class="text-center">Model requests: £{$model.model_desired_rate}/{$job.units_type}</div>
										<div class="text-center">Current offer: £{$model.client_offered_rate}/{$job.units_type}</div>
										{else}
										<div class="text-center">Agreed rate: £{$model.agreed_rate}/{$job.units_type}</div>
										{/if}
										{else}
										{if $job.units_type eq 'unpaid'}
										<div class="text-center">Rate: unpaid</div>
										{else}
										<div class="text-center">Rate offer: £{$job.offered_rate}/{$job.units_type}</div>
										{/if}
										{/if}
										{/if}
										{/if}
									</div>
								</div>
							</div>
							{/foreach}
						</div>
						{/if}
						
						{/if}
					</div>	
				</div>
				<input type="hidden" name="jobid" value="{$job.id}" />
			</div>
		</div>
		
		<div class="panel active viewjob" id="tab-invoice-panel">
		{include file="user/invoices/client_view_invoice_invoice.tpl"}
		</div>
	</div>
</section>

{/block}