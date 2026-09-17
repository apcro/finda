{extends "user/layout.tpl"}

{block name="main"}
<div class="row row-heading">
	<div class="column">
		<h2>Your favourite models</h2>
	</div>
</div>
<div class="row mobile">
	<div class="column">
		<p class="notice">Please use your desktop or laptop to enjoy all our features. The iDAL app is coming soon!</p>
	</div>
</div>

{if $pagemessage.message neq ""}
<div class="row">
	<div class="callout {$pagemessage.type}">
		<h5>{$pagemessage.message}</h5>
	</div>
</div>
{/if}
<div class="search-results favourites">
	<div class="row">
		<div class="column modelcards">
			{if $favourites}
			{foreach from=$favourites item=model name=model}
			<div id="model-{$model.sefu}">
				<a href="/view/{$model.sefu}"><div class="searchmodelimage">
				<div class="modelView">
					<div class="image"><img src="{if $model.filename}{$CDN_ROOT}/{$model.imagetype}/large{$model.filename}{else}{$default_avatar}{/if}" /></div>
					<div class="details_overlay">
						<div class="name-leader">{$model.firstname}.{$model.lastname|substr:0:1}<div class="model-favourite" data-id="{$model.sefu}"><i class="fa{if $model.clientfavourite}s{else}r{/if} fa-heart"></i></div></div>
						<div class="details">
							<ul>
								<li>AGE: {$model.age}</li>
								<li>HEIGHT: <span data-sizeconvert="cmtoft" data-value="{$model.height}"></span></li>
								<li>DRESS SIZE: {$model.dresssize}</li>
								<li class="desktop">SHOE SIZE: {$model.shoesize} UK</li>
								<li class="desktop">HAIR: {$model.haircolour}</li>
								<li class="desktop">EYES: {$model.eyecolour}</li>
							</ul>
						</div>
						<div class="images-link desktop">
							<div class="portfolio" data-href="/view/{$model.sefu}/portfolio">portfolio</div> 
							<div class="polaroids" data-href="/view/{$model.sefu}/polaroids">polaroids</div>
						</div>
						{if $model.instagram_followers neq 0}
						<div class="instagram-details">
							<img src="/images/instagram_white.png" width="16px" height="16px" /> {$model.instagram_followers}
						</div>{/if}
					</div>
				</div>
			</div></a>
		</div>
		{/foreach}
		{else}
		<p>You have no favourite models.</b></p>
		{/if}
		</div>
	</div>
</div>
{/block}