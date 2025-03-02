# Dağıtık Sistemler

Bu proje, Docker teknolojisi kullanılarak oluşturulmuş dağıtık bir sistem mimarisidir. Projede, Nginx yük dengeleyici, iki adet replikasyonlu Spring Boot uygulama sunucusu, PostgreSQL veritabanı sunucusu ve Redis cache sunucusu yer almaktadır.

## İçerik

- [Proje Hakkında](#proje-hakkında)
- [Mimari Tasarım](#mimari-tasarım)
- [Ön Koşullar](#ön-koşullar)
- [Kurulum ve Çalıştırma](#kurulum-ve-çalıştırma)
- [Proje Yapısı](#proje-yapısı)
- [Konfigürasyon Detayları](#konfigürasyon-detayları)
- [Sorun Giderme](#sorun-giderme)

## Proje Hakkında

Bu proje, modern uygulama geliştirme ve dağıtık sistem mimarilerini öğrenmek amacıyla hazırlanmıştır. Docker Compose kullanılarak, tüm servisler (Nginx, Spring Boot uygulamaları, PostgreSQL ve Redis) container'lar içerisinde konfigüre edilmiştir. Ayrıca, Nginx yapılandırması ile failover mekanizması sağlanarak, herhangi bir uygulama sunucusu devre dışı kaldığında isteklerin diğer sunucuya yönlendirilmesi garanti altına alınmıştır.

## Mimari Tasarım

- **Nginx:**  
  - Yük dengeleyici olarak çalışır ve gelen istekleri Spring Boot uygulama sunucularına yönlendirir.
  - Failover yapılandırması sayesinde, bir uygulama sunucusunun erişilememesi durumunda diğer sunucu devreye girer.

- **Spring Boot Uygulamaları (app1, app2):**  
  - İki adet replikasyonlu uygulama sunucusu bulunur.
  - App1 container'ı 8080 portunu, app2 container'ı ise 8081 portunu kullanacak şekilde yapılandırılmıştır.
  - Uygulama sunucuları, PostgreSQL veritabanı ve Redis cache ile entegre çalışmaktadır.

- **PostgreSQL:**  
  - Uygulama verilerinin saklanması için kullanılır.
  - `pg_data` adlı Docker volume ile verilerin kalıcılığı sağlanır.

- **Redis:**  
  - Uygulama performansını artırmak için cache mekanizması sağlar.

## Ön Koşullar

- [Docker Engine](https://docs.docker.com/get-docker/) kurulmuş olmalı.
- [Docker Compose](https://docs.docker.com/compose/install/) yüklü olmalı.
- (Opsiyonel) Git kurulumu, repository’yi klonlamak için önerilir.

## Kurulum ve Çalıştırma

1. **Repository’yi Klonlayın:**

   ```bash
   git clone <repository_url>
   cd <repository_directory>
   ```

2. **Docker Container’larını Oluşturun ve Başlatın:**

   ```bash
   docker-compose up --build -d
   ```

   Bu komut, Spring Boot uygulamaları için gerekli imajları oluşturur ve tüm container’ları başlatır.

3. **Uygulamaya Erişim:**

   Tarayıcınızda `http://localhost` adresine giderek, Nginx yük dengeleyici aracılığıyla uygulamaya erişebilirsiniz.

4. **Container’ları Durdurmak:**

   ```bash
   docker-compose down
   ```

   komutuyla tüm container’ları kapatabilirsiniz.

## Proje Yapısı

```
.
distributed-system/
│-- nginx/
│   ├── nginx.conf
│-- app1/
│   ├── src/
│   │   ├── main/
│   │   │   ├── java/com/example/app1/
│   │   │   │   ├── Application.java
│   │   │   │   ├── controller/
│   │   │   │   │   ├── HomeController.java
│   │   │   │   ├── service/
│   │   │   │   ├── repository/
│   │   │   │   ├── model/
│   │   ├── resources/
│   │   │   ├── application.properties
│   ├── Dockerfile
│   ├── pom.xml
│   ├── target/
│       ├── myapp1.jar
│-- app2/
│   ├── src/
│   │   ├── main/
│   │   │   ├── java/com/example/app2/
│   │   │   │   ├── Application.java
│   │   │   │   ├── controller/
│   │   │   │   │   ├── HomeController.java
│   │   │   │   ├── service/
│   │   │   │   ├── repository/
│   │   │   │   ├── model/
│   │   ├── resources/
│   │   │   ├── application.properties
│   ├── Dockerfile
│   ├── pom.xml
│   ├── target/
│       ├── myapp2.jar
│-- db/
│   ├── init.sql
│-- redis/
│   ├── redis.conf
│-- docker-compose.yml
│-- README.md
│-- video/
│   ├── setup-demo.mp4
```

## Konfigürasyon Detayları

- **Nginx:**
  - Konfigürasyon dosyası: `nginx/nginx.conf`
  - Upstream bloğunda, `app1:8080` ve `app2:8081` sunucuları tanımlanmıştır.
  - `max_fails` ve `fail_timeout` parametreleri ile failover mekanizması sağlanmıştır.

- **Spring Boot Uygulamaları:**
  - Her iki uygulama da kendi `Dockerfile`’ları aracılığıyla imajlanmaktadır.
  - Ortam değişkenleri ile PostgreSQL ve Redis bağlantı bilgileri yapılandırılmıştır.
  - `app2` için `server.port=8081` ayarı, container içindeki port yapılandırmasını belirler.

- **PostgreSQL:**
  - Konfigürasyon, `docker-compose.yml` içerisinde ortam değişkenleri aracılığıyla yapılır.
  - Veritabanı adı, kullanıcı adı ve şifre ayarları tanımlıdır.
  - Veri kalıcılığı için `pg_data` volume kullanılmıştır.

- **Redis:**
  - Cache sunucusu olarak 6379 portu üzerinden çalışmaktadır.

## Sorun Giderme

- **Docker ve Docker Compose Kurulumu:**
  - Docker ve Docker Compose’un güncel ve doğru şekilde kurulu olduğundan emin olun.

- **Container Logları:**
  - Herhangi bir servis başlatılamıyorsa, ilgili container’ın loglarını inceleyin:

    ```bash
    docker logs <container_name>
    ```

- **Port Çakışmaları:**
  - Özellikle `80`, `5432` ve `6379` portlarının başka servisler tarafından kullanılmadığından emin olun.

