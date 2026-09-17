{extends "user/layout_messages.tpl"}

{block name="main"}
<div class="row" style="flex-wrap: nowrap;">
	{* other person's details *}
	<div class="column persondetails">
		<div class="row">
			<div class="column text-center">
				<img src="{$CDN_ROOT}/avatar/thumb{$recipient.avatar}">
				<h4>{$recipient.firstname} {$recipient.lastname}</h4>
			</div>
		</div>
		{if $usertype eq 2}
		<div class="row">
			<div class="column text-center">
				<p style="margin-top: 1em;"><a class="button burgundy small" href="/view/{$recipient.sefu}">Back to Profile</a></p>
			</div>
		</div>
		{/if}
		{if $projects}
		<div class="row">
			<div class="column">
				<h4>Projects</h4>
				<ul class="projectslist">
					{foreach from=$projects item=project}
					<li>&raquo; <a href="/projects/view/{$project.id}">{$project.name}</a></li>
					{/foreach}
				</ul>
			</div>
		</div>
		<div class="row"><div class="column"></div></div>
		<div class="row"><div class="column"></div></div>
		{/if}
	</div>
	
	{* the chat *}
	<div class="column messageslistholder">
		<div class="row">
			<div class="column"></div>
			<div class="column">
				<div class="notice burgundy">
					{if $usertype eq 2}
					For your and a model’s safety, protection and professionalism, use this secure messenger to discuss your booking or casting.{if $thisjobid neq 0} To continue booking models for this project simply <a href="/projects/{$thisjobid}">go back there</a>.{/if}
					{else}
					For your safety, protection and professionalism, use this secure messenger to discuss your booking or casting. iDAL will not be able to participate in a dispute or chasing payment if you communicate outside iDAL.
					{/if}
				</div>
			</div>
			<div class="column"></div>
		</div>
		<div class="row">
			<div class="column text-right messageinput">
				<textarea id="newmessage" name="newmessage" rows=5 placeholder="Type your message here"></textarea>
				<a class="button small sendmessage">Send a message</a>
			</div>
			<div class="column actions" style="flex-grow: 0;">
				<div class="addattachment" data-open="attachmentModal" data-balloon="Send image or PDF" data-balloon-pos="up">
					<i class="fas fa-paperclip"></i>
				</div>
			</div>
			<div class="column useravatar" style="flex-grow: 0; margin-right: 4em;">
				<img src="{$CDN_ROOT}{$avatar}">
			</div>
		</div>
		
		<hr>
		<div class="messageslist">
		{include file="user/inbox/messages_list.tpl"}
		</div>
	</div>
</div>
<input type="hidden" name="modelid" value="{$recipient.id}" />
<div class="reveal modalWhite" id="attachmentModal" data-reveal>
	<div class="row">
		<div class="column">
			<h2>Send image or PDF</h2>
			<p>Select an Image or PDF to be sent to {$recipient.firstname}</p>
		</div>
	</div>
	<div class="row">
		<div class="column uploadimage">
			<div id="wrapper dropzone dz-clickable">
				<form action="/user/portfolio/upload" class="imagedropzone" id="imagedropzone">
					<div class="dz-message needsclick">Drop files here or click to upload.</div>
					<div class="fallback">
						<input class="button" name="file" type="file" multiple />
					</div>
				</form>
			</div>
		</div>
	</div>
	<div class="row">
		<div class="column text-right">
			<textarea id="newimagemessage" name="newimagemessage" rows=5 placeholder="Type your message here"></textarea>
		</div>
	</div>
	<div class="row">
		<div class="column">
			<a class="button small cancelimagemessage">Cancel</a>
		</div>
		<div class="column text-right">
			<a class="button small sendimagemessage">Send a message</a>
		</div>
	</div>
</div>
{/block}