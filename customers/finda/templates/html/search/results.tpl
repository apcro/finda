{* search results template *}
<div class="row">
	<div class="column">
	{if $models}
	{foreach from=$models item=model name=model}
	<a href="/view/{$model.sefu}/portfolio"><div class="searchmodelimage">
		<div class="modelView">
			<div class="image{if $smarty.foreach.model.iteration gte 6} lazy{/if}" data-imagesrc="{if $model.filename}{$CDN_ROOT}/{$model.imagetype}/large{$model.filename}{else}{$default_avatar}{/if}">
				<div class="loadfader">
				<div class="reverse-spinner"></div>
				</div>
			</div>
			<div class="details_overlay">
				{if $model.instagram_followers neq 0}
				<div class="instagram-details">
					<img src="/images/instagram_white.png" width="16px" height="16px" /> {$model.instagram_followers}
					<p style="font-size: 0.75rem; font-weight: normal; margin-top: 0.5em; margin-bottom: 1em;">{$model.instagram_username}</p>
				</div>{/if}
				<div class="details">
					<ul>
						<li class="divided"><span>Height</span><span data-sizeconvert="cmtoft" data-value="{$model.height}"></span></li>
						{if $model.gender eq 'female' || $model.gender eq 'other'}
						{if $model.dresssize neq 0}
						<li class="divided"><span>Dress Size</span><span>{$model.dresssize} UK</span></li>
						{/if}
						{/if}
						{if $model.gender eq 'male' || $model.gender eq 'other'}
						{if $model.suitsize neq 0}
						<li class="divided"><span>Suit Size</span><span>{$model.suitsize} UK</span></li>
						{/if}
						{/if}
						<li class="desktop divided"><span>Shoe Size</span><span>{$model.shoesize} UK</span></li>
						<li class="desktop divided"><span>Hair</span><span>{$model.haircolour}</span></li>
						<li class="desktop divided"><span>Eyes</span><span>{$model.eyecolour}</span></li>
					</ul>
				</div>
				{*
				<div class="images-link desktop">
					<div class="portfolio" data-href="/view/{$model.sefu}/portfolio">Portfolio</div>
					<div class="polaroids" data-href="/view/{$model.sefu}/polaroids">Polaroids</div>
				</div>
				*}
				{*
				<hr class="availablility_gap">
				<div class="availability">
					<div class="availability_heading">Availability for the next week</div>
					<div class="availability_days">
						{foreach from=$model.lastminute item=day key=dayname name=dayslist}
							{if $smarty.foreach.dayslist.first}
							{else}
							<div class="availablility_box">
								<div class="availability_day">{$dayname|substr:0:3}</div>
								<div class="available">
									{if $day eq 1}<i class="fas fa-check"></i>
									{elseif $day eq 2}<i class="fas fa-times"></i>
									{else}<i class="fas fa-minus"></i>{/if}
								</div>
							</div>
							{/if}
						{/foreach}
					</div>
				</div>
				*}
			</div>
		</div>
		<div class="name-leader">
			<p class="nameleader-name text-center">{$model.firstname|capitalize} {$model.lastname|substr:0:1}</p>
			{if $usertype eq 2}
			<div class="model-favourite" data-id="{$model.sefu}"><i class="fa{if $model.clientfavourite}s{else}r{/if} fa-heart"></i></div>
			{/if}
		</div>
		
	</div></a>
	{/foreach}
	{else}
	<p style="text-align: center; width: 100%;"><b>Sorry, no models matched your search criteria.</b></p>
	{/if}
	</div>
</div>
