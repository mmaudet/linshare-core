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
package org.linagora.linshare.webservice.user.impl;

import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

import javax.ws.rs.Consumes;
import javax.ws.rs.DefaultValue;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.Response.ResponseBuilder;

import org.linagora.linshare.core.exception.BusinessException;
import org.linagora.linshare.core.facade.webservice.common.dto.ShareDto;
import org.linagora.linshare.core.facade.webservice.user.ShareFacade;
import org.linagora.linshare.webservice.WebserviceBase;
import org.linagora.linshare.webservice.user.ShareRestService;
import org.linagora.linshare.webservice.utils.DocumentStreamReponseBuilder;

public class ShareRestServiceImpl extends WebserviceBase implements
		ShareRestService {

	private final ShareFacade webServiceShareFacade;

	public ShareRestServiceImpl(final ShareFacade facade) {
		this.webServiceShareFacade = facade;
	}

	/**
	 * get the files of the user
	 */
	@Path("/")
	@GET
	@Produces({ MediaType.APPLICATION_XML, MediaType.APPLICATION_JSON })
	@Override
	public List<ShareDto> getReceivedShares() throws BusinessException {
		return webServiceShareFacade.getReceivedShares();
	}

	@GET
	@Path("/sharedocument/{targetMail}/{uuid}")
	@Override
	public void sharedocument(@PathParam("targetMail") String targetMail,
			@PathParam("uuid") String uuid,
			@DefaultValue("0") @QueryParam("securedShare") int securedShare)
			throws BusinessException {
		webServiceShareFacade.sharedocument(targetMail, uuid, securedShare);
	}

	@POST
	@Path("/multiplesharedocuments")
	@Consumes(MediaType.APPLICATION_JSON)
	@Override
	public void multiplesharedocuments(ArrayList<ShareDto> shares,
			@QueryParam("secured") boolean secured,
			@QueryParam("message") String message) throws BusinessException {
		webServiceShareFacade.multiplesharedocuments(shares, secured, message);
	}

	@Path("/{uuid}/download")
	@GET
	@Override
	public Response getDocumentStream(@PathParam("uuid") String shareUuid)
			throws BusinessException {
		ShareDto shareDto = webServiceShareFacade.getReceivedShare(shareUuid);
		InputStream documentStream = webServiceShareFacade
				.getDocumentStream(shareUuid);
		ResponseBuilder response = DocumentStreamReponseBuilder
				.getDocumentResponseBuilder(documentStream, shareDto.getName(),
						shareDto.getType(), shareDto.getSize());
		return response.build();
	}

	@Path("/{uuid}/thumbnail")
	@GET
	@Override
	public Response getThumbnailStream(@PathParam("uuid") String shareUuid)
			throws BusinessException {
		InputStream documentStream = webServiceShareFacade
				.getThumbnailStream(shareUuid);
		ResponseBuilder response = DocumentStreamReponseBuilder
				.getThumbnailResponseBuilder(documentStream, null, false);
		return response.build();
	}
}
