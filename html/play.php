<?php
$uri = $_GET["uri"];
exec("mpc stop; mpc clear; mpc add '$uri'; mpc play");
?>
