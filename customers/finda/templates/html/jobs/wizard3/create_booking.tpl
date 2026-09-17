<form action="/projects/wizardcreate" method="post" id="createjob-form">
	<div class="container-header">Select and Book Models</div>
	<div class="wizard-container">

		<div class="wizard-step" style="display: none">
			<div class="row">
				<div class="column">
					<p class="text-center">This booking form will be sent directly to the models.</p>
					<p class="text-center">Please add as much information as possible in each step; this will ensure that your shortlisted model(s) can make a quick decision to your request. You’ll be able to edit this section later if you wish!</p>
					<p class="text-center">For any assistance, contact us on:<br />The IDAL Office<br />Phone: +44 844 357 0556<br />Email: <a href="mailto:support@idal.co">support@idal.co</a></p>
				</div>
			</div>
		</div>
	
		<div class="wizard-step">
			<h2>Project Name</h2>
			<div class="row">
				<div class="column">
					<input type="text" id="name" name="name input" placeholder="Project Name">
				</div>
			</div>
			<h2>Choose a project type</h2>
			<div class="row">
				<div class="column">
					<div class="select-wrap">
						<select name="jobtype input" id="jobtype" class="select">
							<option disabled="disabled" selected="selected">Please select</option>
							{foreach from=$jobtypes item=type name=type key=k}
							{if $k neq 75 && $k neq 78}
							<option value="{$k}" data-hourly="{$type.hourly}" data-daily="{$type.daily}">{$type.name}</option>
							{/if}
							{/foreach}
						</select>
					</div>
				</div>
			</div>
			
		</div>
		
		<div class="wizard-step">
			<div class="projectnormal skipusage">
				<h2>Specify your desired usage rights</h2>
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
				<p class="skipusage"><em>As a standard, usage rights for each booking through IDAL covers 6 months across up to three selected media.</em></p>
			</div>
			<div class="skipusagerow">
				<div class="column">
					<p><em>There are no usage rights associated with this type of job, please go to the next step.</em></p>
				</div>
			</div>
		</div>
		
		<div class="wizard-step">
			<h2>How many models do you need?</h2>
			<div class="row">
				<div class="column">
					<input type="text" id="modelcount" name="modelcount input" placeholder="Number of Models">
				</div>
			</div>
			<h2>And for how long?</h2>
			<div class="row">
				<div class="column">
					<div class="select-wrap">
						<select name="length input" id="length" class="select">
							<option disabled="disabled" selected="selected">Please select</option>
							<option value=".5" >Half day</option>
							<option value="1" >1 day</option>
							<option value="2" >2 days</option>
							<option value="3" >3 days</option>
							<option value="4" >4 days</option>
							<option value="5" >5 days</option>
							<option value="6" >6 days</option>
							<option value="7" >7 days</option>
							<option value="8" >8 days</option>
							<option value="9" >9 days</option>
							<option value="10" >10 days</option>
							<option value="11" >11 days</option>
							<option value="12" >12 days</option>
							<option value="13" >13 days</option>
							<option value="14" >14 days</option>
							<option value="15" >15 days</option>
						</select>
					</div>
				</div>
			</div>
		</div>

		<div class="wizard-step">
			<h2>Please enter your per-model rate for the whole project</h2>
			<div class="chooseprojecttypenotice">
				You must select a project type before setting a rate
			</div>
			<div class="chooseprojectdurationnotice">
				You must choose a project duration before setting a rate
			</div>
			<div class="chooseprojectmodelcountnotice">
				You must choose the number of models you need before setting a rate
			</div>
			<div class="row rateinfo">
				<div class="column text-left" style="width: 100%;">
					<span>Per-model fee for <span class="joblength"></span>:</span> <input type="text" id="modelsubtotal" name="modelsubtotal" /> <span style="font-size: 80%"></span>
					<p class="minrate_notice"></p>
				</div>
			</div>
			<div class="row rateinfo">
				<div class="column text-left" style="width: 100%;">
					<span><b>Total fee<span id="modelcounttotal"> for </span> <span class="joblength"> for </span>:</b></span> <input type="text" id="ratesubtotal" disabled="disabled" />
					<br /><span style="font-size: 80%; text-align: center; width: 100%; dipslay: inline-block;">Including 10% IDAL fee and 20% VAT</span>
				</div>
			</div>
		</div>

		<div class="wizard-step">
			<h2>Project date</h2>
			<div class="row">
				<div class="column">
					<input type="text" id="startdate" name="startdate input" placeholder="Start Date" class="span2">
				</div>
			</div>
			<h2>Set the call-time</h2>
			<div class="row">
				<div class="column">
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
		</div>


		<div class="wizard-step">
			<h2>Project Address</h2>
			<p>Please include the full address of where the booking will take place.</p>
			<div class="row">
				<div class="column">
					<textarea id="location" name="location input" placeholder="Number/Name, Street, Postcode" rows="8"></textarea>
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

		</div>
		
			
		<div class="wizard-step">
			<h2>Additional information</h2>
			<div class="row">
				<div class="column">
					<div class="advanced-checkboxes">
						<div class="row">
							<div class="column">
								<h3 >Will there be a specific meeting point other than the project location?</h3>
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
								<h3>Any specific transport methods to location?</h3>
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
			<p><em>You can leave these blank and edit them later.</em></p>
		</div>
	
		<div class="wizard-step">
			<h2>Provide a contact number</h2>
			<div class="row">
				<div class="column">
					<input type="text" id="contact_number" name="contact_number input" placeholder="Contact number">
				</div>
			</div>
			<p class="projectnormal"><em>This phone number will be provided on the day of your project</em></p>
		</div>
		
		<div class="wizard-step">
			<h2>Add the project description</h2>
			<div class="row">
				<div class="column">
					<textarea id="description" name="description input" placeholder="Project Description" rows="5"></textarea>
				</div>
			</div>
			<p><em>Indicate any other details that might be relevant</em></p>
		</div>
		
		
		
		<div class="wizard-step">
			<h2 class="text-center">Save your project and <span class="modelcountgrammar">find models</span></h2>
			<div style="width: 100%; padding: 4em; text-align: center">
				<a class="button burgundy createjob">Shortlist Models</a>
			</div>
		</div>
	</div>
	<input type="hidden" name="step" value="wizardcreate" />
	<input type="hidden" name="projecttype" value="normal" />
	<input type="hidden" name="bookingtype" value="booking" />
	<input type="hidden" name="daysahead" value="{$smarty.const.IDAL_MINIMUM_DAYS_AHEAD}" />
	<p class="form-footer-note">* You can edit the project once created</p>
</form>
