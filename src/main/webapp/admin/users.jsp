<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<c:if test="${empty sessionScope.adminUser}">
    <c:redirect url="../admin-login"/>
</c:if>

<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <title>Kullanıcı Yönetimi - Admin Paneli</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        body { background-color: #f8f9fa; }
        .sidebar { min-height: 100vh; background-color: #212529; color: white; }
        .sidebar a { color: #adb5bd; text-decoration: none; padding: 10px 15px; display: block; border-radius: 5px; margin-bottom: 5px;}
        .sidebar a:hover, .sidebar a.active { background-color: #0d6efd; color: white; }
    </style>
</head>
<body>

<div class="container-fluid">
    <div class="row">
        <div class="col-md-2 sidebar p-3 shadow">
            <h4 class="text-center text-white mb-4 fw-bold">Admin Panel</h4>
            <hr class="text-secondary">
            <nav>
                <a href="${pageContext.request.contextPath}/admin-dashboard"><i class="bi bi-speedometer2 me-2"></i> Özet Tablo</a>
                <a href="${pageContext.request.contextPath}/admin-category"><i class="bi bi-tags me-2"></i> Kategoriler</a>
                <a href="${pageContext.request.contextPath}/admin-product"><i class="bi bi-box-seam me-2"></i> Ürünler</a>
                <a href="${pageContext.request.contextPath}/admin-order"><i class="bi bi-cart-check me-2"></i> Siparişler</a>
                <a href="${pageContext.request.contextPath}/admin-user" class="active"><i class="bi bi-people me-2"></i> Kullanıcılar</a>
            </nav>
            <hr class="text-secondary mt-5">
           <a href="${pageContext.request.contextPath}/admin-login?action=logout" class="text-danger"><i class="bi bi-box-arrow-left me-2"></i> Çıkış Yap</a>
        </div>

        <div class="col-md-10 p-4">
            <h2 class="fw-bold mb-4">Müşteri ve Kullanıcı Listesi</h2>
            <div class="card shadow-sm">
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0 text-center">
                            <thead class="table-dark">
                                <tr>
                                    <th>ID</th>
                                    <th class="text-start">Ad Soyad</th>
                                    <th>E-Posta</th>
                                    <th>Telefon</th>
                                    <th>Rol</th>
                                    <th>Kayıt Tarihi</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="user" items="${listUser}">
                                    <tr>
                                        <td class="fw-bold">${user.id}</td>
                                        <td class="text-start">${user.fullName}</td>
                                        <td>${user.email}</td>
                                        <td>${user.phone != null ? user.phone : '-'}</td>
                                        <td>
                                            <span class="badge ${user.role == 'ADMIN' ? 'bg-danger' : 'bg-primary'}">
                                                ${user.role}
                                            </span>
                                        </td>
                                        <td><fmt:formatDate value="${user.createdAt}" pattern="dd.MM.yyyy"/></td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>