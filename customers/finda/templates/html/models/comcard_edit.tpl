{extends "user/layout.tpl"}
{block name="main"}
<div class="row row-heading">
	<div class="column">
		<h2 class="text-black">Edit your Comcard</h2>
	</div>
</div>
{if $message neq '' || $errormessage neq ''}
<div class="row">
	<div class="column">
		{if $errormessage neq ''}
		<p class="notice">{$errormessage}</p>
		{/if}
		{if $message neq ''}
		<p>{$message}</p>
		{/if}
	</div>
</div>
{/if}

	<div class="frontback text-center">
		<div class="tab-front active"><em>front</em></div> | <div class="tab-back"><em>back</em></div>
	</div>
	<div class="pages"> {* comcard editor *}
		<div class="comcard page1">
			<div class="page1_details">
				<div class="nameholder">
					<div class="fname">{$model.firstname}</div>
					<div class="lname"><em>{$model.lastname}</em></div>
				</div>
				<div class="instaholder">
					<div class="instafollowers"><img src="/images/instagram.png" style="width: 24px; height: 24px;"/>{$model.instagram_followers}</div>
					<div class="instagramhandle">{$model.instagram_username}</div>
				</div>
			</div>
			<div class="portfolio_frame" style="background-image: url({$smarty.const.CDN_ROOT}/portfolio/large/{$model.filename});"></div>
			<div class="text-center"><img src="/images/IDAL_black.png" /></div>
		</div>
		<div class="comcard page2">
			<div class="nameleader">{$model.firstname} {$model.lastname}</div>
			<div class="measurements text-center">
			height: <b>{$model.profile.height}</b> | 
			bust: <b>{$model.profile.bust}</b> |
			waist: <b>{$model.profile.waist}</b> |
			hips:<b>{$model.profile.hips}</b> |
			shoes: <b>{$model.profile.shoesize}</b> |
			dress: <b>{$model.profile.dresssize}</b> |
			hair: <b>{$model.profile.haircolour}</b> |
			eyes: <b>{$model.profile.eyecolour}</b>
			</div>
			<div class="comcard_images">
				<div class="polaroid1 polaroid droppable" data-type="polaroid">
					<p>Select a close-up polaroid image of yourself and drop it here</p>
					<div class="cross"></div>
				</div>
				<div class="polaroid2 polaroid droppable" data-type="polaroid">
					<p>Select a full body polaroid image of yourself and drop it here</p>
					<div class="cross"></div>
				</div>
				<div class="portfolio1 portfolio droppable" data-type="portfolio">
					<p>Select a body shot of yourself and drop it here</p>
					<div class="cross"></div>
				</div>
				<div class="portfolio2 portfolio droppable" data-type="portfolio">
					<p>Select a beauty shot of yourself and drop it here</p>
					<div class="cross"></div>
				</div>
			</div>
			<div class="text-center" style="margin-bottom: 1em;"><img src="/images/IDAL_black.png" /></div>
		</div>
	</div>
	
	<div class="narrow"> {* images *}
		<div class="tabs">
			<div class="tab-portfolio active" id="tab-portfolio">Portfolio</div>
			<div class="tab-polaroids" id="tab-polaroids">Polaroids</div>
		</div>
		<div class="scrollable">
			<div class="tab-portfolio-images">
				{foreach from=$portfolio item=portf}
				<div class="imagecol draggable" data-type="portfolio" id="dragimage-{$portf.id}">
					<div class="image_container">
						<div class="imageload image{$portf.id}" data-imageId="{$portf.id}" data-filename="{$smarty.const.CDN_ROOT}/portfolio/large{$portf.filename}" data-image="{$smarty.const.CDN_ROOT}/portfolio/large{$portf.filename}"><span class="image_fader {$imagetype}"><img src="/images/loading-icon.gif" /></span></div>
					</div>
				</div>
	
				{/foreach}
			</div>
			<div class="tab-polaroids-images">
				{foreach from=$polaroids item=portf}
				<div class="column imagecol draggable" data-type="polaroid" id="dragimage-{$portf.id}">
					<div class="image_container">
						<div class="imageload image{$portf.id}" data-imageId="{$portf.id}" data-filename="{$smarty.const.CDN_ROOT}/polaroids/large{$portf.filename}" data-image="{$smarty.const.CDN_ROOT}/polaroids/large{$portf.filename}"><span class="image_fader {$imagetype}"><img src="/images/loading-icon.gif" /></span></div>
					</div>
				</div>
	
				{/foreach}
			</div>
		</div>
	
	</div>


{/block}