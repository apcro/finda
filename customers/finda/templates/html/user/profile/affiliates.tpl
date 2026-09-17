<div class="row">
	<div class="column">
		<h1>Invite your friends and win cash</h1>
	</div>
</div>
<div class="seperator" data-gap="2"></div>
<div class="row">
	<div class="column">
		<p>Share your personal code or link with your friends to join our New Year competition. The three most successful referrers until March 15<sup>th</sup> 2020 will win a cash prize!</p>
	</div>
</div>
<div class="row">
	<div class="column" style="line-height: 1.75em; margin-left: 6em; margin-top: 2em; margin-bottom: 3em;">
		<p><span style="width: 6em; display: inline-block;">1<sup>st</sup> prize:</span> <b>£1,000</b></p>
		<p><span style="width: 6em; display: inline-block;">2<sup>nd</sup> prize:</span> <b>£500</b></p>
		<p><span style="width: 6em; display: inline-block;">3<sup>rd</sup> prize:</span> <b>£300</b></p>
	</div>
</div>

<div class="row">
	<div class="column text-center aff">
		<div style="display: inline-block; margin-right: 2em;">
			<a class="button burgundy" href="https://wa.me/?text=I would like to invite you to iDAL a smart and transparent model booking platform I have started using for my projects. You can discover talent on the go and book them directly. You can sign up using my link or code {$user.referrer_code} to waive the commission for your first booking: https://idal.co/?aff_id={$user.referrer_code}" target="_blank">Share via WhatsApp</a>
		</div>
		<div style="display: inline-block; margin-left: 2em;">
			<a class="button burgundy" href="mailto:?subject=Invitation to iDAL&body=I would like to invite you to iDAL a smart and transparent model booking platform I have started using for my projects. You can discover talent on the go and book them directly. You can sign up using my link or code {$user.referrer_code} to waive the commission for your first booking: https://idal.co/?aff_id={$user.referrer_code}">Share via Email</a>
		</div>
	</div>
	<div class="column"></div>
</div>

<div class="row">
	<div class="column affiliates">
		<p>Or give your friend this signup code: <span class="text-bold" data-balloon="Click to copy" data-balloon-pos="up"><span class="copyme" data-code="{$user.referrer_code}">{$user.referrer_code}</span></span></p>
		<p>Your personal referral link is: <span class="text-bold" data-balloon="Click to copy" data-balloon-pos="up"><span class="copyme" data-code="https://idal.co/?aff_id={$user.referrer_code}">https://idal.co/?aff_id={$user.referrer_code}</span></span></p>
		<p>Click either of these to copy to your clipboard, so you can share it with your friends.</p>
	</div>
</div>



{if $affiliates}
<div class="row">
	<div class="column affiliates">
		<h2>Successful Referrals ({$verifiedusers})</h2>
		<div class="friend_referral_cards">
		{foreach from=$affiliates item=affiliate}
			<div class="card">
				<img src="/{$affiliate.imagetype}/large{$affiliate.filename}">
				<p>{$affiliate.firstname} {$affiliate.lastname}</p>
				<div class="{if $affiliate.status eq 0}un{/if}verified"><i class="fa{if $affiliate.status eq 1}s fa-check{else}r fa-clock{/if}"></i></div>
			</div>
		{/foreach}
		
		</div>
		
	</div>
</div>
{/if}

{include file="user/popups/referral_program.tpl"}