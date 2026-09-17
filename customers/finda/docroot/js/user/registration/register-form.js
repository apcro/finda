/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
$(document).ready(function(){
	
	var is_valid = false;

	$('.step1').on('click', function(e) {
		e.preventDefault();
		var type = $(this).data('type');
		switch($type) {
			case 'model':
				$('.step1.brand').hide();
				$('.step2.model').show();
				break;
			case 'brand':
				$('.step1.model').hide();
				$('.step2.brand').show();
				break;
		}
	});
	
	
	
	$('#login-form').submit(function(e){
		if (!is_valid) {
			e.preventDefault();
			$.post('/user/login/check', $('#login-form').serialize(), function(data) {
				if (data.result == 1) {
					is_valid = true;
					$('#login-form').submit();
				} else {
					$('#login-modal #password').addClass('error');
			 		$('#login-modal #email').addClass('error');
				}
			}, 'json');
		}
	});

	$("#register-form").submit(function(e){
		e.preventDefault();
		
		var error = false;
		var userType = $('input[name=usertype]').val();
		var form = this;
		
		if (error) {
			error = true;
		}
		
		$("#register-form input, #register-form select").removeClass("error");
		$('p.emailError').remove();

		if (!$.croissant.isEmail($('#register_email').val())) {
			$('#register_email').addClass('error');
			error = true;
		} else {
			if ($('#register_email').val() != '') {
				// verify the email doesn't already exist
				$.ajax({ 
					type: 'POST', 
					dataType: 'json', 
					url: '/user/register', 
					data: {
						step: 'checkemail',
						email: $('#register_email').val()
					}, 
					success: function(data) {
						if (data == false) {	// flipped result - 'false' means the email address is in use (can it be used? == no)
							error = true;
							$('#register_email').addClass('error');
							$('#register_email').parent().append('<p class="emailError">This email address is already in use</p>');
						} else {
							$('p.emailError').remove();
							error = false;
						}
					}
				});
			}
		}

		if ($('#register_pass').val() != $('#register_confirmpass').val()) {
			$('#register_pass, #register_confirmpass').addClass('error');
			error = true;
		}
		
		if ($('#register_pass').val() == '') {
			$('#register_pass').addClass('error');
			error = true;
		}
		
		if ($('#register_firstname').val() == '') {
			$('#register_firstname').addClass('error');
			error = true;
		}
		
		if ($('#register_lastname').val() == '') {
			$('#register_lastname').addClass('error');
			error = true;
		}
		
		if (!$("#register_terms").is(":checked")) {
			$("#register_terms").parent().addClass('error');
			error = true;
		}
		
		// model-specific fields
//		if (userType == 'model') {
//			if ($("#register_age").val() == '') {
//				$("#register_age").addClass('error');
//				error = true;
//			}
//		}
		
		// agent-specific fields
		if (userType == 'agent') {
			if ($("#register_occupation").val() == '') {
				$("#register_occupation").addClass('error');
				error = true;
			}
			if ($("#register_company").val() == '') {
				$("#register_company").addClass('error');
				error = true;
			}
			if ($("#register_website").val() == '') {
				$("#register_website").addClass('error');
				error = true;
			}
			if ($("#register_telephone").val() == '') {
				$("#register_telephone").addClass('error');
				error = true;
			}

		}
		
		
		

		if (!error) {
			form.submit();
//			$.ajax({ 
//				type: 'POST', 
//				dataType: 'json', 
//				url: '/user/register/account', 
//				data: $('#register-form').serialize(), 
//				success: function(data) {
//					if (data == true) {
//						document.location.href = '/user/register-confirm';
//					}
//				}
//			});
		} else {
			$('#error_messages').html('<p>Please fill in all the highlighted fields</p>');
		}
	});

});