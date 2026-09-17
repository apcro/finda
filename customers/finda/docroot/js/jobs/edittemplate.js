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

var templateid;

$(window).ready(function() {
	
	minHourly = $('input[name=minHourly]').val();
	minDaily = $('input[name=minDaily]').val();

	$('select[name="jobtype input"]').on('change', function(e) {
		e.preventDefault();
		var selected = $(this).find('option:selected');
		var jobtype = selected.val();
		minHourly = selected.data('hourly');
		minDaily = selected.data('daily');
		switch (jobtype) {
			case '12':
				$('.projectnormal').hide();
				$('.projectinfluencer').show();
				break
			default:
				$('.projectnormal').show();
				$('.projectinfluencer').hide();
				break;
			}
	});

	if ($('select[name="jobtype input"]').val() == 12) {
		$('.projectnormal').hide();
		$('.projectinfluencer').show();
	} else {
		$('.projectnormal').show();
		$('.projectinfluencer').hide();
	}
	
	if ($('#rate').length > 0) {
		var rate = new Cleave('#rate', {
			numeral: true,
			numeralPositiveOnly: true,
			prefix: '£'
		});
	}
	
	$.each($('.additional-info .tgl'), function() {
		if ($(this).is(':checked')) {
			$('textarea[name='+$(this).attr('id')+']').show();
		} else {
			$('textarea[name='+$(this).attr('id')+']').hide();
		}
	});
	$('.additional-info .tgl').on('change', function(e) {
		if ($(this).is(':checked')) {
			$('textarea[name='+$(this).attr('id')+']').show();
		} else {
			$('textarea[name='+$(this).attr('id')+']').hide();
		}
	});
	
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
	
	$('.base-rights-holder .tgl').on('change', function(e) {
		e.preventDefault();
		if ($('#standardrights').is(':checked')) {
			countOn();
		}
	});

	$('.cancelchanges').on('click', function(e) {
		e.preventDefault();
		location.reload();
	});
	
	
	$('select[name="jobtype input"]').on('change', function(e) {
		e.preventDefault();
		var jobtype = $(this).val();
		$('.base-rights-holder').show();
		switch (jobtype) {
			case '12':
				$('.base-rights-holder').hide();
				break
			case '3':
			case '4':
			case '8':
			case '51':
				break;
			default:
				break;
		}
		$('.jobtype_header').html($('#jobtype option:selected').text());
	});
	
	enableAllRights();
	countOn();
	setRights();
	enableTemplateLoader();
	
	if ($('select[name="jobtype input"]').val() == 12) {
		$('.base-rights-holder').hide();
	}
	
	$('#rate').on('blur', function(e) {
		if ($('#baserateradio').is(':checked')) {
			var rate = parseInt($(this).val().replace('£', '').replace(',', ''));
			var selected = $('select[name="jobtype input"]').find('option:selected');
			var jobtype = selected.html();
			var unitstype_selected = $('#unitstype').find('option:selected');
			if (unitstype_selected.val() == 'day') {
				if (rate < minDaily) {
					$('.minrate_notice').html('The minimum daily rate for<br />' + jobtype + ' jobs is £' + minDaily);
					$('.minrate_notice').show();
					$('.updatebtn').attr('disabled', 'disabled');
				} else {
					$('.minrate_notice').hide();
					$('.updatebtn').removeAttr("disabled");
					
				}
			} else if (unitstype_selected.val() == 'hour') {
				if (rate < minHourly) {
					$('.minrate_notice').html('The minimum hourly rate for<br />' + jobtype + ' jobs is £' + minHourly);
					$('.minrate_notice').show();
					$('.updatebtn').attr('disabled', 'disabled');
				} else {
					$('.minrate_notice').hide();
					$('.updatebtn').removeAttr("disabled");
				}
			}
		}
	});
	
	$('.edittemplate').on('click', function(e) {
		e.preventDefault();
		$('a.croissant-close').trigger('click');
		
		var data = $('#templateform').serialize();
		$.post('/templates/update', data, function(resultData) {
			if (resultData.result == true) {
				$('.templatelist').html(resultData.html);
				enableTemplateLoader();
				$('body').tinymodal({
					title: 'Saved',
					message: '',
					autoClose: true,
					autoCloseTimeout: 2000
				});
			} else {
				$('body').tinymodal({
					title: 'Something went wrong',
					message: 'We couldn\'t save your changes. Please try again later.',
					autoClose: true,
					autoCloseTimeout: 2000
				});
			}
		}, 'json');
		
	});

	$('.deletetemplate').on('click', function(e) {
		e.preventDefault();
		$('body').tinymodal({
			title: 'Are you sure?',
			message: '<p>This cannot be undone</p><div class="row"><div class="column"><div class="button errorbutton" id="confirmdelete">Delete</div></div></div>',
			callback: function(e) {
				$('#confirmdelete').off().on('click', function(e){
					e.preventDefault();
					$('a.croissant-close').trigger('click');
					$.ajax({
						type: 'POST',
						url: '/templates/delete',
						data: {
							'templateid': templateid		// scope global, this function only accessible after a selection
						},
						success: function(resultData) {
							window.location.reload();
						}
					});
				});
			}
		});
	});
	
	if ($('input[name=edittemplateid]').length > 0) {
		templateid = $('input[name=edittemplateid]').val();
		loadTemplate(templateid);
		history.pushState(null, null, '/templates' );
	}
});

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

function enableTemplateLoader() {
	$('.templatename, .addnew').off().on('click', function(e) {
		e.preventDefault();
		templateid = $(this).data('templateid');	// stored as a scope global so we can use it elsewhere when selected
		$('input[name=templateid]').val(templateid);
		$.each($('.templatelist ul li'), function() {
			$(this).removeClass('active');
			loadTemplate(templateid);
		});
		if (templateid != 0) {
			$(this).addClass('active');
			$('a.createfromtemplate').show();
		} else {
			// empty data set, new template
			fillForm({
				template_name: '',
				location: '',
				decription: '',
				offered_rate: 0
			});
			$('.templateeditheading').html('Create New Template');
			$('a.createfromtemplate').hide();
		}
	});
}

function fillForm(data) {
	$('input[name=templatename]').val(data.template_name);
	$('textarea[name=location]').val(data.location);
	$('textarea[name=description]').val(data.description);
	$('#rate').val(data.offered_rate);
}

var selectedTemplateid;

function loadTemplate(templateid) {
	selectedTemplateid = templateid;
	$('.templateinfo').hide();
	$('.templatedetails').show();
	$.ajax({
		type: 'POST',
		url: '/templates/load',
		data: {
			'templateid': templateid
		},
		success: function(resultData) {
			if (resultData.status == true) {
				$('.templateeditheading').html('Edit Template');
				fillForm(resultData.content);
			} else {
				// error
			}
		}
	});
	$('.createfromtemplate').off().on('click', function(e) {
		e && e.preventDefault() && e.stopPropagation();
		
		$.ajax({
			type: 'POST',
			url: '/projects/createfromtemplate',
			data: {
				'templateid': selectedTemplateid
				
			},
			success: function(resultData) { 
				if (resultData.status == true) {
					window.location.href = '/projects/edit/' + resultData.id + '#models'
				}
			}
		})
		
	});
}