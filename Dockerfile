# Use Maven to build, then Tomcat to run
FROM maven:3.9.9-eclipse-temurin-11 AS build
WORKDIR /app
COPY . .
RUN mvn clean package

FROM tomcat:11.0.6-jdk21-temurin-noble
COPY --from=build /app/target/devops.war /usr/local/tomcat/webapps/devops.war
EXPOSE 8080
CMD ["catalina.sh", "run"]
