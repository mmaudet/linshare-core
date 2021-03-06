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
package org.linagora.linshare.webservice.user;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.ws.rs.Path;
import javax.ws.rs.core.Response;

import org.linagora.linshare.core.exception.BusinessException;
import org.linagora.linshare.core.facade.webservice.common.dto.ShareDto;

/**
 * Interface for the Share service REST jaxRS interface Allows for creation of a
 * sharing
 */

@Path("/shares")
public interface ShareRestService {

	/**
	 * Share a document with a user Returns are : -> HttpStatus.SC_UNAUTHORIZED
	 * if the user is not authentified -> HttpStatus.SC_FORBIDDEN if the user is
	 * a guest without upload right -> HttpStatus.SC_NOT_FOUND if either the
	 * document or the target user are not found -> HttpStatus.SC_METHOD_FAILURE
	 * if the sharing cannot be created (maybe not a proper return type) ->
	 * HttpStatus.SC_OK if the sharing is successful
	 * 
	 * @param targetMail
	 *            : the email of the target
	 * @param uuid
	 *            : the uuid of the document to be shared
	 * @throws IOException
	 *             : in case of failure
	 * 
	 */
	void multiplesharedocuments(ArrayList<ShareDto> shares, boolean secured, String message) throws BusinessException;

	void sharedocument(String targetMail, String uuid, int securedShare) throws BusinessException;

	List<ShareDto> getReceivedShares() throws BusinessException;

	Response getDocumentStream(String shareUuid) throws BusinessException;
	
	Response getThumbnailStream(String shareUuid) throws BusinessException;
}