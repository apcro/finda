/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
function createJobForm() {

	$('input, textarea').on('focus', function() {
		$(this).removeClass('error');
	})
	var rightNow = new Date();
	var res = rightNow.toISOString().slice(0,10).replace(/-/g,"");

	var jobType = $('#jobtype').val();
	var bookingtype = $('input[name=bookingtype]').val();
	
	$('#startdate').Zebra_DatePicker({
		direction: true,
		disable_time_picker: true,
		format: 'd-m-Y',
		icon_position: "left",
		show_icon: false,
		offset: [-300, 0]
	
	});
	
	if ($('#modelsubtotal').length > 0 ) {
		var cleaverate = new Cleave('#modelsubtotal', {
			numeral: true,
			numeralDecimalScale: 2
		});
	}
	var cleaveduration = new Cleave('#length', {
		numeral: true,
		numeralDecimalScale: 2
	});
	
	if (bookingtype == 'booking') {
		var cleavemodelcount = new Cleave('#modelcount', {
			numeral: true,
			numeralDecimalScale: 0
		});
	}
	
	if (bookingtype == 'booking') {
	
		$('#unitstype').on('change', function() {
			var type = $(this).val();
			switch(type) {
				case 'day':
					$('#ratelabel').html('Rate per Day');
					break;
				case 'hour':
					$('#ratelabel').html('Rate per Hour');
					break;
			}
		})
	}

	function addDays(date, days) {
		date.setDate(date.getDate() + days);
		return date;
	}
	
	$('.createjob').on('click', function(e) {
		e.preventDefault();
		$("#createjob-form").trigger('submit');
	})
	
	$("#createjob-form").submit(function(e){
		e.preventDefault();
		
		var error = false;
		var errorpage = 100;
		var form = this;
		
		var jobType = $('#jobtype').val();
		
		console.log(jobType);
		
		if (error) {
			error = true;
		}
		
		$("#createjob-form input, #createjob-form select").removeClass("error");

		if (isEmptyOrSpaces($('#name').val())) {
			$('#name').addClass('error');
			error = true;
			if (errorpage > 0) {
				errorpage = 0;
			}		
		}

		if (isEmptyOrSpaces($('#description').val())) {
			$('#description').addClass('error');
			error = true;
			if (errorpage > 0) {
				errorpage = 0;
			}		
		}

		
		if ($('#jobtype').val() ==  null) {
			$('#jobtype').addClass('error');
			error = true;
			if (errorpage > 1) {
				errorpage = 1;
			}

		}
		
		if (isEmptyOrSpaces($('#location').val())) {
			$('#location').addClass('error');
			error = true;
			if (errorpage > 2) {
				errorpage = 2;
			}
		}

		if ($("#length").val() == '') {
			$("#length").addClass('error');
			error = true;
			if (errorpage > 10) {
				errorpage = 10;
			}

		}
		
		// @TODO this check needs to be on unpaid selector
		var unitstype = $('input[name="unitstype input"]:checked').val();
		if (jobType != 75 && jobType != 78 && unitstype != 'unpaid') {
			if ($("#rate").val() == '') {
				$("#rate").addClass('error');
				error = true;
				if (errorpage > 10) {
					errorpage = 10;
				}
				
			}	
		
			if (bookingtype == 'booking') {
				if ($("#modelcount").val() == '') {
					$("#modelcount").addClass('error');
					error = true;
					if (errorpage > 9) {
						errorpage = 9;
					}
				}
			}
		}

		if ($("#startdate").val() == '') {
			$("#startdate").addClass('error');
			error = true;
			if (errorpage > 3) {
				errorpage = 3;
			}
		}	

		if (!error) {
			form.submit();
		} else {
			$('body').tinymodal({
				title: '<i class="fas fa-clipboard-list"></i> Missing information',
				message: 'Please go back and fill in all the highlighted fields',
				zindex: 10007,
				retainModal: true
			});
		}
	});
}

