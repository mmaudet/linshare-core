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
package org.linagora.linShare.view.tapestry.components;


import java.io.IOException;
import java.io.InputStream;

import org.apache.tapestry5.Asset;
import org.apache.tapestry5.ComponentResources;
import org.apache.tapestry5.annotations.AfterRender;
import org.apache.tapestry5.annotations.ApplicationState;
import org.apache.tapestry5.annotations.Component;
import org.apache.tapestry5.annotations.OnEvent;
import org.apache.tapestry5.annotations.Path;
import org.apache.tapestry5.annotations.Persist;
import org.apache.tapestry5.annotations.SetupRender;
import org.apache.tapestry5.annotations.SupportsInformalParameters;
import org.apache.tapestry5.ioc.Messages;
import org.apache.tapestry5.ioc.annotations.Inject;
import org.apache.tapestry5.upload.services.UploadedFile;
import org.linagora.linShare.core.Facade.DocumentFacade;
import org.linagora.linShare.core.Facade.ParameterFacade;
import org.linagora.linShare.core.Facade.ShareFacade;
import org.linagora.linShare.core.domain.vo.DocumentVo;
import org.linagora.linShare.core.domain.vo.UserVo;
import org.linagora.linShare.core.exception.BusinessException;
import org.linagora.linShare.core.exception.TechnicalErrorCode;
import org.linagora.linShare.core.exception.TechnicalException;
import org.linagora.linShare.core.utils.FileUtils;
import org.linagora.linShare.view.tapestry.enums.BusinessUserMessageType;
import org.linagora.linShare.view.tapestry.objects.BusinessUserMessage;
import org.linagora.linShare.view.tapestry.objects.MessageSeverity;
import org.linagora.linShare.view.tapestry.services.BusinessMessagesManagementService;
import org.linagora.linShare.view.tapestry.services.Templating;
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
public class FileUpdateUploader {

    private static final long DEFAULT_MAX_FILE_SIZE = 52428800;

	/* ***********************************************************
     *                         Parameters
     ************************************************************ */

    /* ***********************************************************
     *                      Injected services
     ************************************************************ */
	
	@Inject
	private DocumentFacade documentFacade;
	
	@Inject
	private ShareFacade shareFacade;
	
	@Inject
	private Templating templating;
	
    @Inject
    private BusinessMessagesManagementService messagesManagementService;
    
    @Inject
    private ParameterFacade parameterFacade;

    @Inject
    private BusinessMessagesManagementService businessMessagesManagementService;

    @Inject
    private Logger logger;

    @Inject
    private ComponentResources componentResources;
    
    @Inject
    private Messages messages;
    
    
	@SuppressWarnings("unused")
	@Component(parameters = {"style=bluelighting", "show=false","width=600", "height=250"})
	private WindowWithEffects windowUpdateDocUpload;
	
	
	@Inject
	@Path("context:templates/updatedoc-shared-message.html")
	private Asset updateDocSharedTemplateHtml;
	
	@Inject
	@Path("context:templates/updatedoc-shared-message.txt")
	private Asset updateDocSharedTemplateTxt;
    
	
	
	/* ***********************************************************
     *                Properties & injected symbol, ASO, etc
     ************************************************************ */
	
	@ApplicationState
	private UserVo userDetails;

	@Persist
	private String uuidDocToUpdate;
	
	
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
            
            if (uploadedFile != null && i<1) { //limit to one file (for update)

                String mimeType;
                try {
                    mimeType = documentFacade.getMimeType(uploadedFile.getStream(), uploadedFile.getFilePath());
                    if (null == mimeType) {
                        mimeType = uploadedFile.getContentType();
                    }
                } catch (BusinessException e) {
                    mimeType = uploadedFile.getContentType();
                }

                try {
                    
                	DocumentVo initialdocument = documentFacade.getDocument(userDetails.getLogin(), uuidDocToUpdate);
                	
                    DocumentVo document  =  documentFacade.updateDocumentContent(uuidDocToUpdate, uploadedFile.getStream(), uploadedFile.getSize(),
                            uploadedFile.getFileName(), mimeType, userDetails);
                    
                    messagesManagementService.notify(new BusinessUserMessage(BusinessUserMessageType.UPLOAD_UPDATE_FILE_CONTENT_OK,
                        MessageSeverity.INFO, initialdocument.getFileName(),uploadedFile.getFileName()));

                    if(initialdocument.getShared()){
                    	String updateDocSharedTemplateHtmlContent = templating.readFullyTemplateContent(updateDocSharedTemplateHtml.getResource().openStream());
                    	String updateDocSharedTemplateTxtContent = templating.readFullyTemplateContent(updateDocSharedTemplateTxt.getResource().openStream());
                    	String filesizeTxt = FileUtils.getFriendlySize(document.getSize(), messages);
                    	//send email file has been replaced ....
                    	shareFacade.sendSharedUpdateDocNotification(document, userDetails, filesizeTxt, initialdocument.getFileName(), messages.get("mail.user.all.updatedoc.subject"), updateDocSharedTemplateHtmlContent, updateDocSharedTemplateTxtContent);
                    }
                    
                    
                    // Notify the add of a file.
                    Object[] addedFile = {document};
                    componentResources.triggerEvent("fileAdded", addedFile, null);
                    toUpdate=true;
                } catch (BusinessException e) {
                    messagesManagementService.notify(e);
                    readFileStream(uploadedFile);
                } catch (IOException e) {
                    readFileStream(uploadedFile);
        			throw new TechnicalException(TechnicalErrorCode.MAIL_EXCEPTION,"Bad template",e);
				}
            } else {
            	
            	if (uploadedFile!=null) readFileStream(uploadedFile);
            }
        }
        if (toUpdate) 
        	componentResources.triggerEvent("resetListFiles", null, null);
    }
	
    /* ***********************************************************
     *                   Helpers
     ************************************************************ */
	
    public long getUserFreeSpace() {
        return documentFacade.getUserAvailableQuota(userDetails);
    }

	public void setUuidDocToUpdate(String uuidDocToUpdate) {
		this.uuidDocToUpdate = uuidDocToUpdate;
	}

	public long getMaxFileSize() {
        long maxFileSize = DEFAULT_MAX_FILE_SIZE;
        try {
            maxFileSize = parameterFacade.loadConfig().getFileSizeMax();
        } catch (BusinessException e) {
            // value has not been defined. We use the default value.
        }
        return maxFileSize;
    }
    
    
    

    @SuppressWarnings("empty-statement")
    private void readFileStream(UploadedFile file) {
        try {
            // read the complete stream.
            InputStream stream = file.getStream();
            while (stream.read() != -1);
        } catch (IOException ex) {
            logger.error(ex.toString());
        }
    }
}
