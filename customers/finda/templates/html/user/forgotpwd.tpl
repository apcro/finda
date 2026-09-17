{extends "user/layout_wide.tpl"}

{block name="main"}
<div class="row">
	<div class="column">
	<div class="mobile" style="margin-top: 1em;"></div>
		<h1 style="transform-origin: left top;">Forgot your password?</h1>
		<p style="margin: 1em 0;">Enter your email address here and we'll send you a link to reset it.</p>
		<form action="/user/forgotpasswd" method="post" id="resetpasswd">
			<label for="register_email">Email address:</label>
			<input type="email" id="register_email" name="mail" placeholder="Enter your email address" style="border-bottom-width: 1px;">
			<a class="button burgundy forgotpasswd desktop">Recover</a>
			<div class="text-center">
				<a class="button burgundy forgotpasswd mobile">Recover</a>
			</div>
			<input type="hidden" name="action" value="reset" />
		</form>
	</div>
</div>
{/block}