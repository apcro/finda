<div class="grid profile-home">
	<div class="grid-left">
		<div class="row">
			<div class="column">
			</div>
			<div class="column">
				<h1 class="align-left">{$client.firstname}</h1>
				<h2>{$client.lastname}</h2>
			</div>
		</div>
		<div class="row">
			<div class="column">
			</div>
			<div class="column">
				<div class="clientdetails">
					<div class="row">
						<div class="column narrow">Website</div>
						<div class="column"><hr class="yellow-line"></div>
						<div class="column narrow"><a href="{$client.company_website}">{$client.company_website}</a></div>
					</div>
					<div class="row">
						<div class="column narrow">Complete Projects</div>
						<div class="column"><hr class="yellow-line"></div>
						<div class="column narrow">{$client.completedprojects}</div>
					</div>
					<div class="row">
						<div class="column narrow">Complete Bookings</div>
						<div class="column"><hr class="yellow-line"></div>
						<div class="column narrow">{$client.completedassignments}</div>
					</div>
					<div class="row">
						<div class="column narrow">Average Rating</div>
						<div class="column"><hr class="yellow-line"></div>
						<div class="column narrow">{$client.average_rating}cm</div>
					</div>

				</div>
			</div>
		</div>
	</div>
	<div class="grid-main">
		<div class="full-bleed">
			<img src="{$smarty.const.CDN_ROOT}/images/user/avatars/{$client.avatar}" />
		</div>
	</div>
</div>