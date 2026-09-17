	{* main layout for project pages *}
	{* collapsing menu here *}
	<section id="projects_header">
		<div class="row column">
			<div class="projects_top">
				<div class="project_collapsing">My Jobs</div>
				<div class="project_filters">
					<div class="project_filter_tab upcoming active">
						<div>Upcoming & Offers<span class="badge upcoming">{$jobs.upcoming|count}</span></div>
					</div>
					<div class="project_filter_tab past">
						<div>To Complete<span class="badge past">{$jobs.past|count}</span></div>
					</div>
					<div class="project_filter_tab history">
						<div class="text-grey">History<span class="badge history">{$jobs.history|count}</span></div>
					</div>
					<div class="project_filter_search"></div>
				</div>
			</div>
		</div>
	</section>
	
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