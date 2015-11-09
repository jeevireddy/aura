-- phpMyAdmin SQL Dump
-- version 4.4.11
-- http://www.phpmyadmin.net
--
-- Host: us-cdbr-iron-east-03.cleardb.net:3306
-- Generation Time: Nov 09, 2015 at 10:00 AM
-- Server version: 5.5.45-log
-- PHP Version: 5.5.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

--
-- Database: `ad_463a2c81da5e2c0`
--
CREATE DATABASE IF NOT EXISTS `ad_463a2c81da5e2c0` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE `ad_463a2c81da5e2c0`;

DELIMITER $$
--
-- Procedures
--
DROP PROCEDURE IF EXISTS `splitChatString`$$
CREATE DEFINER=`bee1e683ba77e3`@`%` PROCEDURE `splitChatString`()
BEGIN

DECLARE my_delimiter CHAR(1);
DECLARE split_string varchar(5000);
DECLARE done INT;
DECLARE occurance INT;
DECLARE i INT;
DECLARE split_id INT;
DECLARE ins_query VARCHAR(5000);
DECLARE splitter_cur CURSOR FOR
SELECT account_id,replace(chat,'''','') chat FROM tbl_chathistory;


DECLARE CONTINUE HANDLER FOR NOT FOUND SET done=1;

TRUNCATE  TABLE `my_splits`;


OPEN splitter_cur;
splitter_loop:LOOP
      FETCH splitter_cur INTO split_id,split_string;

SET occurance=length(split_string)-length(replace(split_string,' ',''))+1;
SET my_delimiter=' ';
  IF done=1 THEN
    LEAVE splitter_loop;
  END IF;
#  select occurance;
  IF occurance > 0 then
    #select occurance;
    set i=1;
    while i <= occurance do
#        select concat("SUBSTRING_INDEX(SUBSTRING_INDEX( '",split_string ,"', '",my_delimiter,"', ",i, "),'",my_delimiter,"',-1);");
insert into my_splits (`splitted_column`,`id`)
SELECT REPLACE(SUBSTRING(SUBSTRING_INDEX(split_string, ' ', i),LENGTH(SUBSTRING_INDEX(split_string, ' ', i -1)) + 1),' ', '')
as splitted_column,split_id;
        SET ins_query=concat("insert into my_splits(splitted_column,id) values(", concat("SUBSTRING_INDEX(SUBSTRING_INDEX( '",split_string ,"', '",my_delimiter,"', ",i, "),'",my_delimiter,"',-1),",split_id,");"));
        
    #select ins_query;
        set @ins_query=ins_query;
        #select @ins_query;
        PREPARE ins_query from @ins_query;
        EXECUTE ins_query;
      set i=i+1;
    end while;
  ELSE
        set ins_query=concat("insert into my_splits(splitted_column,id) values(",split_string,"',",split_id,");");
        set @ins_query=ins_query;
        PREPARE ins_query from @ins_query;
        EXECUTE ins_query;
  END IF;
  set occurance=0;
END LOOP;

CLOSE splitter_cur;

TRUNCATE TABLE tbl_finallist;

 insert into tbl_finallist
 (splitted_column,id,cnt)
select  
lower(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(splitted_column,'!',''),'"',''),'.',''),'.',''),')',''),'(',''),'/',''),'?',''),'&',''),'\\',''),'+',''),'-',''),'<','')) as splitted_column 
 ,id,count(*) as cnt from my_splits where splitted_column is not null and splitted_column <> ''
and splitted_Column not in (select wordslist from tbl_stopwordlist)
group by lower(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(splitted_column,'!',''),'"',''),'.',''),'.',''),')',''),'(',''),'/',''),'?',''),'&',''),'\\',''),'+',''),'-',''),'<','') ),id
 
order by cnt desc
limit 1;

insert into tbl_finallist
(splitted_column,id,cnt)
select  
lower(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(splitted_column,'!',''),'"',''),'.',''),'.',''),')',''),'(',''),'/',''),'?',''),'&',''),'\\',''),'+',''),'-',''),'<','')) as splitted_column 
 ,'NFL',count(*) as cnt from my_splits where splitted_column is not null and splitted_column <> ''
and splitted_Column not in (select wordslist from tbl_stopwordlist) and splitted_Column is not null
and splitted_Column <>' '
group by lower(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(splitted_column,'!',''),'"',''),'.',''),'.',''),')',''),'(',''),'/',''),'?',''),'&',''),'\\',''),'+',''),'-',''),'<',''))  
 
order by cnt desc
limit 1;

truncate table adText;

insert into adText (linkurl,add_ts)
SELECT  concat(link,'>',hyperlink) ,sysdate() 
  FROM tbl_adinventory s
  JOIN tbl_finallist c
    ON  LOWER(c.splitted_Column) like concat('%',LOWER(s.keyword),'%')
where c.id='NFL' ;
	
insert into adText (linkurl,add_ts)
select concat(splitted_Column, '>' , 'http://www.google.com/search?q=' , splitted_Column ,'&btnI') , sysdate() from tbl_finallist where id='NFL' and splitted_column is not null;



END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `adtext`
--

DROP TABLE IF EXISTS `adtext`;
CREATE TABLE IF NOT EXISTS `adtext` (
  `linkurl` varchar(1000) DEFAULT NULL,
  `add_ts` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `adtext`
--

INSERT INTO `adtext` (`linkurl`, `add_ts`) VALUES
('Oakland Athletics Tickets>oakland.athletics.mlb.com/ticketing/?c_id=oak', '2015-11-09 07:18:16'),
('oakland\n>http://www.google.com/search?q=oakland\n&btnI', '2015-11-09 07:18:16');

-- --------------------------------------------------------

--
-- Table structure for table `my_splits`
--

DROP TABLE IF EXISTS `my_splits`;
CREATE TABLE IF NOT EXISTS `my_splits` (
  `splitted_column` varchar(500) NOT NULL,
  `id` int(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `my_splits`
--

INSERT INTO `my_splits` (`splitted_column`, `id`) VALUES
('oakland\n', 222115),
('', 222115),
('oakland\n', 222115),
('', 222115),
('oakland\n', 222115),
('', 222115),
('oakland\n', 222115),
('', 222115),
('moenyball\n', 222115),
('', 222115),
('moneyball\n', 222115),
('', 222115),
('moneyball\n', 222115),
('', 222115),
('moneyball\n', 222115),
('', 222115),
('moneyball\n', 222115),
('', 222115),
('moenyball\n', 222115),
('', 222115),
('moneyball\n', 222115),
('', 222115),
('moneyball\n', 222115),
('', 222115),
('moneyball\n', 222115),
('', 222115),
('moneyball', 222115),
('', 222115),
('moneyball', 222115),
('', 222115),
('moneyball\n', 222115),
('', 222115),
('moneyball\n', 222115),
('', 222115),
('moneyball\n', 222115),
('', 222115),
('oakland', 222115),
('', 222115),
('oakland', 222115),
('', 222115),
('oakland', 222115),
('', 222115),
('oakland', 222115),
('', 222115),
('oakland', 222115),
('', 222115),
('oakland', 222115),
('', 222115),
('oakland', 222115),
('', 222115),
('oakland\n', 222115),
('', 222115),
('oakland\n', 222115),
('', 222115),
('oakland\n', 222115),
('', 222115),
('oakland\n', 222115),
('', 222115),
('oakland\n', 222115),
('', 222115),
('oakland\n', 222115),
('', 222115),
('oakland\n', 222115),
('', 222115),
('oakland\n', 222115),
('', 222115);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_adinventory`
--

DROP TABLE IF EXISTS `tbl_adinventory`;
CREATE TABLE IF NOT EXISTS `tbl_adinventory` (
  `keyword` varchar(100) NOT NULL,
  `hyperlink` varchar(1000) NOT NULL,
  `link` varchar(500) NOT NULL,
  `active` varchar(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tbl_adinventory`
--

INSERT INTO `tbl_adinventory` (`keyword`, `hyperlink`, `link`, `active`) VALUES
('Oakland', 'oakland.athletics.mlb.com/ticketing/?c_id=oak', 'Oakland Athletics Tickets', 'Y'),
('moneyball', 'https://www.verizon.com/Ondemand/Movies/MovieDetails/Moneyball/TVNX0011284101153930', 'Moneyball on demand video', 'Y'),
('Cricket', 'www.cricbuzz.com', 'Live Cricket Scores', 'Y'),
('Shopping', 'www.amazon.com', 'Shopping at Amazon', 'Y');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_chathistory`
--

DROP TABLE IF EXISTS `tbl_chathistory`;
CREATE TABLE IF NOT EXISTS `tbl_chathistory` (
  `Account_id` int(11) DEFAULT NULL,
  `User_id` text,
  `Chat_Group` text,
  `Chat` text,
  `Latitude` double DEFAULT NULL,
  `Longitude` double DEFAULT NULL,
  `chat_ts` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tbl_chathistory`
--

INSERT INTO `tbl_chathistory` (`Account_id`, `User_id`, `Chat_Group`, `Chat`, `Latitude`, `Longitude`, `chat_ts`) VALUES
(222115, 's', 'nfl', 'oakland', 40.91709, -72.709457, '2015-11-09 07:12:52'),
(222115, 's', 'nfl', 'oakland', 40.91709, -72.709457, '2015-11-09 07:12:56'),
(222115, 's', 'nfl', 'oakland', 40.91709, -72.709457, '2015-11-09 07:12:58'),
(222115, 's', 'nfl', 'oakland', 40.91709, -72.709457, '2015-11-09 07:13:00'),
(222115, 's', 'nfl', 'moenyball', 40.91709, -72.709457, '2015-11-09 07:13:42'),
(222115, 's', 'nfl', 'moneyball', 40.91709, -72.709457, '2015-11-09 07:13:44'),
(222115, 's', 'nfl', 'moneyball', 40.91709, -72.709457, '2015-11-09 07:13:46'),
(222115, 's', 'nfl', 'moneyball', 40.91709, -72.709457, '2015-11-09 07:13:48'),
(222115, 's', 'nfl', 'moneyball', 40.91709, -72.709457, '2015-11-09 07:13:53'),
(222115, 's', 'nfl', 'moenyball', 40.91709, -72.709457, '2015-11-09 07:14:01'),
(222115, 's', 'nfl', 'moneyball', 40.91709, -72.709457, '2015-11-09 07:14:39'),
(222115, 's', 'nfl', 'moneyball', 40.91709, -72.709457, '2015-11-09 07:14:42'),
(222115, 's', 'nfl', 'moneyball', 40.91709, -72.709457, '2015-11-09 07:15:49');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_finallist`
--

DROP TABLE IF EXISTS `tbl_finallist`;
CREATE TABLE IF NOT EXISTS `tbl_finallist` (
  `splitted_column` varchar(500) DEFAULT NULL,
  `id` varchar(45) DEFAULT NULL,
  `cnt` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tbl_finallist`
--

INSERT INTO `tbl_finallist` (`splitted_column`, `id`, `cnt`) VALUES
('oakland\n', '222115', 12),
('oakland\n', 'NFL', 12);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_stopwordlist`
--

DROP TABLE IF EXISTS `tbl_stopwordlist`;
CREATE TABLE IF NOT EXISTS `tbl_stopwordlist` (
  `wordslist` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tbl_stopwordlist`
--

INSERT INTO `tbl_stopwordlist` (`wordslist`) VALUES
('as'),
('able'),
('about'),
('above'),
('according'),
('accordingly'),
('across'),
('actually'),
('after'),
('afterwards'),
('again'),
('against'),
('aint'),
('all'),
('allow'),
('allows'),
('almost'),
('alone'),
('along'),
('already'),
('also'),
('although'),
('always'),
('am'),
('among'),
('amongst'),
('an'),
('and'),
('another'),
('any'),
('anybody'),
('anyhow'),
('anyone'),
('anything'),
('anyway'),
('anyways'),
('anywhere'),
('apart'),
('appear'),
('appreciate'),
('appropriate'),
('are'),
('arent'),
('around'),
('as'),
('aside'),
('ask'),
('asking'),
('associated'),
('at'),
('available'),
('away'),
('awfully'),
('be'),
('became'),
('because'),
('become'),
('becomes'),
('becoming'),
('been'),
('before'),
('beforehand'),
('behind'),
('being'),
('believe'),
('below'),
('beside'),
('besides'),
('best'),
('better'),
('between'),
('beyond'),
('both'),
('brief'),
('but'),
('by'),
('cmon'),
('cs'),
('came'),
('can'),
('cant'),
('cannot'),
('cant'),
('cause'),
('causes'),
('certain'),
('certainly'),
('changes'),
('clearly'),
('co'),
('com'),
('come'),
('comes'),
('concerning'),
('consequently'),
('consider'),
('considering'),
('contain'),
('containing'),
('contains'),
('corresponding'),
('could'),
('couldnt'),
('course'),
('currently'),
('definitely'),
('described'),
('despite'),
('did'),
('didnt'),
('different'),
('do'),
('does'),
('doesnt'),
('doing'),
('dont'),
('done'),
('down'),
('downwards'),
('during'),
('each'),
('edu'),
('eg'),
('eight'),
('either'),
('else'),
('elsewhere'),
('enough'),
('entirely'),
('especially'),
('et'),
('etc'),
('even'),
('ever'),
('every'),
('everybody'),
('everyone'),
('everything'),
('everywhere'),
('ex'),
('exactly'),
('example'),
('except'),
('far'),
('few'),
('fifth'),
('first'),
('five'),
('followed'),
('following'),
('follows'),
('for'),
('former'),
('formerly'),
('forth'),
('four'),
('from'),
('further'),
('furthermore'),
('get'),
('gets'),
('getting'),
('given'),
('gives'),
('go'),
('goes'),
('going'),
('gone'),
('got'),
('gotten'),
('greetings'),
('had'),
('hadnt'),
('happens'),
('hardly'),
('has'),
('hasnt'),
('have'),
('havent'),
('having'),
('he'),
('hes'),
('hello'),
('help'),
('hence'),
('her'),
('here'),
('heres'),
('hereafter'),
('hereby'),
('herein'),
('hereupon'),
('hers'),
('herself'),
('hi'),
('him'),
('himself'),
('his'),
('hither'),
('hopefully'),
('how'),
('howbeit'),
('however'),
('id'),
('ill'),
('im'),
('ive'),
('ie'),
('if'),
('ignored'),
('immediate'),
('in'),
('inasmuch'),
('inc'),
('indeed'),
('indicate'),
('indicated'),
('indicates'),
('inner'),
('insofar'),
('instead'),
('into'),
('inward'),
('is'),
('isnt'),
('it'),
('itd'),
('itll'),
('its'),
('its'),
('itself'),
('just'),
('keep'),
('keeps'),
('kept'),
('know'),
('known'),
('knows'),
('last'),
('lately'),
('later'),
('latter'),
('latterly'),
('least'),
('less'),
('lest'),
('let'),
('lets'),
('like'),
('liked'),
('likely'),
('little'),
('look'),
('looking'),
('looks'),
('ltd'),
('mainly'),
('many'),
('may'),
('maybe'),
('me'),
('mean'),
('meanwhile'),
('merely'),
('might'),
('more'),
('moreover'),
('most'),
('mostly'),
('much'),
('must'),
('my'),
('myself'),
('name'),
('namely'),
('nd'),
('near'),
('nearly'),
('necessary'),
('need'),
('needs'),
('neither'),
('never'),
('nevertheless'),
('new'),
('next'),
('nine'),
('no'),
('nobody'),
('non'),
('none'),
('noone'),
('nor'),
('normally'),
('not'),
('nothing'),
('novel'),
('now'),
('nowhere'),
('obviously'),
('of'),
('off'),
('often'),
('oh'),
('ok'),
('okay'),
('old'),
('on'),
('once'),
('one'),
('ones'),
('only'),
('onto'),
('or'),
('other'),
('others'),
('otherwise'),
('ought'),
('our'),
('ours'),
('ourselves'),
('out'),
('outside'),
('over'),
('overall'),
('own'),
('particular'),
('particularly'),
('per'),
('perhaps'),
('placed'),
('please'),
('plus'),
('possible'),
('presumably'),
('probably'),
('provides'),
('que'),
('quite'),
('qv'),
('rather'),
('rd'),
('re'),
('really'),
('reasonably'),
('regarding'),
('regardless'),
('regards'),
('relatively'),
('respectively'),
('right'),
('said'),
('same'),
('saw'),
('say'),
('saying'),
('says'),
('second'),
('secondly'),
('see'),
('seeing'),
('seem'),
('seemed'),
('seeming'),
('seems'),
('seen'),
('self'),
('selves'),
('sensible'),
('sent'),
('serious'),
('seriously'),
('seven'),
('several'),
('shall'),
('she'),
('should'),
('shouldnt'),
('since'),
('six'),
('so'),
('some'),
('somebody'),
('somehow'),
('someone'),
('something'),
('sometime'),
('sometimes'),
('somewhat'),
('somewhere'),
('soon'),
('sorry'),
('specified'),
('specify'),
('specifying'),
('still'),
('sub'),
('such'),
('sup'),
('sure'),
('ts'),
('take'),
('taken'),
('tell'),
('tends'),
('th'),
('than'),
('thank'),
('thanks'),
('thanx'),
('that'),
('thats'),
('thats'),
('the'),
('their'),
('theirs'),
('them'),
('themselves'),
('then'),
('thence'),
('there'),
('theres'),
('thereafter'),
('thereby'),
('therefore'),
('therein'),
('theres'),
('thereupon'),
('these'),
('they'),
('theyd'),
('theyll'),
('theyre'),
('theyve'),
('think'),
('third'),
('this'),
('thorough'),
('thoroughly'),
('those'),
('though'),
('three'),
('through'),
('throughout'),
('thru'),
('thus'),
('to'),
('together'),
('too'),
('took'),
('toward'),
('towards'),
('tried'),
('tries'),
('truly'),
('try'),
('trying'),
('twice'),
('two'),
('un'),
('under'),
('unfortunately'),
('unless'),
('unlikely'),
('until'),
('unto'),
('up'),
('upon'),
('us'),
('use'),
('used'),
('useful'),
('uses'),
('using'),
('usually'),
('value'),
('various'),
('very'),
('via'),
('viz'),
('vs'),
('want'),
('wants'),
('was'),
('wasnt'),
('way'),
('we'),
('wed'),
('well'),
('were'),
('weve'),
('welcome'),
('well'),
('went'),
('were'),
('werent'),
('what'),
('whats'),
('whatever'),
('when'),
('whence'),
('whenever'),
('where'),
('wheres'),
('whereafter'),
('whereas'),
('whereby'),
('wherein'),
('whereupon'),
('wherever'),
('whether'),
('which'),
('while'),
('whither'),
('who'),
('whos'),
('whoever'),
('whole'),
('whom'),
('whose'),
('why'),
('will'),
('willing'),
('wish'),
('with'),
('within'),
('without'),
('wont'),
('wonder'),
('would'),
('wouldnt'),
('yes'),
('yet'),
('you'),
('youd'),
('youll'),
('youre'),
('youve'),
('your'),
('yours'),
('yourself'),
('yourselves'),
('zero'),
('yeah'),
('hi'),
('hello'),
('from'),
('bye'),
('whatsup'),
('or'),
('will'),
('be'),
('haha'),
('hahaha'),
('but'),
('dont'),
('lets'),
('see');
