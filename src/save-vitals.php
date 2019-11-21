<?php

$whitelist = ["CAR_VIN_GOES_HERE"];

$newData = "window.Tesla={newVitals:{connect:async function(t){const n=await fetch('vitals.json');t(await n.text())}}};";

// Just a preventative measure
if (empty($_GET['vin']) || !in_array($_GET['vin'], $whitelist)) exit;

function isJson($string)
{
    json_decode($string);
    return (json_last_error() == JSON_ERROR_NONE);
}

// Update vital html & js
if (isset($_GET['updateVitals'])) {
    $fileName = 'vitals.tar.gz';

    $input = @file_get_contents('php://input');
    if (empty($input)) {
        exit;
    }

    $handle = fopen($fileName, 'w');
    fwrite($handle, $input);
    fclose($handle);

    $file = realpath($fileName);
    $path = pathinfo($file, PATHINFO_DIRNAME);
    $zipFile = str_replace('.tar.gz', '.zip', $file);

    // Creates .tar
    $p = new PharData($file, RecursiveDirectoryIterator::SKIP_DOTS);
    $p->convertToData(Phar::ZIP);
    $zip = new ZipArchive;
    $res = $zip->open($zipFile);
    if ($res === TRUE) {
        $zip->extractTo($path);
        $zip->close();
    }

    unlink($file);
    unlink($zipFile);

    // Fix vitals fetcher
    file_put_contents($path . '/assets/vehicle_vitals.js', $newData, FILE_APPEND | LOCK_EX);
    exit;
} else {
    $input = @file_get_contents('php://input');

    // Make sure there is actually data
    if (!empty($input) && isJson($input)) {
        // Write file being sent to vitals.json
        $file = 'vitals.json';
        $handle = fopen($file, 'w');
        fwrite($handle, $input);
        fclose($handle);

        $sum = md5_file('assets/vehicle_vitals_layout.js');
        echo $sum;
    }
}
