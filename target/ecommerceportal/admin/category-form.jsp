<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <title>${category != null ? 'Kategori Düzenle' : 'Yeni Kategori Ekle'} - Admin Paneli</title>
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
                <a href="${pageContext.request.contextPath}/admin-category" class="active"><i class="bi bi-tags me-2"></i> Kategoriler</a>
                <a href="${pageContext.request.contextPath}/admin-product"><i class="bi bi-box-seam me-2"></i> Ürünler</a>
                <a href="${pageContext.request.contextPath}/admin-order"><i class="bi bi-cart-check me-2"></i> Siparişler</a>
                <a href="${pageContext.request.contextPath}/admin-user"><i class="bi bi-people me-2"></i> Kullanıcılar</a>
            </nav>
            <hr class="text-secondary mt-5">
            <a href="${pageContext.request.contextPath}/admin-login?action=logout" class="text-danger"><i class="bi bi-box-arrow-left me-2"></i> Çıkış Yap</a>
        </div>

        <div class="col-md-10 p-4">
            <div class="mb-4 d-flex justify-content-between align-items-center">
                <h2 class="fw-bold">${category != null ? 'Kategori Düzenle' : 'Yeni Kategori Ekle'}</h2>
                <a href="${pageContext.request.contextPath}/admin-category" class="btn btn-outline-secondary">
                    <i class="bi bi-arrow-left me-1"></i> İptal ve Geri Dön
                </a>
            </div>

            <div class="card shadow-sm" style="max-width: 600px;">
                <div class="card-body p-4">
                    <form action="${pageContext.request.contextPath}/admin-category" method="post">
                        <c:if test="${category != null}">
                            <input type="hidden" name="action" value="update" />
                            <input type="hidden" name="id" value="${category.id}" />
                        </c:if>
                        <c:if test="${category == null}">
                            <input type="hidden" name="action" value="insert" />
                        </c:if>

                        <div class="mb-3">
                            <label for="name" class="form-label fw-bold">Kategori Adı <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="name" name="name" 
                                   value="<c:out value='${category.name}' />" required>
                        </div>

                        <div class="mb-3">
                            <label for="description" class="form-label fw-bold">Açıklama</label>
                            <textarea class="form-control" id="description" name="description" rows="3"><c:out value='${category.description}' /></textarea>
                        </div>

                        <div class="mb-4 form-check form-switch">
                            <input class="form-check-input" type="checkbox" role="switch" id="isActive" name="isActive" 
                                   <c:if test="${category == null || category.active}">checked</c:if> >
                            <label class="form-check-label fw-bold" for="isActive">Aktif Kategori (Sitede Görünsün)</label>
                        </div>

                        <button type="submit" class="btn btn-success w-100 fw-bold">
                            <i class="bi bi-save me-1"></i> ${category != null ? 'Değişiklikleri Kaydet' : 'Kategoriyi Ekle'}
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