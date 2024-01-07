FROM alpine:3.18.4
RUN apk update
RUN echo "https://dl-cdn.alpinelinux.org/alpine/v3.18/community" >> /etc/apk/repositories
RUN apk update && apk --no-cache add openjdk17
ENV JAVA_HOME /usr/lib/jvm/default-jvm
RUN apk add --no-cache tzdata && \
    cp /usr/share/zoneinfo/America/La_Paz /etc/localtime && \
    echo "America/La_Paz" > /etc/timezone
RUN mkdir /logs

ARG APP_USER=nurairbnbuser
ARG JAR_FILE=build/libs/CheckInApi-*.jar


COPY $JAR_FILE /app.jar
RUN adduser -D $APP_USER && \
    chown $APP_USER /app.jar /logs
USER $APP_USER
ENV JAVA_TOOL_OPTIONS="-XX:+UseG1GC"
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app.jar", "--server.port=8080"]