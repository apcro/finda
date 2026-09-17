{extends "user/layout_wide.tpl"}

{block name="main"}
<div class="row">
	<div class="column">
		<h1>Models shortlisted for project <em>{$job.name}</em></h1>
	</div>
</div>

<div class="row">
	<div class="column">
		<div style="display: flex; flex-wrap: wrap; justify-content: center; align-items: center">
			{assign shareproject 1}
			{include file='jobs/job_card.tpl'}
		</div>
	</div>
</div>
<div class="row">
	<div class="column">
		<p>Drag and drop models between the two selection areas. Changes are saved automatically. Models will not be informed of your changes until the changes are confirmed by <b>{$client.firstname} {$client.lastname}</b> in the project editor.</p>
		<div class="text-center">
			<a class="text-center finished button burgundy">Finished</a>
		</div>
	</div>
</div>
<div class="row mobile">
	<div class="column">
		<p class="notice">Please use your desktop or laptop to enjoy all our features. The IDAL app is coming soon!</p>
	</div>
</div>

{if $pagemessage.message neq ""}
<div class="row">
	<div class="callout {$pagemessage.type}">
		<h5>{$pagemessage.message}</h5>
	</div>
</div>
{/if}

<div class="row">
	<div class="column modelcards half">
		<h3>Shortlisted for review</h3>
		<div class="optioned modelcards container">
			{if $optioned}
			{foreach from=$optioned item=model name=model}
				<a href="/view/{$model.sefu}/{$shareuri}" class="modelcard" id="modeldrag-{$model.id}"><div class="searchmodelimage model-{$model.id}">
					<div class="modelView">
						<div class="image"><img src="{$CDN_ROOT}/{$model.imagetype}/large{$model.filename}" /></div>
						<div class="details_overlay">
							<div class="name-leader">{$model.firstname}.{$model.lastname|substr:0:1}
							{if $model.instagram_followers neq 0}<span style="float: right;"><img src="/images/instagram_white.png" width="10px" height="10px" /> {$model.instagram_followers}{/if}</span>
							</div>
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
							<div class="images-link">
								<span style="position: absolute; bottom: 10px;" data-modelid="{$model.id}" class="text-center shareremovebutton bg-blue white hvr hvr-black removeModel">remove?</span>
							</div>
						</div>
					</div>
				</div></a>
			{/foreach}
			{/if}
		</div>
	</div>
	<div class="column">
		<div class="dragtext">
			<i class="fas fa-angle-double-right"></i><i class="fas fa-angle-double-right"></i><br />
			Click or drag to select model<br />
			<i class="fas fa-angle-double-right"></i><i class="fas fa-angle-double-right"></i><br /><br /><br /><br />
			<i class="fas fa-angle-double-left"></i><i class="fas fa-angle-double-left"></i><br />
			Click or drag to de-select model<br /><i class="fas fa-angle-double-left"></i><i class="fas fa-angle-double-left"></i>
		</div>
	</div>
	<div class="column modelcards half">
		<h3>Shortlisted for Project</h3>
		<div class="column modelcards">
			<div class="reviewed modelcards container">
				{if $selected}
				{foreach from=$selected item=model name=model}
					<a href="/view/{$model.sefu}" class="modelcard" id="modeldrag-{$model.id}"><div class="searchmodelimage model-{$model.id}">
						<div class="modelView">
							<div class="image"><img src="{$CDN_ROOT}/{$model.imagetype}/large{$model.filename}" /></div>
							<div class="details_overlay">
								<div class="name-leader">{$model.firstname}.{$model.lastname|substr:0:1}</div>
								<div class="images-link">
									<span style="position: absolute; bottom: 10px;" data-modelid="{$model.id}" class="text-center shareremovebutton bg-blue white hvr hvr-black removeModel">remove?</span>
								</div>
							</div>
						</div>
					</div></a>
				{/foreach}
				{/if}
			</div>
		</div>
	</div>
</div>
<input type="hidden" name="jobid" value="{$job.id}" />
<input type="hidden" name="shareuri" value="{$job.shareuri}" />
{/block}