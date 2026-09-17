{* model menu *}
{* <li><a href="/user">Dashboard</a></li> *}
{if $userStatus eq 0}
{if $canverify}
<li><a href="/user/verify"><i class="fas fa-check"></i>Verify Your Account</a></li>
{else}
<li><a href="/user/verify"><i class="fas fa-check"></i>Verify Your Account</a></li>
{/if}
{else}
<li><a href="/jobs" data-badge="{$newoffers}" class="badge primary msgoffers"><i class="fas fa-camera"></i>Jobs</a></li>
<li><a href="/updates" data-badge="{$unread_messages}" class="badge primary msgnotifications{if $unread_messages neq 0} badge-highlight{/if}"><i class="fas fa-envelope"></i>Updates{$unread_messages}</a></li>
<li><a href="/payments" data-badge="{$new_payments}" class="badge primary payments"><i class="fas fa-piggy-bank"></i>Payments</a></li>
<li>&nbsp;</li>
{/if}
