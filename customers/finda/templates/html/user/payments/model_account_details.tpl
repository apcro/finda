{extends file="user/layout.tpl"}

{block name="main"}
<div class="row row-heading">
	<div class="column">
		<h2>Payments</h2>
	</div>
</div>
<form class="account-details" method="post" action="/payments/update">
	<div class="row">
		<div class="column">
			{if $smarty.const.DEBUG}
			<div class="testmode">
				<h4>TEST MODE</h4>
				<p>For testing purposes, please use the following details:</p>
				<p>Account Name: Enter anything you like, this is free text.<br />
				Sort Code: 10-88-00<br />
				Account Number: 00012345</p>
			</div>
			{/if}
			{if $missingdetails != ''}
        	<div class="row">
        		<div class="column">
        			<div class="notice">
        				<p>We are also missing your <a href="/user/profile">{$missingdetails}</a>. Make sure to fill the missing details so we can pay you!</p>
        			</div>
        		</div>
        	</div>
        	{/if}
			{if $errorMessage}
			<div class="notice">
				<h2>Sorry, there was an error</h2>
				<p>Something went wrong. We've made a note of it and will look into it soon.</p>
			</div>
			{/if}
			<h4>Account Details</h4>
			{if $change eq ''}
			<p>We don't have your bank account details on file. Until we have these we can't pay you for your work.</p>
			{else}
			<p>Please update your details</p>
			{/if}
			<label for="accountname">Account Name</label>
			<input type="text" name="input accountname" id="accountname" placeholder="Account name">
		</div>
	</div>
	<div class="row">
		<div class="column">
			<label for="sortcode">Sort Code<span class="required"> *</span></label>
			<input type="text" name="input sortcode" id="sortcode" placeholder="xx-xx-xx">
		</div>
		<div class="column">
			<label for="accountnumber">Account Number<span class="required"> *</span></label>
			<input type="text" name="input accountnumber" id="accountnumber" placeholder="xxxxxxxx">
		</div>
	</div>
	<div class="row">
		<div class="column desktop"></div>
		<div class="column text-center">
			<button type="submit" class="button white cancel">Cancel</button>
		</div>
		<div class="column text-center desktop">
			<button type="submit" class="button white">Save</button>
		</div>
		<div class="column desktop"></div>
	</div>
</form>
{/block}