{* client menu *}
{if $userStatus eq 0}
{if $canverify}
<li><a href="/user/verify">Verify Your Account</a></li>
{else}
<li data-balloon-pos="down" data-balloon-length="medium" data-balloon="We also need to know you {$verifyfails} before we can verify your account"><a href="/user/verify">Verify Your Account</a></li>
{/if}
{else}
<li><a href="/updates" data-badge="{$unread_messages}" class="primary msgnotifications{if $function eq 'updates'} selected{/if}" style="margin-right: 0.5em;"><i class="far fa-envelope text-center" style="font-size: 120%;"></i></a></li>
<li><a href="/search"{if $function eq 'search'} class="selected"{/if}>Talent</a></li>
<li><a href="/projects"{if $function eq 'projects'} class="selected"{/if}>Bookings</a></li>
<li><a href="/howto"{if $function eq 'howto'} class="selected"{/if}>How it Works</a></li>
<li><a href="/user/profile"{if $function eq 'user' && $secondary eq 'details'} class="selected"{/if}>My Details</a></li>
<li><a href="/invoices" data-badge="{$invoicecount}" class="primary invoicecount{if $function eq 'invoices'} selected{/if}">Payments</a></li>
<li><a href="/support" class="primary payments{if $function eq 'support'} selected{/if}"><i class="fas fa-question-circle text-center" style="font-size: 120%;"></i></a></li>
{/if}