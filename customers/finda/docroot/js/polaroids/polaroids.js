/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
$.each($('.image_container .image'), function(img) {
	var that = this;
	var image = $(this).data('image');
	var bgimage = new Image();
	bgimage.src = image;
	$(bgimage).on('load', function() {
		$(that).css('background-image','url(' + image + ')');
		$(that).find('.image_fader').addClass('fadein').css('opacity', 0);
	});
	
});

$('a.remove').on('click', function(e) {
	e.preventDefault()
	var id = $(this).data('id');
	var that = this;
	$.ajax({
		type: 'POST',
		url: "/user/polaroids/delete",
		data: {'id': id},
		dataType: "text",
		success: function(resultData) { 
			if (resultData == 'true') {
				$('#image'+id).remove();
			} else {
				alert("Image could not be removed");
			}
		}
	});
});

$('a.makeleader').on('click', function(e) {
	e.preventDefault();
	$('img.leader').removeClass('leader');
	$(this).parent().find('img').addClass('leader');
	var id = $(this).data('id');
	$.ajax({
		type: 'POST',
		url: "/user/polaroids/makeleader",
		data: {'id': id},
		dataType: "text",
		success: function(resultData) { 
			if (resultData != 'true') {
				alert("Image could not be updated");
			} else {
				window.location.href = '/user/polaroids';
			}
		}
	});
});

var rotationAngle = 0;
$('.rotate_left').on('click', function(e) {
	e.preventDefault();
	e.stopPropagation();
	var rotation = $(this).parent().data('rotation');
	rotation = (rotation - 90) % 360;
	$(this).parent().parent().find('.image').css('transform', 'rotate('+rotation+'deg)');
	$(this).parent().data('rotation', rotation);
	$(this).parent().parent().find('.rotate_confirm').show();
	rotationAngle = rotation;

});

$('.rotate_right').on('click', function(e) {
	e.preventDefault();
	e.stopPropagation();
	var rotation = $(this).parent().data('rotation');
	rotation = (rotation + 90) % 360;
	$(this).parent().parent().find('.image').css('transform', 'rotate('+rotation+'deg)');
	$(this).parent().data('rotation', rotation);
	rotationAngle = rotation;
	$(this).parent().parent().find('.rotate_confirm').show();
});

$('.rotate_confirm').on('click', function(e) {
	e.preventDefault();
	e.stopPropagation();
	var imageid = $(this).parent().data('imageid');
	$.ajax({
		type: 'POST',
		url: "/user/polaroids/rotate",
		data: {'imageid': imageid, 'angle': (-1 * rotationAngle)},
		dataType: "text",
		success: function(resultData) { 
			if (resultData != 'true') {
				alert("Image could not be rotated");
			} else {
				window.location.reload();
			}
		}
	});
	$(this).parent().hide();
	rotationAngle = 0;
});

$(document).ready(function() {
	var imagesArray = document.getElementById('polaroidImages');
	var sortable = Sortable.create(imagesArray, 
		{
			animation: 150,
			easing: "cubic-bezier(1, 0, 0, 1)",
			onEnd: function(evt) {
				
				var newOrder = [];
				
				$.each($(evt.to).find('.imagecol'), function(key, value) {
					newOrder.push($(this).data('orderid'));
				});
				$.ajax({
					type: 'POST',
					url: "/user/portfolio/saveorder",
					data: {'order': newOrder, 'type': 'polaroids'},
					success: function(resultData) { 
						if (resultData != true) {
							console.log("Image order could not be saved");
						}
					}
				});
			}
		}
	);
	
});