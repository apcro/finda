/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
$('.savebutton.small').off().on('click', function(e) {
	e.preventDefault();
	$.ajax({
		type: 'POST',
		url: '/projects/addinfo',
		data: {
			'jobid': $('input[name=jobid]').val(),
			'info': $('textarea#job_add_info').val()
		}, 
		success: function(resultData) {
			if (resultData == true) {
				$('body').tinymodal({
					html: '<h2>Information sent</h2>'
				});
			} else {
			}
		}
	});
});