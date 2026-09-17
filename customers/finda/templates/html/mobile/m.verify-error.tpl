{extends "user/layout.tpl"}

{block name="main"}
<div class="row">
	<div class="column">
		<h1 style="transform-origin: left top;">Verify your account</h1>
	</div>
</div>
<div class="row">
	<div class="column">
		<h4 style="transform-origin: left top;">Sorry, there was a problem with your verification.</h4>
		<p>{$error.error}</p>
		<a href="/m/loggedin">Try again</a>
	</div>
</div>
{/block}