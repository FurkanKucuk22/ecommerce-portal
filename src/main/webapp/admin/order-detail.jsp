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
    <title>Sipariş Detayı - Admin Paneli</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        body { background-color: #f8f9fa; }
        .sidebar { min-height: 100vh; background-color: #212529; color: white; }
        .sidebar a { color: #adb5bd; text-decoration: none; padding: 10px 15px; display: block; border-radius: 5px; margin-bottom: 5px;}
        .sidebar a:hover, .sidebar a.active { background-color: #0d6efd; color: white; }
        .product-img { width: 60px; height: 60px; object-fit: cover; border-radius: 5px; }
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
                <a href="${pageContext.request.contextPath}/admin-order" class="active"><i class="bi bi-cart-check me-2"></i> Siparişler</a>
                <a href="${pageContext.request.contextPath}/admin-user"><i class="bi bi-people me-2"></i> Kullanıcılar</a>
            </nav>
            <hr class="text-secondary mt-5">
            <a href="${pageContext.request.contextPath}/admin-login?action=logout" class="text-danger"><i class="bi bi-box-arrow-left me-2"></i> Çıkış Yap</a>
        </div>

        <div class="col-md-10 p-4">
            <div class="mb-4 d-flex justify-content-between align-items-center">
                <div>
                    <h2 class="fw-bold">Sipariş İçeriği</h2>
                    <p class="text-muted">Bu siparişte yer alan ürünlerin detaylı listesi.</p>
                </div>
                <a href="${pageContext.request.contextPath}/admin-order" class="btn btn-outline-secondary fw-bold">
                    <i class="bi bi-arrow-left me-1"></i> Siparişlere Dön
                </a>
            </div>

            <div class="card shadow-sm">
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0 text-center">
                            <thead class="table-dark">
                                <tr>
                                    <th>Görsel</th>
                                    <th class="text-start">Ürün Adı</th>
                                    <th>Birim Fiyat</th>
                                    <th>Adet</th>
                                    <th>Ara Toplam</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="item" items="${items}">
                                    <tr>
                                        <td>
                                            <img src="${not empty item.product.imageUrl ? item.product.imageUrl : 'https://via.placeholder.com/60'}" 
                                                 alt="${item.product.name}" class="product-img border">
                                        </td>
                                        <td class="text-start fw-bold">${item.product.name}</td>
                                        <td>
                                            <fmt:formatNumber value="${item.unitPrice}" type="currency" currencySymbol="₺" />
                                        </td>
                                        <td><span class="badge bg-secondary fs-6">${item.quantity}</span></td>
                                        <td class="text-success fw-bold fs-6">
                                            <fmt:formatNumber value="${item.subtotal}" type="currency" currencySymbol="₺" />
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty items}">
                                    <tr>
                                        <td colspan="5" class="text-center p-4 text-muted">Bu siparişe ait ürün detayı bulunamadı.</td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>