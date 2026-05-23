<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <title>${product.name} - E-Ticaret Portalı</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

    <nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-5">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/home">E-Ticaret Portalı</a>
            <div class="collapse navbar-collapse">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item"><a class="nav-link" href="login.jsp">Giriş Yap</a></li>
                    <li class="nav-item"><a class="nav-link btn btn-outline-light ms-2" href="cart.jsp">Sepetim</a></li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container bg-white p-5 rounded shadow-sm">
        <div class="row">
            <div class="col-md-6 text-center mb-4 mb-md-0">
                <img src="${not empty product.imageUrl ? product.imageUrl : 'https://via.placeholder.com/500x500?text=Gorsel+Yok'}" 
                     class="img-fluid rounded" alt="${product.name}" style="max-height: 500px; object-fit: contain;">
            </div>
            
            <div class="col-md-6 d-flex flex-column justify-content-center">
                
                <a href="${pageContext.request.contextPath}/home" class="text-decoration-none text-muted mb-3">
                    &larr; Tüm Ürünlere Dön
                </a>

                <h1 class="display-5 fw-bold mb-3">${product.name}</h1>
                
                <h2 class="text-primary fw-bold mb-4">
                    <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="₺" />
                </h2>
                
                <div class="mb-4">
                    <h5 class="fw-bold border-bottom pb-2">Ürün Açıklaması</h5>
                    <p class="text-muted" style="line-height: 1.8;">
                        ${product.description}
                    </p>
                </div>
                
                <c:choose>
                    <c:when test="${product.stock > 0}">
                        <div class="alert alert-success d-inline-block py-2 px-3 mb-4">
                            <strong>Stok Durumu:</strong> Mevcut (${product.stock} adet)
                        </div>
                        
                        <form action="cart" method="post" class="mt-auto">
                            <input type="hidden" name="productId" value="${product.id}">
                            <input type="hidden" name="action" value="add">
                            <button type="submit" class="btn btn-primary btn-lg w-100 fw-bold shadow-sm">
                                Hemen Sepete Ekle
                            </button>
                        </form>
                    </c:when>
                    <c:otherwise>
                        <div class="alert alert-danger d-inline-block py-2 px-3 mb-4">
                            <strong>Stok Durumu:</strong> Maalesef Tükendi
                        </div>
                        <button class="btn btn-secondary btn-lg w-100 fw-bold mt-auto" disabled>
                            Stokta Yok
                        </button>
                    </c:otherwise>
                </c:choose>

            </div>
        </div>
    </div>

</body>
</html>