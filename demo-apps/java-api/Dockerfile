FROM maven:3-amazoncorretto-17 AS build

WORKDIR /tmp

COPY . ./

RUN curl -L -O https://github.com/open-telemetry/opentelemetry-java-instrumentation/releases/latest/download/opentelemetry-javaagent.jar

RUN mvn -B -f ./pom.xml clean install

FROM amazoncorretto:17-alpine-jdk AS runtime

EXPOSE 5001/tcp

RUN addgroup -S jag && adduser -S ja -G jag

RUN mkdir -p /opt/java-api
COPY --from=build --chown=ja:jag /tmp/opentelemetry-javaagent.jar /opt/java-api/
COPY --from=build --chown=ja:jag /tmp/target/java-api-0.0.1-SNAPSHOT.jar /opt/java-api/

USER ja

WORKDIR /opt/java-api

ENTRYPOINT ["java", "-javaagent:opentelemetry-javaagent.jar", "-jar", "java-api-0.0.1-SNAPSHOT.jar"]
