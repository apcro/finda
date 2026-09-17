<div class="comcard page">
	<div class="text-center"><img src="/images/IDAL_black.png" height=48/></div>
	<div class="modeldetails" style="text-align: center; width: 100%; margin-top: 32px;">
		<span style="font-size: 18px; font-weight: 900; color: #000;">Digital Portfolio & Polaroids: <a href="https://idal.co/view/{$model.sefu}" target="_blank" style="color: #000;">https://idal.co/view/{$model.sefu}</a></span><br />
		<span style="font-size: 18px; font-weight: 900; color: #000;">Instagram: <a href="https://instagram.com/{$model.instagram_username|replace:'@':''}" target="_blank" style="color: #000">{$model.instagram_username}</a></span><br />
	</div>
{include file="models/comcard_measurements.tpl"}
	<div class="portfolio_frame">
		<img src="{$smarty.const.CDN_ROOT}/polaroids/large{$image.filename}" />
	</div>
</div>