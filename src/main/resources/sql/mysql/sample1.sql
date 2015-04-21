-- Jeu de données de tests
START TRANSACTION;

INSERT INTO ldap_connection(id, uuid, label, provider_url, security_auth, security_principal, security_credentials, creation_date, modification_date) VALUES (1, 'a9b2058f-811f-44b7-8fe5-7a51961eb098', 'linshare-obm', 'ldap://linshare-obm2.linagora.dc1:389', 'simple', '', '', current_date, current_date);


-- system domain pattern
INSERT INTO ldap_pattern(
    id,
    uuid,
    pattern_type,
    label,
    description,
    auth_command,
    search_user_command,
    system,
    auto_complete_command_on_first_and_last_name,
    auto_complete_command_on_all_attributes,
    search_page_size,
    search_size_limit,
    completion_page_size,
    completion_size_limit,
    creation_date,
    modification_date)
VALUES (
    50,
    'd793ebef-b8bb-4930-bf16-27add911ec13',
    'USER_LDAP_PATTERN',
    'linshare-obm',
    'This is pattern the default pattern for the ldap obm structure.',
    'ldap.search(domain, "(&(objectClass=obmUser)(mail=*)(givenName=*)(sn=*)(|(mail="+login+")(uid="+login+")))");',
    'ldap.search(domain, "(&(objectClass=obmUser)(mail="+mail+")(givenName="+first_name+")(sn="+last_name+"))");',
    false,
    'ldap.search(domain, "(&(objectClass=obmUser)(mail=*)(givenName=*)(sn=*)(|(&(sn=" + first_name + ")(givenName=" + last_name + "))(&(sn=" + last_name + ")(givenName=" + first_name + "))))");',
    'ldap.search(domain, "(&(objectClass=obmUser)(mail=*)(givenName=*)(sn=*)(|(mail=" + pattern + ")(sn=" + pattern + ")(givenName=" + pattern + ")))");',
    100,
    100,
    10,
    10,
    current_date,
    current_date
    );

INSERT INTO ldap_attribute(id, field, attribute, sync, system, enable, ldap_pattern_id, completion) VALUES (51, 'user_mail', 'mail', false, true, true, 50, true);
INSERT INTO ldap_attribute(id, field, attribute, sync, system, enable, ldap_pattern_id, completion) VALUES (52, 'user_firstname', 'givenName', false, true, true, 50, true);
INSERT INTO ldap_attribute(id, field, attribute, sync, system, enable, ldap_pattern_id, completion) VALUES (53, 'user_lastname', 'sn', false, true, true, 50, true);
INSERT INTO ldap_attribute(id, field, attribute, sync, system, enable, ldap_pattern_id, completion) VALUES (54, 'user_uid', 'uid', false, true, true, 50, false);



INSERT INTO user_provider(id, uuid, provider_type, base_dn, creation_date, modification_date, ldap_connection_id, ldap_pattern_id) VALUES (1, '93fd0e8b-fa4c-495d-978f-132e157c2292', 'LDAP_PROVIDER', 'ou=users,dc=int1.linshare.dev,dc=local', current_date, current_date, 1, 50);


-- Top domain (example domain)
INSERT INTO domain_abstract(id, type , identifier, label, enable, template, description, default_role, default_locale, default_mail_locale, used_space, user_provider_id, domain_policy_id, parent_id, auth_show_order) VALUES (2, 1, 'MyDomain', 'MyDomain', true, false, 'a simple description', 0, 'en', 'en', 0, null, 1, 1, 2);
-- Sub domain (example domain)
INSERT INTO domain_abstract(id, type , identifier, label, enable, template, description, default_role, default_locale, default_mail_locale, used_space, user_provider_id, domain_policy_id, parent_id, auth_show_order) VALUES (3, 2, 'MySubDomain', 'MySubDomain', true, false, 'a simple description', 0, 'en', 'en', 0, 1, 1, 2, 3);
-- Guest domain (example domain)
INSERT INTO domain_abstract(id, type , identifier, label, enable, template, description, default_role, default_locale, default_mail_locale, used_space, user_provider_id, domain_policy_id, parent_id, auth_show_order) VALUES (4, 3, 'GuestDomain', 'GuestDomain', true, false, 'a simple description', 0, 'en', 'en', 0, null, 1, 2, 4);

UPDATE domain_abstract SET mailconfig_id = 1;
UPDATE domain_abstract SET mime_policy_id=1;
UPDATE domain_abstract SET welcome_messages_id = 1;





-- Users
-- bart simpson
INSERT INTO account(id, account_type, ls_uuid, creation_date, modification_date, role_id, locale, external_mail_locale, enable, destroyed, domain_id) VALUES (50, 2, '9a9ece25-7a0e-4d75-bb55-d4070e25e1e1', current_date, current_date, 0, 'fr', 'en', true, false, 3);
INSERT INTO users(account_id, First_name, Last_name, Mail, Can_upload, Comment, Restricted, CAN_CREATE_GUEST) VALUES (50, 'Bart', 'Simpson', 'bart.simpson@int1.linshare.dev', true, '', false, true);
-- pierre mongin : 15kn60njvhdjh
INSERT INTO account(id, account_type, ls_uuid, creation_date, modification_date, role_id, locale, external_mail_locale, enable, destroyed, domain_id, owner_id , password ) VALUES (53, 3, 'fa2cab19-2cd7-44f5-96f6-418455899d3e', current_date, current_date, 0, 'fr', 'fr', true, false, 4, 50 , 'OsFTxoUjd62imwHnaV/4zQfrJ5s=');
INSERT INTO users(account_id, First_name, Last_name, Mail, Can_upload, Comment, Restricted, CAN_CREATE_GUEST, expiration_date) VALUES (53, 'Pierre', 'Mongin', 'pmongin@ratp.fr', true, '', false, false, current_date);


-- Thread : projet : RATP
INSERT INTO account(id, account_type, ls_uuid, creation_date, modification_date, role_id, locale, external_mail_locale, enable, destroyed, domain_id) VALUES (51, 5, '9806de10-ed0b-11e1-877a-5404a6202d2c', current_date, current_date, 0, 'fr', 'fr', true, false, 1);
INSERT INTO thread (account_id, name) VALUES (51, 'RATP');
-- Thread : projet : 3MI
INSERT INTO account(id, account_type, ls_uuid, creation_date, modification_date, role_id, locale, external_mail_locale, enable, destroyed, domain_id) VALUES (52, 5, '34544580-f0ec-11e1-a62a-080027c0eef0', current_date, current_date, 0, 'fr', 'fr', true, false, 1);
INSERT INTO thread (account_id, name) VALUES (52, 'Ministère de l''intérieur');
-- Thread : projet : Test Thread
INSERT INTO account(id, account_type, ls_uuid, creation_date, modification_date, role_id, locale, external_mail_locale, enable, destroyed, domain_id) VALUES (54, 5, 'c4570914-d004-4506-8abf-04527f342e88', current_date, current_date, 0, 'en', 'en', true, false, 1);
INSERT INTO thread (account_id, name) VALUES (54, 'Test Thread');


-- Thread members
INSERT INTO thread_member (id, thread_id, admin, can_upload, creation_date, modification_date, user_id) VALUES (1, 51, false, false, current_date, current_date, 50); 
INSERT INTO thread_member (id, thread_id, admin, can_upload, creation_date, modification_date, user_id) VALUES (2, 51, true, true, current_date, current_date, 53); 

INSERT INTO thread_member (id, thread_id, admin, can_upload, creation_date, modification_date, user_id) VALUES (3, 52, true, true, current_date, current_date, 50); 

INSERT INTO thread_member (id, thread_id, admin, can_upload, creation_date, modification_date, user_id) VALUES (4, 54, true, true, current_date, current_date, 50); 
INSERT INTO thread_member (id, thread_id, admin, can_upload, creation_date, modification_date, user_id) VALUES (5, 54, false, true, current_date, current_date, 53); 




-- -- thread-entry-1-no-dl
-- INSERT INTO document (id, uuid, creation_date, type, size, thmb_uuid, timestamp) VALUES (1, 'a09e6bea-edcb-11e1-86e7-5404a6202d2c', current_date, 'image/png', 49105, null, null);
-- INSERT INTO entry (id, owner_id, creation_date, modification_date, name, comment, expiration_date, uuid) VALUES (1, 51, current_date, current_date, 'thread-entry-1-no-dl', '', current_date, '5a663f86-edcb-11e1-a9fd-5404a6202d2c'); 
-- INSERT INTO thread_entry (entry_id, document_id, ciphered) VALUES (1, 1, false); 
-- 
-- 
-- -- thread-entry-2-no-dl
-- INSERT INTO document (id, uuid, creation_date, type, size, thmb_uuid, timestamp) VALUES (2, '026e60fa-edcc-11e1-acb9-5404a6202d2c', current_date, 'image/png', 49105, null, null);
-- INSERT INTO entry (id, owner_id, creation_date, modification_date, name, comment, expiration_date, uuid) VALUES (2, 51, current_date, current_date, 'thread-entry-2-no-dl', '', current_date, '187f5ef8-edcc-11e1-8ed2-5404a6202d2c'); 
-- INSERT INTO thread_entry (entry_id, document_id, ciphered) VALUES (2, 2, false); 
-- 
-- -- thread-entry-3-no-dl
-- INSERT INTO document (id, uuid, creation_date, type, size, thmb_uuid, timestamp) VALUES (3, '79eb3356-edcc-11e1-b379-5404a6202d2c', current_date, 'image/png', 49105, null, null);
-- INSERT INTO entry (id, owner_id, creation_date, modification_date, name, comment, expiration_date, uuid) VALUES (3, 51, current_date, current_date, 'thread-entry-3-no-dl', '', current_date, '82169142-edcc-11e1-9686-5404a6202d2c'); 
-- INSERT INTO thread_entry (entry_id, document_id, ciphered) VALUES (3, 3, false); 
-- 
-- 
-- -- thread-entry-4-no-dl
-- INSERT INTO document (id, uuid, creation_date, type, size, thmb_uuid, timestamp) VALUES (4, '92169010-edcc-11e1-8494-5404a6202d2c', current_date, 'image/png', 49105, null, null);
-- INSERT INTO entry (id, owner_id, creation_date, modification_date, name, comment, expiration_date, uuid) VALUES (4, 51, current_date, current_date, 'thread-entry-4-no-dl', '', current_date, '996eb78e-edcc-11e1-a48f-5404a6202d2c'); 
-- INSERT INTO thread_entry (entry_id, document_id, ciphered) VALUES (4, 4, false); 
-- 
-- 
-- 
-- 
-- 
-- -- doc 1: réponse, projet:ratp, phase:Instruction
-- INSERT INTO entry_tag_association (id, entry_id, tag_id, enum_value_id) VALUES (1, 1, 1, null); 
-- INSERT INTO entry_tag_association (id, entry_id, tag_id, enum_value_id) VALUES (2, 1, 3, 1); 
-- INSERT INTO entry_tag_association (id, entry_id, tag_id, enum_value_id) VALUES (3, 1, 4, 3); 
-- 
-- -- doc 2: réponse, projet:ratp, phase:Contraction
-- INSERT INTO entry_tag_association (id, entry_id, tag_id, enum_value_id) VALUES (4, 2, 1, null); 
-- INSERT INTO entry_tag_association (id, entry_id, tag_id, enum_value_id) VALUES (5, 2, 3, 1); 
-- INSERT INTO entry_tag_association (id, entry_id, tag_id, enum_value_id) VALUES (6, 2, 4, 4); 
-- 
-- -- doc 3: réponse, projet:3mi, phase:Instruction
-- INSERT INTO entry_tag_association (id, entry_id, tag_id, enum_value_id) VALUES (7, 3, 1, null); 
-- INSERT INTO entry_tag_association (id, entry_id, tag_id, enum_value_id) VALUES (8, 3, 3, 2); 
-- INSERT INTO entry_tag_association (id, entry_id, tag_id, enum_value_id) VALUES (9, 3, 4, 3); 
-- 
-- -- doc 3: question, projet:3m1, phase:Recommandation
-- INSERT INTO entry_tag_association (id, entry_id, tag_id, enum_value_id) VALUES (10, 4, 2, null); 
-- INSERT INTO entry_tag_association (id, entry_id, tag_id, enum_value_id) VALUES (11, 4, 3, 2); 
-- INSERT INTO entry_tag_association (id, entry_id, tag_id, enum_value_id) VALUES (12, 4, 4, 5); 
-- 

-- enable guests
UPDATE policy SET status=true where id=27;

-- enable thread tab
UPDATE policy SET status=true , system=false , default_status=true where id=45;

-- enable upload proposition web service
UPDATE policy SET status=true , policy=1 where id=98; -- fixme

-- enable upload request
UPDATE policy SET status=true , policy=1 where id=63;

COMMIT;
