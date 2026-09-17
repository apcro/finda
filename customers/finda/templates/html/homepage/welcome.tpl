<div class="mobile">
	<div class="panel-toggle-button">
		<div class="hamburger hamburger--arrow">
			<div class="hamburger-box">
				<div class="hamburger-inner"></div>
			</div>
		</div>
	</div>
</div>
<nav id="mobilemenu" class="mobile">
	<ul>
		<li><a href="/m/enquire">Enquire for talent booking</a></li>
		<li><a href="/m/register" class="register" data-registertype="model">Join</a></li>
	</ul>
</nav>
<div id="main" class="mobilepanel">
	{include file="homepage/sections/redesign_2020/leader.tpl"}
</div>

{include file="shared/footer.tpl"}
{if $affuser neq ''}
<input type="hidden" name="affuser" value="{$affuser}"/>
{/if}
{if $userid eq 0}
{include file="shared/loginmodal.tpl"}
<script type="text/javascript">
{capture name="regmod"}{strip}{include file="shared/registermodal.tpl"}{/strip}{/capture}
var registerModal = '{$smarty.capture.regmod|escape:"javascript"}';
var trk = '{$trk}';
</script>
{/if}
