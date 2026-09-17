<section id="howitworks_lead">
	<div class="content text-center">
		<h1>Unbiased Search</h1>
		<h3>We aim to lead the message of diversity and inclusivity<br />in the modelling industry.</h3>
	</div>
</section>

<section id="unbiased_section1">
	<div class="half">
		<div class="content">
			<p>Meet the new <strong>Unbiased Search</strong>; an anti-category search system that will make it easier for you to discover diverse talent, allowing you to shape all-embracing and considered choices.</p>
			<p>On our talent board you will continue to use your set project specifications like size and essential physical features to match your brief. All models that match your criteria will now have a chance to be discovered – without limiting boxes or missed opportunities due to their skin colour, age or gender.</p>
			<p>We believe it is our clients’ right to access and view all available models, and not just those favoured by traditional casting means.</p>

		</div>
	</div>
	<div class="half">
		<div class="image">
		</div>
	</div>
</section>

<section id="unbiased_section2">
	<div class="half">
		<div class="image">
		</div>
	</div>
	<div class="half">
		<div class=" content">
			<p>By empowering brands in fashion, beauty and the advertising industry with as much freedom of choice as possible, we expand their creative horizons.</p>
			<p>With this in mind, iDAL is taking a proactive step towards automating and boosting the ethical element of the model selection.</p>
			<p>This is the future of the modelling industry – a tailored approach to model selection, while putting inclusivity and diversity front and centre.</p>
			<div class="row">
				<div class="column text-center desktop" style="margin-top: 4em;"><a href="" class="button burgundy register" data-registertype="client">BOOK TALENT</a></div>
			</div>
			
		</div>
	</div>
</section>
<div class="row mobile">
	<div class="column text-center" style="margin-top: 0em; margin-bottom: 4em;"><a href="/m/register" class="button burgundy" data-registertype="client">BOOK TALENT</a></div>
</div>
{if $userid eq 0}
<script type="text/javascript">
{capture name="regmod"}{strip}{include file="shared/registermodal.tpl"}{/strip}{/capture}
var registerModal = '{$smarty.capture.regmod|escape:"javascript"}';
var trk = '{$trk}';
</script>
{/if}