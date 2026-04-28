<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thanh toán | S-Mall</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-color: #EE4D2D;
            --secondary-color: #1A7A42;
            --bg-body: #F1F5F9;
            --glass-bg: rgba(255, 255, 255, 0.9);
        }

        body {
            background-color: var(--bg-body);
            font-family: 'Plus Jakarta Sans', sans-serif;
            color: #1E293B;
        }

        .checkout-container {
            max-width: 1100px;
            margin: 40px auto;
            padding: 0 15px;
        }

        .section-card {
            background: white;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.04);
            padding: 30px;
            margin-bottom: 25px;
            border: 1px solid rgba(226, 232, 240, 0.8);
        }

        .section-title {
            font-weight: 800;
            font-size: 1.25rem;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .section-title i {
            color: var(--primary-color);
        }

        .address-box {
            background: #FFF7F5;
            border: 1.5px dashed #FFD0C5;
            border-radius: 16px;
            padding: 20px;
            display: flex;
            align-items: flex-start;
            gap: 15px;
        }

        .address-icon {
            background: white;
            width: 40px;
            height: 40px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--primary-color);
            box-shadow: 0 4px 10px rgba(238, 77, 45, 0.1);
        }

        .item-row {
            display: grid;
            grid-template-columns: 80px 1fr 150px;
            gap: 20px;
            padding: 15px 0;
            border-bottom: 1px solid #F1F5F9;
        }

        .item-row:last-child {
            border-bottom: none;
        }

        .item-img {
            width: 80px;
            height: 80px;
            border-radius: 12px;
            object-fit: cover;
        }

        .item-name {
            font-weight: 600;
            font-size: 0.95rem;
            margin-bottom: 4px;
        }

        .item-variant {
            font-size: 0.85rem;
            color: #64748B;
        }

        .price-summary {
            background: white;
            border-radius: 24px;
            padding: 25px;
            position: sticky;
            top: 20px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.06);
        }

        .summary-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 15px;
            font-size: 0.95rem;
        }

        .total-row {
            display: flex;
            justify-content: space-between;
            margin-top: 20px;
            padding-top: 20px;
            border-top: 2px dashed #E2E8F0;
            font-weight: 800;
            font-size: 1.4rem;
            color: var(--primary-color);
        }

        .btn-order {
            background: linear-gradient(135deg, #EE4D2D 0%, #FF7B60 100%);
            color: white;
            border: none;
            width: 100%;
            padding: 18px;
            border-radius: 16px;
            font-weight: 700;
            font-size: 1.1rem;
            margin-top: 25px;
            transition: all 0.3s ease;
            box-shadow: 0 10px 20px rgba(238, 77, 45, 0.2);
        }

        .btn-order:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 30px rgba(238, 77, 45, 0.3);
            color: white;
        }

        .header-nav {
            background: white;
            padding: 15px 0;
            box-shadow: 0 2px 10px rgba(0,0,0,0.02);
        }
    </style>
</head>
<body>

<div class="header-nav mb-4">
    <div class="container d-flex align-items-center">
        <a href="${pageContext.request.contextPath}/" style="text-decoration: none;">
            <h1 style="color: var(--primary-color); font-weight: 800; margin: 0; font-size: 1.8rem;">S-Mall <span style="font-weight: 300; font-size: 1.2rem; color: #64748B; border-left: 2px solid #E2E8F0; padding-left: 15px; margin-left: 10px;">Thanh toán</span></h1>
        </a>
    </div>
</div>

<div class="checkout-container">
    <div class="row">
        <div class="col-lg-8">
            <!-- Địa chỉ nhận hàng -->
            <div class="section-card">
                <div class="section-title">
                    <i class="fas fa-map-marker-alt"></i> Địa chỉ nhận hàng
                </div>
                <div class="address-box">
                    <div class="address-icon">
                        <i class="fas fa-location-dot"></i>
                    </div>
                    <div>
                        <div style="font-weight: 700; margin-bottom: 4px;">
                            ${userProfile.fullName} <span style="font-weight: 400; color: #64748B; margin-left: 10px;">(+84) ${userProfile.phoneNumber}</span>
                        </div>
                        <div style="color: #475569; font-size: 0.95rem;">
                            ${userProfile.address}
                        </div>
                        <div class="mt-2">
                            <span class="badge bg-outline-primary" style="color: var(--primary-color); border: 1px solid var(--primary-color); font-weight: 500;">Mặc định</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Danh sách sản phẩm -->
            <div class="section-card">
                <div class="section-title">
                    <i class="fas fa-box-open"></i> Sản phẩm
                </div>
                <div class="checkout-items">
                    <c:forEach var="item" items="${cart.items}">
                        <div class="item-row">
                            <img src="${pageContext.request.contextPath}${item.imageUrl}" class="item-img" alt="${item.productName}">
                            <div>
                                <div class="item-name">${item.productName}</div>
                                <div class="item-variant">Phân loại: ${item.attributesJson}</div>
                                <div class="mt-1" style="font-weight: 600;">x ${item.quantity}</div>
                            </div>
                            <div class="text-end" style="font-weight: 700;">
                                <fmt:formatNumber value="${item.price * item.quantity}" type="currency" currencySymbol="₫" />
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>

        <div class="col-lg-4">
            <!-- Tóm tắt đơn hàng -->
            <div class="price-summary">
                <h4 style="font-weight: 800; margin-bottom: 25px;">Tóm tắt đơn hàng</h4>
                
                <div class="summary-row">
                    <span style="color: #64748B;">Tổng tiền hàng</span>
                    <span style="font-weight: 600;">
                        <fmt:formatNumber value="${cart.totalPrice}" type="currency" currencySymbol="₫" />
                    </span>
                </div>
                <div class="summary-row">
                    <span style="color: #64748B;">Phí vận chuyển</span>
                    <span style="font-weight: 600; color: #10B981;">Miễn phí</span>
                </div>
                <div class="summary-row">
                    <span style="color: #64748B;">Giảm giá Voucher</span>
                    <span style="font-weight: 600;">- 0 ₫</span>
                </div>

                <div class="total-row">
                    <span>Tổng cộng</span>
                    <span>
                        <fmt:formatNumber value="${cart.totalPrice}" type="currency" currencySymbol="₫" />
                    </span>
                </div>

                <button class="btn btn-order" onclick="placeOrder()">
                    <i class="fas fa-shield-check me-2"></i> ĐẶT HÀNG NGAY
                </button>
                
                <div class="text-center mt-3" style="font-size: 0.8rem; color: #94A3B8;">
                    Nhấn "Đặt hàng" đồng nghĩa với việc bạn đồng ý tuân theo <a href="#" style="color: #64748B;">Điều khoản S-Mall</a>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    function placeOrder() {
        alert('Cảm ơn bạn! Đơn hàng đang được xử lý...');
        window.location.href = '${pageContext.request.contextPath}/';
    }
</script>

</body>
</html>
