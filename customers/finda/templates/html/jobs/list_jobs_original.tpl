{extends "user/layout.tpl"}
{block name="main"}
<div class="row">
	<div class="column">
		<h1>Let's sort out your schedule...</h1>
	</div>
</div>
<div class="row">
	<div class="column">
		<h4>Upcoming Projects</h4>
		<p>DEBUG: projects count: {$jobscount}</p>
	</div>
</div>
<div class="row row-heading">
	<div class="column"><strong>Project name</strong></div>
	<div class="column text-center"><strong>Created</strong></div>
	<div class="column text-center"><strong>Last modified</strong></div>
	<div class="column text-center"><strong>Models<br />Wanted</strong></div>
	<div class="column text-center"><strong>Optioned</strong></div>
	<div class="column text-center"><strong>Accepted</strong></div>
	<div class="column text-center"><strong>Declined</strong></div>
	<div class="column text-center"><strong>Status</strong></div>
	<div class="column">&nbsp;</div>
</div>
{foreach from=$jobs item=job name=jobs}
{if $job.startdate > $smarty.now && $job.job_status neq 2}
<div class="row offerrow {if $smarty.foreach.jobs.iteration%2 eq 0} highlight{/if} project-{$job.id}">
	{if $job.status eq 0}
	<div class="column"><a class="jobname" data-jobid="{$job.id}" href="/projects/edit/{$job.id}" class="jobname">{$job.name} ({$job.startdate|date_format:"%d %b"}){if $smarty.const.DEBUG} ({$job.id}){/if}</a></div>
	{else}
	<div class="column"><span class="jobname">{$job.name} ({$job.startdate|date_format:"%d %b"}){if $smarty.const.DEBUG} ({$job.id}){/if}</span></div>
	{/if}
	<div class="column text-center">{$job.created|date_format:"%d %b, %Y"}</div>
	<div class="column text-center">{$job.modified|date_format:"%d %b, %Y"}</div>
	<div class="column text-center">{$job.modelcount}</div>
	<div class="column text-center">{$job.optionedmodelcount}</div>
	<div class="column text-center">{$job.acceptedcount}</div>
	<div class="column text-center">{$job.rejectedcount}</div>
	<div class="column text-center">{if $job.job_status eq 0}Pending{else if $job.job_status eq 1}Closed{/if}</div>
	<div class="column">
		{if $job.job_status eq 0}<a data-jobid="{$job.id}" class="edit" href="/projects/edit/{$job.id}" data-balloon="edit job" data-balloon-pos="up"></a>{/if}
		{if $job.optionedmodelcount eq $job.acceptedcount && $job.job_status eq 0}<a data-jobid="{$job.id}" class="check closejob tiny success" href="" data-balloon="close job" data-balloon-pos="up"></a>{/if} 
		<a data-jobid="{$job.id}" class="cancel"  data-balloon="cancel job" data-balloon-pos="up" href=""></a>
	</div>
</div>
{/if}
{/foreach}
<div class="row">
	<div class="column"></div>
	<div class="column"></div>
	<div class="column">
		<a class="button bg-black white hvr hvr-purple" href="/projects/create" style="margin-top: 1em;">+ Create New Project</a>
	</div>
</div>
<div class="row">
	<div class="column">
		<h4 class="lead">Unfinalised Projects</h4>
	</div>
</div>
<div class="row row-heading">
	<div class="column"><strong>Project name</strong></div>
	<div class="column text-center"><strong>Created</strong></div>
	<div class="column text-center"><strong>Needed</strong></div>
	<div class="column text-center"><strong>Optioned</strong></div>
	<div class="column text-center"><strong>Agreed<br />complete</strong></div>
	<div class="column text-center">&nbsp;</div>
</div>
{foreach from=$jobs item=job name=jobs}
{if ($job.startdate < $smarty.now) && ($job.job_status eq 0) && ($job.optionedmodelcount neq $job.completedcount)}
<div class="row offerrow{if $smarty.foreach.jobs.iteration%2 eq 0} highlight{/if}">
	<div class="column"><strong>{$job.name}{if $smarty.const.DEBUG} ({$job.id}){/if}</strong></div>
	<div class="column text-center">{$job.created|date_format:"%d %b, %Y"}</div>
	<div class="column text-center">{$job.modelcount}</div>
	<div class="column text-center">{$job.optionedmodelcount}</div>
	<div class="column text-center">{$job.completedcount}</div>
	<div class="column text-center">
	{if $job.invoice_paid eq 0 && $job.invoice_id neq 0}
		<a class="money" href="/invoices{if $job.invoice_id neq 0}/pay/{$job.invoice_id}{/if}" data-balloon="Pay invoice" data-balloon-pos="up"></a></div>
	{elseif $job.invoice_paid eq 0 && $job.invoice_id eq 0}
		<a data-jobid="{$job.id}" class="check closejob tiny success" href="" data-balloon="close job" data-balloon-pos="up"></a>
	{else}
		{if ($job.optionedmodelcount neq $job.completedcount) || $job.completedcount eq 0}<a data-jobid="{$job.id}" data-open="completeJob" class="check complete" href="" data-balloon="complete job" data-balloon-pos="up"></a>{/if}
		{if $job.optionedmodelcount eq 0} <a data-jobid="{$job.id}" href="" class="cancel" data-balloon="close job" data-balloon-pos="up"></a>{/if}
	{/if}
	</div>
</div>
{/if}
{/foreach}

<div class="row">
	<div class="column">
		<h4 class="lead">Past unclosed projects</h4>
	</div>
</div>
<div class="row row-heading">
	<div class="column"><strong>Project Name</strong></div>
	<div class="column text-center">&nbsp;</div>
	<div class="column narrow10">&nbsp;</div>
</div>
{foreach from=$jobs item=job name=jobs}
{if ($job.startdate < $smarty.now) && ($job.job_status eq 0) && ($job.invoice_paid eq 0)}
<div class="row offerrow{if $smarty.foreach.jobs.iteration%2 eq 0} highlight{/if}">
	<div class="column"><strong>{$job.name}{if $smarty.const.DEBUG} ({$job.id}){/if}</strong></div>
	<div class="column text-center">{$job.created|date_format:"%d %b, %Y"}</div>
	<div class="column narrow10 text-center"><a data-jobid="{$job.id}" class="check closejob tiny success" href="" data-balloon="close job" data-balloon-pos="up"></a></div>
</div>
{/if}
{/foreach}

<div class="row">
	<div class="column">
		<h4 class="lead">Projects with overdue invoices</h4>
	</div>
</div>
<div class="row row-heading">
	<div class="column"><strong>Project Name</strong></div>
	<div class="column text-center">&nbsp;</div>
	<div class="column narrow10">&nbsp;</div>
</div>
{foreach from=$jobs item=job name=jobs}
{if $job.startdate < $smarty.now && $job.job_status eq 2 && $job.invoice_paid eq 0 && $job.invoice_id neq 0}
<div class="row offerrow{if $smarty.foreach.jobs.iteration%2 eq 0} highlight{/if}">
	<div class="column"><strong>{$job.name}{if $smarty.const.DEBUG} ({$job.id}){/if}</strong></div>
	<div class="column text-center">{$job.created|date_format:"%d %b, %Y"}</div>
	<div class="column narrow10 text-center"><a class="money" href="/invoices{if $job.invoice_id neq 0}/pay/{$job.invoice_id}{/if}" data-balloon="Pay invoice" data-balloon-pos="up"></a></div>
</div>
{/if}
{/foreach}

<div class="row">
	<div class="column">
		<h4 class="lead">Waiting for models to complete</h4>
	</div>
</div>
<div class="row row-heading">
	<div class="column"><strong>Project Name</strong></div>
	<div class="column text-center">&nbsp;</div>
</div>
{foreach from=$jobs item=job name=jobs}
{if ($job.startdate < $smarty.now) && ($job.job_status eq 1) && ($job.optionedmodelcount eq $job.completedcount) && ($job.invoice_paid eq 1)}
<div class="row offerrow{if $smarty.foreach.jobs.iteration%2 eq 0} highlight{/if}">
	<div class="column"><strong>{$job.name}{if $smarty.const.DEBUG} ({$job.id}){/if}</strong></div>
	<div class="column text-center">{$job.created|date_format:"%d %b, %Y"}</div>
</div>
{/if}
{/foreach}

<div class="row">
	<div class="column">
		<h4 class="lead">Completed Projects</h4>
	</div>
</div>
<div class="row row-heading">
	<div class="column"><strong>Project name</strong></div>
	<div class="column text-center">&nbsp;</div>
</div>
{foreach from=$jobs item=job name=jobs}
{if ($job.startdate < $smarty.now) && ($job.job_status eq 1) && ($job.invoice_paid eq 1)}
<div class="row offerrow{if $smarty.foreach.jobs.iteration%2 eq 0} highlight{/if}">
	<div class="column"><strong>{$job.name}{if $smarty.const.DEBUG} ({$job.id}){/if}</strong></div>
	<div class="column text-right">{$job.created|date_format:"%d %b, %Y"}</div>
</div>
{/if}
{/foreach}

<div class="row">
	<div class="column">
		<h4 class="lead">Deleted Projects</h4>
	</div>
</div>
<div class="row row-heading">
	<div class="column"><strong>Project name</strong></div>
	<div class="column text-center">&nbsp;</div>
</div>
{foreach from=$jobs item=job name=jobs}
{if $job.job_status eq 2}
<div class="row offerrow{if $smarty.foreach.jobs.iteration%2 eq 0} highlight{/if}">
	<div class="column"><strong>{$job.name}{if $smarty.const.DEBUG} ({$job.id}){/if}</strong></div>
	<div class="column text-right">{$job.created|date_format:"%d %b, %Y"}</div>
</div>
{/if}
{/foreach}
<div class="large reveal modalWhite" data-reveal id="completeJob">
</div>
{/block}