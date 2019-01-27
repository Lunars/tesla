<?php

// Usage: file.php?s1=FirstToken&s2=SecondToken&car=YourCarName

class TeslaKeys

{
    var $filename = '.tesla_tokens.json';
    function __construct()
    {
        if (!file_exists($this->filename)) {
            $fh = fopen($this->filename, 'w') or die("Can't create file");
        }

        if (empty($_GET['s1']) || empty($_GET['s2'])) {
            $this->showLastKey();
        }
        else {
            $this->saveKeys();
        }
    }

    function showLastKey()
    {
        $str_data = file_get_contents($this->filename);
        $decoded = json_decode($str_data);
        if (!empty($_GET['car'])) {
            $decoded->tokens = array_filter((array) $decoded->tokens,
            function ($v)
            {
                return $v->car === $_GET['car'];
            });
        }

        if (!empty($decoded)) {
            $last = end($decoded->tokens);
            if ($last) {
                $last->saved_date = date('Y-m-d G:i', $last->saved_date);
            }

            header('Content-Type: application/json');
            echo json_encode($last, JSON_PRETTY_PRINT);
            exit;
        }
    }

    function saveKeys()
    {
        $str_data = file_get_contents($this->filename);
        $decoded = json_decode($str_data, true);
        if (empty($decoded)) $decoded = [];
        if (empty($decoded['tokens'])) $decoded['tokens'] = [];

        // Remove duplicate tokens, in case the cron runs often

        $decoded['tokens'] = array_filter($decoded['tokens'],
        function ($v)
        {
            return $v['tesla1'] != $_GET['s1'] && $v['tesla2'] != $_GET['s2'];
        });
        $newTokens = ['tesla1' => $_GET['s1'], 'tesla2' => $_GET['s2'], 'saved_date' => strtotime('now') ];
        if (!empty($_GET['car'])) {
            $newTokens['car'] = $_GET['car'];
        }
        if (!empty($_GET['unlock_token'])) {
            $newTokens['unlock_token'] = $_GET['unlock_token'];
        }

        array_push($decoded['tokens'], $newTokens);

        // format the data

        $formattedData = json_encode($decoded);

        // open or create the file

        $handle = fopen($this->filename, 'w+');

        // write the data into the file

        fwrite($handle, $formattedData);

        // close the file

        fclose($handle);

 	   	echo strlen($str_data) !== strlen($formattedData) ? 'New keys saved.' : 'These keys already exist. No changes made.';
    }
}

new TeslaKeys();
