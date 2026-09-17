<div data-href="/view/{$model.sefu}" class="modelcard candrag" id="modeldrag-{$model.id}">
	{if $job.projectbookingtype eq 'booking'}<div class="detailsoverlay-removemodel text-center" data-modelid="{$model.id}" data-balloon="Remove?" data-balloon-pos="left"><i class="fas fa-times align-right text-white"></i></div>{/if}
	<div class="searchmodelimage model-{$model.id}">
		<div class="modelView">
			<div class="image" data-imagesrc="{if $model.filename}{$CDN_ROOT}/{$model.imagetype}/large{$model.filename}{else}{$default_avatar}{/if}">
				<div class="loadfader">
					<img class="loader" src="/images/loading-icon.gif" />
				</div>
				<div class="notesbutton{if $model.client_notes neq ''} withnotes{/if}">
					<span class="notespan" data-modelid="{$model.id}" data-balloon="Write a note about {$model.firstname}" data-balloon-pos="up"><i class="fas fa-edit"></i></span>{if $model.job_status eq 1 || $model.job_status eq 2 || $model.job_status eq 14}<a class="model-chat" href="/messages/{$model.sefu}/{$job.id}" data-balloon="Send a message to {$model.firstname}" data-balloon-pos="up"><i class="fa fa-comment-dots"></i></a>{/if}
				</div>
			</div>
			{if $model.job_status neq 0}
			<div class="statusribbon">
				<div class="button small {if $model.model_desired_rate neq 0 && $model.job_status eq 1 && $model.agreed_rate eq 0}negotiated negotiatebutton" data-modelid="{$model.id}" data-jobid="{$job.id}" data-modelname="{$model.firstname}" data-desiredrate="{$model.model_desired_rate}" data-offeredrate="{$model.client_offered_rate}">Negotiate?</div>
				{else}
				{if $model.job_status eq 1}offered disabled">{if $job.bookingtype eq 'casting'}Invited{else}Requested{/if}</div>
				{elseif $model.job_status eq 2}confirmed disabled">{if $job.bookingtype eq 'casting'}Attending{else}Confirmed{/if}</div>
				{elseif $model.job_status eq 3}cancelled disabled">Cancelled</div>
				{elseif $model.job_status eq 10 || $model.job_status eq 15}inverted optioned offerbutton" data-modelid="{$model.id}" data-jobid="{$job.id}" data-modelname="{$model.firstname}">{if $job.bookingtype eq 'casting'}Invite to casting?{else}Request?{/if}</div>
				{elseif $model.job_status eq 12}declined disabled">Declined</div>
				{elseif $model.job_status eq 14}accepted confirmbutton" data-modelid="{$model.id}" data-jobid="{$job.id}" data-modelname="{$model.firstname}">Confirm?</div>
				{elseif $model.job_status eq 7}">Completed</div>
				
				{else}">{/if}
				{/if}
			</div>
			{/if}
			<div class="name-leader">
				<div class="nameleader-name">{$model.firstname}.{$model.lastname|substr:0:1}</div>
				<div class="model-favourite" data-id="{$model.sefu}"><i class="fa{if $model.clientfavourite}s{else}r{/if} fa-heart"></i></div>
				<p class="nameleader-insta"><i class="fab fa-instagram"></i>&nbsp;{$model.instagram_username}</p>
			</div>
		</div>
	</div>
</div>

<div class="notesholder-{$model.id}" style="display: none;">
	<div class="row">
		<div class="column">
			<h2>Notes about {$model.firstname}</h2>
			<div class="notesform">
				<label for="modelnotes">These notes are for this booking only and can only be seen by your company.</label>
				<hr>
				<textarea name="modelnotes" class="modelnotes modelnotes-{$model.id}" rows=5>{$model.client_notes}</textarea>
				<a class="button small burgundy savenotes" data-modelid="{$model.id}">Save</a>
			</div>
		</div>
	</div>
</div>