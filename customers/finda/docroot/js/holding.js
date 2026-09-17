/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
// image cross-fader
var imageSources = [
	"/images/homepage/AnnaPluskotaStory.06.jpg",
];
var images = [];

$(document).ready(function() {
	
	var height = $(window).height();
	
	function preloadImages(srcs, imgs, callback) {
		var img;
		var remaining = srcs.length;
		for (var i = 0; i < srcs.length; i++) {
			img = new Image();
			img.onload = function() {
				--remaining;
				if (remaining <= 0) {
					callback();
				}
			};
			img.src = srcs[i];
			imgs.push(img);
		}
	}

	var pointer = 0, 
	xfade = function() {
		var selectedBackground = $('.background:not(.active)'), 
			image = images[pointer];
		
		RGBaster.colors(image, {
			success: function(payload) {
				$('.background').css('background-color', payload.dominant);
			}
		})
		
		$('.background.active').removeClass('active');
		selectedBackground.css({'backgroundImage' : "url(" + image.src + ")"}).addClass('active');
		
		pointer += 1;
		if (pointer >= images.length) {
			pointer = 0;
		}
	}
	preloadImages(imageSources, images, function() {
		var selectedBackground = $('.background:not(.active)');
		$('.background.active').removeClass('active');
		selectedBackground.css({'backgroundImage' : "url(" + images[0].src + ")"}).addClass('active');
		pointer += 1;
		if (images.length > 1) {
			setInterval(xfade, 10000);
		}
	});
});

var height = $('body').height() - $(window).height();

