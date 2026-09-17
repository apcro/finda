{* client menu *}
{if $userStatus eq 0}
<li><a href="/dashboard">Dashboard</a>
<li><a href="/support" class="primary payments{if $function eq 'support'} selected{/if}"><i class="fas fa-question-circle text-center" style="font-size: 120%;"></i></a></li>
{else}
{* <li><a href="/dashboard/updates" data-badge="{$unread_messages}" class="primary msgnotifications{if $function eq 'dashboard' && $secondary eq 'updates'} selected{/if}" style="margin-right: 0.5em;"><i class="far fa-envelope text-center" style="font-size: 120%;"></i></a></li> *}
<li><a href="/dashboard">Dashboard</a>
<li><a href="/search"{if $function eq 'search'} class="selected"{/if}>Talent</a></li>
{* <li><a href="/projects"{if $function eq 'projects'} class="selected"{/if}>Bookings</a></li> *}
<li><a href="/dashboard/assignments"{if $function eq 'dashboard' && $secondary eq 'assignments'} class="selected"{/if}>Assignments</a></li>
<li><a href="/dashboard/invoices" data-badge="{$invoicecount}" class="primary invoicecount{if $function eq 'dashboard' && $secondary eq 'invoices'} selected{/if}">Payments</a></li>
<li><a href="/support" class="primary payments{if $function eq 'support'} selected{/if}"><i class="fas fa-question-circle text-center" style="font-size: 120%;"></i></a></li>
{/if}