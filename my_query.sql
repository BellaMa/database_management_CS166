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


-- 11. Browse chat messages 
-- first need to promote user to choose which chat to display
-- that is fist to show all the possible chats
select chat_id from CHAT_LIST
    where member = 'loginName';

-- then promote user to choose which chatting to display
select msg_id, msg_text, msg_timestamp, sender_login from MESSAGE 
    where chat_id = inputFromUser and sender_login = 'loginName';
-- msg_timestamp is used for displaying in chronological order
-- sender_login is used for indicating sender
-- java will only display latest 10 messages initially



-- 10. Delete my chats
-- first display all chats that the current user can delete
select chat_id, chat_type from CHAT
    where init_sender = 'loginName';

-- delete the indicated chats 
-- use a loop to delete all chats!!!!
delete from CHAT_LIST
	where chat_id = inputFromUser;

delete from CHAT 
	where init_sender = 'loginName' and chat_id = inputFromUser;

delete from MESSAGE 
	where chat_id = inputFromUser and sender_login = 'loginName';




-- 9. Manage chatting members
-- delete/add chatting members ONLY by initial creater
-- use another memu here
-- delete (1) add (2)

-- first display chats created by the user (also their members)
select chat_id from CHAT where init_sender = 'loginName';
-- then promost user to select which chat he wants to modify
select chat_id, member from CHAT_LIST
    where chat_id = inputFromUser_id;

-- if user wants to delete someone
delete from CHAT_LIST
	    where chat_id = inputFromUser_id and member = inputFromUser_loginName;

-- if user want to add someone
insert into CHAT_LIST values
	(inputFromUser_id, inputFromUser_loginName);






-- 8. Start new chat
-- chat_id is generated by trigger and sequence
-- user will first choose if the chat is private or public
-- user will also indicate with whom he initializes the chat
insert into CHAT values
	(chat_id_sequence, inputFromUser_chatType,'loginName');

-- update chat_list, use a loop here
insert into CHAT_LIST values
	(chat_id_sequence, 'loginName');

insert into CHAT_LIST values
	(chat_id_sequence, inputFromUser_loginName);



-- 7. Browse current chat lists
-- display availble chats
-- index on MESSAGE.chat_id 

select MESSAGE.chat_id, MIN(MESSAGE.msg_timestamp)from CHAT_LIST, MESSAGE
    where CHAT_LIST.member = 'loginName' and CHAT_LIST.chat_id = MESSAGE.chat_id 
    group by MESSAGE.chat_id
    order by MESSAGE.msg_timestamp;



-- 6. Delete someone from your block list
--delete from USER_LIST_CONTAINS using USR, USER_LIST
--	where list_member = inputFromUser_loginName and USR.block_list = USER_LIST.list_id
--	and USER_LIST_CONTAINS.list_id = USER_LIST.list_id and USR.login = 'loginName';
delete from USER_LIST_CONTAINS using USR,
	where list_member = inputFromUser_loginName 
	and USER_LIST_CONTAINS.list_id = USR.block_list and USR.login = 'loginName';



-- 5. Browse block list
--select USER_LIST_CONTAINS.list_member from USER_LIST_CONTAINS, USER_LIST, USR
  --  where USR.login = 'loginName' and USR.block_list = USER_LIST.list_id
    --and USER_LIST_CONTAINS.list_id = USER_LIST.list_id;
select USER_LIST_CONTAINS.list_member from USER_LIST_CONTAINS,, USR
    where USR.login = 'loginName' 
    and USER_LIST_CONTAINS.list_id = USR.block_list;





-- 4. Add to block list
with tem_list_id as ( select block_list from USR )
insert into USER_LIST_CONTAINS  values
	(tem_list_id, inputFromUser_loginName);


-- 3. Delete someone from your contact list
delete from USER_LIST_CONTAINS using USR
	where list_member = inputFromUser_loginName
	and USER_LIST_CONTAINS.list_id = USR.contact_list;


-- 2. Browse contact list
select USER_LIST_CONTAINS.list_member from USER_LIST_CONTAINS,USR
    where USR.login = 'loginName' 
    and USER_LIST_CONTAINS.list_id = USR.contact_list;


-- 1. Add someone to contact list
with tem_list_id as (select contact_list from USR)
insert into USER_LIST_CONTAINS values
	(tem_list_id, inputFromUser_loginName);














