{extends "user/layout.tpl"}

{block name="main"}
<div class="row">
	<div class="column">
		<h1>Portfolio Images</h1>
		<p class="desktop">Upload your most recent portfolio images, and then select your profile photo by clicking on the tick on one of the uploaded photos.</p>
	</div>
	<div class="column text-right desktop">
		<a class="button burgundy" href="/user/portfolio/new">+ Add New</a><br /><br />
		<a class="button inverted" href="/view/{$sefu}">Preview your profile</a>
	</div>
</div>
<div class="row desktop">
	<div class="column text-center"><a class="text-bold" href="/guidebook/how-to-create-a-drop-dead-gorgeous-portfolio-on-finda">How to create an interesting portfolio &raquo;</a></div>
</div>
<div class="row mobile">
	<div class="column">
		<p class="notice">Please use your laptop to upload your portfolio.</p>
	</div>
</div>
<div class="row portfolio" id="portfolioImages">
	{foreach from=$portfolioimages item=portfolio name=portfolio}
	<div class="column imagecol" id="image{$portfolio.id}" data-orderid="{$portfolio.id}">
		<div class="large reveal" id="imagePolModal{$smarty.foreach.portfolio.iteration}" data-reveal data-prev="{$portfolio.prev}" data-next="{$portfolio.next}">
			<a class="croissant-close mobile" title="Close"></a>
			<img id="modalImage{$portfolio.id}" src="{$smarty.const.CDN_ROOT}/portfolio/large{$portfolio.filename}" class="float-center" style="max-height: 100%;"/>
		</div>
		
		<div class="image_container">
			<div class="dots_menu">
				<div class="menudots"><i class="fas fa-ellipsis-h"></i></div>
				<div class="dotmenuitems">
					{if $portfolio.leadimage eq 0}
					<div><a class="makeleader" href="/user/portfolio/leader" data-id="{$portfolio.id}" data-balloon="Select as profile image" data-balloon-pos="up">Set as Main Image</a></div>
					{else}
					<div><a class="editavatar" href="/user/avatar/edit" data-id="{$portfolio.id}" data-balloon="Edit existing profile image" data-balloon-pos="up">Edit Profile Image</a></div>
					{/if}
					<div><a class="remove" href="/user/portfolio/remove" data-id="{$portfolio.id}" data-balloon="Remove image" data-balloon-pos="up">Remove</a></div>
				</div>
			</div>

			<div data-open="imagePolModal{$smarty.foreach.portfolio.iteration}" class="image" data-image="{$smarty.const.CDN_ROOT}/portfolio/large{$portfolio.filename}"><span class="{if $portfolio.leadimage eq 1}leader{/if}"><span class="image_fader"><img src="/images/loading-icon.gif" /></span></span></div>
		</div>
	</div>
	{/foreach}
</div>
{/block}