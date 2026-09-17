<div class="comcard page1">
	<div class="text-center"><img src="/images/IDAL_black.png" height=48/></div>
	
	<div class="portfolio_frame" style="overflow: hidden; position: relative; width: 450px; height: 480px; border: 5px solid #59c5cf; margin-top: 64px; margin-bottom: 32px;">
		<div style="position: absolute; left: {$marginLeft}px; top: {$marginTop}px; right: 0px; bottom: 0px; ">
			<img src="{$smarty.const.CDN_ROOT}/portfolio/large{$model.filename}" style="{if $orientation eq 'portrait'}width: 450px;{else}height: 480px{/if}">
		</div>
	</div>
	
	<table style="width: 100%;">
		<tr style="width: 100%;">
			<td style="width: 50%; line-height: 24px; font-size: 24px; font-weight: bold; text-align: left;">{$model.firstname|strtoupper} {$model.lastname|substr:0:1}.</td>
			<td style="width: 50%; line-height: 24px; font-size: 16px; font-weight: normal; text-align: right;"><em>idal.co/view/{$model.sefu}</em></td>
		</tr>
	</table>
</div>