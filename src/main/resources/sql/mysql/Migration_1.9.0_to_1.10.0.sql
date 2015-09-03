SET storage_engine=INNODB;
SET NAMES UTF8 COLLATE utf8_general_ci;
SET CHARACTER SET UTF8;

SET AUTOCOMMIT=0;
START TRANSACTION;

ALTER TABLE users ADD COLUMN inconsistent tinyint(1) DEFAULT False;


ALTER TABLE account MODIFY destroyed TINYINT(1);
ALTER TABLE account MODIFY enable TINYINT(1);
ALTER TABLE account ADD COLUMN cmis_locale varchar(255) DEFAULT 'en' NOT NULL;

ALTER TABLE document MODIFY check_mime_type TINYINT(1);

ALTER TABLE document_entry MODIFY ciphered TINYINT(1);
ALTER TABLE document_entry MODIFY has_thumbnail TINYINT(1);

ALTER TABLE entry ADD COLUMN cmis_sync tinyint(1) DEFAULT false NOT NULL;

ALTER TABLE domain_abstract MODIFY enable TINYINT(1);
ALTER TABLE domain_abstract MODIFY template TINYINT(1);
ALTER TABLE domain_abstract MODIFY description text NOT NULL;


-- CHANGING bit to tinyint(1) for some columns
ALTER TABLE functionality MODIFY system TINYINT(1);
ALTER TABLE functionality MODIFY param TINYINT(1);

ALTER TABLE policy MODIFY status TINYINT(1);
ALTER TABLE policy MODIFY default_status TINYINT(1);
ALTER TABLE policy MODIFY system TINYINT(1);

ALTER TABLE ldap_attribute MODIFY sync TINYINT(1);
ALTER TABLE ldap_attribute MODIFY system TINYINT(1);
ALTER TABLE ldap_attribute MODIFY enable TINYINT(1);
ALTER TABLE ldap_attribute MODIFY completion TINYINT(1);

ALTER TABLE thread_entry MODIFY ciphered TINYINT(1);
ALTER TABLE thread_entry MODIFY has_thumbnail TINYINT(1);

ALTER TABLE thread_member MODIFY admin TINYINT(1);
ALTER TABLE thread_member MODIFY can_upload TINYINT(1);

ALTER TABLE users MODIFY can_upload TINYINT(1);
ALTER TABLE users MODIFY restricted TINYINT(1);
ALTER TABLE users MODIFY can_create_guest TINYINT(1);

ALTER TABLE mail_notification MODIFY system TINYINT(1);

ALTER TABLE mail_config MODIFY visible TINYINT(1);

ALTER TABLE mail_layout MODIFY visible TINYINT(1);
ALTER TABLE mail_layout MODIFY plaintext TINYINT(1);

ALTER TABLE mail_footer MODIFY visible TINYINT(1);
ALTER TABLE mail_footer MODIFY plaintext TINYINT(1);

ALTER TABLE mail_content MODIFY visible TINYINT(1);
ALTER TABLE mail_content MODIFY plaintext TINYINT(1);
ALTER TABLE mail_content MODIFY enable_as TINYINT(1);

ALTER TABLE upload_request MODIFY can_delete TINYINT(1);
ALTER TABLE upload_request MODIFY can_close TINYINT(1);
ALTER TABLE upload_request MODIFY can_edit_expiry_date TINYINT(1);
ALTER TABLE upload_request MODIFY secured TINYINT(1);

ALTER TABLE upload_request_history MODIFY status_updated TINYINT(1);
ALTER TABLE upload_request_history MODIFY can_delete TINYINT(1);
ALTER TABLE upload_request_history MODIFY can_close TINYINT(1);
ALTER TABLE upload_request_history MODIFY can_edit_expiry_date TINYINT(1);
ALTER TABLE upload_request_history MODIFY secured TINYINT(1);

ALTER TABLE upload_proposition_filter MODIFY enable TINYINT(1);

ALTER TABLE mailing_list MODIFY is_public TINYINT(1);

ALTER TABLE upload_request_template MODIFY group_mode TINYINT(1);
ALTER TABLE upload_request_template MODIFY deposit_mode TINYINT(1);
ALTER TABLE upload_request_template MODIFY secured TINYINT(1);
ALTER TABLE upload_request_template MODIFY prolongation_mode TINYINT(1);

ALTER TABLE mime_type MODIFY enable TINYINT(1);
ALTER TABLE mime_type MODIFY displayable TINYINT(1);

ALTER TABLE functionality_boolean MODIFY boolean_value TINYINT(1);

ALTER TABLE ldap_pattern MODIFY system TINYINT(1);



UPDATE mail_content SET language = 1 where id = 80;

UPDATE mail_content set body = 'Vous avez partagé ${fileNumber} document(s), le ${creationDate}, expirant le ${expirationDate}, avec : <ul>${recipientNames}</ul><br/>Voici la liste des documents partagés : <ul>${documentNames}</ul>' where id = 82;

UPDATE mail_content set body = 'Vous avez partagé ${fileNumber} document(s), le ${creationDate}, expirant le ${expirationDate}, avec : <ul>${recipientNames}</ul>Votre message original est le suivant :<br/><i>${message}</i><br/><br/>Voici la liste des documents partagés :<br/><ul>${documentNames}</ul>' where id = 83;




CREATE TABLE share_entry_group (
  id                bigint(8) NOT NULL AUTO_INCREMENT,
  account_id        bigint(8) NOT NULL,
  uuid              varchar(255) NOT NULL UNIQUE,
  subject           text,
  notification_date datetime NULL,
  creation_date     datetime NOT NULL,
  modification_date datetime NOT NULL,
  expiration_date   datetime NULL,
  notified          tinyint(1) DEFAULT false NOT NULL,
  processed         tinyint(1) DEFAULT false NOT NULL,
  PRIMARY KEY (id)) CHARACTER SET UTF8;
CREATE TABLE mail_activation (
  id                      bigint(8) NOT NULL AUTO_INCREMENT,
  identifier              varchar(255) NOT NULL,
  system                  tinyint(1) NOT NULL,
  policy_activation_id    bigint(8) NOT NULL,
  policy_configuration_id bigint(8) NOT NULL,
  policy_delegation_id    bigint(8) NOT NULL,
  domain_id               bigint(8) NOT NULL,
  enable                  tinyint(1) NOT NULL,
  PRIMARY KEY (id)) CHARACTER SET UTF8;

ALTER TABLE anonymous_share_entry ADD COLUMN share_entry_group_id bigint(8);
ALTER TABLE share_entry ADD COLUMN share_entry_group_id bigint(8);

ALTER TABLE anonymous_share_entry ADD INDEX FKanonymous_708340 (share_entry_group_id), ADD CONSTRAINT FKanonymous_708340 FOREIGN KEY (share_entry_group_id) REFERENCES share_entry_group (id);
ALTER TABLE share_entry ADD INDEX FKshare_entr137514 (share_entry_group_id), ADD CONSTRAINT FKshare_entr137514 FOREIGN KEY (share_entry_group_id) REFERENCES share_entry_group (id);
ALTER TABLE share_entry_group ADD INDEX shareEntryGroup (account_id), ADD CONSTRAINT shareEntryGroup FOREIGN KEY (account_id) REFERENCES account (id);

ALTER TABLE mail_activation ADD INDEX FKmail_activ188698 (domain_id), ADD CONSTRAINT FKmail_activ188698 FOREIGN KEY (domain_id) REFERENCES domain_abstract (id);
ALTER TABLE mail_activation ADD INDEX activation (policy_activation_id), ADD CONSTRAINT activation FOREIGN KEY (policy_activation_id) REFERENCES policy (id);
ALTER TABLE mail_activation ADD INDEX configuration (policy_configuration_id), ADD CONSTRAINT configuration FOREIGN KEY (policy_configuration_id) REFERENCES policy (id);
ALTER TABLE mail_activation ADD INDEX delegation (policy_delegation_id), ADD CONSTRAINT delegation FOREIGN KEY (policy_delegation_id) REFERENCES policy (id);

-- Functionality : UNDOWNLOADED_SHARED_DOCUMENTS_ALERT
INSERT INTO policy(status, default_status, policy, system) VALUES (true, true, 1, false);
SET @policy_activation_id = last_insert_id();
INSERT INTO policy(status, default_status, policy, system) VALUES (true, true, 1, false);
SET @policy_configuration_id = last_insert_id();
INSERT INTO policy(status, default_status, policy, system) VALUES (true, true, 1, false);
SET @policy_delegation_id = last_insert_id();
INSERT INTO functionality(system, identifier, policy_activation_id, policy_configuration_id, policy_delegation_id, domain_id, param)
 VALUES(false, 'UNDOWNLOADED_SHARED_DOCUMENTS_ALERT', @policy_activation_id, @policy_configuration_id, @policy_delegation_id, 1, false);
INSERT INTO functionality_boolean(functionality_id, boolean_value) VALUES (last_insert_id(), true);

-- Functionality : UNDOWNLOADED_SHARED_DOCUMENTS_ALERT__DURATION
INSERT INTO policy(status, default_status, policy, system) VALUES (true, true, 0, true);
SET @policy_activation_id = last_insert_id();
INSERT INTO policy(status, default_status, policy, system) VALUES (true, true, 1, false);
SET @policy_configuration_id = last_insert_id();
INSERT INTO policy(status, default_status, policy, system) VALUES (true, true, 1, false);
SET @policy_delegation_id = last_insert_id();
INSERT INTO functionality(system, identifier, policy_activation_id, policy_configuration_id, policy_delegation_id, domain_id, parent_identifier, param)
 VALUES(false, 'UNDOWNLOADED_SHARED_DOCUMENTS_ALERT__DURATION', @policy_activation_id, @policy_configuration_id, @policy_delegation_id, 1,'UNDOWNLOADED_SHARED_DOCUMENTS_ALERT', true);
INSERT INTO functionality_integer(functionality_id, integer_value) VALUES (last_insert_id(), 3);

-- Functionality : ANONYMOUS_URL__NOTIFICATION
INSERT INTO policy(status, default_status, policy, system) VALUES (true, true, 0, true);
SET @policy_activation_id = last_insert_id();
INSERT INTO policy(status, default_status, policy, system) VALUES (true, true, 1, false);
SET @policy_configuration_id = last_insert_id();
INSERT INTO policy(status, default_status, policy, system) VALUES (false, false, 2, true);
SET @policy_delegation_id = last_insert_id();
INSERT INTO functionality(system, identifier, policy_activation_id, policy_configuration_id, policy_delegation_id, domain_id, parent_identifier, param)
 VALUES(false, 'ANONYMOUS_URL__NOTIFICATION', @policy_activation_id, @policy_configuration_id, @policy_delegation_id, 1, 'ANONYMOUS_URL', true);
INSERT INTO functionality_boolean(functionality_id, boolean_value) VALUES (last_insert_id(), true);


-- MailActivation : BEGIN

DROP FUNCTION IF EXISTS ls_insert_mail_activation;
delimiter '$$'
CREATE FUNCTION ls_insert_mail_activation(ls_mail_activation_name VARCHAR(255)) RETURNS bigint(8)
BEGIN
        DECLARE result bigint(8);
        INSERT INTO policy(status, default_status, policy, system) VALUES (true, true, 0, true);
        INSERT INTO policy(status, default_status, policy, system) VALUES (true, true, 1, false);
        INSERT INTO policy(status, default_status, policy, system) VALUES (false, false, 2, true);
        INSERT INTO mail_activation(system, identifier, policy_activation_id, policy_configuration_id, policy_delegation_id, domain_id, enable)
         VALUES(false, ls_mail_activation_name, last_insert_id() - 2, last_insert_id() - 1, last_insert_id(), 1, true);
         SET result = last_insert_id();
         return result;
END$$

delimiter ';'

SELECT ls_insert_mail_activation('ANONYMOUS_DOWNLOAD');
SELECT ls_insert_mail_activation('REGISTERED_DOWNLOAD');
SELECT ls_insert_mail_activation('NEW_GUEST');
SELECT ls_insert_mail_activation('RESET_PASSWORD');
SELECT ls_insert_mail_activation('SHARED_DOC_UPDATED');
SELECT ls_insert_mail_activation('SHARED_DOC_DELETED');
SELECT ls_insert_mail_activation('SHARED_DOC_UPCOMING_OUTDATED');
SELECT ls_insert_mail_activation('DOC_UPCOMING_OUTDATED');
SELECT ls_insert_mail_activation('NEW_SHARING');
SELECT ls_insert_mail_activation('UPLOAD_PROPOSITION_CREATED');
SELECT ls_insert_mail_activation('UPLOAD_PROPOSITION_REJECTED');
SELECT ls_insert_mail_activation('UPLOAD_REQUEST_UPDATED');
SELECT ls_insert_mail_activation('UPLOAD_REQUEST_ACTIVATED');
SELECT ls_insert_mail_activation('UPLOAD_REQUEST_AUTO_FILTER');
SELECT ls_insert_mail_activation('UPLOAD_REQUEST_CREATED');
SELECT ls_insert_mail_activation('UPLOAD_REQUEST_ACKNOWLEDGEMENT');
SELECT ls_insert_mail_activation('UPLOAD_REQUEST_REMINDER');
SELECT ls_insert_mail_activation('UPLOAD_REQUEST_WARN_OWNER_BEFORE_EXPIRY');
SELECT ls_insert_mail_activation('UPLOAD_REQUEST_WARN_RECIPIENT_BEFORE_EXPIRY');
SELECT ls_insert_mail_activation('UPLOAD_REQUEST_WARN_OWNER_EXPIRY');
SELECT ls_insert_mail_activation('UPLOAD_REQUEST_WARN_RECIPIENT_EXPIRY');
SELECT ls_insert_mail_activation('UPLOAD_REQUEST_CLOSED_BY_RECIPIENT');
SELECT ls_insert_mail_activation('UPLOAD_REQUEST_CLOSED_BY_OWNER');
SELECT ls_insert_mail_activation('UPLOAD_REQUEST_DELETED_BY_OWNER');
SELECT ls_insert_mail_activation('UPLOAD_REQUEST_NO_SPACE_LEFT');
SELECT ls_insert_mail_activation('UPLOAD_REQUEST_FILE_DELETED_BY_SENDER');
SELECT ls_insert_mail_activation('SHARE_CREATION_ACKNOWLEDGEMENT_FOR_OWNER');
SELECT ls_insert_mail_activation('UNDOWNLOADED_SHARED_DOCUMENTS_ALERT');

-- MailActivation : END

-- UPDATE FUNCTIONALITIES THAT CONTAINS ACKNOWLEDGMENT INSTEAD OF ACKNOWLEDGMENT
UPDATE functionality SET identifier = 'SHARE_CREATION_ACKNOWLEDGEMENT_FOR_OWNER' WHERE identifier = 'SHARE_CREATION_ACKNOWLEDGMENT_FOR_OWNER';
UPDATE functionality SET identifier = 'DOMAIN__MAIL' WHERE identifier = 'DOMAIN_MAIL';

-- UNDOWNLOADED SHARED DOCUMENTS ALERT MAIL CONTENT ENGLISH
INSERT INTO mail_content (id, uuid, domain_abstract_id, language, mail_content_type, visible, plaintext, modification_date, creation_date, greetings, name, subject, body) VALUES  (33, 'eb291876-53fc-419b-831b-53a480399f7c', 1, 0, 32, true, false, now(), now(), 'Hello ${firstName} ${lastName},<br/><br/>', 'Undownloaded shared documents alert', '[Undownloaded shared documents alert] ${subject} Shared on ${date}.', 'Please find below the resume of the share you made on ${creationDate} with initial expiration date on ${expirationDate}.<br /> List of documents : <br /><table style="border-collapse: collapse;">${shareInfo}</table><br/>');
INSERT INTO mail_content_lang(id, mail_config_id, language, mail_content_id, mail_content_type, uuid) VALUES (33, 1, 0, 33, 32, 'bfcced12-7325-49df-bf84-65ed90ff7f59');
INSERT INTO mail_content_lang (mail_config_id, language, mail_content_id, mail_content_type, uuid) (SELECT config.id, 0, 33, 32, UUID() FROM mail_config AS config WHERE id <> 1);
-- UNDOWNLOADED SHARED DOCUMENTS ALERT MAIL CONTENT FRENCH
INSERT INTO mail_content (id, uuid, domain_abstract_id, language, mail_content_type, visible, plaintext, modification_date, creation_date, greetings, name, subject, body) VALUES  (84, 'f2cc5735-a3fe-43e8-ae9c-bace74195af0', 1, 1, 32, true, false, now(), now(), 'Bonjour ${firstName} ${lastName},<br/><br/>', 'Accusé de non téléchargement de fichiers', '[Accusé de Non Téléchargement] ${subject} Partagé le ${date}.', 'Veuillez trouver ci-dessous le suivi du partage de documents réalisé le ${creationDate} avec pour date d’expiration initiale le ${expirationDate}.<br /> Liste des documents : <br /><table style="border-collapse: collapse;">${shareInfo}</table><br/>');
INSERT INTO mail_content_lang(id, mail_config_id, language, mail_content_id, mail_content_type, uuid) VALUES (84, 1, 1, 84, 32, 'fa7a23cb-f545-45b4-b9dc-c39586cb2398');
INSERT INTO mail_content_lang (mail_config_id, language, mail_content_id, mail_content_type, uuid) (SELECT config.id, 1, 84, 32, UUID() FROM mail_config AS config WHERE id <> 1);

-- Fix Migration 1.8 to 1.9
UPDATE document_entry
	SET shared = (SELECT COUNT(document_entry_id)
	FROM (SELECT entry_id, document_entry_id FROM share_entry UNION ALL SELECT entry_id, document_entry_id FROM anonymous_share_entry) as all_shared
	WHERE all_shared.document_entry_id = document_entry.entry_id);

-- DROP UPLOAD_REQUEST_ENTRY_URL TABLE
-- step 1 : delete subclass functionality
CREATE TEMPORARY TABLE temptable_1_10_unit (id bigint(8));
INSERT INTO temptable_1_10_unit SELECT unit_id FROM functionality_unit as fu join functionality as f on f.id = fu.functionality_id WHERE parent_identifier = 'UPLOAD_REQUEST_ENTRY_URL';

CREATE TEMPORARY TABLE temptable_1_10 (id bigint(8));

INSERT INTO temptable_1_10 SELECT policy_activation_id FROM functionality WHERE identifier = 'UPLOAD_REQUEST_ENTRY_URL';
INSERT INTO temptable_1_10 SELECT policy_configuration_id FROM functionality WHERE identifier = 'UPLOAD_REQUEST_ENTRY_URL';
INSERT INTO temptable_1_10 SELECT policy_delegation_id FROM functionality WHERE identifier = 'UPLOAD_REQUEST_ENTRY_URL';

INSERT INTO temptable_1_10 SELECT policy_activation_id FROM functionality WHERE identifier = 'UPLOAD_REQUEST_ENTRY_URL__EXPIRATION';
INSERT INTO temptable_1_10 SELECT policy_configuration_id FROM functionality WHERE identifier = 'UPLOAD_REQUEST_ENTRY_URL__EXPIRATION';
INSERT INTO temptable_1_10 SELECT policy_delegation_id FROM functionality WHERE identifier = 'UPLOAD_REQUEST_ENTRY_URL__EXPIRATION';

INSERT INTO temptable_1_10 SELECT policy_activation_id FROM functionality WHERE identifier = 'UPLOAD_REQUEST_ENTRY_URL__PASSWORD';
INSERT INTO temptable_1_10 SELECT policy_configuration_id FROM functionality WHERE identifier = 'UPLOAD_REQUEST_ENTRY_URL__PASSWORD';
INSERT INTO temptable_1_10 SELECT policy_delegation_id FROM functionality WHERE identifier = 'UPLOAD_REQUEST_ENTRY_URL__PASSWORD';

-- step 2 : delete subclass functionality
DELETE FROM functionality_unit WHERE functionality_id in (SELECT id FROM functionality WHERE identifier = 'UPLOAD_REQUEST_ENTRY_URL__EXPIRATION');
DELETE FROM functionality_boolean WHERE functionality_id in (SELECT id FROM functionality WHERE identifier = 'UPLOAD_REQUEST_ENTRY_URL__PASSWORD');

-- step 3 : delete unit
DELETE FROM unit WHERE id in (SELECT id FROM temptable_1_10_unit);

-- step 4 : delete subclass functionality
DELETE FROM functionality WHERE identifier = 'UPLOAD_REQUEST_ENTRY_URL__PASSWORD';
DELETE FROM functionality WHERE identifier = 'UPLOAD_REQUEST_ENTRY_URL__EXPIRATION';
DELETE FROM functionality WHERE identifier = 'UPLOAD_REQUEST_ENTRY_URL';

-- step 5 : delete policies
DELETE FROM policy WHERE id in (SELECT id FROM temptable_1_10);
-- call ls_drop_constraint_if_exists("upload_request_entry_url", "FKupload_req784409");
DROP TABLE IF EXISTS upload_request_entry_url;
-- constraint was : FKupload_req784409


-- UPLOAD_REQUEST_ENTRY_URL = 28
DELETE FROM mail_content_lang WHERE mail_content_type = 28;
DELETE FROM mail_content WHERE mail_content_type = 28;

-- Fix: schema
ALTER TABLE document CHANGE `size` ls_size bigint(8) NOT NULL;
ALTER TABLE document_entry CHANGE `size` ls_size bigint(8) NOT NULL;
ALTER TABLE domain_access_rule CHANGE `regexp` ls_regexp VARCHAR(255);
ALTER TABLE signature CHANGE `size` ls_size bigint(8);
ALTER TABLE thread_entry CHANGE `size` ls_size bigint(8) NOT NULL;
ALTER TABLE upload_request_entry CHANGE `size` ls_size bigint(8) NOT NULL;
ALTER TABLE upload_proposition_filter CHANGE `match` ls_match VARCHAR(255) NOT NULL;
ALTER TABLE mail_content MODIFY enable_as TINYINT(1) DEFAULT False NOT NULL;

ALTER TABLE welcome_messages MODIFY COLUMN id int8 NOT NULL AUTO_INCREMENT;
ALTER TABLE welcome_messages_entry MODIFY COLUMN id int8 NOT NULL AUTO_INCREMENT;
ALTER TABLE ldap_connection MODIFY COLUMN id int8 NOT NULL AUTO_INCREMENT;
ALTER TABLE ldap_pattern MODIFY COLUMN id int8 NOT NULL AUTO_INCREMENT;
ALTER TABLE contact_provider MODIFY COLUMN id int8 NOT NULL AUTO_INCREMENT;

-- LinShare version
INSERT INTO version (version) VALUES ('1.10.0');

COMMIT;
SET AUTOCOMMIT=1;
