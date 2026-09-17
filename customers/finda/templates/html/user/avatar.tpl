{extends "user/layout.tpl"}
	
{block name="main"}
<div class="row row-heading">
	<div class="column">
		<h1 style="transform-origin: left top;">Upload a new Avatar</h1>
	</div>
</div>
{if $usertype eq 1}
<div class="row">
		<div class="column">
			<form method="post" action="/user/avatar/upload" enctype="multipart/form-data" id="avatarform">
				<input type="file" name="avatar" id="avatar" class="button" >
				<button type="submit" name="Upload" class="button bg-black white hvr hvr-blue">Upload</button>
			</form>
		</div>
		<div class="column text-right">
			<a href="/user/avatar/edit" class="button bg-black white hvr hvr-blue">Edit your existing avatar</a>
		</div>
</div>
{else}
<div class="row">
		<div class="column">
			<form method="post" action="/user/avatar/upload" enctype="multipart/form-data" id="avatarform">
				<input type="file" name="avatar" id="avatar" class="button" >
				<button type="submit" name="Upload" class="button inverted">Upload</button>
			</form>
		</div>
</div>
{/if}
{/block}