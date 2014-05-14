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
package org.linagora.linshare.core.business.service.impl;

import java.util.Set;

import org.linagora.linshare.core.business.service.MimePolicyBusinessService;
import org.linagora.linshare.core.dao.MimeTypeMagicNumberDao;
import org.linagora.linshare.core.domain.entities.MimePolicy;
import org.linagora.linshare.core.domain.entities.MimeType;
import org.linagora.linshare.core.exception.BusinessException;
import org.linagora.linshare.core.repository.MimePolicyRepository;
import org.linagora.linshare.core.repository.MimeTypeRepository;

public class MimePolicyBusinessServiceImpl implements MimePolicyBusinessService {

	private MimePolicyRepository mimePolicyRepository;
	
	private MimeTypeRepository mimeTypeRepository;
	
	private MimeTypeMagicNumberDao mimeTypeMagicNumberDao;

	public MimePolicyBusinessServiceImpl(MimePolicyRepository mimePolicyRepository,
			MimeTypeRepository mimeTypeRepository,
			MimeTypeMagicNumberDao mimeTypeMagicNumberDao) {
		this.mimePolicyRepository = mimePolicyRepository;
		this.mimeTypeRepository = mimeTypeRepository;
		this.mimeTypeMagicNumberDao = mimeTypeMagicNumberDao;
	}

	@Override
	public MimePolicy findByUuid(String uuid) {
		return mimePolicyRepository.findByUuid(uuid);
	}

	@Override
	public void create(MimePolicy mimePolicy) throws BusinessException {
		Set<MimeType> mimeTypes = mimeTypeMagicNumberDao.getAllMimeType();
		for (MimeType mimeType : mimeTypes) {
			mimeTypeRepository.create(mimeType);
		}
		mimePolicy.setMimeTypes(mimeTypes);
		mimePolicyRepository.create(mimePolicy);
	}

	@Override
	public void update(MimePolicy mimePolicy) throws BusinessException {
		MimePolicy entity = mimePolicyRepository.findByUuid(mimePolicy.getUuid());
		entity.setDisplayable(mimePolicy.getDisplayable());
		entity.setMode(mimePolicy.getMode());
		entity.setName(mimePolicy.getName());
		mimePolicyRepository.update(entity);
	}

	@Override
	public void delete(MimePolicy mimePolicy) throws BusinessException {
		mimePolicyRepository.delete(mimePolicy);		
	}
}
