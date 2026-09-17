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
		url: "/user/portfolio/delete",
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
		url: "/user/portfolio/makeleader",
		data: {'id': id},
		dataType: "text",
		success: function(resultData) { 
			if (resultData != 'true') {
				alert("Image could not be updated");
			} else {
				window.location.href = '/user/avatar/edit';
			}
		}
	});
});

$(document).ready(function() {
	var imagesArray = document.getElementById('portfolioImages');
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
					data: {'order': newOrder, 'type': 'portfolio'},
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