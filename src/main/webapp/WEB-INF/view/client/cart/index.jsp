<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="url" value="${pageContext.request.contextPath}" />

<jsp:include page="../layout/header.jsp" />

<!-- Premium Inter Font -->
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${url}/resources/css/client/cart.css?v=3.0">
<link rel="stylesheet" href="${url}/resources/css/client/footer.css">

<div class="cart-container">
    <!-- Main Cart Header -->
    <div class="cart-header-section">
        <div>
            <h1 class="cart-title">Giỏ hàng của bạn</h1>
            <p class="cart-subtitle">Bạn có <span class="fw-bold text-success">${cart.items.size()}</span> loại hàng trong giỏ</p>
        </div>
        
        <c:if test="${not empty cart.items}">
            <div class="select-all-box" onclick="toggleSelectAll()">
                <div class="custom-checkbox select-all-trigger" id="selectAllHeader">
                    <i class="fas fa-check"></i>
                </div>
                <span>Chọn tất cả</span>
            </div>
        </c:if>
    </div>

    <c:choose>
        <c:when test="${not empty cart.items}">
            <div class="cart-grid">
                <div class="cart-rows">
                    <c:forEach var="item" items="${cart.items}">
                        <div class="cart-item-card" id="cart-item-${item.variantId}">
                            <div class="d-flex align-items-center me-3">
                                <div class="custom-checkbox item-selector" 
                                     data-id="${item.variantId}" 
                                     data-price="${item.price}" 
                                     onclick="toggleItemSelection(this)">
                                    <i class="fas fa-check"></i>
                                </div>
                            </div>

                            <div class="cart-item-image-box">
                                <c:set var="rawImg" value="${fn:trim(item.imageUrl)}" />
                                <c:choose>
                                    <c:when test="${empty rawImg}">
                                        <img src="https://placehold.co/400x400/f1f5f9/1a7a42?text=S-Mall" alt="${item.productName}">
                                    </c:when>
                                    <c:when test="${fn:startsWith(rawImg, 'http')}">
                                        <img src="${rawImg}" alt="${item.productName}">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="${url}${rawImg}" alt="${item.productName}">
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="cart-item-details">
                                <div>
                                    <h3 class="cart-item-name">${item.productName}</h3>
                                    <div class="cart-item-meta">
                                        <span class="meta-label">Phân loại:</span>
                                        <span class="meta-value">${not empty item.attributesJson ? item.attributesJson : item.sku}</span>
                                    </div>
                                </div>
                                
                                <div class="cart-item-bottom">
                                    <div class="price-group">
                                        <span class="current-price">
                                            <fmt:formatNumber value="${item.price}" type="currency" currencySymbol="₫" maxFractionDigits="0" />
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
            </div>
        </c:when>
        <c:otherwise>
            <div class="empty-state">
                <i class="fas fa-shopping-bag fa-5x text-muted opacity-25 mb-4 d-block"></i>
                <h2 class="text-dark font-weight-bold mb-3">Giỏ hàng đang trống</h2>
                <a href="${url}/" class="btn btn-success px-5 py-3 rounded-pill fw-bold">Tiếp tục mua sắm</a>
            </div>
        </c:otherwise>
    </c:choose>

    <!-- Recommendation Header (Now OUTSIDE the white box) -->
    <div class="cart-header-section" style="margin-top: 80px; margin-bottom: 32px; max-width: 1200px; margin-left: auto; margin-right: auto;">
        <div>
            <h2 class="cart-title">Gợi ý cho bạn</h2>
            <p class="cart-subtitle">Dựa trên hành vi mua sắm của bạn</p>
        </div>
        <i class="fas fa-sparkles text-success fa-2x opacity-25"></i>
    </div>

    <!-- Recommendation Content Box -->
    <div class="reco-section" style="margin-top: 0;">
        <div class="reco-grid" id="recommendations-container"></div>
    </div>
</div>

<div class="footer-spacer" style="height: 120px;"></div>

<jsp:include page="../layout/_update_profile_modal.jsp" />

<jsp:include page="../layout/footer.jsp" />

<!-- STICKY BOTTOM CHECKOUT BAR -->
<c:if test="${not empty cart.items}">
    <div class="sticky-checkout-bar show-sticky-bar">
        <div class="sticky-bar-content">
            <div class="sticky-bar-left">
                <div class="select-all-box" onclick="toggleSelectAll()">
                    <div class="custom-checkbox select-all-trigger" id="selectAllBottom">
                        <i class="fas fa-check"></i>
                    </div>
                    <span>Chọn tất cả</span>
                </div>
            </div>
            <div class="sticky-bar-right">
                <div class="text-end">
                    <div class="sticky-total-label" id="sticky-qty-label">Tạm tính (0 sản phẩm):</div>
                    <div class="sticky-total-price" id="sticky-total">0 ₫</div>
                </div>
                <button class="btn-checkout-sticky" id="checkoutBtnSticky" disabled onclick="proceedToCheckout()">
                    Thanh toán
                </button>
            </div>
        </div>
    </div>
</c:if>

<script>
    const baseUrl = '${url}';

    document.addEventListener('DOMContentLoaded', function() {
        loadRecommendations();
        updateSummary();
    });

    function fixImagePath(path) {
        if (!path || path.trim() === '') return 'https://placehold.co/400x400/f1f5f9/1a7a42?text=S-Mall';
        path = path.trim();
        if (path.startsWith('http')) return path;
        if (path.startsWith('/')) return baseUrl + path;
        return baseUrl + '/' + path;
    }

    function toggleSelectAll() {
        const headerCheckbox = document.getElementById('selectAllHeader');
        const bottomCheckbox = document.getElementById('selectAllBottom');
        const isChecking = !headerCheckbox.classList.contains('checked');
        headerCheckbox.classList.toggle('checked', isChecking);
        if (bottomCheckbox) bottomCheckbox.classList.toggle('checked', isChecking);
        document.querySelectorAll('.item-selector').forEach(cb => cb.classList.toggle('checked', isChecking));
        updateSummary();
    }

    function toggleItemSelection(el) {
        el.classList.toggle('checked');
        const allItems = document.querySelectorAll('.item-selector');
        const checkedItems = document.querySelectorAll('.item-selector.checked');
        const isAllSelected = allItems.length === checkedItems.length;
        document.getElementById('selectAllHeader').classList.toggle('checked', isAllSelected);
        const bottomBox = document.getElementById('selectAllBottom');
        if (bottomBox) bottomBox.classList.toggle('checked', isAllSelected);
        updateSummary();
    }

    function updateSummary() {
        let total = 0, count = 0, selectedUnique = 0;
        const checkedItems = document.querySelectorAll('.item-selector.checked');
        checkedItems.forEach(cb => {
            selectedUnique++;
            const variantId = cb.getAttribute('data-id');
            const price = parseFloat(cb.getAttribute('data-price'));
            const qty = parseInt(document.getElementById(`qty-` + variantId).textContent);
            total += price * qty;
            count += qty;
        });
        const formatter = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(total).replace('₫', 'đ');
        document.getElementById('sticky-total').textContent = formatter;
        document.getElementById('sticky-qty-label').textContent = `Tạm tính (` + count + ` sản phẩm):`;
        if (document.getElementById('checkoutBtnSticky')) 
            document.getElementById('checkoutBtnSticky').disabled = selectedUnique === 0;
    }

    function updateCartQty(variantId, delta) {
        const valSpan = document.getElementById(`qty-` + variantId);
        let newQty = parseInt(valSpan.textContent) + delta;
        if (newQty < 1) return;
        fetch(`\${baseUrl}/api/cart/update?variantId=` + variantId + `&quantity=` + newQty, { method: 'POST' })
        .then(res => res.json()).then(data => {
            if (data.status === 'success') {
                valSpan.textContent = newQty;
                updateSummary();
                if (typeof updateCartCount === 'function') updateCartCount();
            }
        });
    }

    function removeItem(variantId) {
        if (!confirm('Xóa sản phẩm này khỏi giỏ hàng?')) return;
        fetch(`\${baseUrl}/api/cart/remove?variantId=` + variantId, { method: 'POST' })
        .then(res => res.json()).then(data => {
            if (data.status === 'success') {
                document.getElementById(`cart-item-` + variantId).remove();
                if (document.querySelectorAll('.cart-item-card').length === 0) location.reload();
                updateSummary();
                if (typeof updateCartCount === 'function') updateCartCount();
            }
        });
    }

    const isProfileIncomplete = ${isProfileIncomplete != null ? isProfileIncomplete : true};

    function proceedToCheckout() {
        if (isProfileIncomplete) {
            const modalEl = document.getElementById('updateProfileModal');
            if (modalEl) {
                const modal = new bootstrap.Modal(modalEl);
                modal.show();
            }
            return;
        }
        
        const selectedIds = Array.from(document.querySelectorAll('.item-selector.checked')).map(cb => cb.getAttribute('data-id'));
        window.location.href = `\${baseUrl}/payment?ids=` + selectedIds.join(',');
    }

    function loadRecommendations() {
        fetch(baseUrl + '/api/recommendations/more?size=6')
            .then(res => res.json()).then(data => {
                const container = document.getElementById('recommendations-container');
                if (data && data.products) {
                    container.innerHTML = data.products.map(p => {
                        const discountBadge = (p.discountPercentage && p.discountPercentage > 0) 
                            ? '<div class="reco-badge">-' + p.discountPercentage + '% GIẢM</div>' 
                            : '';
                        
                        return '<div class="product-card-mini" onclick="window.location.href=\'' + baseUrl + '/product/' + p.slug + '\'">' +
                                    '<div class="reco-img-box">' +
                                        '<img src="' + fixImagePath(p.mainImageUrl) + '" alt="' + p.name + '">' +
                                        discountBadge +
                                    '</div>' +
                                    '<h4 class="reco-name text-truncate">' + p.name + '</h4>' +
                                    '<div class="reco-price">' + new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(p.price).replace('₫', 'đ') + '</div>' +
                                '</div>';
                    }).join('');
                }
            });
    }
</script>

<style>
.product-card-mini { background: #F8FAFC; border-radius: 20px; padding: 12px; cursor: pointer; transition: all 0.3s ease; }
.product-card-mini:hover { background: white; box-shadow: 0 10px 20px rgba(0,0,0,0.05); transform: translateY(-5px); border: 1px solid #1A7A42; }
.reco-img-box { width: 100%; aspect-ratio: 1; border-radius: 12px; overflow: hidden; margin-bottom: 12px; position: relative; }
.reco-img-box img { width: 100%; height: 100%; object-fit: cover; }
.reco-badge { position: absolute; top: 8px; right: 8px; background: #EF4444; color: white; padding: 4px 10px; border-radius: 10px; font-size: 11px; font-weight: 800; box-shadow: 0 4px 10px rgba(0,0,0,0.1); }
.reco-name { font-size: 14px; font-weight: 600; color: #1E293B; margin-bottom: 4px; }
.reco-price { font-size: 15px; font-weight: 800; color: #EF4444; }
</style>
