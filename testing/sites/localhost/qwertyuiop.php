<?php

// Super simple test script, we just check that we're not massively broken.

// Keep a list of success and fail.
$success = array();
$fail = array();


// 1. Test that we correctly installed some key PHP extensions.
$extensions = array(
  // Parrot installed extensions.
  'curl',
  'mysqli',
  'pdo',
  'xdebug',
  'xmlrpc',
  'soap',

  // Drupal 7 required extensions
  'date',
  'dom',
  'filter',
  'gd',
  'hash',
  'json',
  'pcre',
  'pdo',
  'session',
  'SimpleXML',
  'SPL',
  'xml',

);

// We are not able to install xhprof for PHP7 yet.
if (PHP_MAJOR_VERSION < 7) {
  $extensions[] = 'xhprof';
}
foreach ($extensions as $extension) {
  if (extension_loaded($extension)) {
    $success[] = 'Extension: ' . $extension . ' is loaded.';
  }
  else {
    $fail[] = 'Extension: ' . $extension . ' is NOT loaded.';
  }
}

// 2. Try connecting to the default installed parrot DB.
try {
  # MySQL with PDO_MYSQL
  $DBH = new PDO("mysql:host=localhost;dbname=parrot", 'root', 'root');
  $success[] = 'Connected to Parrot DB via PDO MySQL.';
}
catch(PDOException $e) {
  $fail[] = 'Failed to connect to Parrot DB via PDO MySQL.';
}


// Print the results.
if (!empty($fail)) {
  http_response_code(500);
  print "Failures:\n" . implode("\n", $fail) . "\n\n";
}

if (!empty($success)) {
  print "Successes:\n" . implode("\n", $success) . "\n\n";
}
