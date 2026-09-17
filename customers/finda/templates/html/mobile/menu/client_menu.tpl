{* client menu *}
{* <li><a href="/user">Dashboard</a></li> *}
{if $userStatus eq 0}
{if $canverify}
<li><a href="/user/verify"><i class="fas fa-check"></i>Verify Your Account</a></li>
{else}
<li><a href="/user/verify"><i class="fas fa-check"></i>Verify Your Account</a></li>
{/if}
{else}
<li><a href="/projects"><i class="fas fa-calendar-alt"></i>Projects</a></li>
<li><a href="/updates" data-badge="{$unread_messages}" class="badge primary msgnotifications"><i class="fas fa-envelope"></i>Updates</a></li>
<li><a href="/search"><i class="fas fa-users"></i>Find a model</a></li>
{/if}