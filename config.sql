DELETE FROM lum_CfgEnvironmentConf;

INSERT INTO lum_CfgEnvironmentConf (id, type, fileSystemImplementation, javaMelodyEnabled, bigDataRepositoryType, esClusterName,esConnectionAddresses,esHttpConnectionAddresses, esBulkConcurrentRequests, useUserGroupsSessionCache) 
VALUES(  '000000000A00000000000A0000100000', 'DEVELOPMENT','lumis.portal.filesystem.impl.SingleCopyFileSystem', 1,'ELASTICSEARCH_TRANSPORT_CLIENT', 'ELASTICSEARCH_CLUSTER_NAME', 'ELASTICSEARCH_HOST:9300', 'ELASTICSEARCH_HOST:9200', 10,1);

UPDATE lum_Website set webRootPath='/usr/local/htdocs' where name ='default';

COMMIT;