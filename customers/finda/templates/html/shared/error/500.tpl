<div class="notfound"></div>
<div class="row">
	<div class="column">
		<h1>"500, server error"</h1>
		<h3>Sorry, something went wrong behind the scenes.</h3>
		<p><a href="/">Go back to the homepage</a></p>
	</div>
</div>
<div class="seperator" data-gap="3"></div>
{if $errorMessage}
<div class="row">
	<div class="column">
		<h3>Technical details</h3>
		<p>{$errorMessage}</p>
	</div>
</div>
{/if}
<div class="imagecredit">Photo by Mark Kamalov</div>