<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="url" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý đơn hàng | S-Mall Seller</title>
    
    <script src="https://cdn.tailwindcss.com"></script>
    <script defer src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        'small-emerald': '#065F46',
                        'small-navy': '#0F172A',
                        'small-mint-bg': '#EFF7F2',
                    }
                }
            }
        }
    </script>
    
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #EFF7F2; }
        .glass-card {
            background: rgba(255, 255, 255, 0.6);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(226, 232, 240, 0.5);
        }
        .sticky-header {
            position: sticky;
            top: 0;
            z-index: 40;
            background: rgba(239, 247, 242, 0.8);
            backdrop-filter: blur(20px);
            border-bottom: 1px solid rgba(6, 95, 70, 0.05);
        }
        [x-cloak] { display: none !important; }
    </style>
</head>
<body class="bg-small-mint-bg" 
      x-data="{ 
        isDetailOpen: false, 
        selectedOrder: null,
        openDetail(order) {
            this.selectedOrder = order;
            this.isDetailOpen = true;
        },
        closeDetail() {
            this.isDetailOpen = false;
        }
      }">

    <!-- Sidebar Inclusion -->
    <jsp:include page="/WEB-INF/view/seller/layout/sidebar.jsp" />

    <!-- Main Content Wrapper -->
    <div class="md:pl-64 flex flex-col min-h-screen">
        
        <!-- Sticky Header Section -->
        <div class="sticky-header">
            <div class="px-8 py-6">
                <div class="flex items-center justify-between mb-6">
                    <div class="flex-1">
                        <h1 class="text-3xl font-semibold text-small-navy mb-1">Quản lý đơn hàng</h1>
                        <p class="text-sm text-gray-500">Theo dõi và vận hành đơn hàng của bạn hiệu quả</p>
                    </div>
                    
                    <!-- Search Bar -->
                    <div class="flex-1 max-w-md mx-6">
                        <div class="relative group">
                            <i class="fas fa-search absolute left-4 top-1/2 -translate-y-1/2 text-gray-400 group-focus-within:text-small-emerald transition-colors"></i>
                            <input type="text" id="orderSearchInput" placeholder="Tìm theo mã đơn hàng (ví dụ: #SM-A5A)..." 
                                   class="w-full pl-12 pr-4 py-2.5 bg-white/60 backdrop-blur-xl border border-gray-200/50 rounded-xl focus:ring-4 focus:ring-small-emerald/5 focus:border-small-emerald outline-none transition-all text-sm shadow-sm"
                                   onkeyup="searchOrders()">
                        </div>
                    </div>

                    <div class="flex items-center gap-3">
                        <button class="flex items-center gap-2 px-4 py-2.5 bg-white/60 backdrop-blur-xl border border-gray-200/50 rounded-xl hover:bg-white/80 transition-all text-sm text-gray-700 shadow-sm">
                            <i class="far fa-calendar-alt text-gray-500"></i>
                            <span>Hôm nay</span>
                        </button>
                        <button class="w-10 h-10 flex items-center justify-center bg-white/60 backdrop-blur-xl border border-gray-200/50 rounded-xl hover:bg-white/80 transition-all shadow-sm">
                            <i class="fas fa-filter text-gray-500"></i>
                        </button>
                    </div>
                </div>

                <!-- Modern Tab Navigation -->
                <div class="flex gap-1 bg-white/40 backdrop-blur-md border border-white/40 rounded-2xl p-1.5 shadow-sm overflow-x-auto" x-data="{ activeTab: 'ALL' }">
                    <c:set var="statuses" value="${['ALL', 'PENDING', 'CONFIRMED', 'SHIPPING', 'DELIVERED', 'CANCELLED']}" />
                    <c:set var="labels" value="${['Tất cả', 'Chờ xác nhận', 'Đã xác nhận', 'Đang giao', 'Hoàn thành', 'Đã hủy']}" />
                    
                    <c:forEach var="st" items="${statuses}" varStatus="loop">
                        <button @click="activeTab = '${st}'; filterOrders('${st}')"
                                :class="activeTab === '${st}' ? 'bg-white shadow-md text-small-navy' : 'text-gray-500 hover:bg-white/50'"
                                class="flex-1 min-w-[120px] flex items-center justify-center gap-2 px-4 py-2.5 rounded-xl transition-all duration-300">
                            <span class="text-sm font-semibold">${labels[loop.index]}</span>
                            <span :class="activeTab === '${st}' ? 'bg-small-emerald text-white' : 'bg-gray-200 text-gray-500'"
                                  class="px-2 py-0.5 rounded-full text-[10px] font-bold">
                                <c:choose>
                                    <c:when test="${st == 'ALL'}">${orders.size()}</c:when>
                                    <c:otherwise>
                                        <c:set var="count" value="0" />
                                        <c:forEach var="o" items="${orders}">
                                            <c:choose>
                                                <c:when test="${st == 'SHIPPING'}">
                                                    <c:if test="${o.status == 'SHIPPING' || o.status == 'READY_FOR_PICKUP'}">
                                                        <c:set var="count" value="${count + 1}" />
                                                    </c:if>
                                                </c:when>
                                                <c:when test="${st == 'CONFIRMED'}">
                                                    <c:if test="${o.status == 'CONFIRMED' || o.status == 'PREPARING'}">
                                                        <c:set var="count" value="${count + 1}" />
                                                    </c:if>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:if test="${o.status == st}">
                                                        <c:set var="count" value="${count + 1}" />
                                                    </c:if>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:forEach>
                                        ${count}
                                    </c:otherwise>
                                </c:choose>
                            </span>
                        </button>
                    </c:forEach>
                </div>
            </div>
        </div>

        <!-- Order List Container -->
        <main class="px-8 py-8 space-y-4" id="orderListContainer">
            <!-- PHẦN 1: ƯU TIÊN ĐƠN HÀNG PENDING -->
            <c:forEach var="order" items="${orders}">
                <c:if test="${order.status == 'PENDING'}">
                    <jsp:include page="order_card_fragment.jsp">
                        <jsp:param name="orderId" value="${order.id}" />
                    </jsp:include>
                </c:if>
            </c:forEach>

            <!-- PHẦN 2: CÁC ĐƠN HÀNG CÒN LẠI -->
            <c:forEach var="order" items="${orders}">
                <c:if test="${order.status != 'PENDING'}">
                    <jsp:include page="order_card_fragment.jsp">
                        <jsp:param name="orderId" value="${order.id}" />
                    </jsp:include>
                </c:if>
            </c:forEach>

            <c:if test="${empty orders}">
                <div class="flex flex-col items-center justify-center py-24 glass-card rounded-[32px]">
                    <div class="w-24 h-24 bg-emerald-50 rounded-full flex items-center justify-center mb-6">
                        <i class="fas fa-box-open text-3xl text-emerald-300"></i>
                    </div>
                    <h3 class="text-xl font-bold text-small-navy mb-2">Chưa có đơn hàng nào</h3>
                    <p class="text-gray-400 text-sm">Khi khách hàng đặt mua sản phẩm, đơn hàng sẽ hiện ở đây.</p>
                </div>
            </c:if>
        </main>
    </div>

    <!-- ORDER DETAIL SLIDE-OVER PANEL -->
    <div x-show="isDetailOpen" x-cloak class="fixed inset-0 z-50 overflow-hidden">
        <!-- Backdrop -->
        <div x-show="isDetailOpen" 
             x-transition:enter="ease-in-out duration-500" 
             x-transition:enter-start="opacity-0" 
             x-transition:enter-end="opacity-100" 
             x-transition:leave="ease-in-out duration-500" 
             x-transition:leave-start="opacity-100" 
             x-transition:leave-end="opacity-0" 
             class="absolute inset-0 bg-small-navy/20 backdrop-blur-sm transition-opacity" 
             @click="closeDetail()"></div>

        <div class="fixed inset-y-0 right-0 pl-10 max-w-full flex">
            <div x-show="isDetailOpen" 
                 x-transition:enter="transform transition ease-in-out duration-500 sm:duration-700" 
                 x-transition:enter-start="translate-x-full" 
                 x-transition:enter-end="translate-x-0" 
                 x-transition:leave="transform transition ease-in-out duration-500 sm:duration-700" 
                 x-transition:leave-start="translate-x-0" 
                 x-transition:leave-end="translate-x-full" 
                 class="w-screen max-w-lg">
                
                <div class="h-full flex flex-col bg-white shadow-2xl">
                    <!-- Header -->
                    <div class="px-6 py-6 border-b border-gray-100 flex items-center justify-between bg-white sticky top-0 z-10">
                        <div>
                            <h2 class="text-xl font-black text-small-navy">Chi tiết đơn hàng <span class="text-emerald-600" x-text="'#' + selectedOrder?.code"></span></h2>
                            <div class="flex items-center gap-3 mt-1">
                                <div class="flex items-center gap-1.5 text-[11px] text-emerald-600 font-semibold bg-emerald-50 px-2 py-0.5 rounded-md">
                                    <i class="far fa-clock"></i>
                                    <span x-text="selectedOrder?.time"></span>
                                </div>
                            </div>
                        </div>
                        <button @click="closeDetail()" class="p-2 hover:bg-gray-100 rounded-xl transition-all text-gray-400">
                            <i class="fas fa-times text-lg"></i>
                        </button>
                    </div>

                    <!-- Content -->
                    <div class="flex-1 overflow-y-auto px-6 py-8 space-y-8 bg-gray-50/30">
                        <!-- Customer Info Card -->
                        <div class="bg-white rounded-3xl p-5 shadow-sm border border-gray-100">
                            <div class="flex justify-between items-start mb-4">
                                <!-- QR Code Passport Section -->
                                <div class="flex flex-col items-center p-4 bg-emerald-50/50 rounded-2xl border border-emerald-100 mb-6 w-full">
                                    <div class="p-2 bg-white rounded-2xl shadow-sm mb-3">
                                        <img :src="'https://api.qrserver.com/v1/create-qr-code/?size=120x120&data=' + encodeURIComponent(window.location.origin + '${url}/order/passport/' + selectedOrder?.code)" 
                                             class="w-24 h-24 rounded-lg">
                                    </div>
                                    <div class="text-center">
                                        <div class="text-[9px] text-emerald-800 font-black uppercase tracking-widest mb-1">Hộ chiếu đơn hàng</div>
                                        <p class="text-[10px] text-gray-400 leading-tight px-4">Mã định danh được cấp riêng cho mỗi đơn hàng để Shipper và Seller dễ dàng quản lý & cập nhật.</p>
                                    </div>
                                </div>
                            </div>
                            <!-- Buyer Profile Card -->
                            <div class="flex items-center gap-4 mb-6 pt-4 border-t border-gray-50">
                                <div class="relative">
                                    <img :src="selectedOrder?.customerAvatar" class="w-14 h-14 rounded-2xl bg-emerald-50 border border-emerald-100 shadow-sm object-cover">
                                    <div class="absolute -bottom-1 -right-1 w-5 h-5 bg-emerald-500 border-2 border-white rounded-full flex items-center justify-center">
                                        <i class="fas fa-check text-[8px] text-white"></i>
                                    </div>
                                </div>
                                <div class="flex-1">
                                    <div class="flex items-center gap-2">
                                        <div class="font-bold text-small-navy text-base" x-text="selectedOrder?.customerName"></div>
                                        <span class="px-2 py-0.5 bg-emerald-100 text-emerald-700 text-[9px] font-black rounded uppercase">Thành viên Bạc</span>
                                    </div>
                                    <div class="text-xs text-gray-400 font-medium" x-text="selectedOrder?.customerEmail"></div>
                                </div>
                                <button class="w-10 h-10 rounded-xl bg-emerald-50 text-emerald-600 hover:bg-emerald-600 hover:text-white transition-all flex items-center justify-center shadow-sm">
                                    <i class="fas fa-comment-dots text-sm"></i>
                                </button>
                            </div>

                            <div class="space-y-3 pt-3 border-t border-gray-50">
                                <div class="flex items-center gap-3 text-sm text-gray-600">
                                    <i class="fas fa-phone-alt w-5 text-emerald-600/50 text-xs"></i>
                                    <span class="font-bold text-small-navy" x-text="selectedOrder?.customerPhone"></span>
                                </div>
                                <div class="flex items-start gap-3 text-sm text-gray-600">
                                    <i class="fas fa-map-marker-alt w-5 text-emerald-600/50 text-xs mt-1"></i>
                                    <span class="text-xs font-medium leading-relaxed" x-text="selectedOrder?.shippingAddress"></span>
                                </div>
                            </div>
                        </div>

                        <!-- Products List -->
                        <div>
                            <div class="text-[10px] text-gray-400 font-bold uppercase tracking-widest mb-4 px-1">Sản phẩm trong đơn</div>
                            <div class="space-y-3">
                                <template x-for="item in selectedOrder?.items" :key="item.id">
                                    <div class="flex gap-4 bg-white p-3 rounded-2xl border border-gray-100 shadow-sm">
                                        <img :src="item.image" class="w-16 h-16 rounded-xl object-cover bg-gray-50">
                                        <div class="flex-1 min-w-0 py-1">
                                            <div class="font-bold text-sm text-small-navy truncate" x-text="item.name"></div>
                                            <div class="text-[10px] text-gray-400 font-medium mt-1 uppercase" x-text="item.variant"></div>
                                            <div class="flex items-center justify-between mt-2">
                                                <div class="text-xs font-bold text-emerald-600" x-text="'x' + item.quantity"></div>
                                                <div class="font-bold text-small-navy" x-text="item.price"></div>
                                            </div>
                                        </div>
                                    </div>
                                </template>
                            </div>
                        </div>

                        <!-- Total Amount Card -->
                        <div class="bg-small-emerald rounded-[32px] p-8 text-white shadow-2xl shadow-emerald-900/20 relative overflow-hidden group">
                            <div class="absolute top-0 right-0 p-8 opacity-10 group-hover:scale-110 transition-transform duration-500">
                                <i class="fas fa-wallet text-6xl"></i>
                            </div>
                            <div class="relative z-10">
                                <div class="flex justify-between items-center mb-2">
                                    <div class="text-[10px] font-bold uppercase tracking-[0.2em] text-emerald-200">Tổng thanh toán</div>
                                    <span class="px-3 py-1 bg-white/10 rounded-lg text-[10px] font-bold uppercase tracking-widest" x-text="selectedOrder?.paymentMethod"></span>
                                </div>
                                <div class="text-4xl font-black tracking-tight" x-text="selectedOrder?.totalPrice"></div>
                            </div>
                        </div>

                        <!-- Order Timeline -->
                        <div class="space-y-6">
                            <div class="text-[10px] text-gray-400 font-bold uppercase tracking-widest mb-6 px-1">Tiến trình đơn hàng</div>
                            <div class="relative pl-8 space-y-8 before:absolute before:left-[11px] before:top-2 before:bottom-2 before:w-[2px] before:bg-gray-100">
                                
                                <!-- Bước 1 -->
                                <div class="relative">
                                    <div class="absolute -left-8 w-6 h-6 rounded-full border-4 border-white shadow-sm z-10 flex items-center justify-center transition-colors duration-500"
                                         :class="selectedOrder?.status !== 'CANCELLED' ? 'bg-emerald-500' : 'bg-red-500'">
                                        <i class="fas text-[8px] text-white" :class="selectedOrder?.status !== 'CANCELLED' ? 'fa-check' : 'fa-times'"></i>
                                    </div>
                                    <div>
                                        <div class="text-sm font-bold text-small-navy" x-text="selectedOrder?.status !== 'CANCELLED' ? 'Đã đặt hàng' : 'Đơn hàng đã hủy'"></div>
                                        <div class="text-[11px] text-gray-400 mt-0.5" x-text="selectedOrder?.time"></div>
                                    </div>
                                </div>

                                <!-- Bước 2 -->
                                <div class="relative" :class="['CONFIRMED', 'SHIPPING', 'DELIVERED', 'REVIEWED'].includes(selectedOrder?.status) ? '' : 'opacity-40'">
                                    <div class="absolute -left-8 w-6 h-6 rounded-full border-4 border-white shadow-sm z-10 flex items-center justify-center transition-colors duration-500"
                                         :class="['CONFIRMED', 'SHIPPING', 'DELIVERED', 'REVIEWED'].includes(selectedOrder?.status) ? 'bg-emerald-500' : 'bg-gray-200'">
                                        <i class="fas fa-check text-[8px] text-white" x-show="['CONFIRMED', 'SHIPPING', 'DELIVERED', 'REVIEWED'].includes(selectedOrder?.status)"></i>
                                    </div>
                                    <div>
                                        <div class="text-sm font-bold" :class="['CONFIRMED', 'SHIPPING', 'DELIVERED', 'REVIEWED'].includes(selectedOrder?.status) ? 'text-small-navy' : 'text-gray-400'">Đã xác nhận</div>
                                        <div class="text-[11px] text-gray-300 mt-0.5">Hệ thống đã xác nhận đơn hàng</div>
                                    </div>
                                </div>

                                <!-- Bước 3 -->
                                <div class="relative" :class="['SHIPPING', 'DELIVERED', 'REVIEWED'].includes(selectedOrder?.status) ? '' : 'opacity-40'">
                                    <div class="absolute -left-8 w-6 h-6 rounded-full border-4 border-white shadow-sm z-10 flex items-center justify-center transition-colors duration-500"
                                         :class="['SHIPPING', 'DELIVERED', 'REVIEWED'].includes(selectedOrder?.status) ? 'bg-emerald-500' : 'bg-gray-200'">
                                        <i class="fas fa-truck text-[8px] text-white" x-show="['SHIPPING', 'DELIVERED', 'REVIEWED'].includes(selectedOrder?.status)"></i>
                                    </div>
                                    <div>
                                        <div class="text-sm font-bold" :class="['SHIPPING', 'DELIVERED', 'REVIEWED'].includes(selectedOrder?.status) ? 'text-small-navy' : 'text-gray-400'">Đang giao hàng</div>
                                        <div class="text-[11px] text-gray-300 mt-0.5">Đơn hàng đang trên đường tới bạn</div>
                                    </div>
                                </div>

                                <!-- Bước 4 -->
                                <div class="relative" :class="['DELIVERED', 'REVIEWED'].includes(selectedOrder?.status) ? '' : 'opacity-40'">
                                    <div class="absolute -left-8 w-6 h-6 rounded-full border-4 border-white shadow-sm z-10 flex items-center justify-center transition-colors duration-500"
                                         :class="['DELIVERED', 'REVIEWED'].includes(selectedOrder?.status) ? 'bg-emerald-500' : 'bg-gray-200'">
                                        <i class="fas fa-box-open text-[8px] text-white" x-show="['DELIVERED', 'REVIEWED'].includes(selectedOrder?.status)"></i>
                                    </div>
                                    <div>
                                        <div class="text-sm font-bold" :class="['DELIVERED', 'REVIEWED'].includes(selectedOrder?.status) ? 'text-small-navy' : 'text-gray-400'">Đã nhận hàng</div>
                                        <div class="text-[11px] text-gray-300 mt-0.5">Giao hàng thành công</div>
                                    </div>
                                </div>

                                <!-- Bước 5 -->
                                <div class="relative" :class="selectedOrder?.status === 'REVIEWED' ? '' : 'opacity-40'">
                                    <div class="absolute -left-8 w-6 h-6 rounded-full border-4 border-white shadow-sm z-10 flex items-center justify-center transition-colors duration-500"
                                         :class="selectedOrder?.status === 'REVIEWED' ? 'bg-emerald-500' : 'bg-gray-200'">
                                        <i class="fas fa-star text-[8px] text-white" x-show="selectedOrder?.status === 'REVIEWED'"></i>
                                    </div>
                                    <div>
                                        <div class="text-sm font-bold" :class="selectedOrder?.status === 'REVIEWED' ? 'text-small-navy' : 'text-gray-400'">Đã đánh giá</div>
                                        <div class="text-[11px] text-gray-300 mt-0.5">Khách hàng đã phản hồi về sản phẩm</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Footer Action -->
                    <div class="px-6 py-6 bg-white border-t border-gray-100 flex gap-3 sticky bottom-0">
                        <button @click="closeDetail()" class="flex-1 py-4 bg-gray-50 text-gray-400 text-xs font-black uppercase tracking-[0.2em] rounded-2xl hover:bg-gray-100 transition-all">Đóng</button>
                        <template x-if="selectedOrder?.status === 'PENDING'">
                            <button @click="updateStatus(selectedOrder.id, 'CONFIRMED'); closeDetail()" 
                                    class="flex-[2] py-4 bg-small-emerald text-white text-xs font-black uppercase tracking-[0.2em] rounded-2xl shadow-xl shadow-emerald-900/20 hover:bg-emerald-900 transition-all">
                                Xác nhận đơn hàng
                            </button>
                        </template>
                        <template x-if="selectedOrder?.status === 'CONFIRMED'">
                            <button @click="updateStatus(selectedOrder.id, 'SHIPPING'); closeDetail()" 
                                    class="flex-[2] py-4 bg-indigo-600 text-white text-xs font-black uppercase tracking-[0.2em] rounded-2xl shadow-xl shadow-indigo-900/20 hover:bg-indigo-900 transition-all">
                                Bàn giao vận chuyển
                            </button>
                        </template>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script>
        function filterOrders(status) {
            const cards = document.querySelectorAll('.order-card');
            cards.forEach(card => {
                const cardStatus = card.getAttribute('data-status');
                if (status === 'ALL') {
                    card.style.display = 'block';
                } else if (status === 'SHIPPING') {
                    // Nhóm Đang giao bao gồm cả SHIPPING và READY_FOR_PICKUP
                    if (cardStatus === 'SHIPPING' || cardStatus === 'READY_FOR_PICKUP') {
                        card.style.display = 'block';
                    } else {
                        card.style.display = 'none';
                    }
                } else if (status === 'CONFIRMED') {
                    // Nhóm Đã xác nhận bao gồm cả CONFIRMED và PREPARING
                    if (cardStatus === 'CONFIRMED' || cardStatus === 'PREPARING') {
                        card.style.display = 'block';
                    } else {
                        card.style.display = 'none';
                    }
                } else {
                    if (cardStatus === status) {
                        card.style.display = 'block';
                    } else {
                        card.style.display = 'none';
                    }
                }
            });
        }

        function searchOrders() {
            const input = document.getElementById('orderSearchInput');
            const filter = input.value.toUpperCase();
            const cards = document.querySelectorAll('.order-card');
            
            cards.forEach(card => {
                const orderCode = card.querySelector('.font-mono').innerText.toUpperCase();
                if (orderCode.indexOf(filter) > -1) {
                    card.style.display = "block";
                } else {
                    card.style.display = "none";
                }
            });
        }

        function updateStatus(orderId, status) {
            Swal.fire({
                title: 'Xác nhận?',
                text: "Bạn muốn chuyển đơn hàng sang trạng thái " + status + "?",
                icon: 'question',
                showCancelButton: true,
                confirmButtonColor: '#065F46',
                cancelButtonColor: '#6c757d',
                confirmButtonText: 'Đồng ý',
                cancelButtonText: 'Hủy',
                background: '#ffffff',
                borderRadius: '24px'
            }).then((result) => {
                if (result.isConfirmed) {
                    const params = new URLSearchParams();
                    params.append('orderId', orderId);
                    params.append('status', status);
                    params.append('note', 'Seller cập nhật trạng thái sang ' + status);

                    fetch('${url}/seller/order/update-status', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                        body: params
                    })
                    .then(res => res.json())
                    .then(data => {
                        if (data.success) {
                            Swal.fire({
                                title: 'Thành công!',
                                text: data.message,
                                icon: 'success',
                                confirmButtonColor: '#065F46',
                                borderRadius: '24px'
                            }).then(() => {
                                location.reload();
                            });
                        } else {
                            Swal.fire('Lỗi!', data.message, 'error');
                        }
                    });
                }
            });
        }
    </script>
</body>
</html>
