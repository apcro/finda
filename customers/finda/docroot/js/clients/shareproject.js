/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
var jobid = $('input[name=jobid]').val();

$(window).ready(function() {
	
	$('span.removeModel').on('click', function(e) {
		e.preventDefault();
		var modelid = $(this).data('modelid');
		if (modelid != null) {
			$('#modeldrag-'+modelid).remove();
			updateModelStatus(modelid, jobid, 0, true, false);	// remove the model from the job
		}
	});
	
	setupModelDragDrop();
	
	$('.finished').on('click', function(e) {
		var shareuri = $('input[name=shareuri]').val();
		$.ajax({
			type: 'POST',
			url: '/projects/share/'+shareuri+'/finished',
			data: {
				'shareuri': shareuri
			},
			success: function(resultData) {
				window.location.href = "/";
			}
		});
	});
});

function setupModelDragDrop() {
	setupContainers();
	setupModelCards();
}

function setupContainers() {
	$('.reviewed.container').droppable({
		tolerance: 'pointer',
		classes: {
			'ui-droppable-active': 'ui-state-default'
		},
		drop: function(e, ui) {
			$('.changedbutton').show();
			$(e.target).append($(ui.draggable).detach().css({'top':'', 'left':''}));
			updateModelStatus(ui.draggable.attr('id').replace('modeldrag-', ''), jobid, 15, true, false);
		}
	});
	
	$('.optioned.container').droppable({
		tolerance: 'pointer',
		classes: {
			'ui-droppable-active': 'ui-state-default'
		},
		drop: function(e, ui) {
			$('.changedbutton').show();
			$(e.target).append($(ui.draggable).detach().css({'top':'', 'left':''}));
			updateModelStatus(ui.draggable.attr('id').replace('modeldrag-', ''), jobid, 10, true, false);
		}
	});
	
}

function updateModelStatus(modelid, jobid, status, closemodal, reloadWindow) {
//	console.log('Model ID: '+modelid+', Job ID: '+jobid+', Status: '+status);
	$.ajax({
		type: 'POST',
		url: '/projects/share/'+jobid+'/updateModel',
		data: {
			'jobid': jobid,
			'modelid': modelid,
			'status': status
		},
		success: function(resultData) {
			if (closemodal = true) {
				$('.croissant-close').trigger('click');
			}
		}
	});
}
function setupModelCards() {
	$.each($('a.modelcard'),function(e) {
		$(this).draggable({
			revert: 'invalid',
			snap: '.container',
			snapMode: 'outer'
		});
	});
}