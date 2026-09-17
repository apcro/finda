<div class="reveal modalWhite" id="loginModal" data-reveal>
	<form class="callout" action="/user/login" method="post">
		<h1 class="text-center">Hello!</h1>
		<label for="email">Email</label> <input type="email" id="email" name="mail input" placeholder="Email" autocomplete="on">
		<label for="pass">Password</label> <input type="password" id="pass" name="password input" autocomplete="on" placeholder="Password">
		<div class="seperator" data-gap="1"></div>
		<div class="text-center">
			<a class="button fullwidth loginbutton">SIGN IN</a>
		</div>
		<p class="align-center forgotpwd"><a class="forgot" href="/user/forgotpasswd">Forgot password?</a></p>
	</form>
</div>