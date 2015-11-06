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
 

 $con=mysqli_connect("localhost","root","admin","cb1");
 if (mysqli_connect_errno($con))
 {
 	echo "Failed to connect to MySQL: " . mysqli_connect_error();
 }
 $sql = "INSERT INTO  tbl_chathistory (Chat,Account_id,TimeStamp,Latitude,Longitude) VALUES ('"	.nullif($_POST["Chat"])."',222115,sysdate(),40.91709,-72.709457)";
 						if (!mysqli_query($con,$sql))
 						{
 							die('Error: ' . mysqli_error($con));
 						}
 						echo "1 record added";
 						mysqli_close($con);
 

 ?>