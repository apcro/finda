<div id="main" class="prod mobilepanel profile-home" style="padding-left: 0;">

	<div class="half">
		<div class="row">
			<div class="column" style="padding-left: 1em; padding-top: 1em;">
			{if $usertype eq 2}
				{if $workflowStep neq 'fromeditsearch'}
				<a href="/search" class="button small">back to talent</a>
				{else}
				&nbsp;
				{/if}
			{else if $usertype eq 1}
				<a href="/user/profile" class="button inverted small">Back to your Profile</a>
			{/if}
			</div>
		</div>

		<div class="row">
			<div class="column text-center">
				<h1>{$model.firstname|capitalize}.{$model.lastname|substr:0:1|capitalize}</h1>
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
			</div>
		</div>
			
		<div class="row">
			<div class="column text-center">
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
			</div>
		</div>
		{if $usertype eq 2}
		<div class="row" style="margin-bottom: 2em;">
			<div class="column model_calendar text-center">
				<div class="month_heading">
					<h4>Availability</h4>
				</div>
				<div class="days_holder">
					{foreach from=$calendar item=day}
					<div class="calendar_day {$day.state}" data-balloon="{if $day.state eq 'busy'}Busy{else if $day.available eq 1}Available for Last Minute Bookings{else}Free{/if}" data-balloon-pos="up">
						<div class="calendar_date">
							{if $day.month neq $thismonth && $day.day eq 1}
							{$day.month}
							{/if}
							<span style="font-size: 75%;">{$day.dayname}</span>
							<span style="float: right;">{$day.day}</span>
							{if $day.available eq 1}
							<div class="available_check">
								<i class="fas fa-check"></i>
							</div>
							{/if}
							{if $day.state eq 'busy'}
							<div class="available_check">
								<i class="fas fa-times"></i>
							</div>
							{/if}
						</div>
					</div>
					{/foreach}
				</div>
			</div>
		</div>
		{/if}
		<div class="row" style="margin-bottom: 1em;">
			<div class="column text-center">
				<a href="compcard" class="compcard"><i class="fas fa-download"></i> Download Portfolio</a>
			</div>
		</div>
		{if $usertype eq 2}
		<div class="row">
			<div class="column text-center">
				<div class="model-favourite" data-id="{$model.sefu}"><i class="fa{if $model.clientfavourite}s{else}r{/if} fa-heart"></i> {if $model.clientfavourite}Remove from {else}Add to {/if} favourites</div>
			</div>
		</div>
		{/if}
		{if $usertype eq 2}
		<div class="row">
			<div class="column text-center">
				<div class="modelbooking" style="text-align: center;">
					{if $workflowStep neq '' && $workflowStep neq 'fromeditsearch'}
					{if $job_status neq 1}
					<a href="" class="button burgundy desktop requestModel" style="margin-top: 1em;" data-jobid="{$workflowData.id}">Shortlist for Project?</a>
					{/if}
					{else}
					{if $job_status neq 10}
					<a href="" style="margin-top: 1em;" {if $workflowStep neq 'fromeditsearch'}data-open="joboffers" {/if}class="button burgundy desktop optionModel">Shortlist for Project</a>
					{/if}
					{/if}
				</div>
				
			</div>
		</div>
		{/if}
	</div>

	<div class="half">
		<div class="image" data-imagesrc="{$smarty.const.CDN_ROOT}/{$model.imagetype}/large{$model.leadimage}" style="width: 100%: height: 100%;"></div>
		<div class="loadfader">
			<div class="reverse-spinner"></div>
		</div>
		{if $workflowStep neq ''}
		{if $model.model_desired_rate neq 0 && $model.job_status eq 1}<div class="project_ribbon">Negotiating rate for<br />{$workflowData.name}</div>
		{else}
		{if $job_status eq 9}<div class="project_ribbon">shortlisted for<br />{$workflowData.name}</div>
		{else if $job_status eq 10}<div class="project_ribbon">Shortlisted for<br />{$workflowData.name}</div>
		{else if $job_status eq 12}<div class="project_ribbon">Declined<br />{$workflowData.name}</div>
		{else if $job_status eq 14}<div class="project_ribbon">Accepted<br />{$workflowData.name}</div>
		{else if $job_status eq 2}<div class="project_ribbon">Confirmed<br />{$workflowData.name}</div>
		{else if $job_status eq 1}<div class="project_ribbon">Requested<br />{$workflowData.name}</div>
		{/if}
		{/if}
		{/if}
		
		<div class="imagebuttons">
			<div class="row">
				<div class="column text-center">
					<a href="/view/{$model.sefu}/portfolio" class="button photolink portfolio">PORTFOLIO</a>
				</div>
				<div class="column text-center">
					<a href="/view/{$model.sefu}/polaroids" class="button photolink polaroids">POLAROIDS</a>
				</div>
			</div>
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
