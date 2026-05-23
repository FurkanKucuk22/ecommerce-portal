<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <title>Giriş Yap - E-Ticaret Portalı</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

    <nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-5">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/home">E-Ticaret Portalı</a>
            <div class="collapse navbar-collapse">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/register">Kayıt Ol</a></li>
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/cart">Sepetim</a></li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-6 col-lg-4">
                
                <c:if test="${param.registered == 'true'}">
                    <div class="alert alert-success text-center fw-bold shadow-sm" role="alert">
                        🎉 Kayıt başarılı! Lütfen giriş yapın.
                    </div>
                </c:if>

                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger text-center shadow-sm" role="alert">
                        ${errorMessage}
                    </div>
                </c:if>

                <div class="card shadow-sm border-0 mt-3">
                    <div class="card-body p-5">
                        <h2 class="text-center mb-4 fw-bold">Giriş Yap</h2>

                        <form action="${not empty postAction ? postAction : 'login'}" method="post">
                            <div class="mb-3">
                                <label for="email" class="form-label fw-bold">E-Posta Adresi</label>
                                <input type="email" class="form-control" id="email" name="email" required>
                            </div>
                            
                            <div class="mb-4">
                                <label for="password" class="form-label fw-bold">Şifre</label>
                                <input type="password" class="form-control" id="password" name="password" required>
                            </div>
                            
                            <button type="submit" class="btn btn-primary w-100 py-2 fw-bold">Giriş Yap</button>
                        </form>
                        
                        <div class="text-center mt-4">
                            <span class="text-muted">Hesabın yok mu?</span>
                            <a href="${pageContext.request.contextPath}/register" class="text-decoration-none fw-bold">Hemen Kayıt Ol</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

</body>
</html>