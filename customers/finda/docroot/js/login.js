/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
$(document).ready(function() {

	$('input').on('keydown', function(e) {
		if (e.which == 13) {
			$('.loginbutton').trigger('click');
		}
	});
	
	$('.loginbutton').off().on('click', function(e) {
		e.preventDefault();
		$('#loginModal .croissant-close').trigger('click');
		var username = $('#email').val();
		var password = $('#pass').val();
		$.ajax({
			type: 'POST',
			url: '/user/login',
			data: {
				'email': username,
				'pass': password
			},
			success: function(resultData) { 
				if (resultData == true) {
					window.location.href = '/';
				} else {
					$('#finda-website').tinymodal({
						html: '<h2 class="text-red">OOPS</h2><p>There was a problem. Please check your username and password are correct and try again.</p><p><a class="button white errorbutton close">got it</a></p>',
						hide_close: true
					});
					$('.button.errorbutton.close').off().on('click', function(e) {
						forceRemoveModal(function(){});
					})
				}
			}
		});
	});
});
