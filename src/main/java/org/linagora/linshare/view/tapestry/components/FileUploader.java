/*
 *    This file is part of Linshare.
 *
 *   Linshare is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU Affero General Public License as
 *   published by the Free Software Foundation, either version 3 of
 *   the License, or (at your option) any later version.
 *
 *   Linshare is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU Affero General Public License for more details.
 *
 *   You should have received a copy of the GNU Affero General Public
 *   License along with Foobar.  If not, see
 *                                    <http://www.gnu.org/licenses/>.
 *
 *   (c) 2008 Groupe Linagora - http://linagora.org
 *
*/
package org.linagora.linshare.view.tapestry.components;


import java.io.IOException;
import java.io.InputStream;

import org.apache.tapestry5.ComponentResources;
import org.apache.tapestry5.annotations.AfterRender;
import org.apache.tapestry5.annotations.OnEvent;
import org.apache.tapestry5.annotations.Parameter;
import org.apache.tapestry5.annotations.Property;
import org.apache.tapestry5.annotations.SessionState;
import org.apache.tapestry5.annotations.SetupRender;
import org.apache.tapestry5.annotations.SupportsInformalParameters;
import org.apache.tapestry5.ioc.Messages;
import org.apache.tapestry5.ioc.annotations.Inject;
import org.apache.tapestry5.upload.services.UploadedFile;
import org.linagora.linshare.core.Facade.AbstractDomainFacade;
import org.linagora.linshare.core.Facade.DocumentFacade;
import org.linagora.linshare.core.domain.vo.DocumentVo;
import org.linagora.linshare.core.domain.vo.UserVo;
import org.linagora.linshare.core.exception.BusinessException;
import org.linagora.linshare.core.utils.FileUtils;
import org.linagora.linshare.view.tapestry.enums.BusinessUserMessageType;
import org.linagora.linshare.view.tapestry.objects.BusinessUserMessage;
import org.linagora.linshare.view.tapestry.objects.MessageSeverity;
import org.linagora.linshare.view.tapestry.services.BusinessMessagesManagementService;
import org.slf4j.Logger;



/**
 * Component used to display the multiple uploader
 * This component my throw two exceptions, fatal, that are to be catched :
 * - FileUploadBase.FileSizeLimitExceededException : if a file is too large
 * - FileUploadBase.SizeLimitExceededException : if the total upload is too large
 * @author ncharles
 *
 */
@SupportsInformalParameters
public class FileUploader {

    private static final long DEFAULT_MAX_FILE_SIZE = 52428800;

	/* ***********************************************************
     *                         Parameters
     ************************************************************ */
    @Parameter(required=false)
    @Property(write=false)
    private String divId;

    @Parameter(required=false, value="true")
    @Property(write=false)
    private String showSendButton;

    /* ***********************************************************
     *                      Injected services
     ************************************************************ */
	
	@Inject
	private DocumentFacade documentFacade;
	
    @Inject
    private BusinessMessagesManagementService messagesManagementService;

	@Inject
	private AbstractDomainFacade domainFacade;

    @Inject
    private BusinessMessagesManagementService businessMessagesManagementService;

    @Inject
    private Logger logger;

    @Inject
    private ComponentResources componentResources;
    
	@Inject
	private Messages messages;

	/* ***********************************************************
     *                Properties & injected symbol, ASO, etc
     ************************************************************ */
	
	@SessionState
	private UserVo userDetails;

    /* ***********************************************************
     *                   Event handlers&processing
     ************************************************************ */
	
	@SetupRender
	void setupRender() {
	}
	
    @AfterRender
    public void afterRender() {
    }



	/**
	 * Prior to validating the form, we need to initialise all the arrays
	 */
	public void onPrepare() {
	}
	  
    @OnEvent(value = "fileUploaded")
    public void processFilesUploaded(Object[] context) {
    	boolean toUpdate=false;

        for (int i = 0; i < context.length; i++) {
            UploadedFile uploadedFile = (UploadedFile) context[i];
            if (uploadedFile != null) {
            	if (uploadedFile.getSize() > getMaxFileSize()) {
            		messagesManagementService.notify(new BusinessUserMessage(BusinessUserMessageType.UPLOAD_WITH_FILE_TOO_LARGE,
                            MessageSeverity.ERROR, 
                            uploadedFile.getFileName(), 
                            FileUtils.getFriendlySize(uploadedFile.getSize(),messages),
                            FileUtils.getFriendlySize(getMaxFileSize(),messages)));
            		continue;
            	}
            	if (uploadedFile.getSize() > getUserFreeSpace()) {
            		messagesManagementService.notify(new BusinessUserMessage(BusinessUserMessageType.UPLOAD_NOT_ENOUGH_SPACE,
                            MessageSeverity.ERROR, 
                            uploadedFile.getFileName(), 
                            FileUtils.getFriendlySize(uploadedFile.getSize(),messages),
                            FileUtils.getFriendlySize(getUserFreeSpace(),messages)));
            		continue;
            	}

//                String mimeType;
//                try {
//                    mimeType = documentFacade.getMimeType(uploadedFile.getStream(), uploadedFile.getFilePath());
//                    if (null == mimeType) {
//                        mimeType = uploadedFile.getContentType();
//                    }
//                } catch (BusinessException e) {
//                    mimeType = uploadedFile.getContentType();
//                }

                try {
                    DocumentVo document = documentFacade.insertFile(uploadedFile.getStream(), uploadedFile.getSize(),
                        uploadedFile.getFileName(), userDetails);
                    messagesManagementService.notify(new BusinessUserMessage(BusinessUserMessageType.UPLOAD_OK,
                        MessageSeverity.INFO, uploadedFile.getFileName()));

                    // Notify the add of a file.
                    Object[] addedFile = {document};
                    componentResources.triggerEvent("fileAdded", addedFile, null);
                    toUpdate=true;
                } catch (BusinessException e) {
                    messagesManagementService.notify(e);
                }
            }
        }
        if (toUpdate) 
        	componentResources.triggerEvent("resetListFiles", null, null);
    }
	
    /* ***********************************************************
     *                   Helpers
     ************************************************************ */
	
    public long getUserFreeSpace() {
    	long res = 0;
        try {
			res = documentFacade.getUserAvailableQuota(userDetails);
		} catch (BusinessException e) {
			messagesManagementService.notify(e);
		}
		return res;
    }

    public long getMaxFileSize() {
        long maxFileSize = DEFAULT_MAX_FILE_SIZE;
        try {
            maxFileSize = documentFacade.getUserMaxFileSize(userDetails);
        } catch (BusinessException e) {
            // value has not been defined. We use the default value.
        }
        return maxFileSize;
    }

    private void readFileStream(UploadedFile file) {
        try {
            // read the complete stream.
            InputStream stream = file.getStream();
            while (stream.read() != -1); // NOPMD by matthieu on 24/02/10 10:19
        } catch (IOException ex) {
            logger.error(ex.toString());
        }
    }
}