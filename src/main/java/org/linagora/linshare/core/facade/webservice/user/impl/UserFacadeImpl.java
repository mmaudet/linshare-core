/*
 * LinShare is an open source filesharing software, part of the LinPKI software
 * suite, developed by Linagora.
 * 
 * Copyright (C) 2013 LINAGORA
 * 
 * This program is free software: you can redistribute it and/or modify it under
 * the terms of the GNU Affero General Public License as published by the Free
 * Software Foundation, either version 3 of the License, or (at your option) any
 * later version, provided you comply with the Additional Terms applicable for
 * LinShare software by Linagora pursuant to Section 7 of the GNU Affero General
 * Public License, subsections (b), (c), and (e), pursuant to which you must
 * notably (i) retain the display of the “LinShare™” trademark/logo at the top
 * of the interface window, the display of the “You are using the Open Source
 * and free version of LinShare™, powered by Linagora © 2009–2013. Contribute to
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
package org.linagora.linshare.core.facade.webservice.user.impl;

import java.util.ArrayList;
import java.util.List;

import org.linagora.linshare.core.domain.entities.Functionality;
import org.linagora.linshare.core.domain.entities.User;
import org.linagora.linshare.core.exception.BusinessErrorCode;
import org.linagora.linshare.core.exception.BusinessException;
import org.linagora.linshare.core.facade.webservice.user.UserFacade;
import org.linagora.linshare.core.service.AccountService;
import org.linagora.linshare.core.service.FunctionalityService;
import org.linagora.linshare.core.service.UserService;
import org.linagora.linshare.webservice.dto.UserDto;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class UserFacadeImpl extends GenericFacadeImpl
		implements UserFacade {

	private static final Logger logger = LoggerFactory
			.getLogger(UserFacadeImpl.class);

	private final UserService userService;

	private final FunctionalityService functionalityService;

	public UserFacadeImpl(final UserService userService,
			final AccountService accountService,
			FunctionalityService functionalityService) {
		super(accountService);
		this.userService = userService;
		this.functionalityService = functionalityService;
	}

	@Override
	public User checkAuthentication() throws BusinessException {
		User user = super.checkAuthentication();
		Functionality functionality = functionalityService
				.getUserTabFunctionality(user.getDomain());
		if (!functionality.getActivationPolicy().getStatus()) {
			throw new BusinessException(
					BusinessErrorCode.WEBSERVICE_UNAUTHORIZED,
					"You are not authorized to use this service");
		}
		return user;
	}

	@Override
	public List<UserDto> getUsers() throws BusinessException {
		User actor = getAuthentication();
		List<UserDto> res = new ArrayList<UserDto>();
		// we return all users without any filters
		List<User> users = userService
				.searchUser(null, null, null, null, actor);

		for (User user : users) {
			res.add(new UserDto(user));
		}
		logger.debug("user found : " + res.size());
		return res;
	}
}