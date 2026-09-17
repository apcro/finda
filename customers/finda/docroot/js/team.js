/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
//var imageSources = ["/images/team/mariya.jpg", "/images/team/tom.jpg", "/images/team/martine.jpg", "/images/team/leanne.jpg"];
 var imageSources = ["/images/team/alice2.jpg", "/images/team/alice2.jpg", "/images/team/alice2.jpg", "/images/team/alice2.jpg"];
var images = [];
var fading = false;
var scrolling = false;
var isMobile = window.matchMedia("only screen and (max-width: 760px)");

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
		var selectedBg = $('.bg:not(.active)'), 
		image = images[index];
		
		$('.bg.active').removeClass('active');
		selectedBg.css({'backgroundImage' : "url(" + image.src + ")"}).addClass('active');
		fading = false;
	}
}

var heights = [];
var height = 0;
function setHeights() {
	// set heights
	var tutorialheight = $('.team-details').outerHeight();
	var headingheight = $('.team-details h1').outerHeight();
	if (!$.croissant.isMobile()) {
		$('.about-finda').find('section').each(function() {
			heights.push(height);
			height = height + tutorialheight;
			$('#' + this.id).css('height', tutorialheight + 'px');
		});
		$('.about-finda').css('top', '-' + headingheight + 'px');
	}
	console.log(heights);
	
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
	var blockheight = windowheight - footerheight - $('.team-finda-scroll').offset().top;
	
	setActiveCircle('mariya');
	
	setHeights();
	
	$('#scroll-indicator-bullets a').off().on('click', function(e) {
		e.preventDefault();

		var dest = $(this).attr('href');
		var offset = 0;
		
		switch(dest) {
			case '#mariya':
				offset = heights[0];
				setActiveCircle('mariya');
				break;
			case '#tom':
				offset = heights[1];
				setActiveCircle('tom');
				break;
			case '#martine':
				offset = heights[2];
				setActiveCircle('martine');
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
				if (!$('.circlemariya').hasClass('active')) {
					setActiveCircle('mariya');
				}
			} else if (scrollX >= heights[1] - 250 && scrollX < heights[2] - 250) {
				if (!$('.circletom').hasClass('active')) {
					setActiveCircle('tom');
				}
			} else if (scrollX >= heights[2] - 250) { // && scrollX < heights[3]- 250) {
				if (!$('.circlemartine').hasClass('active')) {
					setActiveCircle('martine');
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

