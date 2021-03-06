SET NAMES UTF8 COLLATE utf8_general_ci;
SET CHARACTER SET UTF8;

START TRANSACTION;
-- default domain policy
INSERT INTO domain_access_policy(id) VALUES (1);
INSERT INTO domain_access_rule(id, domain_access_rule_type, ls_regexp, domain_id, domain_access_policy_id, rule_index) VALUES (1, 0, '', null, 1,0);
INSERT INTO domain_policy(id, identifier, domain_access_policy_id) VALUES (1, 'DefaultDomainPolicy', 1);


-- Root domain (application domain)
INSERT INTO domain_abstract(id, type , identifier, label, enable, template, description, default_role, default_locale, default_mail_locale, used_space, user_provider_id, domain_policy_id, parent_id, auth_show_order) VALUES (1, 0, 'LinShareRootDomain', 'LinShareRootDomain', true, false, 'The root application domain', 3, 'en', 'en', 0, null, 1, null, 0);

-- Default mime policy
INSERT INTO mime_policy(id, domain_id, uuid, name, mode, displayable, version, creation_date, modification_date) VALUES(1, 1, '3d6d8800-e0f7-11e3-8ec0-080027c0eef0', 'Default Mime Policy', 0, 0, 1, now(), now());
UPDATE domain_abstract SET mime_policy_id=1;


-- Welcome messages
INSERT INTO welcome_messages(id, uuid, name, description, creation_date, modification_date, domain_id) VALUES (1, '4bc57114-c8c9-11e4-a859-37b5db95d856', 'WelcomeName', 'a Welcome description', now(), now(), 1);

-- Melcome messages Entry
INSERT INTO welcome_messages_entry(id, lang, value, welcome_messages_id) VALUES (1, 'en', 'Welcome to LinShare, THE Secure, Open-Source File Sharing Tool.', 1);
INSERT INTO welcome_messages_entry(id, lang, value, welcome_messages_id) VALUES (2, 'fr', 'Bienvenue dans LinShare, le logiciel libre de partage de fichiers sécurisé.', 1);
INSERT INTO welcome_messages_entry(id, lang, value, welcome_messages_id) VALUES (3, 'mq', 'Bienvini an lè Linshare, an solusyon lib de partaj de fichié sékirisé.', 1);
INSERT INTO welcome_messages_entry(id, lang, value, welcome_messages_id) VALUES (4, 'vi', 'Chào mừng bạn đến với Linshare, phần mềm nguồn mở chia sẻ file bảo mật.', 1);
INSERT INTO welcome_messages_entry(id, lang, value, welcome_messages_id) VALUES (5, 'nl', 'Welkom bij LinShare, het Open Source-systeem om grote bestanden te delen.', 1);

-- Update domains
UPDATE domain_abstract SET welcome_messages_id = 1;

-- system domain pattern
-- OBM user ldap pattern.
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
    1,
    'cd26e59d-6d4c-41b4-a0eb-610fd42e1beb',
    'USER_LDAP_PATTERN',
    'default-pattern-obm',
    'This is pattern the default pattern for the ldap obm structure.',
    'ldap.search(domain, "(&(objectClass=obmUser)(mail=*)(givenName=*)(sn=*)(|(mail="+login+")(uid="+login+")))");',
    'ldap.search(domain, "(&(objectClass=obmUser)(mail="+mail+")(givenName="+first_name+")(sn="+last_name+"))");',
    true,
    'ldap.search(domain, "(&(objectClass=obmUser)(mail=*)(givenName=*)(sn=*)(|(&(sn=" + first_name + ")(givenName=" + last_name + "))(&(sn=" + last_name + ")(givenName=" + first_name + "))))");',
    'ldap.search(domain, "(&(objectClass=obmUser)(mail=*)(givenName=*)(sn=*)(|(mail=" + pattern + ")(sn=" + pattern + ")(givenName=" + pattern + ")))");',
    100,
    100,
    10,
    10,
    now(),
    now()
);
INSERT INTO ldap_attribute(id, field, attribute, sync, system, enable, ldap_pattern_id, completion) VALUES (1, 'user_mail', 'mail', false, true, true, 1, true);
INSERT INTO ldap_attribute(id, field, attribute, sync, system, enable, ldap_pattern_id, completion) VALUES (2, 'user_firstname', 'givenName', false, true, true, 1, true);
INSERT INTO ldap_attribute(id, field, attribute, sync, system, enable, ldap_pattern_id, completion) VALUES (3, 'user_lastname', 'sn', false, true, true, 1, true);
INSERT INTO ldap_attribute(id, field, attribute, sync, system, enable, ldap_pattern_id, completion) VALUES (4, 'user_uid', 'uid', false, true, true, 1, false);

-- Active Directory domain pattern.
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
    2,
    'af7ceb1e-9268-4b20-af80-21fa4bd5222c',
    'USER_LDAP_PATTERN',
    'default-pattern-AD',
    'This is pattern the default pattern for the Active Directory structure.',
    'ldap.search(domain, "(&(objectClass=user)(mail=*)(givenName=*)(sn=*)(|(mail="+login+")(sAMAccountName="+login+")))");',
    'ldap.search(domain, "(&(objectClass=user)(mail="+mail+")(givenName="+first_name+")(sn="+last_name+"))");',
    true,
    'ldap.search(domain, "(&(objectClass=user)(mail=*)(givenName=*)(sn=*)(|(&(sn=" + first_name + ")(givenName=" + last_name + "))(&(sn=" + last_name + ")(givenName=" + first_name + "))))");',
    'ldap.search(domain, "(&(objectClass=user)(mail=*)(givenName=*)(sn=*)(|(mail=" + pattern + ")(sn=" + pattern + ")(givenName=" + pattern + ")))");',
    100,
    100,
    10,
    10,
    now(),
    now()
);
INSERT INTO ldap_attribute(id, field, attribute, sync, system, enable, ldap_pattern_id, completion) VALUES (5, 'user_mail', 'mail', false, true, true, 2, true);
INSERT INTO ldap_attribute(id, field, attribute, sync, system, enable, ldap_pattern_id, completion) VALUES (6, 'user_firstname', 'givenName', false, true, true, 2, true);
INSERT INTO ldap_attribute(id, field, attribute, sync, system, enable, ldap_pattern_id, completion) VALUES (7, 'user_lastname', 'sn', false, true, true, 2, true);
INSERT INTO ldap_attribute(id, field, attribute, sync, system, enable, ldap_pattern_id, completion) VALUES (8, 'user_uid', 'sAMAccountName', false, true, true, 2, false);

-- OpenLdap domain pattern.
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
    3,
    '868400c0-c12e-456a-8c3c-19e985290586',
    'USER_LDAP_PATTERN',
    'default-pattern-openldap',
    'This is pattern the default pattern for the OpenLdap structure.',
    'ldap.search(domain, "(&(objectClass=inetOrgPerson)(mail=*)(givenName=*)(sn=*)(|(mail="+login+")(uid="+login+")))");',
    'ldap.search(domain, "(&(objectClass=inetOrgPerson)(mail="+mail+")(givenName="+first_name+")(sn="+last_name+"))");',
    true,
    'ldap.search(domain, "(&(objectClass=inetOrgPerson)(mail=*)(givenName=*)(sn=*)(|(&(sn=" + first_name + ")(givenName=" + last_name + "))(&(sn=" + last_name + ")(givenName=" + first_name + "))))");',
    'ldap.search(domain, "(&(objectClass=inetOrgPerson)(mail=*)(givenName=*)(sn=*)(|(mail=" + pattern + ")(sn=" + pattern + ")(givenName=" + pattern + ")))");',
    100,
    100,
    10,
    10,
    now(),
    now()
);
INSERT INTO ldap_attribute(id, field, attribute, sync, system, enable, ldap_pattern_id, completion) VALUES (9, 'user_mail', 'mail', false, true, true, 3, true);
INSERT INTO ldap_attribute(id, field, attribute, sync, system, enable, ldap_pattern_id, completion) VALUES (10, 'user_firstname', 'givenName', false, true, true, 3, true);
INSERT INTO ldap_attribute(id, field, attribute, sync, system, enable, ldap_pattern_id, completion) VALUES (11, 'user_lastname', 'sn', false, true, true, 3, true);
INSERT INTO ldap_attribute(id, field, attribute, sync, system, enable, ldap_pattern_id, completion) VALUES (12, 'user_uid', 'uid', false, true, true, 3, false);


-- login is e-mail address 'root@localhost.localdomain' and password is 'adminlinshare'
INSERT INTO account(id, mail, account_type, ls_uuid, creation_date, modification_date, role_id, locale, external_mail_locale,cmis_locale, enable, password, destroyed, domain_id) VALUES (1, 'root@localhost.localdomain', 6, 'root@localhost.localdomain', current_date,current_date, 3, 'en', 'en','en', true, 'JYRd2THzjEqTGYq3gjzUh2UBso8=', false, 1);
INSERT INTO users(account_id, First_name, Last_name, Can_upload, Comment, Restricted, CAN_CREATE_GUEST) VALUES (1, 'Administrator', 'LinShare', false, '', false, false);

-- system account :
INSERT INTO account(id, mail, account_type, ls_uuid, creation_date, modification_date, role_id, locale, external_mail_locale, cmis_locale, enable, destroyed, domain_id) VALUES (2, 'system', 7, 'system', now(), now(), 3, 'en', 'en', 'en', true, false, 1);
-- system account for upload-request:
INSERT INTO account(id, mail, account_type, ls_uuid, creation_date, modification_date, role_id, locale, external_mail_locale, cmis_locale, enable, destroyed, domain_id) VALUES (3, 'system-account-uploadrequest', 7, 'system-account-uploadrequest', now(), now(), 3, 'en', 'en', 'en', true, false, 1);

-- system account for upload-proposition
INSERT INTO account(id, mail, account_type, ls_uuid, creation_date, modification_date, role_id, locale, external_mail_locale, cmis_locale, enable, password, destroyed, domain_id)
	VALUES (4, 'linshare-noreply@linagora.com', 4, '89877610-574a-4e79-aeef-5606b96bde35', now(),now(), 5, 'en', 'en', 'en', true, 'JYRd2THzjEqTGYq3gjzUh2UBso8=', false, 1);
INSERT INTO users(account_id, first_name, last_name, can_upload, comment, restricted, can_create_guest)
	VALUES (4, null, 'Technical Account for upload proposition', false, '', false, false);




-- unit type : TIME(0), SIZE(1)
-- unit value : FileSizeUnit : KILO(0), MEGA(1), GIGA(2)
-- unit value : TimeUnit : DAY(0), WEEK(1), MONTH(2)
-- Policies : MANDATORY(0), ALLOWED(1), FORBIDDEN(2)


-- Functionality : FILESIZE_MAX
INSERT INTO policy(id, status, default_status, policy, system) VALUES (1, true, true, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (2, true, true, 1, false);
-- if a functionality is system, you will not be able see/modify its parameters
INSERT INTO functionality(id, system, identifier, policy_activation_id, policy_configuration_id, domain_id) VALUES (1, false, 'FILESIZE_MAX', 1, 2, 1);
INSERT INTO unit(id, unit_type, unit_value) VALUES (1, 1, 1);
INSERT INTO functionality_unit(functionality_id, integer_value, unit_id) VALUES (1, 10, 1);


-- Functionality : QUOTA_GLOBAL
INSERT INTO policy(id, status, default_status, policy, system) VALUES (3, false, false, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (4, true, true, 1, false);
INSERT INTO functionality(id, system, identifier, policy_activation_id, policy_configuration_id, domain_id) VALUES (2, false, 'QUOTA_GLOBAL', 3, 4, 1);
INSERT INTO unit(id, unit_type, unit_value) VALUES (2, 1, 1);
INSERT INTO functionality_unit(functionality_id, integer_value, unit_id) VALUES (2, 1, 2);


-- Functionality : QUOTA_USER
INSERT INTO policy(id, status, default_status, policy, system) VALUES (5, true, true, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (6, true, true, 1, false);
INSERT INTO functionality(id, system, identifier, policy_activation_id, policy_configuration_id, domain_id) VALUES (3, false, 'QUOTA_USER', 5, 6, 1);
INSERT INTO unit(id, unit_type, unit_value) VALUES (3, 1, 1);
INSERT INTO functionality_unit(functionality_id, integer_value, unit_id) VALUES (3, 100, 3);


-- Functionality : MIME_TYPE
INSERT INTO policy(id, status, default_status, policy, system) VALUES (7, false, false, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (8, false, false, 2, true);
INSERT INTO functionality(id, system, identifier, policy_activation_id, policy_configuration_id, domain_id) VALUES (4, true, 'MIME_TYPE', 7, 8, 1);


-- Functionality : SIGNATURE
INSERT INTO policy(id, status, default_status, policy, system) VALUES (9, false, false, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (10, false, false, 2, true);
INSERT INTO functionality(id, system, identifier, policy_activation_id, policy_configuration_id, domain_id) VALUES (5, true, 'SIGNATURE', 9, 10, 1);


-- Functionality : ENCIPHERMENT
INSERT INTO policy(id, status, default_status, policy, system) VALUES (11, false, false, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (12, false, false, 2, true);
INSERT INTO functionality(id, system, identifier, policy_activation_id, policy_configuration_id, domain_id) VALUES (6, true, 'ENCIPHERMENT', 11, 12, 1);


-- Functionality : TIME_STAMPING
INSERT INTO policy(id, status, default_status, policy, system) VALUES (13, false, false, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (14, true, true, 1, false);
INSERT INTO functionality(id, system, identifier, policy_activation_id, policy_configuration_id, domain_id) VALUES (7, false, 'TIME_STAMPING', 13, 14, 1);
INSERT INTO functionality_string(functionality_id, string_value) VALUES (7, 'http://localhost:8080/signserver/tsa?signerId=1');


-- Functionality : ANTIVIRUS
INSERT INTO policy(id, status, default_status, policy, system) VALUES (15, false, false, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (16, false, false, 2, true);
INSERT INTO functionality(id, system, identifier, policy_activation_id, policy_configuration_id, domain_id) VALUES (8, true, 'ANTIVIRUS', 15, 16, 1);


-- Functionality : CUSTOM_LOGO
INSERT INTO policy(id, status, default_status, policy, system) VALUES (17, false, false, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (18, true, true, 1, false);
INSERT INTO functionality(id, system, identifier, policy_activation_id, policy_configuration_id, domain_id) VALUES (9, false, 'CUSTOM_LOGO', 17, 18, 1);
INSERT INTO functionality_string(functionality_id, string_value) VALUES (9, 'http://localhost/images/logo.png');

-- Functionality : CUSTOM_LOGO__LINK
INSERT INTO policy(id, status, default_status, policy, system) VALUES (59, false, false, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (60, false, false, 1, false);
INSERT INTO functionality(id, system, identifier, policy_activation_id, policy_configuration_id, domain_id, parent_identifier, param) VALUES (29, false, 'CUSTOM_LOGO__LINK', 59, 60, 1, 'CUSTOM_LOGO', true);
INSERT INTO functionality_string(functionality_id, string_value) VALUES (29, 'http://localhost:8080/linshare/en');

-- Functionality : GUESTS
INSERT INTO policy(id, status, default_status, policy, system) VALUES (27, false, false, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (28, false, false, 2, true);
INSERT INTO functionality(id, system, identifier, policy_activation_id, policy_configuration_id, domain_id) VALUES (14, true, 'GUESTS', 27, 28, 1);

-- Functionality : GUESTS__EXPIRATION (for Guests)
INSERT INTO policy(id, status, default_status, policy, system) VALUES (19, true, true, 0, true);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (20, true, true, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (111, true, true, 1, false);
INSERT INTO functionality(id, system, identifier, policy_activation_id, policy_configuration_id, policy_delegation_id, domain_id, parent_identifier, param) VALUES (10, false, 'GUESTS__EXPIRATION', 19, 20, 111, 1, 'GUESTS', true);
INSERT INTO unit(id, unit_type, unit_value) VALUES (4, 0, 2);
INSERT INTO functionality_unit(functionality_id, integer_value, unit_id) VALUES (10, 3, 4);

-- Functionality : GUESTS__RESTRICTED
INSERT INTO policy(id, status, default_status, policy, system) VALUES (47, true, true, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (48, true, true, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (112, true, true, 1, false);
INSERT INTO functionality(id, system, identifier, policy_activation_id, policy_configuration_id, policy_delegation_id, domain_id, parent_identifier, param) VALUES (24, false, 'GUESTS__RESTRICTED', 47, 48, 112, 1, 'GUESTS', true);
INSERT INTO functionality_boolean(functionality_id, boolean_value) VALUES (24, true);

-- Functionality : GUESTS__CAN_UPLOAD
INSERT INTO policy(id, status, default_status, policy, system) VALUES (113, true, true, 0, true);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (114, true, true, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (115, true, true, 1, false);
INSERT INTO functionality(id, system, identifier, policy_activation_id, policy_configuration_id, policy_delegation_id, domain_id, parent_identifier, param) VALUES (48, false, 'GUESTS__CAN_UPLOAD', 113, 114, 115, 1, 'GUESTS', true);
INSERT INTO functionality_boolean(functionality_id, boolean_value) VALUES (48, true);

-- Functionality : FILE_EXPIRATION
INSERT INTO policy(id, status, default_status, policy, system) VALUES (21, true, true, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (22, true, true, 1, false);
INSERT INTO functionality(id, system, identifier, policy_activation_id, policy_configuration_id, domain_id) VALUES (11, false, 'FILE_EXPIRATION', 21, 22, 1);
INSERT INTO unit(id, unit_type, unit_value) VALUES (5, 0, 2);
INSERT INTO functionality_unit(functionality_id, integer_value, unit_id) VALUES (11, 3, 5);


-- Functionality : SHARE_EXPIRATION
INSERT INTO policy(id, status, default_status, policy, system) VALUES (23, true, true, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (24, true, true, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (122, true, true, 1, false);
INSERT INTO functionality(id, system, identifier, policy_activation_id, policy_configuration_id, policy_delegation_id, domain_id) VALUES (12, false, 'SHARE_EXPIRATION', 23, 24, 122, 1);
INSERT INTO unit(id, unit_type, unit_value) VALUES (6, 0, 2);
INSERT INTO functionality_unit(functionality_id, integer_value, unit_id) VALUES (12, 3, 6);

-- Functionality : SHARE_EXPIRATION__DELETE_FILE_ON_EXPIRATION
INSERT INTO policy(id, status, default_status, policy, system) VALUES (120, true, true, 0, true);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (121, true, true, 1, false);
INSERT INTO functionality(id, system, identifier, policy_activation_id, policy_configuration_id, domain_id, parent_identifier, param) VALUES (50, false, 'SHARE_EXPIRATION__DELETE_FILE_ON_EXPIRATION', 120, 121, 1, 'SHARE_EXPIRATION', true);
INSERT INTO functionality_boolean(functionality_id, boolean_value) VALUES (50, false);


-- Functionality : ANONYMOUS_URL
INSERT INTO policy(id, status, default_status, policy, system) VALUES (25, true, true, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (26, true, true, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (116, true, true, 1, false);
INSERT INTO functionality(id, system, identifier, policy_activation_id, policy_configuration_id, policy_delegation_id, domain_id) VALUES (13, false, 'ANONYMOUS_URL', 25, 26, 116, 1);
INSERT INTO functionality_boolean(functionality_id, boolean_value) VALUES (13, true);


-- Functionality : INTERNAL_CAN_UPLOAD formerly known as USER_CAN_UPLOAD
INSERT INTO policy(id, status, default_status, policy, system) VALUES (29, true, true, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (30, false, false, 2, true);
INSERT INTO functionality(id, system, identifier, policy_activation_id, policy_configuration_id, domain_id) VALUES (15, true, 'INTERNAL_CAN_UPLOAD', 29, 30, 1);
INSERT INTO functionality_boolean(functionality_id, boolean_value) VALUES (15, true);


-- Functionality : COMPLETION
INSERT INTO policy(id, status, default_status, policy, system) VALUES (31, true, true, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (32, true, true, 1, false);
INSERT INTO functionality(id, system, identifier, policy_activation_id, policy_configuration_id, domain_id) VALUES (16, false, 'COMPLETION', 31, 32, 1);
INSERT INTO functionality_integer(functionality_id, integer_value) VALUES (16, 3);


-- Functionality : TAB_HELP
INSERT INTO policy(id, status, default_status, policy, system) VALUES (33, true, true, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (34, false, false, 1, true);
INSERT INTO functionality(id, system, identifier, policy_activation_id, policy_configuration_id, domain_id) VALUES (17, true, 'TAB_HELP', 33, 34, 1);


-- Functionality : TAB_AUDIT
INSERT INTO policy(id, status, default_status, policy, system) VALUES (35, true, true, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (36, false, false, 1, true);
INSERT INTO functionality(id, system, identifier, policy_activation_id, policy_configuration_id, domain_id) VALUES (18, true, 'TAB_AUDIT', 35, 36, 1);


-- Functionality : TAB_USER
INSERT INTO policy(id, status, default_status, policy, system) VALUES (37, true, true, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (38, false, false, 1, true);
INSERT INTO functionality(id, system, identifier, policy_activation_id, policy_configuration_id, domain_id) VALUES (19, true, 'TAB_USER', 37, 38, 1);


-- Functionality : SHARE_NOTIFICATION_BEFORE_EXPIRATION
-- Policies : MANDATORY(0), ALLOWED(1), FORBIDDEN(2)
INSERT INTO policy(id, status, default_status, policy, system) VALUES (43, true, true, 0, true);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (44, false, false, 2, true);
INSERT INTO functionality(id, system, identifier, policy_activation_id, policy_configuration_id, domain_id) VALUES (22, false, 'SHARE_NOTIFICATION_BEFORE_EXPIRATION', 43, 44, 1);
INSERT INTO functionality_string(functionality_id, string_value) VALUES (22, '2,7');

-- Functionality : TAB_THREAD
INSERT INTO policy(id, status, default_status, policy, system) VALUES (45, true, true, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (46, false, false, 1, true);
-- if a functionality is system, you will not be able see/modify its parameters
INSERT INTO functionality(id, system, identifier, policy_activation_id, policy_configuration_id, domain_id) VALUES (23, true, 'TAB_THREAD', 45, 46, 1);

-- Functionality : TAB_THREAD__CREATE_PERMISSION
INSERT INTO policy(id, status, default_status, policy, system) VALUES (57, true, true, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (58, false, false, 1, false);
INSERT INTO functionality(id, system, identifier, policy_activation_id, policy_configuration_id, domain_id, parent_identifier, param) VALUES (28, true, 'TAB_THREAD__CREATE_PERMISSION', 57, 58, 1, 'TAB_THREAD', true);

-- Functionality : TAB_LIST
INSERT INTO policy(id, status, default_status, policy, system) VALUES (53, true, true, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (54, false, false, 1, true);
INSERT INTO functionality(id, system, identifier, policy_activation_id, policy_configuration_id, domain_id) VALUES (26, true, 'TAB_LIST', 53, 54, 1);

-- Functionality : UPDATE_FILE
INSERT INTO policy(id, status, default_status, policy, system) VALUES (55, true, true, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (56, false, false, 1, true);
INSERT INTO functionality(id, system, identifier, policy_activation_id, policy_configuration_id, domain_id) VALUES (27, true, 'UPDATE_FILE', 55, 56, 1);

-- Functionality : DOMAIN
INSERT INTO policy(id, status, default_status, policy, system) VALUES (118, true, true, 0, true);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (119, false, false, 2, true);
INSERT INTO functionality(id, system, identifier, policy_activation_id, policy_configuration_id, domain_id) VALUES(49, false, 'DOMAIN', 118, 119, 1);

-- Functionality : DOMAIN__NOTIFICATION_URL
INSERT INTO policy(id, status, default_status, policy, system) VALUES (61, true, true, 0, true);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (62, false, false, 1, false);
INSERT INTO functionality(id, system, identifier, policy_activation_id, policy_configuration_id, domain_id, parent_identifier, param) VALUES(30, false, 'DOMAIN__NOTIFICATION_URL', 61, 62, 1, 'DOMAIN', true);
INSERT INTO functionality_string(functionality_id, string_value) VALUES (30, 'http://localhost:8080/linshare/');

-- Functionality : DOMAIN_MAIL
INSERT INTO policy(id, status, default_status, policy, system) VALUES (49, true, true, 0, true);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (50, false, false, 2, false);
INSERT INTO functionality(id, system, identifier, policy_activation_id, policy_configuration_id, domain_id, parent_identifier, param) VALUES (25, false, 'DOMAIN__MAIL', 49, 50, 1, 'DOMAIN', true);
INSERT INTO functionality_string(functionality_id, string_value) VALUES (25, 'linshare-noreply@linagora.com');


-- Functionality : UPLOAD_REQUEST
INSERT INTO policy(id, status, default_status, policy, system) VALUES (63, false, false, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (64, true, true, 1, true);
INSERT INTO functionality(id, system, identifier, policy_activation_id, policy_configuration_id, domain_id) VALUES(31, false, 'UPLOAD_REQUEST', 63, 64, 1);
INSERT INTO functionality_string(functionality_id, string_value) VALUES (31, 'http://linshare-upload-request.local');

-- Functionality : UPLOAD_REQUEST__DELAY_BEFORE_ACTIVATION
INSERT INTO policy(id, status, default_status, policy, system) VALUES (65, true, true, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (66, true, true, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (67, true, true, 1, false);
INSERT INTO functionality(id, system, identifier, policy_activation_id, policy_configuration_id, policy_delegation_id, domain_id, parent_identifier, param)
 VALUES(32, false, 'UPLOAD_REQUEST__DELAY_BEFORE_ACTIVATION', 65, 66, 67, 1, 'UPLOAD_REQUEST', true);
INSERT INTO unit(id, unit_type, unit_value) VALUES (7, 0, 2);
INSERT INTO functionality_unit(functionality_id, integer_value, unit_id) VALUES (32, 0, 7);

-- Functionality : UPLOAD_REQUEST__DELAY_BEFORE_EXPIRATION
INSERT INTO policy(id, status, default_status, policy, system) VALUES (68, true, true, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (69, true, true, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (70, true, true, 1, false);
INSERT INTO functionality(id, system, identifier, policy_activation_id, policy_configuration_id, policy_delegation_id, domain_id, parent_identifier, param)
 VALUES(33, false, 'UPLOAD_REQUEST__DELAY_BEFORE_EXPIRATION', 68, 69, 70, 1, 'UPLOAD_REQUEST', true);
-- time unit : month
 INSERT INTO unit(id, unit_type, unit_value) VALUES (8, 0, 2);
-- month : 1 month
INSERT INTO functionality_unit(functionality_id, integer_value, unit_id) VALUES (33, 1, 8);

-- Functionality : UPLOAD_REQUEST__GROUPED_MODE
INSERT INTO policy(id, status, default_status, policy, system) VALUES (71, false, false, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (72, true, true, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (73, false, false, 1, false);
INSERT INTO functionality(id, system, identifier, policy_activation_id, policy_configuration_id, policy_delegation_id, domain_id, parent_identifier, param)
 VALUES(34, false, 'UPLOAD_REQUEST__GROUPED_MODE', 71, 72, 73, 1, 'UPLOAD_REQUEST', true);
INSERT INTO functionality_boolean(functionality_id, boolean_value) VALUES (34, false);

-- Functionality : UPLOAD_REQUEST__MAXIMUM_FILE_COUNT
INSERT INTO policy(id, status, default_status, policy, system) VALUES (74, true, true, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (75, true, true, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (76, true, true, 1, false);
INSERT INTO functionality(id, system, identifier, policy_activation_id, policy_configuration_id, policy_delegation_id, domain_id, parent_identifier, param)
 VALUES(35, false, 'UPLOAD_REQUEST__MAXIMUM_FILE_COUNT', 74, 75, 76, 1, 'UPLOAD_REQUEST', true);
INSERT INTO functionality_integer(functionality_id, integer_value) VALUES (35, 3);

-- Functionality : UPLOAD_REQUEST__MAXIMUM_FILE_SIZE
INSERT INTO policy(id, status, default_status, policy, system) VALUES (77, true, true, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (78, true, true, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (79, true, true, 1, false);
INSERT INTO functionality(id, system, identifier, policy_activation_id, policy_configuration_id, policy_delegation_id, domain_id, parent_identifier, param)
 VALUES(36, false, 'UPLOAD_REQUEST__MAXIMUM_FILE_SIZE', 77, 78, 79, 1, 'UPLOAD_REQUEST', true);
 -- file size unit : Mega
INSERT INTO unit(id, unit_type, unit_value) VALUES (9, 1, 1);
-- size : 10 Mega
INSERT INTO functionality_unit(functionality_id, integer_value, unit_id) VALUES (36, 10, 9);

-- Functionality : UPLOAD_REQUEST__MAXIMUM_DEPOSIT_SIZE
INSERT INTO policy(id, status, default_status, policy, system) VALUES (80, false, false, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (81, true, true, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (82, true, true, 1, false);
INSERT INTO functionality(id, system, identifier, policy_activation_id, policy_configuration_id, policy_delegation_id, domain_id, parent_identifier, param)
 VALUES(37, false, 'UPLOAD_REQUEST__MAXIMUM_DEPOSIT_SIZE', 80, 81, 82, 1, 'UPLOAD_REQUEST', true);
 -- file size unit : Mega
INSERT INTO unit(id, unit_type, unit_value) VALUES (10, 1, 1);
-- size : 30 Mega
INSERT INTO functionality_unit(functionality_id, integer_value, unit_id) VALUES (37, 30, 10);

-- Functionality : UPLOAD_REQUEST__NOTIFICATION_LANGUAGE
INSERT INTO policy(id, status, default_status, policy, system) VALUES (83, true, true, 1, true);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (84, true, true, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (85, true, true, 1, false);
INSERT INTO functionality(id, system, identifier, policy_activation_id, policy_configuration_id, policy_delegation_id, domain_id, parent_identifier, param)
 VALUES(38, false, 'UPLOAD_REQUEST__NOTIFICATION_LANGUAGE', 83, 84, 85, 1, 'UPLOAD_REQUEST', true);
INSERT INTO functionality_enum_lang(functionality_id, lang_value) VALUES (38, 'en');

-- Functionality : UPLOAD_REQUEST__SECURED_URL
INSERT INTO policy(id, status, default_status, policy, system) VALUES (86, false, false, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (87, false, false, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (88, false, false, 1, false);
INSERT INTO functionality(id, system, identifier, policy_activation_id, policy_configuration_id, policy_delegation_id, domain_id, parent_identifier, param)
 VALUES(39, false, 'UPLOAD_REQUEST__SECURED_URL', 86, 87, 88, 1, 'UPLOAD_REQUEST', true);
INSERT INTO functionality_boolean(functionality_id, boolean_value) VALUES (39, false);

-- Functionality : UPLOAD_REQUEST__PROLONGATION
INSERT INTO policy(id, status, default_status, policy, system) VALUES (89, false, false, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (90, false, false, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (91, false, false, 1, false);
INSERT INTO functionality(id, system, identifier, policy_activation_id, policy_configuration_id, policy_delegation_id, domain_id, parent_identifier, param)
 VALUES(40, false, 'UPLOAD_REQUEST__PROLONGATION', 89, 90, 91, 1, 'UPLOAD_REQUEST', true);
INSERT INTO functionality_boolean(functionality_id, boolean_value) VALUES (40, false);

-- Functionality : UPLOAD_REQUEST__CAN_DELETE
INSERT INTO policy(id, status, default_status, policy, system) VALUES (92, true, true, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (93, true, true, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (94, true, true, 1, false);
INSERT INTO functionality(id, system, identifier, policy_activation_id, policy_configuration_id, policy_delegation_id, domain_id, parent_identifier, param)
 VALUES(41, false, 'UPLOAD_REQUEST__CAN_DELETE', 92, 93, 94, 1, 'UPLOAD_REQUEST', true);
INSERT INTO functionality_boolean(functionality_id, boolean_value) VALUES (41, true);

-- Functionality : UPLOAD_REQUEST__DELAY_BEFORE_NOTIFICATION
INSERT INTO policy(id, status, default_status, policy, system) VALUES (95, true, true, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (96, true, true, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (97, true, true, 1, false);
INSERT INTO functionality(id, system, identifier, policy_activation_id, policy_configuration_id, policy_delegation_id, domain_id, parent_identifier, param)
 VALUES(42, false, 'UPLOAD_REQUEST__DELAY_BEFORE_NOTIFICATION', 95, 96, 97, 1, 'UPLOAD_REQUEST', true);
-- time unit : day
INSERT INTO unit(id, unit_type, unit_value) VALUES (11, 0, 0);
-- time : 7 days
INSERT INTO functionality_unit(functionality_id, integer_value, unit_id) VALUES (42, 7, 11);

-- Functionality : UPLOAD_REQUEST__CAN_CLOSE
INSERT INTO policy(id, status, default_status, policy, system) VALUES (98, true, true, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (99, true, true, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (100, true, true, 1, false);
INSERT INTO functionality(id, system, identifier, policy_activation_id, policy_configuration_id, policy_delegation_id, domain_id, parent_identifier, param)
 VALUES(43, false, 'UPLOAD_REQUEST__CAN_CLOSE', 98, 99, 100, 1, 'UPLOAD_REQUEST', true);
INSERT INTO functionality_boolean(functionality_id, boolean_value) VALUES (43, true);

 -- Functionality : UPLOAD_PROPOSITION
INSERT INTO policy(id, status, default_status, policy, system) VALUES (101, false, false, 2, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (102, true, true, 1, true);
INSERT INTO functionality(id, system, identifier, policy_activation_id, policy_configuration_id, domain_id)
 VALUES(44, false, 'UPLOAD_PROPOSITION', 101, 102, 1);

-- Functionality : GUEST__EXPIRATION_ALLOW_PROLONGATION
INSERT INTO policy(id, status, default_status, policy, system) VALUES (123, true, true, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (124, true, true, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (125, true, true, 1, false);
INSERT INTO functionality(id, system, identifier, policy_activation_id, policy_configuration_id, policy_delegation_id, domain_id, parent_identifier, param) VALUES(51, false, 'GUESTS__EXPIRATION_ALLOW_PROLONGATION', 123, 124, 125, 1, 'GUESTS', true);
INSERT INTO functionality_boolean(functionality_id, boolean_value) VALUES (51, true);

-- Functionality : UPLOAD_REQUEST_ENABLE_TEMPLATE
INSERT INTO policy(id, status, default_status, policy, system) VALUES (129, false, false, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (130, true, true, 1, true);
INSERT INTO functionality(id, system, identifier, policy_activation_id, policy_configuration_id, domain_id, param)
 VALUES(53, false, 'UPLOAD_REQUEST_ENABLE_TEMPLATE', 129, 130, 1, false);

-- Functionality : SHARE_CREATION_ACKNOWLEDGEMENT_FOR_OWNER
INSERT INTO policy(id, status, default_status, policy, system) VALUES (126, true, true, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (127, true, true, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (128, true, true, 1, false);
INSERT INTO functionality(id, system, identifier, policy_activation_id, policy_configuration_id, policy_delegation_id, domain_id) VALUES(52, false, 'SHARE_CREATION_ACKNOWLEDGEMENT_FOR_OWNER', 126, 127, 128, 1);
INSERT INTO functionality_boolean(functionality_id, boolean_value) VALUES (52, true);

-- Functionality : UNDOWNLOADED_SHARED_DOCUMENTS_ALERT
INSERT INTO policy(id, status, default_status, policy, system) VALUES (131, true, true, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (132, true, true, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (133, true, true, 1, false);
INSERT INTO functionality(id, system, identifier, policy_activation_id, policy_configuration_id, policy_delegation_id, domain_id)
 VALUES(54, false, 'UNDOWNLOADED_SHARED_DOCUMENTS_ALERT', 131, 132, 133, 1);
INSERT INTO functionality_boolean(functionality_id, boolean_value) VALUES (54, true);

-- Functionality : UNDOWNLOADED_SHARED_DOCUMENTS_ALERT__DURATION
INSERT INTO policy(id, status, default_status, policy, system) VALUES (134, true, true, 0, true);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (135, true, true, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (136, true, true, 1, false);
INSERT INTO functionality(id, system, identifier, policy_activation_id, policy_configuration_id, policy_delegation_id, domain_id, parent_identifier, param)
 VALUES(55, false, 'UNDOWNLOADED_SHARED_DOCUMENTS_ALERT__DURATION', 134, 135, 136, 1, 'UNDOWNLOADED_SHARED_DOCUMENTS_ALERT', true);
INSERT INTO functionality_integer(functionality_id, integer_value) VALUES (55, 3);

-- Functionality : ANONYMOUS_URL__NOTIFICATION
INSERT INTO policy(id, status, default_status, policy, system) VALUES (224, true, true, 0, true);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (225, true, true, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (226, false, false, 2, true);
INSERT INTO functionality(id, system, identifier, policy_activation_id, policy_configuration_id, policy_delegation_id, domain_id, parent_identifier, param)
 VALUES(56, false, 'ANONYMOUS_URL__NOTIFICATION', 224, 225, 226, 1, 'ANONYMOUS_URL', true);
INSERT INTO functionality_boolean(functionality_id, boolean_value) VALUES (56, true);

-- Functionality: END


-- MailActivation : BEGIN

-- MailActivation : ANONYMOUS_DOWNLOAD
INSERT INTO policy(id, status, default_status, policy, system) VALUES (137, true, true, 0, true);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (138, true, true, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (139, false, false, 2, true);
INSERT INTO mail_activation(id, system, identifier, policy_activation_id, policy_configuration_id, policy_delegation_id, domain_id, enable)
 VALUES(1, false, 'ANONYMOUS_DOWNLOAD', 137, 138, 139, 1, true);

-- MailActivation : REGISTERED_DOWNLOAD
INSERT INTO policy(id, status, default_status, policy, system) VALUES (140, true, true, 0, true);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (141, true, true, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (142, false, false, 2, true);
INSERT INTO mail_activation(id, system, identifier, policy_activation_id, policy_configuration_id, policy_delegation_id, domain_id, enable)
 VALUES(2, false, 'REGISTERED_DOWNLOAD', 140, 141, 142, 1, true);

-- MailActivation : NEW_GUEST
INSERT INTO policy(id, status, default_status, policy, system) VALUES (143, true, true, 0, true);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (144, true, true, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (145, false, false, 2, true);
INSERT INTO mail_activation(id, system, identifier, policy_activation_id, policy_configuration_id, policy_delegation_id, domain_id, enable)
 VALUES(3, false, 'NEW_GUEST', 143, 144, 145, 1, true);

-- MailActivation : RESET_PASSWORD
INSERT INTO policy(id, status, default_status, policy, system) VALUES (146, true, true, 0, true);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (147, true, true, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (148, false, false, 2, true);
INSERT INTO mail_activation(id, system, identifier, policy_activation_id, policy_configuration_id, policy_delegation_id, domain_id, enable)
 VALUES(4, false, 'RESET_PASSWORD', 146, 147, 148, 1, true);

-- MailActivation : SHARED_DOC_UPDATED
INSERT INTO policy(id, status, default_status, policy, system) VALUES (149, true, true, 0, true);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (150, true, true, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (151, false, false, 2, true);
INSERT INTO mail_activation(id, system, identifier, policy_activation_id, policy_configuration_id, policy_delegation_id, domain_id, enable)
 VALUES(5, false, 'SHARED_DOC_UPDATED', 149, 150, 151, 1, true);

-- MailActivation : SHARED_DOC_DELETED
INSERT INTO policy(id, status, default_status, policy, system) VALUES (152, true, true, 0, true);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (153, true, true, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (154, false, false, 2, true);
INSERT INTO mail_activation(id, system, identifier, policy_activation_id, policy_configuration_id, policy_delegation_id, domain_id, enable)
 VALUES(6, false, 'SHARED_DOC_DELETED', 152, 153, 154, 1, true);

-- MailActivation : SHARED_DOC_UPCOMING_OUTDATED
INSERT INTO policy(id, status, default_status, policy, system) VALUES (155, true, true, 0, true);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (156, true, true, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (157, false, false, 2, true);
INSERT INTO mail_activation(id, system, identifier, policy_activation_id, policy_configuration_id, policy_delegation_id, domain_id, enable)
 VALUES(7, false, 'SHARED_DOC_UPCOMING_OUTDATED', 155, 156, 157, 1, true);

-- MailActivation : DOC_UPCOMING_OUTDATED
INSERT INTO policy(id, status, default_status, policy, system) VALUES (158, true, true, 0, true);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (159, true, true, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (160, false, false, 2, true);
INSERT INTO mail_activation(id, system, identifier, policy_activation_id, policy_configuration_id, policy_delegation_id, domain_id, enable)
 VALUES(8, false, 'DOC_UPCOMING_OUTDATED', 158, 159, 160, 1, true);

-- MailActivation : NEW_SHARING
INSERT INTO policy(id, status, default_status, policy, system) VALUES (161, true, true, 0, true);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (162, true, true, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (163, false, false, 2, true);
INSERT INTO mail_activation(id, system, identifier, policy_activation_id, policy_configuration_id, policy_delegation_id, domain_id, enable)
 VALUES(9, false, 'NEW_SHARING', 161, 162, 163, 1, true);

-- MailActivation : UPLOAD_PROPOSITION_CREATED
INSERT INTO policy(id, status, default_status, policy, system) VALUES (164, true, true, 0, true);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (165, true, true, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (166, false, false, 2, true);
INSERT INTO mail_activation(id, system, identifier, policy_activation_id, policy_configuration_id, policy_delegation_id, domain_id, enable)
 VALUES(10, false, 'UPLOAD_PROPOSITION_CREATED', 164, 165, 166, 1, true);

-- MailActivation : UPLOAD_PROPOSITION_REJECTED
INSERT INTO policy(id, status, default_status, policy, system) VALUES (167, true, true, 0, true);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (168, true, true, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (169, false, false, 2, true);
INSERT INTO mail_activation(id, system, identifier, policy_activation_id, policy_configuration_id, policy_delegation_id, domain_id, enable)
 VALUES(11, false, 'UPLOAD_PROPOSITION_REJECTED', 167, 168, 169, 1, true);

-- MailActivation : UPLOAD_REQUEST_UPDATED
INSERT INTO policy(id, status, default_status, policy, system) VALUES (170, true, true, 0, true);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (171, true, true, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (172, false, false, 2, true);
INSERT INTO mail_activation(id, system, identifier, policy_activation_id, policy_configuration_id, policy_delegation_id, domain_id, enable)
 VALUES(12, false, 'UPLOAD_REQUEST_UPDATED', 170, 171, 172, 1, true);

-- MailActivation : UPLOAD_REQUEST_ACTIVATED
INSERT INTO policy(id, status, default_status, policy, system) VALUES (173, true, true, 0, true);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (174, true, true, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (175, false, false, 2, true);
INSERT INTO mail_activation(id, system, identifier, policy_activation_id, policy_configuration_id, policy_delegation_id, domain_id, enable)
 VALUES(13, false, 'UPLOAD_REQUEST_ACTIVATED', 173, 174, 175, 1, true);

-- MailActivation : UPLOAD_REQUEST_AUTO_FILTER
INSERT INTO policy(id, status, default_status, policy, system) VALUES (176, true, true, 0, true);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (177, true, true, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (178, false, false, 2, true);
INSERT INTO mail_activation(id, system, identifier, policy_activation_id, policy_configuration_id, policy_delegation_id, domain_id, enable)
 VALUES(14, false, 'UPLOAD_REQUEST_AUTO_FILTER', 176, 177, 178, 1, true);

-- MailActivation : UPLOAD_REQUEST_CREATED
INSERT INTO policy(id, status, default_status, policy, system) VALUES (179, true, true, 0, true);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (180, true, true, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (181, false, false, 2, true);
INSERT INTO mail_activation(id, system, identifier, policy_activation_id, policy_configuration_id, policy_delegation_id, domain_id, enable)
 VALUES(15, false, 'UPLOAD_REQUEST_CREATED', 179, 180, 181, 1, true);

-- MailActivation : UPLOAD_REQUEST_ACKNOWLEDGEMENT
INSERT INTO policy(id, status, default_status, policy, system) VALUES (182, true, true, 0, true);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (183, true, true, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (184, false, false, 2, true);
INSERT INTO mail_activation(id, system, identifier, policy_activation_id, policy_configuration_id, policy_delegation_id, domain_id, enable)
 VALUES(16, false, 'UPLOAD_REQUEST_ACKNOWLEDGEMENT', 182, 183, 184, 1, true);

-- MailActivation : UPLOAD_REQUEST_REMINDER
INSERT INTO policy(id, status, default_status, policy, system) VALUES (185, true, true, 0, true);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (186, true, true, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (187, false, false, 2, true);
INSERT INTO mail_activation(id, system, identifier, policy_activation_id, policy_configuration_id, policy_delegation_id, domain_id, enable)
 VALUES(17, false, 'UPLOAD_REQUEST_REMINDER', 185, 186, 187, 1, true);

-- MailActivation : UPLOAD_REQUEST_WARN_OWNER_BEFORE_EXPIRY
INSERT INTO policy(id, status, default_status, policy, system) VALUES (188, true, true, 0, true);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (189, true, true, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (190, false, false, 2, true);
INSERT INTO mail_activation(id, system, identifier, policy_activation_id, policy_configuration_id, policy_delegation_id, domain_id, enable)
 VALUES(18, false, 'UPLOAD_REQUEST_WARN_OWNER_BEFORE_EXPIRY', 188, 189, 190, 1, true);

-- MailActivation : UPLOAD_REQUEST_WARN_RECIPIENT_BEFORE_EXPIRY
INSERT INTO policy(id, status, default_status, policy, system) VALUES (191, true, true, 0, true);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (192, true, true, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (193, false, false, 2, true);
INSERT INTO mail_activation(id, system, identifier, policy_activation_id, policy_configuration_id, policy_delegation_id, domain_id, enable)
 VALUES(19, false, 'UPLOAD_REQUEST_WARN_RECIPIENT_BEFORE_EXPIRY', 191, 192, 193, 1, true);

-- MailActivation : UPLOAD_REQUEST_WARN_OWNER_EXPIRY
INSERT INTO policy(id, status, default_status, policy, system) VALUES (194, true, true, 0, true);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (195, true, true, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (196, false, false, 2, true);
INSERT INTO mail_activation(id, system, identifier, policy_activation_id, policy_configuration_id, policy_delegation_id, domain_id, enable)
 VALUES(20, false, 'UPLOAD_REQUEST_WARN_OWNER_EXPIRY', 194, 195, 196, 1, true);

-- MailActivation : UPLOAD_REQUEST_WARN_RECIPIENT_EXPIRY
INSERT INTO policy(id, status, default_status, policy, system) VALUES (197, true, true, 0, true);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (198, true, true, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (199, false, false, 2, true);
INSERT INTO mail_activation(id, system, identifier, policy_activation_id, policy_configuration_id, policy_delegation_id, domain_id, enable)
 VALUES(21, false, 'UPLOAD_REQUEST_WARN_RECIPIENT_EXPIRY', 197, 198, 199, 1, true);

-- MailActivation : UPLOAD_REQUEST_CLOSED_BY_RECIPIENT
INSERT INTO policy(id, status, default_status, policy, system) VALUES (200, true, true, 0, true);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (201, true, true, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (202, false, false, 2, true);
INSERT INTO mail_activation(id, system, identifier, policy_activation_id, policy_configuration_id, policy_delegation_id, domain_id, enable)
 VALUES(22, false, 'UPLOAD_REQUEST_CLOSED_BY_RECIPIENT', 200, 201, 202, 1, true);

-- MailActivation : UPLOAD_REQUEST_CLOSED_BY_OWNER
INSERT INTO policy(id, status, default_status, policy, system) VALUES (203, true, true, 0, true);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (204, true, true, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (205, false, false, 2, true);
INSERT INTO mail_activation(id, system, identifier, policy_activation_id, policy_configuration_id, policy_delegation_id, domain_id, enable)
 VALUES(23, false, 'UPLOAD_REQUEST_CLOSED_BY_OWNER', 203, 204, 205, 1, true);

-- MailActivation : UPLOAD_REQUEST_DELETED_BY_OWNER
INSERT INTO policy(id, status, default_status, policy, system) VALUES (206, true, true, 0, true);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (207, true, true, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (208, false, false, 2, true);
INSERT INTO mail_activation(id, system, identifier, policy_activation_id, policy_configuration_id, policy_delegation_id, domain_id, enable)
 VALUES(24, false, 'UPLOAD_REQUEST_DELETED_BY_OWNER', 206, 207, 208, 1, true);

-- MailActivation : UPLOAD_REQUEST_NO_SPACE_LEFT
INSERT INTO policy(id, status, default_status, policy, system) VALUES (209, true, true, 0, true);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (210, true, true, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (211, false, false, 2, true);
INSERT INTO mail_activation(id, system, identifier, policy_activation_id, policy_configuration_id, policy_delegation_id, domain_id, enable)
 VALUES(25, false, 'UPLOAD_REQUEST_NO_SPACE_LEFT', 209, 210, 211, 1, true);

-- MailActivation : UPLOAD_REQUEST_ENTRY_URL
INSERT INTO policy(id, status, default_status, policy, system) VALUES (212, true, true, 0, true);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (213, true, true, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (214, false, false, 2, true);
INSERT INTO mail_activation(id, system, identifier, policy_activation_id, policy_configuration_id, policy_delegation_id, domain_id, enable)
 VALUES(26, false, 'UPLOAD_REQUEST_ENTRY_URL', 212, 213, 214, 1, true);

-- MailActivation : UPLOAD_REQUEST_FILE_DELETED_BY_SENDER
INSERT INTO policy(id, status, default_status, policy, system) VALUES (215, true, true, 0, true);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (216, true, true, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (217, false, false, 2, true);
INSERT INTO mail_activation(id, system, identifier, policy_activation_id, policy_configuration_id, policy_delegation_id, domain_id, enable)
 VALUES(27, false, 'UPLOAD_REQUEST_FILE_DELETED_BY_SENDER', 215, 216, 217, 1, true);

-- MailActivation : SHARE_CREATION_ACKNOWLEDGEMENT_FOR_OWNER
INSERT INTO policy(id, status, default_status, policy, system) VALUES (218, true, true, 0, true);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (219, true, true, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (220, false, false, 2, true);
INSERT INTO mail_activation(id, system, identifier, policy_activation_id, policy_configuration_id, policy_delegation_id, domain_id, enable)
 VALUES(28, false, 'SHARE_CREATION_ACKNOWLEDGEMENT_FOR_OWNER', 218, 219, 220, 1, true);

-- MailActivation : UNDOWNLOADED_SHARED_DOCUMENTS_ALERT
INSERT INTO policy(id, status, default_status, policy, system) VALUES (221, true, true, 0, true);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (222, true, true, 1, false);
INSERT INTO policy(id, status, default_status, policy, system) VALUES (223, false, false, 2, true);
INSERT INTO mail_activation(id, system, identifier, policy_activation_id, policy_configuration_id, policy_delegation_id, domain_id, enable)
 VALUES(29, false, 'UNDOWNLOADED_SHARED_DOCUMENTS_ALERT', 221, 222, 223, 1, true);

-- MailActivation : END

-- %{image}    <img src="cid:image.part.1@linshare.org" /><br/><br/>

INSERT INTO mail_layout (id, name,domain_abstract_id,visible,plaintext,modification_date,creation_date,uuid,layout) VALUES (1, 'Default HTML layout', 1,true,false,now(),now(),'15044750-89d1-11e3-8d50-5404a683a462', '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">\n<html xmlns="http://www.w3.org/1999/xhtml">\n<head>\n<title>${mailSubject}</title>\n<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />\n<meta http-equiv="Content-Style-Type" content="text/css" />\n<style type="text/css">\npre { margin-top: .25em; font-family: Verdana, Arial, Helvetica, sans-serif; color: blue; }\nul { margin-top: .25em; padding-left: 1.5em; }\n</style>\n</head>\n<body>\n${image}\n${personalMessage}\n${greetings}\n${body}\n <hr/>\n${footer}\n</body>\n</html>');
INSERT INTO mail_layout (id, name,domain_abstract_id,visible,plaintext,modification_date,creation_date,uuid,layout) VALUES (2, 'Default plaintext layout', 1,true,true,now(),now(),'db044da6-89d1-11e3-b6a9-5404a683a462', '${personalMessage}\n\n${greetings}\n\n${body}\n-- \n${footer}\n');

INSERT INTO mail_footer (id, name, language, domain_abstract_id, visible, plaintext, footer,uuid,modification_date,creation_date) VALUES (1, 'FOOTER_HTML', 0,1, true, false, '<a href="http://linshare.org/" title="LinShare"><strong>LinShare</strong></a> - THE Secure, Open-Source File Sharing Tool','e85f4a22-8cf2-11e3-8a7a-5404a683a462',now(),now());
INSERT INTO mail_footer (id, name, language, domain_abstract_id, visible, plaintext, footer,uuid,modification_date,creation_date) VALUES (2, 'FOOTER_HTML', 1,1, true, false, '<a href="http://www.linshare.org/" title="LinShare"><strong>LinShare</strong></a> - Logiciel libre de partage de fichiers sécurisé','c9e8e482-8daa-11e3-9d04-5404a683a462',now(),now());


INSERT INTO mail_footer (id, name, language, domain_abstract_id, visible, plaintext, footer,uuid,modification_date,creation_date) VALUES (3, 'FOOTER_TXT', 0,1, true, true, 'LinShare - http://linshare.org - THE Secure, Open-Source File Sharing Tool','83e756e8-8cf7-11e3-b493-5404a683a462',now(),now());
INSERT INTO mail_footer (id, name, language, domain_abstract_id, visible, plaintext, footer,uuid,modification_date,creation_date) VALUES (4, 'FOOTER_TXT', 1,1, true, true, 'LinShare - http://www.linshare.org/ - Logiciel libre de partage de fichiers sécurisé','d56a8f54-8daa-11e3-9cc2-5404a683a462',now(),now());


-- LANGUAGE DEFAULT 0

-- ANONYMOUS_DOWNLOAD
INSERT INTO mail_content (id, uuid, domain_abstract_id, language, mail_content_type, visible, plaintext, modification_date, creation_date, greetings, name, subject, body) VALUES  (1, '938f91ab-b33c-4184-900f-c8a595fc6cd9', 1, 0,  0, true, false, now(), now(), 'Hello ${firstName} ${lastName},<br/><br/>', 'Anonymous user downloaded a file', 'An unknown user ${actorRepresentation} has just downloaded a file you made available for sharing', 'An unknown user ${email} has just downloaded the following file(s) you made available via LinShare:<ul>${documentNames}</ul><br/>');
-- REGISTERED_DOWNLOAD
INSERT INTO mail_content (id, uuid, domain_abstract_id, language, mail_content_type, visible, plaintext, modification_date, creation_date, greetings, name, subject, body) VALUES  (2, '403e5d8b-bc38-443d-8b94-bab39a4460af', 1, 0,  1, true, false, now(), now(), 'Hello ${firstName} ${lastName},<br/><br/>', 'Registered user downloaded a file', 'A user ${actorRepresentation} has just downloaded a file you made available for sharing', '${recipientFirstName} ${recipientLastName} has just downloaded the following file(s) you made available to her/him via LinShare:<ul>${documentNames}</ul><br/>');
-- NEW_GUEST
INSERT INTO mail_content (id, uuid, domain_abstract_id, language, mail_content_type, visible, plaintext, modification_date, creation_date, greetings, name, subject, body) VALUES  (3, 'a1ca74a5-433d-444a-8e53-8daa08fa0ddb', 1, 0,  2, true, false, now(), now(), 'Hello ${firstName} ${lastName},<br/><br/>', 'New guest', 'Your LinShare account has been sucessfully created', '<strong>${ownerFirstName} ${ownerLastName}</strong> invites you to use and enjoy LinShare!<br/><br/>To login, please go to: <a href="${url}">${url}</a><br/><br/>Your LinShare account:<ul><li>Login: <code>${mail}</code> &nbsp;(your e-mail address)</li><li>Password: <code>${password}</code></li></ul><br/>');
-- RESET_PASSWORD
INSERT INTO mail_content (id, uuid, domain_abstract_id, language, mail_content_type, visible, plaintext, modification_date, creation_date, greetings, name, subject, body) VALUES  (4, '753d57a8-4fcc-4346-ac92-f71828aca77c', 1, 0,  3, true, false, now(), now(), 'Hello ${firstName} ${lastName},<br/><br/>', 'Password reset', 'Your password has been reset', 'Your LinShare account:<ul><li>Login: <code>${mail}</code> &nbsp;(your e-mail address)</li><li>Password: <code>${password}</code></li></ul><br/>');
-- SHARED_DOC_UPDATED
INSERT INTO mail_content (id, uuid, domain_abstract_id, language, mail_content_type, visible, plaintext, modification_date, creation_date, greetings, name, subject, body) VALUES  (5, '09a50c58-b430-4ccf-ab3e-0257c463d8df', 1, 0,  4, true, false, now(), now(), 'Hello ${firstName} ${lastName},<br/><br/>', 'Shared document was updated', 'A user ${actorRepresentation} has just modified a shared file you still have access to', '<strong>${firstName} ${lastName}</strong> has just modified the following shared file <strong>${fileOldName}</strong>:<ul><li>New file name: ${fileName}</li><li>File size: ${fileSize}</li><li>MIME type: <code>${mimeType}</code></li></ul><br/>To download the file(s), simply click on the following link or copy/paste it into your favorite browser: <a href="${url}${urlparam}">${url}${urlparam}</a><br/>');
-- SHARED_DOC_DELETED
INSERT INTO mail_content (id, uuid, domain_abstract_id, language, mail_content_type, visible, plaintext, modification_date, creation_date, greetings, name, subject, body) VALUES  (6, '554a3a2b-53b1-4ec8-9462-2d6053b80078', 1, 0,  5, true, false, now(), now(), 'Hello ${firstName} ${lastName},<br/><br/>', 'Shared document was deleted', 'A user ${actorRepresentation} has just deleted a shared file you had access to!', '<strong>${firstName} ${lastName}</strong> has just deleted a previously shared file <strong>${documentName}</strong>.<br/>');
-- SHARED_DOC_UPCOMING_OUTDATED
INSERT INTO mail_content (id, uuid, domain_abstract_id, language, mail_content_type, visible, plaintext, modification_date, creation_date, greetings, name, subject, body) VALUES  (7, 'e7bf56c2-b015-4e64-9f07-3c7e2f3f9ca8', 1, 0,  6, true, false, now(), now(), 'Hello ${firstName} ${lastName},<br/><br/>', 'Shared document is soon to be outdated', 'A LinShare workspace is about to be deleted', 'Your access to the shared file ${documentName}, granted by ${firstName} ${lastName}, will expire in ${nbDays} days. Remember to download it before!<br/>To download the file(s), simply click on the following link or copy/paste it into your favorite browser: <a href="${url}${urlparam}">${url}${urlparam}</a><br/>');
-- DOC_UPCOMING_OUTDATED
INSERT INTO mail_content (id, uuid, domain_abstract_id, language, mail_content_type, visible, plaintext, modification_date, creation_date, greetings, name, subject, body) VALUES  (8, '1507e9c0-c1e1-4e0f-9efb-506f63cbba97', 1, 0,  7, true, false, now(), now(), 'Hello ${firstName} ${lastName},<br/><br/>', 'Document is soon to be outdated', 'A shared file is about to be deleted!', 'Your access to the file <strong>${documentName}</strong> will expire in ${nbDays} days!<br/>To download the file(s), simply click on the following link or copy/paste it into your favorite browser: <a href="${url}${urlparam}">${url}${urlparam}</a><br/>');
-- NEW_SHARING
INSERT INTO mail_content (id, uuid, domain_abstract_id, language, mail_content_type, visible, plaintext, modification_date, creation_date, greetings, name, subject, body, alternative_subject, enable_as) VALUES  (9, '250e4572-7bb9-4735-84ff-6a8af93e3a42', 1, 0,  8, true, false, now(), now(), 'Hello ${firstName} ${lastName},<br/><br/>', 'New sharing', 'A user ${actorRepresentation} has just made a file available to you!', '<strong>${firstName} ${lastName}</strong> has just shared with you ${number} file(s):<ul>${documentNames}</ul><br/>To download the file(s), simply click on the following link or copy/paste it into your favorite browser: <a href="${url}${urlparam}">${url}${urlparam}</a><br/>', '${actorSubject} from ${actorRepresentation}', true);
-- NEW_SHARING_PROTECTED
INSERT INTO mail_content (id, uuid, domain_abstract_id, language, mail_content_type, visible, plaintext, modification_date, creation_date, greetings, name, subject, body, alternative_subject, enable_as) VALUES  (10, '1e972f43-619c-4bd6-a1bd-10667b80af74', 1, 0,  9, true, false, now(), now(), 'Hello ${firstName} ${lastName},<br/><br/>', 'New sharing with password protection', 'A user ${actorRepresentation} has just made a file available to you!', '<strong>${firstName} ${lastName}</strong> has just shared with you ${number} file(s):<ul>${documentNames}</ul><br/>To download the file(s), simply click on the following link or copy/paste it into your favorite browser: <a href="${url}${urlparam}">${url}${urlparam}</a><br/>The password to be used is: <code>${password}</code><br/><br/>', '${actorSubject} from ${actorRepresentation}', true);
-- NEW_SHARING_CYPHERED
INSERT INTO mail_content (id, uuid, domain_abstract_id, language, mail_content_type, visible, plaintext, modification_date, creation_date, greetings, name, subject, body, alternative_subject, enable_as) VALUES  (11, 'fef9a3f1-6011-46cd-8d39-6bd1bc02f899', 1, 0, 10, true, false, now(), now(), 'Hello ${firstName} ${lastName},<br/><br/>', 'New sharing of a cyphered file', 'A user ${actorRepresentation} has just made a file available to you!', '<strong>${firstName} ${lastName}</strong> has just shared with you ${number} file(s):<ul>${documentNames}</ul><br/>To download the file(s), simply click on the following link or copy/paste it into your favorite browser: <a href="${url}${urlparam}">${url}${urlparam}</a><br/><p>One or more received files are <b>encrypted</b>. After download is complete, make sure to decrypt them locally by using the application:<br/><a href="${jwsEncryptUrl}">${jwsEncryptUrl}</a><br/>You must use the <i>password</i> granted to you by the user who made the file(s) available for sharing.</p><br/><br/>', '${actorSubject} from ${actorRepresentation}', true);
-- NEW_SHARING_CYPHERED_PROTECTED
INSERT INTO mail_content (id, uuid, domain_abstract_id, language, mail_content_type, visible, plaintext, modification_date, creation_date, greetings, name, subject, body, alternative_subject, enable_as) VALUES  (12, '2da85945-7793-43f4-b547-eacff15a6f88', 1, 0, 11, true, false, now(), now(), 'Hello ${firstName} ${lastName},<br/><br/>', 'New sharing with password protection of a cyphered file', 'A user ${actorRepresentation} has just made a file available to you!', '<strong>${firstName} ${lastName}</strong> has just shared with you ${number} file(s):<ul>${documentNames}</ul><br/>To download the file(s), simply click on the following link or copy/paste it into your favorite browser: <a href="${url}${urlparam}">${url}${urlparam}</a><br/><p>One or more received files are <b>encrypted</b>. After download is complete, make sure to decrypt them locally by using the application:<br/><a href="${jwsEncryptUrl}">${jwsEncryptUrl}</a><br/>You must use the <i>password</i> granted to you by the user who made the file(s) available for sharing.</p><br/><br/>The password to be used is: <code>${password}</code><br/><br/>', '${actorSubject} from ${actorRepresentation}', true);
-- UPLOAD_PROPOSITION_CREATED
INSERT INTO mail_content (id, uuid, domain_abstract_id, language, mail_content_type, visible, plaintext, modification_date, creation_date, greetings, name, subject, body) VALUES  (13, 'dd7d6a36-03b6-48e8-bfb5-3c2d8dc227fd', 1, 0, 12, true, false, now(), now(), 'Hello ${firstName} ${lastName},<br/><br/>', 'New upload proposition', 'A user ${actorRepresentation} has send to you an upload proposition: ${subject}', '<strong>${firstName} ${lastName}</strong> has just send to you an upload request: ${subject}<br/>${body}<br/>You need to activate or reject this request <br/><br/>');
-- UPLOAD_PROPOSITION_REJECTED
INSERT INTO mail_content (id, uuid, domain_abstract_id, language, mail_content_type, visible, plaintext, modification_date, creation_date, greetings, name, subject, body) VALUES  (14, '62af93dd-0b19-4376-bc76-08b7a97fc0f2', 1, 0, 13, true, false, now(), now(), 'Hello ${firstName} ${lastName},<br/><br/>', 'Upload proposition rejected', 'A user ${actorRepresentation} has rejected your upload proposition: ${subject}', '<strong>${firstName} ${lastName}</strong> has just rejected your upload proposition: ${subject}<br/>${body}<br/><br/>');
-- UPLOAD_REQUEST_UPDATED
INSERT INTO mail_content (id, uuid, domain_abstract_id, language, mail_content_type, visible, plaintext, modification_date, creation_date, greetings, name, subject, body) VALUES  (15, '40f36a3b-39ea-4723-a292-9c86e2ee8f94', 1, 0, 14, true, false, now(), now(), 'Hello ${firstName} ${lastName},<br/><br/>', 'Upload request updated', 'A user ${actorRepresentation} has updated upload request: ${subject}', '<strong>${firstName} ${lastName}</strong> has just updated the upload request: ${subject}<br/>${body}<br/>New settings can be found here: <a href="${url}">${url}</a><br/><br/>');
-- UPLOAD_REQUEST_ACTIVATED
INSERT INTO mail_content (id, uuid, domain_abstract_id, language, mail_content_type, visible, plaintext, modification_date, creation_date, greetings, name, subject, body) VALUES  (16, '817ae032-9022-4c22-97a3-cfb5ce50817c', 1, 0, 15, true, false, now(), now(), 'Hello ${firstName} ${lastName},<br/><br/>', 'Upload request activated', 'A user ${actorRepresentation} has activated upload request: ${subject}', '<strong>${firstName} ${lastName}</strong> has just activate the upload request: ${subject}<br/>${body}<br/>To upload files, simply click on the following link or copy/paste it into your favorite browser: <a href="${url}">${url}</a><br/><p>Upload request may be <b>encrypted</b>, use <em>password</em>: <code>${password}</code><br/><br/>');
-- UPLOAD_PROPOSITION_AUTO_FILTER
INSERT INTO mail_content (id, uuid, domain_abstract_id, language, mail_content_type, visible, plaintext, modification_date, creation_date, greetings, name, subject, body) VALUES  (17, 'd692674c-e797-49f1-a415-1df7ea5c8fee', 1, 0, 16, true, false, now(), now(), 'Hello ${firstName} ${lastName},<br/><br/>', 'Upload proposition filtered', 'An upload proposition has been filtered: ${subject}', 'A new upload proposition has been filtered.<br/>Subject: ${subject}<br/>${body}<br/><br/>');
-- UPLOAD_REQUEST_CREATED
INSERT INTO mail_content (id, uuid, domain_abstract_id, language, mail_content_type, visible, plaintext, modification_date, creation_date, greetings, name, subject, body) VALUES  (18, '40a74e4e-a663-4ad2-98ef-1e5d70d3536c', 1, 0, 17, true, false, now(), now(), 'Hello ${firstName} ${lastName},<br/><br/>', 'Upload request created', 'A user ${actorRepresentation} has created upload request: ${subject}', '<strong>${firstName} ${lastName}</strong> has just made you an upload request: ${subject}.<br/>${body}<br/>It will be activated ${activationDate}<br/><br/>');
-- UPLOAD_REQUEST_ACKNOWLEDGEMENT
INSERT INTO mail_content (id, uuid, domain_abstract_id, language, mail_content_type, visible, plaintext, modification_date, creation_date, greetings, name, subject, body) VALUES  (19, '5ea27e5b-9260-4ce1-b1bd-27372c5b653d', 1, 0, 18, true, false, now(), now(), 'Hello ${firstName} ${lastName},<br/><br/>', 'Upload request acknowledgement', 'A user ${actorRepresentation} has upload a file for upload request: ${subject}', '<strong>${firstName} ${lastName}</strong> has upload a file.<br/>File name: ${fileName}<br/>Deposit date: ${depositDate}<br/>File size: ${fileSize}<br/><br/>');
-- UPLOAD_REQUEST_REMINDER
INSERT INTO mail_content (id, uuid, domain_abstract_id, language, mail_content_type, visible, plaintext, modification_date, creation_date, greetings, name, subject, body) VALUES  (20, '0d87e08d-d102-42b9-8ced-4d49c21ce126', 1, 0, 19, true, false, now(), now(), 'Hello ${firstName} ${lastName},<br/><br/>', 'Upload request reminder', 'A user ${actorRepresentation} reminds you have an upload request: ${subject}', '<strong>${firstName} ${lastName}</strong> reminds you have got an upload request : ${subject}.<br/>${body}<br/>To upload files, simply click on the following link or copy/paste it into your favorite browser: <a href="${url}">${url}</a><br/><p>Upload request may be <b>encrypted</b>, use <em>password</em>: <code>${password}</code><br/><br/><br/><br/>');
-- UPLOAD_REQUEST_WARN_OWNER_BEFORE_EXPIRY
INSERT INTO mail_content (id, uuid, domain_abstract_id, language, mail_content_type, visible, plaintext, modification_date, creation_date, greetings, name, subject, body) VALUES  (21, 'd43b22d6-d915-41cc-99e4-9c9db66c5aac', 1, 0, 20, true, false, now(), now(), 'Hello ${firstName} ${lastName},<br/><br/>', 'Upload request will be expired', 'The upload request: ${subject}, will expire', 'Expiry date approaching for upload request: ${subject}<br/>${body}<br/>Be sure that the request is complete<br/>Files already uploaded: ${files}<br/><br/>');
-- UPLOAD_REQUEST_WARN_RECIPIENT_BEFORE_EXPIRY
INSERT INTO mail_content (id, uuid, domain_abstract_id, language, mail_content_type, visible, plaintext, modification_date, creation_date, greetings, name, subject, body) VALUES  (22, '0bea7e7c-e2e9-44ff-bbb3-7e28967a4d67', 1, 0, 21, true, false, now(), now(), 'Hello ${firstName} ${lastName},<br/><br/>', 'Upload request will be expired', 'The upload request: ${subject}, will expire', 'Expiry date approaching for upload request: ${subject}<br/>${body}<br/>Files already uploaded: ${files}<br/>To upload files, simply click on the following link or copy/paste it into your favorite browser: <a href="${url}">${url}</a><br/><br/>');
-- UPLOAD_REQUEST_WARN_OWNER_EXPIRY
INSERT INTO mail_content (id, uuid, domain_abstract_id, language, mail_content_type, visible, plaintext, modification_date, creation_date, greetings, name, subject, body) VALUES  (23, '0cd705f3-f1f5-450d-bfcd-f2f5a60c57f8', 1, 0, 22, true, false, now(), now(), 'Hello ${firstName} ${lastName},<br/><br/>', 'Upload request is expired', 'The upload request: ${subject}, is expired', 'Expiration of the upload request: ${subject}<br/>${body}<br/>Files uploaded: ${files}<br/><br/>');
-- UPLOAD_REQUEST_WARN_RECIPIENT_EXPIRY
INSERT INTO mail_content (id, uuid, domain_abstract_id, language, mail_content_type, visible, plaintext, modification_date, creation_date, greetings, name, subject, body) VALUES  (24, '7412940b-870b-4f58-877c-9955a423a5f3', 1, 0, 23, true, false, now(), now(), 'Hello ${firstName} ${lastName},<br/><br/>', 'Upload request is expired', 'The upload request: ${subject}, is expired', 'Expiration of the upload request: ${subject}<br/>${body}<br/>Files uploaded: ${files}<br/>You will not be able to upload file anymore<br/><br/>');
-- UPLOAD_REQUEST_CLOSED_BY_RECIPIENT
INSERT INTO mail_content (id, uuid, domain_abstract_id, language, mail_content_type, visible, plaintext, modification_date, creation_date, greetings, name, subject, body) VALUES  (25, '6c0c1214-0a77-46d0-92c5-c41d225bf9aa', 1, 0, 24, true, false, now(), now(), 'Hello ${firstName} ${lastName},<br/><br/>', 'Upload request closed', 'A user ${actorRepresentation} has just closed upload request: ${subject}', '<strong>${firstName} ${lastName}</strong> has just closed the upload request: ${subject}<br/>${body}<br/>Files uploaded: ${files}<br/><br/>');
-- UPLOAD_REQUEST_CLOSED_BY_OWNER
INSERT INTO mail_content (id, uuid, domain_abstract_id, language, mail_content_type, visible, plaintext, modification_date, creation_date, greetings, name, subject, body) VALUES  (26, '1956ca27-5127-4f42-a41d-81a72a325aae', 1, 0, 25, true, false, now(), now(), 'Hello ${firstName} ${lastName},<br/><br/>', 'Upload request closed', 'A user ${actorRepresentation} has just closed upload request: ${subject}', '<strong>${firstName} ${lastName}</strong> has just closed the upload request: ${subject}<br/>${body}<br/>Files uploaded: ${files}<br/>You will not be able to upload file anymore<br/><br/>');
-- UPLOAD_REQUEST_DELETED_BY_OWNER
INSERT INTO mail_content (id, uuid, domain_abstract_id, language, mail_content_type, visible, plaintext, modification_date, creation_date, greetings, name, subject, body) VALUES  (27, '690f1bbc-4f99-4e70-a6cd-44388e3e2c86', 1, 0, 26, true, false, now(), now(), 'Hello ${firstName} ${lastName},<br/><br/>', 'Upload request deleted', 'A user ${actorRepresentation} has just deleted an upload request', '<strong>${firstName} ${lastName}</strong> has just deleted the upload request: ${subject}<br/>${body}<br/>You will not be able to upload file anymore<br/><br/>');
-- UPLOAD_REQUEST_NO_SPACE_LEFT
INSERT INTO mail_content (id, uuid, domain_abstract_id, language, mail_content_type, visible, plaintext, modification_date, creation_date, greetings, name, subject, body) VALUES  (28, '48fee30b-b2d3-4f85-b9ee-22044f9dbb4d', 1, 0, 27, true, false, now(), now(), 'Hello ${firstName} ${lastName},<br/><br/>', 'Upload request error: no space left', 'A user ${actorRepresentation} has just tried to upload a file but server had no space left', '<strong>${firstName} ${lastName}</strong> has just tried to upload in the upload request: ${subject}<br/>${body}<br>Please free space and notify the recipient to retry is upload<br/><br/>');
-- UPLOAD_REQUEST_FILE_DELETED_BY_SENDER
INSERT INTO mail_content (id, uuid, domain_abstract_id, language, mail_content_type, visible, plaintext, modification_date, creation_date, greetings, name, subject, body) VALUES  (30, '88b90304-e9c9-11e4-b6b4-5404a6202d2c', 1, 0, 29, true, false, now(), now(), 'Hello ${firstName} ${lastName},<br/><br/>', 'Upload request file deleted', 'A user ${actorRepresentation} has deleted a file for upload request: ${subject}', '<strong>${firstName} ${lastName}</strong> has deleted a file.<br/>File name: ${fileName}<br/>Deletion date: ${deleteDate}<br/>File size: ${fileSize}<br/><br/>');
-- SHARE_CREATION_ACKNOWLEDGEMENT_FOR_OWNER
INSERT INTO mail_content (id, uuid, domain_abstract_id, language, mail_content_type, visible, plaintext, modification_date, creation_date, greetings, name, subject, body, enable_as) VALUES  (31, '01e0ac2e-f7ba-11e4-901b-08002722e7b1', 1, 0, 30, true, false, now(), now(), 'Hello ${firstName} ${lastName},<br/><br/>', 'Share creation acknowledgement', '[SHARE ACKNOWLEDGEMENT] Shared on ${date}.', 'You just shared ${fileNumber} file(s), on the ${creationDate}, expiring the ${expirationDate}, with :<br/><ul>${recipientNames}</ul><br/>The list of your files is : <ul>${documentNames}</ul><br/>', false);
INSERT INTO mail_content (id, uuid, domain_abstract_id, language, mail_content_type, visible, plaintext, modification_date, creation_date, greetings, name, subject, body, enable_as) VALUES  (32, '2209b038-e1e7-11e4-8d2d-3b2a506425c0', 1, 0, 31, true, false, now(), now(), 'Hello ${firstName} ${lastName},<br/><br/>', 'Share creation acknowledgement', '[SHARE ACKNOWLEDGEMENT] ${subject}. Shared on ${date}.', 'You just shared ${fileNumber} file(s), on the ${creationDate}, expiring the ${expirationDate}, with :<br/><ul>${recipientNames}</ul><br/>Your original message was:<br/><i>${message}</i><br/><br/>The list of your files is : <ul>${documentNames}</ul><br/>', false);
-- UNDOWNLOADED_SHARED_DOCUMENT_ALERT
INSERT INTO mail_content (id, uuid, domain_abstract_id, language, mail_content_type, visible, plaintext, modification_date, creation_date, greetings, name, subject, body) VALUES  (33, 'eb291876-53fc-419b-831b-53a480399f7c', 1, 0, 32, true, false, now(), now(), 'Hello ${firstName} ${lastName},<br/><br/>', 'Undownloaded shared documents alert', '[Undownloaded shared documents alert] ${subject} Shared on ${date}.', 'Please find below the state of the share you made on ${creationDate} with initial expiration date on ${expirationDate}.<br /> List of documents : <br /> <table style="border-collapse: collapse;">${shareInfo}</table><br/>');

-- LANGUAGE FRENCH 1

-- ANONYMOUS_DOWNLOAD
INSERT INTO mail_content (id, uuid, domain_abstract_id, language, mail_content_type, visible, plaintext, modification_date, creation_date, greetings, name, subject, body) VALUES  (51, 'cc3bb3c6-e21e-44fe-b552-9acf654e4988', 1, 1,  0, true, false, now(), now(), 'Bonjour ${firstName} ${lastName},<br/><br/>', 'Un externe a téléchargé un fichier', 'Un utilisateur anonyme ${actorRepresentation} a téléchargé des fichiers en partage', 'L’utilisateur anonyme ${email} a téléchargé le(s) fichier(s) que vous avez mis en partage via LinShare&nbsp;:<ul>${documentNames}</ul><br/>');
-- REGISTERED_DOWNLOAD
INSERT INTO mail_content (id, uuid, domain_abstract_id, language, mail_content_type, visible, plaintext, modification_date, creation_date, greetings, name, subject, body) VALUES  (52, '7e1b4fe3-c859-453d-ae80-9751e2c4811c', 1, 1,  1, true, false, now(), now(), 'Bonjour ${firstName} ${lastName},<br/><br/>', 'Un utilisateur a téléchargé un fichier', '${actorRepresentation} a téléchargé des fichiers en partage', '${recipientFirstName} ${recipientLastName} a téléchargé le(s) fichier(s) que vous lui avez mis en partage via LinShare&nbsp;:<ul>${documentNames}</ul><br/>');
-- NEW_GUEST
INSERT INTO mail_content (id, uuid, domain_abstract_id, language, mail_content_type, visible, plaintext, modification_date, creation_date, greetings, name, subject, body) VALUES  (53, 'e68d9b75-1ff3-4e0e-8487-8579c531b391', 1, 1,  2, true, false, now(), now(), 'Bonjour ${firstName} ${lastName},<br/><br/>', 'Nouveau compte invité', 'Votre compte LinShare a été créé', '<strong>${ownerFirstName} ${ownerLastName}</strong> vous invite à utiliser LinShare.<br/><br/>Vous pouvez vous connecter à cette adresse&nbsp;: <a href="${url}">${url}</a><br/><br/>Votre compte LinShare&nbsp;:<ul><li>Identifiant&nbsp;: <code>${mail}</code> &nbsp;(votre adresse électronique)</li><li>Mot de passe&nbsp;: <code>${password}</code></li></ul><br/>');
-- RESET_PASSWORD
INSERT INTO mail_content (id, uuid, domain_abstract_id, language, mail_content_type, visible, plaintext, modification_date, creation_date, greetings, name, subject, body) VALUES  (54, 'ae789e03-bd78-428f-8986-d85b96e1e08d', 1, 1,  3, true, false, now(), now(), 'Bonjour ${firstName} ${lastName},<br/><br/>', 'Nouveau mot de passe', 'Votre nouveau mot de passe', 'Votre compte LinShare&nbsp;:<ul><li>Identifiant&nbsp;: <code>${mail}</code> &nbsp;(votre adresse électronique)</li><li>Mot de passe&nbsp;: <code>${password}</code></li></ul><br/>');
-- SHARED_DOC_UPDATED
INSERT INTO mail_content (id, uuid, domain_abstract_id, language, mail_content_type, visible, plaintext, modification_date, creation_date, greetings, name, subject, body) VALUES  (55, 'c88f9821-44d7-4330-97a1-8c47f0be4572', 1, 1,  4, true, false, now(), now(), 'Bonjour ${firstName} ${lastName},<br/><br/>', 'Mise à jour d´un partage', '${actorRepresentation} a mis à jour un fichier partagé', '<strong>${firstName} ${lastName}</strong> a mis à jour le fichier partagé <strong>${fileOldName}</strong>&nbsp;:<ul><li>Nom du nouveau fichier&nbsp;: ${fileName}</li><li>Taille du fichier&nbsp;: ${fileSize}</li><li>Type MIME&nbsp;: <code>${mimeType}</code></li></ul><br/>Pour télécharger les fichiers, cliquez sur le lien ou copiez-le dans votre navigateur&nbsp;: <a href="${url}${urlparam}">${url}${urlparam}</a><br/>');
-- SHARED_DOC_DELETED
INSERT INTO mail_content (id, uuid, domain_abstract_id, language, mail_content_type, visible, plaintext, modification_date, creation_date, greetings, name, subject, body) VALUES  (56, '9626399e-1152-471f-83a1-372b08800b1a', 1, 1,  5, true, false, now(), now(), 'Bonjour ${firstName} ${lastName},<br/><br/>', 'Suppression d´un partage', '${actorRepresentation} a supprimé un fichier partagé', '<strong>${firstName} ${lastName}</strong> a supprimé le fichier partagé <strong>${documentName}</strong>.<br/>');
-- SHARED_DOC_UPCOMING_OUTDATED
INSERT INTO mail_content (id, uuid, domain_abstract_id, language, mail_content_type, visible, plaintext, modification_date, creation_date, greetings, name, subject, body) VALUES  (57, '06b1f018-9b3d-4a1b-af90-c03e5e1ec314', 1, 1,  6, true, false, now(), now(), 'Bonjour ${firstName} ${lastName},<br/><br/>', 'Expiration d´un partage', 'Un partage va bientôt expirer', 'Le partage du fichier ${documentName} provenant de <strong>${firstName} ${lastName}</strong> va expirer dans ${nbDays} jours. Pensez à télécharger ou copier ce fichier avant son expiration.<br/>Pour télécharger les fichiers, cliquez sur le lien ou copiez-le dans votre navigateur&nbsp;: <a href="${url}${urlparam}">${url}${urlparam}</a><br/>');
-- DOC_UPCOMING_OUTDATED
INSERT INTO mail_content (id, uuid, domain_abstract_id, language, mail_content_type, visible, plaintext, modification_date, creation_date, greetings, name, subject, body) VALUES  (58, 'edb87b54-007e-4654-8709-e8eb3db19366', 1, 1,  7, true, false, now(), now(), 'Bonjour ${firstName} ${lastName},<br/><br/>', 'Expiration d´un fichier', 'Un fichier va bientôt être supprimé', 'Le fichier <strong>${documentName}</strong> va expirer dans ${nbDays} jours.<br/>Pour télécharger les fichiers, cliquez sur le lien ou copiez-le dans votre navigateur&nbsp;: <a href="${url}${urlparam}">${url}${urlparam}</a><br/>');
-- NEW_SHARING
INSERT INTO mail_content (id, uuid, domain_abstract_id, language, mail_content_type, visible, plaintext, modification_date, creation_date, greetings, name, subject, body, alternative_subject, enable_as) VALUES  (59, 'ae9ced24-64a3-498d-a576-a23864c56127', 1, 1,  8, true, false, now(), now(), 'Bonjour ${firstName} ${lastName},<br/><br/>', 'Nouveau partage', '${actorRepresentation} vous a déposé des fichiers en partage', '<strong>${firstName} ${lastName}</strong> a mis en partage ${number} fichier(s) à votre attention&nbsp;:<ul>${documentNames}</ul><br/>Pour télécharger les fichiers, cliquez sur le lien ou copiez-le dans votre navigateur&nbsp;: <a href="${url}${urlparam}">${url}${urlparam}</a><br/>', '${actorSubject} de la part de ${actorRepresentation}', true);
-- NEW_SHARING_PROTECTED
INSERT INTO mail_content (id, uuid, domain_abstract_id, language, mail_content_type, visible, plaintext, modification_date, creation_date, greetings, name, subject, body, alternative_subject, enable_as) VALUES  (60, '0e602bb9-63f8-4c88-aa61-d2338cfcbb5b', 1, 1,  9, true, false, now(), now(), 'Bonjour ${firstName} ${lastName},<br/><br/>', 'Nouveau partage avec mot de passe', '${actorRepresentation} vous a déposé des fichiers en partage', '<strong>${firstName} ${lastName}</strong> a mis en partage ${number} fichier(s) à votre attention&nbsp;:<ul>${documentNames}</ul><br/>Pour télécharger les fichiers, cliquez sur le lien ou copiez-le dans votre navigateur&nbsp;: <a href="${url}${urlparam}">${url}${urlparam}</a><br/>Le mot de passe à utiliser est&nbsp;: <code>${password}</code><br/>', '${actorSubject} de la part de ${actorRepresentation}', true);
-- NEW_SHARING_CYPHERED
INSERT INTO mail_content (id, uuid, domain_abstract_id, language, mail_content_type, visible, plaintext, modification_date, creation_date, greetings, name, subject, body, alternative_subject, enable_as) VALUES  (61, 'e9e8fd55-b06f-4d04-b46d-4ca4f58ebbef', 1, 1, 10, true, false, now(), now(), 'Bonjour ${firstName} ${lastName},<br/><br/>', 'Nouveau partage avec chiffrement', '${actorRepresentation} vous a déposé des fichiers en partage', '<strong>${firstName} ${lastName}</strong> a mis en partage ${number} fichier(s) à votre attention&nbsp;:<ul>${documentNames}</ul><br/>Pour télécharger les fichiers, cliquez sur le lien ou copiez-le dans votre navigateur&nbsp;: <a href="${url}${urlparam}">${url}${urlparam}</a><br/><p>Certains de vos fichiers sont <strong>chiffrés</strong>. Après le téléchargement, vous devez les déchiffrer localement avec l’application&nbsp;:<br/><a href="${jwsEncryptUrl}">${jwsEncryptUrl}</a><br/>Vous devez vous munir du <em>mot de passe de déchiffrement</em> qui a dû vous être communiqué par l’expéditeur des fichiers.</p><br/>', '${actorSubject} de la part de ${actorRepresentation}', true);
-- NEW_SHARING_CYPHERED_PROTECTED
INSERT INTO mail_content (id, uuid, domain_abstract_id, language, mail_content_type, visible, plaintext, modification_date, creation_date, greetings, name, subject, body, alternative_subject, enable_as) VALUES  (62, 'd1608d46-efb7-4465-897c-d8d34c036f21', 1, 1, 11, true, false, now(), now(), 'Bonjour ${firstName} ${lastName},<br/><br/>', 'Nouveau partage avec chiffrement et mot de passe', '${actorRepresentation} vous a déposé des fichiers en partage', '<strong>${firstName} ${lastName}</strong> a mis en partage ${number} fichier(s) à votre attention&nbsp;:<ul>${documentNames}</ul><br/>Pour télécharger les fichiers, cliquez sur le lien ou copiez-le dans votre navigateur&nbsp;: <a href="${url}${urlparam}">${url}${urlparam}</a><br/><p>Certains de vos fichiers sont <strong>chiffrés</strong>. Après le téléchargement, vous devez les déchiffrer localement avec l’application&nbsp;:<br/><a href="${jwsEncryptUrl}">${jwsEncryptUrl}</a><br/>Vous devez vous munir du <em>mot de passe de déchiffrement</em> qui a dû vous être communiqué par l’expéditeur des fichiers.</p><br/>Le mot de passe à utiliser est&nbsp;: <code>${password}</code><br/><br/>', '${actorSubject} de la part de ${actorRepresentation}', true);
-- UPLOAD_PROPOSITION_CREATED
INSERT INTO mail_content (id, uuid, domain_abstract_id, language, mail_content_type, visible, plaintext, modification_date, creation_date, greetings, name, subject, body) VALUES  (63, '3cbc9145-4fc9-43bc-9417-a157bdda2575', 1, 1, 12, true, false, now(), now(), 'Bonjour ${firstName} ${lastName},<br/><br/>', 'Nouvelle demande d’invitation de partage', '${actorRepresentation} vous a envoyé une demande invitation de dépôt: ${subject}', '<strong>${firstName} ${lastName}</strong> vous a envoyé une demande d’invitation de dépôt.<br/>Vous devez activer ou rejeter cette demande.<br/><br/>');
-- UPLOAD_PROPOSITION_REJECTED
INSERT INTO mail_content (id, uuid, domain_abstract_id, language, mail_content_type, visible, plaintext, modification_date, creation_date, greetings, name, subject, body) VALUES  (64, 'c8ba5fd5-b3b1-463f-b24a-ef113e7df294', 1, 1, 13, true, false, now(), now(), 'Bonjour ${firstName} ${lastName},<br/><br/>', 'Demande d’invitation de partage rejetée', '${actorRepresentation} a rejeté votre invitation de dépôt: ${subject}', '<strong>${firstName} ${lastName}</strong> a rejeté votre invitation de dépôt: ${subject}<br/>${body}<br/><br/>');
-- UPLOAD_REQUEST_UPDATED
INSERT INTO mail_content (id, uuid, domain_abstract_id, language, mail_content_type, visible, plaintext, modification_date, creation_date, greetings, name, subject, body) VALUES  (65, 'c8ba5fd5-b3b1-463f-b24a-ef113e7df294', 1, 1, 14, true, false, now(), now(), 'Bonjour ${firstName} ${lastName},<br/><br/>', 'Invitation de partage modifiée', '${actorRepresentation} a mis à jour l’invitation de dépôt: ${subject}', '<strong>${firstName} ${lastName}</strong> a mis à jour l’invitation de dépôt: ${subject}<br/>${body}<br/>La nouvelle configuration est disponible ici: <a href="${url}">${url}</a><br/><br/>');
-- UPLOAD_REQUEST_ACTIVATED
INSERT INTO mail_content (id, uuid, domain_abstract_id, language, mail_content_type, visible, plaintext, modification_date, creation_date, greetings, name, subject, body) VALUES  (66, '24c92194-4291-4deb-9fb7-2c6b6fb40e18', 1, 1, 15, true, false, now(), now(), 'Bonjour ${firstName} ${lastName},<br/><br/>', 'Invitation de partage activée', '${actorRepresentation} a activé l’invitation de dépôt: ${subject}', '<strong>${firstName} ${lastName}</strong> a activé l’invitation de dépôt: ${subject}<br/>${body}<br/>Pour déposer des fichiers, cliquer sur le lien suivant ou copier/coller ce dernier dans votre navigateur favori: <a href="${url}">${url}</a><br/>L’invitation de dépôt peut être <b>protégée</b>, utiliser le <em>mot de passe</em> suivant: <code>${password}</code><br/><br/>');
-- UPLOAD_REQUEST_AUTO_FILTER
INSERT INTO mail_content (id, uuid, domain_abstract_id, language, mail_content_type, visible, plaintext, modification_date, creation_date, greetings, name, subject, body) VALUES  (67, 'aac3fd67-043c-46b2-9fe6-7aa89d12c099', 1, 1, 16, true, false, now(), now(), 'Bonjour ${firstName} ${lastName},<br/><br/>', 'Invitation de dépôt filtrée', 'Une invitation de dépôt a été filtrée: ${subject}', 'Une nouvelle demande d’invitation de dépôt à été filtrée.<br/>Subject: ${subject}<br/>${body}<br/><br/>');
-- UPLOAD_REQUEST_CREATED
INSERT INTO mail_content (id, uuid, domain_abstract_id, language, mail_content_type, visible, plaintext, modification_date, creation_date, greetings, name, subject, body) VALUES  (68, '6d821746-e481-4eb1-84f8-0d64a0b8f526', 1, 1, 17, true, false, now(), now(), 'Bonjour ${firstName} ${lastName},<br/><br/>', 'Nouvelle invitation de dépôt', '${actorRepresentation} a créé une invitation de dépôt: ${subject}', '<strong>${firstName} ${lastName}</strong> a créé l’invitation de dépôt: ${subject}<br/>${body}<br/>Elle sera active le ${activationDate}<br/><br/>');
-- UPLOAD_REQUEST_ACKNOWLEDGEMENT
INSERT INTO mail_content (id, uuid, domain_abstract_id, language, mail_content_type, visible, plaintext, modification_date, creation_date, greetings, name, subject, body) VALUES  (69, '879ea2d3-68e4-465b-b6ce-4ee58998e441', 1, 1, 18, true, false, now(), now(), 'Bonjour ${firstName} ${lastName},<br/><br/>', 'Accusé de reception d’invitation de dépôt', '${actorRepresentation} a déposé un fichier pour l’invitation de dépôt: ${subject}', '<strong>${firstName} ${lastName}</strong> a déposé un fichier.<br/>Nom du fichier: ${fileName}<br/>Date de dépôt: ${depositDate}<br/>Taille du fichier: ${fileSize}<br/><br/>');
-- UPLOAD_REQUEST_REMINDER
INSERT INTO mail_content (id, uuid, domain_abstract_id, language, mail_content_type, visible, plaintext, modification_date, creation_date, greetings, name, subject, body) VALUES  (70, '7a1baafb-1db3-4e9b-b39f-2f770d9e848b', 1, 1, 19, true, false, now(), now(), 'Bonjour ${firstName} ${lastName},<br/><br/>', 'Rappel d’invitation de dépôt', '${actorRepresentation} vous rappelle l’invitation de dépôt: ${subject}', '<strong>${firstName} ${lastName}</strong> vous rappelle l’invitation de dépôt: ${subject}<br/>${body}<br/>Pour déposer des fichiers, cliquer sur le lien suivant ou copier/coller ce dernier dans votre navigateur favoris: <a href="${url}">${url}</a><br/>L’invitation de dépôt peu être <b>protégée</b>, utiliser le <em>nouveau mot de passe</em> suivant: <code>${password}</code><br/><br/>');
-- UPLOAD_REQUEST_WARN_OWNER_BEFORE_EXPIRY
INSERT INTO mail_content (id, uuid, domain_abstract_id, language, mail_content_type, visible, plaintext, modification_date, creation_date, greetings, name, subject, body) VALUES  (71, '259b20a2-48a9-4282-bac9-07b6673062c4', 1, 1, 20, true, false, now(), now(), 'Bonjour ${firstName} ${lastName},<br/><br/>', 'Invitation de dépôt bientôt expirée', 'L’invitation de dépôt: ${subject}, va expirée', 'La date d’expiraton approche pour l’invitation de dépôt: ${subject}<br/>${body}<br/>Vérifier que l’invitation est complêtée<br/>Fichiers déjà déposés: ${files}<br/><br/>');
-- UPLOAD_REQUEST_WARN_RECIPIENT_BEFORE_EXPIRY
INSERT INTO mail_content (id, uuid, domain_abstract_id, language, mail_content_type, visible, plaintext, modification_date, creation_date, greetings, name, subject, body) VALUES  (72, '44c650a5-084d-4821-9e87-d0c54ec4db77', 1, 1, 21, true, false, now(), now(), 'Bonjour ${firstName} ${lastName},<br/><br/>', 'Invitation de dépôt bientôt expirée', 'L’invitation de dépôt: ${subject}, va expirée', 'La date d’expiration approche pour l’invitation de dépôt: ${subject}<br/>${body}<br/>Fichiers déjà déposés: ${files}<br/>Pour déposer des fichiers, cliquer sur le lien suivant ou copier/coller ce dernier dans votre navigateur favoris: <a href="${url}">${url}</a><br/><br/>');
-- UPLOAD_REQUEST_WARN_OWNER_EXPIRY
INSERT INTO mail_content (id, uuid, domain_abstract_id, language, mail_content_type, visible, plaintext, modification_date, creation_date, greetings, name, subject, body) VALUES  (73, '5ae69e7f-cbf7-4958-a069-6e74135810d4', 1, 1, 22, true, false, now(), now(), 'Bonjour ${firstName} ${lastName},<br/><br/>', 'Invitation de dépôt expirée', 'L’invitation de dépôt: ${subject}, est expirée', 'Expiration de l’invitation de dépôt: ${subject}<br/>${body}<br/>Fichiers déposés: ${files}<br/><br/>');
-- UPLOAD_REQUEST_WARN_RECIPIENT_EXPIRY
INSERT INTO mail_content (id, uuid, domain_abstract_id, language, mail_content_type, visible, plaintext, modification_date, creation_date, greetings, name, subject, body) VALUES  (74, '52d97982-ea1e-43b6-8012-39ba1578f0be', 1, 1, 23, true, false, now(), now(), 'Bonjour ${firstName} ${lastName},<br/><br/>', 'Invitation de dépôt expirée', 'L’invitation de dépôt: ${subject}, est expirée', 'Expiration de l’invitation de dépôt: ${subject}<br/>${body}</br>Fichiers déposés: ${files}<br/>Vous ne serez plus en mesure d’y déposer des fichiers<br/><br/>');
-- UPLOAD_REQUEST_CLOSED_BY_RECIPIENT
INSERT INTO mail_content (id, uuid, domain_abstract_id, language, mail_content_type, visible, plaintext, modification_date, creation_date, greetings, name, subject, body) VALUES  (75, '7f0fb9f5-6215-4e1f-946f-d7532e390684', 1, 1, 24, true, false, now(), now(), 'Bonjour ${firstName} ${lastName},<br/><br/>', 'Invitation de dépôt clôturée', '${actorRepresentation} a clôturé l’invitation de dépôt: ${subject}', '<strong>${firstName} ${lastName}</strong> a clôturé l’invitation de dépôt: ${subject}<br/>${body}<br/>Fichiers déposés: ${files}<br/><br/>');
-- UPLOAD_REQUEST_CLOSED_BY_OWNER
INSERT INTO mail_content (id, uuid, domain_abstract_id, language, mail_content_type, visible, plaintext, modification_date, creation_date, greetings, name, subject, body) VALUES  (76, 'ce8256c9-bdf5-45fa-ad1d-51d2b546273e', 1, 1, 25, true, false, now(), now(), 'Bonjour ${firstName} ${lastName},<br/><br/>', 'Invitation de dépôt clôturée', '${actorRepresentation} a clôturé l’invitation de dépôt: ${subject}', '<strong>${firstName} ${lastName}</strong> a clôturé l’invitation de dépôt: ${subject}<br/>${body}<br/>Fichiers déposés: ${files}<br/>Vous ne serez plus en mesure d’y déposer des fichiers<br/><br/>');
-- UPLOAD_REQUEST_DELETED_BY_OWNER
INSERT INTO mail_content (id, uuid, domain_abstract_id, language, mail_content_type, visible, plaintext, modification_date, creation_date, greetings, name, subject, body) VALUES  (77, '1ebf231f-ab5e-469a-9487-c460db735e96', 1, 1, 26, true, false, now(), now(), 'Bonjour ${firstName} ${lastName},<br/><br/>', 'Invitation de dépôt supprimée', '${actorRepresentation} a supprimé l’invitation de dépôt: ${subject}', '<strong>${firstName} ${lastName}</strong> a supprimé une invitation de dépôt: ${subject}<br/>${body}<br/>Vous ne serez plus en mesure d’y déposer des fichiers<br/><br/>');
-- UPLOAD_REQUEST_NO_SPACE_LEFT
INSERT INTO mail_content (id, uuid, domain_abstract_id, language, mail_content_type, visible, plaintext, modification_date, creation_date, greetings, name, subject, body) VALUES  (78, 'a89afcb4-2bef-431c-9967-e2cf4de38933', 1, 1, 27, true, false, now(), now(), 'Bonjour ${firstName} ${lastName},<br/><br/>', 'Erreur sur une d’invitation de dépôt: espace disque insuffisant', '${actorRepresentation} a essayé de déposer un fichier mais le serveur n’a pas suffisamment d’espace', '<strong>${firstName} ${lastName}</strong> a tenté de déposer un fichier dans l’invitation de dépôt: ${subject}<br/>${body}<br/>Veuiller libérer de l’espace puis notifier le destinataire d’exécuter son dépôt à nouveau<br/><br/>');
-- UPLOAD_REQUEST_FILE_DELETED_BY_SENDER
INSERT INTO mail_content (id, uuid, domain_abstract_id, language, mail_content_type, visible, plaintext, modification_date, creation_date, greetings, name, subject, body) VALUES  (81, '41ef3560-e9ca-11e4-b6b4-5404a6202d2c', 1, 1, 29, true, false, now(), now(), 'Bonjour ${firstName} ${lastName},<br/><br/>', 'Suppression de fichier après dépôt', '${actorRepresentation} a supprimé un fichier suite à une invitation de dépôt: ${subject}', '<strong>${firstName} ${lastName}</strong> a supprimé un fichier.<br/>Nom du fichier: ${fileName}<br/>Date de suppression: ${deleteDate}<br/>Taille du fichier: ${fileSize}<br/><br/>');
-- SHARE_CREATION_ACKNOWLEDGEMENT_FOR_OWNER
INSERT INTO mail_content (id, uuid, domain_abstract_id, language, mail_content_type, visible, plaintext, modification_date, creation_date, greetings, name, subject, body, enable_as) VALUES  (82, '5f705812-e351-11e4-b752-08002722e7b1', 1, 1, 30, true, false, now(), now(), 'Bonjour ${firstName} ${lastName},<br/><br/>', 'Accusé de réception de création de partag', '[Accusé de Réception]  Partagé le ${date}.', 'Vous avez partagé ${fileNumber} document(s), le ${creationDate}, expirant le ${expirationDate}, avec : <ul>${recipientNames}</ul><br/>Voici la liste des documents partagés : <ul>${documentNames}</ul>', false);
INSERT INTO mail_content (id, uuid, domain_abstract_id, language, mail_content_type, visible, plaintext, modification_date, creation_date, greetings, name, subject, body, enable_as) VALUES  (83, 'edd4eba0-f7b9-11e4-95cc-08002722e7b1', 1, 1, 31, true, false, now(), now(), 'Bonjour ${firstName} ${lastName},<br/><br/>', 'Accusé de réception de création de partag', '[Accusé de Réception] ${subject}. Partagé le ${date}.', 'Vous avez partagé ${fileNumber} document(s), le ${creationDate}, expirant le ${expirationDate}, avec : <ul>${recipientNames}</ul>Votre message original est le suivant :<br/><i>${message}</i><br/><br/>Voici la liste des documents partagés :<br/><ul>${documentNames}</ul>', false);
-- UNDOWNLOADED_SHARED_DOCUMENT_ALERT
INSERT INTO mail_content (id, uuid, domain_abstract_id, language, mail_content_type, visible, plaintext, modification_date, creation_date, greetings, name, subject, body) VALUES  (84, 'f2cc5735-a3fe-43e8-ae9c-bace74195af0', 1, 1, 32, true, false, now(), now(), 'Bonjour ${firstName} ${lastName},<br/><br/>', 'Accusé de non téléchargement de fichiers', '[Accusé de Non Téléchargement] ${subject} Partagé le ${date}.', 'Veuillez trouver ci-dessous le suivi du partage de documents réalisé le ${creationDate} avec pour date d’expiration initiale le ${expirationDate}.<br /> Liste des documents : <br /><table style="border-collapse: collapse;">${shareInfo}</table><br/>');

INSERT INTO mail_config (id, name, domain_abstract_id, visible, mail_layout_html_id, mail_layout_text_id, modification_date, creation_date, uuid) VALUES (1, 'Default mail config', 1, true, 1, 2, now(), now(), '946b190d-4c95-485f-bfe6-d288a2de1edd');

INSERT INTO mail_footer_lang(id, mail_config_id, language, mail_footer_id, uuid) VALUES (1, 1, 0, 1, 'bf87e580-fb25-49bb-8d63-579a31a8f81e');
INSERT INTO mail_footer_lang(id, mail_config_id, language, mail_footer_id, uuid) VALUES (2, 1, 1, 2, 'a6c8ee84-b5a8-4c96-b148-43301fbccdd9');

INSERT INTO mail_content_lang(id, mail_config_id, language, mail_content_id, mail_content_type, uuid) VALUES (1, 1, 0, 1, 0, 'd6868568-f5bd-4677-b4e2-9d6924a58871');
INSERT INTO mail_content_lang(id, mail_config_id, language, mail_content_id, mail_content_type, uuid) VALUES (2, 1, 0, 2, 1, '4f3c4723-531e-449b-a1ae-d304fd3d2387');
INSERT INTO mail_content_lang(id, mail_config_id, language, mail_content_id, mail_content_type, uuid) VALUES (3, 1, 0, 3, 2, '81041673-c699-4849-8be4-58eea4507305');
INSERT INTO mail_content_lang(id, mail_config_id, language, mail_content_id, mail_content_type, uuid) VALUES (4, 1, 0, 4, 3, '85538234-1fc1-47a2-850d-7f7b59f1640e');
INSERT INTO mail_content_lang(id, mail_config_id, language, mail_content_id, mail_content_type, uuid) VALUES (5, 1, 0, 5, 4, '796a98eb-0b97-4756-b23e-74b5a939c2e3');
INSERT INTO mail_content_lang(id, mail_config_id, language, mail_content_id, mail_content_type, uuid) VALUES (6, 1, 0, 6, 5, 'ed70cc00-099e-4c44-8937-e8f51835000b');
INSERT INTO mail_content_lang(id, mail_config_id, language, mail_content_id, mail_content_type, uuid) VALUES (7, 1, 0, 7, 6, 'f355793b-17d4-499c-bb2b-e3264bc13dbd');
INSERT INTO mail_content_lang(id, mail_config_id, language, mail_content_id, mail_content_type, uuid) VALUES (8, 1, 0, 8, 7, '5a6764fc-350c-4f10-bdb0-e95ca7607607');
INSERT INTO mail_content_lang(id, mail_config_id, language, mail_content_id, mail_content_type, uuid) VALUES (9, 1, 0, 9, 8, 'befd8182-88a6-4c72-8bae-5fcb7a79b8e7');
INSERT INTO mail_content_lang(id, mail_config_id, language, mail_content_id, mail_content_type, uuid) VALUES (10, 1, 0, 10, 9, 'fa59abad-490b-4cd5-9a31-3c3302fc4a18');
INSERT INTO mail_content_lang(id, mail_config_id, language, mail_content_id, mail_content_type, uuid) VALUES (11, 1, 0, 11, 10, '5bd828fa-d25e-47fa-9c0d-1bb84304e692');
INSERT INTO mail_content_lang(id, mail_config_id, language, mail_content_id, mail_content_type, uuid) VALUES (12, 1, 0, 12, 11, 'a9096a7e-949c-4fae-aedf-2347c40cd999');
INSERT INTO mail_content_lang(id, mail_config_id, language, mail_content_id, mail_content_type, uuid) VALUES (13, 1, 0, 13, 12, '1216ca54-f510-426c-a12b-8158efa21619');
INSERT INTO mail_content_lang(id, mail_config_id, language, mail_content_id, mail_content_type, uuid) VALUES (14, 1, 0, 14, 13, '9f87c53d-80e5-4e10-b571-d0c9f9c35017');
INSERT INTO mail_content_lang(id, mail_config_id, language, mail_content_id, mail_content_type, uuid) VALUES (15, 1, 0, 15, 14, '454e3e88-7129-4e98-a79a-e119cb94bd07');
INSERT INTO mail_content_lang(id, mail_config_id, language, mail_content_id, mail_content_type, uuid) VALUES (16, 1, 0, 16, 15, '0a8251dd-9514-4b7b-bf47-c398c00ba21b');
INSERT INTO mail_content_lang(id, mail_config_id, language, mail_content_id, mail_content_type, uuid) VALUES (17, 1, 0, 17, 16, 'e3b99efb-875c-4c63-bd5c-8f121d75876b');
INSERT INTO mail_content_lang(id, mail_config_id, language, mail_content_id, mail_content_type, uuid) VALUES (18, 1, 0, 18, 17, 'e37cbade-db93-487d-96ee-dc491ce63035');
INSERT INTO mail_content_lang(id, mail_config_id, language, mail_content_id, mail_content_type, uuid) VALUES (19, 1, 0, 19, 18, '8d707581-3920-4d82-a8ba-f7984afc54ca');
INSERT INTO mail_content_lang(id, mail_config_id, language, mail_content_id, mail_content_type, uuid) VALUES (20, 1, 0, 20, 19, '64b5df7b-b197-49a7-b0af-aaac2c2f8d79');
INSERT INTO mail_content_lang(id, mail_config_id, language, mail_content_id, mail_content_type, uuid) VALUES (21, 1, 0, 21, 20, 'fd6011cf-e4cf-478d-835b-75b25e024b81');
INSERT INTO mail_content_lang(id, mail_config_id, language, mail_content_id, mail_content_type, uuid) VALUES (22, 1, 0, 22, 21, 'e4439f5b-380b-4a78-86a7-764f15ff599d');
INSERT INTO mail_content_lang(id, mail_config_id, language, mail_content_id, mail_content_type, uuid) VALUES (23, 1, 0, 23, 22, '7a560359-fa35-4ffd-ac1d-1d9ceef1b1e0');
INSERT INTO mail_content_lang(id, mail_config_id, language, mail_content_id, mail_content_type, uuid) VALUES (24, 1, 0, 24, 23, '2b038721-fe6e-4406-b5de-c4c84a964df8');
INSERT INTO mail_content_lang(id, mail_config_id, language, mail_content_id, mail_content_type, uuid) VALUES (25, 1, 0, 25, 24, '822b3ede-daea-4b60-a8a2-2216c7d36fea');
INSERT INTO mail_content_lang(id, mail_config_id, language, mail_content_id, mail_content_type, uuid) VALUES (26, 1, 0, 26, 25, 'd8316b6b-f6c8-408b-ac7d-1ebea767912e');
INSERT INTO mail_content_lang(id, mail_config_id, language, mail_content_id, mail_content_type, uuid) VALUES (27, 1, 0, 27, 26, '7642b888-3bd8-4f8c-b65c-81b61e512137');
INSERT INTO mail_content_lang(id, mail_config_id, language, mail_content_id, mail_content_type, uuid) VALUES (28, 1, 0, 28, 27, '9bf9d474-fd10-48da-843c-dfadebd2b455');
INSERT INTO mail_content_lang(id, mail_config_id, language, mail_content_id, mail_content_type, uuid) VALUES (30, 1, 0, 30, 29, 'ec270da7-e9cb-11e4-b6b4-5404a6202d2c');
INSERT INTO mail_content_lang(id, mail_config_id, language, mail_content_id, mail_content_type, uuid) VALUES (31, 1, 0, 31, 30, '447217e4-e1ee-11e4-8a45-fb8c68777bdf');
INSERT INTO mail_content_lang(id, mail_config_id, language, mail_content_id, mail_content_type, uuid) VALUES (32, 1, 0, 32, 31, '1837a6f0-e8c7-11e4-b36a-08002722e7b1');
INSERT INTO mail_content_lang(id, mail_config_id, language, mail_content_id, mail_content_type, uuid) VALUES (33, 1, 0, 33, 32, 'bfcced12-7325-49df-bf84-65ed90ff7f59');

INSERT INTO mail_content_lang(id, mail_config_id, language, mail_content_id, mail_content_type, uuid) VALUES (51, 1, 1, 51, 0, 'd0af96a7-6a9c-4c3f-8b8c-7c8e2d0449e1');
INSERT INTO mail_content_lang(id, mail_config_id, language, mail_content_id, mail_content_type, uuid) VALUES (52, 1, 1, 52, 1, '28e5855a-c0e7-40fc-8401-9cf25eb53f03');
INSERT INTO mail_content_lang(id, mail_config_id, language, mail_content_id, mail_content_type, uuid) VALUES (53, 1, 1, 53, 2, '41d0f03d-57dd-420e-84b0-7908179c8329');
INSERT INTO mail_content_lang(id, mail_config_id, language, mail_content_id, mail_content_type, uuid) VALUES (54, 1, 1, 54, 3, '72c0fff4-4638-4e98-8223-df27f8f8ea8b');
INSERT INTO mail_content_lang(id, mail_config_id, language, mail_content_id, mail_content_type, uuid) VALUES (55, 1, 1, 55, 4, '8b7f57c1-b4a1-4896-8e19-d3ebf3af4831');
INSERT INTO mail_content_lang(id, mail_config_id, language, mail_content_id, mail_content_type, uuid) VALUES (56, 1, 1, 56, 5, '6fbabf1a-58c0-49b9-859e-d24b0af38c87');
INSERT INTO mail_content_lang(id, mail_config_id, language, mail_content_id, mail_content_type, uuid) VALUES (57, 1, 1, 57, 6, 'b85fc62f-d9eb-454b-9289-fec5eab51a76');
INSERT INTO mail_content_lang(id, mail_config_id, language, mail_content_id, mail_content_type, uuid) VALUES (58, 1, 1, 58, 7, '25540d2d-b3b8-46a9-811b-0549ad300fe0');
INSERT INTO mail_content_lang(id, mail_config_id, language, mail_content_id, mail_content_type, uuid) VALUES (59, 1, 1, 59, 8, '72ae03e7-5865-433c-a2be-a95c655a8e17');
INSERT INTO mail_content_lang(id, mail_config_id, language, mail_content_id, mail_content_type, uuid) VALUES (60, 1, 1, 60, 9, 'e2af2ff6-585b-4cdc-a887-1755e42fcde6');
INSERT INTO mail_content_lang(id, mail_config_id, language, mail_content_id, mail_content_type, uuid) VALUES (61, 1, 1, 61, 10, '1ee1c8bc-75e9-4fbe-a34b-893a86704ec9');
INSERT INTO mail_content_lang(id, mail_config_id, language, mail_content_id, mail_content_type, uuid) VALUES (62, 1, 1, 62, 11, '12242aa8-b75e-404d-85df-68e7bb8c04af');
INSERT INTO mail_content_lang(id, mail_config_id, language, mail_content_id, mail_content_type, uuid) VALUES (63, 1, 1, 63, 12, '4f2ad41c-3969-461d-a6dc-8f692a1738e9');
INSERT INTO mail_content_lang(id, mail_config_id, language, mail_content_id, mail_content_type, uuid) VALUES (64, 1, 1, 64, 13, '362cf576-30ab-41a5-85d0-3d9175935b14');
INSERT INTO mail_content_lang(id, mail_config_id, language, mail_content_id, mail_content_type, uuid) VALUES (65, 1, 1, 65, 14, '35b81d85-0ee7-44f9-b478-20c8429c2b6d');
INSERT INTO mail_content_lang(id, mail_config_id, language, mail_content_id, mail_content_type, uuid) VALUES (66, 1, 1, 66, 15, '92e0a55e-e4e8-43c9-94f0-0d4e74d5748f');
INSERT INTO mail_content_lang(id, mail_config_id, language, mail_content_id, mail_content_type, uuid) VALUES (67, 1, 1, 67, 16, 'eb8a1b1e-758d-4261-8616-8ead644f70b0');
INSERT INTO mail_content_lang(id, mail_config_id, language, mail_content_id, mail_content_type, uuid) VALUES (68, 1, 1, 68, 17, '50ae2621-556c-446d-a399-55ed799022c3');
INSERT INTO mail_content_lang(id, mail_config_id, language, mail_content_id, mail_content_type, uuid) VALUES (69, 1, 1, 69, 18, '6580009b-36fd-472d-9937-41d0097ead91');
INSERT INTO mail_content_lang(id, mail_config_id, language, mail_content_id, mail_content_type, uuid) VALUES (70, 1, 1, 70, 19, 'ed471d9b-6f64-4d36-97cb-654b73579fe9');
INSERT INTO mail_content_lang(id, mail_config_id, language, mail_content_id, mail_content_type, uuid) VALUES (71, 1, 1, 71, 20, '86fdc43c-5fd7-4aba-b01a-90fccbfb5489');
INSERT INTO mail_content_lang(id, mail_config_id, language, mail_content_id, mail_content_type, uuid) VALUES (72, 1, 1, 72, 21, 'ea3f9814-6da9-49bf-94e5-7ff2c789e07b');
INSERT INTO mail_content_lang(id, mail_config_id, language, mail_content_id, mail_content_type, uuid) VALUES (73, 1, 1, 73, 22, 'f9455b1d-3582-4998-8675-bc0a8137fc73');
INSERT INTO mail_content_lang(id, mail_config_id, language, mail_content_id, mail_content_type, uuid) VALUES (74, 1, 1, 74, 23, '8f91e46b-1cee-45bc-8712-23ea0298db87');
INSERT INTO mail_content_lang(id, mail_config_id, language, mail_content_id, mail_content_type, uuid) VALUES (75, 1, 1, 75, 24, 'e5a9f689-c005-47c2-958f-b68071b1bf6f');
INSERT INTO mail_content_lang(id, mail_config_id, language, mail_content_id, mail_content_type, uuid) VALUES (76, 1, 1, 76, 25, 'a7994bd1-bd67-4cc6-93f3-be935c1cdb67');
INSERT INTO mail_content_lang(id, mail_config_id, language, mail_content_id, mail_content_type, uuid) VALUES (77, 1, 1, 77, 26, '5e1fb460-1efc-497c-96d8-6adf162cbc4e');
INSERT INTO mail_content_lang(id, mail_config_id, language, mail_content_id, mail_content_type, uuid) VALUES (78, 1, 1, 78, 27, '2daaea2a-1b13-48b4-89a6-032f7e034a2d');
INSERT INTO mail_content_lang(id, mail_config_id, language, mail_content_id, mail_content_type, uuid) VALUES (81, 1, 1, 81, 29, 'd6e18c3b-e9cb-11e4-b6b4-5404a6202d2c');
INSERT INTO mail_content_lang(id, mail_config_id, language, mail_content_id, mail_content_type, uuid) VALUES (82, 1, 1, 82, 30, '8f579a8a-e352-11e4-99b3-08002722e7b1');
INSERT INTO mail_content_lang(id, mail_config_id, language, mail_content_id, mail_content_type, uuid) VALUES (83, 1, 1, 83, 31, '2d3a0e80-e8c7-11e4-8349-08002722e7b1');
INSERT INTO mail_content_lang(id, mail_config_id, language, mail_content_id, mail_content_type, uuid) VALUES (84, 1, 1, 84, 32, 'fa7a23cb-f545-45b4-b9dc-c39586cb2398');

UPDATE domain_abstract SET mailconfig_id = 1;

-- LinShare version
INSERT INTO version (id,version) VALUES (1,'1.12.0');

-- Alias
CREATE VIEW alias_func_list_all  AS SELECT
 functionality.id, functionality.system as sys, identifier, policy_delegation_id AS pd_id, domain_id, param, parent_identifier AS parent,
 ap.status AS ap_status, ap.default_status AS ap_default, ap.policy AS ap_policy, ap.system AS ap_sys,
 cp.status AS cp_status, cp.default_status AS cp_default, cp.policy AS cp_policy, cp.system AS cp_sys
 FROM functionality
 JOIN policy AS ap ON policy_activation_id = ap.id
 JOIN policy AS cp ON policy_configuration_id = cp.id order by identifier;

-- Alias for Users
-- All users
CREATE VIEW alias_users_list_all AS
 SELECT id, first_name, last_name, mail, can_upload, restricted, expiration_date, ldap_uid, domain_id, ls_uuid, creation_date, modification_date, role_id, account_type from users as u join account as a on a.id=u.account_id;
-- All active users
CREATE VIEW alias_users_list_active AS
 SELECT id, first_name, last_name, mail, can_upload, restricted, expiration_date, ldap_uid, domain_id, ls_uuid, creation_date, modification_date, role_id, account_type from users as u join account as a on a.id=u.account_id where a.destroyed = 0;
-- All destroyed users
CREATE VIEW alias_users_list_destroyed AS
 SELECT id, first_name, last_name, mail, can_upload, restricted, expiration_date, ldap_uid, domain_id, ls_uuid, creation_date, modification_date, role_id, account_type from users as u join account as a on a.id=u.account_id where a.destroyed > 0;

-- Alias for threads
-- All threads
CREATE VIEW alias_threads_list_all AS SELECT a.id, name, domain_id, ls_uuid, creation_date, modification_date, enable, destroyed from thread as u join account as a on a.id=u.account_id;
-- All active threads
CREATE VIEW alias_threads_list_active AS SELECT a.id, name, domain_id, ls_uuid, creation_date, modification_date, enable, destroyed from thread as u join account as a on a.id=u.account_id where a.destroyed = 0;
-- All destroyed threads
CREATE VIEW alias_threads_list_destroyed AS SELECT a.id, name, domain_id, ls_uuid, creation_date, modification_date, enable, destroyed from thread as u join account as a on a.id=u.account_id where a.destroyed > 0;

COMMIT;
