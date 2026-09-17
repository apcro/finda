<div class="blockcompanydetails">

	<div class="panel profile profileditor" id="tab-companyinformation-panel">
		<div class="row">
			<div class="column">
				<img style="border-radius: 2px" class="normal_site" src="/companylogos/{$companydetails.logo}"/>
			</div>
		</div>
		<div class="row">
			<div class="column">
				<div data-balloon="Please contact us if you want to change this" data-balloon-pos="up">
					<label for="companyname">Company Name</label>
					<input type="text" name="companyname" id="companyname" value="{$companydetails.companyname}" disabled="disabled">
				</div>
			</div>
			<div class="column">
				<div data-balloon="Please contact us if you want to change this" data-balloon-pos="up">
					<label for="companywebsite">Company Website</label>
					<input type="text" name="companywebsite" id="companywebsite" value="{$companydetails.website}" disabled="disabled">
				</div>
			</div>
			<div class="column" >
				{if !$user.is_companyadmin}<div data-balloon="Please contact us if you want to change this" data-balloon-pos="up">{/if}
					<label for="vatnumber">VAT Number</label>
					<input type="text" id="companyvatnumber" name="companyvatnumber" value="{$companydetails.vatnumber}"{if !$user.is_companyadmin} disabled="disabled"{/if}>
				{if !$user.is_companyadmin}</div>{/if}
			</div>
		</div>
		<div class="row">
			<div class="column">
				{if !$user.is_companyadmin}<div data-balloon="Only your company administrator can change this" data-balloon-pos="up">{/if}
					<h4>Company Invoice Details</h4>
					<p>Enter the name and address for use on company invoices</p>
					<textarea name="companyinvoicedetails" rows="10"{if !$user.is_companyadmin} disabled="disabled"{/if}>{$companydetails.invoicedetails}</textarea>
				{if !$user.is_companyadmin}</div>{/if}
			</div>
		</div>
		<div class="row">
			<div class="column">
				<h4>iDAL contact</h4>
				<p>{$companydetails.contactname}</p>
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

	</div>
	<div class="panel profile profileditor" id="tab-companymembers-panel">
		<div class="row">
			<div class="column">
				<h4>Other members</h4>
				<ul>
					{foreach from=$companydetails.members item=member}
					<li>{$member.firstname} {$member.lastname} (email: <a href="mailto:{$member.mail}">{$member.mail}</a>{if $member.telephone}, telephone: <a href="tel:{$member.telephone}">{$member.telephone}</a>{/if})</li>
					{/foreach}
				</ul>
			</div>
		</div>
		<hr />
		<div class="row">
			<div class="column">
				<h3>Invite another member</h3>
				<p>Enter the email address of someone else in your company you would like to join iDAL.<br /><br /></p>
			</div>
		</div>

		<div class="row">
			<div class="column">
				<label for="new_email">Email address</label>
				<input type="text" name="new_email" id="new_email" />
			</div>
			<div class="column text-right">
				<a class="button burgundy inviteuser">Send Invitation</a>
			</div>
		</div>
	</div>
</div>