# 🛒 Java MVC ve JSTL ile Temel E-Ticaret Portalı - Kurulum Rehberi

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
```
cd ecommerceportal
```
### 1.2. SQL Dosyasını İçeri Aktarma (Import)
Aşağıdaki komut ile tüm tablo mimarisi ile örnek verileri (seed) kuran SQL dosyasını tetikleyin:
```
mysql -u root -p < ecommerce_db.sql
```
### 1.3. Bağlantı Bilgilerinin Kontrolü
```src/main/java/com/ecommerce/util/DBConnection.java``` dosyasını açarak yerel MySQL şifrenizi doğrulayın.
```
private static final String URL = "jdbc:mysql://localhost:3306/ecommerce_db?useUnicode=true&characterEncoding=UTF-8";
private static final String USERNAME = "root";
private static final String PASSWORD = ""; // Yerel MySQL şifreniz varsa buraya yazınız.
```
## ⚙️ Adım 2: Projenin IDE'ye Aktarılması (Import)
### 2.1. Eclipse IDE Kullanıyorsanız:
* **File > Import > Existing Projects into Workspace adımlarını izleyin**

* **Proje kök dizinini seçip Finish deyin.**

* **Proje adına sağ tıklayıp Properties > Targeted Runtimes kısmından sisteminizde tanımlı Apache Tomcat sunucusunu işaretleyin.**

### 2.2. IntelliJ IDEA Kullanıyorsanız:
* **Open diyerek projenin ana klasörünü seçin.**

* **Project Structure > Modules kısmından Web fasetinin ekli olduğunu ve src/main/webapp dizininin doğru eşleştiğini kontrol edin.**
## 💻 Adım 3: Tomcat Sunucusunu Başlatma ve Çalıştırma
### Yöntem A: IDE Üzerinden Doğrudan Çalıştırma (Geliştirici Modu)
Eclipse / IntelliJ: Projenin en üst klasör adına (Project Root) veya giriş sayfası olan index.jsp dosyasına sağ tıklayıp Run As > Run on Server seçeneğini seçin. Hedef sunucu olarak Apache Tomcat'i gösterip işlemi başlatın.

### Yöntem B: Derlenmiş .war Dosyasını Dağıtma (Deployment Modu)
Eğer VSCode veya harici bir sunucu kullanıyorsanız, target/ klasörü altında derlenmiş olan mimariyi Tomcat'e gömebilirsiniz:

* **```target/ecommerceportal.war``` dosyasını kopyalayın.**

* **Apache Tomcat'in kurulu olduğu dizindeki webapps/ klasörünün içerisine yapıştırın.**

* **Tomcat bin/startup.bat (Windows) veya startup.sh (Linux) dosyasını çalıştırın. Sunucu otomatik olarak .war dosyasını açacaktır.**

### 📦 Yöntem C: Terminal Üzerinden Manuel Derleme (Maven Kullanıcıları İçin)
Eğer projeyi IDE dışında, doğrudan terminal üzerinden derleyip .war paketini sıfırdan kendiniz oluşturmak isterseniz, proje kök dizininde aşağıdaki komutu çalıştırmanız yeterlidir:

```
mvn clean package
```
Bu komut proje bağımlılıklarını indirecek, sınıfları derleyecek ve target/ klasörü içerisinde ecommerceportal.war dosyasını otomatik olarak oluşturacaktır.

### 🌐 Uygulama Erişim Adresi:
Sunucu ayağa kalktıktan sonra tarayıcınızdan aşağıdaki evrensel URL üzerinden sisteme erişebilirsiniz:
```
http://localhost:8080/ecommerceportal/home
```
## 🚀 Öne Çıkan Teknik Özellikler
* **Katı MVC ve DAO Mimarisi:** İş mantığı (Servlets), veri erişimi (DAO), veri modelleri (POJO) ve sunum katmanı (JSP) tamamen izole edilmiştir. Scriptlet (<% %>) kullanılmamış, arayüz tamamen JSTL etiketleriyle dinamikleştirilmiştir.

* **Sıkı Sunucu Taraflı Doğrulama (Server-Side Validation):** İstemci tarafındaki HTML5 kısıtlamaları (required, min) aşılsa dahi; Servlet katmanında null, boşluk (trim().isEmpty()) ve negatif fiyat/stok girdileri arka planda yakalanarak veritabanı güvenliği zorunlu olarak sağlanır.

* **SHA-256 Parola Güvenliği:** Sisteme kayıt olan tüm kullanıcıların şifreleri açık metin (plain text) olarak değil, SecurityUtil sınıfı üzerinden tek yönlü kriptografik SHA-256 hash algoritmasıyla maskelenerek veritabanında saklanır.

* **Yönetici Gösterge Paneli ve Grafiksel Özet:** Admin paneli ana sayfasında (admin-dashboard), sistemdeki toplam envanter, kullanıcı ve sipariş verileri dinamik grafik motoru ile görselleştirilmiştir.

* **Dinamik Sipariş ve Stok Yönetimi:** Sipariş onaylandığı an orders ve order_items tablolarına ilişkisel veri yazılır, envanterdeki ürün stokları otomatik düşürülür ve session tabanlı sepet temizlenir. Sipariş durumları (Beklemede, Kargoya Verildi vb.) dinamik renkli Bootstrap rozetleri (badge) ile listelenir.

* **Performans Odaklı Sayfalama (Pagination):** Ana sayfadaki yoğun ürün listesi tek seferde yüklenmek yerine, alt kısımda yer alan sayfalama algoritması ile parça parça çağrılarak sunucu yükü optimize edilir.

## 🔑 Test Hesap Bilgileri

Sistemi doğrudan test edebilmeniz için hazır eklenmiş kullanıcı profilleri aşağıdadır:

| Hesap Türü | E-posta | Şifre | Giriş Sayfası | Ek Bilgi |
| :--- | :--- | :--- | :--- | :--- |
| **Yönetici (Admin)** | `admin@ecommerce.com` | `123456` | `/admin-login` | Güvenlik nedeniyle arayüzde linki bulunmaz, adres çubuğundan doğrudan girilmelidir. |
| **Müşteri 1** | `zeynep.celik@yahoo.com` | `123456` | `/login` | Standart müşteri arayüzü girişi. |
| **Müşteri 2** | `elif.kaya@gmail.com` | `123456` | `/login` | Standart müşteri arayüzü girişi. |
