{extends "user/layout.tpl"}
{block name="main"}
<div class="row row-heading">
	<div class="column">
		<h2 class="text-black">Your projects</h2>
	</div>
</div>
<div class="row">
	<div class="column">
		{if $smarty.const.DEBUG eq 1}<p>DEBUG: total projects count: {$jobscount}</p>{/if}
	</div>
	<div class="column text-right desktop">
		<a class="button bg-black white hvr hvr-purple" href="/projects/create">+ Create New Project</a>
	</div>
	<div class="column text-center mobile">
		<a class="button bg-black white hvr hvr-purple" href="/projects/create">+ Create New Project</a>
	</div>

</div>
{if $pending}
<div class="row row-heading">
	<div class="column">
		<h2 class="text-black">Upcoming Projects</h2>
	</div>
</div>
<div class="row sub-heading bg-bordergrey desktop">
	<div class="column">Project</div>
	<div class="column text-center">Date</div>
	<div class="column text-center">Created</div>
	<div class="column text-center">Last modified</div>
	<div class="column text-center">Models<br />needed</div>
	<div class="column text-center">Requested models</div>
	<div class="column text-center">Confirmed models</div>
	<div class="column text-center">Declined models</div>
	<div class="column text-center">Status</div>
	<div class="column">&nbsp;</div>
</div>
{foreach from=$pending item=job name=jobs}
<div class="row offerrow {if $smarty.foreach.jobs.iteration%2 eq 0} highlight{/if} project-{$job.id}">
	<div class="row desktop">
		<div class="column"><a class="jobname" data-jobid="{$job.id}" href="/projects/{if $job.job_status eq 0}edit{else}view{/if}/{$job.id}" class="jobname">{$job.name} ({$job.startdate|date_format:"%d %b"}){if $smarty.const.DEBUG} ({$job.id}){/if}</a></div>
		<div class="column text-center">{$job.startdate|date_format:"%d %b, %Y"}</div>
		<div class="column text-center">{$job.created|date_format:"%d %b, %Y"}</div>
		<div class="column text-center">{$job.modified|date_format:"%d %b, %Y"}</div>
		<div class="column text-center">{$job.modelcount}</div>
		<div class="column text-center">{$job.optionedmodelcount}</div>
		<div class="column text-center">{$job.acceptedcount}</div>
		<div class="column text-center">{$job.rejectedcount}</div>
		<div class="column text-center">{if $job.job_status eq 0}Pending{else if $job.job_status eq 1 && $job.invoice_paid eq 0}Closed{else if $job.job_status eq 1 && $job.invoice_paid eq 1}Invoice Paid{/if}</div>
		<div class="column">
		{if $job.job_status eq 1}
			<a data-jobid="{$job.id}" class="callsheet" data-balloon="Add callsheet" data-balloon-pos="up" href="/callsheet/{$job.id}"></a>
		{/if}
		{if $job.invoice_paid neq 1}
			{if $job.job_status eq 0}
			<a data-jobid="{$job.id}" class="edit" href="/projects/edit/{$job.id}" data-balloon="Edit job" data-balloon-pos="up"></a>
			<a data-jobid="{$job.id}" class="addmodel" href="/projects/edit/{$job.id}#models" data-balloon="Search models" data-balloon-pos="up" href=""></a>
			{/if}
			{if $job.optionedmodelcount eq $job.acceptedcount && $job.job_status eq 0}<a data-jobid="{$job.id}" class="check closejob tiny success" href="" data-balloon="Close job" data-balloon-pos="up"></a>{/if} 
			<a data-jobid="{$job.id}" class="cancel canceljob" data-balloon="Cancel job" data-balloon-pos="up" href=""></a>
		{else}
			<a class="alert" data-balloon="contact IDAL to cancel this job" data-balloon-pos="up" href=""></a>
		{/if}
		</div>
	</div>
	<div class="row mobile">
		<div class="column"><a class="jobname" data-jobid="{$job.id}" href="/projects/{if $job.job_status eq 0}edit{else}view{/if}/{$job.id}" class="jobname">{$job.name} ({$job.startdate|date_format:"%d %b"}){if $smarty.const.DEBUG} ({$job.id}){/if}</a></div>
		<div class="column">Start Date:<span class="right">{$job.startdate|date_format:"%d %b, %Y"}</span></div>
		<div class="column">Models needed:<span class="right">{$job.modelcount}</span></div>
		<div class="column">Models optioned: <span class="right">{$job.optionedmodelcount}</span></div>
		<div class="column">Models accepted: <span class="right">{$job.acceptedcount}</span></div>
		<div class="column">Job status: <span class="right">{if $job.job_status eq 0}Pending{else if $job.job_status eq 1 && $job.invoice_paid eq 0}Closed{else if $job.job_status eq 1 && $job.invoice_paid eq 1}Invoice Paid{/if}</span></div>
		<div class="column text-right">
		{if $job.job_status eq 1}
			<a data-jobid="{$job.id}" class="callsheet" data-balloon="Add callsheet" data-balloon-pos="up" href="/callsheet/{$job.id}"></a>
		{/if}
		{if $job.invoice_paid neq 1}
			{if $job.job_status eq 0}
			<a data-jobid="{$job.id}" class="edit" href="/projects/edit/{$job.id}" data-balloon="Edit job" data-balloon-pos="up"></a>
			<a data-jobid="{$job.id}" class="addmodel" href="/projects/edit/{$job.id}#models" data-balloon="Search models" data-balloon-pos="up" href=""></a>
			{/if}
			{if $job.optionedmodelcount eq $job.acceptedcount && $job.job_status eq 0}<a data-jobid="{$job.id}" class="check closejob tiny success" href="" data-balloon="Close job" data-balloon-pos="up"></a>{/if} 
			<a data-jobid="{$job.id}" class="cancel canceljob" data-balloon="Cancel job" data-balloon-pos="up" href=""></a>
		{else}
			<p><em>Contact IDAL to cancel this job</em></p>
		{/if}
		</div>
	</div>
	{if $job.job_status eq 1 && $job.callsheet neq ''}
	<div class="row">
		<div class="column text-right callsheet-{$job.id}">
			<a href="/download/callsheet/{$job.id}">Current callsheet</a> <a data-jobid="{$job.id}" class="cancel removecallsheet" data-balloon="Remove callsheet" data-balloon-pos="up" href=""></a>
		</div>
	</div>
	{/if}
</div>
{/foreach}
{/if}
{if $unfinalised}
<div class="row row-heading row-break">
	<div class="column">
		<h2 class="text-black">Unfinalised Projects</h2>
	</div>
</div>
<div class="row sub-heading bg-bordergrey">
	<div class="column">Project name</div>
	<div class="column text-center">On</div>
	<div class="column text-center">Models<br />Needed</div>
	<div class="column text-center">Models<br />Optioned</div>
	<div class="column text-center">Models<br />agreed complete</div>
	<div class="column text-center">&nbsp;</div>
</div>
{foreach from=$unfinalised item=job name=jobs}
<div class="row offerrow{if $smarty.foreach.jobs.iteration%2 eq 0} highlight{/if}">
	<div class="column"><a href="/projects/view/{$job.id}">{$job.name}{if $smarty.const.DEBUG} ({$job.id}){/if}</a></div>
	<div class="column text-center">{$job.startdate|date_format:"%d %b, %Y"}</div>
	<div class="column text-center">{$job.modelcount}</div>
	<div class="column text-center">{$job.optionedmodelcount}</div>
	<div class="column text-center">{$job.modelcompletedcount}</div>
	<div class="column text-center">
	{if $job.invoice_paid eq 0 && $job.invoice_id neq 0}
		<a class="money" href="/invoices{if $job.invoice_id neq 0}/pay/{$job.invoice_id}{/if}" data-balloon="Pay invoice" data-balloon-pos="up"></a>
	{elseif $job.invoice_paid eq 0 && $job.invoice_id eq 0}
		<a data-jobid="{$job.id}" class="check closejob tiny success" href="" data-balloon="Close job" data-balloon-pos="up"></a>
	{else}
		{if ($job.optionedmodelcount neq $job.completedcount) || $job.completedcount eq 0}<a data-jobid="{$job.id}" data-open="completeJob" class="check complete" href="" data-balloon="Complete job" data-balloon-pos="up"></a>{/if}
		{if $job.optionedmodelcount eq 0} <a data-jobid="{$job.id}" href="" class="cancel" data-balloon="Close job" data-balloon-pos="up"></a>{/if}
	{/if}
	</div>
</div>
{/foreach}
{/if}

{if $past}
<div class="row row-heading row-break">
	<div class="column">
		<h2 class="text-black">Past unclosed projects</h2>
	</div>
</div>
<div class="row sub-heading bg-bordergrey desktop">
	<div class="column">Project Name</div>
	<div class="column text-center">&nbsp;</div>
	<div class="column narrow10">&nbsp;</div>
</div>
{foreach from=$past item=job name=jobs}
<div class="row offerrow{if $smarty.foreach.jobs.iteration%2 eq 0} highlight{/if}">
	<div class="column"><a href="/projects/view/{$job.id}">{$job.name}{if $smarty.const.DEBUG} ({$job.id}){/if}</a></div>
	<div class="column text-center">{$job.created|date_format:"%d %b, %Y"}</div>
	<div class="column narrow10 text-center"><a data-jobid="{$job.id}" class="check closejob tiny success" href="" data-balloon="Close job" data-balloon-pos="up"></a></div>
</div>
{/foreach}
{/if}

{if $overdue}
<div class="row row-heading row-break">
	<div class="column">
		<h2 class="text-black">Projects with overdue invoices</h2>
	</div>
</div>
<div class="row sub-heading bg-bordergrey desktop">
	<div class="column">Project Name</div>
	<div class="column text-center">&nbsp;</div>
	<div class="column narrow10">&nbsp;</div>
</div>
{foreach from=$overdue item=job name=jobs}
<div class="row offerrow{if $smarty.foreach.jobs.iteration%2 eq 0} highlight{/if}">
	<div class="column"><a href="/projects/view/{$job.id}">{$job.name}{if $smarty.const.DEBUG} ({$job.id}){/if}</a></div>
	<div class="column text-center">{$job.created|date_format:"%d %b, %Y"}</div>
	<div class="column narrow10 text-center"><a class="money" href="/invoices{if $job.invoice_id neq 0}/pay/{$job.invoice_id}{/if}" data-balloon="Pay invoice" data-balloon-pos="up"></a></div>
</div>
{/foreach}
{/if}

{if $waiting}
<div class="row row-heading row-break">
	<div class="column">
		<h2 class="text-black">Waiting for models to complete</h2>
	</div>
</div>
<div class="row sub-heading bg-bordergrey">
	<div class="column">Project Name</div>
	<div class="column text-center">&nbsp;</div>
</div>
{foreach from=$waiting item=job name=jobs}
<div class="row offerrow{if $smarty.foreach.jobs.iteration%2 eq 0} highlight{/if}">
	<div class="column"><a href="/projects/view/{$job.id}">{$job.name}{if $smarty.const.DEBUG} ({$job.id}){/if}</a></div>
	<div class="column text-center">{$job.created|date_format:"%d %b, %Y"}</div>
</div>
{/foreach}
{/if}

{if $complete}
<div class="row row-heading row-break">
	<div class="column">
		<h2 class="text-black">Completed Projects</h2>
	</div>
</div>
<div class="row sub-heading bg-bordergrey">
	<div class="column">Project name</div>
	<div class="column text-center">&nbsp;</div>
</div>
{foreach from=$complete item=job name=jobs}
<div class="row offerrow{if $smarty.foreach.jobs.iteration%2 eq 0} highlight{/if}">
	<div class="column"><a href="/projects/view/{$job.id}">{$job.name}{if $smarty.const.DEBUG} ({$job.id}){/if}</a></div>
	<div class="column text-right">{$job.created|date_format:"%d %b, %Y"}</div>
</div>
{/foreach}
{/if}

{if $deleted}
<div class="row row-heading row-break">
	<div class="column">
		<h2 class="text-black">Deleted Projects</h2>
	</div>
</div>
<div class="row sub-heading bg-bordergrey">
	<div class="column">Project name</div>
	<div class="column text-center">&nbsp;</div>
</div>
{foreach from=$deleted item=job name=jobs}
<div class="row offerrow{if $smarty.foreach.jobs.iteration%2 eq 0} highlight{/if}">
	<div class="column"><a href="/projects/view/{$job.id}">{$job.name}{if $smarty.const.DEBUG} ({$job.id}){/if}</a></div>
	<div class="column text-right">{$job.created|date_format:"%d %b, %Y"}</div>
</div>
{/foreach}
{/if}
<div class="large reveal modalWhite" data-reveal id="completeJob"></div>
{/block}