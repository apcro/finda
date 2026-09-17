/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
$(document).ready(function() {

	$('#register-form-brand').hide();
	$('#register-form-model').hide();
	$('a.jointext').on('click', function(e) {
		e.preventDefault();
		var usertype = $(this).data('usertype');
		$('.mobileregister').fadeOut('fast');
		switch(usertype) {
			case 'model':
				$('#register-form-brand').hide();
				$('#register-form-model').fadeIn('fast');
				break;
			case 'brand':
				$('#register-form-model').hide();
				$('#register-form-brand').fadeIn('fast');
				break;
		}
	})
	
	$("#register-form-brand").submit(function(e){
		e.preventDefault();
		
		var error = false;
		var userType = 'brand';
		var form = this;
		
		if (error) {
			error = true;
		}
		
		$("#brand_register-form input, #brand_register-form select").removeClass("error");
		$('p.emailError').remove();

		if (!$.croissant.isEmail($('#brand_register_email').val())) {
			$('#brand_register_email').addClass('error');
			error = true;
		} else {
			if ($('#brand_register_email').val() != '') {
				// verify the email doesn't already exist
				$.ajax({ 
					type: 'POST', 
					dataType: 'json', 
					url: '/m/register', 
					data: {
						step: 'checkemail',
						email: $('#brand_register_email').val()
					}, 
					success: function(data) {
						if (data == false) {	// flipped result - 'false' means the email address is in use (can it be used? == no)
							error = true;
							$('#brand_register_email').addClass('error');
							$('#brand_register_email').parent().append('<p class="emailError">This email address is already in use</p>');
						} else {
							$('p.emailError').remove();
							error = false;
						}
					}
				});
			}
		}

		if ($('#brand_register_pass').val() != $('#brand_register_confirmpass').val()) {
			$('#brand_register_pass, #brand_register_confirmpass').addClass('error');
			error = true;
		}
		
		if ($('#brand_register_pass').val() == '') {
			$('#brand_register_pass').addClass('error');
			error = true;
		}
		
		if ($('#brand_register_firstname').val() == '') {
			$('#brand_register_firstname').addClass('error');
			error = true;
		}
		
		if ($('#brand_register_lastname').val() == '') {
			$('#brand_register_lastname').addClass('error');
			error = true;
		}
		
		if (!$("#brand_register_terms").is(":checked")) {
			$("#brand_register_terms").parent().addClass('error');
			error = true;
		}
		
		// agent-specific fields
		if ($("#brand_register_occupation").val() == '') {
			$("#brand_register_occupation").addClass('error');
			error = true;
		}
		if ($("#brand_register_company").val() == '') {
			$("#brand_register_company").addClass('error');
			error = true;
		}
		if ($("#brand_register_website").val() == '') {
			$("#brand_register_website").addClass('error');
			error = true;
		}
		if ($("#brand_register_telephone").val() == '') {
			$("#brand_register_telephone").addClass('error');
			error = true;
		}


		if (!error) {
			 form.submit();
		} else {
			$('#brand_error_messages').html('<p>Please fill in all the highlighted fields</p>');
		}
	});
	
	$("#register-form-model").submit(function(e){
		e.preventDefault();
		
		var error = false;
		var userType = 'model';
		var form = this;
		
		if (error) {
			error = true;
		}
		
		$("#register-form-model input, #register-form-model select").removeClass("error");
		$('p.emailError').remove();

		if (!$.croissant.isEmail($('#model_register_email').val())) {
			$('#model_register_email').addClass('error');
			error = true;
		} else {
			if ($('#model_register_email').val() != '') {
				// verify the email doesn't already exist
				$.ajax({ 
					type: 'POST', 
					dataType: 'json', 
					url: '/m/register', 
					data: {
						step: 'checkemail',
						email: $('#model_register_email').val()
					}, 
					success: function(data) {
						if (data == false) {	// flipped result - 'false' means the email address is in use (can it be used? == no)
							error = true;
							$('#model_register_email').addClass('error');
							$('#model_register_email').parent().append('<p class="emailError">This email address is already in use</p>');
						} else {
							$('p.emailError').remove();
							error = false;
						}
					}
				});
			}
		}

		if ($('#model_register_pass').val() != $('#model_register_confirmpass').val()) {
			$('#model_register_pass, #model_register_confirmpass').addClass('error');
			error = true;
		}
		
		if ($('#model_register_pass').val() == '') {
			$('#model_register_pass').addClass('error');
			error = true;
		}
		
		if ($('#model_register_firstname').val() == '') {
			$('#model_register_firstname').addClass('error');
			error = true;
		}
		
		if ($('#model_register_lastname').val() == '') {
			$('#model_register_lastname').addClass('error');
			error = true;
		}
		
		if (!$("#model_register_terms").is(":checked")) {
			$("#model_register_terms").parent().addClass('error');
			error = true;
		}
		
		if (!error) {
			form.submit();
		} else {
			$('#model_error_messages').html('<p>Please fill in all the highlighted fields</p>');
		}
	});
});
