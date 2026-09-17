<div class="row column">
	<form action="/user/login" method="post" id="mobile-login">
	<div class="row">
		<div class="column">
			<h1 style="transform-origin: left top;">Sign in to iDAL</h1>
			{if $message}
			<div class="message error">
				<p style="padding: 0.5em; text-align: center;">Sorry, we didn't recognise that username and password combination.</p>
			</div>
			{/if}
		</div>
	</div>
	<div class="row">
		<div class="column">
			<label for="register_email">Email:</label>
			<input type="email" id="register_email" name="mail input">
		</div>
	</div>
	<div class="row">
		<div class="column">
			<label for="register_password">Password:</label>
			<input type="password" id="register_password" name="password input">
			</div>
		</div>
	<div class="row">
		<div class="column text-center">
			<div class="submit login">
				<button class="button white bg-black hvr hvr-purple-textwhite" type="submit" value="Log in" name="submit">Sign In</button>
			</div>
		</div>
	</div>
	<div class="row">
		<div class="column text-center">
			<div class="submit login">
				<a class="button white bg-black hvr hvr-purple-textwhite" href="/">Cancel</a>
			</div>
		</div>
	</div>
	<div class="row">
		<div class="column text-center">
			<div class="submit login">
				<a class="text-black" href="/user/forgotpasswd">Forgot your password?</a>
			</div>
		</div>
	</div>

	</form>
</div>