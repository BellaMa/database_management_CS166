-- 15  Delete my accout
-- !!!! java will read in count() , if it is 0, then java would delete the user
-- otherwise it will just print "SORRY, there are linked information for this accout, 
-- system is unable to delete user accout"

-- loginName is current user name
select COUNT(serial) from  CHAT 
    where init_sender = 'loginName';

delete from USR
    where login = 'loginName';
 
 
 
 
-- 14 Delete chat messages // only those who wrote  
-- message_ID is read from screen by java
delete from MESSAGE 
	where sender_login = 'loginName' and msg_id = message_ID;




-- 13. Edit a message
-- inputFromUser and message_ID come from java 
-- before edit a message, display messages that current user can edit
-- i.e. those written by current user
select msg_id, msg_text 
    from MESSAGE where sender_login = 'loginName';

-- user can choose which message to edit by inputting mes_id
update MESSAGE set msg_text = 'inputFromUser', msg_timestamp = currentTime
	where mag_id = message_ID and sender_login = 'loginName';


-- 12. Write a new message
insert into MESSAGE values
	(message_ID, 'inputFromUser',currentTime,loginName,chatID);
-- message_ID is generated from a sequence and trigger
-- chatID is the current chat_id	


-- 11. Browse chat messages -- checked
-- first need to promote user to choose which chat to display
-- that is fist to show all the possible chats
select chat_id from CHAT_LIST
    where member = 'currentLoginName';

-- then promote user to choose which chatting to display
select msg_id, msg_text, sender_login, MESSAGE.msg_timestamp from MESSAGE 
    where chat_id = inputFromUser_chatID 
    group by msg_id
    order by MAX(MESSAGE.msg_timestamp) DESC;
-- msg_timestamp is used for displaying in chronological order
-- sender_login is used for indicating sender
-- java will only display latest 10 messages initially



-- 10. Delete my chats
-- first display all chats that the current user can delete
select chat_id, chat_type from CHAT
    where init_sender = 'currentLoginName';

-- delete the indicated chats (user input chat_id)
-- use a loop to delete all chats!!!!
-- must be done in this order!!!
delete from CHAT_LIST
	where chat_id = inputFromUser_chatID;

delete from CHAT 
	where init_sender = 'currentLoginName' and chat_id = inputFromUser_chatID;

delete from MESSAGE 
	where chat_id = inputFromUser_chatID;




-- 9. Manage chatting members -- checked
-- delete/add chatting members ONLY by initial creater
-- use another memu here
-- delete (1) add (2)

-- need to check(update!)
-- if it's a 1-1 chat, chatType is private
-- otherwise it's public

-- first display chats created by the user (also their members)
select * from CHAT where init_sender = 'currentLoginName';
        
-- then promote user to select which chat he wants to modify
select chat_id, member from CHAT_LIST
    where chat_id = inputFromUser_chatID;

-- add
insert into CHAT_LIST values
	(inputFromUser_chatID, 'inputFromUser_loginName');

-- if there're more than 2 members, update chat_type
select count(member) from chat_list 
    where chat_id = inputFromUser_chatID;  -- helper func

update CHAT set chat_type = 'group' where chat_id = inputFromUser_chatID;


-- deletion
delete from CHAT_LIST
    where chat_id = inputFromUser_chatID and member = 'inputFromUser_loginName';
	    
-- if only 2 members, set chat type to private, needs a helper func here!
select count(member) from chat_list 
    where chat_id = inputFromUser_loginName;  -- helper func (same as add's)
    
update CHAT set chat_type = 'private' where chat_id = inputFromUser_chatID;






-- 8. Start new chat  -- checked
-- chat_id is generated by trigger and sequence
-- user will first choose if the chat is private or public
-- user will also indicate with whom he initializes the chat
-- if it's a 1-1 chat, chatType is private
-- otherwise it's public

insert into CHAT values
	(nextval(chat_chat_id_seq), 'private','currentLoginName');

-- update chat_list, use a loop here
-- helper function to find out new chat_id !!!!!
insert into CHAT_LIST values
	(outputFromHelper, 'currentLoginName');

insert into CHAT_LIST values
	(outputFromHelper, 'inputFromUser_loginName');



-- 7. Browse current chat lists -- checked
-- display availble chats
-- index on MESSAGE.chat_id 
select MESSAGE.chat_id, MAX(MESSAGE.msg_timestamp)from CHAT_LIST, MESSAGE
    where CHAT_LIST.member = 'currentLoginName' and CHAT_LIST.chat_id = MESSAGE.chat_id 
    group by MESSAGE.chat_id
    order by MAX(MESSAGE.msg_timestamp) DESC;



-- 6. Delete someone from your block list -- checked
delete from USER_LIST_CONTAINS using USR
	where list_member = 'inputFromUser_loginName' 
	and USER_LIST_CONTAINS.list_id = USR.block_list and USR.login = 'currentLoginName';



-- 5. Browse block list  -- checked
select USER_LIST_CONTAINS.list_member from USER_LIST_CONTAINS, USR
    where USR.login = 'currentLoginName' 
    and USER_LIST_CONTAINS.list_id = USR.block_list;





-- 4. Add to block list  -- checked
select block_list from USR where login = 'currentLoginName';  -- helper function

insert into USER_LIST_CONTAINS  values (outputFromHelper, 'inputFromUser_loginName');


-- 3. Delete someone from your contact list -- check
delete from USER_LIST_CONTAINS using USR
	where USER_LIST_CONTAINS.list_member = 'inputFromUser_loginName'
	and USER_LIST_CONTAINS.list_id = USR.contact_list and USR.login = 'currentLoginName';


-- 2. Browse contact list -- checked
select USER_LIST_CONTAINS.list_member from USER_LIST_CONTAINS,USR
    where USR.login = 'currentLoginName' 
    and USER_LIST_CONTAINS.list_id = USR.contact_list;


-- 1. Add someone to contact list -- checked
select contact_list from USR where login = 'currentLoginName'; -- (helper func) first find out user's contact_list number

insert into USER_LIST_CONTAINS values
	(outputFromHelper, 'inputFromUser_loginName');




----------------------------------------------------------------------------------------
-- accout managements
----------------------------------------------------
-- 1 
contact_list = 1 : Norma
contact_list = 3 : Lonny

select list_member from USER_LIST_CONTAINS where list_id = 1;
 Arne                                              
 Calista.Hessel                                    
 Eliane.Dicki                                      
 Sonia.Boyer                                       
(4 rows)

-- add Lonny to Norma's contact list
insert into USER_LIST_CONTAINS values (1, 'Lonny');
-- result 
select list_member from USER_LIST_CONTAINS where list_id = 1;
 Arne                                              
 Calista.Hessel                                    
 Eliane.Dicki                                      
 Lonny   -- new                                           
 Sonia.Boyer                                       
(5 rows)



----------------------------------------------------
-- 2. Browse contact list
select USER_LIST_CONTAINS.list_member from USER_LIST_CONTAINS,USR
    where USR.login = 'Norma' 
    and USER_LIST_CONTAINS.list_id = USR.contact_list;


----------------------------------------------------
-- 3. Delete someone from your contact list
delete from USER_LIST_CONTAINS using USR
	where USER_LIST_CONTAINS.list_member = 'Lonny'
	and USER_LIST_CONTAINS.list_id = USR.contact_list and USR.login = 'Norma';
-- delete Lonny


----------------------------------------------------
-- find Norma's block list
select block_list from USR where login = 'Lonny';  -- helper function
2 

select list_member from USER_LIST_CONTAINS where list_id = 2;
 Andreane_O'Hara                                   
 Bradford_Hills                                    
 Earl_Schumm                                       
 Ivah_Shanahan                                     
 Laurel                                            
 Leonel_Batz                                       
(6 rows)

-- 4. Add to block list    -- add Norma
insert into USER_LIST_CONTAINS  values (2, 'Norma');



----------------------------------------------------
-- 5. Browse block list
select USER_LIST_CONTAINS.list_member from USER_LIST_CONTAINS, USR
    where USR.login = 'Lonny' 
    and USER_LIST_CONTAINS.list_id = USR.block_list;
    
----------------------------------------------------
-- 6. Delete someone from your block list
delete from USER_LIST_CONTAINS using USR
	where list_member = 'Norma' 
	and USER_LIST_CONTAINS.list_id = USR.block_list and USR.login = 'Lonny';
-- delete Norma








----------------------------------------------------
-- chatting management
----------------------------------------------------
-- 7. Browse current chat lists
-- display availble chats
-- index on MESSAGE.chat_id 

select MESSAGE.chat_id, MAX(MESSAGE.msg_timestamp)from CHAT_LIST, MESSAGE
    where CHAT_LIST.member = 'Norma' and CHAT_LIST.chat_id = MESSAGE.chat_id 
    group by MESSAGE.chat_id
    order by MAX(MESSAGE.msg_timestamp) DESC;
    
 chat_id |         max         
    1899 | 2012-12-11 16:46:11
    2500 | 2011-10-12 15:54:40
    3929 | 2009-06-07 01:59:21



----------------------------------------------------
-- 8. Start new chat 
-- chat_id is generated by trigger and sequence
-- user will first choose if the chat is private or public
-- user will also indicate with whom he initializes the chat
-- if it's a 1-1 chat, chatType is private
-- otherwise it's public
insert into CHAT values
	(nextval(chat_chat_id_seq), 'private','Norma');

-- update chat_list, use a loop here
-- helper function to find out new chat_id !
insert into CHAT_LIST values
	(outputFromHelper, 'Norma');

insert into CHAT_LIST values
	(outputFromHelper, 'Lonny');



-- before
select chat.chat_id, chat_type, init_sender from chat, chat_list where chat.chat_id = chat_list.chat_id and member = 'Norma';
 chat_id |  chat_type  | init_sender                     
    1899 | group       | Chance.Heathcote      
    2500 | group       | Scarlett_Bogisich     
    3929 | group       | Norma                 
(3 rows)

----
insert into CHAT values
	(nextval('chat_chat_id_seq'), 'private' ,'Norma');

insert into CHAT_LIST values
	(5001, 'Norma');

insert into CHAT_LIST values
	(5001, 'Lonny');



select chat_id, chat_type, init_sender from chat where init_sender = 'Norma';
 chat_id |  chat_type      | init_sender                     
    3929 | group           | Norma                 
    5001 | private         | Norma                 
(2 rows)

-- after
 chat_id | chat_type   | init_sender                     
    1899 | group       | Chance.Heathcote      
    2500 | group       | Scarlett_Bogisich     
    3929 | group       | Norma                 
    5001 | private     | Norma                 
(4 rows)



----------------------------------------------------
-- 9. Manage chatting members
-- delete/add chatting members ONLY by initial creater
-- use another memu here
-- delete (1) add (2)

-- need to check(update!)
-- if it's a 1-1 chat, chatType is private
-- otherwise it's public

-- first display chats created by the user (also their members)
select * from CHAT where init_sender = 'Norma';

 chat_id | chat_type | init_sender                     
    3929 | group     | Norma                 
    5001 | private   | Norma                 
(2 rows)
                   
-- then promost user to select which chat he wants to modify
select chat_id, member from CHAT_LIST
    where chat_id = 5001;


 chat_id |                       member                       
    5001 | Lonny                                             
    5001 | Norma                                             
(2 rows)


-- add
insert into CHAT_LIST values
	(5001, 'Chance.Heathcote');

-- if there're more than 2 members, update chat_type
select count(member) from chat_list where chat_id = 5001; 
update CHAT set chat_type = 'group' where chat_id = 5001;


-- deletion
delete from CHAT_LIST
    where chat_id = 5001 and member = 'Chance.Heathcote';
	    
-- if only 2 members, set chat type to private, needs a helper func here!
select count(member) from chat_list where chat_id = 5001;
update CHAT set chat_type = 'private' where chat_id = 5001;




----------------------------------------------------
-- 10. Delete my chats
-- first display all chats that the current user can delete
select chat_id, chat_type from CHAT
    where init_sender = 'Norma';

-- delete the indicated chats (user input chat_id)
-- use a loop to delete all chats!!!!
delete from CHAT_LIST
	where chat_id = 5001;

delete from CHAT 
	where init_sender = 'Norma' and chat_id = 5001;

delete from MESSAGE 
	where chat_id = 5001;
	
	
	
	
	
	
	
	
----------------------------------------------------
-- 11. Browse chat messages 
-- first need to promote user to choose which chat to display
-- that is fist to show all the possible chats
select chat_id from CHAT_LIST
    where member = 'Norma';

-- then promote user to choose which chatting to display
select msg_id, msg_text, sender_login, MESSAGE.msg_timestamp from MESSAGE 
    where chat_id = 2500 
    group by msg_id
    order by MAX(MESSAGE.msg_timestamp) DESC;
-- msg_timestamp is used for displaying in chronological order
-- sender_login is used for indicating sender
-- java will only display latest 10 messages initially
	
	
	
	
	
	
	
	
	
	

