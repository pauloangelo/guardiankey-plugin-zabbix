<?php
/* Dependencies: php-curl */

require_once("guardiankey.class.php");


    echo "Please enter admin email: ";
    $handle = fopen("php://stdin", "r");
    $email = trim(fgets($handle));

$GK = new guardiankey();

try {
    $GKReturn=$GK->register($email);
} catch (Exception $e) {
    echo $e->getMessage()."\n";
    exit;
}

if (@$_SERVER['SERVER_NAME']) {
    echo "<pre>";
}
$result =  '<?php
					$GKconfig = array(
					\'email\' => "' . $GKReturn["email"] . '",
					\'agentid\' => "' . $GKReturn["agentid"]  . '",
					\'key\' => "' . $GKReturn["key"]  . '",
					\'iv\' => "' . $GKReturn["iv"]  . '",
					\'orgid\' => "' . $GKReturn["orgid"]  . '",
					\'authgroupid\' => "' . $GKReturn["groupid"]  . '",
					\'service\' => "MyServiceName",
					\'reverse\' => "True",
					);'."\n";

file_put_contents('guardiankey/gk_register.php',$result);

