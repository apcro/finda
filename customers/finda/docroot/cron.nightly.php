<?php
/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */

// called once per day at 1am by the CRON system

namespace Croissant;

error_reporting(0);
require_once(__DIR__.'/../configuration/configuration.php');

// payments settlement
FindaCron::SettlePastProjects();

die();
