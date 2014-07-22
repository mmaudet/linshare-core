/*
 * LinShare is an open source filesharing software, part of the LinPKI software
 * suite, developed by Linagora.
 * 
 * Copyright (C) 2014 LINAGORA
 * 
 * This program is free software: you can redistribute it and/or modify it under
 * the terms of the GNU Affero General Public License as published by the Free
 * Software Foundation, either version 3 of the License, or (at your option) any
 * later version, provided you comply with the Additional Terms applicable for
 * LinShare software by Linagora pursuant to Section 7 of the GNU Affero General
 * Public License, subsections (b), (c), and (e), pursuant to which you must
 * notably (i) retain the display of the “LinShare™” trademark/logo at the top
 * of the interface window, the display of the “You are using the Open Source
 * and free version of LinShare™, powered by Linagora © 2009–2014. Contribute to
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
package org.linagora.linshare.core.facade.impl;

import java.io.InputStream;
import java.util.Date;
import java.util.List;

import org.apache.commons.lang.time.DateUtils;
import org.apache.tapestry5.beaneditor.BeanModel;
import org.linagora.linshare.core.domain.constants.Language;
import org.linagora.linshare.core.domain.constants.UploadRequestStatus;
import org.linagora.linshare.core.domain.entities.AbstractDomain;
import org.linagora.linshare.core.domain.entities.Contact;
import org.linagora.linshare.core.domain.entities.Functionality;
import org.linagora.linshare.core.domain.entities.IntegerValueFunctionality;
import org.linagora.linshare.core.domain.entities.StringValueFunctionality;
import org.linagora.linshare.core.domain.entities.UploadRequest;
import org.linagora.linshare.core.domain.entities.UploadRequestEntry;
import org.linagora.linshare.core.domain.entities.UploadRequestGroup;
import org.linagora.linshare.core.domain.entities.UploadRequestHistory;
import org.linagora.linshare.core.domain.entities.User;
import org.linagora.linshare.core.domain.objects.SizeUnitValueFunctionality;
import org.linagora.linshare.core.domain.objects.TimeUnitValueFunctionality;
import org.linagora.linshare.core.domain.vo.UploadRequestEntryVo;
import org.linagora.linshare.core.domain.vo.UploadRequestHistoryVo;
import org.linagora.linshare.core.domain.vo.UploadRequestVo;
import org.linagora.linshare.core.domain.vo.UserVo;
import org.linagora.linshare.core.exception.BusinessException;
import org.linagora.linshare.core.facade.UploadRequestFacade;
import org.linagora.linshare.core.service.AbstractDomainService;
import org.linagora.linshare.core.service.DocumentEntryService;
import org.linagora.linshare.core.service.FunctionalityReadOnlyService;
import org.linagora.linshare.core.service.UploadRequestService;
import org.linagora.linshare.core.service.UserService;

import com.google.common.collect.Lists;

public class UploadRequestFacadeImpl implements UploadRequestFacade {

	private final AbstractDomainService abstractDomainService;
	private final UserService userService;
	private final UploadRequestService uploadRequestService;
	private final DocumentEntryService documentEntryService;
	private final FunctionalityReadOnlyService functionalityReadOnlyService;

	public UploadRequestFacadeImpl(
			final AbstractDomainService abstractDomainService,
			final UserService userService,
			final UploadRequestService uploadRequestService,
			final DocumentEntryService documentEntryService,
			final FunctionalityReadOnlyService functionalityReadOnlyService) {
		this.abstractDomainService = abstractDomainService;
		this.userService = userService;
		this.uploadRequestService = uploadRequestService;
		this.documentEntryService = documentEntryService;
		this.functionalityReadOnlyService = functionalityReadOnlyService;
	}

	@Override
	public List<UploadRequestVo> findAllVisibles(UserVo actorVo)
			throws BusinessException {
		return findAll(actorVo, UploadRequestStatus.STATUS_CREATED,
				UploadRequestStatus.STATUS_ENABLED,
				UploadRequestStatus.STATUS_CLOSED);
	}

	@Override
	public List<UploadRequestVo> findAllNotDeleted(UserVo actorVo)
			throws BusinessException {
		return findAll(actorVo, UploadRequestStatus.STATUS_CREATED,
				UploadRequestStatus.STATUS_ENABLED,
				UploadRequestStatus.STATUS_CLOSED,
				UploadRequestStatus.STATUS_CANCELED,
				UploadRequestStatus.STATUS_ARCHIVED);
	}

	private List<UploadRequestVo> findAll(UserVo actorVo,
			UploadRequestStatus... include) throws BusinessException {
		User actor = userService.findByLsUuid(actorVo.getLsUuid());
		List<UploadRequestVo> ret = Lists.newArrayList();

		for (UploadRequest req : uploadRequestService.findAllRequest(actor)) {
			if (Lists.newArrayList(include).contains(req.getStatus())) {
				ret.add(new UploadRequestVo(req));
			}
		}
		return ret;
	}

	@Override
	public UploadRequestVo findRequestByUuid(UserVo actorVo, String uuid)
			throws BusinessException {
		User actor = userService.findByLsUuid(actorVo.getLsUuid());
		// TODO
		return new UploadRequestVo(uploadRequestService.findRequestByUuid(
				actor, uuid));
	}

	@Override
	public UploadRequestVo createRequest(UserVo actorVo, UploadRequestVo req)
			throws BusinessException {
		User actor = userService.findByLsUuid(actorVo.getLsUuid());
		UploadRequestGroup grp = new UploadRequestGroup(req);
		UploadRequest e = req.toEntity();

		// TODO functionalityFacade
		grp = uploadRequestService.createRequestGroup(actor, grp);

		e.setActivationDate(new Date()); // FIXME handle activationDate
		e.setNotificationDate(e.getExpiryDate()); // FIXME functionalityFacade
		e.setUploadRequestGroup(grp);
		e = uploadRequestService.createRequest(actor, e,
				new Contact(req.getRecipient()));

		/*
		 * FIXME handle activationDate FIXME handle status enabled
		 */
		e.updateStatus(UploadRequestStatus.STATUS_ENABLED);
		return new UploadRequestVo(uploadRequestService.updateRequest(actor, e));
	}

	@Override
	public UploadRequestVo updateRequest(UserVo actorVo, UploadRequestVo req)
			throws BusinessException {
		User actor = userService.findByLsUuid(actorVo.getLsUuid());
		UploadRequest e = uploadRequestService.findRequestByUuid(actor,
				req.getUuid());

		e.setMaxFileCount(req.getMaxFileCount());
		e.setMaxFileSize(req.getMaxFileSize());
		e.setMaxDepositSize(req.getMaxDepositSize());
		e.setActivationDate(req.getActivationDate());
		e.setExpiryDate(req.getExpiryDate());
		e.setLocale(req.getLocale().getTapestryLocale());
		return new UploadRequestVo(uploadRequestService.updateRequest(actor, e));
	}

	@Override
	public UploadRequestVo deleteRequest(UserVo actorVo, UploadRequestVo req)
			throws BusinessException {
		User actor = userService.findByLsUuid(actorVo.getLsUuid());
		UploadRequest e = uploadRequestService.findRequestByUuid(actor,
				req.getUuid());

		e.updateStatus(UploadRequestStatus.STATUS_DELETED);
		return new UploadRequestVo(uploadRequestService.updateRequest(actor, e));
	}

	@Override
	public UploadRequestVo closeRequest(UserVo actorVo, UploadRequestVo req)
			throws BusinessException {
		User actor = userService.findByLsUuid(actorVo.getLsUuid());
		UploadRequest e = uploadRequestService.findRequestByUuid(actor,
				req.getUuid());

		e.updateStatus(UploadRequestStatus.STATUS_CLOSED);
		return new UploadRequestVo(uploadRequestService.updateRequest(actor, e));
	}

	@Override
	public UploadRequestVo archiveRequest(UserVo actorVo, UploadRequestVo req)
			throws BusinessException {
		User actor = userService.findByLsUuid(actorVo.getLsUuid());

		UploadRequest e = uploadRequestService.findRequestByUuid(actor,
				req.getUuid());
		e.updateStatus(UploadRequestStatus.STATUS_ARCHIVED);
		return new UploadRequestVo(uploadRequestService.updateRequest(actor, e));
	}

	@Override
	public List<UploadRequestEntryVo> findAllEntries(UserVo actorVo,
			UploadRequestVo req) throws BusinessException {
		User actor = userService.findByLsUuid(actorVo.getLsUuid());
		UploadRequest e = uploadRequestService.findRequestByUuid(actor,
				req.getUuid());
		List<UploadRequestEntryVo> ret = Lists.newArrayList();

		for (UploadRequestEntry ent : e.getUploadRequestEntries()) {
			ret.add(new UploadRequestEntryVo(ent));
		}
		return ret;
	}

	@Override
	public List<UploadRequestHistoryVo> findHistory(UserVo actorVo,
			UploadRequestVo req) throws BusinessException {
		User actor = userService.findByLsUuid(actorVo.getLsUuid());
		List<UploadRequestHistoryVo> ret = Lists.newArrayList();

		for (UploadRequestHistory h : uploadRequestService
				.findAllRequestHistory(actor, req.getUuid())) {
			ret.add(new UploadRequestHistoryVo(h));
		}
		return ret;
	}

	@Override
	public InputStream getFileStream(UserVo actorVo, UploadRequestEntryVo entry)
			throws BusinessException {
		User actor = userService.findByLsUuid(actorVo.getLsUuid());

		return documentEntryService.getDocumentStream(actor, entry
				.getDocument().getIdentifier());
	}

	@Override
	public UploadRequestVo getDefaultValue(UserVo actorVo,
			BeanModel<UploadRequestVo> beanModel) throws BusinessException {
		AbstractDomain domain = abstractDomainService.findById(actorVo
				.getDomainIdentifier());
		UploadRequestVo ret = new UploadRequestVo();
		List<String> includes = Lists.newArrayList();

		includes.add("subject");
		includes.add("body");
		includes.add("recipient");

		TimeUnitValueFunctionality expiryDateFunc = functionalityReadOnlyService
				.getUploadRequestExpiryTimeFunctionality(domain);

		if (expiryDateFunc.getActivationPolicy().getStatus()) {
			if (expiryDateFunc.getDelegationPolicy() != null
					&& expiryDateFunc.getDelegationPolicy().getStatus()) {
				includes.add("expiryDate");
			}
			@SuppressWarnings("deprecation")
			Date expiryDate = DateUtils.add(new Date(),
					expiryDateFunc.toCalendarUnitValue(),
					expiryDateFunc.getValue());
			ret.setExpiryDate(expiryDate);
		}

		SizeUnitValueFunctionality maxDepositSizeFunc = functionalityReadOnlyService
				.getUploadRequestMaxDepositSizeFunctionality(domain);

		if (maxDepositSizeFunc.getActivationPolicy().getStatus()) {
			if (maxDepositSizeFunc.getDelegationPolicy() != null
					&& maxDepositSizeFunc.getDelegationPolicy().getStatus()) {
				includes.add("maxDepositSize");
			}
			long maxDepositSize = maxDepositSizeFunc.getValue().longValue();
			ret.setMaxDepositSize(maxDepositSize);
		}

		IntegerValueFunctionality maxFileCountFunc = functionalityReadOnlyService
				.getUploadRequestMaxFileCountFunctionality(domain);

		if (maxFileCountFunc.getActivationPolicy().getStatus()) {
			if (maxFileCountFunc.getDelegationPolicy() != null
					&& maxFileCountFunc.getDelegationPolicy().getStatus()) {
				includes.add("maxFileCount");
			}
			int maxFileCount = maxFileCountFunc.getValue().intValue();
			ret.setMaxFileCount(maxFileCount);
		}

		SizeUnitValueFunctionality maxFileSizeFunc = functionalityReadOnlyService
				.getUploadRequestMaxFileSizeFunctionality(domain);

		if (maxFileSizeFunc.getActivationPolicy().getStatus()) {
			if (maxFileSizeFunc.getDelegationPolicy() != null
					&& maxFileSizeFunc.getDelegationPolicy().getStatus()) {
				includes.add("maxFileSize");
			}
			long maxFileSize = maxFileSizeFunc.getValue().longValue();
			ret.setMaxFileSize(maxFileSize);
		}

		StringValueFunctionality notificationLangFunc = functionalityReadOnlyService
				.getUploadRequestNotificationLanguageFunctionality(domain);

		if (notificationLangFunc.getActivationPolicy().getStatus()) {
			if (notificationLangFunc.getDelegationPolicy() != null
					&& notificationLangFunc.getDelegationPolicy().getStatus()) {
				includes.add("locale");
			}
			Language locale = Language.fromTapestryLocale(notificationLangFunc
					.getValue());
			ret.setLocale(locale);
		}

		Functionality secureUrlFunc = functionalityReadOnlyService
				.getUploadRequestSecureUrlFunctionality(domain);

		if (secureUrlFunc.getActivationPolicy().getStatus()) {
			if (secureUrlFunc.getDelegationPolicy() != null
					&& secureUrlFunc.getDelegationPolicy().getStatus()) {
				includes.add("secured");
			}
			ret.setSecured(false);
		}

		includes.add("canDelete");
		includes.add("canClose");
		beanModel.include(includes.toArray(new String[includes.size()]));
		ret.setModel(beanModel);

		return ret;
	}

	@Override
	public BeanModel<UploadRequestVo> getEditModel(UserVo actorVo,
			BeanModel<UploadRequestVo> beanModel) throws BusinessException {
		AbstractDomain domain = abstractDomainService.findById(actorVo
				.getDomainIdentifier());
		List<String> includes = Lists.newArrayList();

		TimeUnitValueFunctionality expiryDateFunc = functionalityReadOnlyService
				.getUploadRequestExpiryTimeFunctionality(domain);

		if (expiryDateFunc.getActivationPolicy().getStatus()) {
			if (expiryDateFunc.getDelegationPolicy() != null
					&& expiryDateFunc.getDelegationPolicy().getStatus()) {
				includes.add("expiryDate");
			}
		}

		SizeUnitValueFunctionality maxDepositSizeFunc = functionalityReadOnlyService
				.getUploadRequestMaxDepositSizeFunctionality(domain);

		if (maxDepositSizeFunc.getActivationPolicy().getStatus()) {
			if (maxDepositSizeFunc.getDelegationPolicy() != null
					&& maxDepositSizeFunc.getDelegationPolicy().getStatus()) {
				includes.add("maxDepositSize");
			}
		}

		IntegerValueFunctionality maxFileCountFunc = functionalityReadOnlyService
				.getUploadRequestMaxFileCountFunctionality(domain);

		if (maxFileCountFunc.getActivationPolicy().getStatus()) {
			if (maxFileCountFunc.getDelegationPolicy() != null
					&& maxFileCountFunc.getDelegationPolicy().getStatus()) {
				includes.add("maxFileCount");
			}
		}

		SizeUnitValueFunctionality maxFileSizeFunc = functionalityReadOnlyService
				.getUploadRequestMaxFileSizeFunctionality(domain);

		if (maxFileSizeFunc.getActivationPolicy().getStatus()) {
			if (maxFileSizeFunc.getDelegationPolicy() != null
					&& maxFileSizeFunc.getDelegationPolicy().getStatus()) {
				includes.add("maxFileSize");
			}
		}

		StringValueFunctionality notificationLangFunc = functionalityReadOnlyService
				.getUploadRequestNotificationLanguageFunctionality(domain);

		if (notificationLangFunc.getActivationPolicy().getStatus()) {
			if (notificationLangFunc.getDelegationPolicy() != null
					&& notificationLangFunc.getDelegationPolicy().getStatus()) {
				includes.add("locale");
			}
		}

		beanModel.include(includes.toArray(new String[includes.size()]));
		return beanModel;
	}
}
