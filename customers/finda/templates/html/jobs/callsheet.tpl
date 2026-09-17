{extends "user/layout_wide.tpl"}
	
{block name="main"}
<div class="seperator" data-gap="2"></div>
<div class="row">
	<div class="column">
		{include file="jobs/job_card_small.tpl"}
	</div>
</div>
<div class="seperator" data-gap="2"></div>
<div class="row">
	<div class="column">
		<strong>This call sheet will be made available to the models who accept your booking offer.</strong>
		<div class="notice"><i>Please note: Callsheets must be in PDF format, otherwise the file upload will be rejected.</i></div>
	</div>
</div>
<div class="seperator" data-gap="2"></div>
<div class="row">
	<div class="column" style="background-color: #efefef; padding: 2em; border-radius: 5px;">
		<form method="post" action="/callsheet/upload" enctype="multipart/form-data">
			<label for="documentUpload">Selected callsheet:</label>
			<input type="file" name="callsheet" id="documentUpload">
			<input type="hidden" name="jobid" value="{$job.id}" />
			<div class="text-center mobile" style="margin-top: 1em">
				<button type="submit" name="Upload" class="button burgundy">Upload</button>
			</div>
			<div class="text-center desktop" style="margin-top: 1em">
				<button type="submit" name="Upload" class="button burgundy">Upload</button>
			</div>
		</form>
	</div>
</div>
<div class="seperator" data-gap="4"></div>
<div class="seperator" data-gap="4"></div>
{/block}