<?php
ini_set("error_reporting", E_ALL); 
ini_set("display_errors", 1); 

/*
$con=mysqli_connect("us-cdbr-iron-east-03.cleardb.net","bee1e683ba77e3","ad803f31","ad_463a2c81da5e2c0");
*/

$con=mysqli_connect("localhost","root","","mysql");
if (mysqli_connect_errno($con))
{
	echo "Failed to connect to MySQL: " . mysqli_connect_error();
}


$sql = "CREATE TABLE my_splits ("
  ."splitted_column varchar(500) NOT NULL,"
  ."id int(10) DEFAULT NULL);";
$result = $con->query($sql);

$sql = "CREATE TABLE tbl_chathistory ("
  ."Account_id int(11) DEFAULT NULL,"
  ."Chat text,"
  ."Latitude double DEFAULT NULL,"
  ."Longitude double DEFAULT NULL,"
  ."TimeStamp datetime DEFAULT CURRENT_TIMESTAMP);";
$result1 = $con->query($sql);

$sql = "CREATE TABLE tbl_finallist ("
   ."splitted_column varchar(500) DEFAULT NULL,"
   ."id varchar(45) DEFAULT NULL,"
   ."cnt int(11) DEFAULT NULL);";
$result2 = $con->query($sql);

$sql = "CREATE TABLE tbl_stopwordlist ("
  ."wordslist text);";
$result3 = $con->query($sql);
  
  
  /*
$sql = "create table if not exists tbl_page_performance_details("
."session_id varchar(200),"
."ip_addr varchar(20),"
."entrytime      datetime,"
."country       varchar(100),"
."city           varchar(100),"
."curr_page_url varchar(200),"
."referrer_url varchar(200),"
."time_spent bigint,"
."page_load_time bigint);";

$result = $con->query($sql);

$sql = "create table if not exists tbl_page_click_details("
."session_id varchar(200),"
."country   varchar(100),"
."city        varchar(100),"
."ip_addr varchar(20),"
."curr_page_url varchar(200),"
."click_type varchar(20),"
."clicked_content varchar(200),"
."click_time datetime,"
."comments varchar(200));";

$resultcolumn =$con->query($sql);
*/

if (!$result && !$resultcolumn) {
	echo "Could not successfully run query ($sql) from DB: " . $con->error();
	exit;
}




		mysqli_close($con);

?>