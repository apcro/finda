	{* main layout for dashboard pages *}
	<div id="main" class="grid prod mobilepanel">
	{block name="dashboard"}
		<div class="grid-left desktop">
			{if $userid neq 0}
			<div class="avatar_holder" style="margin-top: 2em;">
				<div class="avatar">
					<a href="/user/avatar" data-balloon="Change your avatar" data-balloon-pos="down"><img id="avatarimage" src="{$user_avatar}" /></a>
				</div>
			</div>
			<div class="name_holder">
				<div class="profilename"><span>Hello,</span><br />{$firstname}<br />{$surname}</div>
				{if $is_founding_member eq 1}
				<br />
				<div style="width: 100%; text-align: left;" class="text-black"><em>Founding Member</em></div>
				<br /><br />
				{/if}
			</div>
			<div style="margin-top: 2em; margin-bottom: 4em; text-align: center;">
			<ul class="model_left_menu">
				<li><a{if $function eq 'user' && $secondary eq 'details'} class="selected" {/if} href="/user/profile">My Details</a></li>
			</ul>
			</div>
			{/if}
			<div class="seperator" data-gap="2"></div>
		</div>
		<div class="grid-main{if $grid_background neq ''} {$grid_background}{/if}">
			{if $missingdetails != ''}
					<div class="notice" style="border-radius: 20px;">
						<h4>We still need some information from you</h4>
						<p>We're missing some important information before {if $user.usertype eq 1}we{else}you{/if} can pay your {if $user.usertype eq 1}self-{/if}invoices.</p>
						{if $missingdetails}<p>Please update your {$missingdetails}.</p>{/if}
						{if $missingmeasurements && $usertype eq 1}<p>You haven't filled in your {$missingmeasurements} measurement{if $mmcount neq 1}s{/if}. Without {if $mmcount eq 1}this{else}these{/if} you will not appear in search results and Clients won't be able to offer you jobs</p>{/if}
					</div>
			{/if}
					
			{block name="main"}{/block}
			
		</div>
	{/block}
	</div>
