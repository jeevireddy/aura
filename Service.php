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
 
 function clean($string) 
 {
   $string = str_replace('\n', '', $string);
   return preg_replace("/[^ \w]+/", "", $string);
   //return preg_replace('/[^A-Za-z0-9\-]/', '', $string); // Removes special chars.
 }
 
 $con = mysqli_connect("us-cdbr-iron-east-03.cleardb.net","bee1e683ba77e3","ad803f31","ad_463a2c81da5e2c0");
 if (mysqli_connect_errno($con))
 {
 	echo "Failed to connect to MySQL: " . mysqli_connect_error();
 }
 
 
 
 $sql = " INSERT INTO  tbl_chathistory (Chat,Account_id,chat_ts,Latitude,Longitude,user_id,chat_group) VALUES ('".clean(nullif($_POST["Chat"]))."',222115,sysdate(),40.91709,-72.709457,'".nullif($_POST["nickname"])."','nfl')";
	
	if (!mysqli_query($con,$sql))
	{
		die('Error: ' . mysqli_error($con));
	}
	echo "1 record added";
	mysqli_close($con);
 

 ?>