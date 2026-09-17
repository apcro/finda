/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
$(window).ready(function() {
	$('.fmp-apply').on('click', function(e) {
		e.preventDefault();
		$('.fmp-page1').hide();
		$('.fmp-page2').show();
	});
});

$('.fmpapply').on('click', function(e) {
	e.preventDefault();
	var error = false;
	
	if (!$.croissant.isEmail($('input[name=client_email]').val())) {
		$('input[name=client_email]').addClass('registererror');
		error = true;
	}
	
	if (!error) {
		
		var message = '';
		$.ajax({
			type: 'POST',
			url: '/foundingmembers',
			data: {
				'company': $('input[name=client_company]').val(),
				'name': $('input[name=client_name]').val(),
				'email': $('input[name=client_email]').val(),
				'phone': $('input[name=client_phone]').val(),
				'address': $('input[name=client_address]').val(),
				'website': $('input[name=client_website]').val(),
				'loc': $('input[name=client_location]').val()
			},
			success: function(resultData) {
				if (resultData == true) {
					message += '<div class="row"><div class="columm text-center">';
					message += '<p>We highly appreciate your application to our Founding Member Programme!</p>';
					message += '<p>Our team will get in touch with you shortly.</p>';
					message += '</div></div>';
				} else {
					message += '<div class="row"><div class="columm text-center">';
					message += '<p>There was an error, please try again.</p>';
					message += '</div></div>';
				}
				$('body').tinymodal({
					html: message,
					remove_callback: function() {
						window.location.href = '/';
					}
				});
			}
		});
	}
	
	
});
