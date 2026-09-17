{extends "user/layout.tpl"}

{block name="main"}
<div class="row">
	<div class="column">
		<h1>Avatar upload</h1>
	</div>
</div>
<div class="row">
	<div class="column">
		<h4>Sorry, there was a problem with your avatar.</h4>
		<p>{$error.error}</p>
		<a href="/user/avatar">Try again</a>
	</div>
</div>
{/block}