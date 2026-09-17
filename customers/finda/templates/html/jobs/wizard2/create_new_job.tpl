{extends "user/layout.tpl"}

{block name="main"}
<div class="row mobile">
	<div class="column">
		<p class="notice">Please use your desktop or laptop to enjoy all our features. The IDAL app is coming soon!</p>
	</div>
</div>

<div class="row">
	<div class="column text-center">
		<h1>What would you like to do?</h1>
	</div>
</div>
<hr>
<div class="row" style="margin-top: 4em;">
	<div class="column text-center" style="display: block; width: 100%;"><h2>Create New Project</h2></div>
</div>

<div class="row">
	<div class="column text-right">
		<a href="/projects/create/casting" class="button inverted">Create Casting</a>
	</div>
	<div class="column">
		<a href="/projects/create/booking" class="button inverted">Create Booking</a>
	</div>
</div>
<div class="seperator" data-gap="2"></div>
{if $user.companyid neq 0}
<div class="row">
	<div class="column text-center">
		<a href="/templates" class="button inverted">Create From Template</a>
	</div>
</div>
{/if}
{/block}