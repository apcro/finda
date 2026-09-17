{extends "user/layout_templates.tpl"}

{block name="main"}
<div class="row mobile">
	<div class="column">
		<p class="notice">Please use your desktop or laptop to enjoy all our features. The iDAL app is coming soon!</p>
	</div>
</div>

{if $pagemessage.message neq ""}
<div class="row">
	<div class="callout {$pagemessage.type}">
		<h5>{$pagemessage.message}</h5>
	</div>
</div>
{/if}

<div class="row">
	<div class="column" style="min-width: 25%;">
		<h2>Templates</h2>
		<div class="templatelist">
		{include file="jobs/templates/template_list.tpl"}
		</div>
		
	</div>
	
	<div class="column" id="tab-details-panel" style="min-width: 75%;">
		<h2 class="templateeditheading">&nbsp;</h2>
		<form id="templateform">
			<input type="hidden" name="templateid" value="" />
			<div class="templatedetails">
				<h3>Basic Information</h3>
				<label for="templatename">Template Name</label>
				<input type="text" id="templatename" name="templatename" placeholder="Template Name" class="span2" value="{$template.name}">
	
				<label for="jobtype">Type of Project</label>
				<div class="select-wrap">
					<select name="jobtype" id="jobtype" class="select">
					{foreach from=$jobtypes item=type name=type key=k}
					<option value="{$k}">{$type.name}</option>
					{/foreach}
					</select>
				</div>
	
				<label for="location">Location</label>
				<textarea id="location" name="projectlocation" placeholder="Project location"></textarea>
	
				<label for="description">Description</label>
				<textarea id="description" name="description" placeholder="Project Description" rows="5">{$job.description}</textarea>
	
				<label for="rate">Base Offered Rate per Model</label>
				<input type="text" id="rate" name="offeredrate" placeholder="Offered Rate" value="{$job.offered_rate}"{if $job.job_status eq 1} disabled="disabled"{/if}>
				<p class="minrate_notice"></p>
	
	
	
	
	{*
				<h3>Usage Rights</h3>
				<div class="triplet-checkbox rights">
					<label for="standardrights"{if $job.baseusage eq 'standard' || $job.baseusage eq ''} class="active"{/if}>Standard</label>
					<input type="radio" id="standardrights" name="baseusage" value="standard" {if $job.baseusage eq 'standard' || $job.baseusage eq ''} checked="checked"{/if}/>
					<label for="extrarights"{if $job.baseusage eq 'custom'}class="active"{/if}>Additional usage</label>
					<input type="radio" id="extrarights" name="baseusage" value="custom" {if $job.baseusage eq 'custom'} checked="checked"{/if}/>
					<p>As a standard, usage rights for each booking through iDAL covers 6 months across up to three selected media.</p>
				</div>
				<div class="rights-checkboxes">
					<div class="row">
						<div class="column">UK</div>
						<div class="column text-right">
							<input class="tgl tgl-slider" id="ukrights" type="checkbox" name="ukrights"{if $job.usage.uk eq 1} checked="checked"{/if} />
							<label class="tgl-btn" for="ukrights"></label>	
						</div>
					</div>
					<div class="rights-holder">
						<div class="row">
							<div class="column">Europe (includes UK)</div>
								<div class="column text-right">
									<input class="tgl tgl-slider" id="eurights" type="checkbox" name="eurights"{if $job.usage.europe eq 1} checked="checked"{/if} />
									<label class="tgl-btn" for="eurights"></label>	
								</div>
							</div>
						<div class="row">
							<div class="column">International</div>
							<div class="column text-right">
								<input class="tgl tgl-slider" id="intrights" type="checkbox" name="intrights"{if $job.usage.international eq 1} checked="checked"{/if} />
								<label class="tgl-btn" for="intrights"></label>	
							</div>
						</div>
					</div>
					<hr />
					<div class="base-rights-holder">
						{foreach from=$usagerights item=right}
						<div class="row">
							<div class="column">{$right.name}</div>
							<div class="column text-right">
								<input class="tgl tgl-slider" id="usagerights-{$right.tid}" type="checkbox" name="usagerights[]" value="{$right.tid}" {foreach from=$job.usagerights item=ur}{if $ur.tid eq $right.tid} checked="checked"{/if}{/foreach} />
								<label class="tgl-btn" for="usagerights-{$right.tid}"></label>	
							</div>
						</div>
						{/foreach}
					
	
					</div>
				</div>
				<div class="rights-holder"{if $job.usagerights neq 'custom'} style="display: none;"{/if}>
					<hr />
					<h3>Additional usage rights</h3>
					<textarea id="extrarightsentry" name="extrarights" placeholder="Additional usage rights" rows="4">{$job.additionalrights}</textarea>
				</div>
				*}
				<div class="seperator" data-gap="2"></div>
				<div class="row">
					<div class="column text-center">
						<a href="edittemplate" class="button burgundy edittemplate">Save Changes</a>
						<a style="margin-left: 1em;" class="button createfromtemplate" href="">Create New Project</a>
						<a href="deletetemplate" class="button errorbutton deletetemplate" style="margin-left: 4em;">Delete</a>
					</div>
				</div>
				
			</div>
			<div class="templateinfo">
				<p>Select a template from the list on the left to view or edit it</p>
			</div>
		</form>
	</div>

</div>
<div class="seperator" data-gap="2"></div>
<div class="seperator" data-gap="2"></div>
{if $edittemplateid}
<input type="hidden" name="edittemplateid" value="{$edittemplateid}" />
{/if}
{/block}