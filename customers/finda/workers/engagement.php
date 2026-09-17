<?php
/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
namespace Croissant;

switch($args[0]) {
    case 'bloom':
        $formData = array();
        $formData['name'] = $name;
        $formData['email'] = $email;
        $formData['instagram'] = $instagram;
        $formData['address'] = $address;
        $formData['colour'] = $colour;
        $formData['privacy'] = $privacy;
        $response = ds('finda_StoreFlowerPerson', array('data' => $formData));
        if ($response['result']) {
            // send email to hello
            SendGrid::SendTimeToBloom($formData);
        }
        Core::JSONWrite($response['result']);
        break;
    default:
        break;
}
die();