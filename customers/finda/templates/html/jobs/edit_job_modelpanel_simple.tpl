<div class="changed_banner">Please confirm your changes &nbsp;&nbsp;<i class="fas fa-chevron-up"></i></div>

<div class="row">
	{if $job.projectbookingtype eq 'booking'}
	<div class="column">
		<div class="text-center" style="width: 50%; margin-left: auto; margin-right: auto;">
			{if $job.modelcount neq 0}
			<p style="margin: 0.5em 0;"><a class="searchbutton button burgundy modelSearchButton">Select models</a></p>
			{if $jobtype eq 'casting'}
			<div class="text-burgundy" style="margin-top: 2.5em;">NOTE: Shortlist models, then 'Invite to casting' and wait for them to respond. If the casting is accepted, their status will change to 'attending'.</div>
			{/if}
			{else}
			<div class="text-burgundy" style="margin-top: 2.5em;">The number of models needed is currently 0. You will not be able to request any models until you update the project details and enter the number of models you need.</div>
			{/if}
		</div>
	</div>
	{/if}
	<div class="column confirmbuttoncolumn"{if $confirmed eq 0} style="display: none;"{/if}>
			<p style="margin: 0.5em 0;"><a class="closejob button burgundy" data-jobid="{$job.id}">Confirm booking with <span class="confirmedmodelcount">{$confirmed}</span> confirmed models</a></p>
	</div>
</div>
<div class="row">
	<div class="column modelcards">
		<div class="dotted-container">
			<div class="optioned modelcards container">
				{if models}
				{foreach from=$models item=model name=model}
					{include file="jobs/edit_job_modelcard_small.tpl"}
				{/foreach}
				{/if}
			</div>
		</div>
	</div>
</div>
{*
<div class="row">
	<div class="column text-right">
		<a class="sharebutton">Share model board with your team&nbsp;&nbsp;<i class="fas fa-share-alt"></i></a>
	</div>
</div>
*}
<input type="hidden" name="modelcount" value="{$job.modelcount}" />