/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
var minHourly = 0;
var minDaily = 0;

$(window).on('scroll', function(e) {
	if (changed) {
		if ($(window).scrollTop() > 285) {
			$('.changed_banner').css('opacity', '1');
		} else {
			$('.changed_banner').css('opacity', '0');
		}	
	}
});

$('.tabs.flex-tabs label').on('click', function(e) {
	var hash = $(this).attr('id');
	if(typeof hash !== "undefined") {
		hash = hash.replace('tab-', '').replace('-label', '');
		var tabhashes = ['details', 'additional','rights', 'models', 'findModels'];
		if (tabhashes.includes(hash)) {
			if (history.pushState) {
				history.pushState(null, null, '#' + hash);
			} else {
				location.hash = '#' + hash;
			}
		}
	}
	
});

var modelcount = $('#modelcount').val();
var changed = false;

var confirmed = $('.optioned.modelcards').find('.confirmed').length;
var accepted = $('.optioned.modelcards').find('.accepted').length;
var offered = $('.optioned.modelcards').find('.offered').length;
var negotiating = $('.optioned.modelcards').find('.negotiated').length;
var selectedcount = $('.optioned.modelcards').find('.searchmodelimage').length;

var bookingtype = 'booking';

var jobid = $('input[name=jobid]').val();

$(window).ready(function() {
	
	bookingtype = $('input[name=bookingtype]').val();
	
	minHourly = $('input[name=minHourly]').val();
	minDaily = $('input[name=minDaily]').val();

	$('select[name="jobtype input"]').on('change', function(e) {
		e.preventDefault();
		var selected = $(this).find('option:selected');
		var jobtype = selected.val();
		minHourly = selected.data('hourly');
		minDaily = selected.data('daily');
		switch (jobtype) {
			case '12':
				$('.projectnormal').hide();
				$('.projectinfluencer').show();
				break
			default:
				$('.projectnormal').show();
				$('.projectinfluencer').hide();
				break;
			}
	});

	if ($('select[name="jobtype input"]').val() == 12) {
		$('.projectnormal').hide();
		$('.projectinfluencer').show();
	} else {
		$('.projectnormal').show();
		$('.projectinfluencer').hide();
	}
	
	$('#startdate').Zebra_DatePicker({
		direction: true,
		disable_time_picker: true,
		format: 'd-m-Y',
		icon_position: "left",
		show_icon: false,
		offset: [-300, 0]
	});
	
	$('#starttime').clockpicker({
		placement: 'top',
		align: 'left',
		donetext: 'Done',
		autoclose: true
	});
	
	if ($('#rate').length > 0) {
		var rate = new Cleave('#rate', {
			numeral: true,
			numeralPositiveOnly: true,
			prefix: '£'
		});
	}
	
	$('.model-favourite-2, .model-favourite').on('click', function(e) {
		e.preventDefault();
		e.stopPropagation();
		var modelid = $(this).data('id');
		if ($(this).find('i').hasClass('far')) {
			$(this).find('i').removeClass('far').addClass('fas');
		} else {
			$(this).find('i').removeClass('fas').addClass('far');
		}
		$.ajax({
			type: 'POST',
			url: '/search/toggle-favourite',
			data: {
				'modelid': modelid
			},
			success: function(resultData) {}
		})
	});
	
	$.each($('.additional-info .tgl'), function() {
		if ($(this).is(':checked')) {
			$('textarea[name='+$(this).attr('id')+']').show();
		} else {
			$('textarea[name='+$(this).attr('id')+']').hide();
		}
	});
	$('.additional-info .tgl').on('change', function(e) {
		if ($(this).is(':checked')) {
			$('textarea[name='+$(this).attr('id')+']').show();
		} else {
			$('textarea[name='+$(this).attr('id')+']').hide();
		}
	});
	
	$('input[name=baseusage]').on('change', function(e) {
		e.preventDefault();
		$.each($('.triplet-checkbox.rights label'), function() {
			$(this).removeClass('active');
		});
		var type = $(this).attr('id');
		$('label[for='+type+']').addClass('active');
		switch(type) {
			case 'standardrights':
				$('.rights-holder').hide();
				countOn();
				break;
			case 'extrarights':
				$('.rights-holder').show();
				enableAllRights();
				break;
		
		}
	});
	
	$('.base-rights-holder .tgl').on('change', function(e) {
		e.preventDefault();
		if ($('#standardrights').is(':checked')) {
			countOn();
		}
	});

//	$('.confirmchanges').on('click', function(e) {
//		e.preventDefault();
//		SaveChanges();
//	});
	
	$('.cancelchanges').on('click', function(e) {
		e.preventDefault();
		location.reload();
	});
	
	
	$('select[name="jobtype input"]').on('change', function(e) {
		e.preventDefault();
		var jobtype = $(this).val();
		$('.base-rights-holder').show();
		switch (jobtype) {
			case '12':
				$('.base-rights-holder').hide();
				break
			case '3':
			case '4':
			case '8':
			case '51':
				break;
			default:
				break;
		}
		$('.jobtype_header').html($('#jobtype option:selected').text());
	});
	
	$('#modelcount').on('blur', function(e) {
		var enteredcount = $(this).val();
		var totalcount = parseInt(accepted)+parseInt(confirmed);
		if (enteredcount < totalcount) {
			// error! can't have less than offered!
			var message = 'You can\'t set the number of models to less than '+totalcount+' as '+enteredcount+' model';
			if (enteredcount != 1) {
				message += 's';
			}
			message += ' have already accepted your offer. If you need fewer models, please cancel one or more models.';
			$('body').tinymodal({
				title: 'Sorry',
				message: message
			});
			$(this).val(totalcount);
		}
	});
	
	enableAllRights();
	countOn();
	setRights();
	setupModelDragDrop();
	setupButtons();
	updateOfferButtons();
	setOptionButtons();
	
	if ($('select[name="jobtype input"]').val() == 12) {
		$('.base-rights-holder').hide();
	}
	
	$('#rate').on('blur', function(e) {
		if ($('#baserateradio').is(':checked')) {
			var rate = parseInt($(this).val().replace('£', '').replace(',', ''));
			var selected = $('select[name="jobtype input"]').find('option:selected');
			var jobtype = selected.html();
			var unitstype_selected = $('#unitstype').find('option:selected');
			if (unitstype_selected.val() == 'day') {
				if (rate < minDaily) {
					$('.minrate_notice').html('The minimum daily rate for<br />' + jobtype + ' jobs is £' + minDaily);
					$('.minrate_notice').show();
					$('.updatebtn').attr('disabled', 'disabled');
				} else {
					$('.minrate_notice').hide();
					$('.updatebtn').removeAttr("disabled");
					
				}
			} else if (unitstype_selected.val() == 'hour') {
				if (rate < minHourly) {
					$('.minrate_notice').html('The minimum hourly rate for<br />' + jobtype + ' jobs is £' + minHourly);
					$('.minrate_notice').show();
					$('.updatebtn').attr('disabled', 'disabled');
				} else {
					$('.minrate_notice').hide();
					$('.updatebtn').removeAttr("disabled");
				}
			}
		}
	});
	
	$('#length, #rate, #modelcount').on('change', function(e) {
		$('.minlength_notice').hide();
//		console.log('changed');
		updateRate();
//		var unitstype_selected = $('#unitstype').find('option:selected');
//		if (unitstype_selected.val() == 'hour') {
//			var length = $(this).val();
//			if (length >= 5) {
//				$('.minlength_notice').html('5 hours or more is considered<br />1 working day, please insert 1 day.');
//				$('.minlength_notice').show();
//			}
//		}
		
	});
	
//	$('.modelcard').off().on('click', function(e) {
//		e.stopPropagation();
//		var href = $(this).data('href');
//		window.location.href = href;
//	});
	
	if ($('.createtemplate').length > 0) {
		$('.createtemplate').off().on('click', function(e) {
			e.preventDefault();
			var name = $('input[name=templatename]').val();
			if (name == '') {
				$('input[name=templatename]').css('border', '1px solid red');
			} else {
				$('a.croissant-close').trigger('click');
				$('input[name=templatename]').css('border', '1px solid transparent');
				$.ajax({
					type: 'POST',
					url: '/templates/createfrom',
					data: {
						'jobid': $('input[name=jobid]').val(),
						'templatename': name
					},
					success: function(resultData) {
						var message = '';
						if (resultData == true) {
							html = '';
							html = '<div class="row"><div class="column"><h2>Template Created</h2></div></div>';
							html += '<div class="row" style="margin-top: 2em;"><div class="column"><a href="" class="okbutton button inverted">OK</a></div></div>';
						} else {
							html = '';
							html = '<div class="row"><div class="column"><h2>There was an error creating your new template. Please try again later.</h2></div></div>';
							html += '<div class="row" style="margin-top: 2em;"><div class="column"><a href="" class="okbutton button inverted">OK</a></div></div>';
						}
						$('body').tinymodal({
							html: html,
							callback: function(e) {
								$('a.okbutton').off().on('click', function(e) {
									e.preventDefault();
									$('a.croissant-close').trigger('click');
								});
							}
						});
					}
				});
			}
		});
	}
	
	$('.notespan').off().on('click', function(e) {
		e.preventDefault();
		e.stopPropagation();
		var modelid = $(this).data('modelid');
		var html = $('.notesholder-'+modelid).html();
		$('body').tinymodal({
			html: html, 
			callback: function(e) {
				$('.savenotes').off().on('click', function(e) {
					e.preventDefault();
					var notes = $(this).parent().find('.modelnotes').val();
					$('.croissant-close').trigger('click');
					$.ajax({
						type: 'POST',
						url: '/projects/savenotes',
						data: {
							modelid: modelid,
							jobid: jobid,
							notes: notes
						},
						success: function(resultData) {
							if (resultData == true) {
								$('.modelnotes-'+modelid).html(notes);
								$('body').tinymodal({
									title: 'Saved',
									message: '',
									autoClose: true,
									autoCloseTimeout: 1000
								});
							} else {
								$('body').tinymodal({
									title: 'Sorry',
									message: 'Something went wrong saving your notes.<br />We\'ve kept them on this page so you can try again.'
								});
							}
						}
					})
				});
			}
		});
	});
	
});

function setRights() {
	if ($('#standardrights').is(':checked')) {
		$('.rights-holder').hide();
	} else {
		$('.rights-holder').show();
		enableAllRights();
	}
}
function countOn() {
	var count = 0;
	enableAllRights();
	$.each($('.base-rights-holder .tgl'), function() {
		if ($(this).is(':checked')) {
			count++;
		}
		if (count >=3) {
			disableAllRights();
			return count;
		}
	});
	return count;
}

function disableAllRights() {
	$.each($('.base-rights-holder .tgl'), function() {
		if ($(this).is(':checked')) {
		} else {
			$(this).prop('disabled', true);
			$(this).parent().addClass('disabled');
		}
	});
}

function enableAllRights() {
	$.each($('.base-rights-holder .tgl'), function() {
		$(this).prop('disabled', false);
		$(this).parent().removeClass('disabled');
	});
}

function setupModelDragDrop() {
	setupContainers();
	setupModelCards();
}

function setupContainers() {

	$('.sharebutton').on('click', function(e) {
		e.preventDefault();
		var html = $('#tab-sharecode-panel .row .column').html();
		$('body').tinymodal({
			html: html
		});
	});
}

function setupModelCards() {
	
//	$('.modelcard').off().on('click', function(e) {
//		e.stopPropagation();
//		updateOfferButtons();	// update counts
//	});
}

function setupRequestButtons() {
	$('.requestModel').off('click').on('click', function(e) {
		e.preventDefault();
		var modelid = $(this).data('modelid');
		if (modelid != null) {
			$.croissant.moveAnimate($('#modeldrag-'+modelid), $('.unconfirmed.container'));
			showChangedBanner();
			$('#modeldrag-'+modelid).find('.requestModel').removeClass('requestModel').addClass('removeModel').html('Cancel');
			setupRemoveButtons();
		}
	});
}

function setupRemoveButtons() {
	$('.detailsoverlay-removemodel').off('click').on('click', function(e) {
		e.preventDefault();
		e.stopPropagation();
		
		var modelId = $(this).data('modelid');
		var modal = $('#finda-website').tinymodal({
			title: 'Are you sure?',
			base_class: 'modalWhite',
			message: 
					'<div class="row"><div class="column">'
					+'<button class="button" id="delete_confirm" type="button delete" value="Reject offer" >Remove</button>'
					+'</div></div>'
		});
		$("#delete_confirm").on('click', function() {
			if (modelId != null) {
				$.ajax({
					type: 'POST',
					url: '/projects/edit/' + $('input[name=jobid]').val()+'/removeModel',
					data: {
						'jobid': $('input[name=jobid]').val(),
						'modelid': modelId
					},
					success: function(resultData) { 
						$('a.croissant-close').trigger('click');
						if (resultData == true) {
							$('#modeldrag-'+modelId).fadeOut('fast', function() {
								$('#modeldrag-'+modelId).remove();
								$('.modelsearch-'+modelId).find('.ribbon').remove();
								updateOfferButtons();
							});
							// we also need to remove the ribbon from the cached search page
							$('#modelSearch').find('#modelresult-'+modelId).find('.ribbon').remove();
							$('.optionbutton-'+modelId).show();
//							$('.optionbutton-'+modelId).html('Select').css('pointer-events', 'inherit').removeClass('success');
						}
					}
				})
			}
		});
		$("#delete_cancel").on('click', function() {
			$('a.croissant-close').trigger('click');
		});
		
		
		
		
	});
	
	$('.removeModel').off('click').on('click', function(e) {
		e.preventDefault();
		var modelId = $(this).data('modelid');
		var modal = $('#finda-website').tinymodal({
			title: 'Are you sure?',
			base_class: 'modalWhite',
			message: 
					'<div class="row"><div class="column">'
					+'<button class="button inverted" id="delete_confirm" type="button delete" value="Reject offer" >Remove</button>'
					+'</div></div>'
		});
		$("#delete_confirm").off().on('click', function() {
			if (modelId != null) {
				$.ajax({
					type: 'POST',
					url: '/projects/edit/' + $('input[name=jobid]').val()+'/removeModel',
					data: {
						'jobid': $('input[name=jobid]').val(),
						'modelid': modelId
					},
					success: function(resultData) { 
						$('a.croissant-close').trigger('click');
						if (resultData == true) {
							$('#modeldrag-'+modelId).fadeOut('fast', function() {
								$('#modeldrag-'+modelId).remove();
							});
							// we also need to remove the ribbon from the cached search page
							$('#modelSearch').find('#modelresult-'+modelId).find('.ribbon').remove();
							
							// and add in the option button again
							$('#modelresult-'+modelId+' div.details_overlay').append('<div class="align-center"><span data-modelid="'+modelId+'" class="option button small optionbutton-'+modelId+'">option</span></div>');
//							$('.optionbutton-'+modelId).html('Select').css('pointer-events', 'inherit').removeClass('success');
							setOptionButtons();
							updateOfferButtons();
						}
					}
				})
			}
		});
		$("#delete_cancel").on('click', function() {
			$('a.croissant-close').trigger('click');
		});
		
	});
	
	$('.removeConfirmedModel').off('click').on('click', function(e) {
		e.preventDefault();
		var modelId = $(this).data('modelid');
		var modal = $('#finda-website').tinymodal({
			title: 'Are you sure?',
			base_class: 'modalWhite',
			message: 
					'<div class="row"><div class="column">'
					+'<button class="button inverted" id="delete_confirm" type="button delete" value="Reject offer" >Remove</button>'
					+'</div></div>'
		});
		$("#delete_confirm").off().on('click', function() {
			if (modelId != null) {
				$.ajax({
					type: 'POST',
					url: '/projects/edit/' + $('input[name=jobid]').val()+'/removeModel',
					data: {
						'jobid': $('input[name=jobid]').val(),
						'modelid': modelId
					},
					success: function(resultData) { 
						$('a.croissant-close').trigger('click');
						if (resultData == true) {
							$('#confirmed-'+modelId).fadeOut('fast', function() {
								$('#confirmed-'+modelId).remove();
							});
							// we also need to remove the ribbon from the cached search page
							$('#modelSearch').find('#modelresult-'+modelId).find('.ribbon').remove();
							$('.optionbutton-'+modelId).html('Select').css('pointer-events', 'inherit').removeClass('success');
						}
					}
				})
			}
		});
		$("#delete_cancel").on('click', function() {
			$('a.croissant-close').trigger('click');
		});
		
	});
	if (bookingtype != 'casting') {
		updateRate();
	}
}

function setupOptionButtons() {
	
	$('.offerbutton').off().on('click', function(e) {
		e.preventDefault();
		e.stopPropagation();
		var modelid = $(this).data('modelid');
		var jobid = $(this).data('jobid');
		var that = $(this);
		if (modelid != null) {
			$.ajax({
				type: 'GET',
				url: '/projects/edit/'+jobid+'/getjobcardconfirm',
				data: {
					'jobid': jobid,
					'modelid': modelid
				},
				success: function(resultData) { 
					$('body').tinymodal({
						html: resultData
					});
					$('.confirmoffer').off().on('click', function(e) {
						updateModelStatus(modelid, jobid, 1, false);
						$('a.croissant-close').trigger('click');
						
						if (bookingtype == 'booking') {
							$('#modeldrag-'+modelid).find('.statusribbon .button').removeClass('optioned').addClass('offered').addClass('disabled').html('Requested');
						} else {
							$('#modeldrag-'+modelid).find('.statusribbon .button').removeClass('optioned').addClass('offered').addClass('disabled').html('Invited');
						}

						updateOfferButtons();
					});
					$('.cancel').off().on('click', function(e) {
						$('a.croissant-close').trigger('click');
					});
					
				}
			});
			
		}
	});
}

function setupButtons() {
	setupOptionButtons();
	setupRemoveButtons();
	setupRequestButtons();
	updateOfferButtons();
	
	$('.updatebtn').on('click', function(e) {
		e.stopPropagation();
		e.preventDefault();
		
		// extra step: https://kantree.io/p/5bd8b50a-finda-website#1150
		confirmed = $('.optioned.modelcards').find('.confirmed').length;
		newmodelcount = $('#modelcount').val();
		if (confirmed == newmodelcount && newmodelcount != 0) {
			
			var html = '<div class="row"><div class="column"><h1>Save and Confirm Booking?</h1></div></div>'
				+ '<div class="row"  style="margin-top: 1em; margin-bottom: 1em;"><div class="column"><p>You have already confirmed '+newmodelcount+' model';
			if (confirmed != 1) {
				html += 's';
			}
			html += '.<br /><br />';
			html += 'Updating this booking to '+newmodelcount+' model';
			if (newmodelcount != 1) {
				html += 's';
			}
			html += ' will confirm it as well as saving your changes.</p></div></div>'
				+ '<div class="row"><div class="column"><a class="confirmclosejob button burgundy"data-jobid="'+jobid+'">Confirm Booking</a></div><div class="column"><a class="cancelclosejob button inverted">Cancel</a></div></div>'
			
			$('body').tinymodal({
				html: html,
				callback: function() {
					$('.cancelclosejob').off().on('click', function(e) {
						e.preventDefault();
						$('a.croissant-close').trigger('click');
					});
					$('.confirmclosejob').off().on('click', function(e) {
						e.preventDefault();
						$('a.croissant-close').trigger('click');
						$.ajax({
							type: 'POST',
							url: '/projects/closejob',
							data: {
								'jobid': jobid,
								'bookingtype': bookingtype
							},
							success: function(resultData) {
								if (resultData != false) {
									if (bookingtype == 'casting') {
										$('body').tinymodal({
											title: 'Casting confirmed',
											message: 'This casting has been confirmed.',
											remove_callback: function() {
												window.location.href = '/projects';
											}
										});
									} else {
										var html = '<div class="row"><div class="column"><h1>Project confirmed</h1></div></div>'
											+ '<div class="row" style="margin-top: 2em;"><div class="column"><p>This project has been confirmed and your invoice has been generated.</p></div></div>'
											+ '<div class="row"><div class="column"><p><a class="button inverted" href="/invoices/pay/'+resultData+'">View/Pay Invoice</a></p></div></div>'
											$('body').tinymodal({
												html: html,
												remove_callback: function() {
													window.location.href = '/projects';
												}
											});
									}
								} else {
									$('body').tinymodal({
										title: 'Sorry',
										message: 'There was an error comfirming this job. The job is still open.',
										remove_callback: function() {
											window.location.href = '/projects';
										}
									});
								}
							}
						});
					});	
				}
			});
		} else {
			var step = $('<input>').attr('type', 'hidden').attr('name', 'step').val('update');
			$('#projectdetails').append(step);
			$('body').tinymodal({
				html: '<div class="row"><div class="column"><h2 style="max-width: 80%; transform-origin: center center; text-align: center; margin-left: auto; margin-right: auto;">Your project is updated and the models are being notified</h2></div></div>'
					+'<div class="row" style="margin-top: 1em"><div class="column"><button class="button" id="updateproject">OK</button></div></div>'
			});
			$('#updateproject').on('click', function(e) {
				$('a.croissant-close').trigger('click');
				$('#projectdetails').submit();
			});
		}
		
	});
}

function updateOfferButtons() {
	confirmed = $('.optioned.modelcards').find('.confirmed').length;
	accepted = $('.optioned.modelcards').find('.accepted').length;
	offered = $('.optioned.modelcards').find('.offered').length;
	negotiating = $('.optioned.modelcards').find('.negotiated').length;
	selectedcount = $('.optioned.modelcards').find('.searchmodelimage').length;

	if (confirmed >= modelcount) {
		$.each($('.optioned.modelcards .confirmbutton'), function(e) {
			$(this).hide();
		});
		$.each($('.statusribbon .button'), function(e) {
			if (!$(this).hasClass('confirmed')) {
				$(this).hide();
			}
		});
	}
	
	$('.number').html(selectedcount);
	
	if (confirmed != 0) {
		$('.confirmbuttoncolumn').show();
		$('.confirmedmodelcount').html(confirmed);
	}
}

$('.modelSearchButton').on('click', function(e) {
	e.preventDefault();
	document.location.hash = 'findModels';
	$.ajax({
		type: 'POST',
		url: '/projects/edit/open/searchModal',
		data: {
			'state': 'open'
		},
		success: function(resultData) { 
			
		}
	});
	$('body').showTinyModal('modelSearch');
	$('#croissant-overlay').on('modal_closed', function(e) {
		$.ajax({type: 'POST', url: '/projects/edit/close/searchModal'});
		document.location.hash = 'models';
		changeTabByHash();
	});
});

var jobid = $('input[name=jobid]').val();
$('.negotiatebutton').on('click', function(e) {
	e.preventDefault();
	e.stopPropagation();
	var modelrate = parseFloat($(this).data('modelrate'));
	var modelid = $(this).data('modelid');
	var modelname = $(this).data('modelname');
	var desiredrate = parseFloat($(this).data('desiredrate'));
	var offeredrate = parseFloat($(this).data('offeredrate'));
	
	var newoffer = parseInt(((desiredrate - offeredrate)/2) + offeredrate);

	var message = ''
			+ '<div class="row"><div class="column">'
			+ '<h2 class="text-burgundy">NEGOTIATE RATE</h2>';
			if (offeredrate != 0) {
				message += '<p>You previously offered £'+offeredrate+'<br />&nbsp;</p>';
			}
	message += '</div></div>'
			+ '<table style="border-spacing: 1em;">'
			+ '<tr style="margin-bottom: 1em;">'
			+ '<td class="text-left"><strong>'+modelname+' is asking for</strong></td>'
			+ '<td class="boxed">£'+desiredrate+'</td>'
			+ '<td><button style="margin-top: 0.5em; margin-left: 1em; padding-left: 1em; padding-right: 1em;" class="button small burgundy" id="acceptoffer" data-modelname="'+modelname+'" data-modelid="' + modelid + '" data-jobid="' + jobid + '" type="submit" value="Accept Offer">Accept &amp; Confirm Model</button></td>'
			+ '</tr>'
			+ '<tr style="margin-bottom: 1em;">'
			+ '<td class="text-left">Make a counter-offer (enter rate)</td>'
			+ '<td><input style="border-bottom-width: 3px; font-weight: bold; margin-top: 0; margin-bottom: 0; padding-top: 0.5em;" class="text-center boxed" type="text" name="updatedrate" value="' + (newoffer) + '" placeholder="Desired Rate" class="input-group-field"/></td>'
			+ '<td><button style="margin-top: 0.5em; margin-left: 1em; padding-left: 1em; padding-right: 1em;" class="button small inverted" id="updateoffer" data-oldrate="'+desiredrate+'" data-modelid="' + modelid + '" data-jobid="' + jobid + '" type="submit" value="Update Offer">Update Offer</button></td>'
			+ '</tr>'
			+ '<tr>'
			+ '<td class="text-left">Decline negotiation and keep last offer</td>'
			+ '<td class="boxed">£'+offeredrate+'</td>'
			+ '<td><button style="margin-top: 0.5em; margin-left: 1em; padding-left: 1em; padding-right: 1em;" class="button small" id="declineoffer" type="submit" value="Decline Negotiation">Decline Negotiation</button></td>'
			+ '</tr>'
			+ '</table>';
	
	$('#finda-website').tinymodal({
		html: message,
		base_class: 'modalWhite updateOffer',
		callback: function() {
			
			$('#declineoffer').off().on('click', function(e) {
				e.preventDefault();
				$('a.croissant-close').trigger('click');
			});
			
			$('#updateoffer').off().on('click', function(e) {
				e.preventDefault();
				$('a.croissant-close').trigger('click');
				var url = $(this).attr("href");
				var newrate = $('input[name=updatedrate]').val();
				var projectrate = parseInt($('#rate').val().replace('£', ''), 10);
				var oldrate = $(this).data('oldrate');
				var modelid = $(this).data('modelid');
				if (newrate != oldrate && newrate > 0 && newrate > projectrate) {
					$.ajax({
						type: 'POST',
						url: '/projects/updaterate',
						data: {
							rate: newrate,
							jobid: jobid,
							modelid: modelid
						},
						success: function(resultData) { 
							$('body').tinymodal({
								title: 'Negotiation sent',
								message: '',
								base_class: 'modalWhite',
								autoClose: true,
								autoCloseTimeout: 2000
							});
							updateOfferButtons();
						}
					})
				} else {
					var html = '<div class="row"><div class="column"><h1>Please enter a different rate</h1></div></div>';
					if (newrate < projectrate) {
						html = '<div class="row"><div class="column"><h1>Please enter a rate that is more than £'+projectrate+'</h1></div></div>'
					}
					$('body').tinymodal({
						html: html,
						base_class: 'modalBlue',
						retainModal: true,
						autoClose: true,
						autoCloseTimeout: 2000
					});
				}
			});
			
			$('#acceptoffer').off().on('click', function(e) {
				e.preventDefault();
				$('a.croissant-close').trigger('click');
				var modelid = $(this).data('modelid');
				var jobid = $(this).data('jobid');
				
				var that = this;
				var modelid = $(this).data('modelid');
				var jobid = $(this).data('jobid');
				var modelname = $(this).data('modelname');
				
				var confirmedcount = $('.modelcards .modelcard .statusribbon.confirmed').length;
				
				confirmDetails(that, modelid, jobid, modelname, confirmedcount, 1);
//				$.ajax({
//					type: 'POST',
//					url: '/projects/acceptrate',
//					data: {
//						jobid: jobid,
//						modelid: modelid
//					},
//					success: function(resultData) { 
//						$('.model-'+modelid).find('.statusribbon').removeClass('negotiated').addClass('requested').html('Requested');
//						$('.model-'+modelid).find('.negotiatebutton').remove();
//						$('body').tinymodal({
//							title: 'Model Rate Accepted',
//							message: '<div class="row"><div class="column">You have accepted the negotiated rate and confirmed '+modelname+'</div></div>'
//									+'<div class="row" style="padding-top: 1em"><div class="column"><button class="button" id="acceptedclose">OK</button></div></div>',
//							base_class: 'modalWhite',
//							remove_callback: function() {
//							}
//						});
//						$('#acceptedclose').on('click', function(e) {
//							e.preventDefault();
//							$('a.croissant-close').trigger('click');
//						});
//					}
//				})
			});
			
		}
	});
	
});

function showChangedBanner() {
	changed = true;
	$('.changedbutton').show();
	if ($(window).scrollTop() > 285) {
		$('.changed_banner').fadeIn('fast');
	} else {
		$('.changed_banner').show();
		$('.changed_banner').css('opacity', 0);
	}
	$('.changed_banner').off().on('click', function(e) {
		$('html, body').animate({
			scrollTop : 0
		}, 1000);
		
	});
}

function updateRate() {
	var rate = $('#rate').val().replace('£', '').replace(',', '');
	var projectduration = $('#length').val();
	var modelcount = $('#modelcount').val();
	
	var projectdurationcalc = (projectduration >= 1?projectduration:1);
	
	var subtotal = (rate * projectdurationcalc * modelcount);
	
	var findafee = subtotal * .1;
	var vat = (subtotal + findafee) * .2;
	var total = subtotal + findafee + vat;
	total = parseFloat(Math.round(total * 100) / 100).toFixed(2)
	$('#totalfee').val('£' + total);
}

function hideChangedBanner() {
	changed = false;
	$('.changedbutton').hide();
	$('.changed_banner').fadeOut('fast');	
}

function setOptionButtons() {
	// the new select
	$('.option').off().on('click', function(e) {
		e.preventDefault();
		
		self = this;
		var jobid = $('input[name=jobid]').val();
		var modelid = $(self).data('modelid');
		var offeredrate = '£0';
		if ($('#rate').length > 0) {
			offeredrate = $('#rate').val();
		}

		$(this).off();
		
		$.ajax({
			type: 'POST',
			url: '/view/' + modelid + '/optionmodel',
			data: {
				'jobid': jobid,
				'modelid': modelid,
				'offeredrate': offeredrate.substring(1),
				'bookingtype': bookingtype
			},
			success: function(resultData) {
				$(self).hide();
				$(self).parent().parent().parent().append('<div class="ribbon">SHORTLISTED</div>');
				
				// need to add the mode details here and update the count, remove the option button if necessary
				// inject the model details
				
				$('.optioned.modelcards').append(resultData.modelcard);
				
				setupModelCards();
				setupButtons();	// from jobs/editjob.js
				updateOfferButtons();
				
				// remove buttons, not remove crosses
				$('span.removeModel').off('click').on('click', function(e) {
					e.preventDefault();
					var modelId = $(this).data('modelid');
					if (modelId != null) {
						$.ajax({
							type: 'POST',
							url: '/projects/edit/' + $('input[name=jobid]').val()+'/removeModel',
							data: {
								'jobid': $('input[name=jobid]').val(),
								'modelid': modelId
							},
							success: function(resultData) { 
								if (resultData == true) {
									$('.model-'+modelId).parent().fadeOut('fast', function() {
										$('.model-'+modelId).parent().remove();
										$('.modelsearch-'+modelId).find('.ribbon').remove();
									});
									modelcount = parseInt($('.openedcount').html());
									modelcount = modelcount - 1;
									if (modelcount <= 0) {
										modelcount = 0;
										$('.column.modelcards').html('<img src="/images/bookmodelsexample.jpg" class="bookmodelsexample">');
									}
									$('.openedcount').html(modelcount);
									
									$('.optionbutton-'+modelId).html('Option').css('pointer-events', 'inherit').removeClass('success');
									$('.optionbutton-'+modelId).show();
								}
							}
						})
					}
				});
			}
		});

		
		
	});
	
	$('.confirmbutton').off().on('click', function(e) {
		e.preventDefault();
		e.stopPropagation();
		
		var that = this;
		var modelid = $(this).data('modelid');
		var jobid = $(this).data('jobid');
		var modelname = $(this).data('modelname');
		
		var confirmedcount = $('.modelcards .modelcard .statusribbon.confirmed').length;
		
		confirmDetails(that, modelid, jobid, modelname, confirmedcount, 0);
		
	});
	
	$('.closejob').off().on('click', function(e) {
		e.preventDefault();
		var jobid = $(this).data('jobid');
		var html = '<div class="row"><div class="column"><h1>Confirm Booking?</h1></div></div>'
			+ '<div class="row" style="margin-top: 1em; margin-bottom: 1em;"><div class="column"><p>You have only confirmed '+confirmed+' model';
		if (confirmed != 1) {
			html += 's';
		}
		html += ', but the booking asked for '+modelcount+'.</p></div></div>'
			+ '<div class="row"><div class="column"><a class="confirmclosejob button burgundy"data-jobid="'+jobid+'">Confirm Booking</a></div><div class="column"><a class="cancelclosejob button inverted">Cancel</a></div></div>'

		$('body').tinymodal({
			html: html,
			callback: function() {
				$('.cancelclosejob').off().on('click', function(e) {
					e.preventDefault();
					$('a.croissant-close').trigger('click');
				});
				$('.confirmclosejob').off().on('click', function(e) {
					e.preventDefault();
					$('a.croissant-close').trigger('click');
					$.ajax({
						type: 'POST',
						url: '/projects/closejob',
						data: {
							'jobid': jobid,
							'bookingtype': bookingtype
						},
						success: function(resultData) {
							if (resultData != false) {
								if (bookingtype == 'casting') {
									$('body').tinymodal({
										title: 'Casting confirmed',
										message: 'This casting has been confirmed.',
										remove_callback: function() {
											window.location.href = '/projects';
										}
									});
								} else {
									var html = '<div class="row"><div class="column"><h1>Project confirmed</h1></div></div>'
										+ '<div class="row" style="margin-top: 2em;"><div class="column"><p>This project has been confirmed and your invoice has been generated.</p></div></div>'
										+ '<div class="row"><div class="column"><p><a class="button inverted" href="/invoices/pay/'+resultData+'">View/Pay Invoice</a></p></div></div>'
										$('body').tinymodal({
											html: html,
											remove_callback: function() {
												window.location.href = '/projects';
											}
										});
								}
							} else {
								$('body').tinymodal({
									title: 'Sorry',
									message: 'There was an error comfirming this job. The job is still open.',
									remove_callback: function() {
										window.location.href = '/projects';
									}
								});
							}
						}
					});
				});
			}
		});
	});
}

function confirmDetails(that, modelid, jobid, modelname, confirmedcount, acceptingrate) {
	var canconfirm = false;

	// need to get this from the server now, as we need additional information for display
	$.ajax({
		type: 'POST',
		url: '/projects/confirmdetails',
		data: {
			'jobid': jobid,
			'modelid': modelid,
			'modelcount': modelcount,
			'confirmedcount': confirmedcount,
			'acceptingrate': acceptingrate
		},
		success: function(resultData) {
			var message = resultData;

			// is this the last model to be confirmed?
			if (modelcount == confirmedcount+1) {
				canconfirm = true;
			}
			
			var modal = $('body').tinymodal({
				base_class: 'modalWhite',
				html: message,
				callback: function() {
					$('.offer_confirm').on('click', function() {
						if (modelid != null) {
							
							// acceptrate here too
							$.ajax({
								type: 'POST',
								url: '/projects/acceptrate',
								data: {
									jobid: jobid,
									modelid: modelid
								},
								success: function() {
									$.ajax({
										type: 'POST',
										url: '/view/' + modelid + '/updateModelStatus',
										data: {
											'jobid': jobid,
											'modelid': modelid,
											'status': 2
										},
										success: function(resultData) {
											$(that).remove();
											$('.model-'+modelid+' .statusribbon').html('<div class="button small confirmed disabled">Confirmed</div>');

											$('a.croissant-close').trigger('click');
											
											if (canconfirm) {
												$.ajax({
													type: 'POST',
													url: '/projects/closejob',
													data: {
														'jobid': jobid,
														'bookingtype': bookingtype
													},
													success: function(resultData) {
														if (resultData != false) {
															if (bookingtype == 'casting') {
																$('body').tinymodal({
																	title: 'Casting confirmed',
																	message: 'This casting has been confirmed.',
																	remove_callback: function() {
																		window.location.href = '/projects';
																	}
																});
															} else {
																var html = '<div class="row"><div class="column"><h1>Project confirmed</h1></div></div>'
																		+ '<div class="row" style="margin-top: 2em;"><div class="column"><p>This project has been confirmed and your invoice has been generated.</p></div></div>'
																		+ '<div class="row"><div class="column"><p><a class="button inverted" href="/invoices/pay/'+resultData+'">View/Pay Invoice</a></p></div></div>'
																$('body').tinymodal({
																	html: html,
																	remove_callback: function() {
																		window.location.href = '/projects';
																	}
																});
															}
														} else {
															$('body').tinymodal({
																title: 'Sorry',
																message: 'There was an error comfirming this job. The job is still open.',
																remove_callback: function() {
																	window.location.href = '/projects';
																}
															});
														}
													}
												});
											} else {
												updateOfferButtons();
											}
										}
									});
								}
							});
							
							
						}
					});
				}
			});
		}
	});
}
