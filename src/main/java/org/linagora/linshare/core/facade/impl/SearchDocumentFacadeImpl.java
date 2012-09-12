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
package org.linagora.linshare.core.facade.impl;

import java.util.ArrayList;
import java.util.List;

import org.linagora.linshare.core.domain.entities.DocumentEntry;
import org.linagora.linshare.core.domain.entities.User;
import org.linagora.linshare.core.domain.transformers.impl.DocumentEntryTransformer;
import org.linagora.linshare.core.domain.vo.DocumentVo;
import org.linagora.linshare.core.domain.vo.SearchDocumentCriterion;
import org.linagora.linshare.core.domain.vo.ShareDocumentVo;
import org.linagora.linshare.core.domain.vo.UserVo;
import org.linagora.linshare.core.exception.BusinessException;
import org.linagora.linshare.core.facade.SearchDocumentFacade;
import org.linagora.linshare.core.service.AccountService;
import org.linagora.linshare.core.service.DocumentEntryService;
import org.linagora.linshare.core.service.SearchDocumentService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class SearchDocumentFacadeImpl implements SearchDocumentFacade{
	
	private static final Logger logger = LoggerFactory.getLogger(SearchDocumentFacadeImpl.class);
	

	private SearchDocumentService searchDocumentService;
	private DocumentEntryTransformer documentEntryTransformer;
	private AccountService accountService;
	private final DocumentEntryService documentEntryService;
	
	public SearchDocumentFacadeImpl(SearchDocumentService searchDocumentService, DocumentEntryTransformer documentEntryTransformer, AccountService accountService,
			DocumentEntryService documentEntryService){
		
		this.searchDocumentService = searchDocumentService;
		this.documentEntryTransformer = documentEntryTransformer;
		this.accountService = accountService;
		this.documentEntryService = documentEntryService;
	}
	
	public List<DocumentVo> retrieveDocument(UserVo userVo) {
		
		User user = (User) accountService.findByLsUid(userVo.getLsUid());
		ArrayList<DocumentVo> documents = new ArrayList<DocumentVo>();

		try {
			List<DocumentEntry> documentEntries = documentEntryService.findAllMyDocumentEntries(user, user);
			for (DocumentEntry entry : documentEntries) {
				documents.add(documentEntryTransformer.disassemble(entry));
			}
		} catch (BusinessException e) {
			logger.error("can't find my document entries");
			logger.debug(e.toString());
		}
		
//		// TODO : Fix documents list
//		Set<Entry> entries = user.getEntries();
//		for (Entry entry : entries) {
//			if(entry.getEntryType().equals(EntryType.DOCUMENT)) {
//				documents.add(documentEntryTransformer.disassemble((DocumentEntry) entry));
//			}
//		}
		
		return documents;
		
	}

	
	/*
	public List<DocumentVo> retrieveDocumentWithCriterion(
			SearchDocumentCriterion searchDocumentCriterion) {
		
		return documentTransformer.disassembleList(this.searchDocumentService.retrieveDocumentWithCriterion(searchDocumentCriterion));
	}

	/*
	public List<DocumentVo> retrieveDocumentBeginWithCriterion(
			SearchDocumentCriterion searchDocumentCriterion) {
		
		return documentTransformer.disassembleList(this.searchDocumentService.retrieveDocumentBeginWithCriterion(searchDocumentCriterion));
	}

	public List<DocumentVo> retrieveDocumentEndWithCriterion(
			SearchDocumentCriterion searchDocumentCriterion) {
		
		return documentTransformer.disassembleList(this.searchDocumentService.retrieveDocumentEndWithCriterion(searchDocumentCriterion));
	}
	*/
	public List<DocumentVo> retrieveDocumentContainsCriterion(SearchDocumentCriterion searchDocumentCriterion) {
		
		return this.searchDocumentService.retrieveDocumentContainsCriterion(searchDocumentCriterion);
	}

	public List<ShareDocumentVo> retrieveShareDocumentContainsCriterion(
			SearchDocumentCriterion searchDocumentCriterion) {
		return this.searchDocumentService.retrieveShareDocumentContainsCriterion(searchDocumentCriterion);
	}

}