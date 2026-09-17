<?php
/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
/**
 * 
 * User Session data configuration
 * Defines keys used in the user session object, retrieved by User::Login() and used in Session::Start()
 * Should match the data keys returned from the database, but reassignment is available
 * 
 * if the key is an array, the following subkeys are available:
 * - type: defines the data type for explicit typecasting on storage, either 'int' or 'string'
 * - name: new keyname to store data against. May be duplicated
 */

namespace Croissant;

Core::$core->_user_session = array(
		'id',		// required
		'imageid',
		'mail',
		'username',
		'firstname',
		'lastname',
		'modified',
		'username',
		'avatar',
		'avatar_status',
		'usertype',
		'available',
		'sefu',
		
		// required for payment processing
		'nationality',
		'dob',
		'residence_country',

		// optional for models
		'gender',
		'age',
		'ethnicity',
		'instagram_username',
		'instagram_followers',
		
		// optional for agents
		'occupation',
		'company_name',
		'company_website',
		
		// status flag for all users
		'status',
		
		// for Stripe
		'stripe_id',
		
		// for referrers
		'referrer_code',
	
		// are they a founding member?
		'is_founding_member',
	
		// can this user (client) pay by invoice?
		'allow_invoice',
	
		// associated company ID
		'companyid',
	
		'mother_agency',

	);

