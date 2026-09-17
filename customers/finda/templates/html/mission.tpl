<div class="mobile">
	<div class="panel-toggle-button">
		<div class="hamburger hamburger--arrow">
			<div class="hamburger-box">
				<div class="hamburger-inner"></div>
			</div>
		</div>
	</div>
</div>
<nav id="mobilemenu" class="mobile {$body_class}">
	<ul>
		<li><a href="/mission">About us</a>
		<li><a href="modelwithus">Model with us</a></li>
		<li><a href="/modellaw">Model Law</a></li>
	</ul>
</nav>
<div id="main" class="mobilepanel">

	<section id="section1">
	
		<div class="row" style="padding-top: 2em;">
			<div class="column">
				<h2 class="text-burgundy">Vision</h2>
				<h3>We are reimagining the traditional way of booking models, shaping a <span class="text-bold">more efficient and ethical solution</span> for the industry with technology.</h3>
			</div>
		</div>
		<div class="row bottom">
			<div class="column">
				<h2 class="text-burgundy">Mission</h2>
				<h3>To create the <span class="text-bold">best experience for brands</span> to work with professional models, creatives and creators by <span class="text-bold">using technology</span> and by building a value driven <span class="text-bold">community of committed and qualified talent</span></h3>
			</div>
		</div>
	
	</section>
	
	<section id="theteam">
			<div class="row" style="width: 100%;">
				<div class="column text-center" style="max-width: 100%; margin-top: 60px; margin-bottom: 20px;">
					<h3><span class="text-burgundy">People</span> behind iDAL</h3> 
				</div>
			</div>
			
			<div class="row images lr">
				<div class="column text-center">
					<div class="rounded profile">
						<a href="https://www.linkedin.com/in/mariyagrinina/" target="_blank" style="background-image: url(/images/staff/mariya.jpg);"></a>
					</div>
				</div>
				<div class="column bar desktop"></div>
				<div class="column">
					<p>Mariya Grinina</p>
					<p class="text-burgundy">CEO & co-founder</p>
					<span class="introduction">Entrepreneur bringing together iDAL's first models, clients, investors and industry leaders to challenge the status quo of the fashion modelling industry.</span>
				</div>
			</div>
			<div class="row mobile">
				<div class="column bar"></div>
			</div>
			
			
			<div class="row images rl">
				<div class="column text-right">
					<p>Ian Loughran</p>
					<p class="text-burgundy">CMO & co-founder</p>
					<span class="introduction"></span>
				</div>
				<div class="column bar desktop"></div>
				<div class="column">
					<div class="rounded profile">
						<a href="" target="_blank" style="background-image: url(/images/staff/ian.jpg);"></a>
					</div>
				</div>
			</div>
			<div class="row mobile">
				<div class="column bar"></div>
			</div>


			<div class="row images lr">
				<div class="column">
					<div class="rounded profile">
						<a href="https://www.linkedin.com/in/tomgordon/" target="_blank" style="background-image: url(/images/staff/tom.jpg);"></a>
					</div>
				</div>
				<div class="column bar desktop"></div>
				<div class="column">
					<p>Tom Gordon</p>
					<p class="text-burgundy">CTO & co-founder</p>
					<span class="introduction">Multi-award-winning developer (BAFTA, Emmy, IDSA). Built technology for companies across various industries including broadcast (Teachers TV) and fashion (Peclers Plus and Elle Magazine).</span>
				</div>
			</div>
			<div class="row mobile">
				<div class="column bar"></div>
			</div>
			
			
			
			
			<div class="row images rl">
				<div class="column text-right">
					<p>Adam Thomas</p>
					<p class="text-burgundy">Head of Brand and Partnerships</p>
					<span class="introduction">Brand consultant for fashion and tech companies from OTB Group to Burberry; previously Managing Partner at Sunshine. Having been on the client side of the business, Adam is driven to make a positive change for the industry he’s been a part of for many years.</span>
				</div>
				<div class="column bar desktop"></div>
				<div class="column image">
					<div class="rounded profile">
						<a href="https://www.linkedin.com/in/adam-thomas-7425a48/" target="_blank" style="background-image: url(/images/staff/adam.jpg);"></a>
					</div>
				</div>
			</div>
			<div class="row mobile">
				<div class="column bar"></div>
			</div>
			
			
			<div class="row images lr">
				<div class="column">
					<div class="rounded profile">
						<a href="https://www.linkedin.com/in/vsolodkiy/" target="_blank" style="background-image: url(/images/staff/slava.jpg);"></a>
					</div>
				</div>
				<div class="column bar desktop"></div>
				<div class="column">
					<p>Vladislav Solodkiy</p>
					<p class="text-burgundy">Growth Advisor</p>
					<span class="introduction">CEO & Co-founder at a digital bank Arival, Institutional Investor’s World’s Top 40 fin-tech investors. Having been interested in revolutionising technology for the model agency industry for years, Vladislav is thrilled to use his findings as well as his bank’s safety technology in iDAL.</span>
				</div>
			</div>
			
			
	</section>
</div>
{if $userid eq 0}
<script type="text/javascript">
{capture name="regmod"}{strip}{include file="shared/registermodal.tpl"}{/strip}{/capture}
var registerModal = '{$smarty.capture.regmod|escape:"javascript"}';
var trk = '{$trk}';
</script>
{/if}
