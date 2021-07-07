FROM ghcr.io/graalvm/graalvm-ce:ol7-java11-21.1.0 as builder

WORKDIR /app

RUN yum install -y wget
RUN wget http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo
RUN yum install -y apache-maven
RUN gu install native-image

COPY pom.xml /app/pom.xml
RUN mvn -q clean dependency:go-offline

COPY . /app
#RUN mvn -q package
RUN mvn -q package -P native

#FROM openjdk:11-jre-buster
#RUN mkdir -p /app
#COPY --from=builder /app/target/springboot-native-demo.jar /app
#CMD java -jar /app/springboot-native-demo.jar
#EXPOSE 4001

#FROM gcr.io/distroless/base-debian10
FROM openjdk:11-jre-buster
RUN mkdir -p /app
COPY --from=builder /app/target/app.out /app
CMD ./app/app.out
EXPOSE 4001