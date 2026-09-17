{extends "user/layout.tpl"}

{block name="main"}

{* for the mobile invite a friend page *}
<div class="row row-heading">
	<div class="column">
		<h2>Invite your talented model friends to iDAL, and earn products from Model Basics!</h2>
	</div>
</div>
<div class="row">
	<div class="column">
		<p>Send your unique referral code using this form or just pass it via WhatsApp, Messenger or wherever you like!</p>
		<p>Earn Model Basics every time one of your friends signs up and gets verified.</p>
		<p>Once confirmed, choose to redeem immediately or wait until you gain more credits. You will receive an email after each successful referral.</p>
		<p>&nbsp;</p>
		<table style="width: 100%; border-collapse: collapse; border: none; padding: 0; margin: 0;">
			<tr style="padding: 0; margin: 0; height: 32px;">
				<td style="padding: 0; width: 50%; text-align: right;">The T-Shirt Goal = refer 3 friends</td>
				<td style="padding: 0 5px; height: 32px;"><img src="/images/refer_uparrow.png" /></td>
				<td style="padding: 0; width: 50%; text-align: left;"><img src="/images/refer_tshirt.png" /></td>
			</tr>
			<tr style="padding: 0; margin: 0; height: 32px;">
				<td style="padding: 0; width: 50%; text-align: right;">The Bra & Panties Goal = refer 2 friends</td>
				<td style="padding: 0 5px; height: 32px;"><img src="/images/refer_uparrow.png" /></td>
				<td style="padding: 0; width: 50%; text-align: left;"><img src="/images/refer_bra.png" /><img src="/images/refer_pants.png" /></td>
			</tr>
			<tr style="padding: 0; margin: 0; height: 32px;">
				<td style="padding: 0; width: 50%; text-align: right;">The Panties goal = refer 1 friend</td>
				<td style="padding: 0 5px; height: 32px;"><img src="/images/refer_uparrow.png" /></td>
				<td style="padding: 0; width: 50%; text-align: left;"><img src="/images/refer_pants.png" /></td>
			</tr>
		</table>
		<p>&nbsp;</p>
		<h2>Your referral code: <span>{$referrer_code}</span></h2>
		<form method="post" action="/invite">
			<input type="text" name="inviteName" placeholder="Your friend's name" style="border-bottom: 1px solid #812d82; font-size: 14px;">
			<input type="text" name="inviteEmail" placeholder="Your friend's email" style="border-bottom: 1px solid #812d82; font-size: 14px;">
			<div class="text-center" style="margin-top: 2em; margin-right: 2em;">
				<a class="button white bg-black hvr hvr-white-textblack sendinvite">send invite</a>
			</div>
		</form>
	</div>
</div>
{/block}