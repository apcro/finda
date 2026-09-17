{* extends "user/polaroids/polaroids_layout.tpl" *}
{extends "user/layout.tpl"}

{block name="main"}
<div class="row">
	<div class="column">
		<h1>Polaroids</h1>
		<p style="width: 100%;">&nbsp;</p>
	</div>
	<div class="column desktop"></div>
	<div class="column text-right desktop">
		<a class="button burgundy" href="/user/polaroids/new">+ Add New</a><br /><br />
		<a class="button inverted" href="/view/{$sefu}">Preview your profile</a>
	</div>
</div>
<div class="row desktop">
	<div class="column text-center"><a class="text-bold" href="/guidebook/a-little-guidebook-nail-the-polaroid-game">How to take your own outstanding polaroids &raquo;</a></div>
</div>
<div class="row mobile">
	<div class="column">
		<p class="notice">Please use your laptop to upload your polaroids.</p>
	</div>
</div>
<div class="row polaroids" id="polaroidImages">
	{foreach from=$polaroids item=polaroid name=polaroid}
	<div class="column imagecol" id="image{$polaroid.id}" data-orderid="{$polaroid.id}">
		<div class="large reveal" id="imagePolModal{$smarty.foreach.polaroid.iteration}" data-reveal>
			<a class="croissant-close mobile" title="Close"></a>
			<img src="{$smarty.const.CDN_ROOT}/polaroids/large{$polaroid.filename}" class="float-center" style="max-height: 100%;"/>
		</div>
		
		<div class="image_container">
				<div class="dots_menu">
				<div class="menudots"><i class="fas fa-ellipsis-h"></i></div>
				<div class="dotmenuitems">
					{if $polaroid.leadimage eq 0}
					<div><a class="makeleader" href="/user/polaroids/leader" data-id="{$polaroid.id}" data-balloon="Select as profile image" data-balloon-pos="up">Set as Main Image</a></div>
					{else}
					<div><a class="editavatar" href="/user/avatar/edit" data-id="{$polaroid.id}" data-balloon="Edit existing profile image" data-balloon-pos="up">Edit Profile Image</a></div>
					{/if}
				
					<div><a class="remove" href="/user/polaroid/remove" data-id="{$polaroid.id}" data-balloon="Remove image" data-balloon-pos="up">Remove</a></div>
				</div>
			</div>
		
			<div data-open="imagePolModal{$smarty.foreach.polaroid.iteration}" class="image image-{$polaroid.id}" data-image="{$smarty.const.CDN_ROOT}/polaroids/large{$polaroid.filename}"><span class="{if $polaroid.leadimage eq 1}leader{/if}"><span class="image_fader"><img src="/images/loading-icon.gif" /></span></span></div>
		</div>
	</div>
	{/foreach}
</div>
{/block}