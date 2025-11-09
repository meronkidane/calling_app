FROM eclipse-temurin:21-jre-alpine AS base
WORKDIR /app

COPY build/libs/*-SNAPSHOT.jar /app/app.jar

ENV JAVA_OPTS="-Xms256m -Xmx512m"
EXPOSE 8080

ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar /app/app.jar"]
