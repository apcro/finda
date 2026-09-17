/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
var modelid = $('input[name=modelid]').val();
var userid = $('input[name=userid]').val();
var modelname = $('input[name=modelname]').val();
var isrecognised = false;
var fullScreenModal = false;

$(document).ready(function() {
	
	if ($.croissant.isMobile()) {
		fullScreenModal = true;
	}
	
	$('#startdate').Zebra_DatePicker({
		direction: true,
		disable_time_picker: true,
		format: 'd-m-Y',
		icon_position: "left",
		show_icon: false,
		offset: [-300, 0]
	});
	
	$('#starttime').clockpicker({
		placement: 'top',
		align: 'left',
		donetext: 'Done',
		autoclose: true
	});
	
	if ($('#rate').length > 0) {
		var rate = new Cleave('#rate', {
			numeral: true,
			numeralPositiveOnly: true
		});
	}
	
	$('#length').off().on('change', function(e) {
		updateRate();
	});
	$('#rate').off().on('keyup', function(e) {
		updateRate();
	});
	
	$('.finishbooking').off().on('click', function(e) {
		e.preventDefault();
		
		if (validated()) {
			finishBooking();
		} else {
			$('body').tinymodal({
				title: 'Please fill in all the highlighted fields',
				message: '',
				autoClose: true,
				autoCloseTimeout: 2000,
				fullscreen: fullScreenModal
			});
		}
	});
	
	// fill in if we have a recognised user
	$('#usermail').on('blur', function(e) {
		var email = $('#usermail').val();
		
		$.ajax({
			type: 'POST',
			url: '/user/getbyemail',
			data: {
				'email': email
			},
			success: function(user) {
				// but do not log them in, we still need confirmation of password
				if (user) {
					if (user.id != 0) {
						$('#firstname').val(user.firstname);
						$('.lastnameholder').fadeOut('fast');
						$('.telephoneholder').fadeOut('fast');
						$('.companyholder').fadeOut('fast');
						$('.companywebsiteholder').fadeOut('fast');
						isrecognised = true;
					}
				} else {
					$('.lastnameholder').fadeIn('fast');
					$('.telephoneholder').fadeIn('fast');
					$('.companyholder').fadeIn('fast');
					$('.companywebsiteholder').fadeIn('fast');
					isrecognised = false;
				}
			}
		});
	});

	if (userid != 0) {
		isrecognised = true;
	}
});

function validated() {
//	return true;
	var valid = true;
	if (userid == 0 && !isrecognised) {
		if (isEmptyOrSpaces($('#firstname').val())) { valid = false; $('#firstname').addClass('error');}
		if (isEmptyOrSpaces($('#lastname').val())) { valid = false; $('#lastname').addClass('error');}
		if (isEmptyOrSpaces($('#company').val())) { valid = false; $('#company').addClass('error');}
		if (isEmptyOrSpaces($('#company_website').val())) { valid = false; $('#company_website').addClass('error');}
		if (isEmptyOrSpaces($('#usermail').val()) || !$.croissant.isEmail($('#usermail').val())) { 
			valid = false; 
			$('#usermail').addClass('error');
		}
		if (isEmptyOrSpaces($('#telephone').val())) { valid = false; $('#telephone').addClass('error');}
	}
	if (isEmptyOrSpaces($('#location').val())) { valid = false; $('#location').addClass('error');}
	if (isEmptyOrSpaces($('#rate').val()) || $('#rate').val() == '£') { valid = false; $('#rate').addClass('error');}
	if (isEmptyOrSpaces($('#description').val())) { valid = false; $('#description').addClass('error');}
	if ($('#jobtype').find(':selected').val() == 0) { valid = false; $('#jobtype').addClass('error');}
	if ($('#length').find(':selected').val() == 0) { valid = false; $('#length').addClass('error');}
	return valid;
}

function updateRate() {
	var rate = $('#rate').val().replace('£', '').replace(',', '');
	var projectduration = $('#length').val();
	if (projectduration != null) {
		var projectdurationcalc = (projectduration >= 1?projectduration:1);
		var subtotal = (rate * projectdurationcalc);
		var findafee = subtotal * .1;
		var vat = (subtotal + findafee) * .2;
		var total = subtotal + findafee + vat;
		total = parseFloat(Math.round(total * 100) / 100).toFixed(2)
		$('#totalfee').val('£' + total);
	}
}


function finishBooking() {
	var html = '<div class="row"><div class="column">';
	
	// unknown or logged-out user
	if (userid == 0) {
		// check email
		var email = $('#usermail').val();
		var modalWidth = 'auto';
		
		$.ajax({
			type: 'POST',
			url: '/user/getbyemail',
			data: {
				'email': email
			},
			success: function(user) {
				if (user) {
					if (user.id != 0) {
						// we have a known user
						if (user.status != 2) {
							html +='<h1>Sign in</h1></div></div>'
								+ '<div class="row"><div class="column" style="margin-top: 2em;">Welcome back '+user.firstname+'. Enter your password to send your request to '+modelname+'</div></div>'
								+ '<div class="row"><div class="column text-left" style="margin-top: 2em;"><label for="userpass"><b>Password</b></label><input type="password" id="userpass" name="userpass"></div></div>'
								+ '<div class="row"><div class="column" style="margin-top: 2em; margin-bottom: 2em;"><a href="/book" class="button burgundy knownuser">Send Request</div></div>';
						} else {
							html +='<h1>Sorry</h1></div></div>'
								+ '<div class="row"><div class="column">This account cannot be used to make requests</div></div>'
								+ '<div class="row"><div class="column" style="margin-top: 2em; margin-bottom: 2em;"><a href="/book" class="button burgundy stopbutton">OK</div></div>';
						}
					}
				} else {
					// unregistered
					html +='<h1>Your booking is almost ready!</h1></div></div>'
						+ '<div class="row"><div class="column"><p>To send your booking request to '+modelname+' get <b>verified & create a free account</b> on iDAL. The account will also give you access to hundreds of available models for your future projects.</p><p class="mobile">Learn more about iDAL here: <a href="/" target="_blank">www.idal.co</a></p></div></div>'
						+ '<div class="row"><div class="column text-left" style="margin-top: 2em;"><label for="pass">Choose a password:</label><input id="userpass" type="password" name="userpass"></div>'
						+ '<div class="column text-left" style="margin-top: 2em;"><label for="repeatpass">Repeat it please:</label><input id="userrepeatpass" type="password" name="userrepeatpass"></div></div>'
						+ '<div class="row"><div class="column text-left"><label for="imageid">To verify your account please upload your ID. You can also choose to do this later by logging into your account after saving your details below.</label><input type="file" id="userimageid" name="userimageid" style="margin-top: 1em;"></div></div>'
						+ '<div class="row"><div class="column" style="margin-top: 2em;"><p><b>Once your account is verified, your request is immediately sent to '+modelname+'.</b></p></div></div>'
						+ '<div class="row"><div class="column text-left" style="margin-top: 0.5em;"><input type="checkbox" id="register_terms" name="terms"> I agree to the iDAL <a href="/terms">Platform Terms & Conditions</a>, the <a href="/terms/client">Client Terms & Conditions</a>, the <a href="/privacy">Privacy Policy</a> and the <a href="https://stripe.com/connect-account/legal">Stripe Connected Account Agreement</a></div></div>'
						+ '<div class="row"><div class="column" style="margin-top: 2em; margin-bottom: 2em;"><a href="/book" class="button burgundy newuser">Create Your Free Account</div></div>';
					modalWidth = '60em';
				}
				
				$('body').tinymodal({
					html: html,
					fullscreen: fullScreenModal,
					width: modalWidth,
					callback: function() {
						$('.stopbutton').off().on('click', function(e) {
							e.preventDefault();
							$('a.croissant-close').trigger('click');
						});
						
						$('.okbutton').off().on('click', function(e) {
							e.preventDefault();
							$('a.croissant-close').trigger('click');
						});
						
						$('.knownuser').off().on('click', function(e) {
							e.preventDefault();
							// all good, process
							$('a.croissant-close').trigger('click');
							
							var formdata = new FormData();
							
							// project data and client data
							formdata.append('userid', user.id);
							formdata.append('userpass', $('#userpass').val());
							formdata.append('jobtype', $('#jobtype').find(':selected').val());
							formdata.append('bookinglocation', $('#location').val());
							formdata.append('ordernumber', $('#ordernumber').val());
							formdata.append('startdate', $('#startdate').val());
							formdata.append('starttime', $('#starttime').val());
							formdata.append('duration', $('#length').find(':selected').val());
							formdata.append('rate', $('#rate').val().replace('£', '').replace(',', ''));
							formdata.append('description', $('#description').val());
							formdata.append('modelid', modelid);
							formdata.append('modelname', modelname);
							
							$('body').tinyspinner();
							$.ajax({
								type: 'POST',
								url: '/book/createproject',
								data: formdata,
								processData: false,
								contentType: false,
								success: function(data) {
									if (data.status != 0) {
										// error
										showError(data);
									} else {
										// success!
										showSuccess(2);
									}
								}
							});
						});
						
						$('.newuser').off().on('click', function(e) {
							e.preventDefault();
							if ($('#register_terms').is(':checked')) {
								if ($('#userpass').val() == $('#userrepeatpass').val()) {
									// all good, process
									$('a.croissant-close').trigger('click');
									
									var formdata = new FormData();
									
									// project data and client data
									formdata.append('firstname', $('#firstname').val());
									formdata.append('lastname', $('#lastname').val());
									formdata.append('company', $('#company').val());
									formdata.append('company_website', $('#company_website').val());
									formdata.append('usermail', $('#usermail').val());
									formdata.append('telephone', $('#telephone').val());
									formdata.append('jobtype', $('#jobtype').find(':selected').val());
									formdata.append('bookinglocation', $('#location').val());
									formdata.append('ordernumber', $('#ordernumber').val());
									formdata.append('startdate', $('#startdate').val());
									formdata.append('starttime', $('#starttime').val());
									formdata.append('duration', $('#length').find(':selected').val());
									formdata.append('rate', $('#rate').val().replace('£', '').replace(',', ''));
									formdata.append('description', $('#description').val());
									formdata.append('userpass', $('#userpass').val());
									formdata.append('modelid', modelid);
									formdata.append('modelname', modelname);
									formdata.append('kyc', $('#userimageid')[0].files[0]);
									$('body').tinyspinner();
									$.ajax({
										type: 'POST',
										url: '/book/newclient',
										data: formdata,
										enctype: 'multipart/form-data',
										processData: false,
										contentType: false,
										success: function(data) {
											if (data.status != 0) {
												// error
												showError(data);
											} else {
												// success!
												showSuccess(1);
											}
										}
									});
								} else {
									$('#userpass').addClass('error');
									$('#userrepeatpass').addClass('error');
								}
							} else {
								$('#register_terms').parent().addClass('error');
							}
						});
					}
				});
			}
		});
	} else {
		// logged-in user
		var formdata = new FormData();
		
		// project data and client data
		formdata.append('userid', userid);
		formdata.append('jobtype', $('#jobtype').find(':selected').val());
		formdata.append('bookinglocation', $('#location').val());
		formdata.append('ordernumber', $('#ordernumber').val());
		formdata.append('startdate', $('#startdate').val());
		formdata.append('starttime', $('#starttime').val());
		formdata.append('duration', $('#length').find(':selected').val());
		formdata.append('rate', $('#rate').val().replace('£', '').replace(',', ''));
		formdata.append('description', $('#description').val());
		formdata.append('modelid', modelid);
		formdata.append('modelname', modelname);
		
		$('body').tinyspinner();
		$.ajax({
			type: 'POST',
			url: '/book/createproject',
			data: formdata,
			processData: false,
			contentType: false,
			success: function(data) {
				if (data.status != 0) {
					// error
					showError(data);
				} else {
					// success!
					showSuccess(2);
				}
			}
		});
	}
}

function showError(data) {
	let html = '<div class="row"><div class="column" style="margin-bottom: 1em;">';
	if (data.status == 5) {
		html +='<h1>Booking Created</h1></div></div>';
	} else {
		html +='<h1>Sorry</h1></div></div>';
		html += '<div class="row"><div class="column">There was an error. ';
	}
	if (data.status == 1) {
		html += 'We could not upload your ID. Please log in using your email address and password to try uploading your ID again.';
	} else if (data.status == 2) {
		// user creation error
		html += 'We could not create a user account for you. Please try again later.';
	} else if (data.status == 3) {
		// project creation error
		html += 'We could not create your booking. Please try again later.';
	} else if (data.status == 5) {
		html += '<div class="row"><div class="column">'+data.message;
	}
	html += '</div></div>';
	html += '<div class="row"><div class="column" style="margin-top: 2em; margin-bottom: 2em;"><a href="/book" class="button burgundy okbutton">OK</a></div></div>';

	$('body').tinymodal({
		html: html,
		fullscreen: fullScreenModal,
		callback: function() {
			$('.okbutton').off().on('click', function(e) {
				e.preventDefault();
				$('a.croissant-close').trigger('click');
				window.location.href = "/";
			});
		}
	});
}

function showSuccess(type) {
	let html = '<div class="row"><div class="column" style="margin-bottom: 1em;">';
	if (type == 1) {
		html +='<h1>Welcome to iDAL</h1></div></div>'
			+ '<div class="row"><div class="column">Your account has been created and the project details saved.</div></div>'
			+ '<div class="row"><div class="column">When your account is verified, '+modelname+' will be sent the details of your project.</div></div>'
			+ '<div class="row"><div class="column" style="margin-top: 2em; margin-bottom: 2em;"><a href="/book" class="button burgundy okbutton">OK</a></div></div>';
	} else {
		html +='<h1>Booking Created</h1></div></div>'
			+ '<div class="row"><div class="column">'+modelname+' has been sent a booking request.</div></div>'
			+ '<div class="row"><div class="column" style="margin-top: 1em;"><a href="/book" class="button burgundy okbutton">OK</a></div></div>';
	}

	$('body').tinymodal({
		html: html,
		fullscreen: fullScreenModal,
		callback: function() {
			$('.okbutton').off().on('click', function(e) {
				e.preventDefault();
				$('a.croissant-close').trigger('click');
				window.location.href = "/projects";
			});
		}
	});
}