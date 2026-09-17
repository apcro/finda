<section id="landing" class="fullscreen">
	{* <div class="background"></div> <div class="background active"></div> *}
	<div class="leadimage">

		<div class="leadlogo">
			<img src="/images/IDAL_white.png"/>
		</div>
		<div class="topmenu desktop">
			<ul class="menu simple horizontal">
				<li><a href="/unbiasedsearch">Unbiased Search</a></li>
				<li><a href="/howto">How it Works</a></li>
				<li><a href="/mission">About Us</a></li>
				<li><a href="#podcast" class="podcast">Idal Voices</a></li>
				<li><a href="/modellaw">Model Law</a></li>
				<li><a data-open="loginModal" href="/user/login">Sign In</a></li>
			</ul>
		</div>
		<div class="tagline">
			<h1 class="leadertagline">Technology for the new generation of entrepreneurial models is coming to LA</h1>
			<p class="leadersubline">&nbsp;</p>
			
			<div class="actionbuttons desktop">
				<div class="welcomeholder"><div class="welcome-button"><a href="" class="register desktop" data-open="joinwaitlistform" data-registertype="waitlist">Join Waitlist</a></div></div>
			</div>
			<div class="actionbuttons mobile">
				<div class="welcomeholder"><div class="welcome-button"><a href="/la/mwaitlist" class="signin-button mobile">Join Waitlist</a></div></div>
			</div>
		</div>
		<div class="leader-welcome desktop">
			<span class="appdownload" style="display: inline-block; text-align: center;">
				<a href="https://itunes.apple.com/us/app/finda-for-models/id1427352589?ls=1&amp;mt=8">
					<img src="/images/Download_on_the_App_Store_Badge_US-UK_RGB_blk_092917.svg">
				</a>
				<a href="https://play.google.com/store/apps/details?id=co.finda.models">
					<img src="/images/google-play-badge.svg">
				</a>
			</span>
		</div>
	</div>
	{* <div class="modelnotice">Alexandru and Anesu, models on Idal</div> *}
</section>
<div class="reveal la_waitlist" id="joinwaitlistform">
{* show model form *}
	<div class="column waitlist modalWhite">
		<form class="callout model" action="/la/waitlist" method="post" id="join-waitlists">
			<div id="register">
				<div class="model_error_messages"></div>

				<div class="row">
					<div class="column">
						<label for="firstname">First Name</label>
						<input type="text" id="waitlist_firstname" name="firstname" placeholder="First Name" class="errorpad" required>
					</div>
					<div class="column">
						<label for="lastname">Last Name</label>
						<input type="text" id="waitlist_lastname" name="lastname" placeholder="Last Name" class="errorpad" required>
					</div>
				</div>
				<div class="row">
					<div class="column" style="position: relative;">
						<label for="email">Email</label>
						<input type="email" id="waitlist_email" name="mail" placeholder="Email" class="errorpad" required>
					</div>
				</div>
				<div class="row">
					<div class="column">
						<label for="instagram">Instagram</label>
						<input type="text" id="waitlist_instagram" name="instagram" placeholder="@" required>
					</div>
				</div>
				<div class="row">
					<div class="column">
						<label for="dob">Date of Birth</label>
						<input type="text" id="waitlist_dob" name="dob" required>
					</div>
				</div>
				<div class="row">
					<div class="column">
						<input type="checkbox" id="waitlist_right_to_work" name="waitlist_right_to_work" required>
						<label for="instagram">Do you have the right to work in the US?</label>
					</div>
				</div>
				<div class="row">
					<div class="column" style="text-align: center">
						<a id="joinwaitlist" style="margin-top: 1em;" class="button inverted">Join LA Waitlist</a>
					</div>
				</div>
			</div>
			<input type="hidden" name="step" value="account" />
			<input type="hidden" name="usertype" value="model" />
		</form>
	</div>
</div>