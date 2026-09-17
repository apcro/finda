<div class="job_card templatecard">
	<div class="job_card_info">
		<p class="text-bold">TEMPLATE</p>
	</div>

	<div class="card_row">
		
		<div class="card_jobname">{$template.term_name|upper} | {if $template.template_name eq ''}Unnamed Template{else}{$template.template_name}{/if}</div>
		<div class="card_jobdetails">
			<div class="card_jobtype">{$template.jobtype}</div>
			<div class="row">
				<div class="column" style="padding: 0;">
					<div class="card_location"><i class="fas fa-map-marker-alt text-center"></i> {$template.location}</div>
				</div>
			</div>
			<div class="row">
				<div class="column" style="padding: 0;">
					<div class="card_location"><i class="fas fa-clipboard text-center"></i> {$template.description}</div>
				</div>
			</div>
			<div class="row">
				<div class="column" style="padding: 0;">
					<i class="fas fa-pound-sign text-center"></i> Basic Fee Per Model: £{$template.offered_rate|number_format:2:".":","}
				</div>
			</div>
			
		</div>
		
	</div>

	<div class="job_card_actions">
		<a class="button small burgundy createfromtemplate" href="/templates/create" data-templateid="{$template.id}">Create Project</a>
		<br /><br />
		<a class="button small" href="/templates/{$template.id}">Edit Templates</a>
		<a class="button small errorbutton deletetemplate" data-templateid="{$template.id} "href="/templates/delete">Delete Templates</a>
			
	</div>
	
</div>