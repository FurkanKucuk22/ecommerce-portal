<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <title>Sipariş Yönetimi - Admin Paneli</title>
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
                <a href="${pageContext.request.contextPath}/admin-order" class="active"><i class="bi bi-cart-check me-2"></i> Siparişler</a>
                <a href="${pageContext.request.contextPath}/admin-user"><i class="bi bi-people me-2"></i> Kullanıcılar</a>
            </nav>
            <hr class="text-secondary mt-5">
            <a href="${pageContext.request.contextPath}/admin-login?action=logout" class="text-danger"><i class="bi bi-box-arrow-left me-2"></i> Çıkış Yap</a>
        </div> <div class="col-md-10 p-4">
            <div class="mb-4">
                <h2 class="fw-bold">Sipariş Yönetimi</h2>
                <p class="text-muted">Müşterilerin verdiği tüm siparişleri buradan takip edip durumlarını güncelleyebilirsiniz.</p>
            </div>

            <div class="card shadow-sm">
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0 text-center">
                            <thead class="table-dark">
                                <tr>
                                    <th>Sipariş No</th>
                                    <th>Müşteri ID</th>
                                    <th>Tarih</th>
                                    <th>Toplam Tutar</th>
                                    <th>Sipariş Durumu</th>
                                    <th>İşlemler (Durum Güncelle)</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="order" items="${listOrder}">
                                    <tr>
                                        <td class="fw-bold">
                                            <a href="${pageContext.request.contextPath}/admin-order?action=detail&id=${order.id}" class="text-decoration-none">
                                                #${order.id} <i class="bi bi-box-arrow-up-right ms-1" style="font-size: 0.8rem;"></i>
                                            </a>
                                        </td>
                                        <td>${order.userId}</td>
                                        <td><fmt:formatDate value="${order.orderDate}" pattern="dd.MM.yyyy HH:mm"/></td>
                                        <td class="text-primary fw-bold">
                                            <fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₺" />
                                        </td>
                                        
                                        <td>
                                            <c:choose>
                                                <c:when test="${order.status == 'Beklemede'}">
                                                    <span class="badge bg-warning text-dark px-3 py-2">Beklemede</span>
                                                </c:when>
                                                <c:when test="${order.status == 'Hazirlaniyor'}">
                                                    <span class="badge bg-info text-dark px-3 py-2">Hazirlaniyor</span>
                                                </c:when>
                                                <c:when test="${order.status == 'Kargoya Verildi'}">
                                                    <span class="badge bg-primary px-3 py-2">Kargoya Verildi</span>
                                                </c:when>
                                                <c:when test="${order.status == 'Teslim Edildi'}">
                                                    <span class="badge bg-success px-3 py-2">Teslim Edildi</span>
                                                </c:when>
                                                <c:when test="${order.status == 'Iptal Edildi'}">
                                                    <span class="badge bg-danger px-3 py-2">Iptal Edildi</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-secondary px-3 py-2">${order.status}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        
                                        <td>
                                            <form action="${pageContext.request.contextPath}/admin-order" method="post" class="d-flex justify-content-center">
                                                <input type="hidden" name="action" value="updateStatus">
                                                <input type="hidden" name="orderId" value="${order.id}">
                                                
                                                <select name="status" class="form-select form-select-sm w-auto d-inline-block me-2">
                                                    <option value="Beklemede" ${order.status == 'Beklemede' ? 'selected' : ''}>Beklemede</option>
                                                    <option value="Hazirlaniyor" ${order.status == 'Hazirlaniyor' ? 'selected' : ''}>Hazirlaniyor</option>
                                                    <option value="Kargoya Verildi" ${order.status == 'Kargoya Verildi' ? 'selected' : ''}>Kargoya Verildi</option>
                                                    <option value="Teslim Edildi" ${order.status == 'Teslim Edildi' ? 'selected' : ''}>Teslim Edildi</option>
                                                    <option value="Iptal Edildi" ${order.status == 'Iptal Edildi' ? 'selected' : ''}>Iptal Edildi</option>
                                                </select>
                                                
                                                <button type="submit" class="btn btn-sm btn-success">Güncelle</button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty listOrder}">
                                    <tr>
                                        <td colspan="6" class="text-center p-4 text-muted">Sistemde henüz verilmiş bir sipariş bulunmamaktadır.</td>
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