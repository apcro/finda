{extends "user/layout.tpl"}
{block name="main"}
{*
<div class="row">
	<div class="column text-center">
		<div class="notice text-white bg-red" style="max-width: 30em; display: inline-block;">Please note that we are still in testing mode, so there might be some bugs or errors. If you come across any problems with the website, please email <span class="text-white text-bold">tom@idal.co</span>.</div>
	</div>
</div>
*}
{if $usertype eq 1}
{* model homepage *}
{include file="user/profile.view.model.tpl"}
{else}
{* client homepage *}
{include file="user/profile.view.client.tpl"}
{/if}
<div class="reveal modalYellow" id="moreModelInfo" data-reveal></div>
{/block}
