{extends "user/layout_projects.tpl"}
{block name="main"}
<div class="blockmyprojects active">
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
	{foreach from=$jobs.upcoming item=job name=job}
	{include file="jobs/job_card.tpl"}
	{/foreach}
	</div>
	
	<div class="row jobcards job_past">
	{foreach from=$jobs.past item=job name=job}
	{include file="jobs/job_card.tpl"}
	{/foreach}
	</div>
	<div class="row jobcards job_history">
	{foreach from=$jobs.history item=job name=job}
	{include file="jobs/job_card.tpl"}
	{/foreach}
	</div>
	
	{else}
	<div class="row">
		<div class="column text-center">
			{if $show_client_affiliate_welcome eq 1}
			<div class="client_affiliate_welcome notice_green">Congratulations! Your first model booking will be commission free! Create your first project and start discovering!</div> 
			{/if}
		
			<h1 style="transform-origin: left top; margin-top: 2em;">Create your First Project</h1>
			<p style="margin-top: 1em; margin-bottom: 1em;">You can now create your first project and negotiate and book models directly.</p>
			<a class="button" href="/projects/create">Let's get started</a>
			<div class="seperator" data-gap="4"></div>
		</div>
	</div>
	{/if}
	
	<div class="large reveal modalWhite" data-reveal id="completeJob"></div>
</div>
{/block}

{block name="companymain"}
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

{block name="templatesmain"}
<div class="blocktemplates">
	{if $jobtemplates}
	{foreach from=$jobtemplates item=template name=template}
	{include file="jobs/template_job_card.tpl"}
	{/foreach}
	{else}
	<div class="row">
		<div class="column text-center" style="margin-bottom: 4em;">
			<h4>You don't have any templates yet.</h4>
			<a class="button small" href="/templates/edit">Edit Templates</a>
		</div>
	</div>
	{/if}
</div>
{/block}