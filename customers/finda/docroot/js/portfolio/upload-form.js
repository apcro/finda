/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
var myDropzone = new Dropzone('.imagedropzone', {
	method: "post",
	url: "/user/portfolio/upload",
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
