	{* collapsing menu here *}
	<section id="projects_header">
		<div class="row column">
			<div class="projects_top">
				<div class="project_collapsing">Messages between you and {$recipient.firstname}{if $recipient.company_name neq ''} from {$recipient.company_name}{/if}</div>
				
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