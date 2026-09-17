<div class="row">
	{* select model *}
	<div class="column step1 model noselect" data-type="model">
		<div class="register-modal model">
			<div class="register-modal-hover">
				<p class="jointext">I'm a<br /><span>model</span></p>
			</div>
		</div>
	</div>
	{* show brand form *}
	<div class="column step2 brand modalWhite">
		<form class="callout brand" action="/user/register" method="post" id="register-form-brand">
			<div id="register">
				<div class="row">
					<div class="column">
						<label for="firstname">First Name</label>
						<input type="text" id="brand_register_firstname" name="firstname input" placeholder="First Name" class="errorpad">
					</div>
					<div class="column">
						<label for="lastname">Last Name</label>
						<input type="text" id="brand_register_lastname" name="lastname input" placeholder="Last Name" class="errorpad">
					</div>
				</div>
				<div class="row">
					<div class="column" style="position: relative;">
						<label for="email">Company Email</label>
						<input type="email" id="brand_register_email" name="mail input" placeholder="Company Email" class="errorpad">
					</div>
				</div>
				<div class="row">
					<div class="column">
						<label for="company">Company name</label>
						<input type="text" id="brand_register_company" name="company input" placeholder="Company name" class="errorpad">
					</div>
					<div class="column">
						<label for="website">Company Website</label>
						<input type="text" id="brand_register_website" name="website input" placeholder="Website address" class="errorpad">
					</div>
				</div>
				<div class="row">
					<div class="column">
						<label for="occupation">Position</label>
						<input type="text" id="brand_register_occupation" name="occupation input" placeholder="Position" class="errorpad">
					</div>
					<div class="column">
						<label for="telephone">Telephone</label>
						<input type="text" id="brand_register_telephone" name="telephone input" placeholder="Telephone number" class="errorpad">
					</div>
				</div>
				<div class="row">
					<div class="column">
						<label for="pass">Password</label>
						<input type="password" id="brand_register_pass" name="password input" placeholder="Password" class="errorpad">
					</div>
					<div class="column">
						<label for="pass">Repeat Password</label>
						<input type="password" id="brand_register_confirmpass" name="password input" placeholder="Password">
					</div>
				</div>
				<div class="row">
					<div class="column">
						<p class="errorpad"><input type="checkbox" id="brand_register_terms" name="terms input"> I agree to the iDAL <a href="/terms">Terms & Conditions</a> and <a href="/privacy">Privacy Policy</a> and the and the <a href="https://stripe.com/connect-account/legal">Stripe Connected Account Agreement</a>.</p>
						<p>All accounts registered with iDAL are subject to verification. Until verification is complete your access to iDAL will be limited to viewing your own profile.</p>
					</div>
				</div>
				<div class="row">
					<div class="column align-center">
						<a id="brandregister" style="margin-top: 1em;" class="button bg-purple white hvr hvr-black">OK</a>
					</div>
					<div class="column align-center">
						<a style="margin-top: 1em;" class="button bg-black white hvr hvr-darkyellow closeform hover-textblack">cancel</a>
						</div>
					</div>
			
				</div>
				<input type="hidden" name="step" value="account" />
				<input type="hidden" name="usertype" value="brand" />
			</form>
		</div>
		
		{* select brand *}
		<div class="column step1 brand noselect" data-type="brand">
			<div class="register-modal brand">
				<div class="register-modal-hover">
					<p class="jointext">I'm a<br /><span>creative</span></p>
				</div>
			</div>
		</div>
		{* show model form *}
		<div class="column step2 model modalWhite">

			<form class="callout model" action="/user/register" method="post" id="register-form-model">
				<div id="register">
					<div class="model_error_messages"></div>
					<div class="row">
						<div class="column">
							<label for="firstname">First Name</label>
							<input type="text" id="model_register_firstname" name="firstname input" placeholder="First Name" class="errorpad">
						</div>
						<div class="column">
							<label for="lastname">Last Name</label>
							<input type="text" id="model_register_lastname" name="lastname input" placeholder="Last Name" class="errorpad">
						</div>
					</div>
					<div class="row">
						<div class="column" style="position: relative;">
							<label for="email">Email</label>
							<input type="email" id="model_register_email" name="mail input" placeholder="Email" class="errorpad">
						</div>
						<div class="column">
							<label for="instagram">Instagram</label>
							<input type="text" id="model_register_instagram" name="instagram input" placeholder="@">
						</div>
					</div>
					<div class="row">
						<div class="column">
							<label for="gender">Gender</label>
							<div class="select-wrap">
								<select name="register_gender input" id="model_gender" class="select">
									<option value="female">Female</option>
									<option value="male">Male</option>
								</select>
							</div>
						</div>
						<div class="column">
							<label for="referral">Referral Code</label>
							<input type="text" id="model_referral_code" name="referral input" placeholder="Enter code if you have one">
						</div>
					</div>
					<div class="row">
						<div class="column">
							<label for="pass">Password</label>
							<input type="password" id="model_register_pass" name="password input" placeholder="Password" class="errorpad">
						</div>
						<div class="column">
							<label for="pass">Repeat Password</label>
							<input type="password" id="model_register_confirmpass" name="password input" placeholder="Password" class="errorpad">
						</div>
					</div>
					<div class="row">
						<div class="column">
							<p class="errorpad"><input type="checkbox" id="model_register_terms" name="terms input"> I agree to the iDAL <a href="/terms">Terms & Conditions</a> and <a href="/privacy">Privacy Policy</a> and the and the <a href="https://stripe.com/connect-account/legal">Stripe Connected Account Agreement</a>.</p>
							<p>All accounts registered with iDAL are subject to verification. Until verification is complete your access to iDAL will be limited to viewing your own profile.</p>
						</div>
					</div>
					<div class="row">
						<div class="column align-center">
							<a id="modelregister" style="margin-top: 1em;" class="button bg-darkyellow white hvr hvr-black">OK</a>
					</div>
					<div class="column align-center">
						<a style="margin-top: 1em;" class="button bg-black white hvr hvr-darkyellow hover-textblack closeform">cancel</a>
					</div>
				</div>
			</div>
			<input type="hidden" name="step" value="account" />
			<input type="hidden" name="usertype" value="model" />
		</form>


	</div>

</div>
