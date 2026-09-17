/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
$(document).ready(function() {
	$.each($('.profile-home .image'), function(img) {
		var that = this;
		var image = $(this).data('imagesrc');
		var bgimage = new Image();
		bgimage.src = image;
		$(that).css('opacity', 0);
		$(bgimage).on('load', function() {
			$(that).css('background-image','url(' + image + ')');
			$(that).css('background-position','center');
			$(that).css('background-size','cover');
			$(that).css('transition', 'opacity 0.3s');
			$(that).css('-webkit-transition', 'opacity 0.3s');
			$(that).css('opacity', 1);
			$(that).css('width', '100%');
			$(that).css('height', '100%');
			
			$('.profile-home').find('.loadfader').addClass('loaded');
			$('.profile-home').find('.loadfader').css('transition', 'opacity 0.3s');
			$('.profile-home').find('.loadfader').css('-webkit-transition', 'opacity 0.3s');
			$('.profile-home').find('.loadfader').css('opacity', 0);
		});
		
	});
	
	$('.compcard').on('click', function(e) {
		e.preventDefault();
		var modelname = $('input[name=modelname]').val();
		$('body').tinymodal({
			title: 'Download '+modelname+'\'s PDF Portfolio',
			message: '<div class="row"><div class="column">Your download will start shortly. Please be patient, this can take a minute or two.</div></div><div class="row"><div class="column" style="margin-top: 1em"><a class="button inverted compcardok">OK</a></div></div>',
			callback: function(e) {
				$('.compcardok').off().on('click', function(e) {
					e.preventDefault();
					$('.croissant-close').trigger('click');
				});
			}
		});
		var modelid = $('input[name=modelid]').val();
		window.location.href='https://idal.co/generate/comcard/'+modelid;
	});
});