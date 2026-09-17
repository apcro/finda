/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
$(function() {
	
	$('.add-to-calendar').on('click', function(e) {
		e.preventDefault();
		$('.calendar-links').toggle();
	})
	
	$('.rsvp-button').on('click', function(e) {
		e.preventDefault();
		var rsvp = $(this).data('rsvp');
		var hash = $('input[name=hash]').val();
		$.ajax({
			type: 'POST',
			url: '/invite/rsvp',
			data: {
				'rsvp': rsvp,
				'id': hash
			},
			success: function(resultData) {
				if (resultData.status == 1) {
					$('.rsvp').html(resultData.html);
				} else {
					$('.rsvp').html('There was an error, please reload this page and try again.');
				}
			}
		})
	})
})

