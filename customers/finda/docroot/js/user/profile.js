/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
$('.moreModelInfo').on('click', function(e) {
	e.preventDefault();
	var jobid = $(this).data('jobid');
	if (jobid != null) {
		$('#moreModelInfo').html('')
		$.ajax({
			type: 'POST',
			url: '/projects/modelinfo',
			data: {
				'jobid': jobid
			},
			success: function(resultData) {
				$('#moreModelInfo').html(resultData).updateTinyModal()
				
			}
		})

	}
});