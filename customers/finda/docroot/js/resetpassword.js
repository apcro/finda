/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
$(document).ready(function() {
	
	$('input').keypress(function(e) {
		if (e.which == 13) { //for key up use 38 
			$('.setpasswd').trigger('click');
		}
	});
	
	$('.forgotpasswd').on('click', function(e) {
		e.preventDefault();
		$('#register_email').removeClass('error');
		var email = $('#register_email').val();
		if ($.croissant.isEmail(email)) {
			$('#resetpasswd').submit();
		} else {
			$('#register_email').addClass('error');
		}
	});
	
	$('.setpasswd').on('click', function(e) {
		e.preventDefault();
		$('#mail').removeClass('error');
		$('#passwd1, #passwd2').removeClass('error');
		var errors = false;
		var error_message = '';
		var email = $('#mail').val();
		var passwd1 = $('#passwd1').val();
		var passwd2 = $('#passwd2').val();
		
		if (passwd1.length < 6) {
			errors = true;
			$('#passwd1, #passwd2').addClass('error');
			error_message = 'Your new password must be at least 6 characters long. ';
		}
		if (passwd2.length < 6) {
			errors = true;
			$('#passwd1, #passwd2').addClass('error');
			error_message = 'Your new password must be at least 6 characters long. ';
		}
		if (passwd1 == '') {
			errors = true;
			$('#passwd1, #passwd2').addClass('error');
			error_message = 'You cannot set an empty password. ';
		}
		if (passwd2 == '') {
			errors = true;
			$('#passwd1, #passwd2').addClass('error');
			error_message = 'You cannot set an empty password. ';
		}
		if (passwd1 != passwd2) {
			errors = true;
			$('#passwd1, #passwd2').addClass('error');
			error_message = 'Your passwords do not match. ';
		}
		if (!$.croissant.isEmail(email)) {
			errors = true;
			$('#mail').addClass('error');
			error_message = 'Please enter an email address. ';
		} 
		
		if (!errors) {
			$('#setpasswd').submit();
		} else {
			$('#finda-website').tinymodal({
				title: 'Sorry',
				message: 'There was a problem. ' + error_message + 'Please check the information you have entered and try again.'
			});
		}
	});

});