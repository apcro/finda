/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
// image cross-fader
var imageSources = [
	"/images/homepage/ajak-6.jpg",
];
var images = [];

$(document).ready(function() {
	
	checkSignin();
	
	$('.downarrow, .downarrow-persistent, .uparrow').on('click', function(e) {
		e.preventDefault();
		$('html, body').animate({
			scrollTop : $("#" + $(this).data('scrollto')).offset().top
		}, 1000);
	})
	
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
		
		// set up the glitch
//		glitchImage = images[0].src;
//		myp5 = new p5(theGlitch, 'imageBackground');
		
	});
	
	if ($('input[name=affuser]').length > 0) {
		var aff = $('input[name=affuser]').val();
		if (aff != '') {
			
			
			// change wording on the page
			$('.leadertagline').html("Your referral code has been applied!<br /><br />Please register on this page to make sure we know who referred you!");
			$('section#landing .tagline').css('top', '55%');
			$('.leadersubline').html("");
			
			if ($.croissant.isMobile()) {
				$('h1.leadertagline').css('font-size', '1.5em');
				$('h1.leadertagline').css('padding-left', '1em');
				$('h1.leadertagline').css('padding-right', '1em');
			}
		}
	}
	
	$('.enquire').on('click', function(e) {
		e.preventDefault();
		var html = '<div class="row"><div class="column">Need talent for your campaign? Reach out to us at <a href="mailto:hello@idal.co">hello@idal.co</a> with your brief.</div></div>';
		$('body').tinymodal({
			html: html
		});
	});
});

var height = $('body').height() - $(window).height();
$(window).on('scroll', function(e) {
	if ($(window).scrollTop() > 50) {
		$('.downarrow').css('opacity', '0');
	} else {
		$('.downarrow').css('opacity', '1');
	}
	
	if ($(window).scrollTop() > (height - 50)) {
		$('.uparrow').css('opacity', '1');
	} else {
		$('.uparrow').css('opacity', '0');
	}
});

function checkSignin() {
	if (window.location.hash) {
		var url = window.location.href;
		console.log(url);
		var urlhash = window.location.hash;
		console.log(urlhash);
		var hash = urlhash.substring(urlhash.indexOf("#") + 1);
		console.log(hash);
		if (url.includes('?')) {
			// split the parts
			
		}
		if (hash == 'signin') {
			$('body').showTinyModal('loginModal');
		}
	}
}