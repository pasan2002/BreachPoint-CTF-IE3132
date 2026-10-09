<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');

// WARNING: No authentication – OWASP API3 violation
$response = [
    "users" => [
        [
            "id"       => 1,
            "username" => "admin",
            "email"    => "admin@novatech.lk",
            "role"     => "administrator",
            "password" => "N0v4T3ch@dm1n"
        ]
    ],
    "flag"  => "BPCTF{4p1_3xp0sur3_l34ks_cr3ds}",
    "total" => 1
];

echo json_encode($response, JSON_PRETTY_PRINT);