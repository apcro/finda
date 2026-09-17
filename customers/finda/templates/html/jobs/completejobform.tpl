<form id="finaliseassignment">
	<div class="row details">
		<div class="column">
			<h2 style="transform-origin: left top; max-width: 80%;">Complete Project - {$job.name}</h2>
			<h3 style="transform-origin: left top;">{$job.jobtype_name} on {$job.startdate|date_format:"%d %B %Y"}</h3>
			<p>Please mark the completion status for the following models:</p>
		</div>
	</div>
	<div class="row row-heading">
		<div class="column" style="max-width: 50px"><p style="width: 50px; flex-grow: 0; display: inline-block;">&nbsp;</p></div>
		<div class="column text-center"><strong>Completed?</strong></div>
		<div class="column text-center"><strong>Notes</strong></div>
		<div class="column text-center"><strong>Rating</strong></div>
	</div>
	{foreach from=$models item=model name=model}
	<div class="row offerrow">
		<div class="column text-center">
			<img src="{if $model.filename}{$smarty.const.CDN_ROOT}/{$model.imagetype}/large{$model.filename}{else}{$default_avatar}{/if}" width="50px" /><br />
			{$model.firstname}<br />{$model.lastname|substr:0:1}
		</div>
		<div class="column">
			<div class="radio mc-field-group input-group">
			<label for="completedyes{$model.id}" class="control control--radio">Yes
				<input type="radio" class="radio" name="completed{$model.id}" value="1" id="completedyes{$model.id}" checked="checked" required>
				<div class="control__indicator"></div>
			</label>
			
			<label for="completedno{$model.id}" class="control control--radio">No
				<input type="radio" class="radio" name="completed{$model.id}" value="0" id="completedno{$model.id}">
				<div class="control__indicator"></div>
			</label>
			</div>
		</div>
		<div class="column">
			<textarea placeholder="None" name="clientnotes{$model.id}"></textarea>
		</div>
		<div class="column">
			<fieldset class="rating">
				<input type="radio" id="star5-{$model.id}" name="rating{$model.id}" value="5" /><label class="full" for="star5-{$model.id}"></label>
				<input type="radio" id="star4-{$model.id}" name="rating{$model.id}" value="4" /><label class="full" for="star4-{$model.id}"></label>
				<input type="radio" id="star3-{$model.id}" name="rating{$model.id}" value="3" /><label class="full" for="star3-{$model.id}"></label>
				<input type="radio" id="star2-{$model.id}" name="rating{$model.id}" value="2" /><label class="full" for="star2-{$model.id}"></label>
				<input type="radio" id="star1-{$model.id}" name="rating{$model.id}" value="1" /><label class="full" for="star1-{$model.id}"></label>
			</fieldset>


		</div>
	</div>
	{/foreach}
	<input type="hidden" name="jobid" value="{$jobid}" />
	<div class="row">
		<div class="column">
			<button type="submit" name="submit" value="Finalise" class="button burgundy finaliseassignment">Complete</button>
		</div>
	</div>
</form>