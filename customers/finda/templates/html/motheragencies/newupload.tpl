{extends "motheragencies/layout_dashboard.tpl"}

{block name="main"}
<div class="row">
	<div class="column text-left">
		<a href="/dashboard/manage/{$model.id}">&laquo; back to {$model.firstname|trim}'s profile</a>
	</div>
</div>
<div class="row">
	<div class="column">
		<h1 style="transform-origin: left top; margin-bottom: 1em;">Upload New Images for {$model.firstname|trim} {$model.lastname}</h1>
	</div>
</div>
<div class="row">
	<div class="column">
		<p  class="text-bold" style="margin-top: 2em; margin-bottom: 2em;">To upload new images for {$model.firstname|trim}, drag and drop images into one of the boxes below. Uploaded images will be automatically rotated if necessary.</p>
	</div>
</div>
<div class="row" style="margin-bottom: 0;">
	<div class="column uploadbutton text-center">
		<p>NB: File formats should be jpg, gif or png. File size up to 20Mb.</p>
	</div>
</div>
<div class="row" style="margin-top: 0;">
	<div class="column imageupload">
		<h3>Portfolio Images</h3>
		<div id="wrapper dropzone dz-clickable">
			<form action="/user/portfolio/upload" class="imagedropzone imagedropzone1" id="imagedropzone">
			<div class="dz-message needsclick"><span style="font-size: 4em; font-weight: 300;">+</span><br />Drop files here or click to upload.</div>
				<div class="fallback">
					<input class="button" name="file" type="file" multiple />
				</div>
			</form>
		</div>
	</div>
	<div class="column imageupload">
		<h3>Polaroids</h3>
		<div id="wrapper dropzone dz-clickable">
			<form action="/user/portfolio/upload" class="imagedropzone imagedropzone2" id="imagedropzone">
			<div class="dz-message needsclick"><span style="font-size: 4em; font-weight: 300;">+</span><br />Drop files here or click to upload.</div>
				<div class="fallback">
					<input class="button" name="file" type="file" multiple />
				</div>
			</form>
		</div>
	</div>
</div>
<input type="hidden" name="modelid" value="{$modelid}" />
{/block}