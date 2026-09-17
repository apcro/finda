{* model menu *}
{if $userStatus eq 0}
{if $canverify}
<li><a href="/user/verify">Verify Your Account</a></li>
<li><a href="/user/profile"{if $function eq 'user' && $secondary eq 'details'} class="selected"{/if}>My Details</a></li>
{else}
<li data-balloon-pos="down" data-balloon-length="medium" data-balloon="We need to know your {$verifyfails} before we can verify your account"><a href="/user/verify">Verify Your Account</a></li>
<li><a href="/user/profile"{if $function eq 'user' && $secondary eq 'details'} class="selected"{/if}>My Details</a></li>
{/if}
{else}
<li><a href="/updates" class="primary msgnotifications{if $function eq 'updates'} selected{/if}" style="margin-right: 0.5em;"><i class="far fa-envelope text-center" style="font-size: 120%;"></i></a></li>
<li><a href="/jobs" data-badge="{$newoffers}" class="primary msgoffers{if $function eq 'jobs'} selected{/if}"{if $function eq 'offers'} class="selected"{/if}>Jobs</a></li>
<li><a href="/payments" class="primary payments{if $function eq 'payments'} selected{/if}">Payments</a></li>
<li><a href="/user/profile"{if $function eq 'user' && $secondary eq 'details'} class="selected"{/if}>My Details</a></li>
<li><a href="#podcast" class="podcast" rel="nofollow">iDAL Voice</a></li>
<li><a href="https://www.facebook.com/groups/idal.co/" target="_blank" rel="nofollow">Community</a></li>
{* <li><a href="/support" class="primary payments{if $function eq 'support'} selected{/if}">Support</a></li>
<li><a href="/user/calendar" class="{if $function eq 'user' && $secondary eq 'calendar'}selected{/if}"><i class="fas fa-calendar text-center" style="font-size: 120%;"></i></a></li>
<li><a href="/updates" class="primary msgnotifications{if $function eq 'updates'} selected{/if}"><i class="fas fa-bell text-center" style="font-size: 120%;"></i></a></li> *}
<li><a href="/user/calendar" class="{if $function eq 'user' && $secondary eq 'calendar'}selected{/if}">Calendar</a></li>
<li><a href="/support" class="primary payments{if $function eq 'support'} selected{/if}"><i class="fas fa-question-circle text-center" style="font-size: 120%;"></i></a></li>
<li>&nbsp;</li>
{*
<li class="dropdown"><a>Guidebook</a>
	<ul>
		<li><a href="/guidebook/a-little-guidebook-how-to-get-started">How to get started</a></li>
		<li><a href="/guidebook/a-little-guidebook-nail-the-polaroid-game">How to take the best polaroids yourself</a></li>
		<li><a href="/guidebook/how-to-create-a-drop-dead-gorgeous-portfolio-on-finda">Create An Impressive Online Portfolio</a></li>
	</ul>
</li> 
*}
{/if}
