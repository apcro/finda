<p>Use the form below to change your password</p>
<form name="form_password" id="form_password" class="register" action="/user/profile/password" method="post">
	<input type="hidden" name="password_form" value="1"/>
	<span>
		<label class="required">Your current password<span> *</span></label><br />
		<input type="password" name="password_currentpass" id="password_currentpass" />
	</span>
	<span>
		<label class="required">Your new password<span> *</span></label><br />
		<input type="password" name="password_newpass" id="password_newpass" />
	</span>
	<span>
		<label class="required">Confirm your new password<span> *</span></label><br />
		<input type="password" name="password_newpassconfirm" id="password_newpassconfirm"/>
	</span>
	<div class="submit_button">
		<input class="button" type="submit" value="Save Password"/>
	</div>
</form>