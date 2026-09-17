	{* main layout for project pages *}
	{* collapsing menu here *}
	<section id="projects_header">
		<div class="row column">
			<div class="projects_top">
				<div class="project_collapsing">
				{if $companyprojects}
				<span class="myprojects active">My Projects</span> | <span class="companyprojects">Company Projects</span>
				{else}
				<span class="myprojects active">My Projects</span>
				{/if}
				{* if $user.companyid neq 0} | <span class="mytemplates">Templates</span>{/if *}
				</div>
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
				<div class="new_project">
					<a href="/projects/create/booking" class="button burgundy">Create Booking</a><br />
					<a href="/projects/create/casting" class="button burgundy">Create Casting</a><br />&mdash;&nbsp;or&nbsp;&mdash;<br/>
					<div class="select-wrap" style="margin-top: 0.5em;">
					<select name="usetemplate" class="select usetemplatedropdown">
						<option value="" disabled="disabled" selected="selected">Use Template</option>
						{foreach from=$jobtemplates item=template}
						<option value="{$template.id}">{$template.template_name}</option>
						{/foreach}
						<option value="" disabled="disabled">&dash;</option>
						<option value="edit">Edit Templates</option>
					</select>
					</div>
				</div>
			</div>
		</div>
	</section>
	
	<div id="main" class="grid grid-wide mobilepanel">
	{block name="dashboard"}
		<div class="row column" style="margin-left: 0; margin-right: 0;">
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
			{if $companyprojects}
			{block name="companymain"}{/block}
			{/if}
			{block name="templatesmain"}{/block}
		</div>
	{/block}
	</div>