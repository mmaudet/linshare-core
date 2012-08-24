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
package org.linagora.linshare.core.domain.vo;

import java.util.Calendar;

public class ShareDocumentVo extends DocumentVo {

	private static final long serialVersionUID = 5229069693361770420L;

	/** the document's owner */
	private final UserVo sender;
	
	/** the recipient of the document */
	private final UserVo receiver;
	
	/** the expiration date of the share*/
	private final Calendar shareExpirationDate;
	
	/** the date of the share*/
	private final Calendar sharingDate;
	
	/** is the document has been downloaded */
	private final Boolean downloaded;
	
	
	
	
	public ShareDocumentVo(String identifier, String name, String fileComment, Calendar creationDate, Calendar expirationDate, String type, String ownerLogin, Boolean encrypted, Boolean shared,
			Long size, UserVo sender, UserVo receiver, Calendar shareExpirationDate, Calendar sharingDate, Boolean downloaded) {
		super(identifier, name, fileComment, creationDate, expirationDate, type, ownerLogin, encrypted, shared, size);
		this.sender = sender;
		this.receiver = receiver;
		this.shareExpirationDate = shareExpirationDate;
		this.sharingDate = sharingDate;
		this.downloaded = downloaded;
	}
	

//	public ShareDocumentVo(String identifier, String name, String fileComment,
//			Calendar creationDate, Calendar expirationDate, String type,
//			String ownerLogin, Boolean encrypted, Boolean shared, 
//			Long size, UserVo sender, UserVo receiver,  Calendar shareExpirationDate,
//			Boolean downloaded, String comment, Calendar sharingDate, long persistenceId) {
//		super(identifier, name, fileComment, creationDate, expirationDate, type, ownerLogin,
//				encrypted, shared, size);
//		
//		this.sender = sender; 
//		this.receiver = receiver; 
//		this.shareExpirationDate = shareExpirationDate;
//		this.downloaded = downloaded;
//		this.comment = comment;
//		this.sharingDate = sharingDate;
//		this.persistenceId = persistenceId;
//	}
//	
	public ShareDocumentVo(DocumentVo doc, UserVo sender, UserVo receiver) {
		
		super(doc.getIdentifier(),doc.getFileName(),doc.getFileComment(),doc.getCreationDate(),doc.getExpirationDate(),doc.getType(), doc.getOwnerLogin(),
				doc.getEncrypted(),doc.getShared(),doc.getSize());
		
		this.sender = sender; 
		this.receiver = receiver; 
		this.shareExpirationDate = null;
		this.downloaded = null;
		this.sharingDate = null;
	}

	public UserVo getSender() {
		return sender;
	}

	public UserVo getReceiver() {
		return receiver;
	}

	public Calendar getShareExpirationDate() {
		return shareExpirationDate;
	}

	public Boolean getDownloaded() {
		return downloaded;
	}

	public Calendar getSharingDate() {
		return sharingDate;
	}

	@Override
	public int compareTo(Object arg0) { //DESC order
		return -this.sharingDate.compareTo(((ShareDocumentVo)arg0).sharingDate);
	}

	@Override
	public String toString() {
		return "ShareDoc:" + this.sender + ":" + this.getFileName() + ":" + receiver; 
	}
}