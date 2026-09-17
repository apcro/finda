{extends "user/layout.tpl"}

{block name="main"}
<div class="grid-x">
	<h4>Edit Experience</h4>	
	<div class="cell">
		<form id="editexperience" action="/user/profile/experience/update/{$experience.id}" method="POST">
			<div>
				<label for="clientname">Client Name</label>
				<input id="clientname" type="text" name="client input" placeholder="Client name" value="{$experience.client}"/>
			</div>
			<div>
				<label for="jobtype">Type of Job</label>
					<select name="jobtype input" id="jobtype">
						{foreach from=$jobtypes item=type name=type key=k}
						<option value="{$k}"{if $k eq $experience.work_type} selected="selected"{/if}>{$type.name}</option>
						{/foreach}
					</select>
			</div>
			<div>
				<label for="detailsname">Details</label>
				<input id="detailsname" type="text" name="details input" placeholder="Details"  value="{$experience.details}"/>
			</div>
			<div>
				<label for="dateworked">Date Worked</label>
				<input id="dateworked" type="text" name="dateworked input" placeholder="date worked"  value="{$experience.client}"/>
			</div>
			<input type="submit" class="button accept" value="Update experience" />
			<input type="hidden" name="experienceid" value="{$experience.id}" />
		</form>
	</div>
</div>
{/block}