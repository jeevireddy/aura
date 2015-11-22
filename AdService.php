<?php
ini_set("error_reporting", E_ALL); 
ini_set("display_errors", 1); 

$con = mysqli_connect("us-cdbr-iron-east-03.cleardb.net","bee1e683ba77e3","ad803f31","ad_463a2c81da5e2c0");
if ( mysqli_connect_errno($con))
{
	echo "Failed to connect to MySQL: " . mysqli_connect_error();
}

/* call stored procedure with out any parameters*/
$sql = "call ad_463a2c81da5e2c0.splitChatStringFinal();";
$result = $con->query($sql);


$sql = "select linkurl from adText order by add_ts desc limit 1;";
$result1 = $con->query($sql);

if (!$result1) {
	echo "Could not successfully run query ($sql) from DB: " . $con->error;
	exit;
}

if (mysqli_num_rows($result1) == 0) {
	echo "us>http://www.verizon.com";
	exit;
}

while ($row = mysqli_fetch_array($result1)) 
{		
	$table =$row[0];
}


echo  $table;

mysqli_close($con);

?>
