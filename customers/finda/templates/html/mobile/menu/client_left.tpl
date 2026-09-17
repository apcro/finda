{if $user_status neq 0}<li><a href="/projects/create"><i class="fas fa-calendar"></i>Create Project</a></li>{/if}
<li><a href="/user/profile"><i class="fas fa-user"></i>My Details</a></li>
{if $user_status neq 0}<li><a href="/invoices"><i class="fas fa-file-invoice"></i>Invoices</a></li>{/if}
{* if $userStatus eq 0}<li>
{if $canverify}
<a href="/user/verify"><i class="fas fa-check"></i>Verify</a></li>
{else}
<li><a><i class="fas fa-check"></i>Verify Your Account</a></li>
{/if}
{/if *}

