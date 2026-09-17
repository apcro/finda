<form action="/projects/wizardcreate" method="post" id="createjob-form">
	<div class="container-header">Social Media Influencer Bookings</div>
	<div class="wizard-container">
		

		{* slide 1 *}
		
		<div class="wizard-step" style="display: none">
			<h2>Project Name</h2>
			<div class="row">
				<div class="column">
					<input type="text" id="name" name="name input" placeholder="Project Name">
				</div>
			</div>
			<h2>Choose a casting type<span class="infoballoon" data-balloon-length="medium" data-balloon="Casting: You would like to see models for a specific project. Go & See: You would like to see models for future potential projects" data-balloon-pos="up"><span class="infoicon">?</span>{* <img src="/images/info_icon.png" /> *}</span></h2>
			<div class="row">
				<div class="column">
					<div class="select-wrap">
						<select name="jobtype input" id="jobtype" class="select">
							<option disabled="disabled" selected="selected">Please select</option>
							<option value="12" data-hourly="0" data-daily="0">Social Media - Influencer Content</option>
							<option value="74" data-hourly="0" data-daily="0">Social Media - Shoot</option>
						</select>
					</div>
				</div>
			</div>
			
		</div>
		
		{* slide 2 *}
				<div class="wizard-step">
			<h2>How many influencers do you need?</h2>
			<div class="row">
				<div class="column">
					<input type="text" id="modelcount" name="modelcount input" placeholder="Number of Models">
				</div>
			</div>
		</div>
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		<div class="wizard-step">
			<h2>Casting date</h2>
			<div class="row">
				<div class="column">
					<input type="text" id="startdate" name="startdate input" placeholder="Start Date" class="span2">
				</div>
			</div>
			<h2>Set the time and length of casting period</h2>
			<div class="row">
				<div class="column" style="margin-right: 0.5em;">
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
				<div class="column" style="margin-left: 0.5em;">
					<input type="text" id="length" name="length input" placeholder="Number of hours">
					<input type="hidden" id="hourly" name="unitstype input" value="hour">
				</div>
			</div>
		</div>
		
		{* slide 3 *}
		{* currently not used *}
		
		{* slide 4 *}
		<div class="wizard-step">
			<h2>Casting Address</h2>
			<div class="row">
				<div class="column">
					<textarea id="location" name="location input" placeholder="Number/Name, Street, Postcode"></textarea>
				</div>
			</div>
			<h2>Contact details</h2>
			<div class="row">
				<div class="column" style="margin-right: 0.5em;">
					<input type="text" id="contact_name" name="contact_name input" placeholder="Contact name">
				</div>
				<div class="column" style="margin-left: 0.5em;">
					<input type="text" id="contact_number" name="contact_number input" placeholder="Contact number">
				</div>
			</div>
		</div>
		
		{* slide 5 *}
		<div class="wizard-step">
			<h2>Additional information</h2>
			<div class="row">
				<div class="column">
					<div class="advanced-checkboxes">
					
						<div class="row">
							<div class="column">
								<h3>Do models need to bring composite cards?</h3>
							</div>
							<div class="column text-right narrow">
								<input class="tgl tgl-slider" id="model_to_bring" name="model_to_bring_check" type="checkbox" />
								<label class="tgl-btn" for="model_to_bring"></label>	
							</div>
						</div>
					
						<div class="row">
							<div class="column">
								<h3>Do models need to present their digital portfolio on a tablet/smartphone?</h3>
							</div>
							<div class="column text-right narrow">
								<input class="tgl tgl-slider" id="transport_methods" name="transport_methods_check" type="checkbox" />
								<label class="tgl-btn" for="transport_methods"></label>	
							</div>
						</div>
					
						<div class="row">
							<div class="column">
								<h3>Any specific details about hair or make-up?</h3>
								<textarea name="makeup_provided" class="toggle"></textarea>
							</div>
							<div class="column text-right narrow">
								<input class="tgl tgl-slider" id="makeup_provided" name="makeup_provided_check" type="checkbox" />
								<label class="tgl-btn" for="makeup_provided" placeholder="Specify here: Please arrive with light natural makeup and low ponytail etc"></label>	
							</div>
						</div>

						<div class="row">
							<div class="column">
								<h3>Do they need to bring any specific footwear?</h3>
								<textarea name="model_expenses" class="toggle" placeholder="Specify here: type of footwear"></textarea>
							</div>
							<div class="column text-right narrow">
								<input class="tgl tgl-slider" id="model_expenses" name="model_expenses_check" type="checkbox" />
								<label class="tgl-btn" for="model_expenses"></label>	
							</div>
						</div>
						
					</div>
				</div>
			</div>
			<p><em>You can leave these blank and edit them later.</em></p>
		</div>
		
		{* slide 6 *}
		<div class="wizard-step">
			<h2>Details about the project you are casting for:</h2>
			<div class="row">
				<div class="column">
					<textarea id="description" name="description input" placeholder="Casting details" rows="5"></textarea>
				</div>
			</div>
		</div>
		
		{* final slide *}
		<div class="wizard-step">
			<h2 class="text-center">LET’S SAVE YOUR CASTING AND FIND MODELS FOR YOU!</h2>
			<div style="width: 100%; padding: 4em; text-align: center">
				<a class="button burgundy createjob">select models</a>
			</div>
		</div>
		
	</div>

	{* this is a casting - no limit on models *}
	<input type="hidden" id="modelcount" name="modelcount input" value="9999">
		
	<input type="hidden" name="step" value="wizardcreate" />
	<input type="hidden" name="projecttype" value="normal" />
	<input type="hidden" name="bookingtype" value="casting" />
	<input type="hidden" name="daysahead" value="{$smarty.const.IDAL_MINIMUM_DAYS_AHEAD}" />
	<p class="form-footer-note">* You can edit the casting once created</p>
</form>
