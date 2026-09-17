{extends "user/layout.tpl"}

{block name="main"}
<div class="row row-headingtext-black">
	<div class="column">
		<h1 style="transform-origin: left top;">Project Sharing</h1>
	</div>
</div>
<div class="row mobile">
	<div class="column">
		<p class="notice">Please use your desktop or laptop to enjoy all our features. The iDAL app is coming soon!</p>
	</div>
</div>

{if $pagemessage.message neq ""}
<div class="row">
	<div class="callout {$pagemessage.type}">
		<h5>{$pagemessage.message}</h5>
	</div>
</div>
{/if}

<div class="row">
	<div class="column">
		<h2>Please enter the code you were given below</h2>
		<input type="text" name="code" placeholder="Enter code" />
		<div class="text-center">
			<a class="auth button bg-black white hvr hvr-blue " style="margin-bottom: 2em;">Access shared project</a>
		</div>	
{*		<input type="hidden" name="jobid" value="{$jobid}" /> *}
		<input type="hidden" name="shareuri" value="{$shareuri}" />
	</div>
</div>
{/block}