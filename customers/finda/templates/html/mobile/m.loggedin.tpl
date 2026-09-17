{extends "user/layout.tpl"}

{block name="main"}
<div class="row loggedin">
	<div class="column">
		<h2 style="transform-origin: left top;" class="header">Welcome to iDAL!</h2>
		<p class="textblock">We're working hard on our redesign at the moment, so the iDAL website is currently not available on mobile devices.</p>
		{if $usertype eq 1}
		<p class="textblock">As a model, you can manage your account using our mobile app, available for iOS:</p>
		<p class="text-center"><a href="https://itunes.apple.com/us/app/finda-for-models/id1427352589?ls=1&mt=8"><img src="/images/Download_on_the_App_Store_Badge_US-UK_RGB_blk_092917.svg" width=150 style="padding: 20px 0px;"/></a></p>
		{/if}
		<p class="text-center"><a href="/user/logout" class="button inverted">Sign Out</a></p>
	</div>
</div>
{/block}