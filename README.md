"""# 🛒 Java MVC ve JSTL ile Temel E-Ticaret Portalı - Kurulum Rehberi

Bu proje, Java tabanlı Model-View-Controller (MVC) mimarisi standartlarına tam uyumlu olarak geliştirilmiş, dinamik, güvenli ve rol tabanlı (Müşteri/Yönetici) çalışan tam kapsamlı bir e-ticaret otomasyon sistemidir. Proje kapsamında veritabanı izolasyonu, sunucu taraflı form doğrulamaları ve şifre güvenliği sektör standartlarında uygulanmıştır.

## 🛠 Teknik Yığın (Tech Stack)

* **Backend:** Java Servlet API, JDBC (Java Database Connectivity)
* **Frontend:** JSP (JavaServer Pages), JSTL (JavaServer Pages Standard Tag Library), Bootstrap 5 & Bootstrap Icons
* **Veritabanı:** MySQL Server (Karakter Kodlaması: `utf8mb4_unicode_ci`)
* **Sunucu Ortamı:** Apache Tomcat (v9.0 veya üzeri)
* **Güvenlik:** SHA-256 Kriptografik Parola Hashleme Sınıfı (`SecurityUtil`)

## 📋 Gereksinimler (Prerequisites)

Projeyi yerel ortamınızda çalıştırmadan önce sisteminizde aşağıdaki araçların kurulu ve yapılandırılmış olduğundan emin olun:

* **JDK (Java Development Kit):** Java 11 veya üzeri sürümler.
* **MySQL Server (v8.0+):** İlişkisel veritabanı motoru.
* **Apache Tomcat (v9.0+):** Servlet konteyneri ve web sunucusu.
* **IDE / Editör:** Eclipse IDE, IntelliJ IDEA veya VSCode (Tomcat / Server eklentileri ile).

---

## 🛠 Adım 1: Veritabanı Kurulumu ve SQL Çalıştırma

PowerShell veya Komut Satırı üzerinden Türkçe karakter kayıplarını sıfıra indirmek ve Windows encoding (LF/CRLF) hatalarını engellemek amacıyla veritabanı yüklemesini doğrudan MySQL kabuğu (`source`) üzerinden yapmanız kesinlikle tavsiye edilir.

### 1.1. Proje Dizinine Giriş
Terminalinizi açın ve projenin yer aldığı kök dizine geçiş yapın:
