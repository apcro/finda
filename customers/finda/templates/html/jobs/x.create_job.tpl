{extends "user/layout.tpl"}

{block name="main"}
{*
<div class="beta_notice desktop">
	<p class="text-blue">Dear {$firstname}, thank you so much for using our BETA platform! Please note we are working hard to develop a very new, transparent and easy way to book models FOR YOU. If you are struggling with any feature of our platform, need some help or simply want to comment on our processes - please call us at 0844 357 0556 or email us at hello@idal.co</p>
</div>
*}
<div class="row row-heading">
	<div class="column">
		<h2 class="text-black">Create a new Project</h2>
	</div>
</div>
<div class="row mobile">
	<div class="column">
		<p class="notice">Please use your desktop or laptop to enjoy all our features. The IDAL app is coming soon!</p>
	</div>
</div>

<form action="/projects/create" method="post" id="createjob-form">
	<div id="createjob">
		<div class="row">
			<div class="column">
				<label for="name">Project Name</label>
				<input type="text" id="name" name="name input" placeholder="Project Name">
			</div>
		</div>
		<div class="row">
			<div class="column">
				<label for="description">Description</label>
				<textarea id="description" name="description input" placeholder="Project Description" rows="5"></textarea>
			</div>
		</div>
		<div class="row">
			<div class="column">
				<label for="location">Location</label>
				<textarea id="location" name="location input" placeholder="Project location"></textarea>
			</div>
		</div>
		<div class="row">
			<div class="column profile">
				<label for="jobtype">Type of Project</label>
				<div class="select-wrap">
					<select name="jobtype input" id="jobtype" class="select">
						{foreach from=$jobtypes item=type name=type key=k}
						<option value="{$k}">{$type.name}</option>
						{/foreach}
					</select>
				</div>
			</div>
	
			<div class="column">
				<label for="length">Duration</label>
				<input type="text" id="length" name="length input" placeholder="Duration of Project">
			</div>
			<div class="column profile">
				<label>in</label>
				<div class="select-wrap">
					<select name="unitstype input" id="unitstype" class="select">
						<option value="day">Days</option>
						<option value="hour">Hours</option>
					</select>
				</div>
			</div>
		</div>
		<div class="row">
			<div class="column">
				<div class="row" style="padding: 0; margin: 0;">
					<div class="column" style="padding: 0; margin: 0;">
    					<label for="rate" id="ratelabel">Rate per Day</label>
    					<input type="text" id="rate" name="rate input" placeholder="Offered Rate">
					</div>
					<div class="column">
    					<label for="ratealt">or Consideration</label>
    					<input type="text" id="altrate" name="altrate input" placeholder="e.g. Product">
					</div>
				</div>
			</div>
			<div class="column">
				<label for="modelcount" id="modelcountlabel">Number of Models</label>
				<input type="text" id="modelcount" name="modelcount input" placeholder="Number of Models">
			</div>
		</div>
	
		<div class="row">
			<div class="column">
				<label for="startdate">Start Date</label>
				<input type="text" id="startdate" name="startdate input" placeholder="Start Date" class="span2">
			</div>
			
			<div class="column">
				<label for="starttime">Start Time</label>
				<div class="select-wrap">
    				<select name="starttime input" id="starttime" class="select">
                        <option value="00:00">00:00</option>
                        <option value="00:30">00:30</option>
                        <option value="01:00">01:00</option>
                        <option value="01:30">01:30</option>
                        <option value="02:00">02:00</option>
                        <option value="02:30">02:30</option>
                        <option value="03:00">03:00</option>
                        <option value="03:30">03:30</option>
                        <option value="04:00">04:00</option>
                        <option value="04:30">04:30</option>
                        <option value="05:00">05:00</option>
                        <option value="05:30">05:30</option>
                        <option value="06:00">06:00</option>
                        <option value="06:30">06:30</option>
                        <option value="07:00">07:00</option>
                        <option value="07:30">07:30</option>
                        <option value="08:00">08:00</option>
                        <option value="08:30">08:30</option>
                        <option value="09:00">09:00</option>
                        <option value="09:30">09:30</option>
                        <option value="10:00">10:00</option>
                        <option value="10:30">10:30</option>
                        <option value="11:00">11:00</option>
                        <option value="11:30">11:30</option>
                        <option value="12:00">12:00</option>
                        <option value="12:30">12:30</option>
                        <option value="13:00">13:00</option>
                        <option value="13:30">13:30</option>
                        <option value="14:00">14:00</option>
                        <option value="14:30">14:30</option>
                        <option value="15:00">15:00</option>
                        <option value="15:30">15:30</option>
                        <option value="16:00">16:00</option>
                        <option value="16:30">16:30</option>
                        <option value="17:00">17:00</option>
                        <option value="17:30">17:30</option>
                        <option value="18:00">18:00</option>
                        <option value="18:30">18:30</option>
                        <option value="19:00">19:00</option>
                        <option value="19:30">19:30</option>
                        <option value="20:00">20:00</option>
                        <option value="20:30">20:30</option>
                        <option value="21:00">21:00</option>
                        <option value="21:30">21:30</option>
                        <option value="22:00">22:00</option>
                        <option value="22:30">22:30</option>
                        <option value="23:00">23:00</option>
                        <option value="23:30">23:30</option>
    				</select>
    			</div>
			</div>
			
		</div>
		<div class="row buttonrow">
{*
			<div class="column text-center">
				<a class="button bg-grey black hvr hvr-black-textwhite" href="/projects">Cancel</a>
			</div>
			<div class="column text-center">
				<button class="button bg-black white hvr hvr-blue" type="submit" value="option" name="step">Create & Option</button>
			</div> *}
			<div class="column text-right">
				<a class="button bg-black white hvr hvr-blue createjob">Create</a>
				
			</div>
		</div>
		<input type="hidden" name="step" value="create" />
		<input type="hidden" name="daysahead" value="{$smarty.const.IDAL_MINIMUM_DAYS_AHEAD}" />
	</div>
</form>
{/block}