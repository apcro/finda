/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
var userid = $('input[name=modelid]').val();
var myDropzone = new Dropzone('.imagedropzone1', {
	method: "post",
	url: "/dashboard/upload/portfolio/"+userid,
	maxFilesize: 20,
	autoDiscover: false,
	createImageThumbnails: true,
	addRemoveLinks: false,
	autoProcessQueue: true,
	paramName: "portfolio",
	parallelUploads: 10,
	acceptedFiles: 'image/gif,image/jpeg,image/png,image/bmp',
	timeout: 600000

});

var myDropzone = new Dropzone('.imagedropzone2', {
	method: "post",
	url: "/dashboard/upload/polaroids/"+userid,
	maxFilesize: 20,
	autoDiscover: false,
	createImageThumbnails: true,
	addRemoveLinks: false,
	autoProcessQueue: true,
	paramName: "polaroids",
	parallelUploads: 10,
	acceptedFiles: 'image/gif,image/jpeg,image/png,image/bmp',
	timeout: 600000

});