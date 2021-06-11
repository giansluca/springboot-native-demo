FROM ghcr.io/graalvm/graalvm-ce:ol7-java11-21.1.0 as builder

WORKDIR /app

COPY pom.xml /app/pom.xml

# For SDKMAN to work we need unzip & zip
RUN yum install -y unzip zip

# Install sdkmab, maven and graalVM native-image
RUN curl -s "https://get.sdkman.io" | bash; \
    source "$HOME/.sdkman/bin/sdkman-init.sh"; \
    sdk install maven 3.8.1; \
    gu install native-image; \
    mvn -q package -P native \

#FROM gcr.io/distroless/base-debian10
#
#COPY --from=builder /app/target/app.out /
#
#EXPOSE 4001
#CMD ./app.out