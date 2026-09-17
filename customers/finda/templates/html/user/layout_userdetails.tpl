	{* main layout for project pages *}
	{* collapsing menu here *}
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
				<div style="width: 100%; text-align: left;" class="text-black"><em>Founding Member</em></div>
				<br /><br />
				{/if}
				{if $motheragency && $usertype eq 1}
				<br />
				Your Mother Agency is <b><a href="{$motheragency.website}" target="_blank">{$motheragency.agencyname}</a></b>.
				<br /><br />
				{/if}
			</div>
			<div style="margin-top: 2em; margin-bottom: 4em; text-align: center;">
			{if $user_status neq 0}
			{if $usertype eq 2}
				<a class="button fullwidth inverted" href="/projects/create">Create Project</a><br /><br />
			{else if $usertype eq 1}
				<ul class="vertical menu profile">
				{if $usertype eq 1}{include file="user/profile/menu/model_left.tpl"}{/if}
				</ul>
				<a class="text-center" style="border-bottom: none;" href="https://itunes.apple.com/us/app/finda-for-models/id1427352589?ls=1&mt=8"><img src="/images/Download_on_the_App_Store_Badge_US-UK_RGB_blk_092917.svg" width=150 style="padding: 20px 0px;"/></a>
				<a href="https://play.google.com/store/apps/details?id=co.finda.models"><img  width=150 style="padding: 20px 0px;" src="/images/google-play-badge.svg"></a>
			{/if}
			{else}
			{if $usertype eq 1}
				<a class="button winvertedtext-center" href="/guidebook/a-little-guidebook-how-to-get-started">Getting started</a>
				<ul class="model_left_menu">
					<li><a{if $function eq 'user' && $secondary eq 'details'} class="selected" {/if} href="/user/profile">My Details</a></li>
					<li><a{if $function eq 'user' && $secondary eq 'portfolio'} class="selected" {/if} href="/user/portfolio">Portfolio</a></li>
					<li><a{if $function eq 'user' && $secondary eq 'polaroids'} class="selected" {/if} href="/user/polaroids">Polaroids</a></li>
				</ul>
			{else if $usertype eq 2}
				{include file="user/profile/menu/client_left.tpl"}
			{/if}
			{/if}
			</div>
			{/if}
			<div class="seperator" data-gap="2"></div>
		</div>
		<div class="grid-main{if $grid_background neq ''} {$grid_background}{/if}">
			{if $missingdetails != ''}
			<div class="notice" style="border-radius: 2px;">
				<h4>We still need some information from you</h4>
				<p>We're missing some important information before {if $user.usertype eq 1}we{else}you{/if} can pay your {if $user.usertype eq 1}self-{/if}invoices.</p>
				{if $missingdetails}<p>Please update your {$missingdetails}.</p>{/if}
				{if $missingmeasurements && $usertype eq 1}<p>You haven't filled in your {$missingmeasurements} measurement{if $mmcount neq 1}s{/if}. Without {if $mmcount eq 1}this{else}these{/if} you will not appear in search results and Clients won't be able to offer you jobs</p>{/if}
			</div>
			{/if}
			<section id="projects_header">
				<div class="row column">
					<div class="projects_top">
						{if $user.companyid neq 0}
						<div class="project_collapsing mydetailsheader"><span class="mydetails active">My Details</span>{if $usertype eq 2 && $user.status neq 0} | <span class="companydetails">Company Information</span>{/if}</div>
						{else}
						<div class="project_collapsing mydetailsheader" style="display: inline-block;">My Details</div>{if $usertype eq 2 && $user.status neq 0}<div class="text-right" style="float: right"><a class="button requestcompany">Request Company Account</a></div>{/if}
						{/if}
					</div>
				</div>
			</section>
			{block name="main"}{/block}
		</div>
	{/block}
	</div>