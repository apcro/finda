{extends "user/layout.tpl"}

{block name="main"}
<div class="row">
	<div class="column">
		<h1 style="transform-origin: left top; max-width: 80%;">Welcome to iDAL</h1>
		<p style="font-size: 120%">We are currently working hard to create a more transparent and empowering solution for the modelling industry, and make it available on mobile. In the meantime, please use desktop version to cast and book models.</p>
		{if $kycdoc neq ''}
		<div class="notice" style="margin-bottom: 0em; margin-top: 1em; padding: 1em;">
			You have already uploaded a verification document, which is being checked by our team, however you may if you wish continue and upload a new verification document. If you upload another file, we will check the new file instead.<br /><br />
		</div>
		{/if}
	</div>
</div>
<div class="row">
	<div class="column">
		<h1 style="transform-origin: left top;">Verify your account</h1>
	</div>
</div>
<div class="row">
	<div class="column verify">
		{if $usertype eq 1}
		<h2 style="transform-origin: left top;"> Hello {$firstname}!</h2>
		<p>To make sure everyone gets the best professional experience at iDAL, we verify and approve each model and creative before they can access the full version. Only photo ID can be submitted via mobile. <b>To continue and finalise your application, log in via the iDAL app or use a computer.</b></p>
		<p>For verification all items below must be submitted:</p>
		<ul style="margin-left: 1em; list-style-type: none;">
			<li>Government-issued photo identification (passport, drivers license, etc.)</li>
			<li>Work permit or proof of residency if non EU applicant (Alongside your ID submission)</li>
			<li>Personal details under ‘My Details’, Professional portfolio, Polaroids and Measurements (Complete via app or computer)</li>
		</ul>
		
		<p>We will use this information to verify the details you have provided and process it according to our <a href="/terms">Terms & Conditions</a> and <a href="/privacy">Privacy Policy</a>.</p>
		<p class="text-bold">You will receive an email if your application is accepted and you have been verified.</p>
		{else}
		{include file="mobile/m.verify-client-welcome.tpl"}
		{/if}
	</div>
</div>
<div class="seperator" data-gap="2"></div>
<form method="post" action="/user/verify/upload" enctype="multipart/form-data">
	<div class="row">
		<div class="column">
			<input type="file" name="kyc" class="button inverted" style="padding: 0.5em;">
		</div>
		<div class="column text-right desktop">
			<button type="submit" name="Upload" class="button burgundy">Upload</button>
		</div>
		<div class="column text-center mobile" style="margin-bottom: 2em; margin-top: 3em;">
			<button type="submit" name="Upload" class="button burgundy">Upload</button>
		</div>
	</div>
	<input type="hidden" name="ismobile" value="yes" />
</form>
<div class="seperator" data-gap="4"></div>
<div class="seperator" data-gap="2"></div>
{/block}