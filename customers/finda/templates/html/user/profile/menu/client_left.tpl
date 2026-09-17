		<ul class="model_left_menu">
			{if $userstatus eq 0}
			<li><a{if $function eq 'user' && $secondary eq 'details'} class="selected" {/if} href="/user/profile">My Details</a></li>
			{if $canverify}
			<li><a{if $function eq 'user' && $secondary eq 'verify'} class="selected" {/if} href="/user/verify">Verify</a></li>
			{else}
			<li {if $verifyfails neq ''}data-balloon-pos="right" data-balloon-length="medium" data-balloon="We also need to know your {$verifyfails} before we can verify your account"{/if}><a href="/user/verify">Verify Your Account</a></li>
			{/if}
			{/if}
		</ul>