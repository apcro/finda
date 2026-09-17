/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
(function($) {
	
	window.resetScrollTop = function(){
		if ($('html').hasClass('mobile-site')) {
			$('body').animate({
				scrollTop	: window.viewerScrollTop
			}, {
				duration	: 1
			});
		}
	};
	
	$.fn.tinyspinner = function(options) {
		var self = this;
		var settings = {
				width					: '75px',
				height					: '75px',
				colour					: '#000000',
				zindex					: 10001
			};
			
		if (options) $.extend(settings, options);
			
		var overlay = $('<div>').attr({
			id : 'spinner-overlay'
		}).appendTo(self);
		
		var contents = $('<div>').addClass('reverse-spinner');
		
		contents.css('width', settings.width);
		contents.css('height', settings.height);
		contents.css('border-top-color', settings.colour);
		contents.css('border-left-color', settings.colour);
		contents.css('position', 'absolute');
		contents.css('left', '50%');
		contents.css('top', '50%');
		contents.css('transform', 'translate(-50%, -50%)');
		
		const build_modal = ((html) => {
			contents.appendTo(overlay);
			overlay.fadeIn('300', function() {
				contents.stop(true, true);
				contents.fadeIn('300', function() {});
			});
		});
		build_modal();
	}
	
	$.fn.tinymodal = function(options) {
		
		// remove any spinner
		$('#spinner-overlay').remove();
		
		var self = this;

		var settings = {
			html					: '',
			title					: 'Title',
			message					: 'Message', 
			remove_callback			: '', 
			base_class				: '', 
			closing_on_overlayclick	: true,
			disable_keypress		: false,
			autoClose				: false,
			callback				: '',
			width					: 'auto',
			height					: '',
			margintop				: '',
			autoCloseTimeout		: 5000,
			fullscreen				: false,
			modalSource				: false,
			retainModal				: false,
			zindex					: 10001,
			hide_close				: false
		};
		
		if (options) $.extend(settings, options);
		
		if ($('html').hasClass('mobile-site')) {
			settings.width = $(window).innerWidth() - 100;
		}
		
		
		var existing = false;
		if ($('#croissant-overlay').length == 0) {
			var overlay = $('<div>').attr({
				id : 'croissant-overlay'
			}).appendTo(self);
			$('#croissant-overlay').css('z-index', settings.zindex);
		} else {
			var overlay = $('#croissant-overlay');
			existing = true;
			$('#croissant-overlay').css('z-index', settings.zindex);
		}
		
		if (settings.fullscreen){
			settings.width 	= $(window).innerWidth();
			settings.height = $(window).innerHeight();
		}
		
		var contents = $('<div>').addClass('croissant-block croissant-modal ' + settings.base_class);
		if (!settings.hide_close) {
			contents.append('<a class="croissant-close" title="Close" />');
		}
		
		function styleContents(contents) {
			if (!settings.fullscreen) {
				var height 		= (settings.height != '') ? settings.height : 'auto';
				var marginTop	= (settings.margintop != '') ? settings.margintop : 'auto';
				
				if (settings.modalSource == false) {
					contents.css({
						width		: settings.width,
						height		: height
					});
				} else {
					// if we're passing in a modal, override the container default padding
					contents.css({
						width		: settings.width,
						height		: height,
						padding		: 0,
						margin	 	: 0
					});
				}
				
			} else {
				window.scrollTo(0, 0);
				contents.css({
					top			: 0,
					right		: 0,
					bottom		: 0,
					left		: 0,
					width		: 'auto',
					margin		: 0
				});
			}
		}

		var build_modal = function(html) {
			// Build modal.
			if (existing && !settings.retainModal) {
				overlay.stop(true, true);
				overlay.empty();
				overlay = $('<div>').attr({
					id : 'croissant-overlay'
				}).appendTo(self);
				existing = false;
			}
			contents.prepend(html).appendTo(overlay);
			
			styleContents(contents);
			
			overlay.fadeIn('300', function() {
				contents.stop(true, true);
				contents.fadeIn('300', function() {
					if (settings.callback != '') {
						settings.callback(this);
					}
				});
			});
			
			if (settings.autoClose) {
				setTimeout(remove_modal, settings.autoCloseTimeout);
			}
			
			
			if (settings.closing_on_overlayclick) {
				contents.on('click', function(e) {
					e.stopPropagation();
				});
				overlay.on('click', remove_modal);
				overlay.find('a.croissant-close').on('click', remove_modal);
				overlay.find('a.closemodal').on('click', remove_modal);
			} else {
				overlay.find('a.croissant-close').on('click', remove_modal);
				overlay.find('a.closemodal').on('click', remove_modal);
			}
			
			$(document).off('keydown.tinyModal').on('keydown.tinyModal', function(e) {
				if (!settings.disable_keypress) {
					if (e.keyCode == 27) {
						remove_modal();
					}
				}
			});
			
		};
		
		var append_modal = function(html) {
			// Build second or third modal.
			contents.prepend(html).appendTo(overlay);
			
			styleContents(contents);
			
			overlay.fadeIn('300', function() {
				
				contents.fadeIn('300', function() {
					if (settings.callback != '') {
						settings.callback(this);
					}
				});
			});
			
			if (settings.autoClose) {
				setTimeout(remove_modal, settings.autoCloseTimeout);
			}
			
			if (settings.closing_on_overlayclick) {
				$('#croissant-overlay .modal').on('click', function(e) {
					e.stopPropagation();
				});
				$('#croissant-overlay a.close, #overlay').on('click', function() {
					$(contents).fadeOut('fast', function() { 
						$(this).remove(); 
					});
				});
			} else {
				$('#croissant-overlay a.close').on('click', function() {
					$(contents).fadeOut('fast', function() { 
						$(this).remove(); 
					});
				});
			}
		};

		var remove_modal = function(e) {
			// close from the top, so we bubble through the visible list
			if ($('#croissant-overlay > div').length > 1) {
				var thismodal = overlay.find('.croissant-modal:last');
				thismodal.fadeOut('fast', function() {
					$(this).remove();
				});
			} else {
				overlay.fadeOut('fast', function() {
					$('html').removeClass('no-scrollbar viewer-activated');
					$('body').css('overflow', 'auto');
					$(this).remove();
					if (settings.remove_callback != '') {
						settings.remove_callback(); 
					}
				});
			}
		};
		
		var html = '';
		if (settings.html != '') {
			html = settings.html;
		} else if (settings.modalSource != false) {
			html = settings.modalSource;
		} else {
			html = '<h3>' + settings.title + '</h3><p>' + settings.message + '</p>';
		}
		if ($('#overlay').is(':visible')) {
			append_modal(html);
		} else {
			build_modal(html);
		}
	};
})(jQuery);

(function($) {
	// shows an existing block of HTML currently hidden on the page
	$.fn.showTinyModal = function(modal) {
		var self = this;

		var build_modal = function(html) {

			if ($('#croissant-overlay').length == 0) {
				var overlay = $('<div>').attr({
					id : 'croissant-overlay'
				}).appendTo(self);
			} else {
				var overlay = $('#croissant-overlay');
			}
			
			// Show existing modal
			$('#'+modal).removeClass('reveal');
			$('#'+modal).addClass('croissant-block croissant-modal');
			if ($('#'+modal+' a.croissant-close').length == 0) {
				$('#'+modal).append('<a class="croissant-close" title="Close" />');
			}
			
			
			//add the overlay
//			self.append($('<div />').attr('id', 'croissant-overlay'));
			
			$('#croissant-overlay').fadeIn('fast');
			
			if ($.croissant.isMobile()) {
				$('#'+modal).css('position', 'absolute');
			} else {
				$('#'+modal).css('position', 'fixed');
			}
			$('#'+modal).css('z-index', '10002');
			
			$('.croissant-modal').on('click', function(e) {
				e.stopPropagation();
			});
			$('a.croissant-close, #croissant-overlay').on('click', function() {
				remove_modal(modal);
			});
			
		};

		var remove_modal = function(modal) {
			$('#croissant-overlay').trigger('modal_closed');
			$('#croissant-overlay').fadeOut('fast', function() {
				$(this).remove();
			});
			$('#'+modal).addClass('reveal');
		};
		

		build_modal(self);
	};
})(jQuery);

(function($) {
	// adds the close button to an existing tinymodal that has had it's HTML overwritten
	$.fn.updateTinyModal = function() {
		var modal = (this.attr('id'));

		
		var build_modal = function() {
			// Show existing modal
			if ($('#'+modal+' a.croissant-close').length == 0) {
				$('#'+modal).append('<a class="croissant-close" title="Close" />');
			}
			
			$('.croissant-modal').on('click', function(e) {
				e.stopPropagation();
			});
			$('a.croissant-close, #croissant-overlay').on('click', function() {
				remove_modal(modal);
			});
		};

		var remove_modal = function(modal) {
			$('#croissant-overlay').fadeOut('fast', function() {
				$(this).remove();
			});
			$('#'+modal).addClass('reveal');
		};

		build_modal();
	};
})(jQuery);

function forceRemoveModal(callback) {
	$('#croissant-overlay').fadeOut('fast', function() {
		$(this).remove();
		callback();
	});
}