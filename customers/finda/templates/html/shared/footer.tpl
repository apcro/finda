<section id="footer">
	<div class="row">
	{if $smarty.const.HOLDING eq 0}
		<div class="column">
			<h4>iDAL</h4>
			<ul>
{*				<li><a href="/mission">About Us</a></li>*}
				<li><a href="/support">Contact</a></li>
{*				<li><a href="/faq">FAQ</a></li> *}
{*				<li><a href="/careers">Careers</a></li> *}
				{if $userid neq 0}
				<li style="margin-left: -20px;"><a href="tel:+442081877737" data-balloon-pos="up" data-balloon="Call us"><i class="fas fa-phone" style="margin-right: 6px;"></i>020 8187 7737</a></li>
				<li style="margin-left: -20px;"><a href="tel:+13156163303" data-balloon-pos="up" data-balloon="Call us"><i class="fas fa-phone" style="margin-right: 6px;"></i>+1 315-616-3303</a></li>
				{/if}
			</ul>
		</div>

		<div class="column">
			<h4>Legal</h4>
			<ul>
				<li><a href="/conduct">Code of Conduct</a></li>
				<li><a href="/terms">Terms and Conditions</a></li>
				{* if $userid neq 0}
				<li style="margin-left: -16px;"><a href="/bookingterms" data-balloon-pos="up" data-balloon="Open PDF"><i class="fas fa-file-pdf" style="margin-right: 2px;"></i> Standard Booking Terms</a></li>
				{/if *}
				<li><a href="/privacy">Privacy Policy</a></li>
			</ul>
		</div>

		<div class="column">
			<h4>Follow Us</h4>
			<ul>
				<li><a href="https://www.instagram.com/idal.co/" title="Instagram" target="_blank">Instagram <i class="fas fa-external-link-alt"></i></a></li>
				<li><a href="idaltalent" title="Facebook" target="_blank">Facebook <i class="fas fa-external-link-alt"></i></a></li>
				<li><a href="https://www.linkedin.com/company/findaformodels/" title="LinkedIn" target="_blank">LinkedIn <i class="fas fa-external-link-alt"></i></a></li>
				{* if $usertype eq 1}
				<li><a href="https://www.facebook.com/groups/idal.co/" title="Private Model Group" target="_blank">Private Model Group <i class="fas fa-external-link-alt"></i></a></li>
				{/if *}
			</ul>
		</div>
	{/if}
	</div>
	<div class="row">
		<div class="column">
			<p style="font-size: 75%; margin-top: 2em;" class="text-right font-thin"><em>Made with <i class="fa fa-heart ho-heart"></i> in London. &copy; 2018-present Finda Global Limited. All Rights Reserved.</em></p>
		</div>
	</div>
</section>