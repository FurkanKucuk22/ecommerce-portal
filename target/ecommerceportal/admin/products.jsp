<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <title>Ürün Yönetimi - Admin Paneli</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        body { background-color: #f8f9fa; }
        .sidebar { min-height: 100vh; background-color: #212529; color: white; }
        .sidebar a { color: #adb5bd; text-decoration: none; padding: 10px 15px; display: block; border-radius: 5px; margin-bottom: 5px;}
        .sidebar a:hover, .sidebar a.active { background-color: #0d6efd; color: white; }
        .product-img { width: 50px; height: 50px; object-fit: cover; border-radius: 5px; }
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
                <a href="${pageContext.request.contextPath}/admin-product" class="active"><i class="bi bi-box-seam me-2"></i> Ürünler</a>
                <a href="${pageContext.request.contextPath}/admin-order"><i class="bi bi-cart-check me-2"></i> Siparişler</a>
                <a href="${pageContext.request.contextPath}/admin-user"><i class="bi bi-people me-2"></i> Kullanıcılar</a>
            </nav>
            <hr class="text-secondary mt-5">
            <a href="${pageContext.request.contextPath}/admin-login?action=logout" class="text-danger"><i class="bi bi-box-arrow-left me-2"></i> Çıkış Yap</a>
        </div>

        <div class="col-md-10 p-4">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2 class="fw-bold">Ürün Yönetimi</h2>
                <a href="${pageContext.request.contextPath}/admin-product?action=new" class="btn btn-primary fw-bold">
                    <i class="bi bi-plus-lg me-1"></i> Yeni Ürün Ekle
                </a>
            </div>

            <div class="card shadow-sm">
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0 text-center">
                            <thead class="table-dark">
                                <tr>
                                    <th>Görsel</th>
                                    <th>ID</th>
                                    <th class="text-start">Ürün Adı</th>
                                    <th>Kategori</th>
                                    <th>Fiyat</th>
                                    <th>Stok</th>
                                    <th>Durum</th>
                                    <th>İşlemler</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="prod" items="${listProduct}">
                                    <tr>
                                        <td>
                                            <img src="${not empty prod.imageUrl ? prod.imageUrl : 'https://via.placeholder.com/50'}" alt="${prod.name}" class="product-img">
                                        </td>
                                        <td class="fw-bold">${prod.id}</td>
                                        <td class="text-start fw-bold">${prod.name}</td>
                                        
                                        <td>
                                            <c:set var="catName" value="Bilinmiyor" />
                                            <c:forEach var="cat" items="${listCategory}">
                                                <c:if test="${cat.id == prod.categoryId}">
                                                    <c:set var="catName" value="${cat.name}" />
                                                </c:if>
                                            </c:forEach>
                                            <span class="badge bg-secondary">${catName}</span>
                                        </td>

                                        <td class="text-primary fw-bold">
                                            <fmt:formatNumber value="${prod.price}" type="currency" currencySymbol="₺" />
                                        </td>
                                        
                                        <td>
                                            <c:choose>
                                                <c:when test="${prod.stock > 10}">
                                                    <span class="text-success fw-bold">${prod.stock}</span>
                                                </c:when>
                                                <c:when test="${prod.stock > 0 && prod.stock <= 10}">
                                                    <span class="text-warning fw-bold">${prod.stock}</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-danger fw-bold">Tükendi (0)</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        
                                        <td>
                                            <span class="badge ${prod.active ? 'bg-success' : 'bg-danger'}">
                                                ${prod.active ? 'Aktif' : 'Pasif'}
                                            </span>
                                        </td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/admin-product?action=edit&id=${prod.id}" class="btn btn-sm btn-outline-primary" title="Düzenle">
                                                <i class="bi bi-pencil-square"></i>
                                            </a>
                                            <a href="${pageContext.request.contextPath}/admin-product?action=delete&id=${prod.id}" 
                                               class="btn btn-sm btn-outline-danger ms-1" 
                                               onclick="return confirm('Bu ürünü silmek istediğinize emin misiniz?');" title="Sil">
                                                <i class="bi bi-trash"></i>
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty listProduct}">
                                    <tr>
                                        <td colspan="8" class="text-center p-4 text-muted">Sistemde henüz kayıtlı ürün bulunmamaktadır.</td>
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