<?php

function isJson($string) {
    json_decode($string);
    return (json_last_error() == JSON_ERROR_NONE);
}

// Write file being sent to vitals.json
$upload_file = 'vitals.json';
$handle = fopen($upload_file, 'w');
$input = @file_get_contents('php://input');

// Make sure there is actually data
if (!empty($input) && isJson($input)) {
    fwrite($handle, $input);
    fclose($handle);
}
