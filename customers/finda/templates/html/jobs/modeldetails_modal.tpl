<div class="search-results">
	<div class="row">
		<div class="column">
		{foreach from=$job.models item=model name=model}
		<a href="/view/{$model.sefu}"><div class="searchmodelimage">
			<div class="modelView">
				<div class="image"><img src="{if $model.filename}{$CDN_ROOT}/{$model.imagetype}/large{$model.filename}{else}{$default_avatar}{/if}" /></div>
				<div class="details_overlay">
					<div class="name-leader">{$model.firstname}.{$model.lastname|substr:0:1}<div class="model-favourite"><i class="fa{if $model.clientfavourite}s{else}r{/if} fa-heart align-right"></i></div></div>
					<div class="details">
						<ul>
							<li>AGE: {$model.age}</li>
							<li>HEIGHT: <span data-sizeconvert="cmtoft" data-value="{$model.height}"></span></li>
							<li>BUST SIZE: {$model.bust}cm</li>
							<li>WAIST SIZE: {$model.waist}cm</li>
							<li>SHOE SIZE: {$model.shoesize} UK</li>
							<li>HAIR: {$model.haircolour}</li>
							<li>EYES: {$model.eyecolour}</li>
						</ul>
					</div>
					<div class="images-link">
						<a class="portfolio" href="/view/{$model.sefu}/portfolio">portfolio</a> 
						<a class="polaroids" href="/view/{$model.sefu}/polaroids">polaroids</a>
					</div>
					{if $model.instagram_followers neq 0}
					<div class="instagram-details">
						<img src="/images/instagram_white.png" width="16px" height="16px" /> {$model.instagram_followers}
					</div>{/if}
				</div>
			</div>
		</div></a>
		{/foreach}
		</div>
	</div>
</div>
