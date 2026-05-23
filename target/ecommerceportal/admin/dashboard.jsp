<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <title>Yönetim Paneli - E-Ticaret</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        body { background-color: #f8f9fa; }
        .sidebar { min-height: 100vh; background-color: #212529; color: white; }
        .sidebar a { color: #adb5bd; text-decoration: none; padding: 10px 15px; display: block; border-radius: 5px; margin-bottom: 5px;}
        .sidebar a:hover, .sidebar a.active { background-color: #0d6efd; color: white; }
        .dashboard-card { border-left: 5px solid #0d6efd; }
    </style>
</head>
<body>

<div class="container-fluid">
    <div class="row">
        <div class="col-md-2 sidebar p-3 shadow">
            <h4 class="text-center text-white mb-4 fw-bold">Admin Panel</h4>
            <hr class="text-secondary">
            <nav>
                <a href="${pageContext.request.contextPath}/admin-dashboard" class="active"><i class="bi bi-speedometer2 me-2"></i> Özet Tablo</a>
                <a href="${pageContext.request.contextPath}/admin-category"><i class="bi bi-tags me-2"></i> Kategoriler</a>
                <a href="${pageContext.request.contextPath}/admin-product"><i class="bi bi-box-seam me-2"></i> Ürünler</a>
                <a href="${pageContext.request.contextPath}/admin-order"><i class="bi bi-cart-check me-2"></i> Siparişler</a>
                <a href="${pageContext.request.contextPath}/admin-user"><i class="bi bi-people me-2"></i> Kullanıcılar</a>
            </nav>
            <hr class="text-secondary mt-5">
            <a href="${pageContext.request.contextPath}/admin-login?action=logout" class="text-danger"><i class="bi bi-box-arrow-left me-2"></i> Çıkış Yap</a>
        </div>

        <div class="col-md-10 p-4">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2 class="fw-bold">Hoş Geldiniz, ${sessionScope.adminUser.fullName}</h2>
                <span class="badge bg-primary fs-6">Yetki: Sistem Yöneticisi</span>
            </div>

            <div class="row g-4 mb-4">
                <div class="col-md-3">
                    <div class="card shadow-sm dashboard-card border-primary">
                        <div class="card-body d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="text-muted fw-bold">Toplam Ürün</h6>
                                <h2 class="fw-bold mb-0 text-primary">${stats.totalProducts != null ? stats.totalProducts : 0}</h2>
                            </div>
                            <i class="bi bi-box-seam fs-1 text-primary"></i>
                        </div>
                    </div>
                </div>
                
                <div class="col-md-3">
                    <div class="card shadow-sm dashboard-card border-success">
                        <div class="card-body d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="text-muted fw-bold">Kategori</h6>
                                <h2 class="fw-bold mb-0 text-success">${stats.totalCategories != null ? stats.totalCategories : 0}</h2>
                            </div>
                            <i class="bi bi-tags fs-1 text-success"></i>
                        </div>
                    </div>
                </div>

                <div class="col-md-3">
                    <div class="card shadow-sm dashboard-card border-info">
                        <div class="card-body d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="text-muted fw-bold">Müşteri</h6>
                                <h2 class="fw-bold mb-0 text-info">${stats.totalUsers != null ? stats.totalUsers : 0}</h2>
                            </div>
                            <i class="bi bi-people fs-1 text-info"></i>
                        </div>
                    </div>
                </div>

                <div class="col-md-3">
                    <div class="card shadow-sm dashboard-card border-warning">
                        <div class="card-body d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="text-muted fw-bold">Bekleyen Sipariş</h6>
                                <h2 class="fw-bold mb-0 text-warning">${stats.pendingOrders != null ? stats.pendingOrders : 0}</h2>
                            </div>
                            <i class="bi bi-hourglass-split fs-1 text-warning"></i>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="alert alert-info mt-5 shadow-sm" role="alert">
                <i class="bi bi-info-circle-fill me-2"></i> Sol menüyü kullanarak sistemi yönetmeye başlayabilirsiniz.
            </div>

            <div class="row mt-4">
                <div class="col-md-8 mx-auto">
                    <div class="card shadow-sm border-0">
                        <div class="card-header bg-white fw-bold border-bottom">
                            <i class="bi bi-bar-chart-fill me-2 text-primary"></i> Sistem İstatistikleri Grafiği
                        </div>
                        <div class="card-body">
                            <canvas id="myChart" height="100"></canvas>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    // Editör hata vermesin diye JSP etiketlerini tırnak içine alıp Number'a çeviriyoruz
    var totalProducts = Number("${stats.totalProducts != null ? stats.totalProducts : 0}");
    var totalCategories = Number("${stats.totalCategories != null ? stats.totalCategories : 0}");
    var totalUsers = Number("${stats.totalUsers != null ? stats.totalUsers : 0}");
    var pendingOrders = Number("${stats.pendingOrders != null ? stats.pendingOrders : 0}");

    // Grafiği Çizdiriyoruz
    var ctx = document.getElementById('myChart').getContext('2d');
    new Chart(ctx, {
        type: 'bar',
        data: {
            labels: ['Toplam Ürün', 'Kategori Sayısı', 'Müşteri Sayısı', 'Bekleyen Sipariş'],
            datasets: [{
                label: 'Sistem Verileri',
                data: [totalProducts, totalCategories, totalUsers, pendingOrders],
                backgroundColor: [
                    'rgba(13, 110, 253, 0.7)',
                    'rgba(25, 135, 84, 0.7)',
                    'rgba(13, 202, 240, 0.7)',
                    'rgba(255, 193, 7, 0.7)'
                ],
                borderColor: [
                    'rgb(13, 110, 253)',
                    'rgb(25, 135, 84)',
                    'rgb(13, 202, 240)',
                    'rgb(255, 193, 7)'
                ],
                borderWidth: 1
            }]
        },
        options: {
            responsive: true,
            scales: {
                y: {
                    beginAtZero: true,
                    ticks: { stepSize: 1 }
                }
            }
        }
    });
</script>

</body>
</html>