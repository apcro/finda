{extends "user/layout_userdetails.tpl"}

<div class="row mobile">
	<div class="column">
		<p class="notice">Please use your desktop or laptop to enjoy all our features. The iDAL app is coming soon!</p>
	</div>
</div>
{block name="main"}
<section class="worko-tabs profile">
	<input class="tabstate myprofiletabs" type="radio" title="tab-profile" name="tabs-state" id="tab-profile" checked="checked" />
	{if $usertype eq 1}<input class="tabstate" type="radio" title="tab-measurements" name="tabs-state" id="tab-measurements" />{/if}
	{if $usertype eq 1}<input class="tabstate" type="radio" title="tab-experience" name="tabs-state" id="tab-experience" />{/if}
	{if $usertype eq 1}<input class="tabstate" type="radio" title="tab-preferences" name="tabs-state" id="tab-preferences" />{/if}
	{if $usertype eq 2}<input class="tabstate myprofiletabs" type="radio" title="tab-affiliates" name="tabs-state" id="tab-affiliates" />{/if}
	<input class="tabstate myprofiletabs" type="radio" title="tab-password" name="tabs-state" id="tab-password" />
	<input class="tabstate myprofiletabs" type="radio" title="tab-deleteaccount" name="tabs-state" id="tab-deleteaccount" />
	<input class="tabstate companyprofiletabs" type="radio" title="tab-companyinformation" name="tabs-state" id="tab-companyinformation" checked="checked" />
	<input class="tabstate companyprofiletabs" type="radio" title="tab-companymembers" name="tabs-state" id="tab-companymembers" />
	<div class="tabs flex-tabs">
		<div class="tab-scroll">
			<label for="tab-profile" id="tab-profile-label" class="tab myprofiletabs">Profile</label>
			{if $usertype eq 1}<label for="tab-measurements" id="tab-measurements-label" class="tab myprofiletabs">Measurements</label>{/if}
			{if $usertype eq 1}<label for="tab-preferences" id="tab-preferences-label" class="tab myprofiletabs">Preferences</label>{/if}
			<label for="tab-password" id="tab-password-label" class="tab myprofiletabs">Change Password</label>
			<label for="tab-deleteaccount" id="tab-deleteaccount-label" class="tab myprofiletabs">Disable Account</label>
			
			<label for="tab-companyinformation" id="tab-companyinformation-label" class="tab companyprofiletabs">Company Information</label>
			<label for="tab-companymembers" id="tab-companymembers-label" class="tab companyprofiletabs">Company Members</label> 
			
			
		</div>
		{include file="user/profile/$secondary.tpl"}
	</div>
</section>
{/block}