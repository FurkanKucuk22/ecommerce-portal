<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <title>Kayıt Ol - E-Ticaret Portalı</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

    <nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-5">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/home">E-Ticaret Portalı</a>
            <div class="collapse navbar-collapse">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/login">Giriş Yap</a></li>
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/cart">Sepetim</a></li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-6 col-lg-5">
                <div class="card shadow-sm border-0">
                    <div class="card-body p-5">
                        <h2 class="text-center mb-4 fw-bold">Yeni Hesap Oluştur</h2>

                        <c:if test="${not empty errorMessage}">
                            <div class="alert alert-danger" role="alert">
                                ${errorMessage}
                            </div>
                        </c:if>

                        <form action="register" method="post">
                            <div class="mb-3">
                                <label for="fullName" class="form-label fw-bold">Ad Soyad</label>
                                <input type="text" class="form-control" id="fullName" name="fullName" required>
                            </div>
                            
                            <div class="mb-3">
                                <label for="email" class="form-label fw-bold">E-Posta Adresi</label>
                                <input type="email" class="form-control" id="email" name="email" required>
                            </div>
                            
                            <div class="mb-3">
                                <label for="password" class="form-label fw-bold">Şifre</label>
                                <input type="password" class="form-control" id="password" name="password" required minlength="6">
                            </div>

                            <div class="mb-3">
                                <label for="phone" class="form-label fw-bold">Telefon Numarası</label>
                                <input type="tel" class="form-control" id="phone" name="phone" placeholder="05XX XXX XX XX">
                            </div>

                            <div class="mb-4">
                                <label for="address" class="form-label fw-bold">Teslimat Adresi</label>
                                <textarea class="form-control" id="address" name="address" rows="3"></textarea>
                            </div>
                            
                            <button type="submit" class="btn btn-primary w-100 py-2 fw-bold">Kayıt Ol</button>
                        </form>
                        
                        <div class="text-center mt-4">
                            <span class="text-muted">Zaten bir hesabın var mı?</span>
                            <a href="${pageContext.request.contextPath}/login" class="text-decoration-none fw-bold">Giriş Yap</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

</body>
</html>