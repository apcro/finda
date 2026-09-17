/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
$('.auth').on('click', function(e) {
	e.preventDefault();
	var code = $('input[name=code]').val();
	code = code.replace(/\s+/g, '');
	var shareuri = $('input[name=shareuri]').val();
	$.ajax({
		type: 'POST',
		url: '/projects/shareauth',
		data: {
			'code': code,
			'shareuri': shareuri
		},
		success: function(resultData) {
			if (resultData == true) {
				window.location.href = '/projects/share/'+shareuri;
			} else {
				$('body').tinymodal({
					title: 'Sorry',
					message: 'That code was not recognised.'
				});
			}
		}
	});
});
