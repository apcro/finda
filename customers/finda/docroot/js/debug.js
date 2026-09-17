/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
$(document).ready(function() {
	$('#debugoutput .debug_bar').mouseenter(function() {
		$('.debug_popout').stop(true, true).fadeIn(100);
	}).mouseleave(function(){
		$('.debug_popout').stop(true,true).fadeOut(500);
	});
});
