<?php 
ini_set("error_reporting", E_ALL); 
ini_set("display_errors", 1); 

function nullif($var){ 
 	if(isset($var) && !empty($var)) 
 	{ 
 	return $var;	 
 	} 
 	else {return null;} 
 
 } 
 
 $con=mysqli_connect("us-cdbr-iron-east-03.cleardb.net","bee1e683ba77e3","ad803f31","ad_463a2c81da5e2c0");
 if (mysqli_connect_errno($con))
 {
 	echo "Failed to connect to MySQL: " . mysqli_connect_error();
 }
 $sql = "INSERT INTO  tbl_chathistory (Chat,Account_id,chat_ts,Latitude,Longitude) VALUES ('"	.nullif($_POST["Chat"])."',222115,sysdate(),40.91709,-72.709457)";
 						if (!mysqli_query($con,$sql))
 						{
 							die('Error: ' . mysqli_error($con));
 						}
 						echo "1 record added";
 						mysqli_close($con);
 

 ?>