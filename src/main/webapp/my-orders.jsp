<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <title>Siparişlerim - E-Ticaret Portalı</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

    <nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-4">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/home">E-Ticaret Portalı</a>
            <div class="collapse navbar-collapse">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <span class="nav-link text-white fw-bold">Merhaba, ${sessionScope.loggedInUser.fullName}</span>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="order">Siparişlerim</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link btn btn-outline-light ms-2" href="cart.jsp">Sepetim</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container">
        <h2 class="mb-4">Geçmiş Siparişlerim</h2>

        <c:choose>
            <c:when test="${empty myOrders}">
                <div class="alert alert-info text-center p-5 shadow-sm" role="alert">
                    <h4>Henüz hiç sipariş vermediniz.</h4>
                    <p>Alışverişe başlamak için ürünlerimize göz atın.</p>
                    <a href="${pageContext.request.contextPath}/home" class="btn btn-primary mt-2">Alışverişe Başla</a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="table-responsive">
                    <table class="table table-hover bg-white shadow-sm align-middle text-center">
                        <thead class="table-dark">
                            <tr>
                                <th>Sipariş No</th>
                                <th>Tarih</th>
                                <th>Toplam Tutar</th>
                                <th>Durum</th>
                                <th>İşlem</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="order" items="${myOrders}">
                                <tr>
                                    <td class="fw-bold">#${order.id}</td>
                                    <td><fmt:formatDate value="${order.orderDate}" pattern="dd.MM.yyyy HH:mm" /></td>
                                    <td class="fw-bold text-primary">
                                        <fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₺" />
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${order.status == 'Beklemede'}">
                                                <span class="badge bg-warning text-dark">${order.status}</span>
                                            </c:when>
                                            <c:when test="${order.status == 'Hazirlaniyor'}">
                                                <span class="badge bg-info text-dark">${order.status}</span>
                                            </c:when>
                                            <c:when test="${order.status == 'Tamamlandi'}">
                                                <span class="badge bg-success">${order.status}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary">${order.status}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <button type="button" class="btn btn-sm btn-outline-primary fw-bold" 
                                                data-bs-toggle="modal" data-bs-target="#orderModal${order.id}">
                                            Detay Gör
                                        </button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <c:forEach var="order" items="${myOrders}">
                    <div class="modal fade" id="orderModal${order.id}" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog modal-lg modal-dialog-centered">
                            <div class="modal-content">
                                <div class="modal-header bg-dark text-white">
                                    <h5 class="modal-title fw-bold">Sipariş Detayı (#${order.id})</h5>
                                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Kapat"></button>
                                </div>
                                <div class="modal-body">
                                    <table class="table table-bordered align-middle text-center mb-0">
                                        <thead class="table-light">
                                            <tr>
                                                <th>Görsel</th>
                                                <th class="text-start">Ürün Adı</th>
                                                <th>Birim Fiyat</th>
                                                <th>Adet</th>
                                                <th>Ara Toplam</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="item" items="${order.items}">
                                                <tr>
                                                    <td>
                                                        <img src="${not empty item.product.imageUrl ? item.product.imageUrl : 'https://via.placeholder.com/50x50?text=Yok'}" 
                                                             alt="${item.product.name}" style="width: 50px; height: 50px; object-fit: cover; border-radius: 5px;">
                                                    </td>
                                                    <td class="text-start fw-bold">${item.product.name}</td>
                                                    <td><fmt:formatNumber value="${item.unitPrice}" type="currency" currencySymbol="₺" /></td>
                                                    <td>${item.quantity}</td>
                                                    <td class="text-primary fw-bold">
                                                        <fmt:formatNumber value="${item.subtotal}" type="currency" currencySymbol="₺" />
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                                <div class="modal-footer d-flex justify-content-between align-items-center bg-light">
                                    <small class="text-muted">Sipariş Tarihi: <fmt:formatDate value="${order.orderDate}" pattern="dd.MM.yyyy HH:mm" /></small>
                                    <h5 class="mb-0 m-0">Genel Toplam: <span class="text-success fw-bold"><fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₺" /></span></h5>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>

            </c:otherwise>
        </c:choose>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>