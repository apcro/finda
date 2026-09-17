<a href="/view/{$model.sefu}" class="modelcard" id="modeldrag-{$model.id}"><div class="searchmodelimage model-{$model.id}">
	<div class="modelView">
		<div class="image"><img src="{if $model.filename}{$CDN_ROOT}/{$model.imagetype}/large{$model.filename}{else}{$default_avatar}{/if}" /></div>
		<div class="details_overlay">
			<div class="name-leader">{$model.firstname}.{$model.lastname|substr:0:1}<div class="model-favourite" data-id="{$model.sefu}"><i class="fa{if $model.clientfavourite}s{else}r{/if} fa-heart align-right"></i></div></div>
			<div class="images-link">
				<span style="position: absolute; bottom: 10px;" data-modelid="{$model.id}" class="text-center button removeModel">Remove?</span>
			</div>
			{if $model.instagram_followers neq 0}
			<div class="instagram-details">
				<img src="/images/instagram_white.png" width="16px" height="16px" /> {$model.instagram_followers}
			</div>{/if}
		</div>
	</div>
</div></a>