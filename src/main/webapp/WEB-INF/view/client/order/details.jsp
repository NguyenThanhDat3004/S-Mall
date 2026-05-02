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
            --primary-color: #065F46;
            --secondary-color: #10B981;
            --bg-body: #F0FDF4;
        }

        body {
            background-color: var(--bg-body);
            font-family: 'Plus Jakarta Sans', sans-serif;
            color: #064E3B;
        }

        .details-container {
            max-width: 1100px;
            margin: 40px auto;
            padding: 0 20px;
        }

        .back-link {
            color: #6B7280;
            text-decoration: none;
            font-weight: 700;
            font-size: 0.85rem;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            padding: 8px 16px;
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
            transition: all 0.3s;
        }
        .back-link:hover { 
            color: var(--primary-color);
            transform: translateX(-5px);
            background: #ECFDF5;
        }

        /* STATUS TIMELINE */
        .status-card {
            background: white;
            border-radius: 24px;
            padding: 40px;
            margin-bottom: 30px;
            box-shadow: 0 10px 25px -5px rgba(0,0,0,0.02);
            border: 1px solid rgba(6, 95, 70, 0.05);
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
            left: 10%;
            right: 10%;
            height: 3px;
            background: #F1F5F9;
            z-index: 1;
            transform: translateY(-50%);
        }
        .timeline-step {
            position: relative;
            z-index: 2;
            background: white;
            padding: 0 15px;
            text-align: center;
            flex: 1;
        }
        .step-icon {
            width: 60px;
            height: 60px;
            background: white;
            border: 3px solid #F1F5F9;
            border-radius: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 15px;
            color: #94A3B8;
            font-size: 1.4rem;
            transition: all 0.5s cubic-bezier(0.4, 0, 0.2, 1);
        }
        .step-label { font-size: 0.7rem; font-weight: 800; color: #94A3B8; text-transform: uppercase; letter-spacing: 0.05em; }

        .timeline-step.active .step-icon {
            border-color: var(--primary-color);
            color: white;
            background: var(--primary-color);
            box-shadow: 0 10px 20px -5px rgba(6, 95, 70, 0.3);
            transform: scale(1.1);
        }
        .timeline-step.active .step-label { color: var(--primary-color); }

        /* ADDRESS & PAYMENT INFO */
        .info-card {
            background: white;
            border-radius: 24px;
            padding: 30px;
            height: 100%;
            box-shadow: 0 10px 25px -5px rgba(0,0,0,0.02);
            border: 1px solid rgba(6, 95, 70, 0.05);
        }
        .info-title { font-weight: 800; font-size: 0.9rem; margin-bottom: 20px; display: flex; align-items: center; gap: 12px; color: var(--primary-color); text-transform: uppercase; letter-spacing: 0.02em; }
        .info-title i { font-size: 1.1rem; opacity: 0.8; }
        .info-content { font-size: 0.95rem; color: #374151; line-height: 1.7; }

        /* PRODUCT LIST */
        .product-card {
            background: white;
            border-radius: 24px;
            padding: 35px;
            margin-top: 30px;
            box-shadow: 0 10px 25px -5px rgba(0,0,0,0.02);
            border: 1px solid rgba(6, 95, 70, 0.05);
        }
        .product-item {
            display: flex;
            gap: 25px;
            padding: 25px 0;
            border-bottom: 1px solid #F3F4F6;
        }
        .product-item:last-child { border-bottom: none; }
        .product-img { width: 110px; height: 110px; border-radius: 18px; object-fit: cover; background: #F9FAFB; border: 1px solid #F3F4F6; }
        .product-info { flex: 1; }
        .product-name { font-weight: 700; font-size: 1.1rem; margin-bottom: 8px; color: #064E3B; }
        .product-variant { font-size: 0.8rem; color: #059669; background: #ECFDF5; display: inline-block; padding: 5px 14px; border-radius: 10px; font-weight: 600; }

        /* PRICE SUMMARY */
        .summary-row {
            display: flex;
            justify-content: space-between;
            padding: 12px 0;
            font-size: 1rem;
            color: #4B5563;
        }
        .summary-total {
            border-top: 2px solid #F3F4F6;
            margin-top: 20px;
            padding-top: 20px;
            font-size: 1.8rem;
            font-weight: 800;
            color: var(--primary-color);
        }

        .badge-status {
            padding: 8px 18px;
            border-radius: 12px;
            font-size: 0.75rem;
            font-weight: 800;
            background: #ECFDF5;
            color: var(--primary-color);
            border: 1px solid rgba(6, 95, 70, 0.1);
        }

        .order-meta-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
            margin-bottom: 30px;
        }
        .order-id-badge {
            font-family: 'Monaco', 'Consolas', monospace;
            font-size: 1.2rem;
            font-weight: 800;
            color: #064E3B;
        }
        .order-date-badge {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 0.9rem;
            color: #6B7280;
            background: white;
            padding: 10px 20px;
            border-radius: 16px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.03);
            border: 1px solid #F1F5F9;
        }
    </style>
</head>
<body>

<jsp:include page="../layout/header.jsp" />

<div class="details-container">
    <div class="order-meta-header">
        <div>
            <a href="${pageContext.request.contextPath}/my-orders" class="back-link mb-4">
                <i class="fas fa-chevron-left"></i> QUAY LẠI DANH SÁCH
            </a>
            <div class="mt-4">
                <span class="text-[10px] text-gray-400 font-bold uppercase tracking-widest block mb-1">Mã đơn hàng</span>
                <span class="order-id-badge">#${order.orderCode}</span>
            </div>
        </div>
        <div class="d-flex flex-column align-items-end gap-3">
            <div class="order-date-badge">
                <i class="far fa-calendar-alt text-emerald-600"></i>
                <span class="text-gray-400">Đặt lúc:</span>
                <span class="fw-bold text-dark">
                    <fmt:parseDate value="${order.createdAt.toString()}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both" />
                    <fmt:formatDate value="${parsedDate}" pattern="HH:mm - dd/MM/yyyy" />
                </span>
            </div>
            <div class="badge-status">
                TRẠNG THÁI: ${order.status.displayName}
            </div>
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
                    <i class="fas fa-map-marker-alt"></i> Thông tin nhận hàng
                </div>
                <div class="info-content">
                    <div class="flex items-center gap-3 mb-4">
                        <div class="w-12 h-12 rounded-full bg-emerald-50 flex items-center justify-center text-emerald-600 font-bold text-lg">
                            ${order.account.profile.fullName.substring(0,1)}
                        </div>
                        <div>
                            <div class="fw-bold text-dark mb-0">${order.account.profile.fullName}</div>
                            <div class="text-emerald-600 font-semibold text-sm">${order.account.profile.phoneNumber}</div>
                        </div>
                    </div>
                    <div class="p-4 bg-gray-50 rounded-2xl border border-gray-100 flex gap-3">
                        <i class="fas fa-location-dot text-gray-300 mt-1"></i>
                        <div class="text-gray-600">${order.shippingAddress}</div>
                    </div>
                </div>
                
                <hr class="my-4" style="border-top: 1px dashed #E2E8F0;">
                
                <div class="info-title">
                    <i class="fas fa-credit-card"></i> Hình thức thanh toán
                </div>
                <div class="info-content">
                    <div class="bg-gradient-to-r from-emerald-50 to-white p-4 rounded-2xl border border-emerald-100 flex items-center gap-4">
                        <div class="w-12 h-12 rounded-xl bg-white shadow-sm flex items-center justify-center text-emerald-600">
                            <c:choose>
                                <c:when test="${order.paymentMethod == 'QR'}"><i class="fas fa-qrcode text-xl"></i></c:when>
                                <c:otherwise><i class="fas fa-money-bill-wave text-xl"></i></c:otherwise>
                            </c:choose>
                        </div>
                        <div>
                            <div class="fw-bold text-emerald-900">
                                <c:choose>
                                    <c:when test="${order.paymentMethod == 'QR'}">Chuyển khoản Ngân hàng (QR)</c:when>
                                    <c:otherwise>Thanh toán khi nhận hàng (COD)</c:otherwise>
                                </c:choose>
                            </div>
                            <div class="small text-emerald-600/70 mt-0.5">
                                <c:choose>
                                    <c:when test="${order.paymentMethod == 'QR'}">Giao dịch đã được hệ thống xác thực an toàn</c:when>
                                    <c:otherwise>Vui lòng chuẩn bị tiền mặt khi bưu tá giao hàng</c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- LOGS/NOTE & QR -->
        <div class="col-md-5 space-y-4">
            <!-- QR Passport Card -->
            <div class="info-card border-2 border-emerald-600/20 bg-gradient-to-br from-white to-emerald-50/30">
                <div class="info-title">
                    <i class="fas fa-qrcode"></i> Digital Shipping Passport
                </div>
                <div class="flex flex-col items-center py-4">
                    <div class="p-3 bg-white rounded-[2rem] shadow-xl border border-emerald-100 mb-4">
                        <img src="https://api.qrserver.com/v1/create-qr-code/?size=180x180&data=${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/order/passport/${order.orderCode}" 
                             class="w-40 h-40 rounded-2xl">
                    </div>
                    <div class="text-center">
                        <div class="text-[10px] text-emerald-800 font-black uppercase tracking-[0.2em] mb-1">Order Passport</div>
                        <p class="text-[11px] text-gray-400 px-6 leading-relaxed">Mã QR định danh đơn hàng (Order Passport) được cấp để Shipper và Seller dễ dàng quản lý, quét để cập nhật trạng thái đơn hàng ngay lập tức.</p>
                    </div>
                </div>
            </div>

            <!-- Shipping & Note Card -->
            <div class="info-card">
                <div class="info-title">
                    <i class="fas fa-paper-plane"></i> Vận chuyển & Ghi chú
                </div>
                <div class="info-content">
                    <div class="space-y-4">
                        <div class="flex justify-between items-center p-3 bg-gray-50 rounded-xl border border-gray-100">
                            <span class="text-xs font-bold text-gray-400 uppercase tracking-wider">Đơn vị vận chuyển</span>
                            <span class="text-sm font-bold text-emerald-700 text-capitalize">${order.shippingMethod}</span>
                        </div>
                        
                        <div class="flex justify-between items-center p-3 bg-gray-50 rounded-xl border border-gray-100">
                            <span class="text-xs font-bold text-gray-400 uppercase tracking-wider">Bảo hiểm hàng hóa</span>
                            <span class="text-sm font-bold ${order.shippingInsurance ? 'text-emerald-600' : 'text-gray-400'}">
                                ${order.shippingInsurance ? '<i class="fas fa-shield-alt mr-1"></i> Đã đăng ký' : 'Không có'}
                            </span>
                        </div>

                        <c:if test="${not empty order.note}">
                            <div class="mt-4">
                                <span class="text-[10px] text-gray-400 font-bold uppercase tracking-widest block mb-2 px-1">Lời nhắn từ người mua</span>
                                <div class="p-4 bg-amber-50/50 rounded-2xl border border-amber-100 text-amber-900 text-sm italic">
                                    "${order.note}"
                                </div>
                            </div>
                        </c:if>

                        <div class="mt-6 p-4 bg-emerald-900 rounded-2xl text-white">
                            <div class="flex items-center gap-3 mb-2">
                                <i class="fas fa-truck-fast text-emerald-300"></i>
                                <span class="text-xs font-bold uppercase tracking-widest text-emerald-200">Trạng thái vận hành</span>
                            </div>
                            <div class="text-sm font-medium">Đơn hàng đang được xử lý theo đúng tiến độ.</div>
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
