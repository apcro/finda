	{* main layout for project pages *}
	{* collapsing menu here *}
	<section id="projects_header">
		<div class="row column">
			<div class="projects_top">
				{if $companyupdates}
				<div class="project_collapsing"><span class="myupdates active">My Updates</span> | <span class="companyupdates">Company Updates</span></div>
				{else}
				<div class="project_collapsing">My Updates</div>
				{/if}
				
			</div>
		</div>
	</section>
	
	<div id="main" class="grid grid-wide prod mobilepanel">
	{block name="dashboard"}
		<div class="grid-main{if $grid_background neq ''} {$grid_background}{/if}">
			{block name="main"}{/block}
			{if $companyupdates}
			{block name="companymain"}{/block}
			{/if}
		</div>
	{/block}
	</div>