/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
$(function() {
	
	$('.releasepayment').on('click', function(e) {
		e.preventDefault();
		
		$(this).removeClass('releasepayment');
		var that = this;
		
		$.ajax({
			type: 'POST',
			url: '/payments/releasepayment',
			data: {
				invoiceid: $(this).data('invoiceid')
			},
			success: function(resultData) {
				if (resultData == true) {
					$(that).remove();
					$('body').tinymodal({
						title: 'Payment has been released',
						message: 'The funds should be in your bank account within 3 days.'
					});
				} else {
					$('body').tinymodal({
						title: 'Sorry',
						message: 'Something went wrong.'
					});
				}
			}
		});

	});
});