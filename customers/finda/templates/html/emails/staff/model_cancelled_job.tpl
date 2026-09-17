A Model cancelled a Job
==========================  

{$model.firstname} {$model.lastname} cancelled the following job:


Job Details
============
Client: {$job.client_firstname} {$job.client_lastname} ({$job.company_name}).
Job Name: {$job.name} 
Description: {$job.description} 
Location: {$job.location} 
Job Type: {$job.jobtype_name} 
For: {$job.time_units} {$job.units_type}{if $job.time_units neq 1}s{/if} 
On: {$job.startdate|date_format:"%d-%m-%Y"} at {$job.starttime|date_format:"%I:%M %p"} 
Models: {$job.modelcount} 
Rate: {if $job.altrate neq ''}{$job.altrate}{else}{$job.offered_rate}{/if} 
Total value: {$job.total_value} 
  
Technical Details 
=================  
Job ID: {$job.id} 
Client ID: {$job.client_uid} 
Created on: {$job.created|date_format:"%d-%m-%Y"} at {$job.created|date_format:"%I:%M %p"}