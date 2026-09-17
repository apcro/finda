<div class="row column register">
	<div class="row row-heading" style="width: 100%">
		<div class="column">
			<h1>Welcome to iDAL</h1>
			<p>You have been invited to join iDAL {if $inviter neq ''} by {$inviter} {/if}as part of <em>{$company.companyname}</em>. As you have received a personal invitation, your account will be verified immediately.</p>
			<p>&nbsp;</p>
			<p>Please fill in the details below and we will finish creating your account.</p>
		</div>
	</div>

	<form class="callout" action="/user/register" method="post" id="register-form">
		<div class="row">
			<div class="column">

				<div id="error_messages"></div>
				<label for="firstname">First Name</label>
				<input type="text" id="register_firstname" name="firstname input">
			</div>
			<div class="column">
				<label for="lastname">Last Name</label>
				<input type="text" id="register_lastname" name="lastname input">
			</div>
		</div>
		<div class="row">
			<div class="column">
				<label for="occupation">Job title</label>
				<input type="text" id="register_occupation" name="occupation input">
			</div>
		</div>
		<div class="row">
			<div class="column">
				<label for="email">Email</label>
				<input type="email" id="register_email" name="mail input">
			</div>
			<div class="column">
				<label for="telephone">Telephone</label>
				<input type="text" id="register_telephone" name="telephone input">
			</div>
		</div>
		<div class="row">
			<div class="column">
				<label for="pass">Password</label>
				<input type="password" id="register_pass" name="password input">
			</div>
			<div class="column">
				<label for="pass">Repeat Password</label>
				<input type="password" id="register_confirmpass" name="confirmpassword input">
			</div>
		</div>
		<div class="row">
			<div class="column">
				<p><input type="checkbox" id="register_terms" name="terms input"> I agree to the <a href="/terms">Terms & Conditions</a> and the <a href="/privacy">Privacy Policy</a>.</p>
			</div>
		</div>
		<div class="seperator" data-gap="2"></div>
		<div class="row">
			<div class="column text-center">
				<button class="button burgundy " id="brandregister" type="submit" value="Register" name="register">Register</button>
				<input type="hidden" name="step" value="account" />
				<input type="hidden" name="usertype" value="brand" />
				<input type="hidden" name="invite_code" value="{$invitecode}" />
			</div>
		</div>
		<div class="seperator" data-gap="4"></div>
		<div class="seperator" data-gap="4"></div>
	</form>
</div>
