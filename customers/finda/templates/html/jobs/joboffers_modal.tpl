<div class="reveal modalWhite" id="joboffers" data-reveal >
{if $jobs}
	<div>
		<div class="row">
			<div class="column">
				<h1>Shortlist {$model.firstname}</h1>
				<p class="lead">Select one of your open projects from the list, or <a href="/projects/create">create a new one</a>.</p>
			</div>
		</div>
		<div class="row">
			<div class="column">
				<div class="select-wrap">
					<select name="jobOffer" id="jobOffer" class="select">
						<option disabled="disabled" selected="selected" value="0">Select a project</option>
						{foreach from=$jobs item=job name=job}
						<option value="{$job.id}" data-unitstype="{$job.units_type}" data-rate="{$job.offered_rate}" data-units="{$job.units_type}">{$job.name} {if $job.bookingtype neq 'casting'}({$job.models|count} selected, {$job.modelcount} needed for this job){else}({$job.bookingtype}){/if}</option>
						{/foreach}
					</select>
				</div>
			</div>
			<div class="column">
				<a class="button makeoffer burgundy" name="makeoffer" style="margin-top: 1em">Shortlist</a>
			</div>
		</div>
{*		<div class="row">
			<div class="column">
				<a class="button cancelbutton" data-close>Cancel</a>
			</div>
		</div> *}
		<input type="hidden" name="modelid" value="{$model.id}" />
	</div>
{else}
	<div>
		<div class="row">
			<div class="column">
				<h1>Shortlist {$model.firstname}</h1>
				<p class="lead">You don't have any available projects at the moment</p>
				<a class="button inverted" href="/projects/create">Create a new project</a>
			</div>
		</div>
	</div>
{/if}
</div>

<div class="reveal" id="offerResponse" data-reveal></div>