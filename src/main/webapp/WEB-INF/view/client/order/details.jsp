<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết đơn hàng | S-Mall</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-color: #EE4D2D;
            --secondary-color: #26aa99;
            --bg-body: #F8FAFC;
        }

        body {
            background-color: var(--bg-body);
            font-family: 'Plus Jakarta Sans', sans-serif;
            color: #1E293B;
        }

        .details-container {
            max-width: 1000px;
            margin: 40px auto;
            padding: 0 15px;
        }

        .back-link {
            color: #64748B;
            text-decoration: none;
            font-weight: 600;
            font-size: 0.9rem;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 20px;
            transition: all 0.2s;
        }
        .back-link:hover { color: var(--primary-color); }

        /* STATUS TIMELINE */
        .status-card {
            background: white;
            border-radius: 12px;
            padding: 30px;
            margin-bottom: 20px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.02);
            border: 1px solid #F1F5F9;
        }

        .timeline {
            display: flex;
            justify-content: space-between;
            position: relative;
            padding: 20px 0;
        }
        .timeline::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 5%;
            right: 5%;
            height: 2px;
            background: #E2E8F0;
            z-index: 1;
            transform: translateY(-50%);
        }
        .timeline-step {
            position: relative;
            z-index: 2;
            background: white;
            padding: 0 10px;
            text-align: center;
            flex: 1;
        }
        .step-icon {
            width: 50px;
            height: 50px;
            background: white;
            border: 2px solid #E2E8F0;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 10px;
            color: #94A3B8;
            font-size: 1.2rem;
            transition: all 0.3s;
        }
        .step-label { font-size: 0.75rem; font-weight: 700; color: #64748B; text-transform: uppercase; }

        .timeline-step.active .step-icon {
            border-color: var(--secondary-color);
            color: var(--secondary-color);
            box-shadow: 0 0 0 4px rgba(38, 170, 153, 0.1);
        }
        .timeline-step.active .step-label { color: var(--secondary-color); }

        /* ADDRESS & PAYMENT INFO */
        .info-card {
            background: white;
            border-radius: 12px;
            padding: 24px;
            height: 100%;
            box-shadow: 0 4px 12px rgba(0,0,0,0.02);
            border: 1px solid #F1F5F9;
        }
        .info-title { font-weight: 700; font-size: 1rem; margin-bottom: 15px; display: flex; align-items: center; gap: 10px; }
        .info-title i { color: var(--primary-color); }
        .info-content { font-size: 0.9rem; color: #475569; line-height: 1.6; }

        /* PRODUCT LIST */
        .product-card {
            background: white;
            border-radius: 12px;
            padding: 24px;
            margin-top: 20px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.02);
            border: 1px solid #F1F5F9;
        }
        .product-item {
            display: flex;
            gap: 20px;
            padding: 20px 0;
            border-bottom: 1px solid #F1F5F9;
        }
        .product-item:last-child { border-bottom: none; }
        .product-img { width: 100px; height: 100px; border-radius: 12px; object-fit: cover; background: #F8FAFC; border: 1px solid #F1F5F9; }
        .product-info { flex: 1; }
        .product-name { font-weight: 700; font-size: 1rem; margin-bottom: 5px; color: #1E293B; }
        .product-variant { font-size: 0.85rem; color: #64748B; background: #F1F5F9; display: inline-block; padding: 4px 12px; border-radius: 6px; }

        /* PRICE SUMMARY */
        .summary-row {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            font-size: 0.95rem;
            color: #475569;
        }
        .summary-total {
            border-top: 1px solid #F1F5F9;
            margin-top: 15px;
            padding-top: 15px;
            font-size: 1.4rem;
            font-weight: 800;
            color: var(--primary-color);
        }

        .badge-status {
            padding: 6px 16px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 700;
            text-transform: uppercase;
        }
    </style>
</head>
<body>

<jsp:include page="../layout/header.jsp" />

<div class="details-container">
    <div class="d-flex justify-content-between align-items-center mb-2">
        <a href="${pageContext.request.contextPath}/my-orders" class="back-link">
            <i class="fas fa-arrow-left"></i> TRỞ LẠI
        </a>
        <div class="small text-muted">
            MÃ ĐƠN HÀNG: <span class="fw-bold text-dark">${order.orderCode}</span>
            <span class="mx-2">|</span>
            TRẠNG THÁI: <span class="text-primary fw-bold">${order.status}</span>
        </div>
    </div>

    <!-- TIMELINE -->
    <div class="status-card">
        <div class="timeline">
            <div class="timeline-step ${order.status == 'PENDING' || order.status == 'CONFIRMED' || order.status == 'SHIPPING' || order.status == 'DELIVERED' ? 'active' : ''}">
                <div class="step-icon"><i class="fas fa-file-invoice"></i></div>
                <div class="step-label">Đơn Hàng Đã Đặt</div>
            </div>
            <div class="timeline-step ${order.status == 'CONFIRMED' || order.status == 'SHIPPING' || order.status == 'DELIVERED' ? 'active' : ''}">
                <div class="step-icon"><i class="fas fa-check-circle"></i></div>
                <div class="step-label">Đã Xác Nhận</div>
            </div>
            <div class="timeline-step ${order.status == 'SHIPPING' || order.status == 'DELIVERED' ? 'active' : ''}">
                <div class="step-icon"><i class="fas fa-truck"></i></div>
                <div class="step-label">Đang Giao Hàng</div>
            </div>
            <div class="timeline-step ${order.status == 'DELIVERED' ? 'active' : ''}">
                <div class="step-icon"><i class="fas fa-box-open"></i></div>
                <div class="step-label">Đã Nhận Hàng</div>
            </div>
        </div>
    </div>

    <div class="row g-4">
        <!-- ADDRESS -->
        <div class="col-md-7">
            <div class="info-card">
                <div class="info-title">
                    <i class="fas fa-map-marker-alt"></i> Địa chỉ nhận hàng
                </div>
                <div class="info-content">
                    <div class="fw-bold text-dark mb-1">${order.account.profile.fullName}</div>
                    <div class="mb-1">${order.account.profile.phoneNumber}</div>
                    <div class="text-muted">${order.shippingAddress}</div>
                </div>
                
                <hr class="my-4" style="border-top: 1px dashed #E2E8F0;">
                
                <div class="info-title">
                    <i class="fas fa-credit-card"></i> Phương thức thanh toán
                </div>
                <div class="info-content d-flex align-items-center gap-3">
                    <div class="bg-light p-3 rounded-3 flex-grow-1">
                        <span class="fw-bold text-dark">
                            <c:choose>
                                <c:when test="${order.paymentMethod == 'QR'}">Chuyển khoản QR Code</c:when>
                                <c:otherwise>Thanh toán khi nhận hàng (COD)</c:otherwise>
                            </c:choose>
                        </span>
                        <div class="small text-muted mt-1">
                            <c:choose>
                                <c:when test="${order.paymentMethod == 'QR'}">Đã xác nhận thanh toán qua ngân hàng</c:when>
                                <c:otherwise>Vui lòng chuẩn bị tiền mặt khi nhận hàng</c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- LOGS/NOTE -->
        <div class="col-md-5">
            <div class="info-card">
                <div class="info-title">
                    <i class="fas fa-info-circle"></i> Ghi chú & Lịch sử
                </div>
                <div class="info-content">
                    <c:if test="${not empty order.note}">
                        <div class="p-3 bg-light rounded-3 mb-3 fst-italic">
                            "${order.note}"
                        </div>
                    </c:if>
                    
                    <div class="small">
                        <div class="d-flex justify-content-between mb-2">
                            <span>Thời gian đặt hàng:</span>
                            <span class="text-dark">${order.createdAt.toString().replace('T', ' ').substring(0, 16)}</span>
                        </div>
                        <div class="d-flex justify-content-between mb-2">
                            <span>Phương thức vận chuyển:</span>
                            <span class="text-dark fw-bold text-capitalize">${order.shippingMethod}</span>
                        </div>
                        <div class="d-flex justify-content-between">
                            <span>Bảo hiểm hàng hóa:</span>
                            <span class="${order.shippingInsurance ? 'text-success' : 'text-muted'}">
                                ${order.shippingInsurance ? 'Đã đăng ký' : 'Không đăng ký'}
                            </span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- PRODUCT LIST -->
    <div class="product-card">
        <div class="info-title mb-4">
            <i class="fas fa-shopping-bag"></i> Sản phẩm trong đơn hàng
        </div>
        
        <c:forEach var="detail" items="${order.orderDetails}">
            <div class="product-item">
                <img src="${pageContext.request.contextPath}${detail.productVariant.imageUrl}" class="product-img">
                <div class="product-info">
                    <div class="product-name">${detail.product.name}</div>
                    <div class="product-variant mb-2">${detail.productVariant.attributesJson}</div>
                    <div class="small text-muted">Số lượng: x${detail.quantity}</div>
                </div>
                <div class="text-end">
                    <div class="fw-bold text-primary fs-5">
                        <fmt:formatNumber value="${detail.priceAtPurchase}" type="currency" currencySymbol="₫" />
                    </div>
                    <div class="small text-muted text-decoration-line-through">
                        <fmt:formatNumber value="${detail.product.price}" type="currency" currencySymbol="₫" />
                    </div>
                </div>
            </div>
        </c:forEach>
        
        <!-- SUMMARY -->
        <div class="mt-4 pt-2 ms-auto" style="max-width: 400px;">
            <div class="summary-row">
                <span>Tổng tiền hàng:</span>
                <span class="text-dark fw-bold"><fmt:formatNumber value="${order.totalPrice - order.shippingFee - (order.shippingInsurance ? 10000 : 0)}" type="currency" currencySymbol="₫" /></span>
            </div>
            <div class="summary-row">
                <span>Phí vận chuyển:</span>
                <span class="text-dark"><fmt:formatNumber value="${order.shippingFee}" type="currency" currencySymbol="₫" /></span>
            </div>
            <c:if test="${order.shippingInsurance}">
                <div class="summary-row">
                    <span>Phí bảo hiểm:</span>
                    <span class="text-dark">10.000₫</span>
                </div>
            </c:if>
            <div class="summary-row summary-total">
                <span>Tổng thanh toán:</span>
                <span><fmt:formatNumber value="${order.totalPrice}" type="currency" currencySymbol="₫" /></span>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../layout/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
