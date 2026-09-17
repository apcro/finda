<div class="row column">
	<div class="grid grid-faq">
		<div class="row row-heading">
			<div class="column">
				<h1 style="transform-origin: left top;">Support</h1>
			</div>
		</div>
		<div class="row">
			<div class="column">
				{if $usertype eq 2}
				<p>For any technical issues or questions regarding projects or models, please fill in the form below or contact us directly.</p>
				{else}
				<p>For any technical issues or questions regarding jobs, please fill in the form below or contact us directly.</p>
				{/if}
				<div class="seperator" data-gap="2"></div>
				<p class="text-center text-bold">Email: <a href="mailto:support@idal.co">support@idal.co</a></p>
				<p class="text-center text-bold">Phone: <a href="tel://+442081877737">+44 20 8187 7737</a></p>
				<p class="text-center text-bold">Phone: <a href="tel://+13156163303">+1 315-616-3303</a></p>
				<div class="seperator" data-gap="4"></div>
				<textarea id="request" rows="10">{if $subject neq ''}{$subject}{/if}</textarea>
			</div>
		</div>
		<div class="row">
			<div class="column">
				<div class="text-right">
					<button class="button inverted" id="submitrequest">Submit</button>
				</div>
			
				<div class="seperator" data-gap="4"></div>
				<div class="seperator" data-gap="4"></div>
			</div>
		</div>
	</div>
</div>