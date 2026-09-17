<?php
/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
namespace Croissant;
// @TODO
// Use a more complete email validation regex
// Add modifiers, ie. an array of extra characters that can be provided as a param and added to the validation regex

class Validation {

	/**
	 * Data validation
	 * @param array $data - the data to validate
	 * @param array $validators - the validators to use against each datum
	 *  provide validators in the form: array( "fieldname" => array("validatorname", "anothervalidatorname", array("match", "fieldname")) );
	 */
	public static function Validate($data = array(), $validators = array())
	{
		$valid = array(
			"result" => 1,
			"invalidfields" => array()
		);
		foreach ($data as $field => $value) {
			if (!empty($validators) && isset($validators[$field])) {
				$validInput = array();
				foreach ($validators[$field] as $validator) {
					switch(true) {
						case $validator == "required":
							$validInput[] = self::required($value);
							break;
						case $validator == "alpha":
							$validInput[] = self::alpha($value);
							break;
						case $validator == "alpha+":
						case $validator == "alphaplus":
							$validInput[] = self::alphaplus($value);
							break;
						case $validator == "alphanumeric":
							$validInput[] = self::alphanumeric($value);
							break;
						case $validator == "alphanumeric+":
						case $validator == "alphanumericplus":
							$validInput[] = self::alphanumericplus($value);
							break;
						case $validator == "numeric":
							$validInput[] = self::numeric($value);
							break;
						case $validator == "pswdlength":
							$validInput[] = self::pswdlength($value);
							break;	
						case $validator == "numeric+":
						case $validator == "numericplus":
							$validInput[] = self::numericplus($value);
							break;
						case $validator == "email":
							$validInput[] = self::email($value);
							break;
						case $validator == "phone":
							$validInput[] = self::phone($value);
							break;
						case is_array($validator):
							//match
							if (isset($validator['match'])) {
								$validInput[] = self::match($value, $data[$validator['match']]);
							}
							//function call
							elseif (isset($validator['function'])) {
								$validInput[] = self::functioncall($value, $validator['function']);
							}
							//custom regex
							elseif (isset($validator['custom'])) {
								$validInput[] = self::custom($value, $validator['custom']);
							}
							break;
					}

				}
				if (in_array(false,$validInput)) {
					$valid['invalidfields'][] = $field;
					$valid['result'] = 0;
				}
			}
		}

		return $valid;
	}

	/**
	 * Checks that a value is set, not null, and not empty
	 * @param string $value
	 * @return int
	 */
	private static function required($value)
	{
		return (isset($value) && ($value != null) && ($value != "")) ? true : false;
	}

	/**
	 * Checks that a value contains only alphabetic chars
	 * @param string $value
	 * @return int
	 */
	private static function alpha($value)
	{
		return (bool)preg_match('/^[a-zA-Z]+$/',$value);
	}
	/**
	 * Checks that a value contains only alphabetic chars
	 * @param string $value
	 * @return int
	 */
	private static function pswdlength($value)
	{
		return (strlen(trim($value))>7 && strlen(trim($value))<25) ? true : false;
	}
	/**
	 * Checks that a value contains only alphabetic characters, whitespace characters, underscores, and hyphens
	 * @param string $value
	 * @return int
	 */
	private static function alphaplus($value)
	{
		return (bool)preg_match('/^[\w\s\D -]+$/',$value);
	}

	/**
	 * Checks that a value contains only alphabetic and numerical characters
	 * @param string $value
	 * @return int
	 */
	private static function alphanumeric($value)
	{
		return (bool)preg_match('/^[a-zA-Z0-9]+$/',$value);
	}

	/**
	 * Checks that a value contains only alphabetic characters, numerical characters, whitespace characters, underscores, and hyphens
	 * @param string $value
	 * @return int
	 */
	private static function alphanumericplus($value)
	{
		return (bool)preg_match('/^[\w\s\d -]+$/',$value);
	}

	/**
	 * Checks that a value contains only numerical characters
	 * @param string $value
	 * @return int
	 */
	private static function numeric($value)
	{
		return (bool)preg_match('/^[0-9]+$/',$value);
	}

	/**
	 * Checks that a value contains only numerical characters, whitespace, underscores, and hyphens
	 * @param string $value
	 * @return int
	 */
	private static function numericplus($value)
	{
		return (bool)preg_match('/^[\d\s _-]+$/',$value);
	}

	/**
	 * Checks that a value is a valid email address (does not cover ALL possible emails, needs expanding)
	 * @param string $value
	 * @return int
	 */
	private static function email($value)
	{
		return (bool)preg_match("/^([\'A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$/", $value);
	}

	/**
	 * Checks that a value is a valid north american phone number
	 * @param string $value
	 * @return int
	 */
	private static function phone($value)
	{
		return (bool)preg_match('/^((([0-9]{1})*[- .(]*([0-9]{3})[- .)]*[0-9]{3}[- .]*[0-9]{4})+)*$/', $value);
	}

	/**
	 * Checks that a value is equal to another value
	 * @param string $value
	 * @param string $matchingValue - the value to compare to
	 * @return int
	 */
	private static function match($value, $matchingValue)
	{
		return ($value == $matchingValue) ? true : false;
	}

	/**
	 * Calls a specific function to validate a value
	 * @param string $value
	 * @param array $function - should contain 3 keys:
	 *  class, the class where the function is,
	 *  function, the name of the function,
	 *  extraParams, any extra params to pass to the function (an array)
	 * @return bool (casts whatever the function returns to a bool)
	 */
	private static function functioncall($value, $function)
	{
		$params = array($value);
		if (isset($function['extraParams']) && !empty($function['extraParams'])) {
			foreach ($function['extraParams'] as $param) {
				$params[] = $param;
			}
		}
		return (bool)call_user_func_array(array($function['class'], $function['function']), $params);
	}

	/**
	 * Check that a value matches a custom regex
	 * @param string $value
	 * @param string $regex
	 * @return int
	 */
	private static function custom($value, $regex)
	{
		return (bool)preg_match($regex, $value);
	}

}