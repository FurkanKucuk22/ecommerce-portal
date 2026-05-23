<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <title>${product != null ? 'Ürün Düzenle' : 'Yeni Ürün Ekle'} - Admin Paneli</title>
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
                <a href="${pageContext.request.contextPath}/admin-product" class="active"><i class="bi bi-box-seam me-2"></i> Ürünler</a>
                <a href="${pageContext.request.contextPath}/admin-order"><i class="bi bi-cart-check me-2"></i> Siparişler</a>
                <a href="${pageContext.request.contextPath}/admin-user"><i class="bi bi-people me-2"></i> Kullanıcılar</a>
            </nav>
            <hr class="text-secondary mt-5">
            <a href="${pageContext.request.contextPath}/admin-login?action=logout" class="text-danger"><i class="bi bi-box-arrow-left me-2"></i> Çıkış Yap</a>
        </div>

        <div class="col-md-10 p-4">
            <div class="mb-4 d-flex justify-content-between align-items-center">
                <h2 class="fw-bold">${product != null ? 'Ürün Düzenle' : 'Yeni Ürün Ekle'}</h2>
                <a href="${pageContext.request.contextPath}/admin-product" class="btn btn-outline-secondary">
                    <i class="bi bi-arrow-left me-1"></i> İptal ve Geri Dön
                </a>
            </div>

            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger fw-bold shadow-sm" role="alert">
                    <i class="bi bi-exclamation-triangle-fill me-2"></i> ${errorMessage}
                </div>
            </c:if>

            <div class="card shadow-sm" style="max-width: 800px;">
                <div class="card-body p-4">
                    <form action="${pageContext.request.contextPath}/admin-product" method="post">
                        
                        <c:if test="${product != null}">
                            <input type="hidden" name="action" value="update" />
                            <input type="hidden" name="id" value="${product.id}" />
                        </c:if>
                        <c:if test="${product == null}">
                            <input type="hidden" name="action" value="insert" />
                        </c:if>

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="name" class="form-label fw-bold">Ürün Adı <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="name" name="name" 
                                       value="<c:out value='${product.name}' />" required>
                            </div>
                            <div class="col-md-6">
                                <label for="categoryId" class="form-label fw-bold">Kategori <span class="text-danger">*</span></label>
                                <select class="form-select" id="categoryId" name="categoryId" required>
                                    <option value="">Seçiniz...</option>
                                    <c:forEach var="cat" items="${listCategory}">
                                        <c:if test="${cat.active || (product != null && product.categoryId == cat.id)}">
                                            <option value="${cat.id}" ${product != null && product.categoryId == cat.id ? 'selected' : ''}>
                                                ${cat.name}
                                            </option>
                                        </c:if>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="price" class="form-label fw-bold">Fiyat (₺) <span class="text-danger">*</span></label>
                                <input type="number" step="0.01" min="0.01" class="form-control" id="price" name="price" 
                                       value="${product != null ? product.price : ''}" required>
                            </div>
                            <div class="col-md-6">
                                <label for="stock" class="form-label fw-bold">Stok Miktarı <span class="text-danger">*</span></label>
                                <input type="number" min="0" class="form-control" id="stock" name="stock" 
                                       value="${product != null ? product.stock : '0'}" required>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="imageUrl" class="form-label fw-bold">Görsel URL'si</label>
                            <input type="text" class="form-control" id="imageUrl" name="imageUrl" 
                                   value="<c:out value='${product.imageUrl}' />" placeholder="https://ornek.com/resim.jpg">
                            <small class="text-muted">Proje gereği resimler bilgisayara yüklenmek yerine link (URL) olarak veritabanında tutulmaktadır.</small>
                        </div>

                        <div class="mb-3">
                            <label for="description" class="form-label fw-bold">Ürün Açıklaması</label>
                            <textarea class="form-control" id="description" name="description" rows="4"><c:out value='${product.description}' /></textarea>
                        </div>

                        <div class="mb-4 form-check form-switch">
                            <input class="form-check-input" type="checkbox" role="switch" id="isActive" name="isActive" 
                                   <c:if test="${product == null || product.active}">checked</c:if> >
                            <label class="form-check-label fw-bold" for="isActive">Satışa Açık (Sitede Görünsün)</label>
                        </div>

                        <button type="submit" class="btn btn-success w-100 fw-bold fs-5">
                            <i class="bi bi-save me-1"></i> ${product != null ? 'Değişiklikleri Kaydet' : 'Ürünü Ekle'}
                        </button>
                    </form>
                </div>
            </div>

        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>