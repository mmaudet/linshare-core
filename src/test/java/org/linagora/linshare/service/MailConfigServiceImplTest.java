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

package org.linagora.linshare.service;

import java.util.Map;
import java.util.Set;

import org.junit.After;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.linagora.linshare.core.domain.constants.Language;
import org.linagora.linshare.core.domain.constants.LinShareTestConstants;
import org.linagora.linshare.core.domain.constants.MailContentType;
import org.linagora.linshare.core.domain.entities.AbstractDomain;
import org.linagora.linshare.core.domain.entities.MailConfig;
import org.linagora.linshare.core.domain.entities.MailContentLang;
import org.linagora.linshare.core.domain.entities.MailFooterLang;
import org.linagora.linshare.core.repository.AbstractDomainRepository;
import org.linagora.linshare.core.service.MailConfigService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.AbstractTransactionalJUnit4SpringContextTests;

import com.google.common.collect.ImmutableSet;

@ContextConfiguration(locations = { "classpath:springContext-datasource.xml",
		"classpath:springContext-dao.xml",
		"classpath:springContext-ldap.xml",
		"classpath:springContext-repository.xml",
		"classpath:springContext-jackRabbit-mock.xml",
		"classpath:springContext-business-service.xml",
		"classpath:springContext-service-miscellaneous.xml",
		"classpath:springContext-test.xml" })
public class MailConfigServiceImplTest extends AbstractTransactionalJUnit4SpringContextTests {

	private static Logger logger = LoggerFactory
			.getLogger(FunctionalityServiceImplTest.class);

	@Autowired
	private MailConfigService mailConfigService;

	@Autowired
	private AbstractDomainRepository abstractDomainRepository;

	private static final Set<Language> supportedLangs = ImmutableSet.of(
			Language.ENGLISH, Language.FRENCH);

	private AbstractDomain rootDomain;

	@Before
	public void setUp() throws Exception {
		logger.debug(LinShareTestConstants.BEGIN_SETUP);
		rootDomain = abstractDomainRepository
				.findById(LoadingServiceTestDatas.sqlRootDomain);
		logger.debug(LinShareTestConstants.END_SETUP);
	}

	@After
	public void tearDown() throws Exception {
		logger.debug(LinShareTestConstants.BEGIN_TEARDOWN);
		logger.debug(LinShareTestConstants.END_TEARDOWN);
	}

	/**
	 * Mail configurations are duplicated from root domain when created. As
	 * such, this mail configuration should is the reference.
	 */
	@Test
	public void testMailConfigDataIntegrity() {
		MailConfig current = rootDomain.getCurrentMailConfiguration();

		/*
		 * Validate mail contents
		 */
		Set<MailContentLang> contents = current.getMailContentLangs();
		Assert.assertNotNull(contents);
		/*
		 * iterate over mailcontent langs, searching for all <Language,
		 * MailContentType> pair
		 */
		for (MailContentType type : MailContentType.values()) {
			for (Language lang : supportedLangs) {
				boolean found = false;

				for (MailContentLang c : contents) {
					if (c.getMailContentType() == type.toInt()
							&& c.getLanguage() == lang.toInt())
						found = true;
				}
				Assert.assertTrue(
						"Missing MailContentLang in root domain mail config : lang="
								+ lang.toString() + ";type=" + type.toString(),
						found);
			}
		}

		/*
		 * Validate mail footers
		 */
		Map<Integer, MailFooterLang> footers = current.getMailFooters();
		Assert.assertNotNull(current.getMailFooters());
		for (Language lang : supportedLangs) {
			Assert.assertNotNull(
					"Missing MailFooter in root domain mail config : lang="
							+ lang.toString(), footers.get(lang.toInt()));
		}

		Assert.assertNotNull(current.getMailLayoutHtml());
		Assert.assertNotNull(current.getMailLayoutText());
	}

	@Test
	public void testCreateMailConfig() {
		// TODO implement tests
	}

	@Test
	public void testUpdateMailConfig() {
		// TODO implement tests
	}

	@Test
	public void testDeleteMailConfig() {
		// TODO implement tests
	}
}
