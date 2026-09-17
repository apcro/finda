/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
$(function() {
	
	$('.selectModel, .optionModel').on('click', function(e) {
		e.preventDefault();
		updateModelStatus($('input[name=modelid]').val(), $('input[name=jobid]').val(), 10, false, false);
		$(this).html('Shortlisted').removeClass('optionModel').css('pointer-events', 'none');
		$('body').tinygrowl({
			title: 'Model selected'
		});
		$('.optionModel').off('click').on('click', function(e) {
			e.preventDefault();
		});
	});

	$('.button.cancel').on('click', function(e) {
		e.preventDefault();
		$('.croissant-close').trigger('click');
	});
	
	$('.model-favourite').off().on('click', function(e) {
		e.preventDefault();
		var modelid = $(this).data('id');
		var message = '';
		if ($(this).find('i').hasClass('far')) {
			$(this).find('i').removeClass('far').addClass('fas');
			message = '<p>Added to Favourites</p>';
		} else {
			$(this).find('i').removeClass('fas').addClass('far');
			message = '<p>Removed from Favourites</p>';
		}
		
		$.ajax({
			type: 'POST',
			url: '/search/toggle-favourite',
			data: {
				'modelid': modelid
			},
			success: function(resultData) {
				$('body').tinymodal({
					html: message,
					base_class: 'modalWhite',
					autoClose: true,
					autoCloseTimeout: 2000
				});
				
			}
		})
	});
});

