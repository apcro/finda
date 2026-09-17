/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
$('#deleteconfirm').on('click', function(e) {
	e.preventDefault();
	$.ajax({ 
		type: 'POST', 
		url: '/user/deleteconfirm', 
		success: function(data) {
			if (data == true) {
				document.location.href = '/';
			}
		}
	})
});