/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
$(document).ready(function() {
	rebindImages();
});

$('.sendmessage').on('click', function(e) {
	e.preventDefault();
	
	var modelid = $('input[name=modelid]').val();
	var message = $('#newmessage').val();
	$('#newmessage').val('');
	
	if (message != '') {
		$.ajax({
			type: 'POST',
			url: '/messages/update',
			data: {
				modelid: modelid,
				message: message
			},
			success: function(resultData) { 
				$('.messageslist').html(resultData);
				rebindImages();
			}
		});
	}
});

$('.deletecomposed').on('click', function(e) {
	e.preventDefault();
	var messageid = $(this).data('msgid');
	var modelid = $('input[name=modelid]').val();
	$.ajax({
		type: 'POST',
		url: '/messages/delete',
		data: {
			modelid: modelid,
			messageid: messageid
		},
		success: function(resultData) { 
			$('.messageslist').html(resultData);
			rebindImages();
		}
	});
});

var myDropzone = new Dropzone('.imagedropzone', {
	method: 'post',
	url: "/messages/upload",
	maxFilesize: 20,
	maxFiles: 1,
	autoDiscover: false,
	createImageThumbnails: true,
	addRemoveLinks: true,
	autoProcessQueue: false,
	paramName: 'chatAttachment',
	parallelUploads: 10,
	acceptedFiles: 'image/gif,image/jpeg,image/png,image/bmp,application/pdf',
	timeout: 600000,
	params: {
		modelid: $('input[name=modelid]').val()
	}
});

$('.sendimagemessage').on('click', function(e) {
	e.preventDefault();
	myDropzone.processQueue();
});

$('.cancelimagemessage').on('click', function(e) {
	myDropzone.removeAllFiles();
	$('#newimagemessage').val('');
	$('a.croissant-close').trigger('click');
});

myDropzone.on('complete', function(file) {
	myDropzone.removeFile(file);
	$('a.croissant-close').trigger('click');
	
});

myDropzone.on('success', function(e, result) {
	if (result.status == 1) {
		$.ajax({
			type: 'POST',
			url: '/messages/update',
			data: {
				modelid: $('input[name=modelid]').val(),
				filename: result.filename,
				message: $('#newimagemessage').val(),
				type: 'chatAttachment'
			},
			success: function(resultData) { 
				$('.messageslist').html(resultData);
				rebindImages();
			}
		});
	}
});

function rebindImages() {
	$('.chatAttachment').off().on('click', function(e) {
		e.preventDefault();
		var image = $(this).data('filename');
		var html = '<div class="large"><a class="croissant-close mobile" title="Close"></a>'
			+'<img id="modalImage" src="'+image+'" class="float-center" style="max-height: 100%; height="100%" border-radius: 1.5em;"/>';
		currentImage = $(this).data('imageid');
		$('body').tinymodal({
			html: html
		});
	});	
}