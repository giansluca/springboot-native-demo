FROM ghcr.io/graalvm/graalvm-ce:ol7-java11-21.1.0 as builder

ARG AWS_USER
ARG AWS_PASSWORD

WORKDIR /app

# For SDKMAN to work we need unzip & zip
RUN yum install -y unzip zip
RUN \
    # Install SDKMAN
    curl -s "https://get.sdkman.io" | bash; \
    source "$HOME/.sdkman/bin/sdkman-init.sh"; \
    # Install Maven
    sdk install maven; \
    # Install GraalVM Native Image
    gu install native-image;

RUN source "$HOME/.sdkman/bin/sdkman-init.sh" && mvn --version
RUN native-image --version

COPY pom.xml /app/pom.xml
COPY settings.xml /app/settings.xml

RUN
RUN mvn -q -s settings.xml clean dependency:go-offline

COPY . /app
RUN mvn -q -s settings.xml package -P native

FROM gcr.io/distroless/base-debian10

COPY --from=builder /app/target/app.out /

EXPOSE 4001
CMD ./app.out