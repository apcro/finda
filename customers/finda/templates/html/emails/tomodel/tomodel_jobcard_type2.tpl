<style>
	.grid-main .row {
		padding: 0;
		margin: 0.5em 0;
	}
	.jobcards {
		margin: 0 auto;
		padding: 0;
	}
	.jobcards_offered .job_card {
		width: 100%;
	}
	.job_card {
		text-align: left;
		border-radius: 2px;
		font-size: 100%;
		z-index: 1;
		position: relative;
		background-color: #FFFFFF;
		border: 3px solid transparent;
		transition: box-shadow 0.2s ease-in-out;
		padding: 1em;
		padding: 0px;
	}
	.job_card .job_card_info {
		border-right: 1px solid #FFFFFF;
		padding: 10px;
		width: 200px;
		height: 100%;
		display: inline-block;
	}
	.job_card .card_row {
		font-size: 1em;
		width: 100%;
		color:#565c66;
		padding: 40px;
		box-sizing: border-box;
		min-width: 100%;
		clear: both;
	}
	.job_card .card_row .card_type {
		font-size: 1em;
		color: #000;
		display: inline-block;
		padding: 5px 10px 10px 10px;
		font-weight: 700;
		width: 100%;
		left: 0;
		margin-top: 5px;
		margin-bottom: 0.5em;
		color: #010101;
	}
	.job_card .card_row .card_jobname {
		margin: 0;
		font-size: 1.25em;
		color: #7A3147;
	}
	.job_card .card_row .card_clientname {
		margin: 5px 10px 0 0px;
	}
	.job_card .card_row .card_clientname a {
		text-decoration: none;
		color: #99A3A3;
	}
	.job_card .card_row .card_clientname a:hover {
		text-decoration: none;
		border-bottom: 2px solid #99A3A3;
		color: #99A3A3;
	}
	.job_card .card_row .job_callsheet {
		margin: 0 10px;
		position: relative;
		display: block;
	}
	.job_card .card_row .job_callsheet .action_holder {
		position: relative;
		display: inline-block;
		width: 100%;
	}
	.job_card .card_row .card_location {
		margin-bottom: 0.5em;
	}
	.job_card .card_row .usage_rights,
	.job_card .card_row .additional_information,
	.job_card .card_row .card_rate,
	.job_card .card_row .card_card_modelthumbs,
	.job_card .card_row .card_manage,
	.job_card .card_row .card_jobdescription,
	.job_card .card_row .card_jobdetails {
		margin-top: 1em;
	}
	.job_card .card_row .usage_rights summary,
	.job_card .card_row .additional_information summary,
	.job_card .card_row .card_rate summary,
	.job_card .card_row .card_card_modelthumbs summary,
	.job_card .card_row .card_manage summary,
	.job_card .card_row .card_jobdescription summary,
	.job_card .card_row .card_jobdetails summary {
		font-weight: 700;
	}
	.job_card .card_row .additional_information .extra_info p {
		display: inline-block;
	}
	.job_card .card_row .additional_information .extra_info p span {
		min-width: 100px;
		margin-right: 20px;
		display: inline-block;
	}
	.job_card .card_button {
		padding: 1em 1.5em;
		border-radius: 2px;
		font-size: 0.75em;
		font-weight: 700;
		margin: 0.25em 0.5em;
		display: inline-block;
		text-align: center;
		min-width: 40%;
		text-transform: uppercase;
	}
	.job_card .card_button.card_buttonsmall {
		padding: 0.5em;
		font-size: 11px;
		width: 25%;
		margin: 0;
		color: #FFFFFF;
	}
	.job_card .card_button.card_nobuttonsmall {
		padding: 0.5em;
		font-size: 11px;
		width: 25%;
		margin: 0;
		text-align: right;
	}
	.job_card .card_button.card_right {
		right: 0;
	}
	.job_card .card_button span {
		display: inline-block;
	}
	.job_card .card_right {
		float: right;
		display: inline-block;
	}
	.job_card .card_readmore {
		float: right;
		background: #FFFFFF;
		padding: 1em;
		position: absolute;
		right: 0;
		top: 0;
		border-radius: 0 2px 0 0;
	}
	@media screen and (min-width: 768px) {
		.croissant-modal .job_card {
			text-align: left;
		}
	}
</style>
<div class="job_card">
	<div class="card_row">
		<div class="card_jobname">{if $job.jobtype_name neq ''}{$job.jobtype_name|upper} | {/if}{$job.name}</div>
		<div class="card_jobdetails">
			<div class="card_location" style="margin-bottom: 1em;">
				<span style="font-size: 75%; font-weight: 100; padding-bottom: 0.5em; display: inline-block;">Location</span>
				<br />{$job.location}
			</div>
		</div>
		<table style="width: 100%;">
			<tr style="width: 100%;">
				<td style="font-size: 75%; font-weight: 100; padding-bottom: 0.5em;">Date</td>
				<td style="font-size: 75%; font-weight: 100; padding-bottom: 0.5em;">Start Time</td>
				<td style="font-size: 75%; font-weight: 100; padding-bottom: 0.5em;">Type of Project</td>
			</tr>
			<tr style="width: 100%;">
				<td>{$job.startdate|date_format:"%d/%m/%Y"}</td>
				<td>{$job.starttime|date_format:"%I:%M%p"}</td>
				<td>{$job.jobtype_name}</td>
			</tr>
		</table>
	</div>
</div>