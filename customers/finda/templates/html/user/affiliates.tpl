	{* main layout for dashboard pages *}
	<div id="main" class="grid prod mobilepanel">
	{block name="dashboard"}
		<div class="grid-left desktop">
			{if $userid neq 0}
			<div class="avatar_holder" style="margin-top: 2em;">
				<div class="avatar">
					{if $usertype eq 1}
					<a href="/user/portfolio" data-balloon="Select a new main image" data-balloon-pos="down"><img id="avatarimage" src="{$user_avatar}"/></a>
					{else}
					<a href="/user/avatar" data-balloon="Change your avatar" data-balloon-pos="down"><img id="avatarimage" src="{$user_avatar}" /></a>
					{/if}
				</div>
			</div>
			<div class="name_holder">
    			<div class="profilename"><span>Hello,</span><br />{$firstname}<br />{$surname}</div>
    			{if $is_founding_member eq 1}
    			<br />
    			<div style="width: 100%; text-align: center"><em>Founding Member</em></div>
    			<br /><br />
    			{/if}
    			{if $usertype eq 1}
    			{* if $missingdetails != '' || $missingbank != ''}
    			<div class="search_face" data-balloon="Unfortunately your profile is still not visible in model search. Please make sure you filled in all your measurements and uploaded portfolio images" data-balloon-pos="up" data-balloon-length="medium"/><i class="fas fa-frown"></i></div>
    			{/if *}
    			{/if}
			</div>
			<div style="margin-top: 2em; margin-bottom: 4em; text-align: center;">
			{if $user_status neq 0}
			{if $usertype eq 2}
				<a class="button fullwidth inverted" href="/search">Find a model</a><br /><br />
				<a class="button fullwidth inverted" href="/projects/create">create project</a>
			{else}
				<ul class="vertical menu profile">
				{if $usertype eq 1}{include file="user/profile/menu/model_left.tpl"}{/if}
				</ul>
				<a class="text-center" href="https://itunes.apple.com/us/app/finda-for-models/id1427352589?ls=1&mt=8"><img src="/images/Download_on_the_App_Store_Badge_US-UK_RGB_blk_092917.svg" width=150 style="padding: 20px 0px;"/></a>
				<a href="https://play.google.com/store/apps/details?id=co.finda.models"><img  width=150 style="padding: 20px 0px;" src="/images/google-play-badge.svg"></a>
				
			{/if}
			{else}
			{if $usertype eq 1}
				<a class="button text-center" href="/guidebook/a-little-guidebook-how-to-get-started">Getting started</a>
			{else}
			{include file="user/profile/menu/client_left.tpl"}
			{/if}
			{/if}
			</div>
			{/if}
			<div class="seperator" data-gap="2"></div>
		</div>
		<div class="grid-main{if $grid_background neq ''} {$grid_background}{/if}">
			{if $missingdetails != '' || ($missingbank != '' && $user.usertype eq 1)}
					<div class="notice" style="border-radius: 20px;">
						<h4>We still need some information from you</h4>
						<p>We're missing some important information before {if $user.usertype eq 1}we{else}you{/if} can pay your {if $user.usertype eq 1}self-{/if}invoices.</p>
						{if $missingdetails}<p>Please update your {$missingdetails}.</p>{/if}
						{if $missingbank && $user.usertype eq 1}<p>Please visit the <a href="/payments">payments page</a> and update your {$missingbank}.</p>{/if}
						{if $missingmeasurements && $usertype eq 1}<p>You haven't filled in your {$missingmeasurements} measurement{if $mmcount neq 1}s{/if}. Without {if $mmcount eq 1}this{else}these{/if} you will not appear in search results and Clients won't be able to offer you jobs</p>{/if}
					</div>
			{/if}
					
			{include file="user/profile/affiliates.tpl"}
		</div>
	{/block}
	</div>
{if $usertype eq 1}
<div class="reveal modalWhite text-black" data-reveal id="referrer-code">
	<h2>Invite your talented model friends to iDAL, and earn products from Model Basics!</h2>
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
			<td style="padding: 0; width: 50%; text-align: right;">The Panties Goal = refer 1 friend</td>
			<td style="padding: 0 5px; height: 32px;"><img src="/images/refer_uparrow.png" /></td>
			<td style="padding: 0; width: 50%; text-align: left;"><img src="/images/refer_pants.png" /></td>
		</tr>
	</table>
	<p>&nbsp;</p>
	<h2>Your referral code: <span>{$referrer_code}</span></h2>
	<form method="post" action="/invite">
		<input type="text" name="inviteName" placeholder="Your friend's name" style="border-bottom: 1px solid #812d82; font-size: 14px;">
		<input type="text" name="inviteEmail" placeholder="Your friend's email" style="border-bottom: 1px solid #812d82; font-size: 14px;">
		<div class="text-right" style="float:right; margin-top: 2em; margin-right: 2em;">
			<a class="button inverted sendinvite">send invite</a>
		</div>
	</form>
</div>
{/if}