FROM tomcat:11.0.18

RUN rm -rf /usr/local/tomcat/webapps/ROOT

ADD https://repo1.maven.org/maven2/mysql/mysql-connector-java/5.1.49/mysql-connector-java-5.1.49.jar /usr/local/tomcat/lib/

COPY ROOT /usr/local/tomcat/webapps/ROOT

COPY server.xml /usr/local/tomcat/conf/server.xml

EXPOSE 8080

CMD ["catalina.sh","run"]
