/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
$(function(){
	if (window.location.hash) {
		var url = window.location.hash;
		var hash = url.substring(url.indexOf("#") + 1);
		if ($('#tab-' + hash + '-label').length > 0) {
			var ulid = '.worko-tabs.profile';
			$(ulid).find('input').each(function(e) {
				var href = '#' + $(this).attr('id');
				if (href == '#tab-' + hash) {
					$(this).click();
				}
			});
		}
	}

	// yes, this is swapped
	$('#available').on('click', function(e) {
		var available = 1;
		if ($(this).is(':checked')) {
			available = 0;
		}
		$.ajax({
			type : 'POST',
			url : '/user/calendar/toggle',
			data : {
				'available' : available
			}
		});
	})
	
	$('.saveprofile').on('click', function(e) {
		e.preventDefault();
		
		var inputTypes = ['text', 'select-one', 'textarea', 'password', 'checkbox', 'hidden', 'date'];
		var fields = $('.profileditor').find(':input');
		var inputs = [];
		fields.each(function() {
			if (typeof $(this) !== 'undefined' && (inputTypes.indexOf($(this).get(0).type) >= 0) && !$(this).hasClass('picker__select--year') && !$(this).hasClass('picker__select--month')) {
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
		
		$.ajax({
			type: 'POST',
			url: '/user/profile/update',
			data: {
				'data': inputs
			},
			success: function(resultData) {
//				window.location.reload(true);
			}
		});
		
	})

	function addDays(date, days) {
		date.setDate(date.getDate() + days);
		return date;
	}
	
	$('.convert').on('click', function(e) {
		e.preventDefault();
		let inches = $('#val1').val();
		let cm = inches * 2.5;
		$('#val2').val(cm);
	});
	
	// format instagram input
	if ($('#instagram').length > 0) {
		var cleave = new Cleave('#instagram', {
			prefix: '@',
			noImmediatePrefix: true
		});
	}
	
	// format measurements
//	var heightFormat = new Cleave('#height', {
//		numeral: true
//	});
	
	if ($('#bust').length > 0) {
		var bustFormat = new Cleave('#bust', {
			numeral: true
		});
	
		var waistFormat = new Cleave('#waist', {
			numeral: true
		});
	
		if ($('#hips').length > 0) {
			var hipsFormat = new Cleave('#hips', {
				numeral: true
			});
		}
		
	}
	
	var mobileNumber = new Cleave('#telephone', {
		phone: true,
		phoneRegionCode: 'GB'
	});

	
	// measurements changing
	$('#height').on('keyup', function(e) {
		var cmft = '<span style="text-decoration: underline; font-weight: bold;">cm</span> / <span>ft</span>';
		if ($(this).val().indexOf("'") > -1) {
			$('input[name=height_type]').val('ft');
			$('.heightinput > span').data('measuretype', 'ft');
			cmft = '<span>cm</span> / <span style="text-decoration: underline; font-weight: bold;">ft</span>';
		} else {
			$('input[name=height_type]').val('cm');
			$('.heightinput > span').data('measuretype', 'cm');
		}
		$('.heightinput > span').html(cmft);
	});
	
	$('.cm-or-inches').on('click', function(e) {
		e.preventDefault();
		var type = $(this).data('measuretype');
		var control = $(this).parent().find('input').attr('id');
		var value = $('input[name="'+control+' input"]').val();
		var newtype = type;
		var output = '';
		switch(type) {
			case 'cm':
				newtype = 'in';
				output = '<span>cm</span> / <span style="text-decoration: underline; font-weight: bold;">in</span>';
				break;
			case 'in':
				newtype = 'cm';
				output = '<span style="text-decoration: underline; font-weight: bold;">cm</span> / <span>in</span>';
				break;
		}
		$(this).html(output);
		$(this).data('measuretype', newtype);
		$('input[name="'+control+'_type"]').val(newtype);
		var newvalue = convertValues(value, type, newtype);
		$('input[name="'+control+' input"]').val(newvalue);
	});
	
	$('.cm-or-feet').on('click', function(e) {
		e.preventDefault();
		var type = $(this).data('measuretype');
		var control = $(this).parent().find('input').attr('id');
		var value = $('input[name="'+control+' input"]').val();
		var newtype = type;
		switch(type) {
			case 'cm':
				newtype = 'ft';
				output = '<span>cm</span> / <span style="text-decoration: underline; font-weight: bold;">ft</span>';
				break;
			case 'ft':
				newtype = 'cm';
				output = '<span style="text-decoration: underline; font-weight: bold;">cm</span> / <span>ft</span>';
				break;
		}
		$(this).html(output);
		$(this).data('measuretype', newtype);
		var newvalue = convertValues(value, type, newtype);
		$('input[name="'+control+'_type"]').val(newtype);
		$('input[name="'+control+' input"]').val(newvalue);
	});

	if ($('.blockcompanydetails').length > 0) {
		$('.mydetails').off().on('click', function(e) {
			e.preventDefault();
			$('.myupdates, .companyupdates').removeClass('active');
			$(this).addClass('active');
			$('.blockmydetails').removeClass('active');
			$('.blockcompanydetails').removeClass('active');
			$('.companydetails').removeClass('active');
			$('.blockmydetails').addClass('active');
			$('.myprofiletabs').show();
			$('.companyprofiletabs').hide();
			$('#tab-profile').trigger('click');
		});
		
		$('.companydetails').off().on('click', function(e) {
			e.preventDefault();
			$('.mydetails, .companydetails').removeClass('active');
			$(this).addClass('active');
			$('.blockmydetails').removeClass('active');
			$('.blockcompanydetails').removeClass('active');
			$('.blockcompanydetails').addClass('active');
			$('.myprofiletabs').hide();
			$('.companyprofiletabs').show();
			$('#tab-companyinformation').trigger('click');
		});
	}
	
	$('.requestcompany').on('click', function(e) {
		e.preventDefault();
		var html = '<div class="row"><div class="column"><h1 style="margin-bottom: 1em;">Request Company Account</h1></div></div>';
			html += '<div class="row"><div class="column">Company accounts allow multiple users to work on the same projects. You can request a company account by clicking the button below.</div></div>'
			html += '<div class="row"><div class="column"><a class="button inverted dorequest" style="margin-top: 1em;">Request</a></div></div>';
			
			$('body').tinymodal({
				html: html,
				callback: function(e) {
					$('.dorequest').on('click', function(ev) {
						ev.preventDefault();
						$('a.croissant-close').trigger('click');
						$.ajax({
							type: 'POST',
							url: '/user/requestcompany',
							success: function(resultData) {
								if (resultData == true) {
									$('body').tinymodal({
										title: 'Request Made',
										message: '',
										autoClose: true,
										autoCloseTimeout: 2000
									});
								} else {
									$('body').tinymodal({
										title: 'Sorry',
										message: 'Something went wrong.'
									});
								}
							}
						});
					});
				}
			});
		
	});
	
	$('.inviteuser').on('click', function(e) {
		e.preventDefault();
		var inviteemail = $('#new_email').val();
		if (inviteemail == '') {
			$('body').tinymodal({
				title: 'Sorry',
				message: 'Please enter an email address',
				autoClose: true,
				autoCloseTimetou: 5000
			});
		} else {
			
			// need to check if the user is already part of the company or a member of finda
			$.ajax({ 
				type: 'POST', 
				dataType: 'json', 
				url: '/user/checkemail', 
				data: {
					email: inviteemail
				}, 
				success: function(resultData) {
					if (resultData == true) {
						$('#new_email').val('');
						$.ajax({
							type: 'POST',
							url: '/user/sendinvite',
							data: {
								email: inviteemail
							},
							success: function(resultData) {
								if (resultData == true) {
									$('body').tinymodal({
										title: 'Invitation sent!',
										message: '',
										autoClose: true,
										autoCloseTimeout: 2000,
									});
								} else {
									$('body').tinymodal({
										title: 'Sorry',
										message: 'Something went wrong.'
									});
								}
							}
						});
					} else {
						$('#new_email').val('');
						$('body').tinymodal({
							title: 'Sorry',
							message: 'That email address is not eligible for an invitation to iDAL',
							autoClose: true,
							autoCloseTimeout: 5000,
						});
					}
				}
			});
			
			
		}
	});
});

$(document).ready(function() {
	$('.companyprofiletabs').hide();
	$('#tab-profile').trigger('click');
});
function convertValues(value, from, to) {
	if (from == 'cm' && to == 'in') {
		return centimetersToInches(value);
	} else if (from == 'in' && to == 'ft') {
		return inchesToFeet(value);
	} else if (from == 'ft' && to == 'cm') {
		return feetToCentimeters(value);
	} else if (from == 'cm' && to == 'ft') {
		return centimetersToFeet(value);
	} else if (from == 'in' && to == 'cm') {
		return inchesToCentimeters(value);
	}
}

