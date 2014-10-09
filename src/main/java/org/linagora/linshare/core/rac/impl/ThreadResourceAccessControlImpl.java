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

package org.linagora.linshare.core.rac.impl;

import org.apache.commons.lang.Validate;
import org.linagora.linshare.core.domain.constants.AccountType;
import org.linagora.linshare.core.domain.constants.TechnicalAccountPermissionType;
import org.linagora.linshare.core.domain.entities.Account;
import org.linagora.linshare.core.domain.entities.Thread;
import org.linagora.linshare.core.domain.entities.User;
import org.linagora.linshare.core.rac.ThreadResourceAccessControl;
import org.linagora.linshare.core.repository.ThreadMemberRepository;

public class ThreadResourceAccessControlImpl extends
		AbstractResourceAccessControlImpl<Account, Account, Thread> implements
		ThreadResourceAccessControl {

	private final ThreadMemberRepository threadMemberRepository;

	public ThreadResourceAccessControlImpl(
			final ThreadMemberRepository threadMemberRepository) {
		super();
		this.threadMemberRepository = threadMemberRepository;
	}

	@Override
	protected boolean hasReadPermission(Account actor, Account owner,
			Thread entry, Object... opt) {
		Validate.notNull(actor);
		Validate.notNull(owner);
		Validate.notNull(entry);

		if (actor.hasDelegationRole()) {
			return hasPermission(actor,
					TechnicalAccountPermissionType.THREADS_GET);
		}
		if (actor.hasAllRights()) {
			return true;
		}
		return isUserMember(owner, entry);
	}

	@Override
	protected boolean hasListPermission(Account actor, Account owner,
			Thread entry, Object... opt) {
		Validate.notNull(actor);
		Validate.notNull(owner);

		if (actor.hasDelegationRole()) {
			return hasPermission(actor,
					TechnicalAccountPermissionType.THREADS_LIST);
		}
		if (actor.hasAllRights()) {
			return true;
		}
		return isUserMember(owner, entry);
	}

	@Override
	protected boolean hasDeletePermission(Account actor, Account owner,
			Thread entry, Object... opt) {
		Validate.notNull(actor);
		Validate.notNull(owner);
		Validate.notNull(entry);

		if (actor.hasDelegationRole()) {
			return hasPermission(actor,
					TechnicalAccountPermissionType.THREADS_DELETE);
		}
		if (actor.hasAllRights()) {
			return true;
		}
		return isUserAdmin(owner, entry);
	}

	@Override
	protected boolean hasCreatePermission(Account actor, Account owner,
			Thread entry, Object... opt) {
		Validate.notNull(actor);
		Validate.notNull(owner);

		if (actor.hasDelegationRole()) {
			return hasPermission(actor,
					TechnicalAccountPermissionType.THREADS_CREATE);
		}
		if (actor.hasAllRights()) {
			return true;
		}
		return !owner.getAccountType().equals(AccountType.GUEST);
	}

	@Override
	protected boolean hasUpdatePermission(Account actor, Account owner,
			Thread entry, Object... opt) {
		Validate.notNull(actor);
		Validate.notNull(owner);
		Validate.notNull(entry);

		if (actor.hasDelegationRole()) {
			return hasPermission(actor,
					TechnicalAccountPermissionType.THREADS_UPDATE);
		}
		if (actor.hasAllRights()) {
			return true;
		}
		return isUserAdmin(owner, entry);
	}

	@Override
	protected String getEntryRepresentation(Thread entry) {
		return '(' + entry.getLsUuid() + ')';
	}

	private boolean isUserMember(Account user, Thread thread) {
		boolean ret = threadMemberRepository.findUserThreadMember(thread,
				(User) user) != null;
		logger.debug(user + " member of " + thread + " : " + ret);
		return ret;
	}

	private boolean isUserAdmin(Account user, Thread thread) {
		boolean ret = threadMemberRepository.isUserAdmin((User) user, thread);
		logger.debug(user + " admin of " + thread + " : " + ret);
		return ret;
	}
}
