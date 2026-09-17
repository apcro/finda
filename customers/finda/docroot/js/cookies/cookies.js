/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
$(document).ready(function () {
	$('.allow-cookies').on('click', function(e) {
		e.preventDefault();
		$.cookie('allowcookies', 1, { expires: 365 });
		$('#cookies').fadeOut('slow');
	});
});

$(window).ready(function() {
	$("#cookies").fadeIn('slow');
});