	{* main layout for project pages *}
	{* collapsing menu here *}
	<section id="projects_header">
		<div class="row column">
			<div class="projects_top">
				<div class="project_collapsing">Edit Templates
					<a class="backlink" href="/projects#templates"><i class="fas fa-arrow-left"></i> back</a>
				</div>
			</div>
		</div>
	</section>
	
	<div id="main" class="grid grid-wide prod mobilepanel">
	{block name="dashboard"}
		<div class="grid-main{if $grid_background neq ''} {$grid_background}{/if}">
			{block name="main"}{/block}
		</div>
	{/block}
	</div>