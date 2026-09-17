	{* Navigation *}
	{if $smarty.const.HOLDING neq 1}
	<header>
		<div class="row column">
			<div class="top-bar">
				<div class="top-bar-title mobile">
					<a class="topbar-responsive-logo" alt="iDAL" href="/"><img class="normal_site" src="/images/IDAL_white.png" height=40 /><img class="welcome_logo" src="/images/IDAL_white.png" height=40 /></a>
				</div>
				<div class="top-bar-title desktop">
					<a class="topbar-responsive-logo" href="/" alt="iDAL"><img class="normal_site" src="/images/IDAL_white.png" height=26 style="margin-bottom: 7px;" /><img class="welcome_logo" src="/images/IDAL_white.png" height=40 /></a>
					{if $usercompany.id neq 0}<span style="margin-left: 2em"><img style="border-radius: 2px" class="normal_site" src="/companylogos/{$usercompany.logo}" height=40 width=40/></span>{/if}
				</div>
				<div class="top-bar-right desktop">
					<ul class="menu simple horizontal">
						{if $usertype == 1 || $usertype == 2 || $usertype == 3}
						{if $usertype == 1}
						{include file="menu/model_menu.tpl"}
						{else if $usertype == 2}
						{include file="menu/client_menu.tpl"}
						{else if $usertype == 3}
						{include file="menu/motheragency_menu.tpl"}
						{/if}
						<li><a href="/user/logout">Sign out</a></li>
						{else}
{*						<li><a href="/howto"{if $function eq 'howto'} style="font-weight: 700; color: #ff4040;"{/if}>How it Works</a></li> *}
{*						<li><a href="/mission"{if $function eq 'mission'} style="font-weight: 700; color: #ff4040;"{/if}>About Us</a></li>*}
{*						<li><a href="/modelwithus"{if $function eq 'modelwithus'} style="font-weight: 700; color: #ff4040;"{/if}>Model With Us</a></li>*}
{*						<li><a href="#podcast" class="podcast">iDAL Voices</a></li> *}
{*						<li><a href="/modellaw"{if $function eq 'modellaw'} style="font-weight: 700; color: #ff4040;"{/if}>Model Law</a></li>*}
						{if $resetpassword eq 0}
						<li><a data-open="loginModal" href="">Sign In</a></li>
						{/if}
					{/if}
					</ul>
					{* messages popup *}
					{* include file="user/inbox/notification_popup.tpl" *}
				</div>
				{if $userid neq 0}
				<div class="mobile">
					<div class="panel-toggle-button">
						<div class="hamburger hamburger--arrow">
							<div class="hamburger-box">
								<div class="hamburger-inner"></div>
							</div>
						</div>
					</div>
				</div>
				{/if}
			</div>
			{if $userid neq 0}
			<nav id="mobilemenu" class="mobile {$body_class}">
				<div class="avatar_holder" style="margin-top: 2em;">
					<div class="avatar">
						<img id="avatarimage" src="{$user_avatar}">
					</div>
				</div>
				<ul>
				<li>&nbsp;</li>
				{* if $usertype eq 1}
				{include file="mobile/menu/model_left.tpl"}
				{else}
				{include file="mobile/menu/client_menu.tpl"}
				{include file="mobile/menu/client_left.tpl"}
				{/if *}
				<li>&nbsp;</li>
				<li><a href="/user/logout"><i class="fas fa-power-off"></i>Sign out</a>
				</ul>
			</nav>
			{/if}
		</div>
	</header>
	{if $userid eq 0}
	{include file="shared/loginmodal.tpl"}
	{/if}
	{/if}