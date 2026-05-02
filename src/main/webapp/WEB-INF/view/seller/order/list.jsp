<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="url" value="${pageContext.request.contextPath}" />

<jsp:include page="../../client/layout/header.jsp" />

        <link rel="stylesheet" href="${url}/resources/css/client/footer.css">
<style>
    .seller-order-container {
        max-width: 1200px;
        margin: 40px auto;
        padding: 0 15px;
    }
    .order-card {
        background: white;
        border-radius: 15px;
        box-shadow: 0 10px 30px rgba(0,0,0,0.05);
        border: 1px solid #edf2f7;
        margin-bottom: 25px;
        overflow: hidden;
    }
    .order-header {
        background: #f8fafc;
        padding: 15px 25px;
        border-bottom: 1px solid #edf2f7;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }
    .status-badge {
        padding: 6px 15px;
        border-radius: 20px;
        font-size: 0.8rem;
        font-weight: 700;
        text-transform: uppercase;
    }
    .status-pending { background: #fff7ed; color: #ea580c; }
    .status-confirmed { background: #f0fdf4; color: #16a34a; }
    .status-shipping { background: #eff6ff; color: #2563eb; }
    .status-delivered { background: #fdf2f8; color: #db2777; }
    .status-cancelled { background: #fef2f2; color: #dc2626; }

    .order-body { padding: 25px; }
    .product-item {
        display: flex;
        gap: 15px;
        margin-bottom: 15px;
        padding-bottom: 15px;
        border-bottom: 1px dashed #e2e8f0;
    }
    .product-item:last-child { border-bottom: none; }
    .product-img { width: 70px; height: 70px; border-radius: 10px; object-fit: cover; }
    
    .action-section {
        background: #fff;
        padding: 15px 25px;
        border-top: 1px solid #edf2f7;
        display: flex;
        justify-content: flex-end;
        gap: 10px;
    }
    .btn-action {
        padding: 8px 20px;
        border-radius: 8px;
        font-weight: 600;
        transition: all 0.2s;
    }
    
    .nav-pills .nav-link {
        color: #64748b;
        font-weight: 600;
        border-radius: 10px;
        padding: 10px 20px;
    }
    .nav-pills .nav-link.active {
        background-color: #ee4d2d;
    }
</style>

<div class="seller-order-container">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="fw-bold"><i class="fas fa-clipboard-list me-2"></i>Quản Lý Đơn Hàng</h2>
        <div class="text-muted">Shop: <span class="fw-bold text-dark">${sessionScope.shopName}</span></div>
    </div>

    <!-- TABS -->
    <ul class="nav nav-pills mb-4" id="pills-tab" role="tablist">
        <li class="nav-item">
            <button class="nav-link active" onclick="filterOrders('ALL')">Tất cả</button>
        </li>
        <li class="nav-item">
            <button class="nav-link" onclick="filterOrders('PENDING')">Chờ xác nhận</button>
        </li>
        <li class="nav-item">
            <button class="nav-link" onclick="filterOrders('CONFIRMED')">Chờ giao hàng</button>
        </li>
        <li class="nav-item">
            <button class="nav-link" onclick="filterOrders('SHIPPING')">Đang giao</button>
        </li>
        <li class="nav-item">
            <button class="nav-link" onclick="filterOrders('DELIVERED')">Hoàn thành</button>
        </li>
    </ul>

    <div id="orderListContainer">
        <c:forEach var="order" items="${orders}">
            <div class="order-card" data-status="${order.status}">
                <div class="order-header">
                    <div>
                        <span class="fw-bold text-dark">#${order.orderCode}</span>
                        <span class="mx-2 text-muted">|</span>
                        <span class="small text-muted"><fmt:formatDate value="${java.util.Date.from(order.createdAt.atZone(java.time.ZoneId.systemDefault()).toInstant())}" pattern="dd/MM/yyyy HH:mm"/></span>
                    </div>
                    <div class="status-badge status-${order.status.toString().toLowerCase()}">
                        ${order.status.displayName}
                    </div>
                </div>
                <div class="order-body">
                    <div class="row">
                        <div class="col-md-8">
                            <c:forEach var="item" items="${order.orderDetails}">
                                <c:if test="${item.product.shop.id == sessionScope.shopId}">
                                    <div class="product-item">
                                        <img src="${url}${item.productVariant.imageUrl}" class="product-img">
                                        <div class="flex-grow-1">
                                            <div class="fw-bold text-dark">${item.product.name}</div>
                                            <div class="small text-muted">Phân loại: ${item.productVariant.attributesJson}</div>
                                            <div class="small">Số lượng: x${item.quantity}</div>
                                        </div>
                                        <div class="text-end">
                                            <div class="fw-bold text-primary"><fmt:formatNumber value="${item.priceAtPurchase}" type="currency" currencySymbol="₫"/></div>
                                        </div>
                                    </div>
                                </c:if>
                            </c:forEach>
                        </div>
                        <div class="col-md-4 border-start">
                            <div class="ps-3">
                                <div class="small text-muted mb-1">Khách hàng:</div>
                                <div class="fw-bold mb-3">${order.account.profile.fullName}</div>
                                <div class="small text-muted mb-1">Địa chỉ:</div>
                                <div class="small text-dark mb-3">${order.shippingAddress}</div>
                                <div class="small text-muted mb-1">Thanh toán:</div>
                                <div class="badge bg-light text-dark">${order.paymentMethod}</div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="action-section">
                    <c:choose>
                        <c:when test="${order.status == 'PENDING'}">
                            <button class="btn btn-action btn-success" onclick="updateStatus(${order.id}, 'CONFIRMED')">Xác nhận đơn hàng</button>
                            <button class="btn btn-action btn-outline-danger" onclick="updateStatus(${order.id}, 'CANCELLED')">Hủy đơn</button>
                        </c:when>
                        <c:when test="${order.status == 'CONFIRMED'}">
                            <button class="btn btn-action btn-primary" onclick="updateStatus(${order.id}, 'SHIPPING')">Giao cho ĐVVC</button>
                        </c:when>
                        <c:when test="${order.status == 'SHIPPING'}">
                            <button class="btn btn-action btn-info text-white" onclick="updateStatus(${order.id}, 'DELIVERED')">Xác nhận đã giao</button>
                        </c:when>
                    </c:choose>
                    <a href="${url}/order-details/${order.orderCode}" class="btn btn-action btn-light">Chi tiết</a>
                </div>
            </div>
        </c:forEach>
        
        <c:if test="${empty orders}">
            <div class="text-center py-5 bg-white rounded-4 shadow-sm">
                <i class="fas fa-box-open fa-3x text-muted mb-3"></i>
                <p class="text-muted">Chưa có đơn hàng nào.</p>
            </div>
        </c:if>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
    function filterOrders(status) {
        // Update active tab
        document.querySelectorAll('.nav-link').forEach(btn => btn.classList.remove('active'));
        event.target.classList.add('active');

        // Filter cards
        const cards = document.querySelectorAll('.order-card');
        cards.forEach(card => {
            if (status === 'ALL' || card.getAttribute('data-status') === status) {
                card.style.display = 'block';
            } else {
                card.style.display = 'none';
            }
        });
    }

    function updateStatus(orderId, status) {
        Swal.fire({
            title: 'Xác nhận?',
            text: "Bạn muốn chuyển đơn hàng sang trạng thái " + status + "?",
            icon: 'question',
            showCancelButton: true,
            confirmButtonColor: '#ee4d2d',
            cancelButtonColor: '#6c757d',
            confirmButtonText: 'Đồng ý',
            cancelButtonText: 'Hủy'
        }).then((result) => {
            if (result.isConfirmed) {
                const params = new URLSearchParams();
                params.append('orderId', orderId);
                params.append('status', status);
                params.append('note', 'Seller updated status to ' + status);

                fetch('${url}/seller/order/update-status', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: params
                })
                .then(res => res.json())
                .then(data => {
                    if (data.success) {
                        Swal.fire('Thành công!', data.message, 'success').then(() => {
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

<jsp:include page="../../client/layout/footer.jsp" />
