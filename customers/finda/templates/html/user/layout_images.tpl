	{* main layout for project pages *}
	<div class="row topper2_name">
		<div class="column text-center">{$banner_title}</div>
	</div>
	<div class="row topper2">
		<div class="column">
			{if $workflowStep eq 'fromeditsearch'}
			<a class="button cancelbutton" href="/projects/edit/{$workflowData.id}#findModels">Back to Search</a>
			{else}
			<a class="button cancelbutton" href="/view/{$model.sefu}">Back to Profile</a>
			{/if}
		</div>
		<div class="column text-center">
			<div class="topper2_tab portfolio active" data-type="portfolio">
				<div>Portfolio<span class="badge portfolio">{$portfolio|count}</span></div>
			</div>
		</div>
		<div class="column text-center">
			<div class="topper2_tab polaroids" data-type="polaroids">
				<div>Polaroids<span class="badge polaroids">{$polaroids|count}</span></div>
			</div>
		</div>
		<div class="column text-center">
			<a href="compcard" class="compcard" style="font-size: 2em;" data-balloon="Download PDF Portfolio" data-balloon-pos="up" data-balloon-length="short"><i class="fas fa-download"></i></a>
		</div>
		<div class="column text-right">
			{if $workflowStep neq ''}
			<a href="" class="button burgundy back-link desktop {if $job_status eq 9}optionModel{else if $job_status eq 10}optionModel{else}optionModel{/if}" data-jobid="{$workflowData.id}">{if $job_status eq 9}Select{else if $job_status eq 10}Request{else}select{/if} for Project</a>
			{else}
			{if $usertype eq 2}
			<a class="button burgundy back-link desktop" data-open="joboffers">Select for Project</a>
			{/if}
			{/if}
		</div>
	</div>
	
	
	
	<div id="main" class="grid grid-wide prod mobilepanel">
	{block name="dashboard"}
		<div class="grid-main{if $grid_background neq ''} {$grid_background}{/if}">
			{if $missingdetails != '' || ($missingbank != '' && $user.usertype eq 1)}
			<div class="notice" style="border-radius: 20px;">
				<h4>We still need some information from you</h4>
				<p>We're missing some important information before {if $user.usertype eq 1}we{else}you{/if} can pay your {if $user.usertype eq 1}self-{/if}invoices.</p>
				{if $missingdetails}<p>Please update your {$missingdetails}.</p>{/if}
				{if $missingbank && $user.usertype eq 1}<p>Please visit the <a href="/payments">payments page</a> and update your {$missingbank}.</p>{/if}
				{if $missingmeasurements && $usertype eq 1}<p>You haven't filled in your {$missingmeasurements} measurement{if $mmcount neq 1}s{/if}. Without {if $mmcount eq 1}this{else}these{/if} you will not appear in search results and Clients won't be able to offer you jobs</p>{/if}
			</div>
			{/if}
					
			{block name="main"}{/block}
		</div>
	{/block}
	</div>
	<input type="hidden" name="modelid" value="{$model.id}" />
	<input type="hidden" name="modelname" value="{$model.firstname}" />