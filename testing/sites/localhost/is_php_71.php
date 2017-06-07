<?php

// Super simple test script, just asserts a specific PHP version.

// Keep a list of success and fail.
$success = array();
$fail = array();

if (PHP_MAJOR_VERSION == 7 && PHP_MINOR_VERSION == 1) {
  $success[] = 'Found PHP 7.1';
}
else {
  $fail[] = 'Expected PHP 7.1, found ' . PHP_MAJOR_VERSION . '.' . PHP_MINOR_VERSION;
}

// Print the results.
if (!empty($fail)) {
  http_response_code(500);
  print "Failures:\n" . implode("\n", $fail) . "\n\n";
}

if (!empty($success)) {
  print "Successes:\n" . implode("\n", $success) . "\n\n";
}
