	{* main layout for project pages *}
	{* collapsing menu here *}
	<section id="projects_header">
		<div class="row column">
			<div class="projects_top">
				<div class="project_collapsing">My Schedule</div>
			</div>
		</div>
	</section>
	
	<div id="main" class="grid grid-wide prod mobilepanel">
		<div class="grid-main{if $grid_background neq ''} {$grid_background}{/if}">
			{block name="main"}{/block}
			
		</div>
	</div>