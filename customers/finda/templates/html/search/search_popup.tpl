<div id="main" class="prod mobilepanel search-popup">
	<section id="filters" style="margin-bottom: 1em;">
		<div class="toplevel-filters row">
			<div class="column narrow">
				<label for="byname">Find a Model</label><br />
				<input id="byname" type="text" name="byname input"/>
			</div>
			<div class="column narrow">
				<label for="location">Location</label>
				<div class="select-wrap"> 
					<select id="modellocation" name="modellocation input" class="select">
						<option value="0">Any</option>
						{foreach from=$user_locations item=user_location name=locations}
						<option value="{$user_location.tid}">{$user_location.name}</option>
						{/foreach}
					</select>
				</div>
			</div>
			
			<div class="column slider narrow" style="margin-left: 2em; margin-right: 2em;">
				<p>Social following</p>
				<div class="row slider">
					<input type="text" id="instafollowers" readonly style="display: none">
					<div class="slidercol">
						<div id="instafollowers-slider-range"></div>
					</div>
				</div>
			</div>
			<div class="column narrow favouritesonly">
				<input class="search-favs" id="favouritesonly" type="checkbox" name="favouritesonly input"/>
				<label for="favouritesonly" class="tab tab-right" style="font-size: 1em !important;">favourites only</label>
			</div>
				
			<div class="column text-right">
				<a class="filter-toggle">Filters</a>
			</div>
		</div>
		<div class="row" style="margin-right: 8em;">
			<div class="column text-center">
				<div class="quickfilters">
					{foreach from=$categories item=category name=category}
					<div class="pretty pretty-boxed p-default p-fill">
						<input type="checkbox" name="categories" value="{$category.tid}" id="category-{$category.tid}">
						<div class="state">
							<label for="category-{$category.tid}">{$category.name}</label>
						</div>
					</div>
					{/foreach}
				</div>
			</div>
		</div>
		<div class="row">
			<div class="column text-center">
				<p style="margin-bottom: 0.25em;"><span class="modelresultscount">100+ models found</span></p>
			</div>
		</div>
		<div class="filterholder desktop" style="margin-right: 130px;">
			<section class="worko-tabs search">
				<input class="tabstate" type="radio" title="Basic filters" name="tabs-state" id="tab-mustbe" checked />
				<input class="tabstate" type="radio" title="Advanced filters" name="tabs-state" id="tab-canhave" />
			
				<div class="tabs flex-tabs">
					<div class="tab-holder">
						<div class="half-tab">
							<label for="tab-mustbe" id="tab-mustbe-label" class="tab text-center">Basic</label>
						</div>
						<div class="half-tab second">
							<label for="tab-canhave" id="tab-canhave-label" class="tab text-center">Advanced</label>
						</div>
					</div>
						
					<div class="panel active search" id="tab-mustbe-panel">
	
						<div class="row filterrow">
						
							<div class="column filtercolumn narrow" style="margin-right: 2em;">
								<h4>Womenswear sizes (<span class="dresssizeslabel">All</span>)</h4>
								{for $i=$smartyparams.dresssizes.0 to $smartyparams.dresssizes.1}
								<div class="pretty pretty-boxed p-default p-fill">
									<input type="checkbox" name="dresssize" value="{$i}" id="dresssize-{$i}">
									<div class="state">
										<i>{$i}</i> <label for="dresssize-{$i}"></label>
									</div>
								</div>
								{/for}
							</div>
							<div class="column filtercolumn narrow" style="margin-right: 2em;">
								<h4>Menswear sizes (<span class="suitsizeslabel">All</span>)</h4>
								{for $i=$smartyparams.suitsizes.0 to $smartyparams.suitsizes.1 step 2}
								<div class="pretty pretty-boxed p-default p-fill">
									<input type="checkbox" name="suitsize" value="{$i}" id="suitsize-{$i}">
									<div class="state">
										<i>{$i}</i> <label for="suitsize-{$i}"></label>
									</div>
								</div>
								{/for}
							</div>
							
							<div class="column filtercolumn normal" style="margin-right: 2em;">
								<div class="row slider">
									<h4>Height</h4>
									<input type="text" id="heightrange" readonly style="display: none;">
									<div class="slidercol heightrange">
										<div id="height-slider-range"></div>
									</div>
								</div>
	
								<div class="row slider">
									<h4>Shoe Size</h4>
									<input type="text" id="shoesize" readonly style="display: none;">
									<div class="slidercol">
										<div id="shoesize-slider-range"></div>
									</div>
								</div>
								
								<div class="row slider">
									<h4>Bust/Chest</h4>
									<input type="text" id="bustsize" readonly style="display: none;">
									<div class="slidercol heightrange">
										<div id="bustsize-slider-range"></div>
									</div>
								</div>
	
							</div>
							
							<div class="column filtercolumn normal">
								<h4>Model Is Available</h4>
								<div class="pretty p-icon p-default">
									<input type="checkbox" name="lastminute" value="-1" id="lastminute-anytime" checked="checked">
									<div class="state">
										<i class="icon fa fa-check"></i> <label for="lastminute-anytime">Any time</label>
									</div>
								</div>
								<h4 style="padding-top: 0.5em; padding-bottom: 0;">Or on all of these days</h4>
								<div class="pretty p-icon p-default">
									<input type="checkbox" name="lastminute" value="0" id="lastminute-tomorrow">
									<div class="state">
										<i class="icon fa fa-check"></i> <label for="lastminute-one">Tomorrow</label>
									</div>
								</div>
								<div class="pretty p-icon p-default">
									<input type="checkbox" name="lastminute" value="1" id="lastminute-dayafter">
									<div class="state">
										<i class="icon fa fa-check"></i> <label for="lastminute-two">Day After</label>
									</div>
								</div>
								<div class="pretty p-icon p-default">
									<input type="checkbox" name="lastminute" value="2" id="lastminute-threedays">
									<div class="state">
										<i class="icon fa fa-check"></i> <label for="lastminute-three">In three days</label>
									</div>
								</div>
								<div class="pretty p-icon p-default">
									<input type="checkbox" name="lastminute" value="3" id="lastminute-fourdays">
									<div class="state">
										<i class="icon fa fa-check"></i> <label for="lastminute-four">In four days</label>
									</div>
								</div>
								<div class="pretty p-icon p-default">
									<input type="checkbox" name="lastminute" value="4" id="lastminute-fivedays">
									<div class="state">
										<i class="icon fa fa-check"></i> <label for="lastminute-five">In five days</label>
									</div>
								</div>
								<div class="pretty p-icon p-default">
									<input type="checkbox" name="lastminute" value="5" id="lastminute-sixdays">
									<div class="state">
										<i class="icon fa fa-check"></i> <label for="lastminute-five">In six days</label>
									</div>
								</div>
							</div>
						
						</div>
					</div>
					
					{* **************** *}
					{* advanced filters *}
					{* **************** *}
					
					<div class="panel search" id="tab-canhave-panel">
					
						<div class="row filterrow">
					
							<div class="column filtercolumn narrow">
							
								<h4>Collar Size (<span class="collarsizeslabel">All</span>)</h4>
								{for $i=$smartyparams.collarsizes.0 to $smartyparams.collarsizes.1}
								<div class="pretty pretty-boxed p-default p-fill">
									<input type="checkbox" name="collarsize" value="{$i}" id="collarsize-{$i}">
									<div class="state">
										<i>{$i}</i> <label for="collarsize-{$i}"></label>
									</div>
								</div>
								{/for}
							</div>
							
							<div class="column filtercolumn narrow" style="margin-right: 2em;">
								<div class="row slider">
									<h4>Waist</h4>
									<input type="text" id="waistsize" readonly style="display: none;">
									<div class="slidercol heightrange">
										<div id="waistsize-slider-range"></div>
									</div>
								</div>
				
								<div class="row slider">
									<h4>Hips</h4>
									<input type="text" id="hipsize" readonly style="display: none;">
									<div class="slidercol heightrange">
										<div id="hipsize-slider-range"></div>
									</div>
								</div>
								
							</div>
							
							<div class="column filtercolumn narrow" style="margin-right: 1em;">
								<h4>Ring Size</h4>
								{foreach item=i from='J'|@range:'Z'}
								<div class="pretty pretty-boxed p-default p-fill">
									<input type="checkbox" name="ringsize" value="{$i}" id="ringsize-{$i}">
									<div class="state">
										<i>{$i}</i> <label for="ringsize-{$i}"></label>
									</div>
								</div>
								{/foreach}
							</div>
							
							<div class="column filtercolumn narrow">
								<h4>Hair Type</h4>
								<div class="pretty p-icon p-default">
									<input type="radio" name="hairtype" value="0" id="hairtype-0" checked="checked">
									<div class="state">
										<i class="icon fa fa-check"></i> <label for="hairtype-0">Any</label>
									</div>
								</div>
								{foreach from=$hairtypes item=hairtype name=hairtype}
								<div class="pretty p-icon p-default">
									<input type="radio" name="hairtype" value="{$hairtype.tid}" id="hairtype-{$hairlength.tid}">
									<div class="state">
										<i class="icon fa fa-check"></i> <label for="hairtype-{$hairtype.tid}">{$hairtype.name}</label>
									</div>
								</div>
								{/foreach}
								
								<h4 style="margin-top: 2em;">Hair Colour</h4>
								<div class="pretty p-icon p-default">
									<input type="radio" name="haircolour" value="0" id="haircolour-0" checked="checked">
									<div class="state">
										<i class="icon fa fa-check"></i> <label for="haircolour-0">Any</label>
									</div>
								</div>
								{foreach from=$haircolours item=haircolour name=haircolour}
								<div class="pretty p-icon p-default">
									<input type="radio" name="haircolour" value="{$haircolour.tid}" id="haircolour-{$haircolour.tid}">
									<div class="state">
										<i class="icon fa fa-check"></i> <label for="haircolour-{$haircolour.tid}">{$haircolour.name}</label>
									</div>
								</div>
								{/foreach}
								
							</div>
		
							<div class="column filtercolumn narrow">
								<h4>Hair Length</h4>
								<div class="pretty p-icon p-default">
									<input type="radio" name="hairlength" value="0" id="hairlength-0" checked="checked">
									<div class="state">
										<i class="icon fa fa-check"></i> <label for="hairlength-0">Any</label>
									</div>
								</div>
								{foreach from=$hairlengths item=hairlength name=hairlength}
								<div class="pretty p-icon p-default">
									<input type="radio" name="hairlength" value="{$hairlength.tid}" id="hairlength-{$hairlength.tid}">
									<div class="state">
										<i class="icon fa fa-check"></i> <label for="hairlength-{$hairlength.tid}">{$hairlength.name}</label>
									</div>
								</div>
								{/foreach}
								
							</div>
							
							<div class="column filtercolumn narrow">
								<h4>Eye Colour</h4>
								<div class="pretty p-icon p-default">
									<input type="radio" name="eyecolour" value="0" id="eyecolour-0" checked="checked">
									<div class="state">
										<i class="icon fa fa-check"></i> <label for="eyecolour-0">Any</label>
									</div>
								</div>
								{foreach from=$eyecolours item=eyecolour name=eyecolour}
								<div class="pretty p-icon p-default">
									<input type="radio" name="eyecolour" value="{$eyecolour.tid}" id="eyecolour-{$eyecolour.tid}">
									<div class="state">
										<i class="icon fa fa-check"></i> <label for="eyecolour-{$eyecolour.tid}">{$eyecolour.name}</label>
									</div>
								</div>
								{/foreach}
							</div>
							
							<div class="column filtercolumn narrow">
								{*
								<h4>Skin Tone</h4>
								<div class="pretty p-icon p-default">
									<input type="checkbox" name="skintone" value="-1" id="skintone-0" checked="checked">
									<div class="state">
										<i class="icon fa fa-check"></i> <label for="skintone-0">Any</label>
									</div>
								</div>
								{foreach from=$skintones item=skintone name=skintone}
								<div class="pretty p-icon p-default">
									<input type="checkbox" name="skintone" value="{$skintone.tid}" id="skintone-{$skintone.tid}">
									<div class="state">
										<i class="icon fa fa-check"></i> <label for="skintone-{$skintone.tid}">{$skintone.name}</label>
									</div>
								</div>
								{/foreach}
								*}
								
								<h4{* style="margin-top: 2em;" *}>Other</h4>
								<div class="pretty p-default p-fill">
									<input type="checkbox" name="willingtodye input" value="0" id="willingtodye" {if $model.willingtodye eq 1} checked="checked" {/if}>
									<div class="state">
										<label for="willingtodye">Willing to dye?</label>
									</div>
								</div>
								
								<div class="pretty p-default p-fill">
									<input type="checkbox" name="willingtocut input" value="0" id="willingtocut" {if $model.willingtocut eq 1} checked="checked" {/if}>
									<div class="state">
										<label for="willingtocut">Willing to cut?</label>
									</div>
								</div>
								
								<div class="pretty p-default p-fill">
									<input type="checkbox" name="	inglicense input" value="0" id="drivinglicense" {if $model.drivinglicense eq 1} checked="checked" {/if}>
									<div class="state">
										<label for="drivinglicense">Driving License?</label>
									</div>
								</div>
	
								<div class="pretty p-default p-fill">
									<input type="checkbox" name="tattoo input" value="0" id="tattoo" {if $model.tattoo eq 1} checked="checked" {/if}>
									<div class="state">
										<label for="tattoo">Tattoos?</label>
									</div>
								</div>
								
							</div>
							
						</div>
					</div>
					
					<div class="row">
						<div class="column text-center">
							<a class="clearfilters filter button" style="margin-bottom: 2em; margin-top: 2em;">Clear filters</a>
						</div>
					</div>
				</div>
			</section>
				
		</div>
		{* drop-down sorting *}
		<div style="float: right; display: inline; font-size: 80%; margin-right: 12em;">
			Sort by:
			
			<div class="pretty p-default p-fill">
				<input type="radio" name="sortorder" id="searchall" value="all"{if $searchsettings.sortorder eq 'all' || $sortorder eq ''} checked="checked"{/if}>
				<div class="state">
					<label for="searchall">All</label>
				</div>
			</div>
			<div class="pretty p-default p-fill">
				<input type="radio" name="sortorder" id="newest" value="recent"{if $searchsettings.sortorder eq 'recent'} checked="checked"{/if}>
				<div class="state">
					<label for="newest">Newest</label>
				</div>
			</div>
			<div class="pretty p-default p-fill">
				<input type="radio" name="sortorder" id="atoz" value="nameatoz"{if $searchsettings.sortorder eq 'nameatoz'} checked="checked"{/if}>
				<div class="state">
					<label for="atoz">Name, A to Z</label>
				</div>
			</div>
			<div class="pretty p-default p-fill">
				<input type="radio" name="sortorder" name="ztoa" value="nameztoa"{if $searchsettings.sortorder eq 'nameztoa'} checked="checked"{/if}>
				<div class="state">
					<label for="ztoa">Name, Z to A</label>
				</div>
			</div>
		</div>
	</section>
	<div class="grid-main search">
		<div class="results">
			<div class="results-column popup">
			
				{if $jobcount eq 0}
				<div class="row desktop">
					<div class="column">
						<p>To book iDAL models you need to <a href="/projects/create">create a project</a>.</p>
					</div>
				</div>
				{/if}
				<div class="row mobile">
					<div class="column">
						<p class="notice">Please use your desktop or laptop to enjoy all our features. The iDAL app is coming soon!</p>
					</div>
				</div>
				{* model results *}
				<div class="row">
					<div class="column text-center">
						<p class="note">Showing only available models for your project date(s)</p>
					</div>
				</div>
				<div class="search-results popup">
					{include file="search/results.tpl"}
				</div>
			</div>
			{*
			<div class="row">
				<div class="column text-center">
					<a class="button burgundy loadmore" href="">Load more</a>
				</div>
			</div>
			*}
			{* filters *}
			<div class="count-column">
				<div class="popup-notice" style="position: fixed; right: 15px; top: 8em; width: 120px; border: 1px solid #000; padding: 5px; border-radius: 5px">
					Please Note: No Models are notified at this stage. This is only for shortlisting purposes
				</div>
				<div class="count">
					<div class="number">01</div>
					<div class="text-burgundy">SELECTED</div>
					<div class="button fullwidth shrink small burgundy btn-close" style="margin: 0.5em 0;">SAVE</div>
				</div>
			</div>
		</div>
	</div>
</div>
<input type="hidden" name="pagerstart" value="0">
<input type="hidden" name="pagerend" value="100">
<input type="hidden" name="modelcount" value="{$modelcount}">
<script type="text/javascript">
{* search parameters *}
	var params = {$parameters};
	var lastsearchsettings = {$searchsettings};
	var searchnames = {$searchnames};
</script>