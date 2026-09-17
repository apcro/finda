{if $userid eq 0 || $userstatus eq 0}
{include file="faq_general.tpl"}
{else}
{if $usertype eq 1}
{include file="faq_model.tpl"}
{else}
{include file="faq_client.tpl"}
{/if}
{/if}