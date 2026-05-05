<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="url" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>S-Mall | Seller Overview</title>
    
    <!-- Tailwind & Alpine -->
    <script src="https://cdn.tailwindcss.com"></script>
    <script defer src="https://unpkg.com/alpinejs@3.x.x/dist/cdn.min.js"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        'small-emerald': '#065F46',
                        'small-navy': '#0F172A',
                        'small-platinum': '#E2E8F0',
                    }
                }
            }
        }
    </script>
    
    <style>
        body { font-family: 'Inter', sans-serif; }
        .glass-card {
            background: rgba(255, 255, 255, 0.7);
            backdrop-filter: blur(12px);
            border: 1px solid rgba(226, 232, 240, 0.5);
        }
    </style>
</head>
<body class="bg-slate-50">

    <!-- Sidebar Inclusion -->
    <jsp:include page="/WEB-INF/view/seller/layout/sidebar.jsp" />

    <!-- Main Wrapper -->
    <div id="main-content" class="md:pl-64 flex flex-col min-h-screen transition-all duration-300 ease-in-out">
        
        <!-- Header -->
        <header class="sticky top-0 z-10 bg-white/80 backdrop-blur-xl border-b border-slate-200/60 px-8 py-6">
            <div class="flex items-center justify-between">
                <div class="flex items-center gap-4">
                    <button onclick="toggleSidebar()" class="w-10 h-10 bg-white shadow-sm border border-slate-100 rounded-xl flex items-center justify-center text-slate-400 hover:text-emerald-500 hover:border-emerald-100 transition-all">
                        <i class="fas fa-bars"></i>
                    </button>
                    <div>
                        <h1 class="text-2xl font-bold text-small-navy tracking-tight">Tổng quan người bán</h1>
                        <p class="text-sm text-slate-500">Chào mừng bạn quay trở lại, hệ thống đã sẵn sàng.</p>
                    </div>
                </div>
                <div class="flex items-center gap-4 bg-slate-100 p-1.5 rounded-2xl border border-slate-200">
                    <c:choose>
                        <c:when test="${not empty sessionScope.shopLogoUrl}">
                            <img src="${url}${sessionScope.shopLogoUrl}" class="w-8 h-8 rounded-xl object-cover border border-white">
                        </c:when>
                        <c:otherwise>
                            <div class="w-8 h-8 bg-emerald-500 rounded-xl flex items-center justify-center text-white text-xs">
                                <i class="fas fa-store"></i>
                            </div>
                        </c:otherwise>
                    </c:choose>
                    <span class="text-sm font-bold text-slate-700 pr-3">${sessionScope.shopName}</span>
                </div>
            </div>
        </header>

        <main class="p-8 space-y-8">
            
            <!-- Stats Grid -->
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
                <div class="glass-card p-6 rounded-3xl shadow-sm border-l-4 border-emerald-500">
                    <div class="flex justify-between items-start">
                        <div>
                            <p class="text-xs font-bold text-slate-400 uppercase tracking-widest mb-1">Lượt truy cập</p>
                            <h3 class="text-2xl font-bold text-small-navy">4,560</h3>
                        </div>
                        <div class="w-10 h-10 bg-emerald-50 rounded-xl flex items-center justify-center text-emerald-600">
                            <i class="fas fa-eye"></i>
                        </div>
                    </div>
                    <div class="mt-4 flex items-center gap-2 text-[10px] font-bold text-emerald-600">
                        <i class="fas fa-arrow-up"></i> 12% so với hôm qua
                    </div>
                </div>

                <div class="glass-card p-6 rounded-3xl shadow-sm border-l-4 border-blue-500">
                    <div class="flex justify-between items-start">
                        <div>
                            <p class="text-xs font-bold text-slate-400 uppercase tracking-widest mb-1">Tổng đơn hàng</p>
                            <h3 class="text-2xl font-bold text-small-navy">128</h3>
                        </div>
                        <div class="w-10 h-10 bg-blue-50 rounded-xl flex items-center justify-center text-blue-600">
                            <i class="fas fa-shopping-bag"></i>
                        </div>
                    </div>
                    <div class="mt-4 flex items-center gap-2 text-[10px] font-bold text-blue-600">
                        <i class="fas fa-arrow-up"></i> 8 đơn mới cần xử lý
                    </div>
                </div>

                <div class="glass-card p-6 rounded-3xl shadow-sm border-l-4 border-amber-500">
                    <div class="flex justify-between items-start">
                        <div>
                            <p class="text-xs font-bold text-slate-400 uppercase tracking-widest mb-1">Doanh thu tháng</p>
                            <h3 class="text-2xl font-bold text-small-navy">45.5M</h3>
                        </div>
                        <div class="w-10 h-10 bg-amber-50 rounded-xl flex items-center justify-center text-amber-600">
                            <i class="fas fa-wallet"></i>
                        </div>
                    </div>
                    <div class="mt-4 flex items-center gap-2 text-[10px] font-bold text-amber-600">
                        <i class="fas fa-chart-line"></i> Đang tăng trưởng tốt
                    </div>
                </div>

                <div class="glass-card p-6 rounded-3xl shadow-sm border-l-4 border-rose-500">
                    <div class="flex justify-between items-start">
                        <div>
                            <p class="text-xs font-bold text-slate-400 uppercase tracking-widest mb-1">Lợi nhuận</p>
                            <h3 class="text-2xl font-bold text-small-navy">12.2M</h3>
                        </div>
                        <div class="w-10 h-10 bg-rose-50 rounded-xl flex items-center justify-center text-rose-600">
                            <i class="fas fa-hand-holding-usd"></i>
                        </div>
                    </div>
                    <div class="mt-4 flex items-center gap-2 text-[10px] font-bold text-slate-400">
                        Sau khi trừ chi phí vận hành
                    </div>
                </div>
            </div>

            <%-- 
            <!-- Charts Row -->
            <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
                <div class="lg:col-span-2 glass-card p-8 rounded-3xl shadow-sm">
                    <div class="flex items-center justify-between mb-8">
                        <h5 class="font-bold text-small-navy">Biểu đồ doanh thu</h5>
                        <select class="bg-slate-50 border-none text-xs font-bold text-slate-500 rounded-lg px-3 py-1.5 outline-none">
                            <option>7 ngày qua</option>
                            <option>30 ngày qua</option>
                        </select>
                    </div>
                    <canvas id="salesChart" style="height: 300px;"></canvas>
                </div>

                <div class="glass-card p-8 rounded-3xl shadow-sm">
                    <h5 class="font-bold text-small-navy mb-8">Trạng thái đơn</h5>
                    <canvas id="statusChart"></canvas>
                    <div class="mt-8 space-y-4">
                        <div class="flex items-center justify-between">
                            <div class="flex items-center gap-2">
                                <div class="w-2 h-2 rounded-full bg-emerald-500"></div>
                                <span class="text-xs font-medium text-slate-500">Hoàn thành</span>
                            </div>
                            <span class="text-xs font-bold text-small-navy">70%</span>
                        </div>
                        <div class="flex items-center justify-between">
                            <div class="flex items-center gap-2">
                                <div class="w-2 h-2 rounded-full bg-amber-500"></div>
                                <span class="text-xs font-medium text-slate-500">Đang xử lý</span>
                            </div>
                            <span class="text-xs font-bold text-small-navy">20%</span>
                        </div>
                        <div class="flex items-center justify-between">
                            <div class="flex items-center gap-2">
                                <div class="w-2 h-2 rounded-full bg-rose-500"></div>
                                <span class="text-xs font-medium text-slate-500">Đã hủy</span>
                            </div>
                            <span class="text-xs font-bold text-small-navy">10%</span>
                        </div>
                    </div>
                </div>
            </div>
            --%>
        </main>
    </div>

    <%-- 
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script>
        const ctx = document.getElementById('salesChart').getContext('2d');
        new Chart(ctx, {
            type: 'line',
            data: {
                labels: ['Thứ 2', 'Thứ 3', 'Thứ 4', 'Thứ 5', 'Thứ 6', 'Thứ 7', 'CN'],
                datasets: [{
                    label: 'Doanh thu',
                    data: [12, 19, 13, 15, 22, 30, 25],
                    borderColor: '#10b981',
                    backgroundColor: 'rgba(16, 185, 129, 0.1)',
                    fill: true,
                    tension: 0.4,
                    borderWidth: 3,
                    pointRadius: 0,
                    pointHoverRadius: 6
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: { legend: { display: false } },
                scales: {
                    y: { display: false },
                    x: { grid: { display: false }, border: { display: false } }
                }
            }
        });

        const ctx2 = document.getElementById('statusChart').getContext('2d');
        new Chart(ctx2, {
            type: 'doughnut',
            data: {
                labels: ['Hoàn thành', 'Đang xử lý', 'Đã hủy'],
                datasets: [{
                    data: [70, 20, 10],
                    backgroundColor: ['#10b981', '#f59e0b', '#f43f5e'],
                    borderWidth: 0,
                    hoverOffset: 4
                }]
            },
            options: {
                cutout: '80%',
                plugins: { legend: { display: false } }
            }
        });
    </script>
    --%>
</body>
</html>