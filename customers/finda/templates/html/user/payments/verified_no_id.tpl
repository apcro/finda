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
        	<div class="row">
        		<div class="column">
        			<div class="notice">
        				<p>You have no uploaded ID yet. Until you have uploaded ID and we have verified it, we will not be able to make payments to you.</p>
        				<a class="button bg-black white hvr hvr-white-textblack" href="/user/verify">Verify</a>
        			</div>
        		</div>
        	</div>
		</div>
	</div>
</form>
{/block}