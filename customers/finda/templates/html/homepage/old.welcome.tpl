{* main welcome page *}
<section id="landing" class="fullscreen">
	<div class="row">
		<div class="column">
			<div class="logo">
				<h1>DISCOVERY AND BOOKING PLATFORM FOR MODELLING TALENT</h1>
			</div>
		</div>
	</div>
	<div class="row">
		<div class="column text-center">
			<a href="" class="register welcome-button button hvr bg-red white hvr-white-textred">Join Now</a>
		</div>
	</div>
	<div class="row mobile">
		<div class="column">
			<div class="align-center">
				<a href="/user/login" class="signin-button button hvr bg-red white hvr-white-textred">Sign in</a>
			</div>
		</div>
	</div>
	<div class="row" style="margin-bottom: 4em;">
		<div class="column text-center">
			<a href="https://itunes.apple.com/us/app/finda-for-models/id1427352589?ls=1&mt=8"><img src="/images/Download_on_the_App_Store_Badge_US-UK_RGB_blk_092917.svg" width=250 style="padding: 20px 40px;"/></a>
		</div>
	</div>
	<div class="row" style="margin-bottom: 4em;">
		<div class="column">
			<div class="align-center socialbuttons"><a href="https://www.instagram.com/idal.co"><img src="/images/instagram_icon_red.png" /></a><span>#IDALMODEL</span></p></div>
		</div>
	</div>
	<div class="downarrow text-center" data-scrollto="landing-insta"><i class="fa fa-angle-down"></i></div>
	<div class="photocredit">Photo &copy; Jamie Nelson. Used with permission</div>
</section>
{* include file="homepage/sections/time_to_bloom.tpl" *}
{* include file="homepage/sections/tutorial.tpl" *}
{if $smarty.const.LOCALDEV neq 1}
{include file="homepage/sections/instagram.tpl"}
{/if}
{include file="mobile/mobilefooter.tpl"}
{if $userid eq 0}
<script type="text/javascript">
{capture name="regmod"}{strip}{include file="shared/registermodal.tpl"}{/strip}{/capture}
var registerModal = '{$smarty.capture.regmod|escape:"javascript"}';
</script>
{/if}
