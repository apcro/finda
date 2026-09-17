/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
(function($) {
	$.fn.tinygrowl = function(options) {
		var self = this;

		var settings = {
			html			: null,
			title			: '',
			type			: 'success',
			message			: '',
			direction		: 'up',
			close_delay		: 5000,
			vertical_offset	: 0
		};
		if (options) {
			$.extend(settings, options);
		}

		var build_modal = function(html) {
			// Build modal.
			// No styling or positioning done yet as this is very temporary.
			var contents = $('<div />').addClass('growl').addClass('block').html(html);
			if (settings.direction == 'down') {
				contents.css('top', '-100px');
			} else {
				contents.css('bottom', '-100px');
			}
			self.append(contents);

			/* show and animate */
			$('.block.growl').animate({opacity: 0}, 0);
			if (settings.direction == 'down') {
				$('.block.growl').animate({
					opacity: 1,
					top: 25 + settings.vertical_offset
				}, 500);
			} else {
				$('.block.growl').fadeIn('fast').animate({
					opacity: 1,
					bottom: 25 + settings.vertical_offset
				}, 500);
			}

			/* fade out after 5 seconds */
			setTimeout(remove_modal, settings.close_delay);

			contents.on('click', function(e) {
				e.stopPropagation();
				remove_modal();
			});
			$('.growl').on('click', remove_modal);
			
			$(document).off('keydown.tinygrowl').on('keydown.tinygrowl', function(e) {
				if (!settings.disable_keypress) {
					if (e.keyCode == 27) {
						remove_modal();
					}
				}
			});
		};

		var remove_modal = function() {
			$('.growl').fadeOut("fast", function() {
				$('.growl').remove();
			});
		};


		var html = '';
		if (settings.html !== null) {
			html = settings.html;
		} else {
			var titleclass = '';
			status = (settings.type) ? settings.type : settings.title;
			switch (status.toLowerCase()) {
			case 'success':
				titleclass = 'text-burgundy';
				break;
			case 'error':
				titleclass = 'text-red';
				break;
			case 'notice':
				titleclass = 'text-white';
				break;
			}
			var growlcontent = '';
			if (settings.title != '') {
				growlcontent += "<span class='title " + titleclass + "'>" + settings.title+ "</span>";
			}
			if (settings.title != '' && settings.message != '') {
				growlcontent += '<br />';
			}
			if (settings.message != '') {
				growlcontent += settings.message;
			}
			html = $('<p/>').html(growlcontent);
		}

		build_modal(html);
	};
})(jQuery);