/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
var welcomeHtml = '<div class="row"><div class="column text-center"><img src="/images/IDAL_black.png" height="40" /></div></div>'
	+ '<div class="row"><div class="column text-center" style="margin-top: 1em;"><p>Thank you for registering</p></div></div>';
var problemHtml = '<div class="row"><div class="column text-center"><h1>Sorry, there was a problem creating your account</h1></div></div>'
	+ '<div class="row"><div class="column text-bold"><p>Please try again later. If you keep seeing this message, please contact us.</p></div></div>';

$(document).ready(function() {

	
	var error = false;
	
	if ($.croissant.isMobile()) {
		var registerButton = $('a.welcome-button').parent();
		registerButton.html('<a href="/m/register" class="welcome-button button">Join Now</a>');
	}
	var registerType = 'client';
	
	bindActions();

});

function bindActions() {
	$("#brandregister").off().on('click', function(e){
		e.preventDefault();
		error = false;
		var userType = 'brand';
		var form = this;
		
		$("#register-form input, #register-form select").removeClass("registererror");
		$('p.emailError').remove();
		
		if (!$.croissant.isEmail($('#register_email').val())) {
			$('#register_email').addClass('registererror');
			error = true;
		}
		
		if ($('#register_pass').val() != $('#register_confirmpass').val()) {
			$('#register_pass, #register_confirmpass').addClass('registererror');
			error = true;
		}
		
		if ($('#register_pass').val() == '') {
			$('#register_pass').addClass('registererror');
			error = true;
		}
		
		if (error == false) {
			var pwd = $('#register_pass').val();
			if (pwd.length < 6) {
				$('#register_pass, #register_confirmpass').addClass('registererror');
				error = true;
			}
		}

		
		if ($('#register_firstname').val() == '') {
			$('#register_firstname').addClass('registererror');
			error = true;
		}
		
		if ($('#register_lastname').val() == '') {
			$('#register_lastname').addClass('registererror');
			error = true;
		}

		if ($('#register_telephone').val() == '') {
			$('#register_telephone').addClass('registererror');
			error = true;
		}
		
		if (!$("#register_terms").is(":checked")) {
			$("#register_terms").parent().addClass('registererror');
			error = true;
		}
		
		// agent-specific fields
		if ($("#register_occupation").val() == '') {
			$("#register_occupation").addClass('registererror');
			error = true;
		}
		
		if (!error) {
			registerUser('brand');
		} else {
			var message = '<div class="row"><div class="column"><h2 class="text-red">OOPS</h2></div></div>';
				message += '<div class="row"><div class="column"><p>Please fill in all the highlighted fields</p></div></div>';
				message += '<div class="row"><div class="column"><a class="button white errorbutton closemodal">Got it</a></div></div>';
			$('body').tinymodal({
				html: message
			});
		}
	});
	
	
	
	var brandtelephone = new Cleave('#register_telephone', {
		phone: true,
		phoneRegionCode: 'GB'
	});
	
};


function registerUser() {
	var registerHtml = '<div class="row"><div class="column"><h1>Please wait while we create your account</h1></div></div>';

	$form = $("#register-form");
	email = $('#register_email').val();
	emailerrorobj = '#register_email';
	
	// check the email first, as a blocking function
	
	if (email != '') {
		// verify the email doesn't already exist
		$.ajax({ 
			type: 'POST', 
			dataType: 'json', 
			url: '/user/register', 
			data: {
				step: 'checkemail',
				email: email
			}, 
			success: function(data) {
				if (data == false) {	// flipped result - 'false' means the email address is in use (can it be used? == no)
					$(emailerrorobj).addClass('registererror');
					$(emailerrorobj).parent().append('<p class="emailError">This email address is already in use</p>');
				} else {
					// email not in use
					var inputTypes = ['text', 'email', 'select-one', 'textarea', 'password', 'checkbox'];
					var fields = $form.find(':input');
					var inputs = [];
					fields.each(function() {
						if (typeof $(this) !== 'undefined' && (inputTypes.indexOf($(this).get(0).type) >= 0)) {
							if ($(this).get(0).type == 'checkbox') {
								if ($(this).is(':checked')) {
									inputs.push([$(this).attr('name').replace(' ', '_'), 'on']);
								} else {
									inputs.push([$(this).attr('name').replace(' ', '_'), 'off']);
								}
							} else {
								inputs.push([$(this).attr('name').replace(' ', '_'), $(this).val()]);
							}
						}
					})
					
					inputs.push(['step', 'account']);
					inputs.push(['usertype', 'brand']);
					var invitecode = $('input[name=invite_code]').val();
					inputs.push(['invitecode', invitecode]);
					console.log(inputs);
					$('body').tinymodal({
						html				: registerHtml,
						autoClose			: true,
						autoCloseTimeout	: 1000
					});
					
					$.ajax({
						type: 'POST',
						url: '/companyinvitation',
						data: {
							'data': inputs
						},
						success: function(resultData) {
							if (resultData == true) {
								$('body').tinymodal({
									html			: welcomeHtml,
									width			: 500,
									base_class		: 'modalWhite',
									remove_callback	: function() {
										window.location.href = '/'
									}
								});
							} else {
								$('body').tinymodal({
									html		: problemHtml,
									base_class	: 'modalWhite',
									width		: 500
								});
							}
						}
					});
					
				}
			}
		});
	}
	
}
