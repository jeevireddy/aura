<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head>

    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    
    <title>verizon aura - discussion forum</title>
    
    <link rel="stylesheet" href="style.css" type="text/css" />
    
    <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js"></script>
    <script type="text/javascript" src="chat.js"></script>
    <script type="text/javascript">
    function sendtext(Chat)
    {
        $.ajax({  
        	     	url: 'Service.php', 
        	         data: {Chat: Chat,
					 nickname:nickname }, 
        	         type: 'post', 
        	         success: function(output) { 
        	 // alert(output); 
        	                  }, 
        	         error:function(err){ 
        	         	 
        	             } 
        	     }); 
        }






    function adsdata()
    {
    	 $.ajax({  
 	     	url: 'AdService.php', 
 	         data: {Chat: "nanu"}, 
 	         type: 'post', 
 	         success: function(output) { 
			 
			 
			 var str = output;
			 
			 
			 var link ='';
			 var linkurl ='';
			if (str =="")
			{
				link = 'Google';
				linkurl = 'http://google.com';
			}
			else
			{
				var res = str.split(">");				
				link = res[0];
				linkurl = res[1];
				alert(link);
				alert(linkurl);
			}

		alert('<div style="left:20px;top:5px;position:relative;" ><p style="color:blue;font-weight:bold;">Your Ad related to <a href="'+linkurl+'"  target="_blank" >'+link+' </a> is here</p></div>');
				$("#ads").html('<div style="left:20px;top:5px;position:relative;" ><p style="color:blue;font-weight:bold;">Your Ad related to <a href="'+linkurl+'"  target="_blank" >'+link+' </a> is here</p></div>'); 
 	                  }, 
 	         error:function(err){ 
 	         	 
 	             } 
 	    	 }); 
        }
    
$(window).load(function(){
/*
	alert($("#chat-area").position().top);
	alert($("#chat-area").position().left);
	alert($("#chat-area").position().top +$("#chat-area").height());
	alert($("#chat-area").position().left +$("#chat-area").width());
	*/
	$("#ads").css("top",$("#chat-area").position().top +$("#chat-area").height()+2);
	$("#ads").css("left",$("#chat-area").position().left);
	$("#ads").width($("#chat-area").width());
	$("#ads").height(50);
	
});


    
        // ask user for name with popup prompt    
        var name = prompt("Enter your chat name:", "Enter Your Name");
        
        // default name is 'Guest'
    	if (!name || name === ' ') {
    	   name = "Your Nick Name";	
    	}
    	
    	// strip tags
    	name = name.replace(/(<([^>]+)>)/ig,"");
    	var counter=0;
    	
    	// display name on page
    	$("#name-area").html("You are: <span>" + name + "</span>");
    	
    	// kick off chat
        var chat =  new Chat();
    	$(function() {
    	
    		 chat.getState(); 
    		 
    		 // watch textarea for key presses
             $("#sendie").keydown(function(event) {  
             
                 var key = event.which;  
           
                 //all keys including return.  
                 if (key >= 33) {
                   
                     var maxLength = $(this).attr("maxlength");  
                     var length = this.value.length;  
                     
                     // don't allow new content if length is maxed out
                     if (length >= maxLength) {  
                         event.preventDefault();  
                     }  
                  }  
    		 																																																});
    		 // watch textarea for release of key press
    		 $('#sendie').keyup(function(e) {	
    		 					 
    			  if (e.keyCode == 13) { 
    			  
                    var text = $(this).val();
                    sendtext(text,name);
                    counter++;
                    //if(
                    
                    //alert(text);
                    if(counter%4==0){
                    adsdata();
                    }
    				var maxLength = $(this).attr("maxlength");  
                    var length = text.length; 
                     
                    // send 
                    if (length <= maxLength + 1) { 
                     
    			        chat.send(text, name);	
    			        $(this).val("");
    			        //$("#send-message-area").append("<p>hello</p>");
    			        
                    } else {
                    
    					$(this).val(text.substring(0, maxLength));
    					
    				}	
    				
    				
    			  }
             });
            
    	});
    </script>

</head>

<body onload="setInterval('chat.update()', 1000)" >
		
    <div id="page-wrap" >
        <p id="name-area"></p>       
        <table style="border:1px black; background:#E4EBED;">
		<tr>
		<td> 
			<font style="font-weight:bold;font-size:30px;">aura</font>
			<img src="images/vzlogo_lg.png" id="vz" style="width:28%;height:auto;"></img>
		</td>
		</tr>
		<tr>
		<td> 		
		<div id="chat-wrap">
			<div id="chat-area"> </div>
        
		<div style="position:relative;">
			<form id="send-message-area">
				<textarea id="sendie" maxlength = '100' placeholder="Type Your Mesage Here"></textarea>
			</form>
		</div>
		</div>
		</td>
		</tr>		
					
		<tr>
		<td> 		
			<div id="ads"></div>
		</td>
		</tr>		
		
		<tr>	
		</table>
        </div>            

</body>

</html>