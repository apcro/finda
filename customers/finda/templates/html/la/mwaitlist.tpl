{include file="shared/header.tpl"}
<div class="row la_waitlist" id="joinwaitlistform">
	<h2>Join the LA Waitlist!</h2>
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
<div class="seperator" data-gap="2"></div>
{include file="shared/footer.tpl"}