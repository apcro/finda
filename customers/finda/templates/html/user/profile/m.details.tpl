	<div class="panel active profile profileditor" id="tab-profile-panel">
		<div class="row">
			<div class="column">
				<h3>Personal Details</h3>
			</div>
			<div class="column">
				{if $usertype eq 1}<p><a href="/view/{$register_firstname}-{$register_lastname}">Check how clients see your profile</a></p>{/if}
			</div>
		</div>
		{if $usertype eq 2}
		<div class="row">
			<div class="column">
				<label class="required" for="company">Company name<span> *</span></label>
				<input type="text" id="company" name="company input" placeholder="Company name" value="{$company_name}">
			</div>
		</div>
		<div class="row">
			<div class="column">
				<label class="required" for="website">Website<span> *</span></label>
				<input type="text" id="website" name="website input" placeholder="Website address" value="{$company_website}">
			</div>
		</div>
		{/if}
		<div class="row">
			<div class="column">
				<label class="required" for="register_firstname">First name<span> *</span></label>
				<input type="text" name="register_firstname" id="register_firstname" value="{$register_firstname}" />
			</div>
		</div>
		<div class="row">
			<div class="column">
				<label class="required" for="register_lastname">Last Name<span> *</span></label>
				<input type="text" name="register_lastname" id="register_lastname" value="{$register_lastname}" />
			</div>
		</div>
		<div class="row">
			<div class="column" style="position: relative; display: inline-block;">
				{if $dob neq 0}<div data-balloon="Please contact us if you want to change this" data-balloon-pos="up">{/if}
				<label style="display: inline-block; position: relative;" class="required" for="dob">Date of Birth<span> *</span>{if $dob eq 0}<div class="infoballoon" data-balloon-length="medium" data-balloon="We need this to {if $usertype eq 2}accept payments from{else}make payments to{/if} you. Until this is filled in you will not be able to {if $usertype eq 2}book models{else}accept projects and will not appear in search results{/if}" data-balloon-pos="up"><img src="/images/info_icon.png" /></div>{/if}</label>
				<input type="text" id="dob" name="dob input" placeholder="Date of Birth" {if $dob neq 0}disabled{/if} value="{if $dob neq 0}{$dob|date_format:"%d/%m/%Y"}{/if}">
				{if $dob neq 0}</div>{/if}
				
			</div>
		</div>
		<div class="row">
			<div class="column" style="position: relative; display: inline-block;">
				{if $nationality neq ''}<div data-balloon="Please contact us if you want to change this" data-balloon-pos="up">{/if}
				<label class="required" style="display: inline-block; position: relative;" for="nationality">Nationality<span> *</span>{if $user.nationality eq ''}<div class="infoballoon" data-balloon-length="medium" data-balloon="We need this to {if $usertype eq 2}accept payments from{else}make payments to{/if} you. Until this is filled in you will not be able to {if $usertype eq 2}book models{else}accept projects{/if}" data-balloon-pos="up"><img src="/images/info_icon.png" /></div>{/if}</label>
				
				<div class="select-wrap">
					<select name="nationality" class="form_select select" id="nationality" {if $user.nationality neq ''}disabled{/if}>
					{if $user.nationality neq ''}
					<option value="{$user.nationality}" selected="selected">{$user.nationality}</option>
					{else}
					{include file="user/countries.tpl"}
					{/if}
					</select>
				</div>
				
				{if $user.nationality neq ''}</div>{/if}
			</div>
			<div class="column" style="position: relative; display: inline-block;">
				{if $user.residence_country neq ''}<div data-balloon="Please contact us if you want to change this" data-balloon-pos="up">{/if}
				<label style="display: inline-block; position: relative;" class="required" for="residence_country">Country of residence<span> *</span>{if $user.residence_country eq ''}<div class="infoballoon" data-balloon-length="medium" data-balloon="We need this to {if $usertype eq 2}accept payments from{else}make payments to{/if} you. Until this is filled in you will not be able to {if $usertype eq 2}book models{else}accept projects{/if}" data-balloon-pos="up"><img src="/images/info_icon.png" /></div>{/if}</label>
				
				<div class="select-wrap">
					<select name="residence_country" class="form_select select" id="residence_country" {if $user.residence_country neq ''}disabled{/if}>
					{if $user.residence_country neq ''}
					<option value="{$user.residence_country}" selected="selected">{$user.residence_country}</option>
					{else}
					{include file="user/countries.tpl"}
					{/if}
					</select>
				</div>
				
				{if $user.residence_country neq ''}</div>{/if}
			</div>
			{if $user.usertype eq 1}
		</div>
		<div class="row">
			<div class="column" style="position: relative; display: inline-block;">
				<label style="display: inline-block; position: relative;" for="vatnumber">VAT Number{if $user.usertype eq 1}<div class="infoballoon" data-balloon-length="medium" data-balloon="We need this to make sure we pay you VAT if necessary. If you don't have a VAT number we won't include VAT in your invoice." data-balloon-pos="up"><img src="/images/info_icon.png" /></div>{/if}</label>
				<input type="text" id="vatnumber" name="vatnumber input" value="{$user.vat_number}" placeholder="(optional)">
			</div>
			{/if}
		</div>
		{if $usertype eq 2}
		<div class="row">
			<div class="column">
				<label for="occupation">Occupation</label>
				<input type="text" id="occupation" name="occupation input" placeholder="Occupation" value="{$occupation}">
			</div>
		</div>
		<div class="row">
			<div class="column">
				<label for="telephone">Telephone</label>
				<input type="text" id="telephone" name="telephone input" placeholder="Telephone number" value="{$telephone}">
			</div>
		</div>
		{/if}
		<div class="row">
			<div class="column">
				<label class="required" for="register_email">Email address<span> *</span></label>
				<input type="text" id="register_email" name="register_mail" value="{$register_mail}" />
				<span class="hide deny">Email address already in use</span>
			</div>
			{if $usertype eq 1}
		</div>
		<div class="row">
			<div class="column">
				<label style="display: inline-block; position: relative;" for="register_referral_code">Referral Code{if !$referral_code}<div class="infoballoon" data-balloon-length="medium" data-balloon="Did a friend refer you to iDAL? Please enter your code here." data-balloon-pos="up"><img src="/images/info_icon.png" /></div>{/if}</label>
				<input type="text" id="register_referral_code" name="register_referral_code" value="{$referral_code}" />
			</div>
			{/if}
		</div>
		{if $usertype eq 1}
		<div class="row">
			<div class="column">
				<label for="gender">I identify as</label>
				<div class="select-wrap">
					<select name="gender input" id="gender" class="select">
						<option value="male"{if $gender eq 'male'} selected="selected"{/if}>Male</option>
						<option value="female"{if $gender eq 'female'} selected="selected"{/if}>Female</option>
						<option value="other"{if $gender eq 'other'} selected="selected"{/if}>Non-binary</option>
					</select>
				</div>
			</div>
			<div class="column">
				<label for="ethnicity">Ethnicity</label>
				<div class="select-wrap">
					<select class="select" name="ethnicity input" id="ethnicity">
						{foreach from=$ethnicity item=eth name=eth}
						<option value="{$eth.tid}"{if $user.ethnicity eq $eth.tid} selected="selected"{/if}>{$eth.name}</option>
						{/foreach}
					</select>
				</div>
			</div>
		</div>
	
		<div class="row">
			<div class="column">
				<label for="instagram">Instagram Username</label>
				<input type="text" id="instagram" name="instagram input" placeholder="@username" value="{$user.instagram_username}">
			</div>
		</div>
		<div class="row desktop">
			<div class="column">
				<label for="instagram">Followers</label>
				<input type="text" id="followers" name="followers input" disabled="disabled" value="{$user.instagram_followers}">
			</div>
		</div>
	
		<div class="row">
			<div class="column">
				<label for="hourlyrate">Minimum Hourly Rate</label>
				<input type="text" id="hourlyrate" name="hourly input" placeholder="Hourly Rate" value="{$user.profile.hourlyrate}">
			</div>
		</div>
		<div class="row">
			<div class="column">
				<label for="dailyrate">Minimum Daily Rate</label>
				<input type="text" id="dailyrate" name="daily input" placeholder="Daily Rate" value="{$user.profile.dailyrate}">
			</div>
		</div>
		
		{/if}
	
	</div>
	
	<div class="panel profile profileditor" id="tab-measurements-panel">
		{if $usertype eq 1}
		<div class="row">
			<div class="column">
				<h3>Measurements</h3>
				<p>Please enter your measurements in centimeters. 1 inch is roughly 2.5 centimeters.</p>
			</div>
		</div>
{*
		<div class="row">
			<div class="column">
				<p>Please enter your measurements in centimeters. 1 inch is roughly 2.5 centimeters.</p>
			</div>
			<div class="converter">
				<div class="column">
					<label for="val1">Inches: </label>
					<input type="text" id="val1"><br />
					<label for="val2">to CM:</label>
					<input type="text" disabled="disabled" id="val2">
				</div>
				<div class="column text-right" style="margin-top: 0.5em;">
					<button class="convert button small bg-black white hvr hvr-purple">Convert</button>
				</div>
			</div>
		</div>
*}	
		<div class="row">
			<div class="column">
				<label for="height">Height (cm)</label>
				<input type="text" id="height" name="height input" placeholder="Height" value="{$user.profile.height}">
			</div>
		</div>
		<div class="row">
			<div class="column">
				<label for="bust">Bust (cm)</label>
				<input type="text" id="bust" name="bust input" placeholder="Bust" value="{$user.profile.bust}">
			</div>
		</div>
		<div class="row">
			<div class="column">
				<label for="waist">Waist (cm)</label>
				<input type="text" id="waist" name="waist input" placeholder="Waist" value="{$user.profile.waist}">
			</div>
		</div>
		<div class="row">
			<div class="column">
				<label for="hips">Hips (cm)</label>
				<input type="text" id="hips" name="hips input" placeholder="Hips" value="{$user.profile.hips}">
			</div>
		</div>
	
		<div class="row">
			<div class="column">
				<label for="shoesize">Shoe Size</label>
				<div class="select-wrap">
					<select name="shoesize input" id="shoesize" class="select">
						{foreach from=$details.shoesizes item=shoesize}
						<option value="{$shoesize.value}"{if $user.profile.shoesize eq $shoesize.value} selected="selected"{/if}>{$shoesize.description}</option>
						{/foreach}
					</select>
				</div>
{*				<input type="text" id="shoesize" name="shoesize input" placeholder="Shoe Size" value="{$user.profile.shoesize}"> *}
			</div>
		</div>
		<div class="row">
			<div class="column">
				<label for="dresssize">Dress Size</label>
				<div class="select-wrap">
					<select name="dresssize input" id="dresssize" class="select">
						{foreach from=$details.dresssizes item=dresssize}
						<option value="{$dresssize.value}"{if $user.profile.dresssize eq $dresssize.value} selected="selected"{/if}>{$dresssize.description}</option>
						{/foreach}
					</select>
				</div>
{*				<input type="text" id="dresssize" name="dresssize input" placeholder="Dress Size" value="{$user.profile.dresssize}">*}
			</div>
		</div>
	
		<div class="row">
			<div class="column">
				<label for="haircolour">Hair Colour</label>
				<div class="select-wrap">
					<select name="haircolour input" id="hairtype" class="select">
						{foreach from=$haircolours item=haircolour name=haircolour}
						<option value="{$haircolour.tid}"{if $user.profile.haircolour_tid eq $haircolour.tid} selected="selected"{/if}>{$haircolour.name}</option>
						{/foreach}
					</select>
				</div>
			</div>
		</div>
		<div class="row">
			<div class="column">
				<label for="hairtype">Hair Type</label>
				<div class="select-wrap">
					<select name="hairtype input" id="hairtype" class="select">
						{foreach from=$hairtypes item=hairtype name=hairtype}
						<option value="{$hairtype.tid}"{if $user.profile.hairtype_tid eq $hairtype.tid} selected="selected"{/if}>{$hairtype.name}</option>
						{/foreach}
					</select>
				</div>
			</div>
		</div>
		<div class="row">
			<div class="column">
				<label for="hairlength">Hair Length</label>
				<div class="select-wrap">
					<select name="hairlength input" id="hairlength" class="select">
						{foreach from=$hairlengths item=hairlength name=hairlength}
						<option value="{$hairlength.tid}"{if $user.profile.hairlength_tid eq $hairlength.tid} selected="selected"{/if}>{$hairlength.name}</option>
						{/foreach}
					</select>
				</div>
			</div>
		</div>
		<div class="row">
			<div class="column">
				<label for="willingtodye">Willing to colour?</label>
				<div class="select-wrap">
					<select name="willingtodye input" id="willingtodye" class="select">
						<option value="yes"{if $user.profile.willingtodye eq 1} selected="selected"{/if}>Yes</option>
						<option value="no"{if $user.profile.willingtodye eq 0} selected="selected"{/if}>No</option>
					</select>
				</div>
			</div>
		</div>
		<div class="row">
			<div class="column">
				<label for="willingtodye">Willing to cut?</label>
				<div class="select-wrap">
					<select name="willingtodye input" id="willingtodye" class="select">
						<option value="yes"{if $user.profile.willingtocut eq 1} selected="selected"{/if}>Yes</option>
						<option value="no"{if $user.profile.willingtocut eq 0} selected="selected"{/if}>No</option>
					</select>
				</div>
			</div>
		</div>
		<div class="row">
			<div class="column">
				<label for="eyecolour">Eye Colour</label>
				<div class="select-wrap">
					<select name="eyecolour input" id="eyecolour" class="select">
						{foreach from=$eyecolours item=eyecolour name=eyecolour}
						<option value="{$eyecolour.tid}"{if $user.profile.eyecolour_tid eq $eyecolour.tid} selected="selected"{/if}>{$eyecolour.name}</option>
						{/foreach}
					</select>
				</div>
			</div>
			{*
			<div class="column">
				<label for="eyebrow">Eyebrow Shape</label>
				<input type="text" id="eyebrow" name="eyebrowshape input" placeholder="Eyebrow Shape" value="{$user.profile.eyebrowshape}">
			</div>
			*}
		</div>
	
		{/if}
	</div>
	
	{if $usertype eq 1}
	<div class="panel profile profileditor" id="tab-experience-panel">
		<div class="">
			<h4>Experience</h4>
		</div>
		<form id="addexperience" action="/user/profile/experience/add" method="POST">
			<div class="row">
				<div class="column">
						<label for="clientname">Client Name</label>
						<input id="clientname" type="text" name="client input" placeholder="Client name" />
				</div>
			</div>
			<div class="row">
				<div class="column">
					<label for="jobtype">Type of Job</label>
					<div class="select-wrap">
						<select name="jobtype input" id="jobtype" class="select">
							{foreach from=$jobtypes item=type name=type key=k}
							<option value="{$k}">{$type.name}</option>
							{/foreach}
						</select>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="column">
					<label for="detailsname">Details</label>
					<input id="detailsname" type="text" name="details input" placeholder="Details" />
				</div>
			</div>
			<div class="row">
				<div class="column">
					<label for="dateworked">Date Worked</label>
					<input id="dateworked" type="text" name="dateworked input" placeholder="date worked" />
				</div>
			</div>
			<button type="submit" class="button bg-black hvr hvr-purple white addexperience">Add Experience</button>
		</form>
		{foreach from=$experience name=exp item=exp}
		<hr />
		<div class="row">
			<div class="column">
				<p>type: {$exp.work_type_name}<br />
				client: {$exp.client}<br />
				details: {$exp.details}<br />
				on: {$exp.date_worked|date_format:"%d %B %Y"}<br />
				<a href="/user/profile/experience/edit/{$exp.id}">edit</a>&nbsp;&middot;&nbsp;<a style="color: #f00" class="remove" data-expid="{$exp.id}" href="/user/profile/experience/remove/{$exp.id}">remove</a></p>
			</div>
		</div>
		{/foreach}
		<hr />
	</div>
	{/if}
		<div class="panel profile profileditor" id="tab-preferences-panel">
		<div class="row">
			<div class="column">
				<h3>Preferences</h3>
				<p>Set your email contact preferences.</p>
			</div>
		</div>

		<div class="row sub-heading bg-bordergrey">
			<div class="column">Email me when:</div>
		</div>
		<div class="row alternate">
			<div class="column">A friend users my referrer code</div>
			<div class="column text-right">
				<input class="tgl tgl-slider" id="email_registers" type="checkbox" name="friend_registers"{if $user.prefs.friend_registers eq 1} checked="checked" {/if}/>
				<label class="tgl-btn" for="email_registers"></label>	
			</div>
		</div>

		<div class="row">
			<div class="column">I receive a job offer</div>
			<div class="column text-right">
				<input class="tgl tgl-slider" id="email_offered" type="checkbox" name="job_offered"{if $user.prefs.job_offered eq 1} checked="checked" {/if}/>
				<label class="tgl-btn" for="email_offered"></label>
			</div>
		</div>

		<div class="row">
			<div class="column">A job I am working on is cancelled</div>
			<div class="column text-right">
				<input class="tgl tgl-slider" id="email_cancelled" type="checkbox" name="job_cancelled"{if $user.prefs.job_cancelled eq 1} checked="checked" {/if}/>
				<label class="tgl-btn" for="email_cancelled"></label>
			</div>
		</div>

		<div class="row alternate">
			<div class="column">I receive a payment</div>
			<div class="column text-right">
				<input class="tgl tgl-slider" id="email_payment" type="checkbox" name="payment_made"{if $user.prefs.payment_made eq 1} checked="checked" {/if}/>
				<label class="tgl-btn" for="email_payment"></label>
			</div>
		</div>

		<div class="row">
			<div class="column">I receive a notification</div>
			<div class="column text-right">
				<input class="tgl tgl-slider" id="email_notifications" type="checkbox" name="notifications"{if $user.prefs.notifications eq 1} checked="checked" {/if}/>
				<label class="tgl-btn" for="email_notifications"></label>
			</div>
		</div>



	</div>




	<div class="panel profile profileditor" id="tab-password-panel">
		<div class="row">
			<div class="column">
				<h3>Password Management</h3>
			</div>
		</div>

		<div class="row">
			<div class="column">
				<label for="oldpass">Old Password</label>
				<input type="password" id="oldpass" name="oldpassword input" placeholder="Password">
			</div>
		</div>
		<div class="row">
			<div class="column">
				<label for="newpass1">New Password</label>
				<input type="password" id="newpass1" name="newpassword input" placeholder="Password">
			</div>
		</div>
		<div class="row">
			<div class="column">
				<label for="newpass2">Repeat New Password</label>
				<input type="password" id="newpass2" name="confirmpassword input" placeholder="Password">
			</div>
		</div>
	</div>
