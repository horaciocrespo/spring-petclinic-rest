# Install dependencies and package
FROM maven:alpine AS BUILD_IMAGE
ARG APP_DIR=/usr/src/spring-petclinic-rest
COPY src ${APP_DIR}/src
COPY pom.xml ${APP_DIR}
WORKDIR ${APP_DIR}
RUN mvn clean package

# Copy Jar files
FROM openjdk:11 AS JAR_IMAGE
ARG APP_DIR=/usr/src/spring-petclinic-rest
COPY --from=BUILD_IMAGE ${APP_DIR}/target/*.jar ${APP_DIR}/app.jar
WORKDIR ${APP_DIR}
EXPOSE 8080
ENTRYPOINT ["java","-jar","/usr/src/spring-petclinic-rest/app.jar"]