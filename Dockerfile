FROM azul/zulu-openjdk-centos

LABEL maintainer="jeduoliveira81@gmail.com"
LABEL version="1.0"

ENV LUMIS_HOME /usr/local/lumisportal
ENV TZ "America/Sao_Paulo"
ENV ES_HOME /usr/share/elasticsearch
ENV LUMIS_HOME_WWW ${LUMIS_HOME}/www
ENV LUMIS_HTDOCS /usr/local/htdocs
ENV TOMCAT_AJP_MAX_THREADS 40
ENV TOMCAT_HTTP_MAX_THREADS 80
ENV TOMCAT_HEAP 512m
ENV CATALINA_HOME /usr/local/tomcat
ENV PATH ${CATALINA_HOME}/bin:${PATH}
ENV TOMCAT_NATIVE_LIBDIR ${CATALINA_HOME}/native-jni-lib
ENV LD_LIBRARY_PATH ${LD_LIBRARY_PATH:+$LD_LIBRARY_PATH:}${TOMCAT_NATIVE_LIBDIR}

WORKDIR ${LUMIS_HOME}

RUN set -x \
    && yum update -y \
    && yum -y install unzip mysql \
    && curl https://lumisportal-repo.s3.amazonaws.com/lumisportal_11.2.0.190404.zip --output lumisportal_11.2.0.190404.zip \
    && unzip lumisportal_11.2.0.190404.zip \
    && rm -fr lumisportal_11.2.0.190404.zip \
    && yum clean all -y

COPY ./11.2.0.190404/ .

RUN set -x \
    && mkdir -p ${CATALINA_HOME} \
    && curl https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.20/bin/apache-tomcat-9.0.20.tar.gz --output apache-tomcat-9.0.20.tar.gz \
    && tar -zxf apache-tomcat-9.0.20.tar.gz \    
    && mv apache-tomcat-9.0.20/* ${CATALINA_HOME} \
    && rm -fr apache-tomcat-9.0.20.tar.gz \
    && rm -fr apache-tomcat-9.0.20

WORKDIR ${CATALINA_HOME}

COPY ./tomcat/ .
COPY ./elasticsearch/config/lumis-analysis ${ES_HOME}/config/lumis-analysis 

RUN set -x \
    && groupadd elasticsearch \
    && useradd -s /bin/nologin -g elasticsearch -d ${ES_HOME} elasticsearch \
    && mkdir -p ${LUMIS_HOME}/lumisdata/shared/data/elasticsearch \
    && ln -s ${ES_HOME}/config/lumis-analysis ${LUMIS_HOME}/lumisdata/shared/data/elasticsearch/lumis-analysis \
    && chown -R elasticsearch:root $ES_HOME \
    && chmod +x ${CATALINA_HOME}/bin/*.sh \
    && mkdir -p ${LUMIS_HTDOCS} \
    && cp -r ${LUMIS_HOME}/www/lumis* ${LUMIS_HTDOCS} \
    && find . -name "*.jsp" -exec rm -rf {} \; \
    && ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo ${TZ} > /etc/timezone \
    && chown -R elasticsearch:root ${ES_HOME}/config/lumis-analysis \
    && chmod -R 755 ${ES_HOME}/config/lumis-analysis 

VOLUME ${LUMIS_HOME}/lumisdata/data
VOLUME ${LUMIS_HOME}/lumisdata/shared
VOLUME ${ES_HOME}/config/lumis-analysis
VOLUME ${LUMIS_HTDOCS}

COPY docker-entrypoint.sh /
COPY wait-for-mysql.sh /
COPY initialize-lumis.sh /
COPY config.sql /

EXPOSE 8080
EXPOSE 8009

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["bin/catalina.sh", "run"]