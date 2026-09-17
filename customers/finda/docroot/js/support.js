/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
$(window).ready(function() {
	
	
	$('#submitrequest').on('click', function (e) {
		e.preventDefault();
		$.ajax({
			type: 'POST',
			url: '/support',
			data: {
				'request': $('#request').val()
			},
			success: function(resultData) {
				
				if (resultData == true) {
					$('#request').val('');
					$('body').tinymodal({
						title: 'Message Sent',
						message: '',
						remove_callback: function() {
						}
					});
				} else {
					$('body').tinymodal({
						title: 'Something went wrong',
						message: 'Please try again later',
						remove_callback: function() {
						}
					});
				}
			}
		});
	
	})
	
});
