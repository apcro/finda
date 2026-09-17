<section id="howitworks_lead">
	<div class="content">
		<h1>How it Works</h1>
		<h3>Efficiently <span class="text-burgundy">browse and book</span> models you need using the iDAL platform.</h3>
	</div>
</section>

<section id="howitworks_section1">
	<div class="half">
		<div class="content">
			<h2>1. Create and View</h2>
			<p>Create a <strong>Casting</strong> or <strong>Booking</strong> by entering your project details (such as project name, type, usage, proposed rate, date) along with any additional information in the description. When ready, iDAL will automatically generate a board of <strong>available models</strong>.</p>
		</div>
	</div>
	<div class="half image">
	</div>
</section>

<section id="howitworks_section2">
	<div class="half image">
	</div>
	<div class="half">
		<div class="content">
			<h2>2. Browse and Select</h2>
			<p>Find exactly what you’re looking for with our detailed <strong>search filters</strong> and innovative, <strong><a href="/unbiasedsearch">Unbiased Search</a></strong> system. Shortlist your favourites, share your selection with your team online or request to book. <strong>Direct message</strong> the requested model(s) in the built- in chat.</p>
			<p>Short on time? The <strong>Last-Minute Booking</strong> feature displays models’ availability for the next six days.</p>
			</div>
	</div>
</section>

<section id="howitworks_section3">
	<div class="half">
		<div class="content">
			<h2>3. Confirm and Pay</h2>
			<p>When the requested model(s) have accepted your offer and rate, <strong>Confirm</strong> the project which signs the <strong>contract</strong> with your usage rights outlined, and settle your <strong>invoice</strong> through our safe and flexible payment system.</p>
			<p style="margin-top: 2em;"><strong>All Done!</strong></p>
		</div>
	</div>
	<div class="half image">
	</div>
</section>

<section id="howitworks_section4">
	<div class="row">
		<div class="column text-center desktop" style="margin-top: 4em; margin-bottom: 10em;"><a href="" class="button burgundy register" data-registertype="client">JOIN IDAL</a></div>
		<div class="column text-center mobile" style="margin-top: 4em; margin-bottom: 10em;"><a href="/m/register" class="button burgundy" data-registertype="client">JOIN IDAL</a></div>
	</div>
</section>
{if $userid eq 0}
<script type="text/javascript">
{capture name="regmod"}{strip}{include file="shared/registermodal.tpl"}{/strip}{/capture}
var registerModal = '{$smarty.capture.regmod|escape:"javascript"}';
var trk = '{$trk}';
</script>
{/if}
