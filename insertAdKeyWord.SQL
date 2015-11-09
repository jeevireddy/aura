DELIMITER $$
CREATE PROCEDURE insertAdKeyWord() 
BEGIN

	DECLARE 	my_delimiter 		CHAR(1);
	DECLARE 	chat_statement 		VARCHAR(5000);
	DECLARE 	done         		INT;
	DECLARE 	occurance    		INT;
	DECLARE 	i            		INT;
	DECLARE 	split_id     		char(100);
	DECLARE 	ins_query    		VARCHAR(5000);

	DECLARE  	splitter_cur CURSOR FOR

	SELECT   	user_id, 
				Replace(chat,'''','') chat 
	FROM     	tbl_chathistory 
	ORDER 		BY chat_ts DESC limit 6;

	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done=1;

	TRUNCATE  TABLE`my_splits`;

	OPEN splitter_cur;
	
	SPLITTER_LOOP: 	
	LOOP FETCH splitter_cur INTO split_id,chat_statement;

		SET occurance = length(chat_statement)-length(replace(chat_statement,' ',''))+1;
		SET my_delimiter=' ';

		IF done =1 THEN
			SPLITTER_LOOP;
		END IF;

		IF occurance > 0 THEN
			SET i=1;
			WHILE i <= occurance 
			DO
				INSERT INTO my_splits (`splitted_column`,`id`)
				SELECT REPLACE(SUBSTRING(SUBSTRING_INDEX(chat_statement, ' ', i),LENGTH(SUBSTRING_INDEX(chat_statement, ' ', i -1)) + 1),' ', '') as splitted_column,split_id;
				
				SET ins_query = concat("insert into my_splits(splitted_column,id) values(", concat("SUBSTRING_INDEX(SUBSTRING_INDEX( '",chat_statement ,"', '",my_delimiter,"', ",i, "),'",my_delimiter,"',-1),",split_id,");"));
				SET @ins_query=ins_query;
						
				PREPARE ins_query from @ins_query;
				EXECUTE ins_query;
				SET i=i+1;
			END WHILE ;
		ELSE
				set ins_query=concat("insert into my_splits(splitted_column,id) values(",chat_statement,"',",split_id,");");
				set @ins_query=ins_query;
				PREPARE ins_query from @ins_query;
				EXECUTE ins_query;
		END IF;
		
		SET occurance=0;
	
	END LOOP;

	CLOSE splitter_cur;

END $$ 

DELIMITER;