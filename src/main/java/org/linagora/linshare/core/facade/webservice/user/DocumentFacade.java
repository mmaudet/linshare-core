/*
 * LinShare is an open source filesharing software, part of the LinPKI software
 * suite, developed by Linagora.
 * 
 * Copyright (C) 2015 LINAGORA
 * 
 * This program is free software: you can redistribute it and/or modify it under
 * the terms of the GNU Affero General Public License as published by the Free
 * Software Foundation, either version 3 of the License, or (at your option) any
 * later version, provided you comply with the Additional Terms applicable for
 * LinShare software by Linagora pursuant to Section 7 of the GNU Affero General
 * Public License, subsections (b), (c), and (e), pursuant to which you must
 * notably (i) retain the display of the “LinShare™” trademark/logo at the top
 * of the interface window, the display of the “You are using the Open Source
 * and free version of LinShare™, powered by Linagora © 2009–2015. Contribute to
 * Linshare R&D by subscribing to an Enterprise offer!” infobox and in the
 * e-mails sent with the Program, (ii) retain all hypertext links between
 * LinShare and linshare.org, between linagora.com and Linagora, and (iii)
 * refrain from infringing Linagora intellectual property rights over its
 * trademarks and commercial brands. Other Additional Terms apply, see
 * <http://www.linagora.com/licenses/> for more details.
 * 
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more
 * details.
 * 
 * You should have received a copy of the GNU Affero General Public License and
 * its applicable Additional Terms for LinShare along with this program. If not,
 * see <http://www.gnu.org/licenses/> for the GNU Affero General Public License
 * version 3 and <http://www.linagora.com/licenses/> for the Additional Terms
 * applicable to LinShare software.
 */
package org.linagora.linshare.core.facade.webservice.user;

import java.io.File;
import java.io.InputStream;
import java.util.List;

import org.linagora.linshare.core.exception.BusinessException;
import org.linagora.linshare.core.facade.webservice.common.dto.DocumentAttachement;
import org.linagora.linshare.core.facade.webservice.common.dto.MimeTypeDto;
import org.linagora.linshare.core.facade.webservice.user.dto.DocumentDto;

public interface DocumentFacade extends GenericFacade {

	List<DocumentDto> findAll() throws BusinessException;

	DocumentDto find(String uuid, boolean withShares) throws BusinessException;

	DocumentDto addDocumentXop(DocumentAttachement doca)
			throws BusinessException;

	Long getUserMaxFileSize() throws BusinessException;

	Long getAvailableSize() throws BusinessException;

	DocumentDto create(File tempFile, String fileName,
			String description, String metadata) throws BusinessException;

	DocumentDto createWithSignature(File tempFile, String fileName,
			String description, InputStream signatureFile, String signatureFileName, InputStream x509certificate) throws BusinessException;

	InputStream getDocumentStream(String docEntryUuid)
			throws BusinessException;

	InputStream getThumbnailStream(String docEntryUuid)
			throws BusinessException;

	DocumentDto delete(String uuid) throws BusinessException;

	Boolean isEnableMimeTypes() throws BusinessException;

	List<MimeTypeDto> getMimeTypes() throws BusinessException;

	DocumentDto update(String documentUuid, DocumentDto documentDto) throws BusinessException;

	DocumentDto updateFile(File file, String givenFileName,
			String documentUuid) throws BusinessException;

}
