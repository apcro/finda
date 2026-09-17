/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
$('.completejob').on('click', function(e) {
	e.preventDefault();
	var jobid = $(this).data('jobid');
	if (jobid != null) {
		$.ajax({
			type: 'POST',
			url: '/projects/completeform',
			data: {
				'jobid': jobid
			},
			success: function(resultData) {
				$('#completeJob').html(resultData);
				$('.finaliseassignment').on('click', function(e) {
					e.preventDefault();
					var values = $('#finaliseassignment').serializeArray();
					$.ajax({
						type: 'POST',
						url: '/projects/finaliseassignments',
						data: {
							value: values,
							jobid: $(this).data('jobid')
						},
						success: function(resultData) {
							window.location.href = '/projects';
						}
					})
				});
			}
		});
	}
});

$('.cannotclosejob').on('click', function(e) {
	e.preventDefault();
	$('body').tinymodal({
		title: 'Oops, something went wrong',
		base_class: 'modalWhite',
		message: 
				'<div class="row"><div class="column">'
				+'<p style="margin-bottom: 1em;">You cannot confirm this project as more models have accepted than<br />'
				+'you originally requested. Please either amend the number of models needed<br />or cancel one or more.</p>' 
				+'</div></div>'
	});
});

var jobid = 0;
$('.closejob').on('click', function(e) {
	e.preventDefault();
	jobid = $(this).data('jobid');
	var past = $(this).data('past');
	var bookingtype = $(this).data('bookingtype');
	
	var title = 'You\'re almost ready!';
	
	var modelcount = $('.job'+jobid).data('modelcount');
	var confirmedcount = $('.job'+jobid).data('confirmedcount');
	
	var message = '';
	
	if (bookingtype == 'casting') {
		message = '<div class="row"><div class="column">'
			+'<p style="margin-bottom: 1em;">To Confirm this casting, click the button below.</p>' 
			+'<p>If you need to cancel the casting, please do so no later than 48 hours<br />before the start date and time to respect iDAL models\' time.</p>'
			+'<p></p>'
			+'<a class="button burgundy" id="close_confirm">Confirm casting</a>'
			+'</div></div>';
	} else {
		if (modelcount != confirmedcount) {
			message += '<p class="notice">You have not confirmed the desired number of models. If you continue this will '
					+'close the project and cancel all the accepted but unconfirmed models.<br /><br />';
			if (modelcount != 1) {
				message += 'You originally created your project with '+modelcount+' models, but ';
			}
			if (confirmedcount == 0) {
				message += 'haven\'t confirmed anyone yet';
			} else {
				message += 'have only confirmed with '+confirmedcount;
			}
			message += '.</p>';
			message += '<p>You may continue to finalise the project and generate your invoice by clicking the <b>FINALISE PROJECT</b> button below. By finalising the project you are accepting the<br /><strong><a href="/projects/bookingterms">Booking Terms and Conditions</a></strong>.</p>'
			
				
		} else {
				message += '<p>This will finalise the project and generate your invoice. By finalising the project you are accepting the<br /><strong><a href="/projects/bookingterms">Booking Terms and Conditions</a></strong>.</p>'
		}
		
		message +='<p>Please pay your invoice on the the <b>invoices</b> page.<br />'
			+'If you need to cancel the project, please do so no later than 48 hours<br />before the start of the project to respect iDAL models\' time.</p>'
			+'<p></p>'
			+'<a class="button burgundy" id="close_confirm">Finalise project</a>'
			+'</div></div>';
	}
	
	var pastMessage = '<div class="row"><div class="column">'
		+ 'Please confirm that the project has happened and pay your outstanding invoice'
		+'<p></p>'
		+'<a class="button burgundy" id="close_confirm">Finalise Project</a>'
		+'</div></div>';
	
	if (past == 1) {
		message = pastMessage;
		title = 'Confirm past project';
	}
	
	$('body').tinymodal({
		title: title,
		base_class: 'modalWhite',
		message: message
	});
	
	$('a#close_confirm').on('click', function(e) {
		e.preventDefault();
		$('.croissant-close').trigger('click');
		if (jobid != null) {
			$.ajax({
				type: 'POST',
				url: '/projects/closejob',
				data: {
					'jobid': jobid,
					'bookingtype': bookingtype
				},
				success: function(resultData) {
					if (resultData != false) {

						
						if (bookingtype == 'casting') {
							$('body').tinymodal({
								title: 'Casting confirmed',
								message: 'This casting has been confirmed.',
								remove_callback: function() {
									window.location.href = '/projects';
								}
							});
						} else {
							var html = '<div class="row"><div class="column"><h1>Project confirmed</h1></div></div>'
									+ '<div class="row" style="margin-top: 2em;"><div class="column"><p>This project has been confirmed and your invoice has been generated.</p></div></div>'
									+ '<div class="row"><div class="column"><p><a class="button inverted" href="/invoices/pay/'+resultData+'">View/Pay Invoice</a></p></div></div>'

							$('body').tinymodal({
								html: html,
								remove_callback: function() {
									window.location.href = '/projects';
								}
							});
						}
					} else {
						$('body').tinymodal({
							title: 'Sorry',
							message: 'There was an error comfirming this job. The job is still open.2',
							remove_callback: function() {
								window.location.href = '/projects';
							}
						});
					}
				}
			});
		}
	})
});

$('.canceljob').on('click', function(e) {
	e.preventDefault();
	jobid = $(this).data('jobid');
	var modal = $('body').tinymodal({
//		title: 'Are you sure?',
		base_class: 'modalWhite',
		html: 	'<div class="row"><div class="column"><h2>Are you sure?</h2></div></div>'
				+'<div class="row" style="margin-top: 1em"><div class="column">You are now cancelling your project and all models.</div></div>'
				+'<div class="row" style="margin-top: 1em"><div class="column">'
				+'<a class="button" id="cancel_confirm">Cancel project</a>'
				+'</div></div>',
		retainModal: false
	});
	$('a#cancel_confirm').on('click', function(e) {
		e.preventDefault();
		$('.croissant-close').trigger('click');
		if (jobid != null) {
			$.ajax({
				type: 'POST',
				url: '/projects/canceljob',
				data: {
					'jobid': jobid
				},
				success: function(resultData) {
					$('.job' + jobid).remove();
//					$masonry.masonry();
					$('body').tinymodal({
						title: 'Project deleted',
						message: 'This project has been deleted',
						remove_callback: function() {
							$('.job' + jobid).stop().animate({ 
								"opacity": "0",
								"height": 0}, {
									duration: 300
								});
						}
					})
				}
			});
		}
	});
});

$('.removecallsheet').on('click', function(e) {
	e.preventDefault();
	var jobid = $(this).data('jobid');
	$.ajax({
		type: 'POST',
		url: '/projects/removecallsheet',
		data: {
			'jobid': jobid
		},
		success: function(resultData) {
			$('.callsheet-'+jobid).empty();
		}
	});
});

$('.deletejob').on('click', function(e) {
	e.preventDefault();
	var jobid = $(this).data('jobid');
	var that = this;
	if (jobid != null) {
		$.ajax({
			type: 'POST',
			url: '/projects/edit/'+jobid+'/deletejob',
			data: {
				'jobid': $('input[name=jobid]').val()
			},
			success: function(resultData) { 
				if (resultData == true) {
					$('.job_card.job'+jobid).addClass('faded').find('.card_type').removeClass('past').addClass('deleted');
					$(that).remove();
				}
			}
		})
	}
});

$('.add_info').on('click', function(e) {
	e.preventDefault();
	var that = this;
	$(this).parent().find('.job_additional_information').toggle();
	$(this).parent().find('.savebutton.small').off().on('click', function(e) {
		e.preventDefault();
		$(that).parent().find('.job_additional_information').hide();
	})
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
	} else if ($(this).hasClass('past')) {
		$('.job_past').show();
	} else if ($(this).hasClass('history')) {
		$('.job_history').show();
	}
	
});

$('.usetemplatedropdown').on('change', function(e) {
	e.preventDefault();
	var templateid = $(this).find(':selected').val();
	if (templateid == 'edit') {
		window.location.href="/templates";
	} else {
		createFromTemplate(templateid, $(this).find(':selected').html());
	}
});

function setupCompanyTabs() {
	$('.myprojects').off().on('click', function(e) {
		e.preventDefault();
		$('.myprojects, .companyprojects, .mytemplates').removeClass('active');
		$(this).addClass('active');
		$('.blockmyprojects').removeClass('active');
		$('.blockcompanyprojects').removeClass('active');
		$('.blocktemplates').removeClass('active');
		$('.blockmyprojects').addClass('active');
		updateJobListCounts('blockmyprojects');
		$('.project_filters').show();
	});
	
	if ($('.blockcompanyprojects').length > 0) {
		$('.companyprojects').off().on('click', function(e) {
			e.preventDefault();
			$('.myprojects, .companyprojects, .mytemplates').removeClass('active');
			$(this).addClass('active');
			$('.blockmyprojects').removeClass('active');
			$('.blockcompanyprojects').removeClass('active');
			$('.blocktemplates').removeClass('active');
			$('.blockcompanyprojects').addClass('active');
			updateJobListCounts('blockcompanyprojects');
			$('.project_filters').show();
		});
	}
	
}

function createFromTemplate(templateid, templatename) {
	var html = '<div class="row"><div class="column"><h2>Create New Booking</h2><br /><h3>Using template<br />"'+templatename+'"</h3></div></div>';
		html += '<div class="row"><div class="column"><label for="projectname">Booking Name</label><input type="text" name="projectname" placeholder="Enter project name"></div></div>';
		html += '<div class="row"><div class="column"><label for="startdate">Start Date</label><input type="text" name="startdate" placeholder="Project start date"></div></div>';
		html += '<div class="row"><div class="column"><a class="button burgundy confirmcreatefromtemplate">Create</div></div>';
	$('body').tinymodal({
		html: html,
		callback: function(e) {
			$('input[name=startdate]').Zebra_DatePicker({
				direction: true,
				disable_time_picker: true,
				format: 'd-m-Y',
				icon_position: "left",
				show_icon: false,
				offset: [-300, 0]
			});
			$('.confirmcreatefromtemplate').off().on('click', function(e) {
				e.preventDefault();
				var projectname = $('input[name=projectname]').val();
				var startdate = $('input[name=startdate]').val();
				if (projectname != '') {
					$('a.croissant-close').trigger('click');
					$.ajax({
						type: 'POST',
						url: '/projects/createfromtemplate',
						data: {
							'templateid': templateid,
							'projectname': projectname,
							'startdate': startdate
						},
						success: function(resultData) { 
							if (resultData.status == true) {
								window.location.href = '/projects/edit/' + resultData.id + '#models'
							}
						}
					})
					
				} else {
					$('input[name=projectname]').addClass('error');	
				}
			});
		}
	})
}

var jobUpcoming, jobPast, jobHistory;

function updateJobListCounts(showing) {
	jobUpcoming = $('.' + showing+' .job_upcoming .job_card').length;
	jobPast = $('.' + showing+' .job_past .job_card').length;
	jobHistory = $('.' + showing+' .job_history .job_card').length;
	$('span.upcoming').html(jobUpcoming);
	$('span.past').html(jobPast);
	$('span.history').html(jobHistory);	// for historical reasons these vars are named differently
}

$(document).ready(function() {
	$('.job_past').hide();
	$('.job_history').hide();
	changeTabByHash();
	setupCompanyTabs();
//	setupTemplateTab();
	updateJobListCounts('blockmyprojects');
	
	var url = window.location.hash;
	var hash = url.substring(url.indexOf("#") + 1);
	if (hash == 'templates') {
		$('.mytemplates').trigger('click');
		history.pushState(null, null, '/projects' );
	}
	
});
