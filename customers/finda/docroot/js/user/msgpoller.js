/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
// Poll for new messages every 2 seconds
(function pollServerForNewMessages() {
	$.getJSON('/user/notifications/getnew', function(response) {
		if (response) {
			if (response.unread == '0') {
				$('a.msgnotifications').removeClass('badge');
			} else {
				$('a.msgnotifications').removeClass('badge').addClass('badge');
			}
			$('a.msgnotifications').attr('data-badge', response.unread);
			if (typeof(response.offers) !== 'undefined') {
				if (response.offers == 0) {
					$('a.msgoffers').removeClass('badge');
				} else {
					$('a.msgoffers').removeClass('badge').addClass('badge');
				}
				$('a.msgoffers').attr('data-badge', response.offers);
			}
			if (typeof(response.invoices) !== 'undefined') {
				if (response.offers == 0) {
					$('a.invoicecount').removeClass('badge');
				} else {
					$('a.invoicecount').removeClass('badge').addClass('badge');
				}
				$('a.invoicecount').attr('data-badge', response.invoices);
			}
		}
		setTimeout(pollServerForNewMessages, 120000);
	});
}());
