/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
var registerType = 'client';
$(document).ready(function() {

	
	var error = false;
	
	if ($.croissant.isMobile()) {
		var registerButton = $('a.welcome-button').parent();
		registerButton.html('<a href="/m/register" class="welcome-button button">Join Now</a>');
	}
	
	$('.register').off().on('click', function(e) {
		e.preventDefault();
		registerType = $(this).data('registertype');
		
		$('body').tinymodal({
			html			: registerModal,
			width			: 1030,
			base_class		: 'registerModal',
			callback		: bindActions
		});
	});
		

});

var welcomeHtml = '<div class="row"><div class="column text-center"><img src="/images/IDAL_black.png" height="40" /></div></div>'
	+ '<div class="row"><div class="column text-center"><p>You\'ve registered with iDAL</p></div></div>'
	+ '<div class="row"><div class="column">'
	+ '<p>Sign-in and provide additional details to verify your account</p>'
	+ '<div class="seperator" data-gap="1"></div>'
	+ '<div class="row"><div class="column text-center"><a href="/user/verify" class="button burgundy">Verify your account</a></div></div>'

var problemHtml = '<div class="row"><div class="column text-center"><h1>Sorry, there was a problem creating your account</h1></div></div>'
				+ '<div class="row"><div class="column text-bold"><p>Please try again later. If you keep seeing this message, please contact us.</p></div></div>';

var referrerHtml = '<div class="row"><div class="column text-center"><h1>Did anyone recommend iDAL to you?</h1></div></div>'
					+ '<div class="row"><div class="column"><p>If so, please enter their name here</p></div></div>'
					+ '<div class="row"><div class="column"><input type="text" name="referralcode" style="border-bottom: 1px solid #010101;" '
					+ 'value="' + trk + '" /></div></div>'
					+ '<div class="row"><div class="column text-center"><a class="button inverted savereferrercode">OK</a></div><div class="column text-center"><a class="button savereferrercode">SKIP</a></div></div>';

var registerHtml = '<div class="row"><div class="column"><h1>Please wait while we create your account</h1></div></div>';

var motheragencyHtml ='<div class="row"><div class="column text-center"><img src="/images/IDAL_white.png" height="40" /></div></div>'
	+ '<div class="row"><div class="column text-center"><h1>You\'ve registered with iDAL</h1></div></div>'
	+ '<div class="row"><div class="column text-bold">'
	+ '<p>One of our team will contact you shortly to create your Mother Agency account and help you sign up all your models.</p>'
	+ '<div class="seperator" data-gap="1"></div>'
	+ '<div class="row"><div class="column text-center"><a href="/dashboard" class="button burgundy">OK</a></div></div>';

var isMotherAgency = false;

function bindActions() {
	switch(registerType) {
	case 'client':
		$('.step1.model').hide();
		$('.step2.brand').fadeIn();
		break;
	case 'model':
		$('.step1.brand').hide();
		$('.step2.model').fadeIn();
		break;
	}
	$('.step1').off().on('click', function(e) {
		e.preventDefault();
		var type = $(this).data('type');
		$('input[name=usertype]').val(type);
		$("#register-form-model input, #register-form-model select, p").removeClass("registererror");
		$('p.emailError').remove();
		switch(type) {
		case 'model':
			$('.step1.brand').fadeOut();
			$('.step2.model').fadeIn();
			break;
		case 'brand':
			$('.step1.model').fadeOut();
			$('.step2.brand').fadeIn();
			break;
		}
	});
	
	$('a.closeform').off().on('click', function(e) {
		e.preventDefault();
		$('a.croissant-close').trigger('click');
	})
	
	$("#brandregister").off().on('click', function(e){
		e.preventDefault();
		error = false;
		var userType = 'brand';
		var form = this;
		
		$("#brand_register-form input, #brand_register-form select").removeClass("registererror");
		$('p.emailError').remove();
		
		if (!$.croissant.isEmail($('#brand_register_email').val())) {
			$('#brand_register_email').addClass('registererror');
			error = true;
		}
		
		if ($('#brand_register_pass').val() != $('#brand_register_confirmpass').val()) {
			$('#brand_register_pass, #brand_register_confirmpass').addClass('registererror');
			error = true;
		}
		
		if ($('#brand_register_pass').val() == '') {
			$('#brand_register_pass').addClass('registererror');
			error = true;
		}
		
		if (error == false) {
			var pwd = $('#brand_register_pass').val();
			if (pwd.length < 6) {
				$('#brand_register_pass, #brand_register_confirmpass').addClass('registererror');
				error = true;
			}
		}

		
		if ($('#brand_register_firstname').val() == '') {
			$('#brand_register_firstname').addClass('registererror');
			error = true;
		}
		
		if ($('#brand_register_lastname').val() == '') {
			$('#brand_register_lastname').addClass('registererror');
			error = true;
		}

		if ($('#brand_register_telephone').val() == '') {
			$('#brand_register_telephone').addClass('registererror');
			error = true;
		}
		
		if (!$("#brand_register_terms").is(":checked")) {
			$("#brand_register_terms").parent().addClass('registererror');
			error = true;
		}
		
		// agent-specific fields
		if ($("#brand_register_occupation").val() == '') {
			$("#brand_register_occupation").addClass('registererror');
			error = true;
		}
		if ($("#brand_register_company").val() == '') {
			$("#brand_register_company").addClass('registererror');
			error = true;
		}
		if ($("#brand_register_website").val() == '') {
			$("#brand_register_website").addClass('registererror');
			error = true;
		}
		if ($("#brand_register_telephone").val() == '') {
			$("#brand_register_telephone").addClass('registererror');
			error = true;
		}
		
		
		if (!error) {
			registerUser('brand');
		} else {
			var message = '<div class="row"><div class="column"><h2 class="text-red">OOPS</h2></div></div>';
				message += '<div class="row"><div class="column"><p>Please fill in all the highlighted fields</p></div></div>';
				message += '<div class="row"><div class="column"><a class="button white errorbutton closemodal">Got it</a></div></div>';
			$('body').tinymodal({
				html: message,
				retainModal: true
			});
		}
	});
	
	$("#modelregister").off().on('click', function(e){
		e.preventDefault();
		
		error = false;
		var userType = 'model';
		var form = this;
		
		var errorMessage = '<div class="row"><div class="column"><h2 class="text-red">OOPS</h2></div></div>';
		errorMessage += '<div class="row"><div class="column"><p>Please fill in all the highlighted fields</p></div></div>';
		errorMessage += '<div class="row"><div class="column"><a class="button white errorbutton closemodal">Got it</a></div></div>';

		
		$("#register-form-model input, #register-form-model select, p, #model_register_email").removeClass("registererror");
		$('p.emailError').remove();
		
		if (!$.croissant.isEmail($('#model_register_email').val())) {
			$('#model_register_email').addClass('registererror');
			error = true;
		}
		
		if ($('#model_register_pass').val() != $('#model_register_confirmpass').val()) {
			$('#model_register_pass, #model_register_confirmpass').addClass('registererror');
			error = true;
		}
		
		if ($('#model_register_pass').val() == '') {
			$('#model_register_pass').addClass('registererror');
			error = true;
		}
		
		if ($('#model_location').find(':selected').val() == 0) {
			$('#model_location').addClass('registererror');
			error = true;
		}
		
		if (error == false) {
			var pwd = $('#model_register_pass').val();
			if (pwd.length < 6) {
				$('#model_register_pass, #model_register_confirmpass').addClass('registererror');
				error = true;
				errorMessage = '<div class="row"><div class="column"><h2 class="text-red">OOPS</h2></div></div>';
				errorMessage += '<div class="row"><div class="column"><p>Please fill in all the highlighted fields. Your password must be at least 6 characters long.</p></div></div>';
				errorMessage += '<div class="row"><div class="column"><a class="button white errorbutton closemodal">Got it</a></div></div>';

			}
		}
		
		if ($('#model_register_firstname').val() == '') {
			$('#model_register_firstname').addClass('registererror');
			error = true;
		}
		
		if ($('#model_register_lastname').val() == '') {
			$('#model_register_lastname').addClass('registererror');
			error = true;
		}
		
		var instaname = $('#model_register_instagram').val();
		if (instaname.length > 30) {
			$('#model_register_instagram').addClass('registererror');
			error = true;
		}
		
		if ($('#model_register_telephone').val() == '') {
			$('#model_register_telephone').addClass('registererror');
			error = true;
		}

		
		if (!$.croissant.isInstagramName(instaname)) {
			$('#model_register_instagram').addClass('registererror');
			$('#model_register_instagram').val('')
			error = true;
		}
		
		if ($('#model_register_instagram').val() == '') {
			$('#model_register_instagram').addClass('registererror');
			error = true;
		}
		
		if (!$("#model_register_terms").is(":checked")) {
			$("#model_register_terms").parent().addClass('registererror');
			error = true;
		}
		if (!error) {
			registerUser('model');
		} else {
			$('body').tinymodal({
				html: errorMessage,
				retainModal: true
			});
		}
	});
	
	var brandtelephone = new Cleave('#brand_register_telephone', {
		phone: true,
		phoneRegionCode: 'GB'
	});
	var modeltelephone = new Cleave('#model_register_telephone', {
		phone: true,
		phoneRegionCode: 'GB'
	});
}

var inputs = [];

function registerUser(usertype) {
	if (usertype == 'model'){
		$form = $("#register-form-model");
		email = $('#model_register_email').val();
		emailerrorobj = '#model_register_email';
	} else {
		$form = $("#register-form-brand");
		email = $('#brand_register_email').val();
		emailerrorobj = '#brand_register_email';
		isMotherAgency = $('#motheragency').is(':checked');
	}
	
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
					inputs.push(['usertype', usertype]);
					
					$('.croissant-close').trigger('click');
					
					// path 1 - no referral code, not a mother agency application, ask user
					if (trk == '' && !isMotherAgency) {
						// referral code?
						$('body').tinymodal({
							html				: referrerHtml,
							base_class			: 'modalWhite'
						});
						
						$('.croissant-close').hide();
						
						$('input[name=referralcode]').css('text-align', 'center');
						$('input[name=referralcode]').off().on('keypress', function (event) {
							var regex = new RegExp("^[a-zA-Z ]+$");
							var key = String.fromCharCode(!event.charCode ? event.which : event.charCode);
							if (!regex.test(key)) {
								event.preventDefault();
								return false;
							}
						});
						
						$('a.savereferrercode').off().on('click', function(e) {
							e.preventDefault();
							
							var referrercode = $('input[name=referralcode]').val();
							inputs.push(['referral_input', referrercode]);
							
							$('.croissant-close').trigger('click');
							
							$('body').tinymodal({
								html				: registerHtml,
								autoClose			: true,
								autoCloseTimeout	: 1000
							});
							
							$.ajax({
								type: 'POST',
								url: '/user/register',
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
												window.location.href = '/user/verify'
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
							
						});
						
					} else if (isMotherAgency) {
						// path 2, mother agency
						inputs.push(['referral_input', trk]);
						$('body').tinymodal({
							html				: registerHtml,
							autoClose			: true,
							autoCloseTimeout	: 1000
						});
						
						$.ajax({
							type: 'POST',
							url: '/user/register',
							data: {
								'data': inputs
							},
							success: function(resultData) {
								if (resultData == true) {
									gtag('event', 'motheragency registered');
									
									$('body').tinymodal({
										html			: motheragencyHtml,
										width			: 500,
										base_class		: 'modalWhite',
										remove_callback	: function() {
											window.location.href = '/dashboard';
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
					} else {
						// path 3, we already have a referral code and we're not a mother agency
						inputs.push(['referral_input', trk]);
						
						var jumptheline = '<div class="row"><div class="column"><h2>Welcome to iDAL!</h2></div></div>';
						jumptheline += '<div class="row"><div class="column"><p>Because you were referred by one of our trusted community members, you will jump the line for verification, please make sure you have uploaded all the requested material.</p></div></div>';
						jumptheline += '<div class="row"><div class="column"><a class="button inverted gotitbutton closemodal">Got it</a></div></div>';

						
						$('body').tinymodal({
							html		: jumptheline,
							autoClose	: false,
							callback	: function() {
								$('a.gotitbutton').off().on('click', function(e) {
									$('.croissant-close').trigger('click');
									
									$('body').tinymodal({
										html				: registerHtml,
										autoClose			: true,
										autoCloseTimeout	: 1000
									});
									
									$.ajax({
										type: 'POST',
										url: '/user/register',
										data: {
											'data': inputs
										},
										success: function(resultData) {
											if (resultData == true) {
												gtag('event', usertype + ' registered');
												
												var msgHtml = welcomeHtml;
												var lHref = '/user/verify'
												if (isMotherAgency) {
													msgHtml = motheragencyHtml;
													lHref = '/dashboard'
												}
												
												$('body').tinymodal({
													html			: msgHtml,
													width			: 500,
													base_class		: 'modalWhite',
													remove_callback	: function() {
														window.location.href = lHref;
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
								});
							}
						});
							
						
					}
					
				}
			}
		});
	}
	
}
