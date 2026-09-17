			<ul class="model_left_menu">
				{if $userStatus eq 0}
				{if $canverify}
				<li><a href="/user/verify"><i class="fas fa-check"></i>Verify</a></li>
				<li><a{if $function eq 'user' && $secondary eq 'details'} class="selected" {/if} href="/user/profile">My Details</a></li>
				<li><a{if $function eq 'user' && $secondary eq 'portfolio'} class="selected" {/if} href="/user/portfolio">Portfolio</a></li>
				<li><a{if $function eq 'user' && $secondary eq 'polaroids'} class="selected" {/if} href="/user/polaroids">Polaroids</a></li>
				{else}
				<li data-balloon-pos="right" data-balloon-length="medium" data-balloon="We need to know you {$verifyfails} before we can verify your account"><a href="/user/verify">Verify Your Account</a></li>
				<li><a{if $function eq 'user' && $secondary eq 'details'} class="selected" {/if} href="/user/profile">My Details</a></li>
				<li><a{if $function eq 'user' && $secondary eq 'portfolio'} class="selected" {/if} href="/user/portfolio">Portfolio</a></li>
				<li><a{if $function eq 'user' && $secondary eq 'polaroids'} class="selected" {/if} href="/user/polaroids">Polaroids</a></li>
				{/if}
				{/if}
				<li><a{if $function eq 'user' && $secondary eq 'details'} class="selected" {/if} href="/user/profile">My Details</a></li>
				<li><a{if $function eq 'user' && $secondary eq 'portfolio'} class="selected" {/if} href="/user/portfolio">Portfolio</a></li>
				<li><a{if $function eq 'user' && $secondary eq 'polaroids'} class="selected" {/if} href="/user/polaroids">Polaroids</a></li>
				<li><a{if $function eq 'user' && $secondary eq 'calendar'} class="selected" {/if} href="/user/calendar">Calendar</a></li>
				<li><a {if $function eq 'referrals'} class="selected" {/if} href="/referrals">Invite Friends</a></li>
			</ul>