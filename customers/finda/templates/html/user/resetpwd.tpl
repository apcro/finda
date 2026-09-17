{extends "user/layout_wide.tpl"}

{block name="main"}
<div class="row">
	<div class="column">
		{if $error}<div class="error">{$error}</div>{/if}
		<h1 style="transform-origin: left top;">Reset your password</h1>
		<p style="margin: 1em 0;">Enter your email address and your new password and we'll reset it for you.</p>
		<form method="post" action="/user/resetpasswd" id="setpasswd">
			<label for="mail">Email address </label>
			<input type="text" class="form-text required styled" tabindex="1" value="" id="mail" name="mail" style="border-bottom-width: 1px;"/>
			
			<label for="passpwd1">New password </label>
			<input type="password" class="form-text required" tabindex="2" name="passwd1" id="passwd1" style="border-bottom-width: 1px;"/>
			
			<label for="passpwd2">And enter it again</label>
			<input type="password" class="form-text required" tabindex="3" name="passwd2" id="passwd2" style="border-bottom-width: 1px;" />
			
			<div class="text-center">
				<a class="button burgundy setpasswd">Reset</a>
			</div>
			<div class="seperator" data-gap="4"></div>
			<div class="seperator" data-gap="4"></div>
			<input type="hidden" value="{$key}" name="key"/>
			<input type="hidden" value="reset" name="action"/>
		</form>
	</div>
</div>
{/block}