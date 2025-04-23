# Use Maven to build, then Tomcat to run
FROM maven:3.9.9-eclipse-temurin-11 AS build
WORKDIR /app
COPY . .
RUN mvn clean package

FROM tomcat:11.0.6-jdk21-temurin-noble
COPY --from=build /app/target/SimpleServletApp-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/SimpleServletApp-1.0-SNAPSHOT.war
EXPOSE 8085
CMD ["catalina.sh", "run"]
