<p style="text-align: center; margin: 0; direction: ltr; color: #000000; line-height: 1.2; font-family: Arial, 'Helvetica Neue', Helvetica, sans-serif; font-size: 14px; mso-line-height-alt: 17px;"><span style="font-size: 14px;"><strong>{if $job.jobtype_name neq ''}{$job.jobtype_name|upper} | {/if}{$job.name}</strong></span></p>
<p style="text-align: center; margin: 0; direction: ltr; color: #000000; line-height: 1.2; font-family: Arial, 'Helvetica Neue', Helvetica, sans-serif; mso-line-height-alt: NaNpx;"></p>
<p style="text-align: center; margin: 0; direction: ltr; color: #000000; line-height: 1.2; font-family: Arial, 'Helvetica Neue', Helvetica, sans-serif; font-size: 14px; mso-line-height-alt: 17px;"><span style="font-size: 14px;">Date: {$job.startdate|date_format:"%d/%m/%Y"}</span></p>
<p style="text-align: center; margin: 0; direction: ltr; color: #000000; line-height: 1.2; font-family: Arial, 'Helvetica Neue', Helvetica, sans-serif; font-size: 14px; mso-line-height-alt: 17px;"><span style="font-size: 14px;">Start Time: {$job.starttime|date_format:"%I:%M%p"}</span></p>
{if $job.location neq ''}
<p style="text-align: center; margin: 0; direction: ltr; color: #000000; line-height: 1.2; font-family: Arial, 'Helvetica Neue', Helvetica, sans-serif; font-size: 14px; mso-line-height-alt: 17px;"><span style="font-size: 14px;">Location: {$job.location}</span></p>
{/if}
{if $job.jobtype_name neq 'casting'}
<p style="text-align: center; margin: 0; direction: ltr; color: #000000; line-height: 1.2; font-family: Arial, 'Helvetica Neue', Helvetica, sans-serif; font-size: 14px; mso-line-height-alt: 17px;"><span style="font-size: 14px;">Rate: £{$agreed_rate|number_format:2:".":","}</span></p>
<p style="text-align: center; margin: 0; direction: ltr; color: #000000; line-height: 1.2; font-family: Arial, 'Helvetica Neue', Helvetica, sans-serif; font-size: 14px; mso-line-height-alt: 17px;"><span style="font-size: 14px;">You make: £{($agreed_rate*0.9)|number_format:2:".":","}</span></p>
{/if}
<p style="margin: 0; direction: ltr; color: #000000; line-height: 1.2; font-family: Arial, 'Helvetica Neue', Helvetica, sans-serif; mso-line-height-alt: 0px;"></p>
<p style="text-align: center; margin: 0; direction: ltr; color: #000000; line-height: 1.2; font-family: Arial, 'Helvetica Neue', Helvetica, sans-serif; font-size: 14px; mso-line-height-alt: 17px;"><span style="font-size: 14px;"><strong>A copy of the booking terms is attached to this email.</strong></span></p>
