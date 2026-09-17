/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
$(document).ready(function() {
	var picture = $('#thepicture');  // Must be already loaded or cached!
	picture.guillotine({width: 230, height: 230});
	picture.guillotine('center');
	
	var mainpic = $('#avatarimage');
	
	$('#rotate_left').click(function(){
		picture.guillotine('rotateLeft');
	});

	$('#rotate_right').click(function(){
		picture.guillotine('rotateRight');
	});
	
	$('#zoom_in').click(function(){
		picture.guillotine('zoomIn');
	});
	$('#zoom_out').click(function(){
		picture.guillotine('zoomOut');
	});
	
	$('#fit').click(function(){
		picture.guillotine('fit');
	});
	
	$('.saveavatar').on('click', function(e) {
		var data = picture.guillotine('getData');

		$.ajax({
			type: 'POST',
			url: '/user/avatar/update',
			data: {
				'data': data,
				'imageid': $(this).data('imageid')
			},
			success: function(resultData) {
				if (resultData == true) {
					window.location.reload(true);
				} else {
					$('body').tinymodal({
						title: 'Sorry',
						message: 'Something went wrong. Your changes were not saved',
						base_class: 'modalBlue'
					});
				}
			}
		});
		
	});
	
});