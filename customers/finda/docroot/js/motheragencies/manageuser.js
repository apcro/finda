/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
$(document).ready(function() {
	let modelid = $('input[name=modelid]').val();
	$('a.maremove').on('click', function(e) {
		e.preventDefault()
		let id = $(this).data('id');
		$.ajax({
			type: 'POST',
			url: "/dashboard/removeimage",
			data: {'id': id, 'modelid': modelid},
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

	$('a.mamakeleader').on('click', function(e) {
		e.preventDefault();
		$('img.leader').removeClass('leader');
		$(this).parent().find('img').addClass('leader');
		let id = $(this).data('id');
		let that = this;
		$.ajax({
			type: 'POST',
			url: "/dashboard/makeleader",
			data: {'id': id, 'modelid': modelid},
			dataType: "text",
			success: function(resultData) { 
				if (resultData != 'true') {
					alert("Image could not be updated");
				} else {
					$(that)
				}
			}
		});
	});
	
	Sortable.create(document.getElementById('polaroidImages'), 
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
					url: "/dashboard/saveorder",
					data: {'order': newOrder, 'type': 'polaroids', 'modelid': modelid},
					success: function(resultData) { 
						if (resultData != true) {
							console.log("Image order could not be saved");
						}
					}
				});
			}
		}
	);
	
	Sortable.create(document.getElementById('portfolioImages'), 
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
					url: "/dashboard/saveorder",
					data: {'order': newOrder, 'type': 'portfolio', 'modelid': modelid},
					success: function(resultData) { 
						if (resultData != true) {
							console.log("Image order could not be saved");
						}
					}
				});
			}
		}
	);
	
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
});