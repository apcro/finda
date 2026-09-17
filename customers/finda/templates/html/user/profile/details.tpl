<div class="blockmydetails active">
	{if $user.instagram_username eq '' && $user.instagram_followers eq -1}
	<div class="row">
		<div class="column">
			<div class="notice">
				<p>We couldn't find your Instagram username. You won't appear in search without it.</p>
			</div>
		</div>
	</div>
	{/if}
	<div class="panel active profile profileditor" id="tab-profile-panel">
		<div class="row">
			<div class="column">
				<h2>My Profile</h2>
				
			</div>
		</div>
		<div class="row">
			<div class="column">
				<label class="required" for="register_firstname">First name<span> *</span></label>
				<input type="text" name="register_firstname" id="register_firstname" value="{$register_firstname}" />
			</div>
			<div class="column">
				<label class="required" for="register_lastname">Last Name<span> *</span></label>
				<input type="text" name="register_lastname" id="register_lastname" value="{$register_lastname}" />
			</div>
			<div class="column" style="position: relative; display: inline-block;">
				{if $dob neq 0}<div data-balloon="Please contact us if you want to change this" data-balloon-pos="up">{/if}
				<label style="display: inline-block; position: relative;" class="required" for="dob">Date of Birth<span> *</span>{if $dob eq 0 && $usertype neq 3}<div class="infoballoon" data-balloon-length="medium" data-balloon="We need this to {if $usertype eq 2}accept payments from{else}make payments to{/if} you. Until this is filled in you will not be able to {if $usertype eq 2}book models{else}accept projects and will not appear in search results{/if}" data-balloon-pos="up"><img src="/images/info_icon.png" /></div>{/if}</label>
				<input style="font-family: inherit; font-size: inherit;" type="date" id="dob" name="dob input" placeholder="dd/mm/YYYY" {if $dob neq 0}disabled{/if} value="{if $dob neq 0}{$dob|date_format:"%Y-%m-%d"}{/if}">
				{if $dob neq 0}</div>{/if}
				
			</div>
		</div>
		<div class="row">
			<div class="column" style="position: relative; display: inline-block;">
				{if $nationality neq ''}<div data-balloon="Please contact us if you want to change this" data-balloon-pos="up">{/if}
				<label class="required" style="display: inline-block; position: relative;" for="nationality">Nationality<span> *</span>{if $user.nationality eq '' && $usertype neq 3}<div class="infoballoon" data-balloon-length="medium" data-balloon="We need this to {if $usertype eq 2}accept payments from{else}make payments to{/if} you. Until this is filled in you will not be able to {if $usertype eq 2}book models{else}accept projects{/if}" data-balloon-pos="up"><img src="/images/info_icon.png" /></div>{/if}</label>
				
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
				<label style="display: inline-block; position: relative;" class="required" for="residence_country">Country of residence<span> *</span>{if $user.residence_country eq '' && $usertype neq 3}<div class="infoballoon" data-balloon-length="medium" data-balloon="We need this to {if $usertype eq 2}accept payments from{else}make payments to{/if} you. Until this is filled in you will not be able to {if $usertype eq 2}book models{else}accept projects{/if}" data-balloon-pos="up"><img src="/images/info_icon.png" /></div>{/if}</label>
				
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
			<div class="column" style="position: relative; display: inline-block;">
				<label style="display: inline-block; position: relative;" class="required" for="user_location">Current Location<span> *</span> {* <div class="infoballoon" data-balloon-length="medium" data-balloon="This helps Clients find models" data-balloon-pos="up"><img src="/images/info_icon.png" /></div> *}</label>
				<div class="select-wrap">
					<select name="user_location" class="form_select select" id="user_location">
						<option value="0"{if $user.location eq 0} selected="selected"{/if} disabled="disabled">Please select your closest city</option>
						{foreach from=$user_locations item=user_location}
						<option value="{$user_location.tid}"{if $user.profile.location eq $user_location.tid} selected="selected"{/if}>{$user_location.name}</option>
						{/foreach}
					</select>
				</div>
			</div>
			{/if}
		</div>
		{if $usertype eq 2}
		<div class="row">
			<div class="column">
				{if $user.companyid neq 0}<div data-balloon="Please contact us if you want to change this" data-balloon-pos="up">{/if}
				<label class="required" for="company">Company name<span> *</span></label>
				<input type="text" id="company" name="company input" placeholder="Company name" value="{$company_name}"{if $user.companyid neq 0} disabled="disabled"{/if}>
				{if $user.companyid neq 0}</div>{/if}
			</div>
	
			<div class="column">
				{if $user.companyid neq 0}<div data-balloon="Please contact us if you want to change this" data-balloon-pos="up">{/if}
				<label class="required" for="website">Website<span> *</span></label>
				<input type="text" id="website" name="website input" placeholder="Website address" value="{$company_website}"{if $user.companyid neq 0} disabled="disabled"{/if}>
				{if $user.companyid neq 0}</div>{/if}
			</div>
			<div class="column">
				<label class="required" for="instagram">Company Instagram Username</label>
				<input type="text" id="instagram" name="instagram input" placeholder="@username" value="{$user.instagram_username}">
			</div>
		</div>
		<div class="row">
			<div class="column">
				<label for="occupation">Occupation</label>
				<input type="text" id="occupation" name="occupation input" placeholder="Occupation" value="{$occupation}">
			</div>
	
			<div class="column">
				<label for="telephone">Telephone</label>
				<input type="text" id="telephone" name="telephone input" placeholder="Telephone number" value="{$telephone}">
			</div>
		</div>
		
		<div class="row">
			<div class="column">
				<label for="address">Postal Address</label>
				<textarea id="address" lines=4 placeholder="(Optional) Enter your postal address" name="postal_address input">{$user.postal_address}</textarea>
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
			<div class="column">
				<label for="telephone">Mobile Number</label>
				<input type="text" id="telephone" name="telephone input" placeholder="Mobile number" value="{$telephone}">
			</div>
			<div class="column">
				<label style="display: inline-block; position: relative;" for="register_referral_code">Referral Code{if !$user.referral_code}<div class="infoballoon" data-balloon-length="medium" data-balloon="Did a friend refer you to iDAL? Please enter your code here." data-balloon-pos="up"><img src="/images/info_icon.png" /></div>{/if}</label>
				<input type="text" id="register_referral_code" name="register_referral_code" value="{$user.referral_code}" />
			</div>
			{/if}
		</div>
		{if $usertype eq 1}
		<div class="row">
			<div class="column">
				<label class="required" for="gender">I identify as<span> *</span></label>
				<div class="select-wrap">
					<select name="gender input" id="gender" class="select">
						<option value="male"{if $gender eq 'male'} selected="selected"{/if}>Man</option>
						<option value="female"{if $gender eq 'female'} selected="selected"{/if}>Woman</option>
						<option value="other"{if $gender eq 'other'} selected="selected"{/if}>Non-binary</option>
					</select>
				</div>
			</div>
			<div class="column{if $user.instagram_followers eq -1} error{/if}">
				<label class="required" for="instagram">Instagram Username<span> *</span></label>
				<input type="text" id="instagram" name="instagram input" placeholder="@username" value="{$user.instagram_username}">
			</div>
	
		</div>
		
		<div class="row">
			<div class="column">
				<label for="address">Postal Address</label>
				<textarea id="address" rows=4 placeholder="(Optional) Enter your postal address" name="postal_address input">{$user.postal_address}</textarea>
			</div>
		</div>
	
		<div class="row">
			<div class="column">
				<h2>Your Personal Booking Link</h2>
			</div>
		</div>
		
		<div class="row">
			<div class="column" style="max-width: 50%;">
				<label for="register_referrer_code">&nbsp;</label>
				<span class="copyme_referrer" data-code="https://idal.co/{$user.referrer_code}" style="display: inherit;">
					<input type="text" id="register_referrer_code" name="register_referrer_code" value="idal.co/{$user.referrer_code}" disabled="disabled"/>
				</span>
			</div>
			<div class="column" style="max-width: 50%;">
				<p style="padding: 0.5em; border: 1px solid rgba(227, 227, 227, 0.4); border-radius: 2px;">Book direct jobs by sharing your link. Copy and paste the link for instance into your social media profiles, on your modelling website or send it in emails.</p>
			</div>
		</div>
		
		<div class="row">
			<div class="column">
				<h2>Financial Details</h2>
			</div>
		</div>
		{*
		<div class="row">
			<div class="column">
				<label for="hourlyrate">Minimum Hourly Rate</label>
				<input type="text" id="hourlyrate" name="hourly input" placeholder="Hourly Rate" value="{$user.profile.hourlyrate}">
			</div>
			<div class="column">
				<label for="dailyrate">Minimum Daily Rate</label>
				<input type="text" id="dailyrate" name="daily input" placeholder="Daily Rate" value="{$user.profile.dailyrate}">
			</div>
		</div>
		*}
		{if $missingbank != ''}
		<div class="row">
			<div class="column">
				<div class="notice">
					<p>We are missing your {$missingbank}. Make sure to fill the missing details so we can pay you!</p>
				</div>
			</div>
		</div>
		{/if}
		<div class="row">
			<div class="column">
				<h3>Enter your UK bank account details</h3>
			</div>
		</div>
			
		<div class="row">
			<div class="column">
				<label for="sortcode">Sort Code</label>
				<input type="text" name="sortcode input" id="sortcode" placeholder="xx-xx-xx" value="{$user.bank_sortcode}">
			</div>
			<div class="column">
				<label for="accountnumber">Account Number</label>
				<input type="text" name="accountnumber input" id="accountnumber" placeholder="xxxxxxxx" value="{$user.bank_accountnumber}">
			</div>
			{if $user.usertype eq 1}
			<div class="column" style="position: relative; display: inline-block;">
				<label style="display: inline-block; position: relative;" for="vatnumber">VAT Number{if $user.usertype eq 1}<div class="infoballoon" data-balloon-length="medium" data-balloon="We need this to make sure we pay you VAT if necessary. If you don't have a VAT number we won't include VAT in your invoice." data-balloon-pos="up"><img src="/images/info_icon.png" /></div>{/if}</label>
				<input type="text" id="vatnumber" name="vatnumber input" value="{$user.vat_number}" placeholder="(optional)">
			</div>
			{/if}
			
		</div>
	
		<div class="row">
			<div class="column">
				<h3>Or your IBAN number if you have a European bank account</h3>
			</div>
		</div>
	
		
		<div class="row">
			<div class="column">
				<label for="iban">IBAN Number</label>
				<input type="text" name="iban input" id="iban" placeholder="xxxxxxxx" value="{$user.bank_iban}">
			</div>
		</div>
	
		{/if}
		<div class="row desktop">
			<div class="column"></div>
			<div class="column text-center">
				<a class="button cancel" href="/">Cancel</a>
			</div>
			<div class="column text-center">
				<a class="button inverted saveprofile">Save Changes</a>
			</div>
			<div class="column"></div>
		</div>
		<div class="row mobile">
			<div class="column text-center">
				<a class="button inverted saveprofile m-small">Save Changes</a>
			</div>
		</div>
	</div>
	
	<div class="panel profile profileditor" id="tab-measurements-panel">
		{if $usertype eq 1}
		<div class="row">
			<div class="column">
				<h2>Measurements</h2>
				<p>Please enter your measurements below. You can tap <b>cm</b> to switch between centimeters and feet/inches.</p>
			</div>
		</div>	
		<div class="row">
			<div class="column">
				<div class="measurements-input heightinput">
					<span class="cm-or-feet" data-balloon="Tap to switch between centimeters and feet" data-balloon-pos="up" data-balloon-length="medium" data-measuretype="cm"><span style="text-decoration: underline; font-weight: bold;">cm</span> / <span>ft</span></span>
					<label class="required" for="height">Height<span> *</span></label>
					<input type="text" id="height" name="height input" value="{$user.profile.height}">
					<input type="hidden" name="height_type" value="cm" />
				</div>
			</div>
			<div class="column">
				<div class="measurements-input">
					<span class="cm-or-inches" data-balloon="Tap to switch between centimeters and inches" data-balloon-pos="up" data-balloon-length="medium" data-measuretype="cm"><span style="text-decoration: underline; font-weight: bold;">cm</span> / <span>in</span></span>
					<label class="required" for="waist">Waist<span> *</span></label>
					<input type="text" id="waist" name="waist input" value="{$user.profile.waist}">
					<input type="hidden" name="waist_type" value="cm" />
				</div>
			</div>
			
			<div class="column">
				<div class="measurements-input">
					<span class="cm-or-inches" data-balloon="Tap to switch between centimeters and inches" data-balloon-pos="up" data-balloon-length="medium" data-measuretype="cm"><span style="text-decoration: underline; font-weight: bold;">cm</span> / <span>in</span></span>
					<label class="required" for="hips">Hips<span> *</span></label>
					<input type="text" id="hips" name="hips input" value="{$user.profile.hips}">
					<input type="hidden" name="hips_type" value="cm" />
				</div>
			</div>
		</div>
		<div class="row">
			{if $gender eq 'male'}
			<div class="column">
				<div class="measurements-input">
					<span class="cm-or-inches" data-balloon="Tap to switch between centimeters and inches" data-balloon-pos="up" data-balloon-length="medium" data-measuretype="cm"><span style="text-decoration: underline; font-weight: bold;">cm</span> / <span>in</span></span>
					<label class="required" for="bust">Chest<span> *</span></label>
					<input type="text" id="bust" name="bust input" value="{$user.profile.bust}">
					<input type="hidden" name="bust_type" value="cm" />
				</div>
			</div>
			{else if $gender eq 'female'}
			<div class="column">
				<div class="measurements-input">
					<span class="cm-or-inches" data-balloon="Tap to switch between centimeters and inches" data-balloon-pos="up" data-balloon-length="medium" data-measuretype="cm"><span style="text-decoration: underline; font-weight: bold;">cm</span> / <span>in</span></span>
					<label class="required" for="bust">Bust<span> *</span></label>
					<input type="text" id="bust" name="bust input" value="{$user.profile.bust}">
					<input type="hidden" name="bust_type" value="cm" />
				</div>
			</div>
			<div class="column">
				<div class="measurements-input">
					<label for="cupsize">Cup size</label>
					<div class="select-wrap">
						<select name="cupsize" class="select">
							<option value="-1" disabled="disabled"{if $user.profile.cupsize eq -1} selected="selected"{/if}>Please choose</option>
							<option value="0"{if $user.profile.cupsize eq 0} selected="selected"{/if}>AA</option>
							<option value="1"{if $user.profile.cupsize eq 1} selected="selected"{/if}>A</option>
							<option value="2"{if $user.profile.cupsize eq 2} selected="selected"{/if}>B</option>
							<option value="3"{if $user.profile.cupsize eq 3} selected="selected"{/if}>C</option>
							<option value="4"{if $user.profile.cupsize eq 4} selected="selected"{/if}>D</option>
							<option value="5"{if $user.profile.cupsize eq 5} selected="selected"{/if}>DD</option>
							<option value="6"{if $user.profile.cupsize eq 6} selected="selected"{/if}>E</option>
							<option value="7"{if $user.profile.cupsize eq 7} selected="selected"{/if}>F</option>
							<option value="8"{if $user.profile.cupsize eq 8} selected="selected"{/if}>FF</option>
							<option value="9"{if $user.profile.cupsize eq 9} selected="selected"{/if}>G</option>
							<option value="10"{if $user.profile.cupsize eq 10} selected="selected"{/if}>H</option>
							<option value="11"{if $user.profile.cupsize eq 11} selected="selected"{/if}>HH</option>
							<option value="12"{if $user.profile.cupsize eq 12} selected="selected"{/if}>I</option>
							<option value="13"{if $user.profile.cupsize eq 13} selected="selected"{/if}>J</option>
							<option value="14"{if $user.profile.cupsize eq 14} selected="selected"{/if}>JJ</option>
							<option value="15"{if $user.profile.cupsize eq 15} selected="selected"{/if}>K</option>
						</select>
					</div>
				</div>
			</div>
			{else}
			<div class="column">
				<div class="measurements-input">
					<span class="cm-or-inches" data-balloon="Tap to switch between centimeters and inches" data-balloon-pos="up" data-balloon-length="medium" data-measuretype="cm"><span style="text-decoration: underline; font-weight: bold;">cm</span> / <span>in</span></span>
					<label class="required" for="bust">Chest/Bust<span> *</span></label>
					<input type="text" id="bust" name="bust input" value="{$user.profile.bust}">
					<input type="hidden" name="bust_type" value="cm" />
				</div>
			</div>
			<div class="column">
				<div class="measurements-input">
					<label for="cupsize">Cup size</label>
					<div class="select-wrap">
						<select name="cupsize" class="select">
							<option value="-1" disabled="disabled"{if $user.profile.cupsize eq -1} selected="selected"{/if}>Please choose</option>
							<option value="0"{if $user.profile.cupsize eq 0} selected="selected"{/if}>AA</option>
							<option value="1"{if $user.profile.cupsize eq 1} selected="selected"{/if}>A</option>
							<option value="2"{if $user.profile.cupsize eq 2} selected="selected"{/if}>B</option>
							<option value="3"{if $user.profile.cupsize eq 3} selected="selected"{/if}>C</option>
							<option value="4"{if $user.profile.cupsize eq 4} selected="selected"{/if}>D</option>
							<option value="5"{if $user.profile.cupsize eq 5} selected="selected"{/if}>DD</option>
							<option value="6"{if $user.profile.cupsize eq 6} selected="selected"{/if}>E</option>
							<option value="7"{if $user.profile.cupsize eq 7} selected="selected"{/if}>F</option>
							<option value="8"{if $user.profile.cupsize eq 8} selected="selected"{/if}>FF</option>
							<option value="9"{if $user.profile.cupsize eq 9} selected="selected"{/if}>G</option>
							<option value="10"{if $user.profile.cupsize eq 10} selected="selected"{/if}>H</option>
							<option value="11"{if $user.profile.cupsize eq 11} selected="selected"{/if}>HH</option>
							<option value="12"{if $user.profile.cupsize eq 12} selected="selected"{/if}>I</option>
							<option value="13"{if $user.profile.cupsize eq 13} selected="selected"{/if}>J</option>
							<option value="14"{if $user.profile.cupsize eq 14} selected="selected"{/if}>JJ</option>
							<option value="15"{if $user.profile.cupsize eq 15} selected="selected"{/if}>K</option>
						</select>
					</div>
				</div>
			</div>
			{/if}
		</div>
	
		<div class="row">
			{if $gender eq 'female' || $gender eq 'other'}
			<div class="column">
				<label class="required" for="dresssize">Dress Size<span> *</span></label>
				<div class="select-wrap">
					<select name="dresssize input" id="dresssize" class="select">
						<option disabled="disabled"{if $user.profile.dresssize eq ''} selected="selected"{/if} value="0">Please choose</option>
						{foreach from=$details.dresssizes item=dresssize}
						<option value="{$dresssize.value}"{if $user.profile.dresssize eq $dresssize.value} selected="selected"{/if}>{$dresssize.description}</option>
						{/foreach}
					</select>
				</div>
			</div>
			{/if}
			{if $gender eq 'male' || $gender eq 'other'}
			<div class="column">
				<label class="required" for="suitsize">Suit Size<span> *</span></label>
				<div class="select-wrap">
					<select name="suitsize input" id="suitsize" class="select">
						<option disabled="disabled"{if $user.profile.suitsize eq ''} selected="selected"{/if} value="0">Please choose</option>
						{foreach from=$details.suitsize item=suitsize}
						<option value="{$suitsize.value}"{if $user.profile.suitsize eq $suitsize.value} selected="selected"{/if}>{$suitsize.description}</option>
						{/foreach}
					</select>
				</div>
			</div>
			{/if}
			{if $gender eq 'male'}
			<div class="column">
				<div class="measurements-input">
					<span class="cm-or-inches" data-balloon="Tap to switch between centimeters and inches" data-balloon-pos="up" data-balloon-length="medium" data-measuretype="cm"><span style="text-decoration: underline; font-weight: bold;">cm</span> / <span>in</span></span>
					<label class="required" for="collar">Collar size<span> *</span></label>
					<input type="text" id="collar" name="collar input" value="{$user.profile.collar_size}">
					<input type="hidden" name="collar_type" value="cm" />
				</div>
			</div>
			{/if}
	
			<div class="column">
				<label class="required" for="shoesize">Shoe Size<span> *</span></label>
				<div class="select-wrap">
					<select name="shoesize input" id="shoesize" class="select">
						<option disabled="disabled"{if $user.profile.shoesize eq 0} selected="selected"{/if} value="0">Please choose</option>
						{foreach from=$details.shoesizes item=shoesize}
						<option value="{$shoesize.value}"{if $user.profile.shoesize eq $shoesize.value} selected="selected"{/if}>{$shoesize.description}</option>
						{/foreach}
					</select>
				</div>
			</div>
	
		</div>
	
		<div class="row">
			<div class="column">
				<label class="required" for="haircolour">Hair Colour<span> *</span></label>
				<div class="select-wrap">
					<select name="haircolour input" id="hairtype" class="select">
						<option disabled="disabled"{if $user.profile.haircolour_tid eq 0} selected="selected"{/if} value="0">Please choose</option>
						{foreach from=$haircolours item=haircolour name=haircolour}
						<option value="{$haircolour.tid}"{if $user.profile.haircolour_tid eq $haircolour.tid} selected="selected"{/if}>{$haircolour.name}</option>
						{/foreach}
					</select>
				</div>
			</div>
			
			<div class="column">
				<label class="required" for="hairtype">Hair Type<span> *</span></label>
				<div class="select-wrap">
					<select name="hairtype input" id="hairtype" class="select">
						<option disabled="disabled"{if $user.profile.hairtype_tid eq 0} selected="selected"{/if} value="0">Please choose</option>
						{foreach from=$hairtypes item=hairtype name=hairtype}
						<option value="{$hairtype.tid}"{if $user.profile.hairtype_tid eq $hairtype.tid} selected="selected"{/if}>{$hairtype.name}</option>
						{/foreach}
					</select>
				</div>
			</div>
			<div class="column">
				<label class="required" for="hairlength">Hair Length<span> *</span></label>
				<div class="select-wrap">
					<select name="hairlength input" id="hairlength" class="select">
						<option disabled="disabled"{if $user.profile.hairlength_tid eq 0} selected="selected"{/if} value="0">Please choose</option>
						{foreach from=$hairlengths item=hairlength name=hairlength}
						<option value="{$hairlength.tid}"{if $user.profile.hairlength_tid eq $hairlength.tid} selected="selected"{/if}>{$hairlength.name}</option>
						{/foreach}
					</select>
				</div>
			</div>
			<div class="column">
				<label for="willingtodye">Willing to colour?</label>
				<div class="select-wrap">
					<select name="willingtodye input" id="willingtodye" class="select">
						<option value="yes"{if $user.profile.willingtodye eq 1} selected="selected"{/if}>Yes</option>
						<option value="no"{if $user.profile.willingtodye eq 0} selected="selected"{/if}>No</option>
					</select>
				</div>
			</div>
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
				<label class="required" for="eyecolour">Eye Colour<span> *</span></label>
				<div class="select-wrap">
					<select name="eyecolour input" id="eyecolour" class="select">
						<option disabled="disabled"{if $user.profile.eyecolour_tid eq 0} selected="selected"{/if} value="0">Please choose</option>
						{foreach from=$eyecolours item=eyecolour name=eyecolour}
						<option value="{$eyecolour.tid}"{if $user.profile.eyecolour_tid eq $eyecolour.tid} selected="selected"{/if}>{$eyecolour.name}</option>
						{/foreach}
					</select>
				</div>
			</div>
			
			<div class="column">
				<label class="required" for="skintone">Skin tone</label>
				<div class="select-wrap">
					<select name="skintone input" id="skintone" class="select">
						<option disabled="disabled"{if $user.profile.skintone_tid eq 0} selected="selected"{/if} value="0">Please choose</option>
						{foreach from=$skintones item=skintone name=skintone}
						<option value="{$skintone.tid}"{if $user.profile.skintone eq $skintone.tid} selected="selected"{/if}>{$skintone.name}</option>
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
			
			<div class="column">
				<label for="ringsize">Ring Size</label>
				<div class="select-wrap">
					<select name="ringsize input" id="ringsize" class="select">
						<option value=" "{if $user.profile.ringsize eq $i} selected="selected"{/if}>(not set)</option>
						{foreach item=i from='J'|@range:'Z'}
						<option value="{$i}"{if $user.profile.ringsize eq $i} selected="selected"{/if}>{$i}</option>
						{/foreach}
					</select>
				</div>
			</div>
			
			<div class="column">
				<label class="required" for="tattoo">Tattoos?<span> *</span></label>
				<div class="select-wrap">
					<div class="select-wrap">
						<select name="tattoo input" id="tattoo" class="select">
							<option value="yes"{if $user.profile.tattoo eq 1} selected="selected"{/if}>Yes</option>
							<option value="no"{if $user.profile.tattoo eq 0} selected="selected"{/if}>No</option>
						</select>
					</div>
	
				</div>
			</div>
			<div class="column">
				<label class="required" for="drivinglicense">Driver's license?<span> *</span></label>
				<div class="select-wrap">
					<div class="select-wrap">
						<select name="drivinglicense input" id="drivinglicense" class="select">
							<option value="yes"{if $user.profile.drivinglicense eq 1} selected="selected"{/if}>Yes</option>
							<option value="no"{if $user.profile.drivinglicense eq 0} selected="selected"{/if}>No</option>
						</select>
					</div>
				</div>
			</div>
			
		</div>
	
		{/if}
		
		<div class="row desktop">
			<div class="column"></div>
			<div class="column text-center">
				<a class="button cancel" href="/">Cancel</a>
			</div>
			<div class="column text-center">
				<a class="button inverted saveprofile">Save Changes</a>
			</div>
			<div class="column"></div>
		</div>
		<div class="row mobile">
			<div class="column text-center">
				<a class="button inverted saveprofile m-small">Save Changes</a>
			</div>
		</div>
	</div>
	
	{if $usertype eq 1}
	<div class="panel profile profileditor" id="tab-experience-panel">
		<div class="">
			<h2>Experience</h2>
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
		<div class="row desktop">
			<div class="column"></div>
			<div class="column text-center">
				<a class="button cancel" href="/">Cancel</a>
			</div>
			<div class="column text-center">
				<a class="button inverted saveprofile">Save Changes</a>
			</div>
			<div class="column"></div>
		</div>
		<div class="row mobile">
			<div class="column text-center">
				<a class="button inverted saveprofile m-small">Save Changes</a>
			</div>
		</div>
	</div>
	{/if}
	<div class="panel profile profileditor" id="tab-preferences-panel">
		<div class="row">
			<div class="column">
				<h2>Preferences</h2>
			</div>
		</div>
	
		<div class="row">
			<div class="column"><b>Email me when:</b></div>
		</div>
		<div class="row alternate">
			<div class="column">A friend uses my referrer code</div>
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
	
		<div class="row">
			<div class="column">A job I am working on is changed</div>
			<div class="column text-right">
				<input class="tgl tgl-slider" id="email_changed" type="checkbox" name="job_changed"{if $user.prefs.job_changed eq 1} checked="checked" {/if}/>
				<label class="tgl-btn" for="email_changed"></label>
			</div>
		</div>
	
		<div class="row">
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
	
		<div class="row desktop">
			<div class="column"></div>
			<div class="column text-center">
				<a class="button cancel" href="/">Cancel</a>
			</div>
			<div class="column text-center">
				<a class="button inverted saveprofile">Save Changes</a>
			</div>
			<div class="column"></div>
		</div>
		<div class="row mobile">
			<div class="column text-center">
				<a class="button inverted saveprofile m-small">Save Changes</a>
			</div>
		</div>
	</div>
		
		{if $usertype eq 2}
		<div class="panel profile profileditor" id="tab-affiliates-panel">
		{* include file="user/profile/affiliates.tpl" *}
		</div>
		{/if}
	
	<div class="panel profile profileditor" id="tab-password-panel">
		<div class="row">
			<div class="column">
				<h2>Password Management</h2>
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
		<div class="row desktop">
			<div class="column"></div>
			<div class="column text-center">
				<a class="button cancel" href="/">Cancel</a>
			</div>
			<div class="column text-center">
				<a class="button inverted saveprofile">Save Changes</a>
			</div>
			<div class="column"></div>
		</div>
		<div class="row mobile">
			<div class="column text-center">
				<a class="button inverted saveprofile m-small">Save Changes</a>
			</div>
		</div>
	</div>
	
	<div class="panel profile profileditor" id="tab-deleteaccount-panel">
		{if $usertype eq 1}
		<div class="row">
			<div class="column">
				<h2>Hide your Account</h2>
				<p>Instead of removing your account, you can hide yourself completely. Would you like to do this?</p>
			</div>
			<div class="column text-right">
				<form id="form_calendar" method="post" action="/user/calendar/update">
					<p>Hide your account&nbsp;
						<input class="tgl tgl-slider" id="available" type="checkbox" name="available input"{if $user.available eq 0} checked="checked" {/if}/>
						<label class="tgl-btn" for="available" style="position: relative; top: 5px;"></label>
					</p>
				</form>
			
			</div>
		</div>
		<div class="seperator" data-gap="2"></div>
		<div class="seperator" data-gap="2"></div>
		<hr>
		{/if}
		<div class="seperator" data-gap="1"></div>
		<div class="row">
			<div class="column notice">
				<p class="text-center text-bold" style="margin-bottom: 1em; font-size: 1.25rem;">To disable your account, please press the button below.</p>
				<p>If you disable your account you will not be able to log in and {if $usertype eq 1}you will not appear in search{else}all your projects will be hidden{/if}.</p>
				{* <p>This will remove all your details from our platform, including bank details and all your uploaded photographs. You will not be able to recover any of this information.</p> *}
				<p>We will retain your email address, so you will not be able to re-register using this address.</p>
				<p>If you want to rejoin iDAL, please email us.</p>
			</div>
		</div>
		<div class="row">
			<div class="column text-center">
				<a href="/user/delete" class="delete button errorbutton">Disable Account</a>
			</div>
		</div>
	</div>
</div>
{include file="user/profile/companydetails.tpl"}