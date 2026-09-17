/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
$().ready(function(){
    var $form = $('#form_accountdetails');
	var vaidation_path = $form.attr('data-validation');
    //setup form validation
    $form.validate({
	rules: {
		title: {
			required: true
		},
		register_name: {
			required: true,
			alphanumericstrict: true,
			minmumLength:6,
			maxLength:18,
			remote: vaidation_path + '?step=checkusername'
		},
		register_firstname: {
			required: true,
			letterswithbasicpunc: true
		},
		register_lastname: {
			required: true,
			letterswithbasicpunc: true
		},
		register_main_role: {
			required: true
		},
		job_title: {
			required: true
		},
		school_type: {
            required: true
        },
		school_name: {
            required: true,
			maxLength:60,
            alphanumericstrict: true
        },
		school_address: {
            required: true,
			maxLength:150,
            alphanumericstrict: true
        },
		uk_post_code: {
            required: true,
			minmumLength:5,
			maxLength:8,
            alphanumericstrict: true
        },
		country: {
			required: true
		},
		county: {
			required: true
		},
		school_phone: {
			required: true
		},
		username: {
			required: true,
			alphanumericstrict: true,
			minmumLength:6,
			maxLength:18/*,
			remote: vaidation_path + '?step=checkUname'*/
		},
		register_mail: {
			required: true,
			//email: true,
			properEmail: true,
			remote: vaidation_path + '?step=checkemail'
		},
		confirm_email: {
			required: true,
			equalTo: "input[name=register_mail]"
		},
		register_mail_val: {
			required: true,
			properEmail: true
		},
		confirm_email_val: {
			required: true,
			equalTo: "input[name=register_mail_val]"
		},
		register_pass: {
			required: true,
			minmumLength:8,
			maxLength:24/*,
			alphanumericstrict: true*/
		},
		register_pass_confirm: {
			required: true,
			minmumLength:8,
			maxLength:24,
			equalTo: "input[name=register_pass]"
		},
		register_telephone: {
			phoneUK: true
		},
		register_cellphone: {
			mobileUK: true
		},
		register_agree_terms: {
			required: true
		}
	},
	messages: {
		title: {
			required: "Please select a title"
		},
			
		register_name: {
			required: "Please provide a username",
			alphanumericstrict: "Please use only letters and numbers",
			minmumLength: "Please use only 6 to 18 digit username",
			maxLength:"Please use only 6 to 18 digit username",
			remote: "This username is already in use, please try another."
		},
		register_firstname: {
			required: "Please provide your first name",
			letterswithbasicpunc: "Please provide valid first name"
		},
		register_lastname: {
			required: "Please provide your last name",
			letterswithbasicpunc: "Please provide valid last name"
		},
		register_main_role: {
			required: "Please select Your role"
		},
		job_title: {
			required: "Please enter Job title"
		},
		school_type: {
			required: "Please select School/organisation type"
		},
		school_name: {
                required: "Please provide School/organisation name",
				maxLength: "School/organisation name should be 60 characters below",
                alphanumericstrict: "Please use only letters and numbers"
            },
			school_address: {
				required: "Please provide School/organisation address",
				maxLength: "School/organisation address should be 150 characters below",
                alphanumericstrict: "Please use only letters and numbers"
            },
			uk_post_code: {
				required: "Please provide Post code",
				minmumLength: "Post code should be at least 5 characters long",
				maxLength: "Post code should not be longer than 8 characters",
                alphanumericstrict: "Please use only letters and numbers"
            },
		country: {
			required: "Please select your country"
		},
		county: {
			required: "Please select your local authority"
		},
		school_phone: {
			required: "Please provide phone number"
		},
		username: {
			required: "Please enter username",
			alphanumericstrict: "Please enter a valid username",
			minmumLength: "Please enter a valid username",
			maxLength: "Please enter a valid username"/*,
			remote: "This username is already in use, please use an alternative"*/
		},
		register_mail: {
			required: "Please provide your email address",
			//email: "Please provide valid email address",
			properEmail: "Please provide valid email address",
			remote: "Email address already in use"
		},
		confirm_email: {
			required: "Please provide your email address",
			equalTo: "Email addresses do not match"
		},
		register_mail_val: {
			required: "Please provide your email address",
			properEmail: "Please provide valid email address"
		},
		confirm_email_val: {
			required: "Please provide your email address",
			equalTo: "Email addresses do not match"
		},
		register_pass: {
			required: "Please enter a password"
		},
		register_pass_confirm: {
			required: "Please enter confirm password",
			equalTo: "Passwords do not match"
		},
		register_telephone: {
			phoneUK: "Please provide a valid UK phone number"
		},
		register_cellphone: {
			mobileUK: "Please provide a valid UK mobile number"
		},
		register_agree_terms: {
			required: "You must accept the terms and conditions in order to continue"
			}
	}/*,
    submitHandler: function() {
       // do other things for a valid form
       $('#form_accountdetails').submit();
    }
	,
  	submitHandler: function() { closeIframe(); }*/
    })
    
    //if there is existing data, try to validate it straight away to display errors
   if (window.retry) {
        $form.valid();
        window.setTimeout(function(){
            $form.valid();
        }, 1000)
    }

		
});
