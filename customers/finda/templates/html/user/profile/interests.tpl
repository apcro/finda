<p>Use the form below to edit your interests. Your interests are used to tailor the content you see on the site specifically for you.</p>
<form name="form_interests" id="form_interests" method="post" action="/user/profile/interests">
	<input type="hidden" name="interests_form" value="1"/>
{*	<span>
		<label class="required">School District</label><br />
		<input type="hidden" value="{$school_districtsvid}" name="interests_school_districts_vid"/>
		<select name="interests_school_district" id="interests_school_district">
			<option>-- Select District --</option>
			{foreach $school_districts as $school_district}
			<option value="{$school_district.tid}" {if in_array($school_district.tid,$interests)}selected="selected"{/if}>{$school_district.name}</option>
			{/foreach}
		</select>
	</span>
	<span {if !isset($schools)}class="hidden"{/if} id="schools">
		<label class="required">School Name</label><br />
		<input type="hidden" value="{$schoolsvid}" name="interests_schools_vid"/>
		{if isset($schools)}
		<select name="interests_school" id="interests_school">
		{foreach $schools as $school}
			<option value="{$school.tid}" {if in_array($school.tid,$interests)}selected="selected"{/if}>{$school.name}</option>
		{/foreach}
		</select>
		{/if}
	</span>
	<span>
		<label class="required">School Type</label><br />
		<input type="hidden" value="{$school_typesvid}" name="interests_school_types_vid"/>
		<select name="interests_school_type" id="interests_school_type">
			<option>-- Select Type --</option>
			{foreach $school_types as $school_type}
			<option value="{$school_type.tid}" {if in_array($school_type.tid,$interests)}selected="selected"{/if}>{$school_type.name}</option>
			{/foreach}
		</select>
	</span> *}

    <span style="display:none;">
		<label class="required">Main role</label><br />
		<input type="hidden" value="{$rolesvid}" name="interests_roles_vid"/>
		<select name="interests_main_role" id="interests_main_role">
			<option value="0" disabled="disabled">-- Select role --</option>
			{foreach $roles as $role}
			<option value="{$role.tid}" {if in_array($role.tid,$interests)}selected="selected"{/if}>{$role.name}</option>
			{/foreach}
		</select>
	</span>
	<span>
		<label class="required">Additional roles</label><br />
		{foreach $roles as $role}
        
        	{if $role.name|lower eq 'cpd leader' or $role.name|lower eq 'governor' or $role.name|lower eq 'senco' or $role.name|lower eq 'school based mentor'}
            
			<span class="checkbox {if in_array($role.tid, $interests)}selected{/if}" data-value="{$role.tid}"><input type="checkbox" {if in_array($role.tid, $interests)}checked="checked"{/if}/> {$role.name}</span>
            
            {/if}
            
		{/foreach}
		<select multiple="multiple" class="hidden" name="interests_additional_roles[]" id="interests_additional_roles">
			{foreach $roles as $role}
			<option id="{$role.tid}" value="{$role.tid}" {if in_array($role.tid,$interests)}selected="selected"{/if}>{$role.name}</option>
			{/foreach}
		</select>
		<span class="selections"></span>
	</span>
    
    {*
	<span>
		<label class="required">Stages</label><br />
		<input type="hidden" value="{$gradesvid}" name="interests_grades_vid"/>
		{foreach $grades as $grade}
			<span class="checkbox {if in_array($grade.tid, $interests)}selected{/if}" data-value="{$grade.tid}"><input type="checkbox" {if in_array($grade.tid, $interests)}checked="checked"{/if}/> {$grade.name}</span>
		{/foreach}
		<select multiple="multiple" class="hidden" name="interests_grades[]" id="interests_grades">
			{foreach $grades as $grade}
			<option id="{$grade.tid}" value="{$grade.tid}" {if in_array($grade.tid,$interests)}selected="selected"{/if}>{$grade.name}</option>
			{/foreach}
		</select>
		<span class="selections"></span>
	</span>
    *}
    
	<span>
		<label class="required">Subjects</label><br />
		<input type="hidden" value="{$subjectsvid}" name="interests_subjects_vid"/>
        
		{foreach $subjects as $subject}
        
         {if $subject.name|lower neq 'ict' and $subject.name|lower neq 'ict curriculum' and $subject.name|lower neq 'international'}
        
			<span class="checkbox {if in_array($subject.tid, $interests)}selected{/if}" data-value="{$subject.tid}"><input type="checkbox" {if in_array($subject.tid, $interests)}checked="checked"{/if}/> {$subject.name}</span>
         
         {/if}
        
		{/foreach}
        
        
		<select multiple="multiple" class="hidden" name="interests_subjects[]" id="interests_subjects">
			{foreach $subjects as $subject}
			<option id="{$subject.tid}" value="{$subject.tid}" {if in_array($subject.tid,$interests)}selected="selected"{/if}>{$subject.name}</option>
			{/foreach}
		</select>
		<span class="selections"></span>
	</span>
	<span>
		<label class="required">Whole school issues</label><br />
		<input type="hidden" value="{$issuesvid}" name="interests_issues_vid"/>
		
        {foreach $issues as $issue}

        	{if $issue.name|lower neq 'ict across the school' and $issue.name|lower neq 'international'}
			
            <span class="checkbox {if in_array($issue.tid, $interests)}selected{/if}" data-value="{$issue.tid}"><input type="checkbox" {if in_array($issue.tid, $interests)}checked="checked"{/if} /> {$issue.name}</span>
            
            {/if}
            
		{/foreach}
        
        
		<select multiple="multiple" class="hidden" name="interests_issues[]" id="interests_issues">
			{foreach $issues as $issue}
			<option id="{$issue.tid}" value="{$issue.tid}" {if in_array($issue.tid,$interests)}selected="selected"{/if}>{$issue.name}</option>
			{/foreach}
		</select>
		<span class="selections"></span>
	</span>
	<div class="submit_button">
		<input class="button" type="submit" id="submit" value="Save Interests" />
	</div>
</form>