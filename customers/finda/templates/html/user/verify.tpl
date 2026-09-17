{extends "user/layout.tpl"}

{block name="main"}
<div class="row">
	<div class="column">
		<h1 style="transform-origin: left top;">Verify your account</h1>
	</div>
</div>
<div class="row">
	<div class="column verify">
		{if $kycdoc neq ''}
		<div class="notice">
			<strong>Note:</strong> You previously uploaded the file <i>{$kycdoc}</i>. If you upload another file, we will check the new file instead.<br /><br />
			<strong>We are still checking and verifying your documents, you do not need to upload a new verification document.</strong>
		</div>
		{/if}
		{if $usertype eq 1}
		<p>Hi {$firstname},</p>
		<p>Thank you for registering with us!</p>
		<p>To make sure everyone gets the best professional experience at iDAL, we verify and approve all models and clients before they can access the full platform.</p>
		<p>Please submit a copy of your passport, driving licence or another form of government-issued photo identification for verification.</p>
		<p>To increase the speed of the process, please upload your professional modelling portfolio, polaroids and enter your measurements under My Details.</p>
		<p>You will receive an email if your application is accepted and you have been verified.</p>
		{else}
		{include file="user/verify-client-welcome.tpl"}
		{/if}
	</div>
</div>
<div class="seperator" data-gap="2"></div>
<form method="post" action="/user/verify/upload" enctype="multipart/form-data">
	<div class="row">
		<div class="column">
			<input type="file" name="kyc" class="button burgundy">
		</div>
		<div class="column desktop">
			<button type="submit" name="Upload" class="button burgundy">Upload</button>
		</div>
		<div class="column text-center mobile" style="margin-bottom: 2em; margin-top: 3em;">
			<button type="submit" name="Upload" class="button burgundy">Upload</button>
		</div>
	</div>
</form>
<div class="seperator" data-gap="2"></div>
<div class="row">
	<div class="column"><a href="mailto:support@idal.co" class="button inverted">Email Support</a></div>
</div>
{if $usertype eq 2}
<div class="row">
	<div class="column"><a href="/support/call" class="button inverted">Book a Demo</a></div>
</div>
{/if}
<div class="seperator" data-gap="2"></div>
<div class="row">
	<div class="column">
		<p>We will use this information to verify the details you have provided and process it according to our <a href="/terms">Terms & Conditions</a> and <a href="/privacy">Privacy Policy</a>.</p>
	</div>
</div>
<div class="seperator" data-gap="4"></div>
{/block}