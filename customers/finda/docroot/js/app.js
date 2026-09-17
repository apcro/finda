/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
// force document center height, since the HTML structure currently needs work (20180821)
var minheight = $(window).height() - $('header').outerHeight() - $('footer').outerHeight();
var currheight = $('.grid').outerHeight();
if (minheight > currheight) {
//	$('.grid').height(minheight);
	$('.grid').css('min-height', minheight);
}

$('[data-tabs]').each(function() {
	if (!$(this).hasClass('active')) {
		var closeModal = $(this).data('tab');
		$('.' + closeModal).hide();
	}
});

$('[data-tabs]').on('click', function(e) {
	var openTab = $(this).data('tab');
	var closeModal;
	$('[data-tabs]').each(function() {
		$(this).removeClass('active');
		closeModal = $(this).data('tab');
		$('.' + closeModal).hide();
	});
	$(this).addClass('active');
	$('.' + openTab).show();
});

$('[data-open]').on('click', function(e) {
	var openModal = $(this).data('open');
	if (openModal != null) {
		e.preventDefault();
		$('body').showTinyModal(openModal);
	}
});

$('[data-close]').on('click', function(e) {
	e.preventDefault();
	$('.croissant-close').trigger('click');
});

$('select').on('change', function(e) {
	if ($(this).find(':selected').val() == 0) {
		$(this).css('color', '#AAAAAA');
	} else {
		$(this).css('color', '#000000');
	}
});

$('select').trigger('change');
sizeConvert();

// override all callsheet links
$('[data-callsheet]').on('click', function(e){
	var callsheet = $(this).data('callsheet');
	if (callsheet != null) {
		e.preventDefault();
		$.ajax({
			type: 'POST',
			url: '/callsheet/query',
			data: {
				'jobid': callsheet
			},
			success: function(resultData) { 
				if (resultData == true) {
					window.location.href = '/download/callsheet/' + callsheet;
				} else {
					// tinymodal error here - model not found on job
					$('body').tinymodal({
						title: 'Sorry',
						message: 'You are not currently working on this job'
					});
				}
			}
		});
	}
});

function hamburgerToggle() {
	if ($('.panel-toggle-button .hamburger').hasClass('is-active')) {
		$('.panel-toggle-button .hamburger').removeClass('is-active');
	} else {
		$('.panel-toggle-button .hamburger').addClass('is-active');
	}
	
}

// display override functions
function centimetersToInches(value) {
	return Math.ceil(value*0.393700);
}

function inchesToFeet(value) {
//	let val = inchesToCentimeters(value);
	return centimetersToFeet(value);
}

function feetToCentimeters(value) {
	// ft comes in the form xx'xx"
	let parts = value.split("'");
	var feet = parts[0];
	var inches = parts[1].replace('"', '');
	var total = (parseInt(feet)* 12) + parseInt(inches);
	return inchesToCentimeters(total);
}

function centimetersToFeet(value) {
	var realFeet = (value*0.393700) / 12;
	var feet = Math.floor(realFeet);
	var inches = Math.round((realFeet - feet) * 12);
	return feet + "'" + inches + '"';
}

function inchesToCentimeters(value) {
	return Math.floor(value*2.54);
}


$(document).ready(function() {
	
	// do we have cookies?
	if (navigator.cookieEnabled) {
		$('.cookiewarning').remove();
	} else {
		$('.cookiewarning').show();
	}
	
	
	// podcast menu
	$('.podcast').off().on('click', function(e) {
		e.preventDefault();
		e.stopPropagation();
		showPodcastPopup();
	});
	
	// if we're on mobile, set up the slideout menu
	if ($.croissant.isMobile()) {
		
		// detect if logged in by whether or not there is a menu?
		if ($('#mobilemenu').length > 0) {
			$('<link>')
				.appendTo('head')
				.attr({
					type: 'text/css', 
					rel: 'stylesheet',
					href: '/css/vendor/hamburgers/hamburgers.css'
				});
			$.getScript('/js/vendor/slideout.js', function() {
				var slideout = new Slideout({
					'panel': document.getElementById('main'),
					'menu': document.getElementById('mobilemenu'),
					'padding': 184,
					'tolerance': 70
				});
				
				slideout.off('beforeopen');
				slideout.on('beforeopen', function() {
					$('.panel-toggle-button .hamburger').addClass('is-active');
				});
				slideout.off('beforeclose');
				slideout.on('beforeclose', function() {
					$('.panel-toggle-button .hamburger').removeClass('is-active');
				});
				$('.panel-toggle-button').off().on('click', function() {
					slideout.toggle();
				});
				
				// override anchors to provide a nice transition
				$('#mobilemenu a').on('click', function(e) {
					e.preventDefault();
					var href = $(this).attr('href');
					slideout.close();
					slideout.off('close');
					slideout.on('close', function() {
						window.location.href = href;
					});
				})
				
			});
			
		}

		if (window.location.pathname == '/projects') {
			window.location.pathname = '/m/loggedin';
		}
		console.log(window.location.pathname);
		
	}
	
	window.fadeIn = function(obj) {
		$(obj).fadeIn(500);
	}
	
	window.onbeforeunload = function(e) {
		$('#loader').css({'display': 'block', 'opacity': '0'});
		$("#loader").animate({
			opacity: 1
		}, 250);
		$('body').delay(250);
	}

	$("#notificationLink").on('click', function() {
		$("#notificationContainer").fadeToggle(300);
		return false;
	});
	
	//Document Click hiding the popup 
	$(document).click(function(e) {
		$("#notificationContainer").hide();
	});
	
	// Prevent following an a-tag if the button is disabled
	$('a.errorbutton.disabled').on('click', function(e) {
		e.preventDefault();
	});
	
	//Popup on click
	$("#notificationContainer .notes").on('click', function(e) {
		e.preventDefault();
		var usertype = $(this).data('usertype');
		var msgtype = $(this).data('msgtype');
		var jobid = $(this).data('jobid');
		if (usertype == 1) {
			// model
			if (msgtype == 1) {
				window.location.href="/jobs#"+jobid;
			}
		} else if (usertype == 2) {
			// client
			if (msgtype < 5) {
				window.location.href="/projects/view/"+jobid;
			} else {
				window.location.href="/notifications#"+msgid;
			}
		}
		
	});
	
	$('.message-controls a.delete').on('click', function(e) {
		e.preventDefault();
		var msgid = $(this).data("msgid");
		$('#finda-website').tinymodal({
			title: 'Are you sure?',
			base_class: '',
			message: 
					'<div class="row"><div class="column" style="margin-top: 0.5em">'
					+'<button class="button bg-black white hvr hvr-purple" id="delete_confirm" data-msgid="' + msgid + '" type="button delete" value="Delete message" >Delete</button>'
					+'</div><div class="column" style="margin-top: 0.5em">'
					+'<button class="close button bg-grey hvr hvr-white" id="delete_cancel" type="button cancel" value="Cancel" >Cancel</button>'
					+'</div></div>'
		});
		$("#delete_confirm").on('click', function() {
			msgid = $(this).data('msgid');
			$.ajax({
				type: 'POST',
				url: '/user/msg/delete',
				data: {
					'msgid': msgid
				},
				success: function(resultData) { 
					$('a.croissant-close').trigger('click');
					$('.msg' + msgid).stop().animate({ 
						"opacity": "0",
						"height": 0}, {
						duration: 300,
						complete: function() { 
							$('.msg' + msgid).remove();
							if ($('.notifications > div').length == 1) {
								// out of messages, change the content
								$('.notifications').append('<div class="row"><div class="column"><p>You have no messages</p></div></div');
							}
						}
					});
				}, 
				failure: function(resultData) {
					
				}
			})
		});
		$("#delete_cancel").on('click', function() {
			$('a.croissant-close').trigger('click');
		});
		return false;
	})

	$('a.sendinvite').on('click', function(e) {
		e.preventDefault();
		var name = $('input[name=inviteName]').val();
		var mail = $('input[name=inviteEmail]').val();
		$('#referrer-code .croissant-close').trigger('click');
		$('input[name=inviteName]').val('');
		$('input[name=inviteEmail]').val('');
		$.ajax({
			type: 'POST',
			url: '/invite-to-finda',
			data: {
				'name': name,
				'mail': mail
			},
			success: function(resultData) { 
				if (resultData == true) {
					$('#finda-website').tinymodal({
						title: 'Thank you, beautiful!',
						message: 'We\'ve sent an invitation email to ' + name + '.'
					});
				} else {
					// tinymodal error here - model not found on job
					$('#finda-website').tinymodal({
						title: 'Sorry',
						message: 'There was a problem sending the email to ' + name + '. Did you enter the email address correctly?'
					});
				}
			}, 
			failure: function(resultData) {
				$('#finda-website').tinymodal({
					title: 'Sorry',
					message: 'There was a problem sending the email to ' + name + '. Please try again later.'
				});
			}
		})
	});
	
	$('button[name=Upload]').on('click', function(e) {
		e.preventDefault();
		if ($('input[type=file]').val() != '') {
			$(this).closest('form').submit();
		} else {
			$('body').tinymodal({
				title: '',
				message: 'Please select a file to upload'
			});
		}
	});
	
	$('.site_uparrow').on('click', function(e) {
		e.preventDefault();
		$('html, body').animate({
			scrollTop : $("#" + $(this).data('scrollto')).offset().top
		}, 1000);
	})
	
	var height = $('body').height() - $(window).height();
	$(window).on('scroll', function(e) {
	
		if ($(window).scrollTop() > 50) {
			$('.site_uparrow').css('opacity', '1');
		} else {
			$('.site_uparrow').css('opacity', '0');
		}
		if ($(window).scrollTop() > (height - 20)) {
			$('.site_uparrow').css('color', $('body').css("background-color"));
		} else {
			$('.site_uparrow').css('color', '#fff');
		}
	});
	
	$('.copyme').on('click', function(e) {
		var that = this;
		$(that).addClass('highlight');
		$(that).parent().attr('data-balloon', 'Copied!');
		setTimeout(function () {
			$(that).removeClass('highlight');
			$(that).parent().attr('data-balloon', 'Click to copy');
		}, 1000);
		copyToClipboard($(this).data('code'));
	});
	
	$('.copyme_referrer').on('click', function(e) {
		var that = this;
		$(that).addClass('highlight');
		setTimeout(function () {
			$(that).removeClass('highlight');
		}, 1000);
		copyToClipboard($(this).data('code'));
	});

	changeTabByHash();
	showNotificationPopup();
	
});

function updateModelStatus(modelid, jobid, status, closemodal, reloadWindow) {
	$.ajax({
		type: 'POST',
		url: '/view/' + modelid + '/updateModelStatus',
		data: {
			'jobid': jobid,
			'modelid': modelid,
			'status': status
		},
		success: function(resultData) {
			if (closemodal == true) {
				$('.croissant-close').trigger('click');
				if (reloadWindow == true) {
					window.location.reload(true);
				}
			}
		}
	});
}

function sizeConvert() {
	$('[data-sizeconvert]').each(function() {
		var algo = $(this).data('sizeconvert');
		var value = $(this).data('value');
		$(this).hide();
		switch(algo) {
			case 'cmtoin':
				$(this).html(centimetersToInches(value) + '"').fadeIn('fast');
				break;
			case 'cmtoft':
				$(this).html(inchesToFeet(value)).fadeIn('fast');
				break;
		} 
	});
}

const copyToClipboard = str => {
	const el = document.createElement('textarea');
	el.value = str;
	el.setAttribute('readonly', '');
	el.style.position = 'absolute';
	el.style.left = '-9999px';
	document.body.appendChild(el);
	el.select();
	document.execCommand('copy');
	document.body.removeChild(el);
};

function changeTabByHash() {
	if (window.location.hash) {
		var url = window.location.hash;
		var hash = url.substring(url.indexOf("#") + 1);
		if (!hash.includes('?')) {
			if ($('#tab-' + hash + '-label').length > 0) {
				var ulid = '.worko-tabs.searchpage';
				$(ulid).find('input').each(function(e) {
					var href = '#' + $(this).attr('id');
					if (href == '#tab-' + hash) {
						$(this).click();
					}
				});
			} else if (hash == 'findModels') {
				$('.modelSearchButton').trigger('click');
			}
			
			// are we on the projects page?
			if ($('.project_filters').length > 0) {
				if (hash == 'offers') {
					$('.project_filter_tab.past').trigger('click');
				} else {
					$('.project_filter_tab.'+hash).trigger('click');
				}
			}
			
			// is it a podcast link?
			if (hash == 'podcast') {
				showPodcastPopup();
			}
		}
		
	}
	
}

function showNotificationPopup() {
	if ($('input[name=notificationpopup]').length > 0) {
		var message = $('input[name=notificationpopup]').data('message');
		$('body').tinymodal({
			title: message,
			message: ''
		});
	}
}

function showPodcastPopup() {
	$('body').tinymodal({
		title: 'iDAL Voices Podcast',
		message: 'The iDAL Voices podcast is an educational and inspirational resource for models, designed to empower with knowledge, useful tips and inspirational stories, so that you can be on top of your career.<br /><br /><br />Listen to the Finda Voices Podcast on <a href="https://open.spotify.com/show/5Upl1CPxEvAGh4pTWCnyP4" target="_blank" class="podcastlink">Spotify <i class="fas fa-external-link-alt"></i></a> or <a href="https://podcasts.apple.com/gb/podcast/finda-voices-podcast/id1470088105" target="_blank" class="podcastlink">iTunes <i class="fas fa-external-link-alt"></i></a>.'
	});
	$('.podcastlink').off().on('click', function(e) {
		$('a.croissant-close').trigger('click');
	});	
}
