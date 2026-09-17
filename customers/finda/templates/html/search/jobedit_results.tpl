{* search results template *}
<div class="row">
	<div class="column">
	{if $models}
	{foreach from=$models item=model name=model}
	
	{* <a href="/view/{$model.sefu}"> *}
	<div class="searchmodelimage modelsearch-{$model.id}">
		<div class="modelView">
			<div class="image" data-imagesrc="{if $model.filename}{$CDN_ROOT}/{$model.imagetype}/large{$model.filename}{else}{$default_avatar}{/if}">
				<div class="loadfader">
					<div class="reverse-spinner"></div>
				</div>
			</div>
{if $model.job_status neq 0}
			<div class="ribbon">
{if $model.model_desired_rate neq 0 && $model.job_status eq 1}NEGOTIATING
{else}
{if $model.job_status eq 1}REQUESTED{/if}
{if $model.job_status eq 2}CONFIRMED{/if}
{if $model.job_status eq 3}CANCELLED{/if}
{* if $model.job_status eq 9}SELECTED{/if *}
{if $model.job_status eq 10}SHORTLISTED{/if}
{if $model.job_status eq 11}<i class="text-pink fas fa-star"></i>SHORTLISTED{/if}
{if $model.job_status eq 12}DECLINED{/if}
{if $model.job_status eq 14}ACCEPTED{/if}
{if $model.searchweight eq 1}<br />IS AVAILABLE{/if}
{/if}
			</div>
{else}
{if $model.job_status eq 0 && $model.searchweight eq 1 && $smarty.const.DEBUG}
			<div class="ribbon">
			IS AVAILABLE
			</div>
{/if}
{/if}
			<div class="details_overlay">
				{if $model.instagram_followers neq 0}
				<div class="instagram-details">
					<img src="/images/instagram_white.png" width="16px" height="16px" /> {$model.instagram_followers}
					<p  style="font-size: 0.75rem; font-weight: normal; text-transform: uppercase; padding-top: 0; padding-bottom: 0;">{$model.instagram_username}</p>
				</div>{/if}
				<hr />
				<div class="details">
					<ul class="resultsoverlay">
						<li class="divided"><span>Height</span><span data-sizeconvert="cmtoft" data-value="{$model.height}"></span></li>
						{if $model.gender eq 'female' || $model.gender eq 'other'}
						<li class="divided"><span>Dress Size</span><span>{$model.dresssize} UK</span></li>
						{/if}
						{if $model.gender eq 'male' || $model.gender eq 'other'}
						<li class="divided"><span>Suit Size</span><span>{$model.suitsize} UK</span></li>
						{/if}
						<li class="desktop divided"><span>Shoe Size</span><span>{$model.shoesize} UK</span></li>
						<li class="desktop divided"><span>Hair</span><span>{$model.haircolour}</span></li>
						<li class="desktop divided"><span>Eyes</span><span>{$model.eyecolour}</span></li>
					</ul>
				</div>
				<hr />
				{if $model.job_status eq 0}
				<div class="align-center" style="margin-top: 1em;"><span data-modelid="{$model.id}" class="option button small {$jobtype} optionbutton-{$model.id}">Shortlist</span></div>
				{else}
				{if $model.job_status neq 1 && $model.job_status neq 2 && $model.job_status neq 10 && $model.job_status neq 12 && $model.job_status neq 14}
				<div class="align-center" style="margin-top: 1em;"><span data-modelid="{$model.id}" class="option button small success optionbutton-{$model.id}" style="pointer-events: none">Shortlisted</span></div>
				{else}
				<div class="align-center" style="margin-top: 1em;"><span data-modelid="{$model.id}" class="option button small optionbutton-{$model.id}" style="display: none">Shortlist</span></div>
				{/if}
				{/if}
				<div class="align-center" style="margin-top: 1em">
					<a class="button small showfullprofile" href="/view/{$model.sefu}" target="_blank" style="border-bottom: 2px solid #ffba1c">View full profile</a>
				</div>
				{*
				<div class="images-link desktop">
					<div class="portfolio" data-href="/view/{$model.sefu}/portfolio">Portfolio</div>
					<div class="polaroids" data-href="/view/{$model.sefu}/polaroids">Polaroids</div>
				</div>
				*}
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
			</div>
		</div>
		<div class="name-leader">
			<div class="nameleader-name">{$model.firstname}.{$model.lastname|substr:0:1}</div>
			<div class="model-favourite" data-id="{$model.sefu}"><i class="fa{if $model.clientfavourite}s{else}r{/if} fa-heart"></i></div>
		</div>
	</div>
	{* </a> *}
	{/foreach}
	{else}
	<p><b class="text-findared">No models matched your search criteria, or your offered rate is too low.</b></p>
	<p>You can update the offered rate on this page for searches without having to save the project.</p>
	{/if}
	</div>
</div>