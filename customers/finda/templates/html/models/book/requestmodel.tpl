{extends "user/layout_wide.tpl"}

{block name="main"}

{if $pagemessage.message neq ""}
<div class="row">
	<div class="callout {$pagemessage.type}">
		<h5>{$pagemessage.message}</h5>
	</div>
</div>
{/if}
<form action="/book/request/{$model.sefu}" method="post" action="create" id="projectdetails" style="margin-top: 2em;">
	<div class="row">
		<div class="column">
			<h1>Book {$model.firstname}</h1>
		</div>
	</div>
	{if $userid eq 0}
	<div class="row">
		<div class="column">
			<label for="username">Your Name</label>
			<input type="text" id="firstname" name="firstname" placeholder="First name">
		</div>
		<div class="column lastnameholder">
			<label for="username">&nbsp;</label>
			<input type="text" id="lastname" name="lastname" placeholder="Last name">
		</div>
		<div class="column">
			<label for="usermail">Email address</label>
			<input type="email" id="usermail" name="usermail" placeholder="Email address at work">
		</div>
		<div class="column telephoneholder">
			<label for="telephone">Phone number</label>
			<input type="text" id="telephone" name="telephone" placeholder="Your international phone number">
		</div>
		<div class="column companyholder">
			<label for="username">Your Company</label>
			<input type="text" id="company" name="company" placeholder="Your company's name">
		</div>
		<div class="column companywebsiteholder">
			<label for="username">Your Website</label>
			<input type="text" id="company_website" name="company_website" placeholder="Your company's website">
		</div>
	</div>
	{/if}
	<div class="row">
		<div class="column profile">
		
			<label for="jobtype">Type of Booking</label>
			<div class="select-wrap">
				<select name="jobtype input" id="jobtype" class="select">
					<option value="0" disabled="disabled" selected="selected">Select booking type</option>
					{foreach from=$jobtypes item=type name=type key=k}
					{if $k neq 75 && $k neq 78}
					<option value="{$k}">{$type.name}</option>
					{/if}
					{/foreach}
				</select>
			</div>
		
			<label for="location">Location</label>
			<textarea id="location" name="location input" rows=4 placeholder="Enter the full address where the project will take place">{$job.location}</textarea>
{*
			<label for="ordernumber">Order/Job Number</label>
			<input type="text" id="ordernumber" name="ordernumber input" placeholder="(Optional) For your own records">
*}
		</div>
	
		<div class="column">
		
			<label for="startdate">Start Date</label>
			<input type="text" id="startdate" name="startdate input" placeholder="Pick the start date" class="span2">
		
			<label for="starttime">Start Time</label>
			<div class="select-wrap">
				<select name="starttime input" id="starttime" class="select">
					<option value="0" selected="selected" disabled="disabled">Select model’s arrival time</option>
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
		
			<label for="length">Duration</label>
			<div class="select-wrap">
				<select name="length input" id="length" class="select">
					<option value="0" disabled="disabled" selected="selected">Select number of working days</option>
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
		</div>
	
	</div>
	
	
	<div class="row">
		<div class="column">
			<label for="rate">Offer</label>
			<span class="rateholder">
				<input type="text" id="rate" name="offeredrate input" placeholder="Your offer to the model" value="{if $model.profile.dailyrate neq 0}{$model.profile.dailyrate}{/if}">
			</span>
			<p class="minrate_notice"></p>
		</div>

		<div class="column">
			<div style="border-bottom: 3px solid #000; padding-left: 0em; padding-right: 0em; margin-bottom: 0.5em;">
				<label for="baserateradio"><b>Total Fee<sup>*</sup></b> <span style="font-size: 75%;">(inc. Booking Fee & VAT)</span></label>
				<input type="text" disabled="disabled" id="totalfee" style="font-weight: 700; border-bottom: 3px solid #000; margin-bottom: 0.25em;" value="--">
			</div>
			<div style="font-size: 75%; padding-left: 1em;"><em><sup>*</sup>The invoiced amount if your project is confirmed</em></div>
			<p class="minrate_notice"></p>
		</div>
	</div>
	
	<div class="row">
		<div class="column">
			<label for="description">Description</label>
			<textarea id="description" name="description input" placeholder="Tell the model all about your project" rows="10">{$job.description}</textarea>
		</div>
	</div>
	
	<div class="row">
		<div class="column text-center">
			<a href="/book" class="button burgundy finishbooking">Send Booking Request</a>
		</div>
	</div>

	<input type="hidden" name="modelid" value="{$model.id}" />
	<input type="hidden" name="modelname" value="{$model.firstname}" />
	<input type="hidden" name="userid" value="{$userid}" />
	<input type="hidden" name="bookingtype" value="booking" />
	<input type="hidden" name="minDaily" value="{$mindaily}" />
</form>
{/block}