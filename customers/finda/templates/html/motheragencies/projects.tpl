{extends "motheragencies/layout_dashboard.tpl"}

{block name="main"}
<section id="projects_header">
	<div class="row">
		<div class="column">
			<h1>View Your Model's Projects</h1>
		</div>
	</div>
	<div class="row">
		<div class="blockmyprojects active projects_top">
			{if $message neq '' || $errormessage neq ''}
			<div class="row">
				<div class="column">
					{if $errormessage neq ''}
					<p class="notice">{$errormessage}</p>
					{/if}
					{if $message neq ''}
					<p>{$message}</p>
					{/if}
				</div>
			</div>
			{/if}
			<div class="row mobile">
				<div class="column">
					<div class="text-center notice">Please note that some functions are not currently available on mobile. To book models or upload a callsheet, please use a laptop or desktop computer.</div>
				</div>
			</div>
			{if $jobs}
			<div class="project_filters">
				<div class="project_filter_tab upcoming active">
					<div>Upcoming<span class="badge upcoming">{$jobs.upcoming|count}</span></div>
				</div>
				<div class="project_filter_tab past">
					<div class="text-blackcolour">To Complete<span class="badge past">{$jobs.past|count}</span></div>
				</div>
				<div class="project_filter_tab history">
					<div class="text-grey">History<span class="badge history">{$jobs.history|count}</span></div>
				</div>
				<div class="project_filter_search"></div>
			</div>
			
			{if $smarty.const.DEBUG eq 1}<p>DEBUG: total projects count: {$jobscount}</p>{/if}
			<div class="row jobcards job_upcoming">
			{foreach from=$jobs.upcoming item=job name=job}
			{include file="jobs/job_card_motheragency.tpl"}
			{/foreach}
			</div>
			
			<div class="row jobcards job_past">
			{foreach from=$jobs.past item=job name=job}
			{include file="jobs/job_card_motheragency.tpl"}
			{/foreach}
			</div>
			<div class="row jobcards job_history">
			{foreach from=$jobs.history item=job name=job}
			{include file="jobs/job_card_motheragency.tpl"}
			{/foreach}
			</div>
			
			{else}
			<div class="row">
				<div class="column text-center">
					{if $show_client_affiliate_welcome eq 1}
					<div class="client_affiliate_welcome notice_green">Congratulations! Your first model booking will be commission free! Create your first project and start discovering!</div> 
					{/if}
				
					<h2 style="transform-origin: center center; margin-top: 2em;">Sorry, there are no projects to view yet</h2>
				</div>
			</div>
			{/if}
			
			<div class="large reveal modalWhite" data-reveal id="completeJob"></div>
		</div>
	</div>
</section>
{/block}

{block name="agencymain"}
<div class="blockcompanyprojects">
	{if $message neq '' || $errormessage neq ''}
	<div class="row">
		<div class="column">
			{if $errormessage neq ''}
			<p class="notice">{$errormessage}</p>
			{/if}
			{if $message neq ''}
			<p>{$message}</p>
			{/if}
		</div>
	</div>
	{/if}
	<div class="row mobile">
		<div class="column">
			<div class="text-center notice">Please note that some functions are not currently available on mobile. To book models or upload a callsheet, please use a laptop or desktop computer.</div>
		</div>
	</div>
	{if $jobs}
	{if $smarty.const.DEBUG eq 1}<p>DEBUG: total projects count: {$jobscount}</p>{/if}
	<div class="row jobcards job_upcoming">
	{foreach from=$companyprojects.upcoming item=job name=job}
	{include file="jobs/job_card.tpl"}
	{/foreach}
	</div>
	
	<div class="row jobcards job_past">
	{foreach from=$companyprojects.past item=job name=job}
	{include file="jobs/job_card.tpl"}
	{/foreach}
	</div>
	<div class="row jobcards job_history">
	{foreach from=$companyprojects.history item=job name=job}
	{include file="jobs/job_card.tpl"}
	{/foreach}
	</div>
	
	{else}
	
	{/if}

</div>
{/block}