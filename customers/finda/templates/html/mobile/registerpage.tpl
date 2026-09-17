<div class="mobile">
	<div class="panel-toggle-button">
		<div class="hamburger hamburger--arrow">
			<div class="hamburger-box">
				<div class="hamburger-inner"></div>
			</div>
		</div>
	</div>
</div>
<nav id="mobilemenu" class="mobile">
	<ul>
		<li><a href="/m/enquire">Enquire for talent booking</a></li>
		<li><a href="/m/register" class="register" data-registertype="model">Join</a></li>
	</ul>
</nav>
<div id="main" class="mobilepanel">

	<section id="landing" class="fullscreen">
		<div class="background"></div>
		<div class="leadimage">

			<div class="top-menu">
				<div class="leadlogo">
					<a href="/" style="border-bottom: none;"><img src="/images/IDAL_black.png"/></a>
				</div>
			</div>

<div class="row mobileregister model">
	<div class="column">
		<div class="center-all">
			<p><a class="jointext" data-usertype="model">Join as model</a></p>
		</div>
	</div>
</div>
<div class="row mobileregister brand">
	<div class="column">
		<div class="center-all">
			<p><a class="jointext" data-usertype="brand">Join as client</a></p>
		</div>
	</div>
</div>
<form class="callout model" action="/m/register" method="post" id="register-form-model">
	<div id="modelregister">
		<div class="row">
			<div class="column">
				<h2>Join as model</h2>
			</div>
		</div>
		<div class="row">
			<div class="column">
				<label for="firstname">First Name</label>
				<input type="text" id="model_register_firstname" name="firstname input" placeholder="First Name">
			</div>
		</div>
		<div class="row">
			<div class="column">
				<label for="lastname">Last Name</label>
				<input type="text" id="model_register_lastname" name="lastname input" placeholder="Last Name">
			</div>
		</div>
		<div class="row">
			<div class="column">
				<label for="email">Email</label>
				<input type="email" id="model_register_email" name="mail input" placeholder="Email">
			</div>
		</div>
		<div class="row">
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
		</div>
		<div class="row">
			<div class="column">
				<label for="referral">Referral Code</label>
				<input type="text" id="model_referral_code" name="referral input" value="{$trk}" placeholder="Enter code if you have one">
			</div>
		</div>
		<div class="row">
			<div class="column">
				<label for="pass">Password</label>
				<input type="password" id="model_register_pass" name="password input" placeholder="Password">
			</div>
		</div>
		<div class="row">
			<div class="column">
				<label for="pass">Repeat Password</label>
				<input type="password" id="model_register_confirmpass" name="password input" placeholder="Password">
			</div>
		</div>
		<div class="row">
			<div class="column">
	
				<p><input type="checkbox" id="model_register_terms" name="terms input"> I agree to the iDAL <a href="/terms">Terms & Conditions</a> and <a href="/privacy">Privacy Policy</a> and the and the <a href="https://stripe.com/connect-account/legal">Stripe Connected Account Agreement</a>.</p>
				<p>All accounts registered with iDAL are subject to verification. Until verification is complete your access to iDAL will be limited to viewing your own profile.</p>
			</div>
		</div>
		<div class="row">
			<div class="column align-center">
				<button style="margin-top: 1em;" class="button inverted" type="submit">Join Us</button>
			</div>
			<div class="column align-center">
				<a style="margin-top: 1em; margin-bottom: 4em;" class="button" href="/">Cancel</a>
			</div>
		</div>
	
	</div>
	<input type="hidden" name="step" value="account" />
	<input type="hidden" name="usertype" value="model" />
</form>
<form class="callout brand" action="/m/register" method="post" id="register-form-brand">
	<div id="brandregister" class="bg-white">
		<div class="row">
			<div class="column">
				<h2>Join as client</h2>
			</div>
		</div>
	
		<div class="row">
			<div class="column">
				<label for="firstname">First Name</label>
				<input type="text" id="brand_register_firstname" name="firstname input" placeholder="First Name">
			</div>
		</div>
		<div class="row">
				<div class="column">
				<label for="lastname">Last Name</label>
				<input type="text" id="brand_register_lastname" name="lastname input" placeholder="Last Name">
			</div>
		</div>
		<div class="row">
			<div class="column">
				<label for="email">Company Email</label>
				<input type="email" id="brand_register_email" name="mail input" placeholder="Company Email">
			</div>
		</div>
		<div class="row">
			<div class="column">
				<label for="company">Company name</label>
				<input type="text" id="brand_register_company" name="company input" placeholder="Company name">
			</div>
		</div>
		<div class="row">
			<div class="column">
				<label for="website">Company Website</label>
				<input type="text" id="brand_register_website" name="website input" placeholder="Website address">
			</div>
		</div>
		<div class="row">
			<div class="column">
				<label for="occupation">Position</label>
				<input type="text" id="brand_register_occupation" name="occupation input" placeholder="Position">
			</div>
		</div>
		<div class="row">
			<div class="column">
				<label for="telephone">Telephone</label>
				<input type="text" id="brand_register_telephone" name="telephone input" placeholder="Telephone number">
			</div>
		</div>
		<div class="row">
			<div class="column">
				<label for="pass">Password</label>
				<input type="password" id="brand_register_pass" name="password input" placeholder="Password">
			</div>
		</div>
		<div class="row">
			<div class="column">
				<label for="pass">Repeat Password</label>
				<input type="password" id="brand_register_confirmpass" name="password input" placeholder="Password">
			</div>
		</div>
		<div class="row">
			<div class="column">
				<p><input type="checkbox" id="brand_register_terms" name="terms input"> I agree to the iDAL <a href="/terms">Terms & Conditions</a> and <a href="/privacy">Privacy Policy</a> and the and the <a href="https://stripe.com/connect-account/legal">Stripe Connected Account Agreement</a>.</p>
				<p>All accounts registered with iDAL are subject to verification. Until verification is complete your access to iDAL will be limited to viewing your own profile.</p>
			</div>
		</div>
		<div class="row">
			<div class="column align-center">
				<button style="margin-top: 1em;" class="button inverted" type="submit">Register</button>
			</div>
			<div class="column align-center">
				<a style="margin-top: 1em; margin-bottom: 4em;" class="button" href="/">Cancel</a>
			</div>
		</div>
	
	</div>
	<input type="hidden" name="step" value="account" />
	<input type="hidden" name="usertype" value="brand" />
</form>
</div>
</section>