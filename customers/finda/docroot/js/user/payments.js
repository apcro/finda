/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
$(function() {

	var sortcode = new Cleave('#sortcode', {
		blocks: [2, 2, 2],
		delimiter: '-'
	});

	var accountnumber = new Cleave('#accountnumber', {
		blocks: [8]
	});
});