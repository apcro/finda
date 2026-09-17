<link href="/css/finda.css" rel="stylesheet" type="text/css"/>
<link href="/css/models/comcard.css" rel="stylesheet" type="text/css"/>
<div class="pages print" style="text-align: center;">
	{foreach from=$portfolio item=image}
	{if $image.enabled}
	{include file="models/comcard_image_page_portfolio.tpl"}
	<div class="page_break"></div>
	{/if}
	
	{/foreach}
	{foreach from=$polaroids item=image name=polaroid}
	{if $image.enabled eq 1}
	{include file="models/comcard_image_page_polaroids.tpl"}
	{if !$smarty.foreach.polaroid.last}
	<div class="page_break"></div>
	{/if}
	{/if}
	{/foreach}
</div>