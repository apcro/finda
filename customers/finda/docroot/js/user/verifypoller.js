/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
// Poll for new messages every 5 minutes
var verified = false;
(function pollServerForVerification() {
	$.getJSON('/user/checkverification', function(response) {
		if (response == true) {
			verified = true;
			$('body').tinygrowl({
				title: 'Welcome to iDAL!',
				message: 'Your account has been verified',
				direction: 'down',
				vertical_offset: 76
			});
		}
	});
	if (!verified) {
		setTimeout(pollServerForVerification, 350000);
	}
}());