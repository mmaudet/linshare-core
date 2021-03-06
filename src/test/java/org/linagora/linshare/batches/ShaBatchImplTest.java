package org.linagora.linshare.batches;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

import org.apache.cxf.helpers.IOUtils;
import org.junit.After;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.linagora.linshare.core.batches.GenericBatch;
import org.linagora.linshare.core.domain.constants.FileSizeUnit;
import org.linagora.linshare.core.domain.constants.LinShareTestConstants;
import org.linagora.linshare.core.domain.constants.Policies;
import org.linagora.linshare.core.domain.constants.TimeUnit;
import org.linagora.linshare.core.domain.entities.Account;
import org.linagora.linshare.core.domain.entities.Document;
import org.linagora.linshare.core.domain.entities.DocumentEntry;
import org.linagora.linshare.core.domain.entities.FileSizeUnitClass;
import org.linagora.linshare.core.domain.entities.Functionality;
import org.linagora.linshare.core.domain.entities.Policy;
import org.linagora.linshare.core.domain.entities.StringValueFunctionality;
import org.linagora.linshare.core.domain.entities.TimeUnitClass;
import org.linagora.linshare.core.domain.entities.UnitValueFunctionality;
import org.linagora.linshare.core.domain.entities.User;
import org.linagora.linshare.core.exception.BusinessException;
import org.linagora.linshare.core.job.quartz.Context;
import org.linagora.linshare.core.job.quartz.LinShareJobBean;
import org.linagora.linshare.core.repository.DocumentEntryRepository;
import org.linagora.linshare.core.repository.DocumentRepository;
import org.linagora.linshare.core.repository.FunctionalityRepository;
import org.linagora.linshare.core.repository.UserRepository;
import org.linagora.linshare.core.service.DocumentEntryService;
import org.linagora.linshare.service.LoadingServiceTestDatas;
import org.quartz.JobExecutionException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.AbstractTransactionalJUnit4SpringContextTests;

import com.google.common.collect.Lists;

@ContextConfiguration(locations = { "classpath:springContext-datasource.xml",
		"classpath:springContext-dao.xml", "classpath:springContext-ldap.xml",
		"classpath:springContext-jackRabbit-mock.xml",
		"classpath:springContext-repository.xml",
		"classpath:springContext-business-service.xml",
		"classpath:springContext-rac.xml",
		"classpath:springContext-service-miscellaneous.xml",
		"classpath:springContext-service.xml",
		"classpath:springContext-batches.xml",
		"classpath:springContext-test.xml" })
public class ShaBatchImplTest extends AbstractTransactionalJUnit4SpringContextTests {

	private static Logger logger = LoggerFactory
			.getLogger(ShaBatchImplTest.class);

	@Qualifier("shaSumBatch")
	@Autowired
	private GenericBatch shaSumBatch;

	@Autowired
	private DocumentRepository documentRepository;

	@Qualifier("userRepository")
	@Autowired
	private UserRepository<User> userRepository;

	@Autowired
	private DocumentEntryService documentEntryService;

	@Autowired
	private DocumentEntryRepository documentEntryRepository;

	private LoadingServiceTestDatas datas;

	private DocumentEntry aDocumentEntry;

	private DocumentEntry bDocumentEntry;

	@Autowired
	private FunctionalityRepository functionalityRepository;

	private User jane;
	private final InputStream stream2 = Thread.currentThread().getContextClassLoader().getResourceAsStream("linshare-mailContainer.properties");
	private final String fileName2 = "linshare-mailContainer.properties";
	private final String comment2 = "file description sample";
	private final InputStream stream1 = Thread.currentThread().getContextClassLoader().getResourceAsStream("linshare-default.properties");
	private final String fileName1 = "linshare-default.properties";
	private final String comment1 = "file description default";

	@Before
	public void setUp() throws Exception {
		logger.debug(LinShareTestConstants.BEGIN_SETUP);
		datas = new LoadingServiceTestDatas(userRepository);
		datas.loadUsers();
		jane = datas.getUser2();
		logger.debug(LinShareTestConstants.END_SETUP);
	}

	@After
	public void tearDown() throws Exception {
		logger.debug(LinShareTestConstants.BEGIN_TEARDOWN);
		logger.debug(LinShareTestConstants.END_TEARDOWN);
	}

	@Test
	public void testLaunch() throws BusinessException, JobExecutionException {
		logger.info(LinShareTestConstants.BEGIN_TEST);
		LinShareJobBean job = new LinShareJobBean();
		List<GenericBatch> batches = Lists.newArrayList();
		batches.add(shaSumBatch);
		job.setBatch(batches);
		Assert.assertTrue("At least one batch failed.", job.executeExternal());
		logger.info(LinShareTestConstants.END_TEST);
	}

	@Test
	public void testShaGetAll() throws BusinessException, JobExecutionException, IOException {
		logger.info(LinShareTestConstants.BEGIN_TEST);
		Account actor = jane;
		createFunctionalities();
		File tempFile1 = File.createTempFile("linshare-test-", ".tmp");
		File tempFile2 = File.createTempFile("linshare-test-2", ".tmp");
		List<String> l = Lists.newArrayList();
		IOUtils.transferTo(stream1, tempFile1);
		IOUtils.transferTo(stream2, tempFile2);
		aDocumentEntry = documentEntryService.create(actor, actor, tempFile1, fileName1, comment1, false, null);
		bDocumentEntry = documentEntryService.create(actor, actor, tempFile2, fileName2, comment2, false, null);
		Assert.assertTrue(documentEntryRepository.findById(aDocumentEntry.getUuid()) != null);
		Assert.assertTrue(documentEntryRepository.findById(bDocumentEntry.getUuid()) != null);
		aDocumentEntry.getDocument().setSha256sum(null);
		bDocumentEntry.getDocument().setSha256sum(null);
		l = shaSumBatch.getAll();
		Assert.assertEquals(l.size(), 2);
	}

	@Test
	public void testSha256Batch() throws BusinessException, JobExecutionException, IOException {
		logger.info(LinShareTestConstants.BEGIN_TEST);
		Account actor = jane;
		createFunctionalities();
		File tempFile = File.createTempFile("linshare-test-", ".tmp");
		File tempFile2 = File.createTempFile("linshare-test-up", ".tmp");
		List<String> l = Lists.newArrayList();
		IOUtils.transferTo(stream2, tempFile);
		IOUtils.transferTo(stream1, tempFile2);
		aDocumentEntry = documentEntryService.create(actor, actor, tempFile, fileName2, comment2, false, null);
		Assert.assertTrue(documentEntryRepository.findById(aDocumentEntry.getUuid()) != null);
		aDocumentEntry.getDocument().setSha256sum(null);
		documentRepository.update(aDocumentEntry.getDocument());
		l = shaSumBatch.getAll();
		int i;
		Context c;
		for (i = 0; i < l.size(); i++) {
			c = shaSumBatch.execute(l.get(i), l.size(), i);
			Assert.assertEquals(c.getIdentifier(), l.get(i));
			Document doc = documentRepository.findByUuid(l.get(i));
			Assert.assertEquals("0f2f3d281607dbcd3178bbf1a61a87c8b5267a3312f6309d1412ba7cdd9ca486", doc.getSha256sum());
			Assert.assertEquals("727e25a63402ac496066df859ee029e48ffa902b", doc.getSha1sum());
		}
		logger.info(LinShareTestConstants.END_TEST);
	}

	private void createFunctionalities() throws IllegalArgumentException, BusinessException {
		Integer value = 1;
		ArrayList<Functionality> functionalities = new ArrayList<Functionality>();
		functionalities.add(
			new UnitValueFunctionality("QUOTA_GLOBAL",
				true,
				new Policy(Policies.ALLOWED, false),
				new Policy(Policies.ALLOWED, false),
				jane.getDomain(),
				value,
				new FileSizeUnitClass(FileSizeUnit.GIGA)
			)
		);
		functionalities.add(
			new UnitValueFunctionality("QUOTA_USER",
				true,
				new Policy(Policies.ALLOWED, false),
				new Policy(Policies.ALLOWED, false),
				jane.getDomain(),
				value,
				new FileSizeUnitClass(FileSizeUnit.GIGA)
			)
		);
		functionalities.add(
				new UnitValueFunctionality("MIME_TYPE",
					true,
					new Policy(Policies.ALLOWED, false),
					new Policy(Policies.ALLOWED, false),
					jane.getDomain(),
					value,
					new FileSizeUnitClass(FileSizeUnit.GIGA)
				)
		);
		functionalities.add(
				new UnitValueFunctionality("ANTIVIRUS",
					true,
					new Policy(Policies.ALLOWED, false),
					new Policy(Policies.ALLOWED, false),
					jane.getDomain(),
					value,
					new FileSizeUnitClass(FileSizeUnit.GIGA)
				)
		);
		functionalities.add(
				new UnitValueFunctionality("ENCIPHERMENT",
					true,
					new Policy(Policies.ALLOWED, true),
					new Policy(Policies.ALLOWED, true),
					jane.getDomain(),
					value,
					new FileSizeUnitClass(FileSizeUnit.GIGA)
				)
		);
		functionalities.add(
				new StringValueFunctionality("TIME_STAMPING",
					true,
					new Policy(Policies.ALLOWED, false),
					new Policy(Policies.ALLOWED, false),
					jane.getDomain(),
					""
				)
		);
		functionalities.add(
				new UnitValueFunctionality("FILE_EXPIRATION",
					true,
					new Policy(Policies.ALLOWED, false),
					new Policy(Policies.ALLOWED, false),
					jane.getDomain(),
					value,
					new TimeUnitClass(TimeUnit.DAY)
				)
		);
		functionalities.add(
				new UnitValueFunctionality("FILESIZE_MAX",
					true,
					new Policy(Policies.ALLOWED, true),
					new Policy(Policies.ALLOWED, true),
					jane.getDomain(),
					5,
					new FileSizeUnitClass(FileSizeUnit.GIGA)
				)
		);
		for (Functionality functionality : functionalities) {
			functionalityRepository.create(functionality);
			jane.getDomain().addFunctionality(functionality);
		}
	}
}
