{if $user_status eq 0}
<div class="row row-heading">
	<div class="column">
		<h2 class="text-black">Dashboard</h2>
	</div>
</div>
<div class="row">
	<div class="column">
		<p>Once you have completed verification details of upcoming jobs {if $usertype eq 2}and invoices{/if} and other useful information.</p>
	</div>
</div>
{else}

{* outstanding invoices *}
{if $invoices}
<div class="row row-heading">
	<div class="column">
		<h2 class="text-black">Overdue invoices</h2>
	</div>
</div>
<div class="row sub-heading bg-bordergrey">
	<div class="column">Project name</div>
	<div class="column text-center">Due date</div>
	<div class="column text-center">Value</div>
	<div class="column text-center narrow10">&nbsp;</div>
</div>
{foreach from=$invoices item=invoice name=invoices}
<div class="row offerrow yellow{if $smarty.foreach.invoices.iteration%2 eq 0} highlight{/if}">
	<div class="column jobname"><a class="jobname" href="/projects/view/{$invoice.jobid}">{$invoice.description}</a></div>
	<div class="column text-center">{$invoice.due_date|date_format:"%d-%m-%Y"}</div>
	<div class="column text-center" >{$invoice.value}</div>
	<div class="column text-center narrow10" style="margin: auto 0"><a href="/invoices/pay/{$invoice.id}" class="payinvoice money" data-balloon="pay invoice" data-balloon-pos="left"></a></div>
</div>
{/foreach}
{/if}

{if $pending}
<div class="row row-heading">
	<div class="column">
		<h2 class="text-black">Upcoming projects</h2>
	</div>
</div>
<div class="row sub-heading bg-bordergrey">
	<div class="column">Project name</div>
	<div class="column">Description</div>
	<div class="column">Location</div>
	<div class="column text-center narrow10">Models</div>
	<div class="column text-center narrow10">On</div>
</div>
{foreach from=$pending item=job name=jobs}
{if $smarty.foreach.jobs.index eq 5}{break}{/if}
<div class="row offerrow yellow{if $smarty.foreach.jobs.iteration%2 eq 0} highlight{/if}">
	{if $job.status eq 0}
	<div class="column"><a class="jobname" data-jobid="{$job.id}" href="/projects/edit/{$job.id}" class="jobname">{$job.name}{if $smarty.const.DEBUG} ({$job.id}){/if}</a></div>
	{else}
	<div class="column"><span class="jobname">{$job.name}{if $smarty.const.DEBUG} ({$job.id}){/if}</span></div>
	{/if}
	<div class="column">{$job.description}</div>
	<div class="column">{$job.location}</div>
	<div class="column text-center narrow10">
	{if $job.optionedmodelcount neq 0}
	<a data-jobid="{$job.id}" class="moreModelInfo" data-open="moreModelInfo" data-balloon="More information" data-balloon-pos="up">{$job.optionedmodelcount}</a>
	{else}
	{$job.optionedmodelcount}
	{/if}
	</div>
	<div class="column text-center narrow10">{$job.startdate|date_format:"%d/%m/%Y"} at {$job.starttime|date_format:"%I:%M %p"}</div>
</div>
{/foreach}
{if $pending|count > 5}
<div class="row sub-heading">
	<div class="column">&nbsp;</div>
	<div class="column">&nbsp;</div>
	<div class="column">&nbsp;</div>
	<div class="column text-right narrow10"><a href="/projects">more &raquo;</a></div>
</div>
{/if}
{else}
<div class="row row-heading heading-yellow">
	<div class="column">
		<h2 class="text-black">You have no upcoming projects.</h2>
	</div>
</div>
<div class="row">
	<div class="column text-right">
		<p><a href="/projects/create" class="button white hvr bg-black hvr-darkyellow">+ Create a new project</a>
	</div>
</div>
{/if}


{* models info *}
{if $models}
<div class="row row-heading" style="margin-top: 2em;">
	<div class="column">
		<h2 class="text-black">Models booked</h2>
	</div>
</div>
<div class="row sub-heading bg-bordergrey">
	<div class="column modelimage">&nbsp;</div>
	<div class="column">Model name</div>
	<div class="column text-center">Overall rating</div>
	<div class="column text-center">Last worked with</div>
	<div class="column text-center narrow10">&nbsp;</div>
</div>
{foreach from=$models item=model name=models}
{if $smarty.foreach.models.index eq 5}{break}{/if}
<div class="row offerrow yellow{if $smarty.foreach.jobs.iteration%2 eq 0} highlight{/if}">
	<div class="column modelimage modelname"><a href="/view/{$model.sefu}"><img src="{if $model.leadimage}{$smarty.const.CDN_ROOT}{$model.leadimage}{else}{$default_avatar}{/if}" /></a></div>
	<div class="column modelname"><span><a class="modelname" href="/view/{$model.sefu}">{$model.firstname} {$model.lastname|substr:0:1}</a></span></div>
	<div class="column stars text-center" style="margin: auto 0">{if $model.rating > 0}{for $star=1 to $model.rating}<i class="star fas fa-star"></i>{/for}{/if}</div>
	<div class="column text-center" style="margin: auto 0">{$job.startdate|date_format:"%d/%m/%Y"}</div>
	<div class="column text-center narrow10" style="margin: auto 0"><a href="/view/{$model.sefu}">more &raquo;</a></div>
</div>
{/foreach}
{if $models|count > 5}
<div class="row sub-heading">
	<div class="column">&nbsp;</div>
	<div class="column">&nbsp;</div>
	<div class="column">&nbsp;</div>
	<div class="column text-right narrow10"><a href="" title="expand to see more models">more &raquo;</a></div>
</div>
{/if}
{/if}

{/if}