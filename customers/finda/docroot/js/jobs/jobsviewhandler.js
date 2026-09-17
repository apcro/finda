/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
$(function() {
	
	// @TODO change this to not use the openmodal handler
	
	$('.makeoffer').on('click', function(e) {
		e.preventDefault();
		
		var optionSelected = $('#jobOffer').find("option:selected");
		var jobid = optionSelected.val();
		
		$('.croissant-close').trigger('click');
		updateModelStatus($('input[name=modelid]').val(), jobid, 10, false, false);
		$('.optionModel').html('Shortlisted').removeClass('optionNewModel').css('pointer-events', 'none');
		$('body').tinygrowl({
			title: 'Model requested'
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
	
	$('.requestModel').on('click', function(e) {
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

});

