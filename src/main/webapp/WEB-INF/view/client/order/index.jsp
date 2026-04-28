<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đơn mua của tôi | S-Mall</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-color: #EE4D2D;
            --bg-body: #F8FAFC;
        }

        body {
            background-color: var(--bg-body);
            font-family: 'Plus Jakarta Sans', sans-serif;
            color: #1E293B;
        }

        .order-container {
            max-width: 1000px;
            margin: 40px auto;
            padding: 0 15px;
        }

        /* TABS */
        .order-tabs {
            background: white;
            display: flex;
            justify-content: space-between;
            border-bottom: 1px solid #E2E8F0;
            position: sticky;
            top: 0;
            z-index: 100;
            border-radius: 12px 12px 0 0;
            overflow-x: auto;
        }

        .order-tab {
            flex: 1;
            text-align: center;
            padding: 16px 8px;
            font-weight: 600;
            font-size: 0.9rem;
            color: #475569;
            cursor: pointer;
            transition: all 0.2s;
            border-bottom: 3px solid transparent;
            white-space: nowrap;
            min-width: 120px;
        }

        .order-tab:hover { color: var(--primary-color); }
        .order-tab.active {
            color: var(--primary-color);
            border-bottom-color: var(--primary-color);
        }

        /* ORDER CARD */
        .order-card {
            background: white;
            border-radius: 12px;
            margin-top: 15px;
            padding: 24px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.02);
            border: 1px solid #F1F5F9;
        }

        .order-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-bottom: 15px;
            border-bottom: 1px solid #F1F5F9;
            margin-bottom: 15px;
        }

        .shop-name { font-weight: 700; font-size: 0.95rem; display: flex; align-items: center; gap: 8px; }
        .order-status { color: var(--primary-color); font-weight: 600; font-size: 0.85rem; text-transform: uppercase; }

        .item-row {
            display: flex;
            gap: 15px;
            margin-bottom: 15px;
        }
        .item-img { width: 80px; height: 80px; border-radius: 8px; object-fit: cover; background: #F8FAFC; border: 1px solid #F1F5F9; }
        .item-info { flex: 1; }
        .item-name { font-weight: 600; font-size: 0.9rem; margin-bottom: 4px; }
        .item-variant { font-size: 0.8rem; color: #64748B; }

        .order-footer {
            margin-top: 15px;
            padding-top: 15px;
            border-top: 1px solid #F1F5F9;
            display: flex;
            justify-content: flex-end;
            align-items: center;
            gap: 20px;
        }

        .total-price { color: var(--primary-color); font-weight: 800; font-size: 1.25rem; }

        .btn-custom {
            padding: 10px 24px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 0.9rem;
            transition: all 0.2s;
        }
        .btn-view { background: var(--primary-color); color: white; border: none; }
        .btn-view:hover { opacity: 0.9; }
    </style>
</head>
<body>

<jsp:include page="../layout/header.jsp" />

<div class="order-container">
    <div class="order-tabs">
        <div class="order-tab active" onclick="filterOrders('ALL')">Tất cả</div>
        <div class="order-tab" onclick="filterOrders('PENDING')">Chờ xử lý</div>
        <div class="order-tab" onclick="filterOrders('PREPARING')">Chờ giao hàng</div>
        <div class="order-tab" onclick="filterOrders('SHIPPING')">Đang giao</div>
        <div class="order-tab" onclick="filterOrders('DELIVERED')">Hoàn thành</div>
        <div class="order-tab" onclick="filterOrders('CANCELLED')">Đã hủy</div>
    </div>

    <div id="ordersList">
        <c:forEach var="order" items="${orders}">
            <div class="order-card" data-status="${order.status}">
                <div class="order-header">
                    <div class="shop-name">
                        <i class="fas fa-store"></i> Tech Store Official
                        <button class="btn btn-sm btn-outline-secondary ms-2" style="font-size: 0.7rem;">Xem Shop</button>
                    </div>
                    <div class="order-status">${order.status}</div>
                </div>
                
                <c:forEach var="detail" items="${order.orderDetails}">
                    <div class="item-row">
                        <img src="${pageContext.request.contextPath}${detail.productVariant.imageUrl}" class="item-img">
                        <div class="item-info">
                            <div class="item-name">${detail.product.name}</div>
                            <div class="item-variant">Loại: ${detail.productVariant.attributesJson}</div>
                            <div class="text-muted small">x ${detail.quantity}</div>
                        </div>
                        <div class="text-end">
                            <div class="text-primary fw-bold">
                                <fmt:formatNumber value="${detail.priceAtPurchase}" type="currency" currencySymbol="₫" />
                            </div>
                        </div>
                    </div>
                </c:forEach>

                <div class="order-footer">
                    <div>
                        <span class="text-muted small">Thành tiền:</span>
                        <span class="total-price ms-2">
                            <fmt:formatNumber value="${order.totalPrice}" type="currency" currencySymbol="₫" />
                        </span>
                    </div>
                    <a href="${pageContext.request.contextPath}/order-details/${order.orderCode}" class="btn btn-view btn-custom">Xem chi tiết</a>
                </div>
            </div>
        </c:forEach>
        
        <c:if test="${empty orders}">
            <div class="text-center py-5">
                <img src="https://deo.shopeemobile.com/shopee/shopee-pcmall-live-sg/assets/5fafbb923393a712b96488590b8f781f.png" style="width: 100px; opacity: 0.5;">
                <p class="text-muted mt-3">Chưa có đơn hàng nào</p>
            </div>
        </c:if>
    </div>
</div>

<jsp:include page="../layout/footer.jsp" />

<script>
    function filterOrders(status) {
        // Cập nhật tab active
        document.querySelectorAll('.order-tab').forEach(t => t.classList.remove('active'));
        event.target.classList.add('active');

        // Lọc đơn hàng
        const cards = document.querySelectorAll('.order-card');
        cards.forEach(card => {
            if (status === 'ALL' || card.getAttribute('data-status') === status) {
                card.style.display = 'block';
            } else {
                card.style.display = 'none';
            }
        });
    }
</script>

</body>
</html>
