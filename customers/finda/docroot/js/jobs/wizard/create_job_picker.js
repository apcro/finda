/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
var skipUsage = false;

var minHourly = 0;
var minDaily = 0;

$(document).ready(function() {

	$('.job_circle').on('click', function(e) {
		e && e.preventDefault() && e.stopPropagation();
		$.each($('.job_circle'), function() {
			$(this).removeClass('selected');
			
		});
		$(this).addClass('selected');
		$('.createbutton').attr('href', $(this).data('jobtype')).css('display', 'inline-block');
	});
	
	$('.createbutton').on('click', function(e) {
		e && e.preventDefault() && e.stopPropagation();
		
		$.ajax({
			type: 'GET',
			url: '/projects/create',
			data: {
				'step': 'createform',
//				'jobtype': $(this).attr('href')
				'jobtype': $(this).data('jobtype')
			},
			success: function(resultData) { 
				if (resultData != '') {
					// show the new modal here now
					
					$('body').tinymodal({
						html: resultData.html
					});
					if (resultData.steps != 0) {
						initiateJobCreator();
					}
					
				}
			}
		});
		
	});
	
	if ($('#projecttemplate').length > 0) {
		$('#projecttemplate').select2({
			placeholder: 'Select a template',
			minimumResultsForSearch: -1
		});
		$('.createfromtemplate').on('click', function(e) {
			e && e.preventDefault() && e.stopPropagation();
			
			$.ajax({
				type: 'POST',
				url: '/projects/createfromtemplate',
				data: {
					'templateid': $('#projecttemplate').val()
					
				},
				success: function(resultData) { 
					if (resultData.status == true) {
						window.location.href = '/projects/edit/' + resultData.id + '#models'
					}
				}
			})
			
		});
	}
	
	// temporary
	if (window.location.hash) {
		var url = window.location.hash;
		var hash = url.substring(url.indexOf("#") + 1);
		if (hash == 'booking' || hash == 'casting') {
			$.ajax({
				type: 'GET',
				url: '/projects/create',
				data: {
					'step': 'createform',
					'jobtype': hash
				},
				success: function(resultData) { 
					if (resultData != '') {
						// show the new modal here now
						
						$('body').tinymodal({
							html: resultData.html
						});
						if (resultData.steps != 0) {
							initiateJobCreator();
						}
						
					}
				}
			})
		}
	}
	
});


