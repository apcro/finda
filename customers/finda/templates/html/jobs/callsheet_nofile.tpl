{extends "user/layout_wide.tpl"}
	
{block name="main"}
<div class="seperator" data-gap="2"></div>
<div class="row">
	<div class="column">
		{include file="jobs/job_card_small.tpl"}
	</div>
</div>
<div class="row">
	<div class="column">
		<div class="notice"><i>The selected file was not a PDF.</i></div>
	</div>
	<div class="column">
		<div style="padding: 3em;">
			<a style="float: right;" class="button white" href="/callsheet/{$jobid}">back</a>
		</div>
	</div>
</div>
<div class="seperator" data-gap="4"></div>
<div class="seperator" data-gap="4"></div>
{/block}