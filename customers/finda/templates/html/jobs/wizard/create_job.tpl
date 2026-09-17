{extends "user/layout.tpl"}

{block name="main"}
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

<form action="/projects/wizardcreate" method="post" id="createjob-form">
	<div class="wizard-container">
	
		{*
		<div class="wizard-step" style="display: none">
			<h2>Choose a name for your project</h2>
			<p><em>This can be anything, but will be the first thing models see.</em></p>
			<div class="row">
				<div class="column">
					<label for="name">Project Name</label>
					<input type="text" id="name" name="name input" placeholder="Project Name">
				</div>
				<div class="column">
				</div>
			</div>
		</div>
		*}
		
		<div class="wizard-step">
			<h2>Choose a project type</h2>
			<p><em>What type of project are you booking for?</em></p>
			<div class="row">
				<div class="column">
					<label for="jobtype">Type of Project</label>
					<div class="select-wrap">
						<select name="jobtype input" id="jobtype" class="select">
							<option disabled="disabled" selected="selected" value="0">Please select</option>
							{foreach from=$jobtypes item=type name=type key=k}
							<option value="{$k}" data-hourly="{$type.hourly}" data-daily="{$type.daily}">{$type.name}</option>
							{/foreach}
						</select>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="column">
					<ul>
						<li>Depending on the type models may be expecting different rates</li>
					</ul>
				</div>
			</div>
		</div>

		<div class="wizard-step projectnormal skipusage">
			<h2>Specify your desired usage rights</h2>
			<p><em>As a standard, usage rights for each booking through IDAL covers 12 months across up to three selected media.</em></p>
			<div class="row">
				<div class="column">
					<div class="triplet-checkbox rights">
						<label for="standardrights" class="active">Standard</label>
						<input type="radio" id="standardrights" name="baseusage" value="standard" checked="checked" />
						<label for="extrarights">Additional usage</label>
						<input type="radio" id="extrarights" name="baseusage" value="custom" />
					</div>
					<div class="rights-checkboxes">
						<div class="row">
							<div class="column">UK</div>
							<div class="column text-right">
								<input class="tgl tgl-slider" id="ukrights" type="checkbox" name="ukrights" checked="checked"/>
								<label class="tgl-btn" for="ukrights"></label>	
							</div>
						</div>
						<div class="rights-holder">
							<div class="row">
								<div class="column">Europe (including UK)</div>
								<div class="column text-right">
									<input class="tgl tgl-slider" id="eurights" type="checkbox" name="eurights" />
									<label class="tgl-btn" for="eurights"></label>	
								</div>
							</div>
							<div class="row">
								<div class="column">International</div>
								<div class="column text-right">
									<input class="tgl tgl-slider" id="intrights" type="checkbox" name="intrights" />
									<label class="tgl-btn" for="intrights"></label>	
								</div>
							</div>
						</div>

						<hr />
						<div class="base-rights-holder">
							{foreach from=$usagerights item=usage}
							<div class="row">
								<div class="column">{$usage.name}</div>
								<div class="column text-right">
									<input class="tgl tgl-slider" id="usageright-{$usage.tid}" type="checkbox" name="usagerights[]" value="{$usage.tid}" />
									<label class="tgl-btn" for="usageright-{$usage.tid}"></label>
								</div>
							</div>
							{/foreach}
						</div>
					</div>
					<div class="rights-holder">
						<hr />
						<textarea id="extrarightsentry" name="extrarights input" placeholder="Additional usage rights" rows="4"></textarea>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="column">
					<input type="checkbox" class="read-more-state" id="usagerights-more" />
					<ul class="read-more-wrap">
						<li>Please select the media where you’d like to use IDAL models’ images after your project.</li>
						<li>If additional usage rights are needed, click on ‘Additional usage’ and select what is required for your project.</li>
						<li class="read-more-target">Before your booking is confirmed, you will be provided with a Modelling Service Agreement on behalf of a model, where these usage rights will be included.</li>
						<li class="read-more-target">In the future, if you need to purchase additional usage rights, you’ll be able to do so by contacting the model through IDAL. </li>
					</ul>
					<label for="usagerights-more" class="read-more-trigger"></label>
				</div>
			</div>
		</div>
		
		
		<div class="wizard-step">
			<h2>Choose the project date<span class="projectinfluencer"> or set a deadline to post the content</span></h2>
			<div class="row">
				<div class="column">
					<label for="startdate">Start Date<span class="projectinfluencer"> or Posting Deadline</span></label>
					<input type="text" id="startdate" name="startdate input" placeholder="Start Date" class="span2">
				</div>
			</div>
			<div class="row">
				<div class="column">
					<input type="checkbox" class="read-more-state" id="start-more" />
					<ul class="read-more-wrap">
						<li>This will allow you to browse models that are available on your specific dates</li>
						<li class="read-more-target">You can edit the date at a later point, before you confirm the project with a model.</li>
						<li class="read-more-target">The project duration will be specified later in the following steps.</li>
					</ul>
					<label for="start-more" class="read-more-trigger"></label>
				</div>
			</div>
		</div>

		<div class="wizard-step">
			<h2 class="projectnormal">How many models do you need?</h2>
			<h2 class="projectinfluencer">How many influencers do you need?</h2>
			<div class="row">
				<div class="column">
					<label for="modelcount" id="modelcountlabel"></label>
					<input type="text" id="modelcount" name="modelcount input" placeholder="Number of Models">
				</div>
			</div>
			<div class="row">
				<div class="column">
					<ul>
						<li>You can change this number later if there are any changes.</li>
					</ul>
				</div>
			</div>
		</div>

		<div class="wizard-step">
			<h2>Choose a duration and rate for your project</h2>
			<p><em>Specify the number of days or hours that you’d like to book models for.</em></p>
			<div class="row">
				<div class="column">
					<div class="triplet-checkbox rate">
						<label for="daily" class="active">Daily</label>
						<input type="radio" id="daily" name="unitstype input" value="day" checked="checked">
						<label for="hourly">Hourly</label>
						<input type="radio" id="hourly" name="unitstype input" value="hour">
						<label for="unpaid">Unpaid</label>
						<input type="radio" id="unpaid" name="unitstype input" value="unpaid">
					</div>
					<div style="margin-top: 2em;">
						<label name="duration-length-label">Number of hours</label>
						<input type="text" id="length" name="length input" placeholder="Duration of Project">
						<p class="minlength_notice"></p>
						<div class="doublet-checkbox notmoney">
							<label for="conhour" class="active">hours</label>
							<input id="conhour" name="unpaidtype input" type="radio" value="hour" checked="checked">
							<label for="conday">days</label>
							<input id="conday" name="unpaidtype input" type="radio" value="day">
						</div>
					</div>
					<div class="triplet-holder">
						<div class="money">
							<label name="duration-label">Daily Rate</label>
							<p style="font-size: 90%; margin: 0.25em 0 0 0;"><em>Excluding VAT and 10% IDAL commission. 1 working day = 5 or more hours.</em></p>
							<input type="text" id="rate" name="rate input" placeholder="Offered Rate" disabled="disabled">
							<p class="minrate_notice"></p>
						</div>
						<div class="notmoney">
							<label for="altrate" id="altratelabel">Consideration</label>
							<input type="text" id="altrate" name="altrate input" placeholder="e.g Product">
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="column">
				<input type="checkbox" class="read-more-state" id="rate-more" />
					<ul class="read-more-wrap">
						<li>Put in a daily or hourly rate for your project, or select 'Unpaid' if you’d like to offer a model an unpaid booking or 'Consideration' such as a product.</li>
						<li class="read-more-target">Please note that the rate selected is a daily or hourly rate and <span class="text-bold">not for the entire project</span>.</li>
						<li class="read-more-target">Depending on the project type and models you wish to request, rate expectations may vary. Please indicate an appropriate rate to ensure more models accept your offer.</li>
						<li class="read-more-target">Models will be able to accept or reject your requests, or negotiate the rate. You may accept or reject their offers.</li>
						<li class="read-more-target">VAT will be added to your invoice once the booking is confirmed.</li>
					</ul>
					<label for="rate-more" class="read-more-trigger"></label>
				</div>
			</div>
		</div>

		<div class="wizard-step projectnormal" style="display: none">
			<h2>Set the call-time</h2>
			<div class="row">
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
							<option value="09:00" selected="selected">09:00</option>
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
			<div class="row">
				<div class="column">
					<ul>
						<li>The models will arrive at this time to your set location on your project start date.</li>
					</ul>
				</div>
			</div>
		</div>


		<div class="wizard-step">
			<h2>State the full address and postcode of your project</h2>
			<div class="row">
				<div class="column">
					<label for="location">Location</label>
					<textarea id="location" name="location input" placeholder="Number/Name, Street, Postcode"></textarea>
					<div class="row projectinfluencer" style="margin-left: 0; margin-right: 0; padding-left: 0; padding-right: 0;">
						<div class="column" style="margin-left: 0; margin-right: 0; padding-left: 0; padding-right: 0;">
							Request model addresses
						</div>
						<div class="column text-right narrow"">
							<input class="tgl tgl-slider" id="model_address" name="model_address" type="checkbox" />
							<label class="tgl-btn" for="model_address"></label>	
						</div>
					</div>
					
				</div>
			</div>
			<div class="row">
				<div class="column">
					<input type="checkbox" class="read-more-state" id="location-more" />
					<ul class="read-more-wrap">
						<li>The address will only be visible to requested models</li>
						<li class="read-more-target">If models need transportation, please indicate this is the description section later.</li>
						<li class="read-more-target">If the location is not confirmed yet, put in the city of the project location and come back later to update.</li>
					</ul>
					<label for="location-more" class="read-more-trigger"></label>
				</div>
			</div>
		</div>
		
			
		<div class="wizard-step">
			<h2>Additional information</h2>
			<p><em>You can leave these blank and edit them later.</em></p>
			<div class="row">
				<div class="column">
					<div class="advanced-checkboxes">
						<div class="row">
							<div class="column">
								<h3 class="projectnormal">Will there be a specific meeting point other than the project location?</h3>
								<h3 class="projectinfluencer">Will there be a specific meeting point?</h3>
								<textarea name="model_meeting_point" class="toggle" placeholder="For example an address for a café, studio, etc."></textarea>
							</div>
							<div class="column text-right narrow">
								<input class="tgl tgl-slider" id="model_meeting_point" name="model_meeting_point_check" type="checkbox" />
								<label class="tgl-btn" for="model_meeting_point"></label>	
							</div>
						</div>
					
						<div class="row">
							<div class="column">
								<h3>Do the models need to bring anything?</h3>
								<textarea name="model_to_bring" class="toggle" placeholder="Specify here: Nude underwear, simple black heels, etc"></textarea>
							</div>
							<div class="column text-right narrow">
								<input class="tgl tgl-slider" id="model_to_bring" name="model_to_bring_check" type="checkbox" />
								<label class="tgl-btn" for="model_to_bring"></label>	
							</div>
						</div>
					
						<div class="row">
							<div class="column">
								<h3>Any specific transport methods?</h3>
								<textarea name="transport_methods" class="toggle" placeholder="Specify here: Train to Oxfordshire Train Station from Victoria with the team, etc"></textarea>
							</div>
							<div class="column text-right narrow">
								<input class="tgl tgl-slider" id="transport_methods" name="transport_methods_check" type="checkbox" />
								<label class="tgl-btn" for="transport_methods"></label>	
							</div>
						</div>
					
						<div class="row">
							<div class="column">
								<h3>Will you expense travel costs?</h3>
								<textarea name="model_expenses" class="toggle" placeholder="Specify here: Train to Oxfordshire will be expensed by us, etc"></textarea>
							</div>
							<div class="column text-right narrow">
								<input class="tgl tgl-slider" id="model_expenses" name="model_expenses_check" type="checkbox" />
								<label class="tgl-btn" for="model_expenses"></label>	
							</div>
						</div>
					
						<div class="row">
							<div class="column">
								<h3>Any additional information about hair or make-up?</h3>
								<textarea name="makeup_provided" class="toggle"></textarea>
							</div>
							<div class="column text-right narrow">
								<input class="tgl tgl-slider" id="makeup_provided" name="makeup_provided_check" type="checkbox" />
								<label class="tgl-btn" for="makeup_provided" placeholder="Specify here: Please arrive with light natural makeup and low ponytail etc"></label>	
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	
	{*
		<div class="wizard-step">
			<h2>Provide a contact number</h2>
			<p class="projectnormal"><em>This phone number will be provided on the day of your project</em></p>
			<div class="row">
				<div class="column">
					<label for="contact_number">Contact number</label>
					<input type="text" id="contact_number" name="contact_number input" placeholder="Contact number">
				</div>
			</div>
			<div class="row">
				<div class="column">
					<ul>
						<li>The number will only be visible to the models after the booking is confirmed.</li>
					</ul>
				</div>
			</div>
		</div>
		*}
		
		{*
		<div class="wizard-step">
			<h2>Add the project description</h2>
			<p><em>Indicate any other details that might be relevant</em></p>
			<div class="row">
				<div class="column">
					<label for="description">Description</label>
					<textarea id="description" name="description input" placeholder="Project Description" rows="5"></textarea>
				</div>
			</div>
			<div class="row">
				<div class="column">
					<ul>
						<li>The more information you provide, the easier it will be for models to understand your project and make a decision.</li>
						<li>This can include specific requests, such as a theme or a purpose of your project or information about your brand.</li>
					</ul>
				</div>
			</div>
		</div>
		*}
		
		
		
		<div class="wizard-step">
			<h2 class="text-center">LET’S SAVE YOUR PROJECT AND FIND A MODEL FOR YOU!</h2>
			<div style="width: 100%; padding: 4em; text-align: center">
				<a class="button white createjob">Save</a>
			</div>
		</div>
	</div>
	<input type="hidden" name="step" value="wizardcreate" />
	<input type="hidden" name="projecttype" value="normal" />
	<input type="hidden" name="daysahead" value="{$smarty.const.IDAL_MINIMUM_DAYS_AHEAD}" />
</form>
<div id="fake-overlay"></div>
{/block}