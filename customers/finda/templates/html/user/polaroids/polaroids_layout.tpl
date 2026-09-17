<div class="row column">
	{block name="dashboard"}
	<div class="grid">
		<div class="grid-left">
			<div class="avatar_holder" style="margin-top: 2em;">
				<div class="avatar">
					{if $usertype eq 1}
					<a href="/user/portfolio" data-balloon="Select a new main image" data-balloon-pos="down"><img id="avatarimage" src="{$user_avatar}"/></a>
					{else}
					<a href="/user/avatar" data-balloon="Change your avatar" data-balloon-pos="down"><img id="avatarimage" src="{$user_avatar}" /></a>
					{/if}
				</div>
			</div>
			<ul class="vertical menu profile">
				{include file="user/profile/menu/model_left.tpl"}
			</ul>
		</div>
		<div class="grid-main grid-bg-green">
			{block name="main"}{/block}
			<div class="dots">
				<div class="fancydots_left"><img src="/images/fancy_dots.png" /></div>
				<div class="fancydots_right"><img src="/images/fancy_dots.png" /></div>
			</div>
		</div>
	</div>
	{/block}

</div>