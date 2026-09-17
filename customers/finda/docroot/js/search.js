/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
var boardtype = "all";
var selectedtime = -1;
var selectedlocation = "anywhere";

// the various sliders
$(function() {
	
	$('.loadmore').hide();
	
	$("#height-slider-range").slider({
		range: true,
		min: parseInt(params.height[0]),
		max: parseInt(params.height[1]),
		values: [parseInt(params.height[0]), parseInt(params.height[1])],
		slide: function(event, ui) {
			$("#height-slider-range .ui-slider-handle:nth-of-type(1)").attr('data-val', ui.values[0] + "cm\n" + centimetersToFeet(ui.values[0]));
			$("#height-slider-range .ui-slider-handle:nth-of-type(2)").attr('data-val', ui.values[1] + "cm\n" + centimetersToFeet(ui.values[1]));
			$('#height-slider-range').attr('data-min', centimetersToFeet(params.height[0]));
			$('#height-slider-range').attr('data-max', centimetersToFeet(params.height[1]));
		},
		stop: function(event, ui) {
			doSearch(true);
		} 
	});
	
	$('#height-slider-range').attr('data-min', centimetersToFeet(params.height[0]));
	$('#height-slider-range').attr('data-max', centimetersToFeet(params.height[1]));
	$("#height-slider-range .ui-slider-handle:nth-of-type(1)").attr('data-val', $("#height-slider-range").slider("values", 0) + "cm\n" + centimetersToFeet($("#height-slider-range").slider("values", 0)) );
	$("#height-slider-range .ui-slider-handle:nth-of-type(2)").attr('data-val', $("#height-slider-range").slider("values", 1) + "cm\n" + centimetersToFeet($("#height-slider-range").slider("values", 1)) );

	$("#bustsize-slider-range").slider({
		range: true,
		min: parseInt(params.bustsize[0]),
		max: parseInt(params.bustsize[1]),
		values: [parseInt(params.bustsize[0]), parseInt(params.bustsize[1])],
		create: function(event, ui) {
			$('#bustsize-slider-range').attr('data-min', centimetersToInches(params.height[0]) + '"');
			$('#bustsize-slider-range').attr('data-max', centimetersToInches(params.height[1]) + '"');
		},
		slide: function(event, ui) {
			$("#bustsize-slider-range .ui-slider-handle:nth-of-type(1)").attr('data-val', ui.values[0] + "cm\n" + centimetersToInches(ui.values[0]) + '"');
			$("#bustsize-slider-range .ui-slider-handle:nth-of-type(2)").attr('data-val', ui.values[1] + "cm\n" + centimetersToInches(ui.values[1]) + '""');
			$('#bustsize-slider-range').attr('data-min', centimetersToInches(params.bustsize[0]) + '"');
			$('#bustsize-slider-range').attr('data-max', centimetersToInches(params.bustsize[1]) + '"');

		},
		stop: function(event, ui) {
			doSearch(true);
		}
	});
	$('#bustsize-slider-range').attr('data-min', centimetersToInches(params.bustsize[0]) + '"');
	$('#bustsize-slider-range').attr('data-max', centimetersToInches(params.bustsize[1]) + '"');
	$("#bustsize-slider-range .ui-slider-handle:nth-of-type(1)").attr('data-val', $("#bustsize-slider-range").slider("values", 0) + "cm\n" + centimetersToFeet($("#bustsize-slider-range").slider("values", 0)) + '"');
	$("#bustsize-slider-range .ui-slider-handle:nth-of-type(2)").attr('data-val', $("#bustsize-slider-range").slider("values", 1) + "cm\n" + centimetersToFeet($("#buastsize-slider-range").slider("values", 1)) + '"');

	$("#waistsize-slider-range").slider({
		range: true,
		min: parseInt(params.waistsize[0]),
		max: parseInt(params.waistsize[1]),
		values: [parseInt(params.waistsize[0]), parseInt(params.waistsize[1])],
		create: function(event, ui) {
			$('#waistsize-slider-range').attr('data-min', centimetersToInches(params.waistsize[0]) + '"');
			$('#waistsize-slider-range').attr('data-max', centimetersToInches(params.waistsize[1]) + '"');
		},
		slide: function(event, ui) {
			$("#waistsize-slider-range .ui-slider-handle:nth-of-type(1)").attr('data-val', ui.values[0] + "cm\n" + centimetersToInches(ui.values[0]) + '"');
			$("#waistsize-slider-range .ui-slider-handle:nth-of-type(2)").attr('data-val', ui.values[1] + "cm\n" + centimetersToInches(ui.values[1]) + '"');
			$('#waistsize-slider-range').attr('data-min', centimetersToInches(params.waistsize[0]) + '"');
			$('#waistsize-slider-range').attr('data-max', centimetersToInches(params.waistsize[1]) + '"');
		},
		stop: function(event, ui) {
			doSearch(true);
		}
	});
	$('#waistsize-slider-range').attr('data-min', centimetersToInches(params.waistsize[0]) + '"');
	$('#waistsize-slider-range').attr('data-max', centimetersToInches(params.waistsize[1]) + '"');
	$("#waistsize-slider-range .ui-slider-handle:nth-of-type(1)").attr('data-val', $("#waistsize-slider-range").slider("values", 0) + "cm\n" + centimetersToInches($("#waistsize-slider-range").slider("values", 0)) + '"');
	$("#waistsize-slider-range .ui-slider-handle:nth-of-type(2)").attr('data-val', $("#waistsize-slider-range").slider("values", 1) + "cm\n" + centimetersToInches($("#waistsize-slider-range").slider("values", 1)) + '"');

	$("#hipsize-slider-range").slider({
		range: true,
		min: parseInt(params.hipsize[0]),
		max: parseInt(params.hipsize[1]),
		values: [parseInt(params.hipsize[0]), parseInt(params.hipsize[1])],
		create: function(event, ui) {
			$('#hipsize-slider-range').attr('data-min', centimetersToInches(params.hipsize[0]) + '"');
			$('#hipsize-slider-range').attr('data-max', centimetersToInches(params.hipsize[1]) + '"');
		},
		slide: function(event, ui) {
			$("#hipsize-slider-range .ui-slider-handle:nth-of-type(1)").attr('data-val', ui.values[0] + "cm\n" + centimetersToInches(ui.values[0]) + '""');
			$("#hipsize-slider-range .ui-slider-handle:nth-of-type(2)").attr('data-val', ui.values[1] + "cm\n" + centimetersToInches(ui.values[0]) + '"');
			$('#hipsize-slider-range').attr('data-min', centimetersToInches(params.hipsize[0]) + '"');
			$('#hipsize-slider-range').attr('data-max', centimetersToInches(params.hipsize[1]) + '"');
			
		},
		stop: function(event, ui) {
			doSearch(true);
		}
	});
	$('#hipsize-slider-range').attr('data-min', centimetersToInches(params.hipsize[0]) + '"');
	$('#hipsize-slider-range').attr('data-max', centimetersToInches(params.hipsize[1]) + '"');
	$("#hipsize-slider-range .ui-slider-handle:nth-of-type(1)").attr('data-val', $("#hipsize-slider-range").slider("values", 0) + "cm\n" + centimetersToInches($("#hipsize-slider-range").slider("values", 0)) + '"');
	$("#hipsize-slider-range .ui-slider-handle:nth-of-type(2)").attr('data-val', $("#hipsize-slider-range").slider("values", 1) + "cm\n" + centimetersToInches($("#hipsize-slider-range").slider("values", 1)) + '"');

	$("#shoesize-slider-range").slider({
		range: true,
		min: parseInt(params.shoesize[0]),
		max: parseInt(params.shoesize[1]),
		values: [parseInt(params.shoesize[0]), parseInt(params.shoesize[1])],
		slide: function(event, ui) {
			$("#shoesize-slider-range .ui-slider-handle:nth-of-type(1)").attr('data-val', ui.values[0]);
			$("#shoesize-slider-range .ui-slider-handle:nth-of-type(2)").attr('data-val', ui.values[1]);
		},
		stop: function(event, ui) {
			doSearch(true);
		}
	});
	$("#shoesize-slider-range").attr('data-min', parseInt(params.shoesize[0]));
	$("#shoesize-slider-range").attr('data-max', parseInt(params.shoesize[1]));
	$("#shoesize-slider-range .ui-slider-handle:nth-of-type(1)").attr('data-val', $("#shoesize-slider-range").slider("values", 0));
	$("#shoesize-slider-range .ui-slider-handle:nth-of-type(2)").attr('data-val', $("#shoesize-slider-range").slider("values", 1));
	
	$("#cupsize-slider-range").slider({
		range: true,
		min: 0,
		max: params.cupsizes.length-1,
		values: [0, params.cupsizes.length-1],
		slide: function(event, ui) {
			$("#cupsize-slider-range .ui-slider-handle:nth-of-type(1)").attr('data-val', params.cupsizes[ui.values[0]]);
			$("#cupsize-slider-range .ui-slider-handle:nth-of-type(2)").attr('data-val', params.cupsizes[ui.values[1]]);
		},
		stop: function(event, ui) {
			doSearch(true);
		}
	});
	$("#cupsize-slider-range").attr('data-min', params.cupsizes[0]);
	$("#cupsize-slider-range").attr('data-max', params.cupsizes[params.cupsizes.length-1]);
	$("#cupsize-slider-range .ui-slider-handle:nth-of-type(1)").attr('data-val', params.cupsizes[0]);
	$("#cupsize-slider-range .ui-slider-handle:nth-of-type(2)").attr('data-val', params.cupsizes[params.cupsizes.length-1]);
	
	
	
	// instafollowers
	$("#instafollowers-slider-range").slider({
		range: false,
		min: 0,
		max: params.followercounts.length-1,
		value: 0, // parseInt(lastsearchsettings.cupsizes[0]),
		slide: function(event, ui) {
			$("#instafollowers-slider-range .ui-slider-handle").attr('data-val', params.followercounts[ui.value]);
		},
		stop: function(event, ui) {
			doSearch(true);
		}
	});
	$("#instafollowers-slider-range").attr('data-min', params.followercounts[0]);
	$("#instafollowers-slider-range").attr('data-max', params.followercounts[params.followercounts.length-1]);
	$("#instafollowers-slider-range .ui-slider-handle").attr('data-val', params.followercounts[0]);
	
	$('a.filter').on('click', function(e) {
		e.preventDefault();
		doSearch(true);
	});
	
	$('#modellocation').on('change', function(e) {
		doSearch(true);
	});
	
	$('#favouritesonly, #willingtocut, #willingtodye, #drivinglicense, #tattoo').on('click', function(e) {
		doSearch(true);
	});
	
	$('input[name=category], input[name=hairtype], input[name=haircolour], input[name=hairlength], input[name=eyecolour], input[name=sortorder], input[name=dresssize], input[name=suitsize], input[name=collarsize], input[name=ringsize]').on('click', function(e) {
		doSearch(true);
	});
	
	$('.filter-toggle').on('click', function(e) {
		e.preventDefault();
		if ($(this).hasClass('active')) {
			$(this).removeClass('active');
		} else {
			$(this).addClass('active');
		}

		$('.filterholder').slideToggle('fast');
	});
	
	$('.clearfilters').on('click', function(e) {
		e.preventDefault();
		clearFilters();
	});
	
	$('input[name=lastminute]').on('click', function(e) {
		selectedtime = $(this).val();
		if (selectedtime != -1) {
			$('#lastminute-anytime').prop('checked', false);
		} else {
			$('input[name=lastminute]').each(function(e) {
				$(this).prop('checked', false);
			});
			$('#lastminute-anytime').prop('checked', true);
		}
		var allfalse = true;
		$('input[name=lastminute]').each(function(e) {
			if ($(this).val() != -1 && $(this).prop('checked') == true) {
				allfalse = false;
			}
		});
		if (allfalse && selectedtime != -1) {
			$('#lastminute-anytime').prop('checked', true);
		}
		doSearch(true);
	});
	
	$('input[name=categories]').on('click', function(e) {
		selectedcategories = $(this).val();
		if (selectedcategories != -1) {
			$('#category-any').prop('checked', false);
		} else {
			$('input[name=categories]').each(function(e) {
				$(this).prop('checked', false);
			});
			$('#category-any').prop('checked', true);
		}
		var allfalse = true;
		$('input[name=categories]').each(function(e) {
			if ($(this).val() != 'any' && $(this).prop('checked') == true) {
				allfalse = false;
			}
		});
		if (allfalse && selectedcategories != -1) {
			$('#category-any').prop('checked', true);
		}
		doSearch(true);
	});
	
	$('input[name=skintone]').on('click', function(e) {
		selectedskintones = $(this).val();
		if (selectedskintones != -1) {
			$('#skintone-0').prop('checked', false);
		} else {
			$('input[name=skintone]').each(function(e) {
				$(this).prop('checked', false);
			});
			$('#skintone-0').prop('checked', true);
		}
		var allfalse = true;
		$('input[name=skintone]').each(function(e) {
			if ($(this).val() != -1 && $(this).prop('checked') == true) {
				allfalse = false;
			}
		});
		if (allfalse && selectedskintones != -1) {
			$('#skintone-0').prop('checked', true);
		}
		doSearch(true);
	});

});

function doSearch(reset = false) {
	if (reset == true) {
		$('input[name=pagerstart]').val(0);
		$('input[name=pagerend]').val(100);
		$('.search-results').html('<div class="row"><div class="column"><div class="modelView"><div class="loadfader"><div class="reverse-spinner"></div></div></div></div><div class="column"><div class="modelView"><div class="loadfader"><div class="reverse-spinner"></div></div></div></div><div class="column"><div class="modelView"><div class="loadfader"><div class="reverse-spinner"></div></div></div></div><div class="column"><div class="modelView"><div class="loadfader"><div class="reverse-spinner"></div></div></div></div></div>');
		$('.loadmore').hide();
	}
	
	// current bug, loads all not limited
	$('.loadmore').hide();
	
	var willcolour = 'no';
	if ($('#willingtodye').is(':checked')) {
		willcolour = 'yes';
	}
	var willcut = 'no';
	if ($('#willingtocut').is(':checked')) {
		willcut = 'yes';
	}
	
	var favouritesonly = 'no';
	if ($('#favouritesonly').is(':checked')) {
		favouritesonly = 'yes';
	}
	
	var driverslicense = 'no';
	if ($('#drivinglicense').is(':checked')) {
		driverslicense = 'yes';
	}
	
	var tattoo = 'no';
	if ($('#tattoo').is(':checked')) {
		tattoo = 'yes';
	}
	var displaysizes;
	var dresssizes = [];
	$('input[name=dresssize]:checked').each(function(){
		dresssizes.push($(this).val());
	});
	if (dresssizes.length != 0) {
		displaysizes = dresssizes.join(', ');
		$('.dresssizeslabel').html(displaysizes);
	} else {
		$('.dresssizeslabel').html('All');
	}
	
	var suitsizes = [];
	$('input[name=suitsize]:checked').each(function(){
		suitsizes.push($(this).val());
	});
	if (suitsizes.length != 0) {
		displaysizes = suitsizes.join(', ');
		$('.suitsizeslabel').html(displaysizes);
	} else {
		$('.suitsizeslabel').html('All');
	}
	
	// we may need to set either Dress Sizes or Suit Sizes to 'None'
	// and override the other size
	if (dresssizes.length > 0 && suitsizes.length == 0) {
		$('.suitsizeslabel').html('-');
		suitsizes.push(-99);	// invalid size
	}
	
	if (dresssizes.length == 0 && suitsizes.length > 0) {
		$('.dresssizeslabel').html('-');
		dresssizes.push(-99);	// invalid size
	}
	
	// and just to check

	var collarsizes = [];
	$('input[name=collarsize]:checked').each(function(){
		collarsizes.push($(this).val());
	});
	if (collarsizes.length != 0) {
		displaysizes = collarsizes.join(', ');
		$('.collarsizeslabel').html(displaysizes);
	} else {
		$('.collarsizeslabel').html('All');
	}
	
	var ringsizes = [];
	$('input[name=ringsize]:checked').each(function(){
		ringsizes.push($(this).val());
	});
	if (ringsizes.length == 0) {
		var letter = '';
		for (var i = 0; i < 26; i++) {
			letter = (i).toString(36);
			$('#ringsize-'+letter).prop('checked', true);
		}
	}
	
	var selectedtimes = [];
	$('input[name=lastminute]:checked').each(function() {
		selectedtimes.push($(this).val());
	});

	var selectedskintones = [];
	$('input[name=skintone]:checked').each(function(){
		selectedskintones.push($(this).val());
	});
	
	var selectedcategories = [];
	$('input[name=categories]:checked').each(function(){
		selectedcategories.push($(this).val());
	});
	
	$.ajax({
		type: 'POST',
		url: '/search/ajax-find',
		data: {
			'height': $('#height-slider-range').slider("values"),
			'bustsize': $('#bustsize-slider-range').slider("values"),
			'waistsize': $('#waistsize-slider-range').slider("values"),
			'hipsize': $('#hipsize-slider-range').slider("values"),
			'dresssize': dresssizes,
			'suitsize': suitsizes,
			'collarsize': collarsizes,
			'shoesize': $('#shoesize-slider-range').slider("values"),
			'haircolour': $('input[name=haircolour]:checked').val(),
			'hairtype': $('input[name=hairtype]:checked').val(),
			'hairlength': $('input[name=hairlength]:checked').val(),
			'willcolour': willcolour,
			'willcut': willcut,
			'ringsize': ringsizes,
			'tattoo': tattoo,
			'driverslicense': driverslicense,
			'favouritesonly': favouritesonly,
			'eyecolour': $('input[name=eyecolour]:checked').val(),
			'instafollowers': $('#instafollowers-slider-range').slider("value"),
			'categories': selectedcategories,
			'boardtype': boardtype, 
			'sortorder': $('input[name=sortorder]:checked').val(),
			'skintones': selectedskintones,
			
			// some specific filters
			'lastminute': selectedtimes,
			'locations': $('#modellocation').val(),
			'pagerstart': $('input[name=pagerstart]').val(),
			'pagerend': $('input[name=pagerend]').val()
		},
		success: function(resultData) { 
			$('.search-results').html("");
			$('.search-results').append(resultData.html);
			$('input[name=modelcount]').val(resultData.modelcount);
			setImageLinks();
			loadImages();
			sizeConvert();
			setNameSearch();
			if (resultData.filteredcount != 100) {
				if (resultData.filteredcount == 1) {
					$('.modelresultscount').html(resultData.filteredcount + " model found");
				} else {
					$('.modelresultscount').html(resultData.filteredcount + " models found");
				}
			} else {
				$('.modelresultscount').html(resultData.modelcount + " models found");
			}
			var pagerend = parseInt($('input[name=pagerend').val());
			if (pagerend < parseInt(resultData.modelcount)) {
				$('.loadmore').show();
			}
			if (resultData.filteredcount < 100) {
				$('.loadmore').hide();
			}
		}
	});
}

function setImageLinks() {
	$('.portfolio, .polaroids').off().on('click', function(e) {
		e.preventDefault();
		var href = $(this).data('href');
		window.location.href = href;
	})
	
	$('.model-favourite').on('click', function(e) {
		e.preventDefault();
		e.stopPropagation();
		var modelid = $(this).data('id');
		var container = $(this).parent().parent().parent();
		
		if ($(this).find('i').hasClass('far')) {
			$(this).find('i').removeClass('far').addClass('fas');
			container.find('.name-leader').find('i').removeClass('far').addClass('fas');
		} else {
			$(this).find('i').removeClass('fas').addClass('far');
			container.find('.name-leader').find('i').removeClass('fas').addClass('far');
		}
		$.ajax({
			type: 'POST',
			url: '/search/toggle-favourite',
			data: {
				'modelid': modelid
			},
			success: function(resultData) {}
		})
	});
	
}

function setSliderSizes() {
	var width = $('.row.slider').width();
}

function loadImages() {
	
	var lazyloadImages;
	
	if ("IntersectionObserver" in window) {
		lazyloadImages = document.querySelectorAll(".lazy");
		var imageObserver = new IntersectionObserver(function(entries, observer) {
			entries.forEach(function(entry) {
				if (entry.isIntersecting) {
					var bgimage = new Image();
					var image = entry.target;
					console.log(image.dataset.imagesrc);
					bgimage.src = image.dataset.imagesrc;
					image.classList.remove("lazy");
					imageObserver.unobserve(image);
					
					$(bgimage).on('load', function() {
						$(image).css('background-image','url(' + image.dataset.imagesrc + ')');
						$(image).css('background-position','center');
						$(image).css('background-size','cover');
						$(image).find('.loadfader').html('');
						$(image).find('loadfader').addClass('loaded');
						$(image).find('.loadfader').css('opacity', 0);
					});
					
				}
			});
		});
		
		lazyloadImages.forEach(function(image) {
			imageObserver.observe(image);
		});
	} else {  
		var lazyloadThrottleTimeout;
		lazyloadImages = document.querySelectorAll(".lazy");
		
		function lazyload () {
			if (lazyloadThrottleTimeout) {
				clearTimeout(lazyloadThrottleTimeout);
			}
		
			lazyloadThrottleTimeout = setTimeout(function() {
				var scrollTop = window.pageYOffset;
				lazyloadImages.forEach(function(img) {
					if (img.offsetTop < (window.innerHeight + scrollTop)) {
						img.src = img.dataset.imagesrc;
						img.classList.remove('lazy');
					}
				});
				if (lazyloadImages.length == 0) { 
					document.removeEventListener("scroll", lazyload);
					window.removeEventListener("resize", lazyload);
					window.removeEventListener("orientationChange", lazyload);
				}
			}, 20);
		}
		
		document.addEventListener("scroll", lazyload);
		window.addEventListener("resize", lazyload);
		window.addEventListener("orientationChange", lazyload);
	}
	
	$.each($('.modelView .image'), function(img) {
		if (!$(this).hasClass('lazy')) {
			var that = this;
			var image = $(this).data('imagesrc');
			var bgimage = new Image();
			bgimage.src = image;
			$(bgimage).on('load', function() {
				$(that).css('background-image','url(' + image + ')');
				$(that).css('background-position','center');
				$(that).css('background-size','cover');
				$(that).find('.loadfader').html('');
				$(that).find('loadfader').addClass('loaded');
				$(that).find('.loadfader').css('opacity', 0);
			});
		}
	});
	
}

function setNameSearch() {
	awesomplete.list = searchnames;
	$('#byname').off().on('awesomplete-select', function(e, text, origin) {
		e.preventDefault();
		window.location.href='/view/'+e.originalEvent.text.value;
	});

}

function clearFilters() {
	$('#i1, #haircolour-0, #eyecolour-0, #hairtype-0, #hairlength-0').prop('checked', true);
	$('#willingtodye, #willingtocut, #drivinglicense, #tattoo').prop('checked', false);
	$('.dresssizeslabel').html('All');
	params.dresssize.forEach(function(entry) {
		$('#dresssize-'+entry).prop('checked', false);
	});
	params.suitsize.forEach(function(entry) {
		$('#suitsize-'+entry).prop('checked', false);
	});
	params.collarsize.forEach(function(entry) {
		$('#collarsize-'+entry).prop('checked', false);
	});
	
	$("#shoesize-slider-range").slider({
		values: [parseInt(params.shoesize[0]), parseInt(params.shoesize[1])]
	});
	$("#shoesize-slider-range .ui-slider-handle:nth-of-type(1)").attr('data-val', $("#shoesize-slider-range").slider("values", 0));
	$("#shoesize-slider-range .ui-slider-handle:nth-of-type(2)").attr('data-val', $("#shoesize-slider-range").slider("values", 1));


	$("#height-slider-range").slider({
		values: [parseInt(params.height[0]), parseInt(params.height[1])]
	});
	$("#height-slider-range .ui-slider-handle:nth-of-type(1)").attr('data-val', $("#height-slider-range").slider("values", 0) + "cm\n" + centimetersToFeet($("#height-slider-range").slider("values", 0)) );
	$("#height-slider-range .ui-slider-handle:nth-of-type(2)").attr('data-val', $("#height-slider-range").slider("values", 1) + "cm\n" + centimetersToFeet($("#height-slider-range").slider("values", 1)) );

	$("#bustsize-slider-range").slider({
		values: [parseInt(params.bustsize[0]), parseInt(params.bustsize[1])]
	});
	$("#bustsize-slider-range .ui-slider-handle:nth-of-type(1)").attr('data-val', $("#bustsize-slider-range").slider("values", 0));
	$("#bustsize-slider-range .ui-slider-handle:nth-of-type(2)").attr('data-val', $("#bustsize-slider-range").slider("values", 1));

	
	$("#waistsize-slider-range").slider({
		values: [parseInt(params.waistsize[0]), parseInt(params.waistsize[1])]
	});
	$("#waistsize-slider-range .ui-slider-handle:nth-of-type(1)").attr('data-val', $("#waistsize-slider-range").slider("values", 0));
	$("#waistsize-slider-range .ui-slider-handle:nth-of-type(2)").attr('data-val', $("#waistsize-slider-range").slider("values", 1));
	
	$("#hipsize-slider-range").slider({
		values: [parseInt(params.hipsize[0]), parseInt(params.hipsize[1])]
	});
	$("#hipsize-slider-range .ui-slider-handle:nth-of-type(1)").attr('data-val', $("#hipsize-slider-range").slider("values", 0));
	$("#hipsize-slider-range .ui-slider-handle:nth-of-type(2)").attr('data-val', $("#hipsize-slider-range").slider("values", 1));
	
	$('input[name=ringsize]').each(function(e) {
		$(this).prop('checked', false);
	});
	
	$("#instafollowers-slider-range").slider({
		value: 0
	});
	$("#instafollowers-slider-range .ui-slider-handle").attr('data-val', params.followercounts[0]);
	
	$("#cupsize-slider-range").slider({
		values: [0, params.cupsizes.length-1]
	});
	$("#cupsize-slider-range .ui-slider-handle:nth-of-type(1)").attr('data-val', params.cupsizes[0]);
	$("#cupsize-slider-range .ui-slider-handle:nth-of-type(2)").attr('data-val', params.cupsizes[params.cupsizes.length-1]);
	
	$('input[name=lastminute]').each(function(e) {
		$(this).prop('checked', false);
	});
	$('#lastminute-anytime').prop('checked', true);
	
	$('input[name=categories]').each(function(e) {
		$(this).prop('checked', false);
	});
	$('#category-any').prop('checked', true);
	
	$('#modellocation').val(0);
	
	$('input[name=skintone]').each(function(e) {
		$(this).prop('checked', false);
	});
	$('#skintone-0').prop('checked', true);
	
	$('input[name=pagerstart]').val(0);
	$('input[name=pagerend]').val(100);
	
	lastsearchsettings = params;
	doSearch();
}

function loadMore() {
	// update the pagerstart/end
	var pagerstart = parseInt($('input[name=pagerstart]').val());
	pagerstart = pagerstart + 100;
	var pagerend = pagerstart + 100;
	$('input[name=pagerstart]').val(pagerstart);
	$('input[name=pagerend]').val(pagerend);
	if (pagerstart < parseInt($('input[name=modelcount]').val())) {
		doSearch();
	} else {
		$('.loadmore').hide();
	}
}

function getOffset(el) {
	const rect = el.getBoundingClientRect();
	return {
		left: rect.left + window.scrollX,
		top: rect.top + window.scrollY
	};
}

function shrinkQuickFilters() {
	var buttonHtml = '<div class="pretty pretty-boxed p-default p-fill showmore"><div class="state"><label>Show more</label></div></div>';
	const filters = document.querySelectorAll('.quickfilters > div');
	var top = 0;
	var shrinkindex = 0;
	var hideall = false;
	for(const [index, item] of filters.entries()) {
		var y = getOffset(item).top;
		if (top == 0) {
			top = y
		} else {
			if (y > top || hideall) { // } && shrinkindex == 0) {
				hideall = true;
				if (shrinkindex == 0) {
					shrinkindex = index - 2;
					$(filters[shrinkindex]).css('display','none');
					$(filters[shrinkindex+1]).css('display','none');
					$(filters[shrinkindex]).parent().append(buttonHtml);
					$(filters[shrinkindex]).parent().find('.showmore').on('click', function(){
						$(this).hide();
						for(const item of filters.entries()) {
							$(item).show();
						}
					});
					
				}
				// insert here, and hide the rest
				$(item).hide();
			}
		}
	}
}

var awesomplete;
var awesompleteinput;

$(document).ready(function() {
	setImageLinks();
	setSliderSizes();
	loadImages();
	awesompleteinput = document.getElementById("byname");
	awesomplete = new Awesomplete(awesompleteinput);
	setNameSearch();
	
	shrinkQuickFilters();
	
	$('.toggle_more').on('click', function(e) {
		e.preventDefault();
		$('.unbiased_more').toggle();
		if ($('.unbiased_more').is(':visible')) {
			$('.toggle_more').html('View less');
			$('.fade_down').removeClass('faded');
		} else {
			$('.toggle_more').html('View more');
			$('.fade_down').addClass('faded');
		}
	});
	
	$('.close_toggle_more').on('click', function(e) {
		e.preventDefault();
		$('.unbiased_more').toggle();
		$('.toggle_more').show();
	});
	
	$('.loadmore').on('click', function(e) {
		e.preventDefault();
		loadMore();
	});
	
});