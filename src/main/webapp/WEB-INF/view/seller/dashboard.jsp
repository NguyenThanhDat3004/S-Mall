<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <c:set var="url" value="${pageContext.request.contextPath}" />
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>S-Mall Seller Dashboard</title>

            <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
                rel="stylesheet">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            <link rel="stylesheet" href="${url}/resources/css/admin/dashboard.css">

            <style>
                .stats-card {
                    border: none;
                    border-radius: 15px;
                    padding: 20px;
                    color: white;
                    transition: transform 0.3s ease;
                }

                .stats-card:hover {
                    transform: translateY(-5px);
                }

                .bg-card-1 {
                    background: #00b894;
                }

                .bg-card-2 {
                    background: #6c5ce7;
                }

                .bg-card-3 {
                    background: #fdcb6e;
                }

                .bg-card-4 {
                    background: #ff7675;
                }

                .dashboard-content {
                    padding: 30px;
                }

                canvas {
                    max-width: 100%;
                    height: 300px !important;
                }
            </style>
        </head>

        <body>

            <!-- Sidebar Inclusion (Seller Version) -->
            <jsp:include page="/WEB-INF/view/seller/layout/sidebar.jsp" />

            <div class="main-wrapper">
                <main class="dashboard-content">
                    <h4 class="fw-bold mb-4">Tổng quan người bán</h4>

                    <!-- Stats Rows -->
                    <div class="row g-4 mb-4">
                        <div class="col-md-3">
                            <div class="stats-card bg-card-1">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <small>Lượt truy cập ngày</small>
                                        <h3 class="mb-0">4,560</h3>
                                    </div>
                                    <i class="fas fa-store fa-2x opacity-50"></i>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="stats-card bg-card-2">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <small>Tổng đơn hàng</small>
                                        <h3 class="mb-0">128</h3>
                                    </div>
                                    <i class="fas fa-file-alt fa-2x opacity-50"></i>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="stats-card bg-card-3">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <small>Doanh thu tháng</small>
                                        <h3 class="mb-0">45.5M</h3>
                                    </div>
                                    <i class="fas fa-shopping-cart fa-2x opacity-50"></i>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="stats-card bg-card-4">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <small>Lợi nhuận ước tính</small>
                                        <h3 class="mb-0">12.2M</h3>
                                    </div>
                                    <i class="fas fa-dollar-sign fa-2x opacity-50"></i>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Charts Row -->
                    <div class="row g-4">
                        <div class="col-lg-8">
                            <div class="card border-0 shadow-sm p-4 rounded-4">
                                <h5 class="fw-bold mb-4">Xu hướng doanh thu</h5>
                                <canvas id="salesChart"></canvas>
                            </div>
                        </div>
                        <div class="col-lg-4">
                            <div class="card border-0 shadow-sm p-4 rounded-4 h-100">
                                <h5 class="fw-bold mb-4">Trạng thái đơn hàng</h5>
                                <canvas id="statusChart"></canvas>
                            </div>
                        </div>
                    </div>
                </main>
            </div>

            <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
            <script>
                const ctx = document.getElementById('salesChart').getContext('2d');
                new Chart(ctx, {
                    type: 'line',
                    data: {
                        labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
                        datasets: [{
                            label: 'Doanh thu (VNĐ)',
                            data: [12000000, 19000000, 13000000, 15000000, 22000000, 30000000],
                            borderColor: '#27ae60',
                            backgroundColor: 'rgba(39, 174, 96, 0.1)',
                            fill: true,
                            tension: 0.4
                        }]
                    },
                    options: { responsive: true, maintainAspectRatio: false }
                });

                const ctx2 = document.getElementById('statusChart').getContext('2d');
                new Chart(ctx2, {
                    type: 'doughnut',
                    data: {
                        labels: ['Hoàn thành', 'Đang xử lý', 'Đã hủy'],
                        datasets: [{
                            data: [70, 20, 10],
                            backgroundColor: ['#27ae60', '#fdcb6e', '#ff7675']
                        }]
                    },
                    options: { cutout: '70%', plugins: { legend: { position: 'bottom' } } }
                });
            </script>
        </body>

        </html>