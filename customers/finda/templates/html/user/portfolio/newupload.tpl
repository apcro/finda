{extends "user/portfolio/portfolio_layout.tpl"}

{block name="main"}
<div class="row">
	<div class="column">
		<h1 style="transform-origin: left top; margin-bottom: 1em;">Upload New Portfolio Images</h1>
	</div>
</div>
<div class="row">
	<div class="column">
		<p>To make sure your portfolio is presented in the best way possible, these are our guidelines:</p>
		<ul>
			<li>High resolution</li>
			<li>Photos not more than 5 years old</li>
			<li>Professional images (No social media lifestyle images)</li>
			<li>No catwalk images</li>
			<li>Don’t dilute your portfolio with photos that are less good (5 great photos is better than 10 average ones)</li>
		</ul>
		<p>Note: Our team members are always looking over portfolios and making sure that it is put together in the best possible way. Please be aware that photos might be hidden in this process. Please send us a note on <a href="mailto:support@idal.co">support@idal.co</a> if you don’t wish this management.</p>
	</div>
</div>
<div class="row">
	<div class="column">
		<p  class="text-bold" style="margin-top: 2em; margin-bottom: 2em;">To upload new images, drag and drop images into the box below. Uploaded images will be automatically rotated if necessary.</p>
	</div>
</div>
<div class="row" style="margin-bottom: 0;">
	<div class="column uploadbutton text-center">
		<p>NB: File formats should be jpg, gif or png. File size up to 20Mb.</p>
	</div>
</div>
<div class="row" style="margin-top: 0;">
	<div class="column uploadimage">
		<div id="wrapper dropzone dz-clickable">
			<form action="/user/portfolio/upload" class="imagedropzone" id="imagedropzone">
			<div class="dz-message needsclick"><span style="font-size: 4em; font-weight: 300;">+</span><br />Drop files here or click to upload.</div>
				<div class="fallback">
					<input class="button" name="file" type="file" multiple />
				</div>
			</form>
		</div>
	</div>
</div>
<div class="row">
	<div class="column text-center">
		<p style="margin-top: 2em; margin-bottom: 2em;"><a class="button burgundy" href="/user/portfolio">View all portfolio images</a></p>
	</div>
</div>
{/block}