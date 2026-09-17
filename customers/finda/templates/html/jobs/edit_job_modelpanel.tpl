<div class="row changedbutton">
	<div class="column" style="width: 100%">
		<div class="notice">
			<div class="text-center">
				<div class="confirmchanges button bg-black white hvr hvr-blue" style="margin-right: 4em;">Confirm changes</div>
				<div class="button bg-black white hvr hvr-blue cancelchanges" href="/projects/edit/{$job.id}#models">Cancel changes</div>
			</div>
		</div>
	</div>
</div>
<div class="changed_banner">Please confirm your changes &nbsp;&nbsp;<i class="fas fa-chevron-up"></i></div>
{*
<div class="row">
	<div class="column">
		<h3>Selected for review</h3>
	</div>
</div>
*}
<div class="row">
	<div class="column">
		<div class="text-bold">
			<ul>
				<li>You can option as many models as you like to see if they want to work on your project.</li>
				<li>Once you option your models, they will receive a notification. If it is not a fit they may decline your option.</li>
				<li>To cancel an option simply remove the model from your option board.</li>
				<li>To book a model, offer her a job by clicking on ‘offer job’ or dragging the model card to <em>Offered the job</em>. If she accepts, she will appear in your <em>Confirmed</em> box.</li>
			</ul>
		</div>
	</div>
</div>
<div class="row">
	<div class="column text-center">
		<a class="searchbutton button bg-blue white hvr hvr-black modelSearchButton">Option models</a>
	</div>	
</div>
{*
<div class="row">
	<div class="column modelcards">
		<div class="selected modelcards">
			{if $selected}
			{foreach from=$selected item=model name=model}
				<a href="/view/{$model.sefu}" class="modelcard candrag" id="modeldrag-{$model.id}"><div class="searchmodelimage model-{$model.id}">
					<div class="modelView">
						<div class="image"><img src="{$CDN_ROOT}/{$model.imagetype}/large{$model.filename}" /></div>
						<div class="details_overlay">
							<div class="name-leader">
								{if $model.job_status eq 11}<i class="text-pink fas fa-star align-right"></i>{/if}
								{$model.firstname}.{$model.lastname|substr:0:1}
								<div class="detailsoverlay-removemodel" data-modelid="{$model.id}"><i class="fas fa-times align-right text-white"></i></div>
								<div class="model-favourite-2" data-id="{$model.sefu}"><i class="fa{if $model.clientfavourite}s{else}r{/if} fa-heart align-right"></i></div>
							</div>
							<div class="images-link">
								<span style="position: absolute; bottom: 10px;" data-modelid="{$model.id}" class="text-center button bg-purple white hvr hvr-black optionModel">option</span>
							</div>
							{if $model.instagram_followers neq 0}
							<div class="instagram-details">
								<img src="/images/instagram_white.png" width="16px" height="16px" /> {$model.instagram_followers}
							</div>{/if}
						</div>
					</div>
				</div></a>
			{/foreach}
			{/if}
		</div>
	</div>
</div>
*}
<div class="row">
	<div class="dragtext"><i class="fas fa-angle-double-right"></i><i class="fas fa-angle-double-right"></i><br />Click or drag to offer optioned model a job<br /><i class="fas fa-angle-double-right"></i><i class="fas fa-angle-double-right"></i>{* <br /><br /><br /><br /><i class="fas fa-angle-double-left"></i><i class="fas fa-angle-double-left"></i><br />Click or drag to cancel offer<br /><i class="fas fa-angle-double-left"></i><i class="fas fa-angle-double-left"></i> *}</div>
	<div class="column half">
		<div class="column modelcards">
			<div class="dotted-container">
				<h4>Optioned for project</h4>
				<div class="optioned modelcards container">
					{if $optioned}
					{foreach from=$optioned item=model name=model}
						<a href="/view/{$model.sefu}" class="modelcard candrag" id="modeldrag-{$model.id}"><div class="searchmodelimage model-{$model.id}">
							<div class="modelView">
								<div class="image"{if $model.job_status == 12} style="opacity: 0.4;"{/if}><img src="{$CDN_ROOT}/{$model.imagetype}/large{$model.filename}" /></div>
								{if $model.job_status eq 12}<div class="declined_option">Model declined your option</div>{/if}
								{if $model.job_status eq 14}<div class="accepted_option">Model accepted your option</div>{/if}
								<div class="details_overlay">
									<div class="name-leader">{if $model.job_status eq 15}<i class="text-findagreen fas fa-check align-right"></i>&nbsp;{/if}{if $model.job_status eq 12}<i class="text-white fas fa-times align-right"></i>&nbsp;{/if}{$model.firstname}.{$model.lastname|substr:0:1}
										<div class="detailsoverlay-removemodel text-center" data-modelid="{$model.id}" data-balloon="remove?" data-balloon-pos="left"><i class="fas fa-times align-right text-white"></i></div>
										<div class="model-favourite" data-id="{$model.sefu}"><i class="fa{if $model.clientfavourite}s{else}r{/if} fa-heart align-right"></i></div>
									</div>
									<div class="images-link">
										<span style="position: absolute; bottom: 10px;" data-modelid="{$model.id}" class="text-center button bg-purple white hvr hvr-black requestModel">offer job</span>
									</div>
									{if $model.instagram_followers neq 0}
									<div class="instagram-details">
										<img src="/images/instagram_white.png" width="16px" height="16px" /> {$model.instagram_followers}
									</div>{/if}
								</div>
							</div>
						</div></a>
					{/foreach}
					{/if}
				</div>
			</div>
		</div>
		
	</div>
	<div class="column half">
		<div class="column modelcards">
			<div class="dotted-container unconfirmed">
				<h4>Offered the job</h4>
				<div class="unconfirmed modelcards container droppable">
					{if $unconfirmed}
					{foreach from=$unconfirmed item=model name=model}
						<a href="/view/{$model.sefu}" class="modelcard candrag" id="modeldrag-{$model.id}"><div class="searchmodelimage model-{$model.id}">
							<div class="modelView">
								<div class="image"><img src="{$CDN_ROOT}/{$model.imagetype}/large{$model.filename}" /></div>
								<div class="details_overlay">
									<div class="name-leader">{$model.firstname}.{$model.lastname|substr:0:1}
										<div class="detailsoverlay-removemodel text-center" data-modelid="{$model.id}" data-balloon="Cancel" data-balloon-pos="left"><i class="fas fa-times align-right text-white"></i></div>
										<div class="model-favourite" data-id="{$model.sefu}"><i class="material-icons align-right">favorite_{if $model.clientfavourite}filled{else}border{/if}</i></div>
									</div>
									<div class="images-link">
										<span style="position: absolute; bottom: 10px;" data-modelid="{$model.id}" class="text-center button bg-purple white hvr hvr-black removeModel">cancel</span>
									</div>
									{if $model.instagram_followers neq 0}
									<div class="instagram-details">
										<img src="/images/instagram_white.png" width="16px" height="16px" /> {$model.instagram_followers}
									</div>{/if}
								</div>
							</div>
						</div></a>
					{/foreach}
					{/if}
				</div>
			</div>
		</div>
	</div>
</div>
{*
<div class="row">
	<div class="column text-center">
		<a class="sharebutton button bg-blue white hvr hvr-black">Share option board&nbsp;&nbsp;<i class="fas fa-share-alt"></i></a>
	</div>
</div>
*}
<div class="row">
	<div class="column">
		<div class="dotted-container">
			<h4>Confirmed</h4>
			<ul style="margin-top: 0;">
				<li>Below are your confirmed models. No action is needed.</li>
				<li>If you need to cancel your booking please do so at least 48 hours in advance. (<a href="/terms">Our cancellation policy</a>)</li>
			</ul>
			<div class="confirmed modelcards container">
				{if $confirmed}
				{foreach from=$confirmed item=model name=model}
				<a href="/view/{$model.sefu}" class="modelcard" id="confirmed-{$model.id}"><div class="searchmodelimage model-{$model.id}">
					<div class="modelView">
						<div class="image"><img src="{$CDN_ROOT}/{$model.imagetype}/large{$model.filename}" /></div>
						<div class="details_overlay">
							<div class="name-leader">{$model.firstname}.{$model.lastname|substr:0:1}
								<div class="detailsoverlay-removemodel text-center removeModel" data-modelid="{$model.id}" data-balloon="Cancel" data-balloon-pos="left"><i class="fas fa-times align-right text-white"></i></div>
								<div class="model-favourite" data-id="{$model.sefu}"><i class="material-icons align-right">favorite_{if $model.clientfavourite}filled{else}border{/if}</i></div>
							</div>
							<div class="images-link">
								<span data-modelid="{$model.id}" class="text-center button bg-purple white hvr hvr-black removeConfirmedModel">cancel</span>
							</div>
							{if $model.instagram_followers neq 0}
							<div class="instagram-details">
								<img src="/images/instagram_white.png" width="16px" height="16px" /> {$model.instagram_followers}
							</div>{/if}
						</div>
					</div>
				</div></a>
				{/foreach}
				{/if}
			</div>
		</div>
	</div>
</div>