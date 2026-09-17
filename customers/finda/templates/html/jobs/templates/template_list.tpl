<ul>
	<li class="addnew" data-templateid="0">Add New Template</li>
	<li>&nbsp;</li>
	{foreach from=$jobtemplates item=template}
	<li class="templatename" data-templateid="{$template.id}">{if $template.template_name neq ''}{$template.template_name}{else}Unnamed Template{/if}</li>
	{/foreach}
</ul>