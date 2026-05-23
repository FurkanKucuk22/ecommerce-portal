<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>E-Ticaret Portalı</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
</head>
<body class="bg-light">

    <nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-4">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/home">E-Ticaret Portalı</a>
            <div class="collapse navbar-collapse">
                <ul class="navbar-nav ms-auto">
                    <c:choose>
                        <c:when test="${not empty sessionScope.loggedInUser}">
                            <li class="nav-item">
                                <span class="nav-link text-white fw-bold">Merhaba, ${sessionScope.loggedInUser.fullName}</span>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/order">Siparişlerim</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/cart">Sepetim</a>
                            </li>                            
                            <li class="nav-item">
                                <a class="nav-link text-danger" href="${pageContext.request.contextPath}/login?action=logout">Çıkış Yap</a>
                            </li>
                        </c:when>
                        <c:otherwise>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/login">Giriş Yap</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/register">Kayıt Ol</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/cart">Sepetim</a>
                            </li>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container">
        
        <c:if test="${param.order == 'success'}">
            <div class="alert alert-success fw-bold text-center mb-4 shadow-sm" role="alert">
                🎉 Siparişiniz başarıyla alındı!
            </div>
        </c:if>

        <h2 class="mb-4">Ürünler</h2>
        
        <div class="row mb-4">
            <div class="col-md-8">
                <form action="${pageContext.request.contextPath}/home" method="GET">
                    <div class="input-group shadow-sm">
                        <input type="text" class="form-control form-control-lg" name="search" 
                               placeholder="Ürün adı veya açıklamasında ara..." value="<c:out value='${searchQuery}'/>">
                        <button class="btn btn-primary px-4" type="submit">
                            <i class="bi bi-search me-1"></i> Ara
                        </button>
                        <c:if test="${not empty searchQuery}">
                            <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-secondary px-3" title="Aramayı Temizle">
                                <i class="bi bi-x-lg"></i>
                            </a>
                        </c:if>
                    </div>
                </form>
            </div>
        </div>
        <div class="mb-4 pb-2 border-bottom">
            <a href="${pageContext.request.contextPath}/home" 
               class="btn ${empty selectedCategoryId && empty searchQuery ? 'btn-primary' : 'btn-outline-primary'} btn-sm me-2 mb-2">
                Tüm Ürünler
            </a>
            <c:forEach var="category" items="${categoryList}">
                <a href="${pageContext.request.contextPath}/home?categoryId=${category.id}" 
                   class="btn ${selectedCategoryId == category.id ? 'btn-primary' : 'btn-outline-primary'} btn-sm me-2 mb-2">
                    ${category.name}
                </a>
            </c:forEach>
        </div>
        
        <c:if test="${not empty searchQuery}">
            <p class="text-muted fw-bold mb-4">
                "<span class="text-primary">${searchQuery}</span>" için arama sonuçları gösteriliyor.
            </p>
        </c:if>

        <div class="row">
            <c:forEach var="product" items="${products}">
                <div class="col-md-4 mb-4">
                    <div class="card h-100 shadow-sm">
                        <img src="${not empty product.imageUrl ? product.imageUrl : 'https://via.placeholder.com/300x200?text=Gorsel+Yok'}" 
                             class="card-img-top" alt="${product.name}" style="height: 200px; object-fit: cover;">
                        
                        <div class="card-body d-flex flex-column">
                            <h5 class="card-title">${product.name}</h5>
                            <p class="card-text text-muted small">${product.description}</p>
                            
                            <h4 class="text-primary mt-auto">
                                <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="₺" />
                            </h4>
                            
                            <c:choose>
                                <c:when test="${product.stock > 0}">
                                    <p class="text-success small fw-bold">Stokta: ${product.stock} adet</p>
                                    <div class="d-flex justify-content-between mt-2">
                                        <a href="${pageContext.request.contextPath}/product-detail?id=${product.id}" class="btn btn-outline-secondary w-50 me-1">Detay</a>
                                        
                                        <form action="${pageContext.request.contextPath}/cart" method="post" class="w-50 ms-1">
                                            <input type="hidden" name="productId" value="${product.id}">
                                            <input type="hidden" name="action" value="add">
                                            <button type="submit" class="btn btn-primary w-100">Sepete Ekle</button>
                                        </form>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <p class="text-danger small fw-bold">Stokta Yok</p>
                                    <div class="d-flex justify-content-between mt-2">
                                        <a href="${pageContext.request.contextPath}/product-detail?id=${product.id}" class="btn btn-outline-secondary w-100">Detay</a>
                                        <button class="btn btn-secondary w-100 ms-2" disabled>Tükendi</button>
                                    </div>
                                </c:otherwise>
                            </c:choose>

                        </div>
                    </div>
                </div>
            </c:forEach>
            
            <c:if test="${empty products}">
                <div class="col-12">
                    <div class="alert alert-warning" role="alert">
                        <c:choose>
                            <c:when test="${not empty searchQuery}">
                                Aradığınız "<b>${searchQuery}</b>" kelimesine uygun ürün bulunamadı.
                            </c:when>
                            <c:otherwise>
                                Henüz bu kategoride sisteme eklenmiş bir ürün bulunmamaktadır.
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </c:if>
        </div>

        <c:if test="${empty searchQuery && empty selectedCategoryId && noOfPages > 1}">
            <nav aria-label="Page navigation" class="mt-4 mb-5">
                <ul class="pagination justify-content-center shadow-sm">
                    
                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                        <a class="page-link" href="${pageContext.request.contextPath}/home?page=${currentPage - 1}">Önceki</a>
                    </li>
                    
                    <c:forEach begin="1" end="${noOfPages}" var="i">
                        <li class="page-item ${currentPage == i ? 'active' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/home?page=${i}">${i}</a>
                        </li>
                    </c:forEach>
                    
                    <li class="page-item ${currentPage == noOfPages ? 'disabled' : ''}">
                        <a class="page-link" href="${pageContext.request.contextPath}/home?page=${currentPage + 1}">Sonraki</a>
                    </li>
                    
                </ul>
            </nav>
        </c:if>

    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>