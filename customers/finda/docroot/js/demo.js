/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
var personname, jobtitle, workemail, companyname;

$(window).ready(function() {
	
	
	$('.requestdemo').on('click', function (e) {
		e.preventDefault();
		personname = $('input[name=personname]').val();
		jobtitle = $('input[name=jobtitle]').val();
		workemail = $('input[name=workemail]').val();
		companyname = $('input[name=companyname]').val();
		fulldata = true;
		$('input[type=text').each(function(e) {
			$(this).removeClass('error');
		});
		if (personname == '') {
			$('input[name=personname]').addClass('error');
			fulldata = false;
		}
		if (jobtitle == '') {
			$('input[name=jobtitle]').addClass('error');
			fulldata = false;
		}
		if (workemail == '') {
			$('input[name=workemail]').addClass('error');
			fulldata = false;
		}
		if (companyname == '') {
			$('input[name=companyname]').addClass('error');
			fulldata = false;
		}
		if (fulldata) {
			sendDemoRequest();
		} else {
			$('body').tinymodal({
				title: 'Please fill in all the fields',
				message: ''
			})
		}
	})
	
});

function sendDemoRequest() {
	$.ajax({
		type: 'POST',
		url: '/demo',
		data: {
			'personname': personname,
			'jobtitle': jobtitle,
			'workemail': workemail,
			'companyname': companyname,
		},
		success: function(resultData) {
			
			if (resultData == true) {
				$('#request').val('');
				$('body').tinymodal({
					title: 'Demo Request Sent',
					message: '',
					remove_callback: function() {
							window.location.href = '/';
					}
				});
			} else {
				$('body').tinymodal({
					title: 'Something went wrong',
					message: 'Please try again later',
					remove_callback: function() {
						window.location.href = '/';
					}
				});
			}
		}
	});
	
}