/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
$(document).ready(function() {
	
	var profileimage = new Image();
	profileimage.src = $('#thepicture').attr('src');
	
	$(profileimage).on('load', function() {
		
		$('#thepicture').show();
		$('#discoverypicture').css('display', 'block');
		
		var picture = $('#thepicture');
		var discovery = $('#discoverypicture');
		picture.guillotine({width: 230, height: 230, eventOnChange: 'guillotinechangepicture'});
		picture.guillotine('fit');

		discovery.guillotine({width: 204, height: 240, eventOnChange: 'guillotinechangediscovery'});
		discovery.guillotine('fit');

		
		var mainpic = $('#avatarimage');
		
		$('#rotate_left').click(function(){
			picture.guillotine('rotateLeft');
			discovery.guillotine('rotateLeft');
		});
		
		$('#rotate_right').click(function(){
			picture.guillotine('rotateRight');
			discovery.guillotine('rotateRight');
		});
		
		$('#zoom_in').click(function(){
			picture.guillotine('zoomIn');
			discovery.guillotine('zoomIn');
		});
		$('#zoom_out').click(function(){
			picture.guillotine('zoomOut');
			discovery.guillotine('zoomOut');
		});
		
		$('#fit').click(function(){
			picture.guillotine('fit');
			discovery.guillotine('fit');
		});
		
		picture.on('guillotinechangepicture', function(ev, data, action) {
			discovery.guillotine('remove');
			discovery.guillotine({
				width: 212,
				height: 248,
				init: {
					angle: data.angle,
					x: data.x,
					y: data.y,
					scale: data.scale
				}
			});
			discovery.show();
		});
		
		discovery.on('guillotinechangediscovery', function(ev, data, action) {
			picture.guillotine('remove');
			picture.guillotine({
				width: 230,
				height: 230,
				init: {
					angle: data.angle,
					x: data.x,
					y: data.y,
					scale: data.scale
				}
			});
			picture.show();
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
						window.location.href = '/user/profile';
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
		
	})
	
	
	
});