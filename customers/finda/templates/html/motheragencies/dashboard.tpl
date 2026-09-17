{extends "motheragencies/layout_dashboard.tpl"}

{block name="main"}
	<div class="row">
		<div class="column">
			<h1>{$motheragency.agencyname} Dashboard</h1>
		</div>
	</div>
	<div class="row">
		<div class="column"><h3>Monthly Stats</h3></div>
	</div>
	
	<div class="row">
		<div class="column">
			<table>
				<tr class="underline dotted">
					<td>Total Models Signed on iDAL</td>
					<td class="text-right">{$stats.modelcount}</td>
				</tr>
				<tr class="underline dotted">
					<td>Total Bookings{* This Month *}</td>
					<td class="text-right">{$stats.bookingcount}</td>
				</tr>
				<tr class="underline dotted">
					<td>Total Commission This Month</td>
					<td class="text-right">{$totalcommission}</td>
				</tr>
				<tr>
					<td colspan=2 class="text-right"><a href="/dashboard/modelinvoices" class="button burgundy">Model Invoices</a></td>
				</tr>
			</table>
		</div>
	</div>
	
	<div class="row">
		<div class="column"><h3>Signed Models</h3></div>
	</div>
	<div class="row">
		<div class="column">
			<table>
				<tr class="underline">
					<td class="text-bold">Model</td>
					<td class="text-bold text-center">Joined</td>
					<td class="text-bold text-center">Castings</td>
					<td class="text-bold text-center">Bookings</td>
					<td class="text-bold text-right">Currently In</td>
				</tr>
				{foreach from=$agencymodels item=model}
				<tr>
					<td style="display: flex; align-items: center;">
						<a class="text-center nounderline" href="/dashboard/manage/{$model.id}"><img class="dashimage" src="/{$model.imagetype}/large{$model.filename}" width=100 /></a>
						<a style="margin-left: 0.5em;" href="/dashboard/manage/{$model.id}">{$model.firstname} {$model.lastname}</a>
						</td>
					<td class="text-center">{$model.created|date_format:"d/m/Y"}</td>
					<td class="text-center">{$model.castingcount}</td>
					<td class="text-center">{$model.bookingcount}</td>
					<td class="text-right">{$model.currentlocation}</td>
				</tr>
				{/foreach}
			</table>
		</div>
	</div>
{/block}