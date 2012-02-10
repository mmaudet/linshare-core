package org.linagora.linShare.service;

import org.junit.After;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.linagora.linShare.core.domain.constants.LinShareConstants;
import org.linagora.linShare.core.domain.entities.User;
import org.linagora.linShare.core.exception.BusinessException;
import org.linagora.linShare.core.repository.AbstractDomainRepository;
import org.linagora.linShare.core.repository.DomainPolicyRepository;
import org.linagora.linShare.core.repository.FunctionalityRepository;
import org.linagora.linShare.core.repository.UserRepository;
import org.linagora.linShare.core.service.AbstractDomainService;
import org.linagora.linShare.core.service.UserAndDomainMultiService;
import org.linagora.linShare.core.service.UserService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.AbstractJUnit4SpringContextTests;
import org.springframework.test.context.junit4.AbstractTransactionalJUnit4SpringContextTests;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;


@ContextConfiguration(locations = { 
		"classpath:springContext-datasource.xml",
		"classpath:springContext-repository.xml",
		"classpath:springContext-service.xml",
		"classpath:springContext-dao.xml",
		"classpath:springContext-facade.xml",
		"classpath:springContext-startopends.xml",
		"classpath:springContext-jackRabbit.xml",
		"classpath:springContext-test.xml"
		})
public class UserAndDomainMultiServiceImplTest extends AbstractTransactionalJUnit4SpringContextTests{
	

	private static Logger logger = LoggerFactory.getLogger(UserAndDomainMultiServiceImplTest.class);

	private LoadingServiceTestDatas datas;
	
	@Autowired
	private FunctionalityRepository functionalityRepository;
	
	@Autowired
	private AbstractDomainRepository abstractDomainRepository;
	
	@Autowired
	private DomainPolicyRepository domainPolicyRepository;
	
	@SuppressWarnings("unchecked")
	@Qualifier("userRepository")
	@Autowired
	private UserRepository userRepository;
	
	@Autowired
	private UserAndDomainMultiService userAndDomainMultiService;	
	
	@Autowired
	private AbstractDomainService abstractDomainService;
	
	@Autowired
	private UserService userService;
	
	
	@Before
	public void setUp() throws Exception {
		logger.debug("Begin setUp");
		
		datas = new LoadingServiceTestDatas(functionalityRepository,abstractDomainRepository,domainPolicyRepository,userRepository,userService);
		
		datas.loadUsers();
		
		logger.debug("End setUp");
	}

	@After
	public void tearDown() throws Exception {
		logger.debug("Begin tearDown");
	
		datas.deleteUsers();
		
		logger.debug("End tearDown");
	}
	
	
	@Test
	public void testDeleteUserInSubDomain() {
		logger.info("testDeleteUserInSubdomain: begin");
		
		User actor = datas.getUser1(); 
		
		String user1Login = new String(datas.getUser1().getLogin());
		String user2Login = new String(datas.getUser2().getLogin());
		String user3Login = new String(datas.getUser3().getLogin());
		
		try {
			logger.debug("John Doe trying to delete Jane Smith (who is in a subdomain)");
			
			userAndDomainMultiService.deleteDomainAndUsers(actor, LoadingServiceTestDatas.subDomainName1);
			
		}catch (BusinessException e) {
			logger.error("userAndDomainMultiService can not delete a user in subdomain");
			logger.error(e.toString());
		}
		
		User tmpUser = userRepository.findByMailAndDomain(LoadingServiceTestDatas.topDomainName, user1Login);
		Assert.assertNotNull(tmpUser);
		
		tmpUser = userRepository.findByMail(user2Login);
		Assert.assertNull(tmpUser);
		
		tmpUser = userRepository.findByMailAndDomain(LoadingServiceTestDatas.guestDomainName1, user3Login);
		Assert.assertNotNull(tmpUser);	
	
		logger.debug("testDeleteUserInSubdomain: end");
	}
	
//	testDeleteGuestInSubDomain
	@Test
	public void testDeleteGuestInGuestDomain() throws BusinessException {
		logger.info("testDeleteGuestInGuestDomain: begin");

		User actor = datas.getUser1(); 
		
		String user1Login = new String(datas.getUser1().getLogin());
		String user2Login = new String(datas.getUser2().getLogin());
		String user3Login = new String(datas.getUser3().getLogin());
		
		try {
			logger.debug("John Doe trying to delete Foo Bar (who is in a guest domain)");
			
			userAndDomainMultiService.deleteDomainAndUsers(actor, LoadingServiceTestDatas.guestDomainName1);
			
			
		}catch (BusinessException e) {
			logger.error("userAndDomainMultiService can not delete a user in guest domain");
			logger.error(e.toString());
		}
		
		
		User tmpUser = userRepository.findByMailAndDomain(LoadingServiceTestDatas.topDomainName, user1Login);
		Assert.assertNotNull(tmpUser);
		
		tmpUser = userRepository.findByMailAndDomain(LoadingServiceTestDatas.subDomainName1, user2Login);
		Assert.assertNotNull(tmpUser);
		
		tmpUser = userRepository.findByMail(user3Login);
		Assert.assertNull(tmpUser);
		
		logger.debug("testDeleteGuestInGuestDomain: end");
	}	
	
	@Test
	public void testDeleteUserInTopDomainWithSubDomainUser() throws BusinessException {
		logger.info("testDeleteUserInTopDomainWithSubDomainUser: begin");
		
		User actor = userService.findOrCreateUser("root@localhost.localdomain", LinShareConstants.rootDomainIdentifier);
		
		String user1Login = new String(datas.getUser1().getLogin());
		String user2Login = new String(datas.getUser2().getLogin());
		String user3Login = new String(datas.getUser3().getLogin());

		
		try {
			logger.debug("Jane Smith trying to delete Top Domain then she had no right on it");
			
			userAndDomainMultiService.deleteDomainAndUsers(actor, LoadingServiceTestDatas.topDomainName);
			
		}catch (BusinessException e) {
			logger.error("userAndDomainMultiService can not delete a user in top domain");
			logger.error(e.toString());
		}
		
		User tmpUser = userRepository.findByMailAndDomain(LoadingServiceTestDatas.topDomainName, user1Login);
		Assert.assertNull(tmpUser);
		
		tmpUser = userRepository.findByMailAndDomain(LoadingServiceTestDatas.subDomainName1, user2Login);
		Assert.assertNull(tmpUser);
		
		tmpUser = userRepository.findByMailAndDomain(LoadingServiceTestDatas.guestDomainName1, user3Login);
		Assert.assertNull(tmpUser);
			
		logger.debug("testDeleteUserInTopDomain: end");
	}
	
	
	
	@Test
	public void testDeleteDomain() throws BusinessException {
		logger.info("testDeleteUserInTopDomain: begin");
		
		User actor = userService.findOrCreateUser("root@localhost.localdomain", LinShareConstants.rootDomainIdentifier);
		
		try {
			logger.debug("Root trying to delete John Doe, Jane Smith and Foo Bar (who are in top domain, sub domain and guest domain)");
			
			userAndDomainMultiService.deleteDomainAndUsers(actor, LoadingServiceTestDatas.topDomainName);
			
		}catch (BusinessException e) {
			logger.error("userAndDomainMultiService can not delete a users in top and sub domain");
			logger.error(e.toString());
		}
		
		try {
			Assert.assertNull(abstractDomainService.retrieveDomain(LoadingServiceTestDatas.topDomainName));
			Assert.assertNull(abstractDomainService.retrieveDomain(LoadingServiceTestDatas.subDomainName1));
			Assert.assertNull(abstractDomainService.retrieveDomain(LoadingServiceTestDatas.guestDomainName1));
		} catch (BusinessException e) {
			logger.error("Test success top and sub domain don't exist");
		}
		
		logger.debug("testDeleteUserInTopDomain: end");
	}

}
