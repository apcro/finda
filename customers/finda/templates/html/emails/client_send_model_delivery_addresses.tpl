Thank you for booking with iDAL!

On your recent Influencer job {$job.name}, you worked with the following models and asked for their delivery address. The details are included below.

{foreach from=$job.models item=model}
{$model.firstname} {$model.lastname}
==============================================================================================
Product Delivery Address:
-------------------------
{$model.delivery_address}

--
{/foreach}

Regards,
Team iDAL