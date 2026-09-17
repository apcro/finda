<div data-href="/view/{$model.sefu}" class="modelcard candrag" id="modeldrag-{$model.id}">
	<div class="detailsoverlay-removemodel text-center" data-modelid="{$model.id}" data-balloon="remove?" data-balloon-pos="left"><i class="fas fa-times align-right text-white"></i></div>
	<div class="searchmodelimage model-{$model.id}">
		<div class="modelView">
			<div class="image"><img src="{if $model.filename}{$CDN_ROOT}/{$model.imagetype}/large{$model.filename}{else}{$default_avatar}{/if}"></div>
			<div class="statusribbon">
				<div class="button inverted small optioned offerbutton" data-modelid="{$model.id}" data-jobid="{$jobid}" data-modelname="{$model.firstname}">Invite to casting?</div>
			</div>
			<div class="name-leader">
				<div class="nameleader-name">{$model.firstname}.{$model.lastname|substr:0:1}</div>
				<div class="model-favourite" data-id="{$model.sefu}"><i class="fa{if $model.clientfavourite}s{else}r{/if} fa-heart"></i></div>
				<p class="nameleader-insta"><i class="fab fa-instagram"></i>&nbsp;{$model.instagram_username}</p>
			</div>
		</div>
	</div>
</div>