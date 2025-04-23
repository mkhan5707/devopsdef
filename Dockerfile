# Use Maven to build, then Tomcat to run
FROM maven:3.8.8-openjdk-8 AS build
WORKDIR /app
COPY . .
RUN mvn clean package

FROM tomcat:9.0-jdk8-openjdk
COPY --from=build /app/target/SimpleServletApp.war /usr/local/tomcat/webapps/SimpleServletApp.war
EXPOSE 8085
CMD ["catalina.sh", "run"]
