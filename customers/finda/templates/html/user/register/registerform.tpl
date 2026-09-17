<h2>Register as a{if $usertype eq 'model'} Model{else} Brand{/if}</h2>
<div id="error_messages">
</div>
<form class="callout" action="/user/register" method="post" id="register-form">
	<div id="register">
		<label for="firstname">First Name</label>
		<input type="text" id="register_firstname" name="firstname input" placeholder="First Name">
		<label for="lastname">Last Name</label>
		<input type="text" id="register_lastname" name="lastname input" placeholder="Last Name">

		<label for="email">Email</label>
		<input type="email" id="register_email" name="mail input" placeholder="Email">

		{if $usertype eq 'model'}
		<label for="gender">I identify as</label>
		<div class="select-wrap">
			<select name="register_gender input" id="gender" class="select">
				<option value="female">Female</option>
				<option value="male">Male</option>
				<option value="other">Non-binary</option>
			</select>
		</div>

		<label for="referral">Referral Code</label>
		<input type="text" id="register_occupation" name="occupation input" placeholder="Occupation">

		{/if}
		{if $usertype eq 'agent'}
		<label for="occupation">Occupation</label>
		<input type="text" id="register_occupation" name="occupation input" placeholder="Occupation">

		<label for="company">Company name</label>
		<input type="text" id="register_company" name="company input" placeholder="Company name">

		<label for="website">Website</label>
		<input type="text" id="register_website" name="website input" placeholder="Website address">

		<label for="telephone">Telephone</label>
		<input type="text" id="register_telephone" name="telephone input" placeholder="Telephone number">
		{/if}
		<label for="pass">Password</label>
		<input type="password" id="register_pass" name="password input" placeholder="Password">
		<label for="pass">Repeat Password</label>
		<input type="password" id="register_confirmpass" name="password input" placeholder="Password">
		{if $usertype eq 'model'}
		<p>Were you told about us by a scout or a friend? If so, enter their email address here:</p>
		<input type="text" id="register_referrer" name="referrer input" placeholder="email address">
		{/if}
		<p><input type="checkbox" id="register_terms" name="terms input"> I agree to the <a href="/terms">Terms & Conditions</a> and the <a href="/privacy">Privacy Policy</a>.</p>
		<p>All accounts registered with iDAL are subject to verification. Until verification is complete your access to iDAL will be limited to viewing your own profile.</p>

	</div>
	<button class="button bg-purple white hvr hvr-black" type="submit" value="Register" name="register">Register</button>
	<input type="hidden" name="step" value="account" />
	<input type="hidden" name="usertype" value="{$usertype}" />
</form>