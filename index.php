<?php
require_once 'Menu.php';

$sessionId   = $_POST['sessionId']   ?? '';
$phoneNumber = $_POST['phoneNumber'] ?? '';
$text        = $_POST['text']        ?? '';

$menu = new Menu($text, $sessionId, $phoneNumber);
$text = $menu->middleware($text);

if ($text === "") {
    $menu->mainMenu();
} else {
    $parts       = explode("*", $text);
    $firstOption = (int)$parts[0];

    switch ($firstOption) {
        case 1:
            $menu->flowEventServices($parts);
            break;
        case 2:
            $menu->flowMomoServices($parts);
            break;
        case 3:
            $menu->flowSupport($parts);
            break;
        default:
            echo "END Invalid option.";
            exit;
    }
}
