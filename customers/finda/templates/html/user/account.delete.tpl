{extends 'user/layout.tpl'}
{block name="main"}
{* delete account *}
<div class="row">
	<div class="column">
		<h1 class="text-center" style="width: 100%; color: #f00">Disable Account</h1>
	</div>
</div>
<div class="row">
	<div class="column text-center">
		<h3>Are you sure you want to disable your account?</h3>
		<p>Pressing the DISABLE button below will disable your account with iDAL and you will not be able to create a new account with the same details.</p>
	</div>
</div>
<div class="row">
	<div class="column align-center">
		<a class="button white errorbutton" id="deleteconfirm" style="margin-top: 4em">Yes, Disable My Account</a>
	</div>
</div>
{/block}