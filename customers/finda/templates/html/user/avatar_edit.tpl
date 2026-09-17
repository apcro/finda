{extends "user/layout.tpl"}

{block name="main"}
<div class="row">
	<div class="column">
		<h1 style="transform-origin: left top;">Edit your Profile Image</h1>
	</div>
</div>
<div class="row">
	<div class="column">
		<p>Use the controls below to adjust how your {if $usertype eq 1}profile image{else}avatar{/if} should appear within the circle. Press the save button when you are finished.</p>
	</div>
</div>
<div class="row">
	<div class="column text-center">
		<h2>Profile Image</h2>
		<p>This image will appear on your pages and on messages you send to Clients</p>
		<div id="theparent" class="avatar">
			<img id="thepicture" src="{$avatar}">
		</div>
{*	</div>
	<div class="column text-center" style="display: flex; align-items: flex-end;"> *}
		<div id="controls" class="">
{*			<a href="#" id="rotate_left" title="Rotate left"><i class="fa fa-rotate-left"></i></a> *}
			<a href="#" id="zoom_out" title="Zoom out"><i class="fa fa-search-minus"></i></a>
			<a href="#" id="fit" title="Fit image"><i class="fa fa-arrows-alt"></i></a>
			<a href="#" id="zoom_in" title="Zoom in"><i class="fa fa-search-plus"></i></a>
{*			<a href="#" id="rotate_right" title="Rotate right"><i class="fa fa-rotate-right"></i></a> *}
		</div>
	</div>
	{*
	<div class="column text-center picture">
		<h2>Discovery Image</h2>
		<p>This is how your profile image will appear on the Discovery page</p>
		<div id="discoveryimage" class="discovery">
			<img id="discoverypicture" src="{$avatar}">
		</div>
	</div>
	*}
</div>
<div class="row" style="padding-top: 2em;">
	<div class="column text-center">
		<a class="button burgundy saveavatar" data-imageid="{$imageid}">Save</a>
	</div>
	<div class="column text-center">
		<a class="button cancelbutton" href="/user/portfolio">Cancel</a>
	</div>
</div>
{/block}