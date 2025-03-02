# OpenJDK 17 kullanarak temel imajı oluştur
FROM openjdk:17-jdk-slim

# Çalışma dizinini belirle
WORKDIR /app

# Maven ile build edilen JAR dosyasını container içine kopyala
COPY /app/target/app-1.0.0.jar /app/app.jar

# Spring Boot uygulamasını başlat
CMD ["java", "-jar", "/app/app.jar"]
