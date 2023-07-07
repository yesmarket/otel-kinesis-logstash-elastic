FROM maven:3-amazoncorretto-17 AS build

WORKDIR /tmp

COPY . ./

RUN curl -L -O https://github.com/open-telemetry/opentelemetry-java-instrumentation/releases/latest/download/opentelemetry-javaagent.jar

RUN mvn -B -f ./pom.xml clean install

FROM amazoncorretto:17-alpine-jdk AS runtime

COPY --from=build /tmp/opentelemetry-javaagent.jar /opt/java-api/
COPY --from=build /tmp/target/java-api-0.0.1-SNAPSHOT.jar /opt/java-api/

WORKDIR /opt/java-api

EXPOSE 5001/tcp

ENTRYPOINT ["java", "-javaagent:opentelemetry-javaagent.jar", "-jar", "java-api-0.0.1-SNAPSHOT.jar"]
