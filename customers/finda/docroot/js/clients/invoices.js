/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
$(document).ready(function() {
	var paymentsuccess = $('input[name=paymentsuccess]').val();
	if (paymentsuccess != 0) {
		if (paymentsuccess == 1) {
			$('body').tinymodal({
				title: 'Thank you',
				message: 'Your payment was accepted and the invoice is now marked as paid.'
			});
		} else if (paymentsuccess == 2) {
			$('body').tinymodal({
				title: 'Sorry, there was a problem',
				message: 'Your payment was not accepted, and your invoice is still marked as unpaid.'
			});
		}
	}
	setupCompanyTabs();
});


function setupCompanyTabs() {
	if ($('.blockcompanyinvoices').length > 0) {
		$('.myinvoices').off().on('click', function(e) {
			e.preventDefault();
			$('.myinvoices, .companyinvoices').removeClass('active');
			$(this).addClass('active');
			$('.blockmyinvoices').removeClass('active');
			$('.blockcompanyinvoices').removeClass('active');
			$('.blockmyinvoices').addClass('active');
		});
		
		$('.companyinvoices').off().on('click', function(e) {
			e.preventDefault();
			$('.myinvoices, .companyinvoices').removeClass('active');
			$(this).addClass('active');
			$('.blockmyinvoices').removeClass('active');
			$('.blockcompanyinvoices').removeClass('active');
			$('.blockcompanyinvoices').addClass('active');
		});
		
	}
}