<div class="comcard page">
	<div class="text-center"><img src="/images/IDAL_black.png" height=48/></div>
	<div class="modeldetails" style="text-align: center; width: 100%; margin-top: 32px;">
		<span style="font-size: 18px; font-weight: 900; color: #000;">Digital Portfolio & Polaroids: https://idal.co/view/{$model.sefu}</span><br />
		<span style="font-size: 18px; font-weight: 900; color: #000;">Instagram: {$model.instagram_username}</span><br />
	</div>
	{include file="models/comcard_measurements.tpl"}
	<div style="clear: both;"></div>
	<div class="portfolio_frame">
		<img src="{$smarty.const.CDN_ROOT}/portfolio/large{$image.filename}" />
	</div>
</div>