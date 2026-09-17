<section id="requestdemoform">
	<div class="row">
		<div class="column">
			<h2>Do you use models for your commercial or creative work?</h2>
			<h2>Find a better way to manage your castings and bookings all-in-one place. Book a demo to find out how or simply go ahead and <a href="" class="register" data-registertype="client">register</a> to submit your details for verification.</h2>
		</div>
	</div>
	<div class="seperator" data-gap="2"></div>
	<div class="row">
		<div class="column">
			<div class="input-row">
				<label for="personname">Name</label>
				<input type="text" name="personname" placeholder="Enter your name" />
			</div>
			<div class="input-row">
				<label for="jobtitle">Job Title</label>
				<input type="text" name="jobtitle" placeholder="Enter your Job Title" />
			</div>
			<div class="input-row">
				<label for="workemail">Work Email Address</label>
				<input type="text" name="workemail" placeholder="Enter your Work Email Address" />
			</div>
			<div class="input-row">
				<label for="companyname">Email Address</label>
				<input type="text" name="companyname" placeholder="Enter your Company Name" />
			</div>
		</div>

	</div>
	<div class="row">
		<div class="column text-center">
			<a class="button inverted requestdemo" href="requestdemo">Request a Demo</a>
		</div>
	</div>
</section>
<div class="seperator" data-gap="4"></div>
{if $userid eq 0}
<script type="text/javascript">
{capture name="regmod"}{strip}{include file="shared/registermodal.tpl"}{/strip}{/capture}
var registerModal = '{$smarty.capture.regmod|escape:"javascript"}';
var trk = '{$trk}';
</script>
{/if}