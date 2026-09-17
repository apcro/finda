/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
$(function() {
	$('.message-controls a.msgreply').on('click', function(e) {
		e.preventDefault();
		e.stopPropagation();
		var self = this;
		var msgid = $(self).data("msgid");
		var url = $(self).attr("href");
		
		$.ajax({
			type: 'POST',
			url: '/user/msg/'+url,
			data: {
				'msgid': msgid
			},
			success: function(resultData) { 
				if (url != 'edit') {
					if (resultData == true) {
						$('.msg' + msgid).stop().animate({ 
							"opacity": "0",
							"height": 0}, {
								duration: 300,
								complete: function() { 
									$('.msg' + msgid).remove();
									$('a.croissant-close').trigger('click');
								}
						});
					} else {
						$('body').tinymodal({
							title: 'Something went wrong',
							message: 'Please try again',
							base_class: 'modalWhite'
						})
					}
					
				}
			}
		})
		
		
	});	
	
	$('.message-actions a.updateoffer').on('click', function(e) {
		e.preventDefault();
		e.stopPropagation();
		var msgid = $(this).data('msgid');
		var modelrate = parseInt($(this).data('modelrate'));
		$('body').tinymodal({
			title: 'Update Offer',
			message: ''
					+ '<div class="input-group">'
					+ '	<span class="input-group-label">New Rate</span>'
					+ '	<input type="text" name="updatedrate" value="' + (modelrate+5) + '" placeholder="Updated Rate" class="input-group-field"/>'
					+ '	<div class="input-group-button">'
					+ '		<button class="button hvr text-white bg-blue hvr-black-textwhite" id="updateoffer" data-modelrate="' + modelrate + '" data-msgid="' + msgid + '" type="submit" value="Update Offer">Update offer</button>'
					+ '	</div>'
					+ '</div>',
			base_class: 'modalWhite updateOffer'
		});
		$('#updateoffer').on('click', function(e) {
			e.preventDefault();
			var msgid = $(this).data("msgid");
			var url = $(this).attr("href");
			var newrate = $('input[name=updatedrate]').val();
			var oldrate = $(this).data('modelrate');
			if (newrate != oldrate) {
				$.ajax({
					type: 'POST',
					url: '/user/msg/updaterate',
					data: {
						'msgid': msgid,
						'rate': newrate
					},
					success: function(resultData) { 
						if (url != 'edit') {
							$('.msg' + msgid).stop().animate({ 
								"opacity": "0",
								"height": 0}, {
									duration: 300,
									complete: function() { 
										$('.msg' + msgid).remove();
										$('a.croissant-close').trigger('click');
									}
							});
						}
					}
				})
			} else {
				$('a.croissant-close').trigger('click');
			}
		});	
	});
	
	$('.message-actions a.edit').on('click', function(e) {
		e.stopPropagation();
	});
	
	$('.message-controls a.confirmmodel').on('click', function(e) {
		e.stopPropagation();
		e.preventDefault();
		var msgid = $(this).data('msgid');
		var that = this;
		
		var modal = $('body').tinymodal({
			title: 'Are you sure?',
			base_class: '',
			message: 
					'<div class="row"><div class="column" style="margin-top: 0.5em">'
					+'<button class="button white fancy" id="confirm_confirm" data-msgid="' + msgid + '" type="button delete" value="Confirm mode" >Confirm</button>'
					+'</div><div class="column" style="margin-top: 0.5em">'
					+'<button class="close button bg-grey hvr hvr-white" id="confirm_cancel" type="button cancel" value="Cancel" >Cancel</button>'
					+'</div></div>'
		});
		$("#confirm_confirm").on('click', function() {
			$.ajax({
				type: 'POST',
				url: '/user/msg/confirmmodel',
				data: {
					'msgid': msgid
				},
				success: function(resultData) {
					var message = '';
					if (resultData.status != false) {
						$('a.croissant-close').trigger('click');
						$('body').tinymodal({
							html: resultData.html,
							base_class: 'modalWhite'
						});
						$.ajax({
							type: 'POST',
							url: '/user/msg/delete',
							data: {
								'msgid': msgid
							},
							success: function(resultData) { 
//								window.location.href = '/projects/edit/'+jobid+'#models';
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
						});
						
					} else {
						$('body').tinymodal({
							title: 'There was an error',
							message: 'Please try again later',
							base_class: 'modalWhite'
						});
	
					}
				}
			});
		});
		$("#confirm_cancel").on('click', function() {
			$('a.croissant-close').trigger('click');
		});
	});
	
	$('.message-controls .success.button').not('.replycomposed').on('click', function(e) {
		e.stopPropagation();
	});
	$('.row.notes').on('click', function(e) {
		e.preventDefault();
		e.stopPropagation();
		var jobid = $(this).data('jobid');
		var usertype = $(this).data('usertype');
		var msgtype = $(this).data('msgtype');
		var sefu = $(this).data('sefu');
		if (usertype == 1 && msgtype != 14 && msgtype != 16 && msgtype != 17) {
			window.location.href = '/jobs/view/'+jobid;
		} else if (usertype != null) {
			if (msgtype == 4 || msgtype == 2) {
				window.location.href = '/projects/edit/'+jobid+'#models';
			} else if (msgtype == 14 || msgtype == 16 || msgtype == 17) {		// composed
				window.location.href = '/messages/'+sefu;
			} else {
				window.location.href = '/projects/view/'+jobid;
			}
		}
	});
	
	if ($('.blockcompanyupdates').length > 0) {
		$('.myupdates').off().on('click', function(e) {
			e.preventDefault();
			$('.myupdates, .companyupdates').removeClass('active');
			$(this).addClass('active');
			$('.blockmyupdates').removeClass('active');
			$('.blockcompanyupdates').removeClass('active');
			$('.blockmyupdates').addClass('active');
			updateJobListCounts('blockmyupdates');
		});
		
		$('.companyupdates').off().on('click', function(e) {
			e.preventDefault();
			$('.myupdates, .companyupdates').removeClass('active');
			$(this).addClass('active');
			$('.blockmyupdates').removeClass('active');
			$('.blockcompanyupdates').removeClass('active');
			$('.blockcompanyupdates').addClass('active');
			updateJobListCounts('blockcompanyupdates');
		});
		
	}
	
	$('.flagcomposed').on('click', function(e) {
		e.preventDefault();
		e.stopPropagation();
		var msgid = $(this).data('msgid');
		$('body').tinymodal({
			html: '<div class="row"><div class="column" style="margin-bottom: 2em;"><h2>Flag this message?</h2></div></div><div class="row"><div class="column">Is this message inappropriate? Click the <em>FLAG</em> button below to report it to us, and we will investigate.</div></div><div class="row"><div class="column text-center" style="margin-top: 2em;"><a class="button burgundy confirmflag" data-msgid="'+msgid+'">FLAG</a></div></div>',
			callback: function(e) {
				$('.confirmflag').off().on('click', function(e) {
					e.preventDefault();
					$('a.croissant-close').trigger('click');
					var msgid = $(this).data('msgid');
					$.ajax({
						type: 'POST',
						url: '/user/msg/flagmessage',
						data: {
							'msgid': msgid
						},
						success: function(resultData) {
							$('body').tinymodal({
								title: 'Message flagged',
								message: '',
								autoCloseTimeout: 3000
							});
						}
					});
				});
			}
				
			
		});
	});
})

