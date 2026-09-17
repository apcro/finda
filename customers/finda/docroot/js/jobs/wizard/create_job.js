/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
	var minHourly = 0;
var minDaily = 0;

var bookingtype = 'booking';

var modelcount = 0;
var projectduration = 0;

function initiateJobCreator() {
	var containerWidth = $('#createjob-form').outerWidth();

//	$('#createjob-form').css('width', containerWidth+'px');
	$('.skipusagerow').hide();
	
	bookingtype = $('input[name=bookingtype]').val();
	
	if (bookingtype == 'booking') {
		$('#length, #modelsubtotal, #modelcount').on('change, blur', function(e) {
			var rateval = $('#modelsubtotal').val().replace("£", "").replace(",", "");
			var length = parseFloat($('#length').val());
			var rate = parseFloat($('#modelsubtotal').val().replace("£", "").replace(",", ""));
			var models = $('#modelcount').val();
			modelcount = models;
			var projectdurationcalc = (length >= 1?length:1);
			var subtotal = projectdurationcalc * rate * models;
			var modelsubtotal = rate * projectdurationcalc;
			
			
			if (!isNaN(subtotal)) {
				var findafee = subtotal * .1;
				var vat = (subtotal + findafee) * .2;
				var total = subtotal + findafee + vat;
				total = parseFloat(Math.round(total * 100) / 100).toFixed(2)
				$('#ratesubtotal').val('£' + total);
				
				total = parseFloat(Math.round(modelsubtotal * 100) / 100).toFixed(2)
			}
			var modelcountwords = ' for ' + modelcount + ' model';
			if (modelcount > 1) {
				modelcountwords += 's';
			}
			$('#modelcounttotal').html(modelcountwords + ' for ');
			var joblength = $('#length').find(':selected').val();
			var joblengthwords = '' + joblength + ' day';
			if (joblength > 1) {
				joblengthwords += 's';
			}
			$('span.joblength').html(joblengthwords);
		});
	} else {
		$('#length').on('change, blur', function(e) {
			$('.step4').fadeIn('fast');
			$('.step6').fadeIn('fast');
			var joblength = $('#length').find(':selected').val();
			var joblengthwords = '' + joblength + ' day';
			if (joblength > 1) {
				joblengthwords += 's';
			}
			$('span.joblength').html(joblengthwords);
		});
	}
	
	$('input[name=baseusage]').on('change', function(e) {
		e.preventDefault();
		$.each($('.triplet-checkbox.rights label'), function() {
			$(this).removeClass('active');
		});
		var type = $(this).attr('id');
		$('label[for='+type+']').addClass('active');
		switch(type) {
			case 'standardrights':
				$('.rights-holder').hide();
				countOn();
				break;
			case 'extrarights':
				$('.rights-holder').show();
				enableAllRights();
				break;
		
		}
	});
	
	$('.advanced-checkboxes .tgl').on('change', function(e) {
		if ($(this).is(':checked')) {
			$('textarea[name='+$(this).attr('id')+']').show();
		} else {
			$('textarea[name='+$(this).attr('id')+']').hide();
		}
	});
	
	$('.base-rights-holder .tgl').on('change', function(e) {
		e.preventDefault();
		if ($('#standardrights').is(':checked')) {
			countOn();
		}
	});
	
	$('select[name="jobtype input"]').on('change', function(e) {
		e.preventDefault();
		var selected = $(this).find('option:selected');
		var jobtype = selected.val();
		minHourly = selected.data('hourly');
		minDaily = selected.data('daily');
		$('#modelsubtotal').removeAttr("disabled");
		$('#modelsubtotal').attr("placeholder", "Offered fee");
		
		$('.projectnormal').show();
		$('.projectinfluencer').hide();
		$('input[name=projecttype]').val('normal');
		
		$('.chooseprojecttypenotice').hide();
		$('.row.rateinfo').show();
		
//		if (bookingtype == 'booking') {
//			$('.step3, .step4').show();
//		} else {
			$('.step3').show();
//		}
		
		switch (jobtype) {
			case '12':
				$('.projectnormal').hide();
				$('.projectinfluencer').show();
				$('input[name=projecttype]').val('influencer');
				break
			case '3':
			case '4':
			case '8':
			case '51':
				$('.skipusage').hide();
				$('.step4').fadeIn('fast');
				break;
			default:
				$('.skipusage').show();
				break;
			}
	});
	
	$('#standardrights').on('change', function(e) {
		if (bookingtype == 'booking') {
			$('.step4').fadeIn('fast');
			if ($(this).find(':selected').val() != 'ukrights' ) {
				$('.extrarightsnotice').show();
			} else {
				if ($('#period').find(':selected').val() == '6' ) {
					$('.extrarightsnotice').hide();
				}
			}
		}
		
	});
	
	$('#period').on('change', function(e) {
		if (bookingtype == 'booking') {
			$('.step4').fadeIn('fast');
			if ($(this).find(':selected').val() != '6' ) {
				$('.extrarightsnotice').show();
			} else {
				if ($('#standardrights').find(':selected').val() == 'ukrights' ) {
					$('.extrarightsnotice').hide();
				}
			}
		}
		
	});
	
	// the new rate calculation
	$('#modelsubtotal').on('keyup', function(e) {
		var rate = $(this).val().replace('£', '').replace(',', '');
		var selected = $('select[name="jobtype input"]').find('option:selected');
		var jobtype = selected.html();
		
		var projectdurationcalc = (projectduration >= 1?projectduration:1);
		
		// calculate some minimums, if the 'rate' value is more 2 digits
		var rateString = rate.toString();
		if (rateString.length >= 2) {
			if (rate < (minDaily * projectduration)) {
				$('.minrate_notice').html('The minimum daily rate for ' + jobtype + ' jobs is £' + minDaily + ' (£' + (minDaily*projectduration) +' each for this project), however models are more likely to accept higher rates, depending on your project');
				$('.minrate_notice').fadeIn('fast');
				$('.step6, .step7, .step8, .step9, .step10, .step11').hide();

			} else {
				$('.step6').fadeIn('fast');
				$('.minrate_notice').fadeOut('fast');
			}
		} else {
			$('.step6').fadeIn('fast');
			$('.minrate_notice').fadeOut('fast');
		}
		
		var subtotal = (rate * projectdurationcalc * modelcount);

		if (subtotal == 0) {
			$('.zerorate').removeClass('hidden');
		} else {
			$('.zerorate').addClass('hidden');
		}
		
		var findafee = subtotal * .1;
		var vat = (subtotal + findafee) * .2;
		var total = subtotal + findafee + vat;
		total = parseFloat(Math.round(total * 100) / 100).toFixed(2)
		$('#ratesubtotal').val('£' + total);
	});
	
	$('#modelcount').on('keyup', function(e) {
		if (bookingtype == 'booking') {
			if ($('#hourly').is(':checked')) {
				var length = $(this).val();
				if (length >= 5) {
					$('.minlength_notice').html('5 hours or more is considered 1 working day, please insert 1 day.');
					$('.minlength_notice').show();
				} else {
					$('.minlength_notice').hide();
				}
			} else {
				$('.minlength_notice').hide();
			}
			projectduration = $(this).find('option:selected').val();
			updateModelCount();
			if (modelcount != 0 && modelcount != '' && projectduration != '') {
				$('.chooseprojectdurationnotice').hide();
				$('.step5').fadeIn('fast');
			}
		} else {
			$('.step4').fadeIn('fast');
		}
	});
	
	$('#modelcount').on('blur', function(e) {
		modelcount = $(this).val();
		if (modelcount != 0 && modelcount != '' && projectduration != '') {
			$('.step5').fadeIn('fast');
		}
		updateModelCount();
	});
	
	$('#startdate').on('blur', function(e) {
		if (bookingtype != 'booking') {
			$('.step4').fadeIn('fast');
		} else {
			$('.step7').fadeIn('fast');
		}
	});

	$('#location').on('keyup', function(e) {
		if (bookingtype == 'booking') {
			$('.step8, .step9').fadeIn('fast');
		}
	});

	$('#contact_number').on('keyup', function(e) {
		if (bookingtype == 'booking') {
			$('.step10').fadeIn('fast');
		} else {
			$('.step5, .step6').fadeIn('fast');
		}
	});

	$('#description').on('keyup', function(e) {
		if (bookingtype == 'booking') {
			$('.step11').fadeIn('fast');
		} else {
			$('.step7').fadeIn('fast');
		}
	});
	
	enableAllRights();
	countOn();
	setRights();
	$('.notmoney').hide();
	
	createJobForm();
}

function updateModelCount() {
	var modeldisplay = '';
	if (projectduration == .5) {
		modeldisplay += 'half a day';
	} else if (projectduration == 1) {
		modeldisplay += projectduration + ' day';
	} else {
		modeldisplay += projectduration + ' days';
	}
	if (modelcount == 1) {
		$('.modelcountgrammar').html('find a model');
	} else {
		$('.modelcountgrammar').html('find some models');
	}
}

function setRights() {
	if ($('#standardrights').is(':checked')) {
		$('.rights-holder').hide();
	} else {
		$('.rights-holder').show();
		enableAllRights();
	}
}
function countOn() {
	var count = 0;
	enableAllRights();
	$.each($('.base-rights-holder .tgl'), function() {
		if ($(this).is(':checked')) {
			count++;
		}
		if (count >=3) {
			disableAllRights();
			return count;
		}
	});
	return count;
}

function disableAllRights() {
	$.each($('.base-rights-holder .tgl'), function() {
		if ($(this).is(':checked')) {
		} else {
			$(this).prop('disabled', true);
			$(this).parent().addClass('disabled');
		}
	});
}

function enableAllRights() {
	$.each($('.base-rights-holder .tgl'), function() {
		$(this).prop('disabled', false);
		$(this).parent().removeClass('disabled');
	});
}

