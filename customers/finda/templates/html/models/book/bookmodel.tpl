<div id="main" class="prod mobilepanel profile-home" style="padding-left: 0;">

	<div class="right-fill">

		<div class="row">
			<div class="column text-center">
				<h1>{$model.firstname|capitalize}.{$model.lastname|substr:0:1|capitalize}</h1>
			</div>
		</div>
		
		<div class="row mobile">
			<div class="column">
				<img src="{$smarty.const.CDN_ROOT}/{$model.imagetype}/large{$model.leadimage}" min-height="10em" width="100%" />
			</div>
		</div>
		
		<div class="modelinstagram">
			<div class="row">
				<div class="column instagramname text-center">
				</div>
			</div>
			<div class="row">
			</div>
		</div>
		<div class="row">
			<div class="column modelinstagram text-center">
				<div class="instagramname">
					{if $model.instagram_followers neq 0}
					<a href="https://instagram.com/{$model.instagram_username|replace:'@':''}" target="_blank">
					<i class="fab fa-instagram"></i> {$model.instagram_username|replace:'@':''} {$model.instagram_followers}
					</a>
					{/if}
				</div>
				<div class="instagramname">
					{$model.profile.location_name}
				</div>
			
			
				<div class="modeldetails">
					<div class="row">
						<div class="column text-right">Height</div>
						<div class="column">{$model.profile.height}cm/<span data-sizeconvert="cmtoft" data-value="{$model.profile.height}"></div>
					</div>
					{if $model.gender eq 'female'}
					<div class="row">
						<div class="column text-right">Bust</div>
						<div class="column">{$model.profile.bust}cm/<span data-sizeconvert="cmtoin" data-value="{$model.profile.bust}"></div>
					</div>
					{else}
					<div class="row">
						<div class="column text-right">{if $model.gender eq 'other'}Bust/{/if}Chest</div>
						<div class="column">{$model.profile.bust}cm/<span data-sizeconvert="cmtoin" data-value="{$model.profile.bust}"></div>
					</div>
					{/if}
					<div class="row">
						<div class="column text-right">Waist</div>
						<div class="column">{$model.profile.waist}cm/<span data-sizeconvert="cmtoin" data-value="{$model.profile.waist}"></div>
					</div>
					{if $model.gender eq 'female'}
					<div class="row">
						<div class="column text-right">Hips</div>
						<div class="column">{$model.profile.hips}cm/<span data-sizeconvert="cmtoin" data-value="{$model.profile.hips}"></div>
					</div>
					{else if $model.gender eq 'male'}
					<div class="row">
						<div class="column text-right">Collar</div>
						<div class="column">{$model.profile.collar_size}cm/<span data-sizeconvert="cmtoin" data-value="{$model.profile.collar_size}"></div>
					</div>
					{/if}
					{if $model.gender eq 'female' || $model.gender eq 'other'}
					{if $model.profile.dresssize neq 0}
					<div class="row">
						<div class="column text-right">Dress</div>
						<div class="column">{$model.profile.dresssize}&nbsp;UK</div>
					</div>
					{/if}
					{/if}
					{if $model.gender eq 'male' || $model.gender eq 'other'}
					{if $model.profile.suitsize neq 0}
					<div class="row">
						<div class="column text-right">Suit</div>
						<div class="column">{$model.profile.suitsize}&nbsp;UK</div>
					</div>
					{/if}
					{/if}
					<div class="row">
						<div class="column text-right">Shoe</div>
						<div class="column">{$model.profile.shoesize}&nbsp;UK</div>
					</div>
					<div class="row">
						<div class="column text-right">Hair</div>
						<div class="column">{$model.profile.haircolour}</div>
					</div>
					<div class="row">
						<div class="column text-right">Eyes</div>
						<div class="column">{$model.profile.eyecolour}</div>
					</div>
				</div>
				<div class="row">
					<div class="column text-center">
						<a href="/book/request/{$model.referrer_code}" class="button burgundy bookmodel" data-modelid="{$modelid}">Book {$model.firstname}</a>
					</div>
				</div>
			</div>
		</div>
	</div>

	<div class="right-third desktop">
		<div class="image" data-imagesrc="{$smarty.const.CDN_ROOT}/{$model.imagetype}/large{$model.leadimage}" style="width: 100%: height: 100%;"></div>
		<div class="loadfader">
			<div class="reverse-spinner"></div>
		</div>
	</div>


</div>

<input type="hidden" name="modelid" value="{$model.id}" />
<input type="hidden" name="modelname" value="{$model.firstname}" />
{if $usertype eq 1}</div>{/if}
{if $workflowData}
<input type="hidden" name="jobid" value="{$workflowData.id}" />
{else}
{if $usertype eq 2}{include file="jobs/joboffers_modal.tpl"}{/if}
{/if}
{if $usertype eq 2}{include file="jobs/newjob_modal.tpl"}{/if}
