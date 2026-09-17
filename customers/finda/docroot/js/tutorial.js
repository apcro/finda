/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
var imageSources = ["/images/tutorial/tutorial1.jpg", "/images/tutorial/tutorial2.jpg", "/images/tutorial/tutorial3.jpg", "/images/tutorial/tutorial4.jpg"];

var images = [];
var fading = false;
var scrolling = false;

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

function setImage(index) {
	if (!fading) {
		fading = true;
		var selectedBg = $('.tutorial_image:not(.active)'), 
		image = images[index];
		
		$('.tutorial_image.active').removeClass('active');
		selectedBg.find('img').attr({'src' : image.src});
		selectedBg.addClass('active');
		fading = false;
	}
}

var heights = [];
var height = 0;
function setHeights() {
	// set heights
	var tutorialheight = $('.tutorial-details').outerHeight();
	var headingheight = $('.tutorial-details h1').outerHeight();
	$('.about-finda').find('section').each(function() {
		heights.push(height);
		height = height + tutorialheight;
		$('#' + this.id).css('height', tutorialheight + 'px');
	});
	$('.about-finda').css('top', '-' + headingheight + 'px');
}

$(window).on('resize', function(){
	heights = [];
	height = 0;
	setHeights();
});

$(window).ready(function() {

	preloadImages(imageSources, images, function() {
		setImage(0);
	});
	
	var footerheight = $('footer').outerHeight();
	var windowheight = $(window).height();
	var blockheight = windowheight - footerheight - $('.tutorial-finda-scroll').offset().top;
	
	setActiveCircle('step1');
	
	setHeights();
	
	$('#scroll-indicator-bullets a').off().on('click', function(e) {
		e.preventDefault();

		var dest = $(this).attr('href');
		var offset = 0;
		
		switch(dest) {
			case '#step1':
				offset = heights[0];
				setActiveCircle('step1');
				setImage(0);
				break;
			case '#step2':
				offset = heights[1];
				setActiveCircle('step2');
				setImage(1);
				break;
			case '#step3':
				offset = heights[2];
				setActiveCircle('step3');
				setImage(2);
				break;
			case '#step4':
				offset = heights[3];
				setActiveCircle('step4');
				setImage(3);
				break;
		}
		
		scrolling = true;
		$('.about-finda').animate({
			scrollTop : offset+'px'
		}, 1000, function() {
			scrolling = false;
		});
		
	});
	
	var scrollX = $(this).scrollTop();
	$('.about-finda').on('scroll', function(e) {
		if (!scrolling) {
			scrollX = $(this).scrollTop();
			if (scrollX < heights[1] - 250) {
				if (!$('.circlestep1').hasClass('active')) {
					setActiveCircle('step1');
					setImage(0);
				}
			} else if (scrollX >= heights[1] - 250 && scrollX < heights[2] - 250) {
				if (!$('.circlestep2').hasClass('active')) {
					setActiveCircle('step2');
					setImage(1);
				}
			} else if (scrollX >= heights[2] - 250 && scrollX < heights[3]- 250) {
				if (!$('.circlestep3').hasClass('active')) {
					setActiveCircle('step3');
					setImage(2);
				}
			} else if (scrollX >= heights[3] - 250) {
				if (!$('.circlestep4').hasClass('active')) {
					setActiveCircle('step4');
					setImage(3);
				}
			}
		}
	});
	
	function setActiveCircle(obj) {
		$('.bullet-item-link').each(function() {
			$(this).removeClass('active');
		});
		$('.circle' + obj).addClass('active');
	}
});

