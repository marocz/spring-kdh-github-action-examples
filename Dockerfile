# Use the official OpenJDK 17 image as a base image
#FROM openjdk:17-jdk-slim

FROM openjdk:17-jdk-slim

# Set the maintainer label
LABEL maintainer="your_email@example.com"

# Set environment variables for Maven
ENV MAVEN_VERSION 3.8.2
ENV MAVEN_HOME /usr/share/maven
ENV PATH ${MAVEN_HOME}/bin:${PATH}
ENV EUREKA_SERVER_URL=http://eureka-server:8761/eureka/

# Install Maven
RUN apt-get update && \
    apt-get install -y curl && \
    curl -fsSL https://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar xzf - -C /usr/share && \
    mv /usr/share/apache-maven-$MAVEN_VERSION /usr/share/maven && \
    ln -s /usr/share/maven/bin/mvn /usr/bin/mvn && \
    apt-get remove -y curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy your project's source code into the image
COPY ./ /app
WORKDIR /app

# Build and deploy the application
RUN mvn clean install

RUN cp target/*.jar ./app.jar
# Expose the application's port (if needed)
# EXPOSE 8080

# Set the command to run your application
ENTRYPOINT ["java", "-Dspring.cloud.config.uri=${EUREKA_SERVER_URL}", "-jar", "./app.jar"]

