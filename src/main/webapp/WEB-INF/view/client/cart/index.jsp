<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="url" value="${pageContext.request.contextPath}" />

<jsp:include page="../layout/header.jsp" />

<!-- Premium Inter Font -->
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${url}/resources/css/client/cart.css?v=2.1">

<div class="cart-container">
    <div class="cart-header-section">
        <h1 class="cart-title">Giỏ hàng của bạn</h1>
        <p class="cart-subtitle">Bạn có <span class="fw-bold text-success">${cart.items.size()}</span> sản phẩm trong giỏ hàng</p>
    </div>

    <c:choose>
        <c:when test="${not empty cart.items}">
            <div class="cart-grid">
                <!-- Left: Products List -->
                <div class="cart-rows">
                    <c:forEach var="item" items="${cart.items}">
                        <div class="cart-item-card" id="cart-item-${item.variantId}">
                            <div class="cart-item-image-box">
                                <img src="${item.imageUrl}" alt="${item.productName}">
                            </div>
                            <div class="cart-item-details">
                                <div>
                                    <h3 class="cart-item-name">${item.productName}</h3>
                                    <div class="cart-item-meta">
                                        <span class="meta-label">Màu sắc:</span>
                                        <span class="meta-value">Mặc định</span>
                                    </div>
                                </div>
                                
                                <div class="cart-item-bottom">
                                    <div class="price-group">
                                        <span class="current-price">
                                            <fmt:formatNumber value="${item.price}" type="currency" currencySymbol="₫" maxFractionDigits="0" />
                                        </span>
                                        <span class="original-price">
                                            <fmt:formatNumber value="${item.price * 1.25}" type="currency" currencySymbol="₫" maxFractionDigits="0" />
                                        </span>
                                    </div>
                                    
                                    <div class="controls-group">
                                        <div class="qty-stepper">
                                            <button class="qty-btn" onclick="updateCartQty(${item.variantId}, -1)">
                                                <i class="fas fa-minus"></i>
                                            </button>
                                            <span class="qty-val" id="qty-${item.variantId}">${item.quantity}</span>
                                            <button class="qty-btn" onclick="updateCartQty(${item.variantId}, 1)">
                                                <i class="fas fa-plus"></i>
                                            </button>
                                        </div>
                                        <button class="delete-btn" onclick="removeItem(${item.variantId})">
                                            <i class="fas fa-trash-alt"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <!-- Right: Payment Summary -->
                <div class="cart-sidebar">
                    <div class="summary-panel">
                        <h2 class="summary-title">Tóm tắt đơn hàng</h2>
                        
                        <div class="summary-rows">
                            <div class="row-item">
                                <span>Tạm tính (${cart.items.size()} sản phẩm)</span>
                                <span class="row-val" id="subtotal">
                                    <fmt:formatNumber value="${cart.totalPrice}" type="currency" currencySymbol="₫" maxFractionDigits="0" />
                                </span>
                            </div>
                            <div class="row-item highlight">
                                <span>Tiết kiệm</span>
                                <span class="row-val d-flex align-items-center">
                                    -<fmt:formatNumber value="${cart.totalPrice * 0.2}" type="currency" currencySymbol="₫" maxFractionDigits="0" />
                                </span>
                            </div>
                            <div class="row-item">
                                <span>Phí vận chuyển</span>
                                <span class="row-val text-success">Miễn phí</span>
                            </div>
                        </div>

                        <div class="total-divider"></div>

                        <div class="total-row">
                            <span class="total-label">Tổng cộng</span>
                            <span class="total-price" id="grandtotal">
                                <fmt:formatNumber value="${cart.totalPrice}" type="currency" currencySymbol="₫" maxFractionDigits="0" />
                            </span>
                        </div>

                        <button class="btn-checkout" onclick="window.location.href='${url}/checkout'">
                            Thanh toán ngay
                            <i class="fas fa-arrow-right"></i>
                        </button>

                        <div class="delivery-info">
                            <div class="info-tag">
                                <div class="info-icon"><i class="fas fa-truck"></i></div>
                                <span class="fw-medium">Miễn phí vận chuyển cho đơn từ 500k</span>
                            </div>
                            <div class="info-tag">
                                <div class="info-icon"><i class="fas fa-shield-alt"></i></div>
                                <span class="fw-medium">Thanh toán an toàn & bảo mật</span>
                            </div>
                            <div class="info-tag">
                                <div class="info-icon"><i class="fas fa-box"></i></div>
                                <span class="fw-medium">Giao hàng nhanh 2-3 ngày</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <div class="empty-state">
                <div class="mb-4">
                    <i class="fas fa-shopping-bag fa-5x text-muted opacity-25"></i>
                </div>
                <h2 class="text-dark font-weight-bold mb-3">Giỏ hàng đang trống</h2>
                <p class="text-muted mb-5">Hãy thêm sản phẩm vào giỏ hàng để tiếp tục mua sắm!</p>
                <a href="${url}/" class="btn btn-success px-5 py-3 rounded-pill fw-bold">Tiếp tục mua sắm</a>
            </div>
        </c:otherwise>
    </c:choose>

    <!-- Recommendations Section -->
    <div class="reco-section">
        <div class="reco-title-box">
            <i class="fas fa-sparkles text-success fa-lg"></i>
            <h2 class="m-0 fs-3 fw-bold text-dark">Có thể bạn cũng thích</h2>
        </div>
        <div class="reco-grid" id="recommendations-container">
            <!-- Loaded via AJAX -->
        </div>
    </div>
</div>

<jsp:include page="../layout/footer.jsp" />

<script>
    document.addEventListener('DOMContentLoaded', function() {
        loadRecommendations();
    });

    function loadRecommendations() {
        fetch(`${url}/api/recommendations/more?size=6`)
            .then(res => res.json())
            .then(data => {
                const container = document.getElementById('recommendations-container');
                if (data && data.products) {
                    container.innerHTML = data.products.map(p => `
                        <div class="product-card-mini" onclick="window.location.href='${url}/product/` + p.slug + `'">
                            <div class="reco-img-box">
                                <img src="` + p.mainImage + `" alt="` + p.name + `">
                            </div>
                            <h4 class="reco-name text-truncate">` + p.name + `</h4>
                            <div class="reco-price">` + new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(p.price).replace('₫', 'đ') + `</div>
                        </div>
                    `).join('');
                }
            });
    }

    function updateCartQty(variantId, delta) {
        const valSpan = document.getElementById(`qty-` + variantId);
        let newQty = parseInt(valSpan.textContent) + delta;
        if (newQty < 1) return;

        fetch(`${url}/api/cart/update?variantId=` + variantId + `&quantity=` + newQty, {
            method: 'POST'
        })
        .then(res => res.json())
        .then(data => {
            if (data.status === 'success') {
                valSpan.textContent = newQty;
                refreshCartUI();
            }
        });
    }

    function removeItem(variantId) {
        if (!confirm('Xóa sản phẩm này khỏi giỏ hàng?')) return;

        fetch(`${url}/api/cart/remove?variantId=` + variantId, {
            method: 'POST'
        })
        .then(res => res.json())
        .then(data => {
            if (data.status === 'success') {
                const card = document.getElementById(`cart-item-` + variantId);
                card.style.opacity = '0';
                card.style.transform = 'scale(0.9)';
                setTimeout(() => {
                    card.remove();
                    if (document.querySelectorAll('.cart-item-card').length === 0) location.reload();
                    refreshCartUI();
                }, 300);
            }
        });
    }

    function refreshCartUI() {
        fetch(`${url}/api/cart`)
            .then(res => res.json())
            .then(cart => {
                const formatter = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(cart.totalPrice).replace('₫', 'đ');
                document.getElementById('subtotal').textContent = formatter;
                document.getElementById('grandtotal').textContent = formatter;
                
                // Sync badges
                const badges = document.querySelectorAll('.cart-badge');
                const count = cart.totalItems || 0;
                badges.forEach(b => {
                    b.textContent = count;
                    b.style.display = count > 0 ? 'flex' : 'none';
                });
            });
    }
</script>

<style>
/* Addition for Recommendations Mini Cards */
.product-card-mini {
    background: #F8FAFC;
    border-radius: 20px;
    padding: 12px;
    cursor: pointer;
    transition: all 0.3s ease;
    border: 1px solid transparent;
}
.product-card-mini:hover {
    background: white;
    box-shadow: 0 10px 20px rgba(0,0,0,0.05);
    border-color: #1A7A42;
    transform: translateY(-5px);
}
.reco-img-box {
    width: 100%;
    aspect-ratio: 1;
    border-radius: 12px;
    overflow: hidden;
    margin-bottom: 12px;
}
.reco-img-box img {
    width: 100%; height: 100%; object-fit: cover;
}
.reco-name {
    font-size: 14px; font-weight: 600; color: #1E293B; margin-bottom: 4px;
}
.reco-price {
    font-size: 15px; font-weight: 800; color: #EF4444;
}
</style>
