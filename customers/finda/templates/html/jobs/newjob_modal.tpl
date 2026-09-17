<div class="reveal modalWhite" id="newjoboffer" data-reveal >
	<div>
		<div class="row" style="margin: 0 0 2em 0;">
			<div class="column text-center">
				<h1>Work with {$model.firstname|capitalize}</h1>
			</div>
		</div>
		<div class="row" style="margin: 1em 0;">
			<div class="column half">Book {$model.firstname|capitalize} for a new job on&nbsp;<span class="newjobdate"></span></div>
			<div class="column text-right" style="display: flex; align-items: center; justify-content: flex-end;">
				<a class="button inverted makenewjob" href="/projects/newproject">New booking</a>
			</div>
		</div>
		{if $jobs}
		<hr />
		<div class="row" style="margin: 1em 0;">
			<div class="column" style="display: flex; align-items: center;">or</div>
			<div class="column half" style="display: flex; align-items: center;">
				<div class="select-wrap">
					<select name="jobOffer" id="jobOffer" class="select" style="margin-bottom: 0;">
						<option disabled="disabled" selected="selected" value="0">Shortlist for a project</option>
						{foreach from=$jobs item=job name=job}
						<option value="{$job.id}" data-unitstype="{$job.units_type}" data-rate="{$job.offered_rate}" data-units="{$job.units_type}">{$job.name} {if $job.bookingtype neq 'casting'}({$job.models|count} selected, {$job.modelcount} needed for this job){else}({$job.bookingtype}){/if}</option>
						{/foreach}
					</select>
				</div>
			</div>
			<div class="column text-right" style="display: flex; align-items: center; justify-content: flex-end;">
				<a class="button makeoffer burgundy" name="makeoffer">Shortlist</a>
			</div>
		</div>
		{/if}
	</div>
</div>
