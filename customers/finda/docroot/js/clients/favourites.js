/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
$(window).ready(function() {
	$('.model-favourite').on('click', function(e) {
		
		e.preventDefault();
		var modelid = $(this).data('id');
		$.ajax({
			type: 'POST',
			url: '/search/toggle-favourite',
			data: {
				'modelid': modelid
			},
			success: function(resultData) {
				$('#model-'+modelid).fadeOut('fast', function() {
					$(this).remove();
				});
				if ($('.search-results .modelcards').length == 0) {
					$('.search-results .modelcards').append('<p>You have no favourite models.</p>');
				}
			}
		});
	});
});