{extends file="user/layout_images.tpl"}

{block name="main"}
<div class="mobile text-center">
	<div class="back-link"><a href="/view/{$model.sefu}">back to profile</a></div>
</div>
<div class="model-images-row" id="main">

	<div class="measurements">
		<ul>
			<li>Height: <span data-sizeconvert="cmtoft" data-value="{$model.profile.height}"></span></li>
			{if $model.gender eq 'female' || $model.gender eq 'other'}
			{if $model.profile.dresssize neq 0}
			<li>Dress Size: {$model.profile.dresssize} UK</li>
			{/if}
			{/if}
			{if $model.gender eq 'male' || $model.gender eq 'other'}
			{if $model.profile.suitsize neq 0}
			<li>Suit Size: {$model.profile.suitsize} UK</li>
			{/if}
			{/if}
			<li>Shoe Size: {$model.profile.shoesize} UK</li>
			<li>Hair: {$model.profile.haircolour}</li>
			<li>Eyes: {$model.profile.eyecolour}</li>
			<li><a href="https://instagram.com/{$model.instagram_username|replace:"@":""}"><i class="fab fa-instagram"></i> {$model.instagram_followers}</a></li>
		</ul>
	</div>

	<div class="viewmodelimages portfolio">
		<div class="model-image-grid">
			<div class="row modelImages">
			<script type="text/javascript">var portfolioImageGallery = {$galleryportfolio};</script>
			{if $portfolio}
			{foreach from=$portfolio item=portf name=portf}
				<div class="column imagecol{if $smarty.foreach.portf.iteration%3 eq 0} modelcounter{/if}" id="image{$portf.id}">
					<div class="image_container">
						<div class="imageload image{$portf.id}" data-imageId="{$portf.id}" data-filename="{$smarty.const.CDN_ROOT}/portfolio/large{$portf.filename}" data-image="{$smarty.const.CDN_ROOT}/portfolio/large{$portf.filename}"><span class="image_fader portfolio"><img src="/images/loading-icon.gif" /></span></div>
					</div>
				</div>
			{/foreach}
			{else}
			<div class="text-center" style="width: 100%">Sorry, {$model.firstname} hasn't uploaded any images to this gallery yet.</div>
			{/if}
			</div>
		</div>
	</div>

	<div class="viewmodelimages polaroids">
		<div class="model-image-grid">
			<div class="row modelImages">
			<script type="text/javascript">var polaroidsImageGallery = {$gallerypolaroids};</script>
			{if $polaroids}
			{foreach from=$polaroids item=portf name=portf}
				<div class="column imagecol{if $smarty.foreach.portf.iteration%3 eq 0} modelcounter{/if}" id="image{$portf.id}">
					<div class="image_container">
						<div class="imageload image{$portf.id}" data-imageId="{$portf.id}" data-filename="{$smarty.const.CDN_ROOT}/polaroids/large{$portf.filename}" data-image="{$smarty.const.CDN_ROOT}/polaroids/large{$portf.filename}"><span class="image_fader portfolio"><img src="/images/loading-icon.gif" /></span></div>
					</div>
				</div>
			{/foreach}
			{else}
			<div class="text-center" style="width: 100%">Sorry, {$model.firstname} hasn't uploaded any images to this gallery yet.</div>
			{/if}
			</div>
		</div>
	</div>
	
	<div class="measurements">
		<ul>
			<li>Height: <span data-sizeconvert="cmtoft" data-value="{$model.profile.height}"></span></li>
			{if $model.gender eq 'female' || $model.gender eq 'other'}
			{if $model.profile.dresssize neq 0}
			<li>Dress Size: {$model.profile.dresssize} UK</li>
			{/if}
			{/if}
			{if $model.gender eq 'male' || $model.gender eq 'other'}
			{if $model.profile.suitsize neq 0}
			<li>Suit Size: {$model.profile.suitsize} UK</li>
			{/if}
			{/if}
			<li>Shoe Size: {$model.profile.shoesize} UK</li>
			<li>Hair: {$model.profile.haircolour}</li>
			<li>Eyes: {$model.profile.eyecolour}</li>
			<li><a href="https://instagram.com/{$model.instagram_username|replace:"@":""}"><i class="fab fa-instagram"></i> {$model.instagram_followers}</a></li>
		</ul>
	</div>
	
</div>
<input type="hidden" name="imagetype" value="{$imagetype}" />
{if $workflowData}
<input type="hidden" name="jobid" value="{$workflowData.id}" />
{else}
{if $usertype eq 2}{include file="jobs/joboffers_modal.tpl"}{/if}
{/if}
{/block}