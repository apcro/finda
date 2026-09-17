{extends "motheragencies/layout_dashboard.tpl"}

{block name="main"}
<div class="row">
	<div class="column">
		<h2>Manage {$user.firstname} {$user.lastname}'s Profile</h2>
	</div>
	<div class="column text-right">
		<img src="/{$user.imagetype}/thumb/{$user.filename}" width=100 style="border-radius: 5px;"/>
	</div>
</div>
<section class="worko-tabs profile">
	<input class="tabstate myprofiletabs" type="radio" title="tab-profile" name="tabs-state" id="tab-profile" checked="checked" />
	<input class="tabstate" type="radio" title="tab-measurements" name="tabs-state" id="tab-measurements" />
	<input class="tabstate myprofiletabs" type="radio" title="tab-deleteaccount" name="tabs-state" id="tab-deleteaccount" />
	<input class="tabstate myimagesportfoliotabs" type="radio" title="tab-imagesportfolio" name="tabs-state" id="tab-imagesportfolio" />
	<input class="tabstate myimagespolaroidstabs" type="radio" title="tab-imagespolaroids" name="tabs-state" id="tab-imagespolaroids" />
	<div class="tabs flex-tabs">
		<div class="tab-scroll">
			<label for="tab-profile" id="tab-profile-label" class="tab myprofiletabs">Profile</label>
			<label for="tab-measurements" id="tab-measurements-label" class="tab myprofiletabs">Measurements</label>
			<label for="tab-imagesportfolio" id="tab-imagesportfolio-label" class="tab myimagesportfoliotabs">Portfolio ({$portfolioimages|count})</label>
			<label for="tab-imagespolaroids" id="tab-imagespolaroids-label" class="tab myimagespolaroidstabs">Polaroids ({$polaroids|count})</label>
			<label for="tab-deleteaccount" id="tab-deleteaccount-label" class="tab myprofiletabs">Disable Account</label>
			
		</div>
		<div class="blockmydetails active">
			{if $user.instagram_username eq '' && $user.instagram_followers eq -1}
			<div class="row">
				<div class="column">
					<div class="notice">
						<p>We couldn't find {$user.firstname}'s Instagram username. {$user.firstname} won't appear in search without it.</p>
					</div>
				</div>
			</div>
			{/if}
			<div class="panel profile profileditor" id="tab-imagesportfolio-panel">
				<div class="row">
					<div class="column">
						<h2>Portfolio</h2>
						<p style="padding: 0.5em; border: 1px solid rgba(227, 227, 227, 0.4); border-radius: 2px;">Drag images to change the display order. Use the floating image menu to select a new leading image, or to remove an existing image.</p>
					</div>
					<div class="column text-right">
						<a class="button burgundy" href="/dashboard/images/{$user.id}">+ Add New Images</a>
					</div>
				</div>
				<div class="row portfolio" id="portfolioImages">
					{foreach from=$portfolioimages item=portfolio name=portfolio}
					<div class="column imagecol" id="image{$portfolio.id}" data-orderid="{$portfolio.id}">
						<div class="large reveal" id="imagePolModal{$smarty.foreach.portfolio.iteration}" data-reveal data-prev="{$portfolio.prev}" data-next="{$portfolio.next}">
							<a class="croissant-close mobile" title="Close"></a>
							<img id="modalImage{$portfolio.id}" src="{$smarty.const.CDN_ROOT}/portfolio/large{$portfolio.filename}" class="float-center" style="max-height: 100%;"/>
						</div>
						
						<div class="image_container">
							<div class="dots_menu">
								<div class="menudots"><i class="fas fa-ellipsis-h"></i></div>
								<div class="dotmenuitems">
									{if $portfolio.leadimage eq 0}
									<div><a class="mamakeleader" href="/user/portfolio/leader" data-id="{$portfolio.id}" data-balloon="Select as profile image" data-balloon-pos="up">Set as Main Image</a></div>
									{/if}
									<div><a class="maremove" href="/user/portfolio/remove" data-id="{$portfolio.id}" data-balloon="Remove image" data-balloon-pos="up">Remove</a></div>
								</div>
							</div>
				
							<div data-open="imagePolModal{$smarty.foreach.portfolio.iteration}" class="image" data-image="{$smarty.const.CDN_ROOT}/portfolio/large{$portfolio.filename}"><span class="{if $portfolio.leadimage eq 1}leader{/if}"><span class="image_fader"><img src="/images/loading-icon.gif" /></span></span></div>
						</div>
					</div>
					{/foreach}
				</div>
			</div>
			
			<div class="panel profile profileditor" id="tab-imagespolaroids-panel">
				<div class="row">
					<div class="column">
						<h2>Polaroids</h2>
						<p style="padding: 0.5em; border: 1px solid rgba(227, 227, 227, 0.4); border-radius: 2px;">Drag images to change the display order. Use the floating image menu to select a new leading image, or to remove an existing image.</p>
					</div>
				<div class="column text-right">
						<a class="button burgundy" href="/dashboard/images/{$user.id}">+ Add New Images</a>
					</div>
				</div>
				<div class="row polaroids" id="polaroidImages">
					{foreach from=$polaroids item=polaroid name=polaroid}
					<div class="column imagecol" id="image{$polaroid.id}" data-orderid="{$polaroid.id}">
						<div class="large reveal" id="imagePolModal{$smarty.foreach.polaroid.iteration}" data-reveal>
							<a class="croissant-close mobile" title="Close"></a>
							<img src="{$smarty.const.CDN_ROOT}/polaroids/large{$polaroid.filename}" class="float-center" style="max-height: 100%;"/>
						</div>
						
						<div class="image_container">
								<div class="dots_menu">
								<div class="menudots"><i class="fas fa-ellipsis-h"></i></div>
								<div class="dotmenuitems">
									{if $polaroid.leadimage eq 0}
									<div><a class="mamakeleader" href="/user/polaroids/leader" data-id="{$polaroid.id}" data-balloon="Select as profile image" data-balloon-pos="up">Set as Main Image</a></div>
									{/if}
									<div><a class="maremove" href="/user/polaroid/remove" data-id="{$polaroid.id}" data-balloon="Remove image" data-balloon-pos="up">Remove</a></div>
								</div>
							</div>
						
							<div data-open="imagePolModal{$smarty.foreach.polaroid.iteration}" class="image image-{$polaroid.id}" data-image="{$smarty.const.CDN_ROOT}/polaroids/large{$polaroid.filename}"><span class="{if $polaroid.leadimage eq 1}leader{/if}"><span class="image_fader"><img src="/images/loading-icon.gif" /></span></span></div>
						</div>
					</div>
					{/foreach}
				</div>
			</div>
			
			
			
			<div class="panel active profile profileditor" id="tab-profile-panel">

				{* and so we can override the userid on save *}
				<input type="hidden" name="userid" value="{$user.id}">
				<input type="hidden" name="modelid" value="{$user.id}">

				<div class="row">
					<div class="column">
						<label class="required" for="register_firstname">First name<span> *</span></label>
						<input type="text" name="register_firstname" id="register_firstname" value="{$user.firstname}" />
					</div>
					<div class="column">
						<label class="required" for="register_lastname">Last Name<span> *</span></label>
						<input type="text" name="register_lastname" id="register_lastname" value="{$user.lastname}" />
					</div>
					<div class="column" style="position: relative; display: inline-block;">
						{if $user.dob neq 0}<div data-balloon="Please contact us if you want to change this" data-balloon-pos="up">{/if}
						<label style="display: inline-block; position: relative;" class="required" for="dob">Date of Birth<span> *</span></label>
						<input style="font-family: inherit; font-size: inherit;" type="date" id="dob" name="dob input" placeholder="dd/mm/YYYY" {if $user.dob neq 0}disabled{/if} value="{if $user.dob neq 0}{$user.dob|date_format:"%Y-%m-%d"}{/if}">
						{if $user.dob neq 0}</div>{/if}
						
					</div>
				</div>
				<div class="row">
					<div class="column" style="position: relative; display: inline-block;">
						<label class="required" style="display: inline-block; position: relative;" for="nationality">Nationality<span> *</span></label>
						
						<div class="select-wrap">
							<select name="nationality" class="form_select select" id="nationality" {if $user.nationality neq ''}disabled{/if}>
							{if $user.nationality neq ''}
							<option value="{$user.nationality}" selected="selected">{$user.nationality}</option>
							{else}
							{include file="user/countries.tpl"}
							{/if}
							</select>
						</div>
						
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
				</div>
				<div class="row">
					<div class="column">
						<label class="required" for="register_email">Email address<span> *</span></label>
						<input type="text" id="register_email" name="register_mail" value="{$user.mail}" />
						<span class="hide deny">Email address already in use</span>
					</div>
					<div class="column">
						<label for="telephone">Mobile Number</label>
						<input type="text" id="telephone" name="telephone input" placeholder="Mobile number" value="{$user.telephone}">
					</div>
				</div>
				<div class="row">
					<div class="column">
						<label class="required" for="gender">{$user.firstname} identifies as<span> *</span></label>
						<div class="select-wrap">
							<select name="gender input" id="gender" class="select">
								<option value="male"{if $user.gender eq 'male'} selected="selected"{/if}>Man</option>
								<option value="female"{if $user.gender eq 'female'} selected="selected"{/if}>Woman</option>
								<option value="other"{if $user.gender eq 'other'} selected="selected"{/if}>Non-binary</option>
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
						<textarea id="address" rows=4 placeholder="(Optional) Enter {$user.firstname}'s postal address" name="postal_address input">{$user.postal_address}</textarea>
					</div>
				</div>
			
				<div class="row">
					<div class="column">
						<h2>{$user.firstname}'s Personal Booking Link</h2>
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
						<p style="padding: 0.5em; border: 1px solid rgba(227, 227, 227, 0.4); border-radius: 2px;">Clients can book direct jobs by using {$user.firstname}'s link.</p>
					</div>
				</div>
				
				<div class="row">
					<div class="column">
						<h2>Financial Details</h2>
					</div>
				</div>
				{if $missingbank != ''}
				<div class="row">
					<div class="column">
						<div class="notice">
							<p>We are missing {$user.firstname}'s {$missingbank}. Make sure to fill the missing details so we can pay {$user.firstname}.</p>
						</div>
					</div>
				</div>
				{/if}
				<div class="row">
					<div class="column">
						<h3>Enter {$user.firstname}'s UK bank account details</h3>
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
					<div class="column" style="position: relative; display: inline-block;">
						<label style="display: inline-block; position: relative;" for="vatnumber">VAT Number{if $user.usertype eq 1}<div class="infoballoon" data-balloon-length="medium" data-balloon="We need this to make sure we pay you VAT if necessary. If you don't have a VAT number we won't include VAT in your invoice." data-balloon-pos="up"><img src="/images/info_icon.png" /></div>{/if}</label>
						<input type="text" id="vatnumber" name="vatnumber input" value="{$user.vat_number}" placeholder="(optional)">
					</div>
					
				</div>
			
				<div class="row">
					<div class="column">
						<h3>Or {$user.firstname}'s IBAN number for a European bank account</h3>
					</div>
				</div>
			
				
				<div class="row">
					<div class="column">
						<label for="iban">IBAN Number</label>
						<input type="text" name="iban input" id="iban" placeholder="xxxxxxxx" value="{$user.bank_iban}">
					</div>
				</div>
				
				<div class="row">
					<div class="column">
						<h2>Our Commission</h2>
					</div>
				</div>
				
				<div class="row">
					<div class="column">
						<label for="commission">Commission we charge from {$user.firstname}</label>
						<input type="text" name="commission input" id="commission" placeholder="%" value="{$user.motheragency_commission}">
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
			
			<div class="panel profile profileditor" id="tab-measurements-panel">
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
				<div class="row">
					<div class="column">
						<h2>Hide This Account</h2>
						<p>Hide this Model Account from the Talent Board?</p>
					</div>
					<div class="column text-right">
						<form id="form_calendar" method="post" action="/user/calendar/update">
							<p>Hide your account&nbsp;
								<input class="tgl tgl-slider" id="available" type="checkbox" name="available input"{if $user.available eq 0} checked="checked" {/if}/>
								<label class="tgl-btn" for="available" style="position: relative; top: 5px;"></label>
								<input type="hidden" name="modelid" value="{$user.id}">
							</p>
						</form>
					
					</div>
				</div>
				<div class="seperator" data-gap="2"></div>
				<div class="seperator" data-gap="2"></div>
				<hr>
				<div class="seperator" data-gap="1"></div>
				<div class="row">
					<div class="column notice">
						<p class="text-center text-bold" style="margin-bottom: 1em; font-size: 1.25rem;">To disable this account, please press the button below.</p>
						<p>If you disable this account the Model will not be able to log in and will not appear in on the IDAL Talent Board.</p>
						<p>We will retain the email address, so they will not be able to re-register using that address.</p>
						<p>If you want to re-enable this Model account on IDAL, please email us.</p>
					</div>
				</div>
				<div class="row">
					<div class="column text-center">
						<a href="/user/delete" class="delete button errorbutton" data-modelid="{$user.id}">Disable Account</a>
					</div>
				</div>
			</div>
		</div>
		{include file="user/profile/companydetails.tpl"}
		
	</div>
</section>
{/block}