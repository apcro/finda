/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
// force redirect on mobile devices, except for limited pages
if ($.croissant.isMobile()) {
	window.location.href="/m/loggedin";
}

var negotiatetimeunits;
$(function() {
	if (window.location.hash) {
		var url = window.location.hash;
		var hash = url.substring(url.indexOf("#") + 1);
		$('.offer'+hash).addClass('flashHighlight');
		setTimeout(function(){
			$('.offer'+hash).removeClass('flashHighlight');
		},1500);
	}
	
	$('.moreInfo').on('click', function(e) {
		e.preventDefault();
		var jobid = $(this).data('jobid');
		if (jobid != null) {
			$('#moreInfo').html('')
			$.ajax({
				type: 'POST',
				url: '/projects/more-info',
				data: {
					'jobid': jobid
				},
				success: function(resultData) {
					$('#moreInfo').html(resultData).updateTinyModal()
					
				}
			})
	
		}
	});
	
	if ($('input[name=negotiation]').length > 0) {
		var negotiateRate = new Cleave('input[name=negotiation]', {
			numeral: true,
			numeralPositiveOnly: true,
			prefix: '£'
		});
		$('input[name=negotiation]').on('change', function(e) {
			var rawvalue = $(this).val().replace('£', '');
			var value = (rawvalue * negotiatetimeunits) * 0.9;
			$('#totaltomodel').html('Total to you: £' + value.toFixed(2));
		})
		
	}

	$('.negotiate, .job_negotiate').on('click', function(e) {
		e.preventDefault();
		var jobrate = $(this).data("jobrate").replace(/(\d)(?=(\d{3})+\.)/g, "$1,").replace(/\.00/g, '');
		var jobunits = $(this).data("jobunits");
		negotiatetimeunits = $(this).data("timeunits");
		$('span.jobrate').html(jobrate);
		$('span.jobunit').html(jobunits);
		$('input[name=negotiate-jobid]').val($(this).data('jobid'));
		$('input[name=negotiation]').val(jobrate);
		$('input[name=currentrate]').val(jobrate);
		$.each($('.tgl.reason'), function() {
			this.checked = false;
		});
		var value = ((jobrate * negotiatetimeunits) * 0.9);
		$('#totaltomodel').html('Total to you: £' + value.toFixed(2));
		setNegotiateButton($(this).parent());
	});
	
	function setNegotiateButton(container) {
		$('.negotiateButton').off('click').on('click', function(e) {
			e.preventDefault();
			$('a.croissant-close').trigger('click');
			var jobid = $('input[name=negotiate-jobid]').val();
			var msgid = $('input[name=negotiate-jobid]').val();
			
			var currentRateString = $('input[name=currentrate]').val();
			currentRateString = currentRateString.replace(/[^\d\.\-]/g, ""); 
			var currentRate = parseFloat(currentRateString);
			
			var desiredRateString = $('input[name=negotiation]').val();
			desiredRateString = desiredRateString.replace(/[^\d\.\-]/g, ""); 
			var desiredRate = parseFloat(desiredRateString);
			
			var reasons = [];
			$.each($('.tgl.reason'), function(key, value) {
				if ($(this).is(':checked')) {
					reasons.push($(this).data('reason'));
				}
			});
			
			if (currentRate < desiredRate) {
				$.ajax({
					type: 'POST',
					url: '/projects/negotiate',
					data: {
						'jobid': jobid,
						'rate': desiredRate, 
						'reasons': reasons.join(',')
					},
					success: function(resultData) {
						if (resultData == true) {
							$('#main').tinymodal({
								title: 'Negotiation sent',
								message: '',
								base_class: 'modalWhite',
								autoClose: true,
								autoCloseTimeout: 2000,
								remove_callback: function() {
									window.location.reload();
								}
							});
						}
					}
				})
			} else {
				$('a.croissant-close').trigger('click');
			}
		});
	}
	
	$('.accept, .jobaccept').on('click', function(e) {
		e.preventDefault();
		var jobid = $(this).data('jobid');
		var bookingtype = $(this).data('bookingtype');
		var requestaddress = $(this).data('requestaddress')
		var msgid = $('input[name=negotiate-jobid]').val();
		
		var message = "";
		
		if (bookingtype == "booking") {
			message = 	'<div class="row"><div class="column"><h2>Are you sure?</h2></div></div>'
				+ '<div class="row"><div class="column">'
				+'<p style="margin-bottom: 1em;">You are now accepting the job offer and waiting to see if the client will confirm your job. The <b><a href="/jobs/bookingterms">Booking Terms and Conditions</a></b> previously sent to you by email.</p>'
				+'<button class="button inverted" id="accept_confirm">Accept Offer</button>'
				+'</div></div>';
		} else if (bookingtype == "casting") {
			message = 	'<div class="row"><div class="column"><h2>Are you sure?</h2></div></div>'
				+ '<div class="row"><div class="column">'
				+'<p style="margin-bottom: 1em;">This will confirm your acceptance of the Casting Invitation.</p>'
				+'<button class="button inverted" id="accept_confirm">Accept Offer</button>'
				+'</div></div>';
		}
		
		if (requestaddress == 1) {
			message = 	'<div class="row"><div class="column">'
						+'<p style="margin-bottom: 1em;">You are now accepting the job offer and waiting to see if the client will confirm your job. The <b><a href="/jobs/bookingterms">Booking Terms and Conditions</a></b> previously sent to you by email.</p>'
						+'<p></p>'
						+'<p>Please enter your address for Product delivery:</p>'
						+'<input type="text" name="deliveryaddress-' + jobid + '" />'
						+'<button class="button inverted" id="accept_confirm">Accept Offer</button>'
						+'</div></div>';
		}
		
		$('body').tinymodal({
			html: message
		});

		$('#accept_confirm').on('click', function(e) {
			e.preventDefault();
			$('.croissant-close').trigger('click');
		
			if (jobid != null) {
				$.ajax({
					type: 'POST',
					url: '/projects/accept',
					data: {
						'jobid': jobid,
						address: $('input[name=deliveryaddress-'+jobid+']').val()
					},
					success: function(resultData) {
						if (resultData == true) {
							window.location.reload();
						} else {
							$('body').tinymodal({
								title: 'Sorry',
								message: 'Something went wrong.'
							});
						}
					}
				})
			}
		});
	});
	
	$('.reject, .jobreject').on('click', function(e) {
		e.preventDefault();
		$('input[name=reject-jobid]').val($(this).data('jobid'));
		$.each($('.tgl.rejectreason'), function() {
			this.checked = false;
		});
		setRejectButton($(this).parent());
		
	});
	
	function setRejectButton(container) {
		var jobid = $('input[name=reject-jobid]').val();
		$("#delete_confirm").off().on('click', function(e) {
			e.preventDefault();
			var reasons = [];
			console.log($('.tgl.rejectreason'));
			$.each($('.tgl.rejectreason'), function(key, value) {
				if ($(this).is(':checked')) {
					reasons.push($(this).data('reason'));
				}
			});
			$.ajax({
				type: 'POST',
				url: '/projects/reject',
				data: {
					'jobid': jobid, 
					'reasons': reasons.join(',')
				},
				success: function(resultData) { 
					if (resultData == true) {
						$('.job_card.job' + jobid).stop().animate({ 
							"opacity": "0"}, {
								duration: 300,
								complete: function() { 
									$('.job_card.job' + jobid).remove();
									$('a.croissant-close').trigger('click');
									window.location.replace('/jobs');
								}
							});
					} else {
						
					}
				}, 
				failure: function(resultData) {
					
				}
			})
		});
		$("#delete_cancel").off().on('click', function(e) {
			e.preventDefault();
			$('a.croissant-close').trigger('click');
		});
	}
	$('.rejectoption').on('click', function(e) {
		e.preventDefault();
		var jobid = $(this).data('jobid');
		$('#finda-website').tinymodal({
			title: 'Are you sure?',
			base_class: 'modalWhite',
			message: '<div class="row"><div class="column"><p>You will be able to negotiate a different rate if the client offers you this job later.</p><p>&nbsp;</p></div></div>'
					+'<div class="row"><div class="column">'
					+'<button class="button white errorbutton delete_confirm" id="delete_confirm" data-jobid="' + jobid + '" type="button delete" value="Reject option" >Decline option</button>'
					+'</div><div class="column">'
					+'<button class="close button white cancel" id="delete_cancel" type="button cancel" value="Cancel">Cancel</button>'
					+'</div></div>',
			callback: function(e) {
				$('.delete_confirm').off().on('click', function() {
					var msgid = $(this).data('msgid');
					$.ajax({
						type: 'POST',
						url: '/projects/rejectoption',
						data: {
							'jobid': jobid
						},
						success: function(resultData) { 
							$('.job_card.job' + jobid).stop().animate({ 
								"opacity": "0"}, {
									duration: 300,
									complete: function() { 
										$('.job_card.job' + jobid).remove();
										$('a.croissant-close').trigger('click');
									}
								});
						}, 
						failure: function(resultData) {
							
						}
					})
				});
				$("#delete_cancel").off().on('click', function() {
					$('a.croissant-close').trigger('click');
				});
			}
		});
	});
	
	$('.rejectaccept, .jobcancel').on('click', function(e) {
		e.preventDefault();
		var jobid = $(this).data('jobid');
		$('body').tinymodal({
			title: 'Are you sure?',
			base_class: 'modalWhite',
			message: '<button class="button white errorbutton delete_confirm" id="delete_confirm" data-jobid="' + jobid + '" type="button delete" value="Cancel acceptance" >Cancel Acceptance</button>',
			callback: function(e) {
				$('.delete_confirm').off().on('click', function(e) {
					e.preventDefault();
					$('a.croissant-close').trigger('click');
					var msgid = $(this).data('msgid');
					$.ajax({
						type: 'POST',
						url: '/projects/cancelacceptance',
						data: {
							'jobid': jobid
						},
						success: function(resultData) { 
							if (resultData == true) {
								$('.job_card.job' + jobid).remove();
								window.location.replace('/jobs');
							} else {
								$('body').tinymodal({
									title: 'Sorry',
									'message': 'Something went wrong. We\'ve made a note.'
								});
								
							}
						}, 
						failure: function(resultData) {
							
						}
					})
				});
			}
		});
	})
	
	$('.completed').on('click', function(e) {
		e.preventDefault();
		var jobid = $(this).data('jobid');
		if (jobid != null) {
			$.ajax({
				type: 'POST',
				url: '/projects/completejob',
				data: {
					'jobid': jobid
				},
				success: function(resultData) {
					window.location.replace('/jobs');
				}
			})
		}
	});
	
	$('.project_filter_tab').on('click', function(e) {
		e.preventDefault();
		e.stopPropagation();
		$.each($('.project_filter_tab'), function() {
			$(this).removeClass('active');
		});
		$('.job_upcoming').hide();
		$('.job_past').hide();
		$('.job_history').hide();
		$(this).addClass('active');
		
		if ($(this).hasClass('upcoming')) {
			$('.job_upcoming').show();
			window.location.hash = 'upcoming';
		} else if ($(this).hasClass('past')) {
			$('.job_past').show();
			window.location.hash = 'offers';
		} else if ($(this).hasClass('history')) {
			$('.job_history').show();
			window.location.hash = 'history';
		}
		
	});
	
//	$('.lastminute h4').on('click', function(e) {
//		$('.lastminute_expander').toggle('fast');
//	});
	
	$('.rounded_tickbox').on('click', function(e) {
		if ($(this).hasClass('neutral')) {
			$(this).removeClass('neutral').addClass('selected');
		} else if ($(this).hasClass('selected')) {
			$(this).removeClass('selected').addClass('deselected');
		} else {
			$(this).removeClass('deselected').addClass('neutral');
		}
		
		// now update
		var availability = {
			'sunday': 0,
			'monday': 0,
			'tuesday': 0,
			'wednesday': 0,
			'thursday': 0,
			'friday': 0,
			'saturday': 0
		};
		$.each($('.rounded_tickbox'), function(e) {
			if ($(this).hasClass('selected')) {
				availability[$(this).data('day')] = 1;
			}
			if ($(this).hasClass('deselected')) {
				availability[$(this).data('day')] = 2;
			}
		});
		$.ajax({
			type: 'POST',
			url: '/user/updateavailability',
			data: {
				'availability': availability
			}
		});
	})

});
$(document).ready(function() {
	$('.job_past').hide();
	$('.job_history').hide();
	changeTabByHash();
});