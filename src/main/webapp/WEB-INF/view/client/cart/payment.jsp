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
            --primary-color: #1A7A42;
            --primary-dark: #125c31;
            --accent-color: #EF4444;
            --text-main: #1E293B;
            --text-muted: #64748B;
            --bg-body: #F8FAFC;
            --shadow-premium: 0 10px 30px -5px rgba(0, 0, 0, 0.08);
        }

        body {
            background-color: var(--bg-body);
            font-family: 'Plus Jakarta Sans', sans-serif;
            color: var(--text-main);
            padding-bottom: 120px;
        }

        .checkout-container {
            max-width: 1200px;
            margin: 30px auto;
            padding: 0 15px;
        }

        .card-custom {
            background: white;
            border-radius: 16px;
            box-shadow: var(--shadow-premium);
            border: 1px solid rgba(0,0,0,0.03);
            padding: 24px;
            margin-bottom: 24px;
            transition: all 0.3s ease;
        }
        .card-custom:hover { transform: translateY(-2px); }

        .section-title {
            font-weight: 700;
            font-size: 1.1rem;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
            color: var(--primary-color);
        }

        .address-box {
            background: #f0fdf4;
            border: 1px solid #dcfce7;
            border-radius: 12px;
            padding: 16px;
        }

        .address-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px; }
        .user-name { font-weight: 700; font-size: 1.05rem; }
        .user-phone { color: var(--text-muted); margin-left: 8px; }
        .badge-default { background: var(--primary-color); color: white; font-size: 0.75rem; padding: 4px 10px; border-radius: 6px; font-weight: 600; }

        .item-row {
            display: flex;
            gap: 20px;
            padding: 16px 0;
            border-bottom: 1px solid #F1F5F9;
        }
        .item-row:last-child { border-bottom: none; }
        .item-img { width: 80px; height: 80px; border-radius: 12px; object-fit: cover; background: #F1F5F9; }
        .item-info { flex: 1; }
        .item-name { font-weight: 600; font-size: 0.95rem; margin-bottom: 4px; }
        .item-variant { font-size: 0.85rem; color: var(--text-muted); }
        .item-price { font-weight: 700; color: var(--accent-color); }

        .shipping-option, .payment-method {
            border: 2px solid #F1F5F9;
            border-radius: 12px;
            padding: 16px;
            cursor: pointer;
            transition: all 0.2s;
            display: flex;
            align-items: center;
            gap: 15px;
            position: relative;
            height: 100%;
        }
        .shipping-option input, .payment-method input { display: none; }
        .shipping-option:hover, .payment-method:hover { border-color: #CBD5E1; }
        .shipping-option.active, .payment-method.active {
            border-color: var(--primary-color);
            background: rgba(26, 122, 66, 0.03);
        }
        .active::after {
            content: '\f058';
            font-family: 'Font Awesome 5 Free';
            font-weight: 900;
            position: absolute;
            top: 5px;
            right: 10px;
            color: var(--primary-color);
        }

        .sticky-summary {
            position: fixed;
            bottom: 0;
            left: 0;
            right: 0;
            background: white;
            box-shadow: 0 -10px 30px rgba(0,0,0,0.05);
            padding: 15px 0;
            z-index: 1000;
            border-top: 1px solid #f1f5f9;
        }

        .btn-place-order {
            background: var(--primary-color);
            color: white;
            border: none;
            padding: 12px 40px;
            border-radius: 50px;
            font-weight: 700;
            font-size: 1.1rem;
            transition: all 0.3s;
            width: 100%;
            box-shadow: 0 4px 15px rgba(26, 122, 66, 0.2);
        }
        .btn-place-order:hover { background: var(--primary-dark); transform: translateY(-2px); }

        .ship-icon {
            width: 40px;
            height: 40px;
            background: #f1f5f9;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.2rem;
            color: var(--primary-color);
            transition: all 0.3s;
        }
        .active .ship-icon {
            background: var(--primary-color);
            color: white;
        }
        .ship-name { font-weight: 700; font-size: 1rem; color: var(--text-main); margin-bottom: 2px; }
        .ship-desc { font-size: 0.75rem; color: var(--text-muted); }
        .ship-price { font-weight: 800; color: var(--primary-color); font-size: 0.95rem; }

        .payment-method .method-icon {
            width: 45px;
            height: 45px;
            background: #f1f5f9;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.3rem;
            color: var(--primary-color);
        }
        .active .method-icon { background: var(--primary-color); color: white; }

        .logo-mall {
            font-size: 1.8rem;
            font-weight: 800;
            color: var(--primary-color);
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 6px;
        }
        .logo-mall .mall-box {
            background: var(--primary-color);
            color: white;
            padding: 2px 10px;
            border-radius: 8px;
            font-size: 1.4rem;
        }

        .form-check-input:checked { background-color: var(--primary-color); border-color: var(--primary-color); }
    </style>

</head>
<body>

<nav class="navbar bg-white shadow-sm py-3">
    <div class="container">
        <a class="logo-mall" href="${pageContext.request.contextPath}/">
            <span>S</span><span class="mall-box">Mall</span>
            <span class="ms-3 ps-3 border-start text-muted fw-normal" style="font-size: 1.2rem;">Thanh toán</span>
        </a>
    </div>
</nav>

<div class="checkout-container">
    <div class="row">
        <div class="col-lg-8">
            <!-- ĐỊA CHỈ NHẬN HÀNG -->
            <div class="card-custom">
                <div class="section-title">
                    <i class="fas fa-map-marker-alt"></i> Địa chỉ nhận hàng
                </div>
                <div class="address-box">
                    <div class="address-header">
                        <div>
                            <span class="user-name">${userProfile.fullName}</span>
                            <span class="user-phone">(+84) ${userProfile.phoneNumber}</span>
                        </div>
                        <div class="d-flex align-items-center gap-2">
                            <span class="badge-default">Giao tới</span>
                            <button class="btn btn-link p-0 text-muted fw-bold me-2" style="font-size: 0.75rem; text-decoration: none;" onclick="useDefaultAddress()">Dùng mặc định</button>
                            <button class="btn btn-link p-0 text-primary fw-bold" style="font-size: 0.8rem; text-decoration: none;" onclick="toggleEditAddress()">Thay đổi</button>
                        </div>
                    </div>
                    
                    <div id="addressDisplaySection">
                        <p class="mb-2 text-muted" id="displayAddress">
                            ${not empty redisAddress ? redisAddress : userProfile.address}
                        </p>
                    </div>

                    <div id="addressEditSection" class="d-none mt-2">
                        <textarea class="form-control" id="editAddressInput" rows="2" placeholder="Nhập địa chỉ nhận hàng chi tiết...">${not empty redisAddress ? redisAddress : userProfile.address}</textarea>
                        
                        <c:if test="${not empty savedAddresses}">
                            <div class="mt-3">
                                <div class="text-muted small fw-bold mb-2"><i class="fas fa-history me-1"></i> Địa chỉ đã dùng gần đây:</div>
                                <div class="list-group list-group-flush border rounded-3 overflow-hidden">
                                    <c:forEach var="savedAddr" items="${savedAddresses}">
                                        <button type="button" class="list-group-item list-group-item-action py-2 px-3 small text-muted" 
                                                onclick="selectSavedAddress('${savedAddr.fullAddress}')"
                                                style="font-size: 0.75rem; border-left: 3px solid transparent;"
                                                onmouseover="this.style.borderLeftColor='#EE4D2D'"
                                                onmouseout="this.style.borderLeftColor='transparent'">
                                            ${savedAddr.fullAddress}
                                        </button>
                                    </c:forEach>
                                </div>
                            </div>
                        </c:if>

                        <div class="mt-3 text-end">
                            <button class="btn btn-sm btn-light" onclick="toggleEditAddress()">Hủy</button>
                            <button class="btn btn-sm btn-primary" onclick="saveEditAddress()">Xác nhận</button>
                        </div>
                    </div>

                    <div class="form-check mt-3">
                        <input class="form-check-input" type="checkbox" id="saveAddressCheck">
                        <label class="form-check-label text-muted" style="font-size: 0.85rem;" for="saveAddressCheck">
                            Lưu địa chỉ này cho đơn hàng sau (vô thời hạn)
                        </label>
                    </div>
                </div>
            </div>

            <!-- DANH SÁCH SẢN PHẨM -->
            <div class="card-custom">
                <div class="section-title">
                    <i class="fas fa-shopping-bag"></i> Sản phẩm từ Tech Store Official
                </div>
                <div class="items-list">
                    <c:forEach var="item" items="${cart.items}">
                        <div class="item-row">
                            <img src="${pageContext.request.contextPath}${item.imageUrl}" class="item-img">
                            <div class="item-info">
                                <div class="item-name">${item.productName}</div>
                                <div class="item-variant">Loại: ${not empty item.attributesJson ? item.attributesJson : item.sku}</div>
                                <div class="d-flex justify-content-between align-items-center mt-1">
                                    <div class="qty-stepper-sm d-flex align-items-center border rounded-2 overflow-hidden" style="height: 28px;">
                                        <button class="btn btn-sm px-2 py-0 border-end" style="font-size: 0.8rem; height: 100%; background: #f8fafc;" onclick="changeQty(${item.variantId}, -1)">-</button>
                                        <span class="px-3 fw-bold" style="font-size: 0.85rem;" id="qty-${item.variantId}">${item.quantity}</span>
                                        <button class="btn btn-sm px-2 py-0 border-start" style="font-size: 0.8rem; height: 100%; background: #f8fafc;" onclick="changeQty(${item.variantId}, 1)">+</button>
                                    </div>
                                    <span class="item-price" data-price="${item.price}">
                                        <fmt:formatNumber value="${item.price}" type="currency" currencySymbol="₫" />
                                    </span>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>

            <!-- LỰA CHỌN VẬN CHUYỂN -->
            <div class="card-custom">
                <div class="section-title">
                    <i class="fas fa-truck-fast"></i> Phương thức vận chuyển
                </div>
                <div class="row g-3">
                    <div class="col-md-4">
                        <label class="shipping-option" id="ship-economy">
                            <input type="radio" name="shippingMethod" value="economy" onchange="updateSummary()">
                            <div class="ship-content w-100">
                                <div class="d-flex justify-content-between align-items-start mb-2">
                                    <div class="ship-icon"><i class="fas fa-bicycle"></i></div>
                                    <div class="ship-price">15.000đ</div>
                                </div>
                                <div class="ship-name">Tiết kiệm</div>
                                <div class="ship-desc">Giao trong 5-7 ngày</div>
                            </div>
                        </label>
                    </div>
                    <div class="col-md-4">
                        <label class="shipping-option active" id="ship-standard">
                            <input type="radio" name="shippingMethod" value="standard" checked onchange="updateSummary()">
                            <div class="ship-content w-100">
                                <div class="d-flex justify-content-between align-items-start mb-2">
                                    <div class="ship-icon"><i class="fas fa-truck"></i></div>
                                    <div class="ship-price">30.000đ</div>
                                </div>
                                <div class="ship-name">Tiêu chuẩn</div>
                                <div class="ship-desc">Giao trong 2-3 ngày</div>
                                <span class="badge bg-success position-absolute" style="top: -10px; left: 15px; font-size: 0.6rem;">PHỔ BIẾN</span>
                            </div>
                        </label>
                    </div>
                    <div class="col-md-4">
                        <label class="shipping-option" id="ship-express">
                            <input type="radio" name="shippingMethod" value="express" onchange="updateSummary()">
                            <div class="ship-content w-100">
                                <div class="d-flex justify-content-between align-items-start mb-2">
                                    <div class="ship-icon text-warning"><i class="fas fa-bolt"></i></div>
                                    <div class="ship-price">50.000đ</div>
                                </div>
                                <div class="ship-name">Hỏa tốc</div>
                                <div class="ship-desc">Giao trong 24h</div>
                            </div>
                        </label>
                    </div>
                </div>
                <div class="mt-3 p-3 border rounded-3 bg-light d-flex justify-content-between align-items-center">
                    <div>
                        <div class="fw-bold small">Bảo hiểm hàng hóa</div>
                        <div class="text-muted" style="font-size: 0.7rem;">Bảo vệ đơn hàng khỏi hư hỏng, thất lạc</div>
                    </div>
                    <div class="form-check form-switch">
                        <input class="form-check-input" type="checkbox" id="insuranceCheck" onchange="updateSummary()">
                        <span class="ms-2 fw-bold text-primary">10k</span>
                    </div>
                </div>
            </div>

            <!-- PHƯƠNG THỨC THANH TOÁN -->
            <div class="card-custom">
                <div class="section-title">
                    <i class="fas fa-credit-card"></i> Phương thức thanh toán
                </div>
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="payment-method active" id="pay-cod">
                            <input type="radio" name="paymentMethod" value="cod" checked onchange="updateSummary()">
                            <div class="method-icon"><i class="fas fa-money-bill-wave"></i></div>
                            <div>
                                <div class="fw-bold">Thanh toán khi nhận hàng</div>
                                <div class="small text-muted">Trả tiền mặt khi Shipper giao tới</div>
                            </div>
                        </label>
                    </div>
                    <div class="col-md-6">
                        <label class="payment-method" id="pay-qr">
                            <input type="radio" name="paymentMethod" value="qr" onchange="updateSummary()">
                            <div class="method-icon"><i class="fas fa-qrcode"></i></div>
                            <div>
                                <div class="fw-bold">Chuyển khoản QR</div>
                                <div class="small text-muted">Quét mã QR để thanh toán ngay</div>
                            </div>
                        </label>
                    </div>
                </div>
            </div>
        </div>

            <!-- TÓM TẮT ĐƠN HÀNG -->
            <div class="col-lg-4">
                <div class="card-custom sticky-top" style="top: 20px;">
                    <div class="section-title">Tóm tắt đơn hàng</div>
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <span class="text-muted">Tổng tiền hàng</span>
                        <span class="fw-bold" id="subtotalVal">
                            <fmt:formatNumber value="${cart.totalPrice}" type="currency" currencySymbol="₫" />
                        </span>
                    </div>
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <span class="text-muted">Phí vận chuyển</span>
                        <span class="fw-bold text-success" id="shippingVal">30.000đ</span>
                    </div>
                    <div class="d-flex justify-content-between align-items-center mb-3 d-none" id="insuranceRow">
                        <span class="text-muted">Bảo hiểm</span>
                        <span class="fw-bold text-success">10.000đ</span>
                    </div>
                    <hr class="my-3">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <span class="fw-bold" style="font-size: 1.1rem;">Tổng thanh toán</span>
                        <span class="fw-bold text-danger" style="font-size: 1.5rem;" id="totalVal">
                            <fmt:formatNumber value="${cart.totalPrice + 30000}" type="currency" currencySymbol="₫" />
                        </span>
                    </div>
                    
                    <div class="mb-3">
                        <div class="input-group">
                            <input type="text" class="form-control" placeholder="Mã giảm giá">
                            <button class="btn btn-outline-success">Áp dụng</button>
                        </div>
                    </div>
    
                    <div class="alert alert-success py-2 border-0" style="font-size: 0.75rem; background: #f0fdf4; color: #166534;">
                        <i class="fas fa-shield-alt me-1"></i> S-Mall đảm bảo nhận hàng hoặc hoàn tiền 100%.
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <div class="sticky-summary">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-6 col-md-8">
                    <div class="text-muted small">Tổng thanh toán:</div>
                    <div class="fw-bold text-danger fs-3" id="stickyTotal">0đ</div>
                </div>
                <div class="col-6 col-md-4 text-end">
                    <button class="btn-place-order" id="btnSubmitOrder" onclick="placeOrder()">Đặt Hàng</button>
                </div>
            </div>
        </div>
    </div>

    <style>
        /* Làm backdrop modal hoàn toàn trong suốt nhưng vẫn cho phép đóng khi click ngoài */
        .modal-backdrop { 
            background-color: transparent !important;
            opacity: 0 !important; 
            z-index: 9998 !important;
        }
        .modal {
            z-index: 9999 !important;
        }
        .modal-content { 
            border-radius: 20px; 
            box-shadow: 0 20px 60px rgba(0,0,0,0.3) !important;
            border: 1px solid #eee;
        }
    </style>
    <script>
        let qrModalInstance = null; // Tránh tạo nhiều instance gây tối màn hình
        
        document.addEventListener('DOMContentLoaded', function() {
            const addr = document.getElementById('displayAddress');
            if(addr && addr.innerText.includes('Qu?ng')) {
                addr.innerText = addr.innerText.replace('Qu?ng', 'Quảng');
            }
            // Khởi tạo modal một lần duy nhất
            qrModalInstance = new bootstrap.Modal(document.getElementById('qrModal'));
        });
    </script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    const subtotal = ${cart.totalPrice};
    const shippingPrices = { economy: 15000, standard: 30000, express: 50000 };

    const profileAddress = `${userProfile.address}`;

    function toggleEditAddress() {
        document.getElementById('addressDisplaySection').classList.toggle('d-none');
        document.getElementById('addressEditSection').classList.toggle('d-none');
    }
    
    function selectSavedAddress(addr) {
        document.getElementById('editAddressInput').value = addr;
    }

    function useDefaultAddress() {
        document.getElementById('displayAddress').textContent = profileAddress;
        document.getElementById('editAddressInput').value = profileAddress;
        alert('Đã chuyển về địa chỉ mặc định trong hồ sơ!');
    }

    function saveEditAddress() {
        const newVal = document.getElementById('editAddressInput').value;
        if (newVal.trim() === '') {
            alert('Vui lòng nhập địa chỉ!');
            return;
        }
        document.getElementById('displayAddress').textContent = newVal;
        toggleEditAddress();
    }

    function changeQty(vId, delta) {
        if (window.event) window.event.preventDefault();
        
        const el = document.getElementById('qty-' + vId);
        if (!el) {
            console.error("Không tìm thấy phần tử số lượng cho ID: " + vId);
            return;
        }
        
        let val = parseInt(el.textContent) || 1;
        let nextVal = val + delta;

        if (nextVal < 1) {
            alert('Số lượng tối thiểu là 1 sản phẩm!');
            return;
        }

        el.textContent = nextVal;
        updateSummary();

        // Cập nhật lên server ngầm
        const p = new URLSearchParams();
        p.append('variantId', vId);
        p.append('quantity', nextVal);
        fetch('${pageContext.request.contextPath}/api/cart/update', { method: 'POST', body: p });
    }

    function updateSummary() {
        try {
            const shipOpt = document.querySelector('input[name="shippingMethod"]:checked');
            const payOpt = document.querySelector('input[name="paymentMethod"]:checked');
            
            // Highlight border
            document.querySelectorAll('.shipping-option').forEach(e => e.classList.remove('active'));
            if (shipOpt) shipOpt.closest('.shipping-option').classList.add('active');
            
            document.querySelectorAll('.payment-method').forEach(e => e.classList.remove('active'));
            if (payOpt) payOpt.closest('.payment-method').classList.add('active');

            // Tính tiền hàng
            let sub = 0;
            document.querySelectorAll('.item-row').forEach(row => {
                const pEl = row.querySelector('.item-price');
                const qEl = row.querySelector('[id^="qty-"]');
                if (pEl && qEl) {
                    const price = parseFloat(pEl.getAttribute('data-price')) || 0;
                    const qty = parseInt(qEl.textContent) || 0;
                    sub += (price * qty);
                }
            });

            // Phí ship & Bảo hiểm
            const sFee = shipOpt ? (shippingPrices[shipOpt.value] || 0) : 0;
            const insCheck = document.getElementById('insuranceCheck');
            const iFee = (insCheck && insCheck.checked) ? 10000 : 0;
            const total = sub + sFee + iFee;

            // Hiển thị tiền
            const fmt = (v) => new Intl.NumberFormat('vi-VN').format(v) + 'đ';
            const cur = (v) => new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(v).replace('₫', 'đ');

            if (document.getElementById('subtotalVal')) document.getElementById('subtotalVal').textContent = fmt(sub);
            if (document.getElementById('shippingVal')) document.getElementById('shippingVal').textContent = fmt(sFee);
            if (document.getElementById('totalVal')) document.getElementById('totalVal').textContent = cur(total);
            if (document.getElementById('stickyTotal')) document.getElementById('stickyTotal').textContent = cur(total);
            
            const insRow = document.getElementById('insuranceRow');
            if (insRow) {
                if (iFee > 0) insRow.classList.remove('d-none');
                else insRow.classList.add('d-none');
            }
        } catch (err) {
            console.error("Lỗi tính toán:", err);
        }
    }

    document.addEventListener('DOMContentLoaded', updateSummary);

    function placeOrder() {
        const payMethod = document.querySelector('input[name="paymentMethod"]:checked').value;
        
        if (payMethod === 'qr') {
            const totalStr = document.getElementById('totalVal').textContent;
            const urlParams = new URLSearchParams(window.location.search);
            const ids = urlParams.get('ids');
            const shipMethod = document.querySelector('input[name="shippingMethod"]:checked').value;
            const insurance = document.getElementById('insuranceCheck').checked;
            const address = document.getElementById('displayAddress').textContent.trim();
            const saveAddr = document.getElementById('saveAddressCheck').checked;
            
            // Simulation URL: This will trigger the email when visited
            const simulationUrl = window.location.origin + '${pageContext.request.contextPath}/payment/simulation' 
                                + '?userId=${userProfile.id}'
                                + '&amount=' + encodeURIComponent(totalStr)
                                + '&ids=' + ids
                                + '&ship=' + shipMethod
                                + '&addr=' + encodeURIComponent(address)
                                + '&ins=' + insurance
                                + '&saveAddr=' + saveAddr;
            
            // Generate QR pointing to our simulation endpoint
            updateSimulationQR();
            
            if (qrModalInstance) qrModalInstance.show();
            return;
        }
        
        submitOrder();
    }

    let statusCheckInterval = null;

    function updateSimulationQR() {
        const totalStr = document.getElementById('totalVal').textContent;
        const urlParams = new URLSearchParams(window.location.search);
        const ids = urlParams.get('ids');
        const shipMethod = document.querySelector('input[name="shippingMethod"]:checked').value;
        const insurance = document.getElementById('insuranceCheck').checked;
        const address = document.getElementById('displayAddress').textContent.trim();
        
        // Get IP from input, or localStorage, or use current origin
        let customIp = document.getElementById('localIpInput').value.trim();
        if (!customIp) {
            customIp = localStorage.getItem('s_mall_local_ip') || '';
            document.getElementById('localIpInput').value = customIp;
        } else {
            localStorage.setItem('s_mall_local_ip', customIp);
        }

        let baseOrigin = window.location.origin;
        if (customIp) {
            baseOrigin = (window.location.protocol + "//" + customIp + (window.location.port ? ":" + window.location.port : ""));
        }

        const saveAddr = document.getElementById('saveAddressCheck').checked;

        const simulationUrl = baseOrigin + '${pageContext.request.contextPath}/payment/simulation' 
                            + '?userId=${userProfile.id}'
                            + '&amount=' + encodeURIComponent(totalStr)
                            + '&ids=' + ids
                            + '&ship=' + shipMethod
                            + '&addr=' + encodeURIComponent(address)
                            + '&ins=' + insurance
                            + '&saveAddr=' + saveAddr;
        
        const qrUrl = "https://api.qrserver.com/v1/create-qr-code/?size=250x250&data=" + encodeURIComponent(simulationUrl);
        const qrImg = document.getElementById('qrImage');
        qrImg.src = qrUrl;
        qrImg.onclick = function() { window.open(simulationUrl, '_blank'); };
        
        document.getElementById('qrAmount').textContent = totalStr;
        document.getElementById('qrContent').textContent = "Thanh toán đơn hàng ID: " + ids;
        document.getElementById('qrStatus').textContent = "Đang trỏ tới: " + baseOrigin;

        // Bắt đầu tự động kiểm tra trạng thái thanh toán
        startStatusPolling(ids);
    }

    function startStatusPolling(ids) {
        if (statusCheckInterval) clearInterval(statusCheckInterval);
        console.log("Bắt đầu kiểm tra trạng thái thanh toán cho IDs: " + ids);
        
        statusCheckInterval = setInterval(function() {
            const checkUrl = '${pageContext.request.contextPath}/api/cart/check-status?ids=' + ids;
            fetch(checkUrl)
                .then(response => {
                    if (!response.ok) throw new Error("Network response was not ok");
                    return response.json();
                })
                .then(data => {
                    console.log("Kết quả kiểm tra thanh toán:", data.isDone);
                    if (data.isDone) {
                        console.log("Thanh toán thành công! Đang chuyển hướng...");
                        clearInterval(statusCheckInterval);
                        
                        // Đóng modal bằng cách nhấn vào nút đóng có sẵn
                        const closeBtn = document.querySelector('#qrModal [data-bs-dismiss="modal"]');
                        if (closeBtn) closeBtn.click();
                        
                        window.location.href = '${pageContext.request.contextPath}/?order_success=true';
                    }
                })
                .catch(err => {
                    console.error("Lỗi khi kiểm tra trạng thái:", err);
                });
        }, 2000); // Kiểm tra mỗi 2 giây cho nhạy
    }

    // Đảm bảo dừng polling khi đóng modal thủ công
    document.getElementById('qrModal').addEventListener('hidden.bs.modal', function () {
        if (statusCheckInterval) clearInterval(statusCheckInterval);
    });

    function confirmQrPayment() {
        const modalEl = document.getElementById('qrModal');
        const modal = bootstrap.Modal.getInstance(modalEl);
        if (modal) modal.hide();
        
        submitOrder();
    }

    function submitOrder() {
        const urlParams = new URLSearchParams(window.location.search);
        const ids = urlParams.get('ids');
        const shipMethod = document.querySelector('input[name="shippingMethod"]:checked').value;
        const payMethod = document.querySelector('input[name="paymentMethod"]:checked').value;
        const insurance = document.getElementById('insuranceCheck').checked;
        const address = document.getElementById('displayAddress').textContent.trim();
        const saveAddr = document.getElementById('saveAddressCheck').checked;

        const btn = document.getElementById('btnSubmitOrder');
        btn.disabled = true;
        btn.innerHTML = '<span class="spinner-border spinner-border-sm"></span> Đang xử lý...';

        const formData = new FormData();
        formData.append('ids', ids);
        formData.append('shippingMethod', shipMethod);
        formData.append('paymentMethod', payMethod);
        formData.append('insurance', insurance);
        formData.append('address', address);
        formData.append('saveAddress', saveAddr);

        fetch('${pageContext.request.contextPath}/api/orders/place', {
            method: 'POST',
            body: formData
        })
        .then(res => res.json())
        .then(data => {
            if (data.status === 'success') {
                window.location.href = '${pageContext.request.contextPath}/?order_success=true';
            } else {
                alert('Lỗi: ' + data.message);
                btn.disabled = false;
                btn.textContent = 'Đặt Hàng';
            }
        })
        .catch(err => {
            console.error("Lỗi đặt hàng:", err);
            btn.disabled = false;
            btn.textContent = 'Đặt Hàng';
            alert('Có lỗi xảy ra khi đặt hàng. Vui lòng thử lại!');
        });
    }

    // Khởi tạo lần đầu
    updateSummary();
</script>

<!-- QR Payment Modal (Moved to end for better layering) -->
<div class="modal fade" id="qrModal" tabindex="-1" aria-hidden="true" data-bs-backdrop="true">
    <div class="modal-dialog modal-dialog-centered" style="z-index: 10000;">
        <div class="modal-content">
            <div class="modal-body p-4">
                <div class="text-center mb-4">
                    <h5 class="fw-bold">Thanh toán qua QR Code</h5>
                    <div class="input-group input-group-sm mx-auto mb-2" style="max-width: 250px;">
                        <span class="input-group-text bg-light border-0" style="font-size: 0.7rem;">IP Máy tính:</span>
                        <input type="text" id="localIpInput" class="form-control border-0 bg-light" value="${serverIp}" placeholder="Ví dụ: 192.168.1.5" style="font-size: 0.7rem;" onchange="updateSimulationQR()">
                    </div>
                    <p class="text-muted" style="font-size: 0.65rem;">(Nhập IP máy tính để quét được bằng điện thoại)</p>
                </div>
                
                <div class="text-center mb-4">
                    <div class="p-2 bg-white d-inline-block rounded-4 shadow-sm mb-3">
                        <img id="qrImage" src="" alt="QR Code" class="img-fluid" style="max-width: 250px; border-radius: 10px; cursor: pointer;" title="Click để giả lập quét mã">
                    </div>
                    <div class="mt-2 p-3 bg-light rounded-4" style="border: 2px dashed #EE4D2D;">
                        <div class="text-muted small mb-1">Số tiền cần thanh toán:</div>
                        <div class="fw-bold text-danger" id="qrAmount" style="font-size: 2.2rem; letter-spacing: -1px;">0đ</div>
                        <div id="qrStatus" class="mt-2 text-primary fw-bold" style="font-size: 0.7rem;"></div>
                    </div>
                    
                    <!-- Nút bấm giả lập quét mã nhanh -->
                    <div class="mt-4">
                        <button type="button" class="btn btn-outline-primary w-100 py-2 fw-bold" style="border-radius: 12px; border-style: dashed;" onclick="document.getElementById('qrImage').click()">
                            <i class="fas fa-magic me-2"></i> Giả lập quét mã trên máy tính
                        </button>
                        <p class="text-muted" style="font-size: 0.7rem; margin-top: 8px;">
                            (Dành cho môi trường Local: Nhấn nút này để thay thế việc quét mã bằng điện thoại)
                        </p>
                    </div>
                </div>
                
                <div class="text-start bg-light p-3 rounded-3 mb-3" style="font-size: 0.85rem;">
                    <div class="d-flex justify-content-between mb-2">
                        <span class="text-muted">Ngân hàng:</span>
                        <span class="fw-bold">Techcombank (Ngân hàng Kỹ thương)</span>
                    </div>
                    <div class="d-flex justify-content-between mb-2">
                        <span class="text-muted">Chủ tài khoản:</span>
                        <span class="fw-bold">NGUYEN THANH DAT</span>
                    </div>
                    <div class="d-flex justify-content-between mb-2">
                        <span class="text-muted">Số tài khoản:</span>
                        <span class="fw-bold">300420059999</span>
                    </div>
                    <div class="d-flex justify-content-between">
                        <span class="text-muted">Nội dung:</span>
                        <span class="fw-bold text-primary" id="qrContent">SMALL_${userProfile.id}</span>
                    </div>
                </div>
                
                <div class="alert alert-warning py-2 border-0" style="font-size: 0.75rem;">
                    <i class="fas fa-info-circle me-1"></i> Lưu ý: Vui lòng không thay đổi nội dung chuyển khoản để hệ thống tự động xác nhận đơn hàng.
                </div>

                <div class="alert alert-warning small text-center mb-4" style="border-radius: 12px; border: none;">
                    <i class="fas fa-spinner fa-spin me-2"></i> Đang chờ bạn quét mã và xác nhận qua Email...
                </div>

                <button class="btn btn-danger w-100 py-2 fw-bold mb-2" style="border-radius: 12px;" data-bs-dismiss="modal">
                    Hủy và quay lại
                </button>
                <p class="text-muted small text-center mb-0">Bạn có thể đóng cửa sổ này bất cứ lúc nào nếu không muốn tiếp tục.</p>
            </div>
        </div>
    </div>
</div>

</body>
</html>
