package org.linagora.linshare.core.dao.impl;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Date;
import java.util.Properties;
import java.util.UUID;

import org.jclouds.ContextBuilder;
import org.jclouds.blobstore.BlobStore;
import org.jclouds.blobstore.BlobStoreContext;
import org.jclouds.blobstore.domain.Blob;
import org.jclouds.io.Payload;
import org.jclouds.io.Payloads;
import org.linagora.linshare.core.dao.FileDataStore;
import org.linagora.linshare.core.domain.objects.FileMetaData;
import org.linagora.linshare.core.exception.TechnicalErrorCode;
import org.linagora.linshare.core.exception.TechnicalException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class JcloudObjectStorageFileDataStoreImpl implements FileDataStore {

	protected static final Logger logger = LoggerFactory.getLogger(JcloudObjectStorageFileDataStoreImpl.class);
	protected static String SWIFT_KEYSTONE = "swift-keystone";
	protected static String FILESYSTEM = "filesystem";

	protected String provider;
	protected BlobStoreContext context;
	protected String baseDirectory;
	protected String identity;
	protected String credential;
	protected String endpoint;
	protected String bucketIdentifier;

	public JcloudObjectStorageFileDataStoreImpl(String provider) {
		super();
		this.provider = provider;
		this.context = null;
		this.baseDirectory = null;
		this.identity = null;
		this.credential = null;
		this.endpoint = null;
		this.bucketIdentifier = null;
	}

	public void afterPropertiesSet() throws Exception {
		Properties properties = new Properties();
		ContextBuilder contextBuilder = null;
		if (provider.equals(SWIFT_KEYSTONE)) {
			properties.setProperty(org.jclouds.Constants.PROPERTY_TRUST_ALL_CERTS, "true");
			properties.setProperty(org.jclouds.Constants.PROPERTY_LOGGER_WIRE_LOG_SENSITIVE_INFO, "true");
			contextBuilder = ContextBuilder.newBuilder(SWIFT_KEYSTONE);
			contextBuilder.endpoint(endpoint).credentials(identity, credential);
		} else if (provider.equals(FILESYSTEM)) {
			properties.setProperty(org.jclouds.filesystem.reference.FilesystemConstants.PROPERTY_BASEDIR,
					baseDirectory);
			contextBuilder = ContextBuilder.newBuilder(FILESYSTEM);
		} else {
			throw new IllegalArgumentException(" only " + SWIFT_KEYSTONE + " or " + FILESYSTEM);
		}
		context = contextBuilder.overrides(properties).buildView(BlobStoreContext.class);
		BlobStore blobStore = context.getBlobStore();
		if (!blobStore.containerExists(bucketIdentifier)) {
			blobStore.createContainerInLocation(null, bucketIdentifier);
		}
	}

	public void destroy() {
		if (context != null)
			context.close();
	}

	public BlobStore getBlobStore(String containerName) {
		BlobStore blobStore = context.getBlobStore();
		if (!blobStore.containerExists(containerName)) {
			logger.warn("bucket does not exists : " + containerName);
			blobStore.createContainerInLocation(null, bucketIdentifier);
		}
		return blobStore;
	}

	public static void stats(Date start, String title) {
		System.out.println("diff : " + title + " : " + String.valueOf(new Date().getTime() - start.getTime()));
	}

	@Override
	public void remove(FileMetaData metadata) {
		String containerName = metadata.getBucketUuid();
		BlobStore blobStore = getBlobStore(containerName);
		Date start = new Date();
		try {
			blobStore.removeBlob(containerName, metadata.getUuid());
		} catch (org.jclouds.blobstore.ContainerNotFoundException e) {
			logger.error(e.getMessage(), e);
		}
		stats(start, "blobRetrieved");
	}

	@Override
	public FileMetaData add(File file, FileMetaData metadata) {
		try (FileInputStream fis = new FileInputStream(file)) {
			return metadata = add(fis, metadata);
		} catch (IOException e) {
			logger.error(e.getMessage(), e);
			throw new TechnicalException(TechnicalErrorCode.GENERIC, "Can not add a new file : " + e.getMessage());
		}
	}

	@Override
	public FileMetaData add(InputStream file, FileMetaData metadata) {
		BlobStore blobStore = getBlobStore(bucketIdentifier);
		Date start = null;

		// Create a Blob
		start = new Date();
		Payload payload = Payloads.newInputStreamPayload(file);
		stats(start, "Payload");

		start = new Date();
		Blob blob;
		metadata.setUuid(UUID.randomUUID().toString());
		metadata.setBucketUuid(bucketIdentifier);
		blob = blobStore.blobBuilder(metadata.getUuid()).payload(payload)
				// .contentLength(file.size())
				.build();
		stats(start, "blob");

		// Upload the Blob
		start = new Date();
		String eTag = blobStore.putBlob(bucketIdentifier, blob);
		logger.debug("etag : {}", eTag);
		stats(start, "putBlob");
		return metadata;
	}

	@Override
	public InputStream get(FileMetaData metadata) {
		String containerName = metadata.getBucketUuid();
		BlobStore blobStore = getBlobStore(containerName);
		Date start = new Date();
		Blob blobRetrieved = blobStore.getBlob(containerName, metadata.getUuid());
		stats(start, "blobRetrieved");
		try {
			return blobRetrieved.getPayload().openStream();
		} catch (IOException e) {
			logger.error(e.getMessage(), e);
			throw new TechnicalException(TechnicalErrorCode.GENERIC, "Can not add a new file : " + e.getMessage());
		}
	}

	@Override
	public boolean exists(FileMetaData metadata) {
		String containerName = metadata.getBucketUuid();
		if (containerName == null) {
			// document stored in jackrabbit does not have bucket_uuid. :)
			return false;
		}
		BlobStore blobStore = getBlobStore(containerName);
		return blobStore.blobExists(containerName, metadata.getUuid());
	}

	public String getBaseDirectory() {
		return baseDirectory;
	}

	public void setBaseDirectory(String baseDirectory) {
		this.baseDirectory = baseDirectory;
	}

	public String getIdentity() {
		return identity;
	}

	public void setIdentity(String identity) {
		this.identity = identity;
	}

	public String getCredential() {
		return credential;
	}

	public void setCredential(String credential) {
		this.credential = credential;
	}

	public String getEndpoint() {
		return endpoint;
	}

	public void setEndpoint(String endpoint) {
		this.endpoint = endpoint;
	}

	public String getBucketIdentifier() {
		return bucketIdentifier;
	}

	public void setBucketIdentifier(String bucketIdentifier) {
		this.bucketIdentifier = bucketIdentifier;
	}

}
