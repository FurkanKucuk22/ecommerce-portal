<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <title>Sepetim - E-Ticaret Portalı</title>
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
                                <a class="nav-link" href="order">Siparişlerim</a>
                            </li>
                        </c:when>
                        <c:otherwise>
                            <li class="nav-item"><a class="nav-link" href="login.jsp">Giriş Yap</a></li>
                        </c:otherwise>
                    </c:choose>
                    <li class="nav-item"><a class="nav-link btn btn-outline-light ms-2" href="cart.jsp">Sepetim</a></li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container">
        <h2 class="mb-4">Alışveriş Sepetim</h2>
        
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger text-center fw-bold shadow-sm" role="alert">
                ${errorMessage}
            </div>
        </c:if>

        <c:choose>
            <c:when test="${empty sessionScope.cart}">
                <div class="alert alert-warning text-center p-5 shadow-sm" role="alert">
                    <h4>Sepetiniz şu an boş.</h4>
                    <p>Hemen alışverişe başlayıp sepetinizi doldurun!</p>
                    <a href="${pageContext.request.contextPath}/home" class="btn btn-primary mt-3 fw-bold">Ürünlere Git</a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="row">
                    <div class="col-md-8">
                        <table class="table table-hover bg-white shadow-sm align-middle text-center">
                            <thead class="table-light">
                                <tr>
                                    <th class="text-start">Ürün</th>
                                    <th>Fiyat</th>
                                    <th>Adet</th>
                                    <th>Toplam</th>
                                    <th>İşlem</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:set var="grandTotal" value="0" />
                                
                                <c:forEach var="item" items="${sessionScope.cart}">
                                    <tr>
                                        <td class="text-start fw-bold">${item.product.name}</td>
                                        <td>
                                            <fmt:formatNumber value="${item.product.price}" type="currency" currencySymbol="₺" />
                                        </td>
                                        
                                        <td>
                                            <div class="d-flex justify-content-center align-items-center">
                                                <form action="cart" method="post" class="m-0">
                                                    <input type="hidden" name="productId" value="${item.product.id}">
                                                    <input type="hidden" name="action" value="update">
                                                    <input type="hidden" name="quantity" value="${item.quantity - 1}">
                                                    <button type="submit" class="btn btn-sm btn-outline-secondary rounded-circle" 
                                                            style="width: 30px; height: 30px; padding: 0;"
                                                            ${item.quantity <= 1 ? 'disabled' : ''} title="Azalt">
                                                        <i class="bi bi-dash"></i>
                                                    </button>
                                                </form>

                                                <span class="mx-3 fw-bold fs-5">${item.quantity}</span>

                                                <form action="cart" method="post" class="m-0">
                                                    <input type="hidden" name="productId" value="${item.product.id}">
                                                    <input type="hidden" name="action" value="update">
                                                    <input type="hidden" name="quantity" value="${item.quantity + 1}">
                                                    <button type="submit" class="btn btn-sm btn-outline-secondary rounded-circle" 
                                                            style="width: 30px; height: 30px; padding: 0;"
                                                            ${item.quantity >= item.product.stock ? 'disabled' : ''} title="Artır">
                                                        <i class="bi bi-plus"></i>
                                                    </button>
                                                </form>
                                            </div>
                                        </td>
                                        
                                        <td class="text-primary fw-bold">
                                            <fmt:formatNumber value="${item.totalPrice}" type="currency" currencySymbol="₺" />
                                        </td>
                                        
                                        <td>
                                            <form action="cart" method="post" class="m-0">
                                                <input type="hidden" name="productId" value="${item.product.id}">
                                                <input type="hidden" name="action" value="remove">
                                                <button type="submit" class="btn btn-sm btn-danger" title="Sepetten Çıkar">
                                                    <i class="bi bi-trash3-fill"></i>
                                                </button>
                                            </form>
                                        </td>
                                    </tr>
                                    <c:set var="grandTotal" value="${grandTotal + item.totalPrice}" />
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                    
                    <div class="col-md-4">
                        <div class="card shadow-sm">
                            <div class="card-header bg-dark text-white fw-bold">
                                Sipariş Özeti
                            </div>
                            <div class="card-body">
                                <h5 class="card-title d-flex justify-content-between">
                                    <span>Ara Toplam:</span>
                                    <span class="text-primary fw-bold">
                                        <fmt:formatNumber value="${grandTotal}" type="currency" currencySymbol="₺" />
                                    </span>
                                </h5>
                                <hr>
                                <form action="order" method="post" class="m-0 mb-2">
                                    <button type="submit" class="btn btn-success w-100 fw-bold">Ödemeye Geç</button>
                                </form>
                                <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-secondary w-100 fw-bold">Alışverişe Devam Et</a>
                            </div>
                        </div>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>