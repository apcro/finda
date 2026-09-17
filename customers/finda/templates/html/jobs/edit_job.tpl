{extends "user/layout_wide.tpl"}

{block name="main"}
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
<form action="/projects/edit/{$jobid}" method="post" id="projectdetails" style="margin-top: 2em;">
	<div class="row">
		<div class="column" style="margin-left: 0; padding-left: 0;">
			{if $companyid neq 0 && $job.projectbookingtype neq 'direct'}<span style="float: right; display: inline;"><a href="/createtemplate" data-open="createtemplate">+ Create template from this project</a></span>{/if}
			<h2 class="projecttypename">{if $job.job_status eq 0}PENDING{else if $job.job_status  eq 1}CLOSED{/if} | <span class="text-burgundy jobtype_header">{$job.jobtype_name}</span></h2>
			<h1 class="projectname"><input type="text" id="name" name="name input" placeholder="Enter Project Name Here" value="{$job.name}"></h1>
		</div>
	</div>
	<section class="worko-tabs searchpage">
			<input class="tabstate" type="radio" title="Details" name="tabs-state" id="tab-details" checked />
			<input class="tabstate" type="radio" title="Additional" name="tabs-state" id="tab-additional"/>
			{if $jobtype eq 'booking'}
			<input class="tabstate" type="radio" title="Rights" name="tabs-state" id="tab-rights" />
			{/if}
			<input class="tabstate" type="radio" title="Models" name="tabs-state" id="tab-models" />
			<input class="tabstate" type="radio" title="Share" name="tabs-state" id="tab-sharecode" />
		<div class="tabs flex-tabs">
			<label for="tab-details" id="tab-details-label" class="tab{if $jobtype eq 'casting'} casting{/if}">Details</label>
			<label for="tab-additional" id="tab-additional-label" class="tab{if $jobtype eq 'casting'} casting{/if}">Additional info</label>
			{if $jobtype eq 'booking'}
			<label for="tab-rights" id="tab-rights-label" class="tab">Usage rights</label>
			{/if}
			
			<label for="tab-models" id="tab-models-label" class="tab desktop{if $jobtype eq 'casting'} casting{/if}">{if $job.projectbookingtype eq 'booking'}Models{else}Requested Model{/if}</label>
			<label for="tab-sharecode" id="tab-sharecode-label" class="tab{if $jobtype eq 'casting'} casting{/if}">Share</label>
			
			<div class="panel active" id="tab-details-panel">
	
				<div class="row">
					<div class="column profile">
						<label for="jobtype">Type of Project</label>
						<div class="select-wrap">
							<select name="jobtype input" id="jobtype" class="select">
							{if  $jobtype eq 'casting'}
							{foreach from=$jobtypes item=type name=type key=k}
							{if $k eq 75 || $k eq 78}
							<option value="{$k}"{if $job.project_tid eq $k} selected="selected"{/if}>{$type.name}</option>
							{/if}
							{/foreach}
							{else}
							{foreach from=$jobtypes item=type name=type key=k}
							{if $k neq 75 && $k neq 78}
							<option value="{$k}"{if $job.project_tid eq $k} selected="selected"{/if}>{$type.name}</option>
							{/if}
							{/foreach}
							{/if}
							</select>
						</div>
					
						<label for="location">Location</label>
						<textarea id="location" name="location input" rows=4 placeholder="Project location">{$job.location}</textarea>
						{if $companyid neq 0}
						<label for="ordernumber">Order/Job Number</label>
						<input type="text" id="ordernumber" name="ordernumber input" placeholder="-" value="{$job.order_number}"{if $job.job_status eq 1} disabled="disabled"{/if}>
						{/if}
					</div>
				
					<div class="column">
					
						<label for="startdate">Start Date</label>
						<input type="text" id="startdate" name="startdate input" placeholder="Start Date" class="span2" value="{$job.startdate|date_format:"%d-%m-%Y"}">
					
						<label for="starttime">Start Time</label>
						<input type="text" id="starttime" name="starttime input" placeholder="Start Time as hh:mm" class="span2" value="{$job.starttime|date_format:"%I:%M %p"}">
					
						{if $jobtype neq 'casting'}
						<label for="length">Duration</label>
						<div class="select-wrap">
							<select name="length input" id="length" class="select">
								<option disabled="disabled" selected="selected" value="0">Please select</option>
								<option value=".5"{if $job.time_units eq .5} selected="selected"{/if}>Half day</option>
								<option value="1"{if $job.time_units eq 1} selected="selected"{/if}>1 day</option>
								<option value="2"{if $job.time_units eq 2} selected="selected"{/if}>2 days</option>
								<option value="3"{if $job.time_units eq 3} selected="selected"{/if}>3 days</option>
								<option value="4"{if $job.time_units eq 4} selected="selected"{/if}>4 days</option>
								<option value="5"{if $job.time_units eq 5} selected="selected"{/if}>5 days</option>
								<option value="6"{if $job.time_units eq 6} selected="selected"{/if}>6 days</option>
								<option value="7"{if $job.time_units eq 7} selected="selected"{/if}>7 days</option>
								<option value="8"{if $job.time_units eq 8} selected="selected"{/if}>8 days</option>
								<option value="9"{if $job.time_units eq 8} selected="selected"{/if}>9 days</option>
								<option value="10"{if $job.time_units eq 10} selected="selected"{/if}>10 days</option>
								<option value="11"{if $job.time_units eq 11} selected="selected"{/if}>11 days</option>
								<option value="12"{if $job.time_units eq 12} selected="selected"{/if}>12 days</option>
								<option value="13"{if $job.time_units eq 13} selected="selected"{/if}>13 days</option>
								<option value="14"{if $job.time_units eq 14} selected="selected"{/if}>14 days</option>
								<option value="15"{if $job.time_units eq 15} selected="selected"{/if}>15 days</option>
							</select>
						</div>
						<div class="minlength_notice"></div>
						{else}
						<label for="length">Duration in Hours</label>
						<input type="text" name="length input" id="length" value="{$job.time_units}">
						{/if}
					</div>
				
				</div>
				
				
				<div class="row">
					{if $jobtype neq 'casting'}
					{if $job.projectbookingtype eq 'booking'}
					<div class="column">
						<label for="modelcount" id="modelcountlabel">Number of <span class="projectnormal">Models</span><span class="projectinfluencer">Influencers</span></label>
						<input type="text" id="modelcount" name="modelcount input" placeholder="" value="{$job.modelcount}">
					</div>
					{else}
					<input type="hidden" id="modelcount" name="modelcount input" placeholder="" value="1">
					{/if}
					<div class="column">
						<label for="rate">Total {if $job.projectbookingtype eq 'booking'}per Model{else}for {$directmodel.firstname}{/if} per day</label>
						<input type="text" id="rate" name="offeredrate input" placeholder="Offered Rate" value="{$job.offered_rate}"{if $job.job_status eq 1} disabled="disabled"{/if}>
						<p class="minrate_notice"></p>
					</div>

					<div class="column" style="border-bottom: 3px solid #000; padding-left: 0em; padding-right: 0em; margin-right: 0.625em; margin-left: 0.625em; margin-bottom: 1.5em;">
						<label for="baserateradio"><b>Total Fee</b> <span style="font-size: 75%;">(inc. Booking Fee & VAT)</span></label>
						<input type="text" disabled="disabled" id="totalfee" style="font-weight: 700; border-bottom: 3px solid #000; margin-bottom: 0.25em;" value="--">
						<p class="minrate_notice"></p>
					</div>
					{/if}
					
				</div>
				
				<div class="row">
					<div class="column">
						<label for="description">Description</label>
						<textarea id="description" name="description input" placeholder="Project Description" rows="10">{$job.description}</textarea>
					</div>
				</div>
				<div class="row">
					<div class="column text-center mobile-center">
						<button class="updatebtn inverted button" type="submit" value="Update" name="step">Update project</button>
					</div>
					<div class="column text-center mobile-center">
						<button class="button white cancel" type="submit" value="Cancel" name="step">Back to projects</button>
					</div>
					{if $job.status eq 0}
					<div class="column text-center mobile-center">
						<button class="button white errorbutton" type="submit" value="Delete" name="step">Delete project</button>
					</div>
					{/if}
				</div>
			</div>
		
			<div class="panel active additional-info" id="tab-additional-panel">
				<div class="row">
					<div class="column">
						<div class="advanced-checkboxes">
							<div class="row">
								{if $jobtype eq 'casting'}
								<div class="column">
									<label for="contact_name">Contact name</label>
									<input type="text" id="contact_name" name="contact_name input" placeholder="Contact name" value="{$job.advanced.contact_name}">
									<p><em>Will be shared with {if $job.modelcount eq 1}the <span class="projectnormal">model</span><span class="projectinfluencer">influencer</span>{else}<span class="projectnormal">models</span><span class="projectinfluencer">influencers</span>{/if} once the job is confirmed</em></p>
								</div>
								{/if}
								<div class="column">
									<label for="contact_number">Contact number</label>
									<input type="text" id="contact_number" name="contact_number input" placeholder="Contact number" value="{$job.advanced.contact_number}">
								</div>
							</div>
							
							<div class="row projectinfluencer">
								<div class="column">
									<b>Request model addresses for Product Delivery</b>
								</div>
								<div class="column text-right narrow"">
									<input class="tgl tgl-slider" id="model_address" name="model_address" type="checkbox" {if $job.request_address eq 1}checked="checked"{/if} />
									<label class="tgl-btn" for="model_address"></label>	
								</div>
							</div>
							{if $jobtype eq 'booking'}
							<div class="row">
								<div class="column">
									<b>Will there be a specific meeting point?</b>
									<textarea name="model_meeting_point" class="toggle" placeholder="">{$job.advanced.model_meeting_point}</textarea>
								</div>
								<div class="column text-right narrow">
									<input class="tgl tgl-slider" id="model_meeting_point" name="model_meeting_point_check" type="checkbox" {if $job.advanced.model_meeting_point neq ''}checked="checked"{/if} />
									<label class="tgl-btn" for="model_meeting_point"></label>	
								</div>
							</div>
							{/if}
							
							<div class="row">
								<div class="column">
									{if $jobtype eq 'casting'}
									<b>Do models need to bring composite cards?</b>
									{else}
									<b>{if $job.modelcount eq 1}Does the <span class="projectnormal">model</span><span class="projectinfluencer">influencer</span>{else}Do the <span class="projectnormal">models</span><span class="projectinfluencer">influencers</span>{/if} need to bring anything?</b>
									<textarea name="model_to_bring" class="toggle" placeholder="Specify here: Nude underwear, simple black heels, etc">{$job.advanced.model_to_bring}</textarea>
									{/if}
								</div>
								<div class="column text-right narrow">
									<input class="tgl tgl-slider" id="model_to_bring" name="model_to_bring_check" type="checkbox" {if $job.advanced.model_to_bring neq ''}checked="checked"{/if}/>
									<label class="tgl-btn" for="model_to_bring"></label>	
								</div>
							</div>
						
							<div class="row">
								<div class="column">
									{if $jobtype eq 'casting'}
									<b>Do models need to present their digital portfolio on a tablet/smartphone?</b>
									{else}
									<b>Any specific transport methods?</b>
									<textarea name="transport_methods" class="toggle" placeholder="Specify here: Train to Oxfordshire Train Station from Victoria with the team, etc">{$job.advanced.transport_methods}</textarea>
									{/if}
								</div>
								<div class="column text-right narrow">
									<input class="tgl tgl-slider" id="transport_methods" name="transport_methods_check" type="checkbox" {if $job.advanced.transport_methods neq ''}checked="checked"{/if}/>
									<label class="tgl-btn" for="transport_methods"></label>	
								</div>
							</div>
						
							<div class="row">
								<div class="column">
									{if $jobtype eq 'casting'}
									<b>Do they need to bring any specific footwear?</b>
									{else}
									<b>Will you expense the {if $job.modelcount eq 1}<span class="projectnormal">model's</span><span class="projectinfluencer">influencer's</span>{else}<span class="projectnormal">models'</span><span class="projectinfluencer">influencers'</span>{/if} travel costs?</b>
									{/if}
									<textarea name="model_expenses" class="toggle" placeholder="Specify here{if $jobtype eq 'booking'}: Train to Oxfordshire will be expensed by us, etc{/if}">{$job.advanced.model_expenses}</textarea>
								</div>
								<div class="column text-right narrow">
									<input class="tgl tgl-slider" id="model_expenses" name="model_expenses_check" type="checkbox" {if $job.advanced.model_expenses neq ''}checked="checked"{/if} />
									<label class="tgl-btn" for="model_expenses"></label>	
								</div>
							</div>
						
							<div class="row">
								<div class="column">
									{if $jobtype eq 'casting'}
									<b>Any specific details about hair or make-up?</b>
									{else}
									<b>Is hair and make-up styling provided?</b>
									{/if}
									<textarea name="makeup_provided" class="toggle">{$job.advanced.makeup_provided}</textarea>
								</div>
								<div class="column text-right narrow">
									<input class="tgl tgl-slider" id="makeup_provided" name="makeup_provided_check" type="checkbox" {if $job.advanced.makeup_provided neq ''}checked="checked"{/if} />
									<label class="tgl-btn" for="makeup_provided" placeholder="Specify here: Please arrive with light natural makeup and low ponytail etc"></label>	
								</div>
							</div>
	
						</div>
					</div>
				</div>
				<div class="row">
					<div class="column text-center mobile-center">
						<button class="updatebtn inverted button" type="submit" value="Update" name="step">Update project</button>
					</div>
					<div class="column text-center mobile-center">
						<button class="button white cancel" type="submit" value="Cancel" name="step">Back to projects</button>
					</div>
					{if $job.status eq 0}
					<div class="column text-center mobile-center">
						<button class="button white errorbutton" type="submit" value="Delete" name="step">Delete project</button>
					</div>
					{/if}
				</div>
			</div>
			
			<div class="panel active usage-rights" id="tab-rights-panel">
				<div class="row">
					<div class="column">
						<div class="triplet-checkbox rights">
							<label for="standardrights"{if $job.baseusage eq 'standard' || $job.baseusage eq ''} class="active"{/if}>Standard</label>
							<input type="radio" id="standardrights" name="baseusage" value="standard" {if $job.baseusage eq 'standard' || $job.baseusage eq ''} checked="checked"{/if}/>
							<label for="extrarights"{if $job.baseusage eq 'custom'}class="active"{/if}>Additional usage</label>
							<input type="radio" id="extrarights" name="baseusage" value="custom" {if $job.baseusage eq 'custom'} checked="checked"{/if}/>
							<p>As a standard, usage rights for each booking through IDAL covers 6 months across up to three selected media.</p>
						</div>
						<div class="rights-checkboxes">
			  		 		<div class="row">
								<div class="column">UK</div>
								<div class="column text-right">
									<input class="tgl tgl-slider" id="ukrights" type="checkbox" name="ukrights"{if $job.usage.uk eq 1} checked="checked"{/if} />
									<label class="tgl-btn" for="ukrights"></label>	
								</div>
							</div>
							<div class="rights-holder">
								<div class="row">
									<div class="column">Europe (includes UK)</div>
										<div class="column text-right">
											<input class="tgl tgl-slider" id="eurights" type="checkbox" name="eurights"{if $job.usage.europe eq 1} checked="checked"{/if} />
											<label class="tgl-btn" for="eurights"></label>	
										</div>
									</div>
						   		<div class="row">
									<div class="column">International</div>
									<div class="column text-right">
										<input class="tgl tgl-slider" id="intrights" type="checkbox" name="intrights"{if $job.usage.international eq 1} checked="checked"{/if} />
										<label class="tgl-btn" for="intrights"></label>	
									</div>
								</div>
							</div>
							<hr />
							<div class="base-rights-holder">
								{foreach from=$usagerights item=right}
								<div class="row">
									<div class="column">{$right.name}</div>
									<div class="column text-right">
										<input class="tgl tgl-slider" id="usagerights-{$right.tid}" type="checkbox" name="usagerights[]" value="{$right.tid}" {foreach from=$job.usagerights item=ur}{if $ur.tid eq $right.tid} checked="checked"{/if}{/foreach} />
										<label class="tgl-btn" for="usagerights-{$right.tid}"></label>	
									</div>
								</div>
								{/foreach}
							
	
							</div>
						</div>
						<div class="rights-holder"{if $job.usagerights neq 'custom'} style="display: none;"{/if}>
							<hr />
							<h3>Additional usage rights</h3>
							<textarea id="extrarightsentry" name="extrarights input" placeholder="Additional usage rights" rows="4">{$job.additionalrights}</textarea>
						</div>
					</div>
					<div class="column">
						
					</div>
					
				</div>
				<div class="row">
					<div class="column text-center mobile-center">
						<button class="updatebtn inverted button" type="submit" value="Update" name="step">Update project</button>
					</div>
					<div class="column text-center mobile-center">
						<button class="button cancel" type="submit" value="Cancel" name="step">Back to projects</button>
					</div>
					{if $job.status eq 0}
					<div class="column text-center mobile-center">
						<button class="button errorbutton" type="submit" value="Delete" name="step">Delete project</button>
					</div>
					{/if}
				</div>
			</div>
			
			<div class="panel active optioned-models" id="tab-models-panel">
				{include file="jobs/edit_job_modelpanel_simple.tpl"}
			</div>
			
			<div class="panel active optioned-models" id="tab-sharecode-panel">
				<div class="row">
					<div class="column">
						<h2>Password to access this project: {$job.sharepass}</h2>
						<p>You can share this code with other people so they can view your model options and propose changes.</p>
						<p style="line-height: 2em;">To share this project, send this URL:<br /><b><span id="copyshareuri" style="margin: 0.25em; padding: 0.25em; border: 1px solid #aaa; border-radius: 2px">{$method}://{$smarty.server.HTTP_HOST}/projects/share/{$job.shareuri}</span></b><br />and the password above.</p>
					</div>
				</div>
			</div>
		</div>
	</section>
	<input type="hidden" name="jobid" value="{$jobid}" />
	<input type="hidden" name="bookingtype" value="{$job.bookingtype}" />
	<input type="hidden" name="sharepass" value="{$job.sharepass}" />
	<input type="hidden" name="shareuri" value="{$job.shareuri}" />
	<input type="hidden" name="minHourly" value="{$minhourly}" />
	<input type="hidden" name="minDaily" value="{$mindaily}" />
	<input type="hidden" name="jobstarttime" value="{$job.startdate}" />
	{if $job.units_type eq 'hours'}
	<input type="hidden" name="jobendtime" value="{$job.startdate}" />
	{else}
	<input type="hidden" name="jobendtime" value="{$job.startdate + ($job.time_units * 60 * 60 * 24)}" />
	{/if}
	
</form>
{* model search modal *}
<div class="reveal modalBlue searchModal" id="modelSearch" data-reveal style="width: 85vw !important; height: 95vh !important; overflow-y: none !important;">
	<div style="width: 100% !important; height: 100% !important; overflow-y: scroll !important; border-radius: 20px;">
	{include file="search/search_popup.tpl"}
	</div>
</div>
{include file="jobs/create_template_popup.tpl"}
{/block}