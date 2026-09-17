/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
var currentImage = 0;
var imagetype = $('input[name=imagetype]').val();
var selectedGallery = imagetype;
var uri = window.location.href;

var modelImageWidth = 350;



$(document).ready(function() {

	$('.' + selectedGallery + ' .modelcounter').scrollIndicatorBullets();

	$.each($('.image_container .imageload'), function(img) {
		var that = this;
		var image = $(this).data('image');
		var bgimage = new Image();
		bgimage.src = image;
		$(bgimage).on('load', function() {
			
			var width = bgimage.naturalWidth;
			var height = bgimage.naturalHeight;
			var ratio = modelImageWidth/width;
			$(that).parent().parent().css('width', modelImageWidth);
//			$(that).parent().css('height', height * ratio);
			
			$(that).css('background-image','url(' + image + ')');
			$(that).find('.image_fader').addClass('fadein').css('opacity', 0);
//			$grid.masonry('layout');
		});
		
	});
	
	$('.imageload').off().on('click', function(e) {
		e.preventDefault();
		var image = $(this).data('filename');
		var html = '<div class="large"><a class="croissant-close mobile" title="Close"></a>'
			+'<img id="modalImage" src="'+image+'" class="float-center" style="max-height: 100%; height="100%" border-radius: 1.5em;"/>';
		currentImage = $(this).data('imageid');
		$('body').tinymodal({
			html: html,
			callback: addButtons,
			remove_callback: removeButtons
		});
	});
	rebindGallery();
	
	$('.project_filter_tab.portfolio, .project_filter_tab.polaroids').removeClass('active');
	$('.project_filter_tab.'+selectedGallery).addClass('active');
	$('.topper2_tab.portfolio, .topper2_tab.polaroids').removeClass('active');
	$('.topper2_tab.'+selectedGallery).addClass('active');
	$('.viewmodelimages.portfolio, .viewmodelimages.polaroids').hide();
	$('.viewmodelimages.'+selectedGallery).show();
	
	$('.project_filter_tab').on('click', function(e) {
		e.preventDefault();
		selectedGallery = $(this).data('type');
		$('.project_filter_tab.portfolio, .project_filter_tab.polaroids').removeClass('active');
		$('.project_filter_tab.'+selectedGallery).addClass('active');
		$('.viewmodelimages.portfolio, .viewmodelimages.polaroids').hide();
		$('.viewmodelimages.'+selectedGallery).show();
		$('#scroll-indicator-bullets').remove();
		$('.' + selectedGallery + ' .modelcounter').scrollIndicatorBullets();
//		$grid.masonry('layout');
	});
	
	$('.topper2_tab').on('click', function(e) {
		e.preventDefault();
		selectedGallery = $(this).data('type');
		$('.topper2_tab.portfolio, .topper2_tab.polaroids').removeClass('active');
		$('.topper2_tab.'+selectedGallery).addClass('active');
		$('.viewmodelimages.portfolio, .viewmodelimages.polaroids').hide();
		$('.viewmodelimages.'+selectedGallery).show();
		$('#scroll-indicator-bullets').remove();
		$('.' + selectedGallery + ' .modelcounter').scrollIndicatorBullets();
//		$grid.masonry('layout');
	});
	
});
var buttons = '<div id="galleryButtons"><div class="galleryPrev"><i class="fa fa-angle-left"></i></div><div class="galleryNext"><i class="fa fa-angle-right"></i></div></div>';
function addButtons() {
	$('body').append(buttons);
	rebindGallery();
}
function removeButtons() {
	$('#galleryButtons').remove();
}

function rebindGallery() {
	// move the buttons to 50% of visible height, not 50% of page
	var height = $(window).height()/2;
	$('#galleryButtons').css({'top': height});
	$(window).off('keydown').on('keydown', function(e) {
		if (e.keyCode == 37) {
			$('.galleryPrev').trigger('click');
		} else if (e.keyCode == 39) {
			$('.galleryNext').trigger('click');
		}
	})
	
	var portfolioGalleryLength = portfolioImageGallery.length;
	var polaroidsGalleryLength = polaroidsImageGallery.length;
	var galleryLength = portfolioGalleryLength;
	
	$('.galleryNext').off().on('click', function(e) {
		e.preventDefault();
		if (selectedGallery == 'portfolio') {
			var nextKey = portfolioImageGallery.indexOf(currentImage);
			galleryLength = portfolioGalleryLength;
		} else {
			var nextKey = polaroidsImageGallery.indexOf(currentImage);
			galleryLength = polaroidsGalleryLength;
		}
		nextKey++;
		if (nextKey >= galleryLength) {
			nextKey = 0;
		}
		if (selectedGallery == 'portfolio') {
			var imageId = portfolioImageGallery[nextKey];
		} else {
			var imageId = polaroidsImageGallery[nextKey];
		}
		
		
		var src = $('.image'+imageId).data('filename');
		$('#modalImage').attr('src', src).css('border-radius', '1.5em');
		currentImage = imageId;
	});
	$('.galleryPrev').off().on('click', function(e) {
		e.preventDefault();

		if (selectedGallery == 'portfolio') {
			var prevKey = portfolioImageGallery.indexOf(currentImage);
			galleryLength = portfolioGalleryLength;
		} else {
			var prevKey = polaroidsImageGallery.indexOf(currentImage);
			galleryLength = polaroidsGalleryLength;
		}
		prevKey--;
		if (prevKey < 0) {
			prevKey = galleryLength-1;
		}
		if (selectedGallery == 'portfolio') {
			var imageId = portfolioImageGallery[prevKey];
		} else {
			var imageId = polaroidsImageGallery[prevKey];
		}
		var src = $('.image'+imageId).data('filename');
		$('#modalImage').attr('src', src).css('border-radius', '1.5em');
		currentImage = imageId;
	});
}