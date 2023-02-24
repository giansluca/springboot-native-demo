FROM gianlucamori/graalvm-compiler:1-java11-21.1.0 as builder

WORKDIR /app

COPY pom.xml /app/pom.xml
RUN mvn -q clean dependency:go-offline

COPY . /app
#RUN mvn -q package
RUN mvn -q package -P native

#FROM openjdk:11-jre-buster
#RUN mkdir -p /app
#COPY --from=builder /app/target/springboot-native-demo.jar /app
#CMD java -jar /app/springboot-native-demo.jar
#EXPOSE 8080

FROM gcr.io/distroless/base-debian10
COPY --from=builder /app/target/app.out /
CMD ["./app.out"]
EXPOSE 4001