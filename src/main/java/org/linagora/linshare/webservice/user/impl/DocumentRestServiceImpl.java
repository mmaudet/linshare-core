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

import java.io.File;
import java.io.InputStream;
import java.util.List;

import javax.ws.rs.Consumes;
import javax.ws.rs.DELETE;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.CacheControl;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.Response.ResponseBuilder;

import org.apache.commons.httpclient.HttpStatus;
import org.apache.cxf.jaxrs.ext.multipart.Multipart;
import org.apache.cxf.jaxrs.ext.multipart.MultipartBody;
import org.linagora.linshare.core.exception.BusinessException;
import org.linagora.linshare.core.facade.webservice.common.dto.DocumentAttachement;
import org.linagora.linshare.core.facade.webservice.common.dto.MimeTypeDto;
import org.linagora.linshare.core.facade.webservice.common.dto.SimpleLongValue;
import org.linagora.linshare.core.facade.webservice.user.DocumentFacade;
import org.linagora.linshare.core.facade.webservice.user.dto.DocumentDto;
import org.linagora.linshare.webservice.WebserviceBase;
import org.linagora.linshare.webservice.user.DocumentRestService;
import org.linagora.linshare.webservice.utils.DocumentStreamReponseBuilder;

@Path("/documents")
public class DocumentRestServiceImpl extends WebserviceBase implements DocumentRestService {

	private final DocumentFacade webServiceDocumentFacade;

	public DocumentRestServiceImpl(final DocumentFacade webServiceDocumentFacade) {
		this.webServiceDocumentFacade = webServiceDocumentFacade;
	}

	@Path("/{uuid}/download")
	@GET
	@Override
	public Response getDocumentStream(@PathParam("uuid") String uuid) throws BusinessException {
		DocumentDto documentDto = webServiceDocumentFacade.find(uuid, false);
		InputStream documentStream = webServiceDocumentFacade.getDocumentStream(uuid);
		ResponseBuilder response = DocumentStreamReponseBuilder.getDocumentResponseBuilder(documentStream, documentDto.getName(),
				documentDto.getType(), documentDto.getSize());
		return response.build();
	}

	@Path("/{uuid}/thumbnail")
	@GET
	@Override
	public Response getThumbnailStream(@PathParam("uuid") String docUuid) throws BusinessException {
		DocumentDto documentDto = webServiceDocumentFacade.find(docUuid, false);
		InputStream documentStream = webServiceDocumentFacade.getThumbnailStream(docUuid);
		ResponseBuilder response = DocumentStreamReponseBuilder.getDocumentResponseBuilder(documentStream, documentDto.getName() + "_thumb.png",
				"image/png");
		return response.build();
	}

	/**
	 * get the files of the user
	 * 
	 * @throws BusinessException
	 */
	@Path("/")
	@GET
	@Produces({ MediaType.APPLICATION_XML, MediaType.APPLICATION_JSON })
	@Override
	public List<DocumentDto> getDocuments() throws BusinessException {
		return webServiceDocumentFacade.findAll();
	}

	/**
	 * upload a file in user's space. send file inside a form
	 */
	@POST
	@Path("/")
	@Consumes(MediaType.MULTIPART_FORM_DATA)
	@Produces({ MediaType.APPLICATION_XML, MediaType.APPLICATION_JSON })
	@Override
	public DocumentDto uploadfile(@Multipart(value = "file") InputStream file,
			@Multipart(value = "description", required = false) String description,
			@Multipart(value = "filename", required = false) String givenFileName, MultipartBody body) throws BusinessException {
		String comment = (description == null) ? "" : description;
		if (file == null) {
			throw giveRestException(HttpStatus.SC_BAD_REQUEST, "Missing file (check parameter file)");
		}
		String fileName = getFileName(givenFileName, body);
		File tempFile = getTempFile(file, "rest-user", fileName);
		try {
			return webServiceDocumentFacade.create(tempFile, fileName, comment, null);
		} finally {
			deleteTempFile(tempFile);
		}
	}

	/**
	 * here we use XOP method for large file upload
	 * 
	 * @param doca
	 */
	@POST
	@Path("/xop")
	@Consumes(MediaType.MULTIPART_FORM_DATA)
	@Produces({ MediaType.APPLICATION_XML, MediaType.APPLICATION_JSON })
	@Override
	public DocumentDto addDocumentXop(DocumentAttachement doca) throws BusinessException {
		return webServiceDocumentFacade.addDocumentXop(doca);
	}

	@GET
	@Path("/userMaxFileSize")
	@Produces({ MediaType.APPLICATION_XML, MediaType.APPLICATION_JSON })
	@Override
	public Response getUserMaxFileSize() throws BusinessException {
		SimpleLongValue value = new SimpleLongValue(webServiceDocumentFacade.getUserMaxFileSize());
		return toResponseWithoutCache(value);
	}

	@GET
	@Path("/availableSize")
	@Produces({ MediaType.APPLICATION_XML, MediaType.APPLICATION_JSON })
	@Override
	public Response getAvailableSize() throws BusinessException {
		SimpleLongValue value = new SimpleLongValue(webServiceDocumentFacade.getAvailableSize());
		return toResponseWithoutCache(value);
	}

	@GET
	@Path("/userAvailableSize")
	@Produces({ MediaType.APPLICATION_XML, MediaType.APPLICATION_JSON })
	@Override
	public Response getUserAvailableSize() throws BusinessException {
		SimpleLongValue value = new SimpleLongValue(Math.min(
				webServiceDocumentFacade.getUserMaxFileSize(),
				webServiceDocumentFacade.getAvailableSize()));
		return toResponseWithoutCache(value);
	}

	private Response toResponseWithoutCache(SimpleLongValue value) {
		// All methods calling this one are used by Tapestry (Front User)
		// through Firefox or IE browsers ... IE  browers do caching for every text or json data
		// where there is no cache headers. To avoid cache issue we disable it.
		CacheControl cc = new CacheControl();
		cc.setNoCache(true);
		ResponseBuilder builder = Response.ok(value);
		builder.cacheControl(cc);
		return builder.build();
	}

	@DELETE
	@Path("/{uuid}")
	@Produces({ MediaType.APPLICATION_XML, MediaType.APPLICATION_JSON })
	@Override
	public DocumentDto delete(@PathParam("uuid") String uuid) throws BusinessException {
		return webServiceDocumentFacade.delete(uuid);
	}

	@GET
	@Path("/mimetypes")
	@Produces({ MediaType.APPLICATION_XML, MediaType.APPLICATION_JSON })
	@Override
	public List<MimeTypeDto> getMimeTypes() throws BusinessException {
		return webServiceDocumentFacade.getMimeTypes();
	}

	@GET
	@Path("/mimetypestatus")
	@Produces({ MediaType.APPLICATION_XML, MediaType.APPLICATION_JSON })
	@Override
	public Boolean getMimeTypeStatus() throws BusinessException {
		return webServiceDocumentFacade.isEnableMimeTypes();
	}

}
