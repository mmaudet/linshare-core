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
package org.linagora.linshare.core.service.impl;

import java.util.Calendar;
import java.util.List;

import org.linagora.linshare.core.business.service.DomainBusinessService;
import org.linagora.linshare.core.domain.entities.LogEntry;
import org.linagora.linshare.core.domain.entities.User;
import org.linagora.linshare.core.exception.BusinessException;
import org.linagora.linshare.core.repository.LogEntryRepository;
import org.linagora.linshare.core.service.LogEntryService;
import org.linagora.linshare.view.tapestry.beans.LogCriteriaBean;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.google.common.collect.Lists;

public class LogEntryServiceImpl implements LogEntryService {

	final static Logger logger = LoggerFactory.getLogger(LogEntryService.class);

	private final LogEntryRepository logEntryRepository;

	private final DomainBusinessService domainBusinessService;

	public LogEntryServiceImpl(final LogEntryRepository logEntryRepository,
			final DomainBusinessService domainBusinessService) {
		super();
		this.logEntryRepository = logEntryRepository;
		this.domainBusinessService = domainBusinessService;
	}

	@Override
	public LogEntry create(int level, LogEntry entity)
			throws IllegalArgumentException, BusinessException {
		if (entity == null) {
			throw new IllegalArgumentException("Entity must not be null");
		}
		// Logger trace
		if (level == INFO) {
			logger.info(entity.toString());
		} else if (level == WARN) {
			logger.warn(entity.toString());
		} else if (level == ERROR) {
			logger.error(entity.toString());
		} else {
			throw new IllegalArgumentException(
					"Unknown log level, is neither INFO, WARN nor ERROR");
		}
		// Database trace
		return logEntryRepository.create(entity);
	}

	@Override
	public LogEntry create(LogEntry entity) throws IllegalArgumentException,
			BusinessException {
		return create(INFO, entity);
	}

	@Override
	public List<LogEntry> findByCriteria(User actor, LogCriteriaBean criteria) {
		List<LogEntry> list = Lists.newArrayList();
		List<String> allMyDomainIdentifiers = domainBusinessService
				.getAllMyDomainIdentifiers(actor.getDomain());
		for (String domain : allMyDomainIdentifiers) {
			list.addAll(logEntryRepository.findByCriteria(criteria, domain));
		}
		return list;
	}

	@Override
	public List<LogEntry> findByUser(String mail) {
		return logEntryRepository.findByUser(mail);
	}

	@Override
	public List<LogEntry> findByDate(String mail, Calendar begin, Calendar end) {
		return logEntryRepository.findByDate(mail, begin, end);
	}

	@Override
	public void updateEmailLogEntry(String currentEmail, String newEmail) {
		logEntryRepository.updateMail(currentEmail, newEmail);
	}
}
