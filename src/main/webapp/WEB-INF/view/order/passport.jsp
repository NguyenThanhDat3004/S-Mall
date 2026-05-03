<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>S-Mall Logistics | Hộ chiếu đơn hàng</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
    <style>
        :root {
            --bg-body: #f1f5f9;
            --bg-card: #ffffff;
            --primary: #10b981;
            --primary-glow: rgba(16, 185, 129, 0.2);
            --accent: #10b981;
            --border: rgba(0, 0, 0, 0.08);
            --text-main: #1e293b;
            --text-muted: #64748b;
            --card-radius: 20px;
        }

        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Outfit', sans-serif; background-color: var(--bg-body); color: var(--text-main); min-height: 100vh; }

        .top-nav {
            display: flex; justify-content: space-between; align-items: center; padding: 1.2rem 4rem;
            background: #ffffff; border-bottom: 1px solid var(--border); position: sticky; top: 0; z-index: 100;
        }
        .logo-area { display: flex; flex-direction: column; gap: 4px; text-decoration: none; }
        .logo-brand { display: flex; align-items: center; gap: 8px; }
        .logo-s { font-size: 2.2rem; font-weight: 800; color: var(--accent); line-height: 1; }
        .logo-mall { 
            background: var(--accent); color: #fff; padding: 4px 12px; border-radius: 12px; 
            font-size: 1.6rem; font-weight: 700; line-height: 1; display: inline-block;
        }
        .logo-subtitle { font-size: 0.85rem; font-weight: 600; color: #64748b; text-transform: uppercase; letter-spacing: 1.5px; }
        
        .order-id-nav { text-align: right; }
        .order-id-nav label { font-size: 0.75rem; color: var(--text-muted); display: block; }
        .order-id-nav span { font-weight: 700; font-family: monospace; font-size: 1.1rem; }

        .dashboard-container {
            display: grid; grid-template-columns: 320px 1fr 320px; gap: 24px;
            padding: 24px 4rem; max-width: 1600px; margin: 0 auto;
        }

        .card { background: var(--bg-card); border-radius: var(--card-radius); border: 1px solid var(--border); padding: 24px; height: fit-content; }
        .card-title { font-size: 1rem; font-weight: 700; margin-bottom: 1.5rem; text-transform: uppercase; letter-spacing: 0.5px; }

        .qr-card { text-align: center; border-top: 4px solid var(--primary); }
        .qr-wrapper { background: #fff; padding: 12px; border-radius: 16px; display: inline-block; margin-bottom: 20px; border: 1px solid var(--border); }
        .qr-wrapper img { width: 220px; height: 220px; }
        
        .status-badge {
            background: rgba(16, 185, 129, 0.1); color: var(--primary); padding: 8px 16px;
            border-radius: 99px; font-size: 0.875rem; font-weight: 700; display: inline-flex; align-items: center; gap: 8px; margin-bottom: 24px;
        }
        .status-dot { width: 8px; height: 8px; background: var(--primary); border-radius: 50%; animation: pulse 2s infinite; }
        @keyframes pulse { 0% { opacity: 1; } 50% { opacity: 0.4; } 100% { opacity: 1; } }
        
        .action-buttons { display: flex; flex-direction: column; gap: 12px; }
        .btn { padding: 14px; border-radius: 12px; font-weight: 700; font-size: 0.95rem; cursor: pointer; border: none; text-align: center; text-decoration: none; display: block; width: 100%; }
        .btn-confirm { background: var(--primary); color: #fff; box-shadow: 0 4px 14px var(--primary-glow); }
        .btn-secondary { background: #fff; color: var(--text-main); border: 1px solid var(--border); }

        .manifest-header { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; margin-bottom: 24px; }
        .actor-card { background: #fff; padding: 16px; border-radius: 16px; display: flex; align-items: center; gap: 12px; border: 1px solid var(--border); overflow: hidden; }
        .avatar { width: 56px; height: 56px; border-radius: 14px; object-fit: cover; border: 1px solid var(--border); background: var(--bg-body); flex-shrink: 0; }
        .actor-info { min-width: 0; flex: 1; }
        .actor-info label { font-size: 0.7rem; color: var(--text-muted); display: block; text-transform: uppercase; margin-bottom: 2px; }
        .actor-info h4 { font-size: 1rem; font-weight: 700; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }

        .product-list { display: flex; flex-direction: column; gap: 12px; }
        .product-item { background: #f8fafc; padding: 12px 16px; border-radius: 12px; display: flex; align-items: center; gap: 16px; border: 1px solid var(--border); }
        .p-icon { width: 44px; height: 44px; background: #fff; border-radius: 10px; display: flex; align-items: center; justify-content: center; font-size: 1.2rem; border: 1px solid var(--border); flex-shrink: 0; }
        .p-details { flex: 1; min-width: 0; }
        .p-details h4 { font-size: 0.9rem; font-weight: 600; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .p-qty { font-size: 0.85rem; font-weight: 600; color: var(--text-muted); }
        .p-price { font-weight: 700; color: var(--accent); }

        .summary-row { 
            display: flex; justify-content: space-between; align-items: center; 
            padding: 12px 0; border-bottom: 1px solid rgba(0,0,0,0.04); 
        }
        .summary-row:last-child { border-bottom: none; }
        .summary-row label { color: var(--text-muted); font-size: 0.85rem; font-weight: 500; }
        .summary-row span { font-weight: 700; font-size: 0.9rem; text-align: right; }
        .status-tag { 
            background: var(--primary-glow); color: var(--primary); 
            padding: 4px 12px; border-radius: 8px; font-size: 0.8rem;
        }

        .total-card { margin-top: 20px; padding-top: 20px; border-top: 2px dashed var(--border); display: flex; justify-content: space-between; align-items: center; }
        .total-card label { font-weight: 600; color: var(--text-muted); }
        .total-card span { font-size: 1.4rem; font-weight: 800; }

        .ledger-list { display: flex; flex-direction: column; }
        .ledger-item { position: relative; padding-left: 32px; padding-bottom: 24px; border-left: 2px solid #e2e8f0; }
        .ledger-item:last-child { border-left-color: transparent; padding-bottom: 0; }
        .ledger-item.completed { border-left-color: var(--primary); }
        .ledger-icon { 
            position: absolute; left: -11px; top: 0; width: 20px; height: 20px; 
            background: #fff; border: 2px solid #e2e8f0; border-radius: 50%; 
            display: flex; align-items: center; justify-content: center; font-size: 0.65rem; font-weight: 800;
        }
        .completed .ledger-icon { background: var(--primary); border-color: var(--primary); color: #fff; }
        .active .ledger-icon { border-color: var(--primary); color: var(--primary); animation: glow 1.5s infinite; }
        @keyframes glow { 0% { box-shadow: 0 0 0 0 rgba(16, 185, 129, 0.4); } 70% { box-shadow: 0 0 0 6px rgba(16, 185, 129, 0); } 100% { box-shadow: 0 0 0 0 rgba(16, 185, 129, 0); } }
        
        .ledger-info h4 { font-size: 0.9rem; font-weight: 700; margin-bottom: 2px; }
        .ledger-info p { font-size: 0.75rem; color: var(--text-muted); }
        .active .ledger-info h4 { color: var(--primary); }
    </style>
</head>
<body>

    <nav class="top-nav">
        <a href="${pageContext.request.contextPath}/" class="logo-area">
            <div class="logo-brand"><span class="logo-s">S</span><span class="logo-mall">Mall</span></div>
            <p class="logo-subtitle">Hộ chiếu đơn hàng số</p>
        </a>
        <div class="order-id-nav"><label>Mã vận đơn</label><span>${order.orderCode}</span></div>
    </nav>

    <main class="dashboard-container">
        <div class="side-col">
            <div class="card qr-card">
                <h3 class="card-title">Định danh vật lý</h3>
                <div class="qr-wrapper"><img src="data:image/png;base64,${qrCode}" alt="QR"></div>
                <div class="status-badge"><div class="status-dot"></div>${order.status.displayName}</div>
                <div class="action-buttons">
                    <form action="/api/orders/passport/update-status" method="POST">
                        <input type="hidden" name="orderCode" value="${order.orderCode}">
                        <c:choose>
                            <c:when test="${role == 'SELLER' && order.status == 'PENDING'}">
                                <button type="submit" name="action" value="CONFIRM" class="btn btn-confirm">Xác nhận đơn hàng</button>
                            </c:when>
                            <c:when test="${role == 'SELLER' && order.status == 'PREPARING'}">
                                <button type="submit" name="action" value="PREPARED" class="btn btn-confirm">Chuẩn bị xong hàng</button>
                            </c:when>
                            <c:when test="${role == 'SHIPPER' && order.status == 'READY_FOR_PICKUP'}">
                                <div style="margin-bottom: 12px; text-align: left;">
                                    <label style="font-size: 0.75rem; color: var(--text-muted); margin-bottom: 4px; display: block;">Vị trí lấy hàng</label>
                                    <input type="text" name="location" value="${order.orderDetails[0].product.shop.user.profile.address}" style="width: 100%; padding: 10px; border-radius: 8px; border: 1px solid var(--border);">
                                </div>
                                <button type="submit" name="action" value="PICKUP" class="btn btn-confirm">Xác nhận lấy hàng</button>
                            </c:when>
                            <c:when test="${role == 'SHIPPER' && order.status == 'SHIPPING'}">
                                <div style="margin-bottom: 12px; text-align: left;">
                                    <label style="font-size: 0.75rem; color: var(--text-muted); margin-bottom: 4px; display: block;">Cập nhật vị trí trạm dừng</label>
                                    <input type="text" name="location" placeholder="Nhập địa chỉ hiện tại..." style="width: 100%; padding: 10px; border-radius: 8px; border: 1px solid var(--border);">
                                </div>
                                <button type="submit" name="action" value="DELIVERED" class="btn btn-confirm">Xác nhận đã giao</button>
                            </c:when>
                            <c:when test="${role == 'BUYER' && order.status == 'DELIVERED'}">
                                <button type="submit" name="action" value="RECEIVED" class="btn btn-confirm">Đã nhận hàng</button>
                            </c:when>
                        </c:choose>
                    </form>
                    
                    <c:choose>
                        <c:when test="${role == 'SELLER'}">
                            <button class="btn btn-secondary">Liên hệ đơn vị vận chuyển</button>
                        </c:when>
                        <c:when test="${role == 'SHIPPER'}">
                            <button class="btn btn-secondary">Liên hệ tổng đài điều phối</button>
                        </c:when>
                        <c:otherwise>
                            <button class="btn btn-secondary">Liên hệ hỗ trợ</button>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <div class="card" style="margin-top: 24px;">
                <h3 class="card-title">Hành trình chi tiết</h3>
                <div class="summary-row">
                    <label>Trạng thái</label>
                    <span class="status-tag">${order.status.displayName}</span>
                </div>
                <div class="summary-row">
                    <label>Vị trí hiện tại</label>
                    <span id="current-loc-text" style="max-width: 160px;">
                        <c:choose>
                            <c:when test="${order.status == 'READY_FOR_PICKUP'}">Sẵn sàng tại kho</c:when>
                            <c:when test="${order.status == 'PREPARING'}">Đang đóng gói</c:when>
                            <c:otherwise>Đang cập nhật...</c:otherwise>
                        </c:choose>
                    </span>
                </div>
                <div class="summary-row">
                    <label>Cập nhật lần cuối</label>
                    <span>${formattedUpdatedAt}</span>
                </div>
            </div>
        </div>

        <div class="main-col">
            <c:set var="firstShop" value="${order.orderDetails[0].product.shop}" />
            <div class="manifest-header">
                <div class="actor-card">
                    <img class="avatar" src="${not empty order.account.profile.avatarUrl ? order.account.profile.avatarUrl : 'https://ui-avatars.com/api/?name=' + order.account.profile.fullName + '&background=10b981&color=fff'}" alt="Buyer">
                    <div class="actor-info">
                        <label>Người mua</label>
                        <h4>${order.account.profile.fullName}</h4>
                        <div style="font-size: 0.7rem; margin-top: 4px; padding: 2px 6px; background: #f1f5f9; border-radius: 4px; display: inline-block;">
                            PTTT: <span style="font-weight: 700; color: var(--accent);">${order.paymentMethod == 'QR' ? 'THANH TOÁN QR' : 'TIỀN MẶT (COD)'}</span>
                        </div>
                    </div>
                </div>
                <div class="actor-card" style="border-left: 4px solid var(--accent);">
                    <img class="avatar" src="${not empty firstShop.logoUrl ? firstShop.logoUrl : 'https://ui-avatars.com/api/?name=' + firstShop.name + '&background=10b981&color=fff'}" alt="Seller">
                    <div class="actor-info">
                        <label>Người bán</label>
                        <h4>${firstShop.name}</h4>
                        <p style="font-size: 0.8rem; color: #64748b;">${firstShop.user.email}</p>
                    </div>
                </div>
            </div>

            <div class="card">
                <h3 class="card-title">Danh mục sản phẩm</h3>
                <div class="product-list">
                    <c:forEach var="detail" items="${order.orderDetails}">
                        <div class="product-item">
                            <div class="p-icon">📦</div>
                            <div class="p-details">
                                <h4>${detail.product.name}</h4>
                                <p style="font-size: 0.75rem; color: var(--text-muted);">Mã SP: ${detail.product.id}-${detail.id}</p>
                            </div>
                            <div class="p-qty">x${detail.quantity}</div>
                            <div class="p-price"><fmt:formatNumber value="${detail.priceAtPurchase * detail.quantity}" type="currency" currencySymbol="₫" /></div>
                        </div>
                    </c:forEach>
                </div>
                <div class="total-card" style="border-top: 2px dashed var(--border); padding-top: 20px; margin-top: 20px;">
                    <div style="width: 100%;">
                        <div style="display: flex; justify-content: space-between; margin-bottom: 8px;">
                            <label style="color: var(--text-muted); font-size: 0.85rem;">Tổng giá trị hàng</label>
                            <span style="font-weight: 600;"><fmt:formatNumber value="${order.totalPrice}" type="currency" currencySymbol="₫" /></span>
                        </div>
                        <div style="display: flex; justify-content: space-between; align-items: center;">
                            <label style="color: var(--text-main); font-weight: 700;">SỐ TIỀN CẦN THU</label>
                            <c:choose>
                                <c:when test="${order.paymentMethod == 'QR'}">
                                    <div style="text-align: right;">
                                        <span style="font-size: 1.5rem; font-weight: 800; color: var(--accent);">0₫</span>
                                        <p style="font-size: 0.65rem; color: var(--accent); font-weight: 700;">ĐÃ THANH TOÁN QR</p>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <span style="font-size: 1.5rem; font-weight: 800; color: #ef4444;">
                                        <fmt:formatNumber value="${order.totalPrice}" type="currency" currencySymbol="₫" />
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>

            <div class="card" style="margin-top: 24px; padding: 0; overflow: hidden; position: relative;">
                <h3 class="card-title" style="padding: 24px;">Bản đồ hành trình</h3>
                <div id="map" style="height: 350px; width: 100%;"></div>
                <div id="distance-info" style="position: absolute; top: 70px; right: 20px; z-index: 1000; background: var(--accent); color: #fff; padding: 4px 12px; border-radius: 8px; font-weight: 700; display: none;">KM: <span id="dist-val">0</span></div>
                <div style="padding: 16px 24px; display: flex; justify-content: space-between; align-items: center; background: #fff;">
                    <p style="font-size: 0.85rem;">📍 Đích đến: ${order.shippingAddress}</p>
                    <div id="shipper-status" style="display: none; color: var(--primary); font-weight: 700; font-size: 0.75rem;">🚚 SHIPPER ĐANG DI CHUYỂN</div>
                </div>
            </div>
        </div>

        <div class="side-col">
            <div class="card" style="min-height: 100%;">
                <h3 class="card-title">Nhật ký Logistics</h3>
                <div class="ledger-list">
                    <div class="ledger-item completed">
                        <div class="ledger-icon">✓</div>
                        <div class="ledger-info"><h4>Đơn hàng đã xác nhận</h4><p>${formattedCreatedAt}</p></div>
                    </div>
                    <div class="ledger-item completed">
                        <div class="ledger-icon">💳</div>
                        <div class="ledger-info">
                            <c:choose>
                                <c:when test="${order.paymentMethod == 'QR'}">
                                    <h4>Đã thanh toán (S-Mall QR)</h4>
                                    <p>${formattedCreatedAt}</p>
                                </c:when>
                                <c:otherwise>
                                    <h4>Thanh toán khi nhận hàng (COD)</h4>
                                    <p>Số tiền: <fmt:formatNumber value="${order.totalPrice}" type="currency" currencySymbol="₫" /></p>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <div class="ledger-item ${order.status != 'PENDING' && order.status != 'CONFIRMED' && order.status != 'PREPARING' ? 'completed' : (order.status == 'PREPARING' ? 'active' : '')}">
                        <div class="ledger-icon">🤝</div>
                        <div class="ledger-info"><h4>Đã chuẩn bị xong hàng</h4><p>${(order.status == 'PENDING' || order.status == 'CONFIRMED' || order.status == 'PREPARING') ? 'Đang chuẩn bị...' : formattedUpdatedAt}</p></div>
                    </div>
                    <div class="ledger-item ${order.status == 'SHIPPING' || order.status == 'DELIVERED' || order.status == 'REVIEWED' ? 'completed' : (order.status == 'READY_FOR_PICKUP' ? 'active' : '')}">
                        <div class="ledger-icon">📦</div>
                        <div class="ledger-info"><h4>Shipper đã nhận hàng</h4><p>${(order.status == 'READY_FOR_PICKUP') ? 'Đang chờ Shipper...' : (order.status == 'PREPARING' ? 'Chờ chuẩn bị xong...' : formattedUpdatedAt)}</p></div>
                    </div>
                    <div class="ledger-item ${order.status == 'DELIVERED' || order.status == 'REVIEWED' ? 'completed' : (order.status == 'SHIPPING' ? 'active' : '')}">
                        <div class="ledger-icon">🚚</div>
                        <div class="ledger-info"><h4>Đang trên đường giao</h4><p>${order.status == 'SHIPPING' ? 'Hàng đang trên đường tới bạn' : ''}</p></div>
                    </div>
                    <div class="ledger-item ${order.status == 'REVIEWED' ? 'completed' : (order.status == 'DELIVERED' ? 'active' : '')}">
                        <div class="ledger-icon">🏁</div>
                        <div class="ledger-info"><h4>Giao hàng thành công</h4><p>${order.status == 'DELIVERED' ? 'Đã giao tới tay khách hàng' : 'Đang chờ...'}</p></div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const map = L.map('map').setView([10.762622, 106.660172], 13);
            L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', { attribution: '© OSM' }).addTo(map);

            const shopAddr = "${order.orderDetails[0].product.shop.user.profile.address}";
            const buyerAddr = "${order.shippingAddress}";
            const status = "${order.status}";

            async function getCoords(addr) {
                if (!addr || addr.trim() === "") return null;
                const search = async (q) => {
                    try {
                        const res = await fetch('https://nominatim.openstreetmap.org/search?format=json&q=' + encodeURIComponent(q) + '&limit=1&polygon_geojson=1');
                        const data = await res.json();
                        return data && data.length > 0 ? data[0] : null;
                    } catch (e) { return null; }
                };
                const parts = addr.split(',').map(p => p.trim());
                for (let i = 0; i < parts.length; i++) {
                    const query = parts.slice(i).join(', ');
                    if (query.length < 3) continue;
                    let data = await search(query);
                    if (data) return data;
                }
                return null;
            }

            Promise.all([getCoords(shopAddr), getCoords(buyerAddr)]).then(results => {
                const shopData = results[0];
                const buyerData = results[1];

                if (buyerData) {
                    const buyerC = [parseFloat(buyerData.lat), parseFloat(buyerData.lon)];
                    document.getElementById('current-loc-text').innerText = (status === 'PENDING' || status === 'PREPARING') ? shopAddr : "Đang vận chuyển...";

                    if (shopData) {
                        const shopC = [parseFloat(shopData.lat), parseFloat(shopData.lon)];
                        if (status === 'SHIPPING') {
                            // Mock Shipper position halfway
                            const shipperC = [(shopC[0] + buyerC[0])/2, (shopC[1] + buyerC[1])/2];
                            L.marker(shipperC, { icon: L.divIcon({ html: '🚚', className: 'truck-icon', iconSize: [30, 30] }) }).addTo(map).bindPopup("Shipper đang ở đây");
                            document.getElementById('shipper-status').style.display = 'block';
                            document.getElementById('current-loc-text').innerText = "Đang trên đường tới điểm giao";
                        }
                        L.marker(shopC).addTo(map).bindPopup("Shop");
                        L.marker(buyerC).addTo(map).bindPopup("Khách");
                        L.polyline([shopC, buyerC], {color: '#10b981', dashArray: '10, 10'}).addTo(map);
                        map.fitBounds(new L.featureGroup([L.marker(shopC), L.marker(buyerC)]).getBounds().pad(0.3));
                    } else {
                        drawZone(buyerData);
                    }
                }

                function drawZone(data) {
                    const coords = [parseFloat(data.lat), parseFloat(data.lon)];
                    if (data.geojson && (data.geojson.type === 'Polygon' || data.geojson.type === 'MultiPolygon')) {
                        L.geoJSON(data.geojson, { style: { color: '#064e3b', fillColor: '#064e3b', fillOpacity: 0.25 } }).addTo(map);
                        map.fitBounds(L.geoJSON(data.geojson).getBounds());
                    } else {
                        L.circle(coords, { radius: 1000, color: '#064e3b' }).addTo(map);
                        map.setView(coords, 14);
                    }
                }
            });
        });
    </script>
</body>
</html>
