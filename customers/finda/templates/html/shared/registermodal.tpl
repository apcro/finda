<svg class="tick-icon">
	<symbol id="check-tick" viewbox="0 0 15 12">
		<polyline points="1.5 6 4.5 9 10.5 1"></polyline>
	</symbol>
</svg>
<div class="row">
	{* show brand form *}
	<div class="column step2 brand modalWhite">
		<form class="callout brand" action="/user/register" method="post" id="register-form-brand">
			<div id="register">
				<div class="row">
					<div class="column">
						<p class="text-black" style="padding-left: 0; padding-right: 0; margin-bottom: 1em;">To be a client on iDAL, you need to be over 18 and work in the Fashion, Advertising and/or the Marketing industry.</p>
					</div>
				</div>
				<div class="row">
					<div class="column">
						<label for="firstname">First Name</label>
						<input type="text" id="brand_register_firstname" name="firstname input" placeholder="First Name" class="errorpad" required>
					</div>
					<div class="column">
						<label for="lastname">Last Name</label>
						<input type="text" id="brand_register_lastname" name="lastname input" placeholder="Last Name" class="errorpad" required>
					</div>
				</div>
				<div class="row">
					<div class="column" style="width: 100%;">
						<label for="company">Company name</label>
						<input type="text" id="brand_register_company" name="company input" placeholder="Company name" class="errorpad" required>
					</div>
					<div class="column" style="width: 100%;">
						<div class="fakeinput">
							<input type="checkbox" id="motheragency" name="motheragency input" class="errorpad main" style="display: none;">
							<label class="inside-label" for="motheragency"><span>
								<svg width="15px" height="12px">
									<use xlink:href="#check-tick"></use>
								</svg></span><span>Are you registering as a Mother Agency?</span></label>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="column" style="position: relative;">
						<label for="email">Company Email</label>
						<input type="email" id="brand_register_email" name="mail input" placeholder="Company Email" class="errorpad" required>
					</div>
					<div class="column">
						<label for="website">Company Website</label>
						<input type="text" id="brand_register_website" name="website input" placeholder="Website address" class="errorpad" required>
					</div>
				</div>
				<div class="row">
					<div class="column">
						<label for="occupation">Position</label>
						<input type="text" id="brand_register_occupation" name="occupation input" placeholder="Position" class="errorpad" required>
					</div>
					<div class="column">
						<label for="telephone">Telephone</label>
						<input type="text" id="brand_register_telephone" name="telephone input" placeholder="Telephone number" class="errorpad" required>
					</div>
				</div>
				<div class="row">
					<div class="column">
						<label for="pass">Password</label>
						<input type="password" id="brand_register_pass" name="password input" placeholder="Password" class="errorpad" required>
					</div>
					<div class="column">
						<label for="pass">Repeat Password</label>
						<input type="password" id="brand_register_confirmpass" name="password input" placeholder="Password" required>
					</div>
				</div>
				<div class="row">
					<div class="column">
						<p>All accounts registered with iDAL are subject to verification. Until verification is complete your access to iDAL will be limited to viewing your own profile.</p>
						<p class="errorpad">
							<input type="checkbox" id="brand_register_terms" name="terms input" class="main" style="display: none;">
							<label class="inside-label" for="brand_register_terms"><span>
								<svg width="15px" height="12px">
									<use xlink:href="#check-tick"></use>
								</svg></span><span>I agree to the iDAL <a href="/terms">Platform Terms & Conditions</a>, the <a href="/terms/client">Client Terms & Conditions</a>, the iDAL <a href="/privacy">Privacy Policy</a> and the <a href="https://stripe.com/connect-account/legal">Stripe Connected Account Agreement</a>.</span>
							
							</p>
					</div>
				</div>
				<div class="row">
					<div class="column" style="text-align: center">
						<a id="brandregister" style="margin-top: 1em;" class="button inverted">Register</a>
					</div>
				</div>
			
			</div>
			<input type="hidden" name="step" value="account" />
			<input type="hidden" name="usertype" value="brand" />
		</form>
	</div>
		
	{* show model form *}
	<div class="column step2 model modalWhite">

		<form class="callout model" action="/user/register" method="post" id="register-form-model">
			<div id="register">
				<div class="model_error_messages"></div>
				<div class="row">
					<div class="column">
						<p class="text-black" style="padding-left: 0; padding-right: 0; margin-bottom: 1em;">iDAL accepts applications from models of all backgrounds and genders. You need to be a professional model over 18 to apply.</p>
					</div>
				</div>

				<div class="row">
					<div class="column">
						<label for="firstname">First Name</label>
						<input type="text" id="model_register_firstname" name="firstname input" placeholder="First Name" class="errorpad" required>
					</div>
					<div class="column">
						<label for="lastname">Last Name</label>
						<input type="text" id="model_register_lastname" name="lastname input" placeholder="Last Name" class="errorpad" required>
					</div>
				</div>
				<div class="row">
					<div class="column" style="position: relative;">
						<label for="email">Email</label>
						<input type="email" id="model_register_email" name="mail input" placeholder="Email" class="errorpad" required>
					</div>
					<div class="column">
						<label for="gender">I identify as</label>
						<div class="select-wrap">
							<select name="register_gender input" id="model_gender" class="select" required>
								<option value="female">Woman</option>
								<option value="male">Man</option>
								<option value="other">Non-binary</option>
							</select>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="column">
						<label for="instagram">Instagram</label>
						<input type="text" id="model_register_instagram" name="instagram input" placeholder="@" required>
					</div>
					<div class="column">
						<label for="telephone">Mobile</label>
						<input type="text" id="model_register_telephone" name="telephone input" placeholder="Mobile number" class="errorpad">
					</div>
					<div class="column">
						<label for="model_location">Location</label>
						<div class="select-wrap">
							<select name="location input" id="model_location" class="select errorpad" required>
								<option value="0" selected="selected" disabled="disabled">Please select your location</option>
								{foreach from=$user_locations item=user_location}
								<option value="{$user_location.tid}">{$user_location.name}</option>
								{/foreach}
							</select>
						</div>
					</div>
					
				</div>
				<div class="row">
					<div class="column">
						<label for="pass">Password</label>
						<input type="password" id="model_register_pass" name="password input" placeholder="Password" class="errorpad" required>
					</div>
					<div class="column">
						<label for="pass">Repeat Password</label>
						<input type="password" id="model_register_confirmpass" name="password input" placeholder="Password" class="errorpad" required>
					</div>
				</div>
				<div class="row">
					<div class="column">
						<p>All individuals applying to register with iDAL are subject to verification. Our teams verify that portfolios include professional work commissioned by established media and brands. Until verification is complete, access to iDAL will be limited to only viewing your profile page.</p>
						<p class="errorpad">
							<input type="checkbox" id="model_register_terms" name="terms input" class="main" style="display: none;">
							<label class="inside-label" for="model_register_terms"><span>
								<svg width="15px" height="12px">
									<use xlink:href="#check-tick"></use>
								</svg></span><span> I agree to the iDAL <a href="/terms">Platform Terms & Conditions</a>, the <a href="/terms/model">Model Terms & Conditions</a>, the <a href="/privacy">Privacy Policy</a> and the <a href="https://stripe.com/connect-account/legal">Stripe Connected Account Agreement</a>.</span>
							
							</p>

					</div>
				</div>
				<div class="row">
					<div class="column" style="text-align: center">
						<a id="modelregister" style="margin-top: 1em;" class="button inverted">Register</a>
					</div>
				</div>
			</div>
			<input type="hidden" name="step" value="account" />
			<input type="hidden" name="usertype" value="model" />
		</form>
	</div>
</div>
