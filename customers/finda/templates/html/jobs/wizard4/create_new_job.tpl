{extends "user/layout.tpl"}

{block name="main"}
<div class="row mobile">
	<div class="column">
		<p class="notice">Please use your desktop or laptop to enjoy all our features. The iDAL app is coming soon!</p>
	</div>
</div>

<div class="row">
	<div class="column text-center">
		<h2 style="margin-top: 4em;">What would you like to do?</h2>
	</div>
</div>
{if $jobtemplates}
<div class="row">
	<div class="column text-center"><h3>Create from Template:</h3></div>
</div>
<div class="row">
	<div class="column">This will create a basic project starting tomorrow from a set of pre-selected set of options. You will still need to edit the project to provide additional details, and then select any models you want to book.</div>
</div>
<div class="row">
	<div class="column">
		<select name="projecttemplate" id="projecttemplate">
			<option></option>
		{foreach from=$jobtemplates item=template}
			<option value="{$template.id}">{$template.template_name} ({$template.term_name}{if $template.unitstype neq 'unpaid' && $template.offered_rate neq 0}, {$template.offered_rate}/{$template.units_type}{/if})</option>
		{/foreach}
		</select>
		<br />
		<br />
	</div>
	<div class="column text-right">
		<a href="" class="button fancy white createfromtemplate">create</a>
	</div>
</div>
<div class="row">
	<div class="column text-right">
		<a href="/templates/edit" class="button white fancy">Edit templates</a>
	</div>
</div>
<hr />

<div class="row">
	<div class="column text-center"><h3>Create New Project:</h3></div>
</div>

{/if}
<div class="row">
	<div class="column text-center">
		<div class="job_circle" data-jobtype="casting">
			<div class="icon"><i class="fas fa-users"></i></div>
			<p>Cast models for an upcoming project</p>
		</div>
		<div class="job_circle" data-jobtype="booking">
			<div class="icon"><i class="fas fa-camera"></i></div>
			<p>Book models</p>
		</div>
	</div>
</div>
<div class="row">
	<div class="column text-center">
		<div class="job_circle" data-jobtype="influencercontent">
			<div class="icon"><i class="fas fa-comment-alt"></i></div>
			<p>Book influencer post</p>
		</div>

		<div class="job_circle" data-jobtype="influencershoot">
			<div class="icon"><i class="fas fa-comment-alt"></i></div>
			<p>Book influencer shoot</p>
		</div>


	</div>
</div>
<div class="row">
	<div class="column text-center">
		<a href="" class="button fancy white createbutton">start creating</a>
	</div>
</div>
{/block}