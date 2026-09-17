/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
$(document).ready(function() {
	
	$.each($('.image_container .imageload'), function(img) {
		var that = this;
		var image = $(this).data('image');
		var bgimage = new Image();
		bgimage.src = image;
		$(bgimage).on('load', function() {
			$(that).css('background-image','url(' + image + ')');
			$(that).find('.image_fader').addClass('fadein').css('opacity', 0);
		});
		
	});
	
	$('.tab-portfolio, .tab-polaroids').on('click', function(e) {
		var tab = $(this).attr('id');
		$('.tab-portfolio, .tab-polaroids').removeClass('active');
		$('.tab-portfolio-images, .tab-polaroids-images').hide();
		$('.'+$(this).attr('id')).addClass('active');
		$('.'+$(this).attr('id')+'-images').show();
	});
	
	$('.tab-front').on('click', function(e) {
		e.preventDefault();
		$('.tab-front').addClass('active');
		$('.tab-back').removeClass('active');
		$('.page1').show();
		$('.page2').hide();
	});
	$('.tab-back').on('click', function(e) {
		e.preventDefault();
		$('.page1').hide();
		$('.page2').show();
		$('.tab-front').removeClass('active');
		$('.tab-back').addClass('active');

	});

	setupDraggables();
	setupDroppables();
	removeFaders();
});

function setupDraggables() {
	$.each($('.draggable'), function(e) {
		$(this).draggable({
			cursor: 'move', 
			start: function(event, ui) {
				ui.helper.css({'width': '80px', 'height': '80px'});
			},
			revert: 'invalid',
			snap: '.tab-'+$(this).data('type')+'-images',
			snapMode: 'outer',
			scope: $(this).data('type'),
			helper: 'clone',
			appendTo: 'body',
		});
	});
}

function setupDroppables() {
	
	$('.polaroid.droppable').droppable({
		tolerance: 'pointer',
		scope: 'polaroid',
		classes: {
			'ui-droppable-active': 'ui-state-default'
		},
		drop: function(e, ui) {
			$('.changedbutton').show();
			setImage($(e.target), $(ui.draggable).find('.imageload').data('filename'));
			$(e.target).data('imageid', $(ui.draggable).find('.imageload').data('imageid'));
		}
	});

	$('.portfolio.droppable').droppable({
		tolerance: 'pointer',
		scope: 'portfolio',
		classes: {
			'ui-droppable-active': 'ui-state-default'
		},
		drop: function(e, ui) {
			$('.changedbutton').show();
			setImage($(e.target), $(ui.draggable).find('.imageload').data('filename'));
		}
	});

}

function setImage($target, image) {
	$target.empty();
	$target.css({
		'background-image':'url('+image+')',
		'background-size':'contain',
		'background-position':'center',
		'background-repeat':'no-repeat',
		'border':'5px solid #00dc8d'
		});
}
function removeFaders() {
	setTimeout(function() {
		$('.image_fader').remove();
	}, 1000);
}

function saveComCard() {
	$.each('.polaroid.droppable', function() {
		
	})
}

