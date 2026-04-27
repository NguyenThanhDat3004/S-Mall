<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="url" value="${pageContext.request.contextPath}" />

<jsp:include page="../layout/header.jsp" />

<link rel="stylesheet" href="${url}/resources/css/client/product_detail.css?v=2.0">
<link rel="stylesheet" href="${url}/resources/css/client/footer.css">


<main class="container py-5">
    <div class="product-main">
        <div class="product-images">
            <div class="main-image-wrapper">
                <c:forEach var="img" items="${product.images}">
                    <c:if test="${img.main}">
                        <img src="${img.url}" alt="${product.name}" id="mainImage">
                    </c:if>
                </c:forEach>
            </div>
            <div class="thumbnail-list">
                <c:forEach var="img" items="${product.images}">
                    <div class="thumb-item ${img.main ? 'active' : ''}" onclick="changeImage('${img.url}', this)">
                        <img src="${img.url}" alt="${product.name}" style="width: 100%; height: 100%; object-fit: cover;">
                    </div>
                </c:forEach>
            </div>
        </div>

        <div class="product-info">
            <h1 class="product-title">${product.name}</h1>
            
            <div class="product-stats">
                <div class="rating-badge">
                    <span class="fw-bold text-dark me-1">${product.averageRating}</span>
                    <c:forEach begin="1" end="5" var="i">
                        <i class="fas fa-star ${i <= product.averageRating ? 'text-warning' : 'text-muted'}"></i>
                    </c:forEach>
                </div>
                <div class="stat-item">
                    <span class="text-dark fw-medium">${product.reviewCount}</span> Đánh giá
                </div>
                <div class="stat-item border-0">
                    <span class="text-dark fw-medium">${product.soldCount}</span> Đã bán
                </div>
            </div>

            <div class="price-section">
                <c:set var="variant" value="${product.variants[0]}" />
                <c:choose>
                    <c:when test="${variant.discountPrice < variant.price}">
                        <span class="current-price">
                            <fmt:formatNumber value="${variant.discountPrice}" type="currency" currencySymbol="₫" />
                        </span>
                        <span class="old-price" style="text-decoration: line-through; color: #94a3b8; font-size: 1.2rem; margin-left: 10px;">
                            <fmt:formatNumber value="${variant.price}" type="currency" currencySymbol="₫" />
                        </span>
                        <span class="discount-tag ms-2">
                            -<fmt:formatNumber value="${(variant.price - variant.discountPrice)/variant.price}" type="percent" />
                        </span>
                    </c:when>
                    <c:otherwise>
                        <span class="current-price">
                            <fmt:formatNumber value="${variant.price}" type="currency" currencySymbol="₫" />
                        </span>
                    </c:otherwise>
                </c:choose>
            </div>

            <c:set var="currentUserEmail" value="${pageContext.request.userPrincipal.name}" />
            <c:set var="isOwner" value="${currentUserEmail != null && currentUserEmail == product.shop.user.email}" />

            <c:if test="${!isOwner}">
                <div class="quantity-section mb-4">
                    <div class="fw-bold text-dark mb-2">Số Lượng</div>
                    <div class="quantity-selector">
                        <button class="qty-btn" onclick="updateQty(-1)">-</button>
                        <input type="number" id="quantityInput" value="1" min="1" readonly>
                        <button class="qty-btn" onclick="updateQty(1)">+</button>
                        <span class="ms-3 text-muted" style="font-size: 0.9rem;">${product.variants[0].stock} sản phẩm có sẵn</span>
                    </div>
                </div>
            </c:if>

            <div class="action-buttons">
                <c:choose>
                    <c:when test="${isOwner}">
                        <div class="seller-tools-box shadow-sm mb-4">
                            <div class="seller-tools-title mb-3">
                                <i class="fas fa-tools me-2"></i> QUẢN LÝ SẢN PHẨM CỦA BẠN
                            </div>
                            <div class="seller-actions-grid">
                                <a href="${url}/seller/product/edit/${product.id}" class="btn-seller-action btn-seller-edit">
                                    <i class="fas fa-edit"></i> Chỉnh sửa
                                </a>
                                <a href="${url}/seller/inventory/${product.id}" class="btn-seller-action btn-seller-inventory">
                                    <i class="fas fa-boxes"></i> Quản lý kho
                                </a>
                                <a href="${url}/seller/stats/product/${product.id}" class="btn-seller-action btn-seller-stats">
                                    <i class="fas fa-chart-line"></i> Thống kê
                                </a>
                                <button class="btn-seller-action btn-seller-delete" onclick="confirmDeleteProduct('${product.id}')">
                                    <i class="fas fa-trash-alt"></i> Xóa sản phẩm
                                </button>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <button class="btn-cart" id="addToCartBtn">
                            <i class="fas fa-cart-plus me-2"></i> Thêm Vào Giỏ Hàng
                        </button>
                        <button class="btn-buy">Mua Ngay</button>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="trust-badges">
                <div class="badge-item">
                    <div class="badge-icon"><i class="fas fa-truck"></i></div>
                    <div class="badge-text">
                        <div class="badge-title">Miễn phí vận chuyển</div>
                        <div class="badge-desc">Toàn quốc</div>
                    </div>
                </div>
                <div class="badge-item">
                    <div class="badge-icon"><i class="fas fa-shield-alt"></i></div>
                    <div class="badge-text">
                        <div class="badge-title">Chính hãng 100%</div>
                        <div class="badge-desc">Bảo hành 12 tháng</div>
                    </div>
                </div>
                <div class="badge-item">
                    <div class="badge-icon"><i class="fas fa-undo"></i></div>
                    <div class="badge-text">
                        <div class="badge-title">Đổi trả dễ dàng</div>
                        <div class="badge-desc">Trong 7 ngày</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const contextPath = '${url}';
    const variantId = ${product.variants[0].id};
    const maxStock = parseInt('${product.variants[0].stock}');

    function showToast(message, type = 'success') {
        const toast = document.createElement('div');
        toast.className = `custom-toast \${type}`;
        toast.innerHTML = `
            <i class="fas \${type === 'success' ? 'fa-check-circle' : 'fa-exclamation-circle'} me-2"></i>
            \${message}
        `;
        document.body.appendChild(toast);
        
        setTimeout(() => toast.classList.add('show'), 100);
        setTimeout(() => {
            toast.classList.remove('show');
            setTimeout(() => toast.remove(), 500);
        }, 3000);
    }

    window.updateQty = function(delta) {
        const input = document.getElementById('quantityInput');
        let val = parseInt(input.value) + delta;
        if (val < 1) val = 1;
        if (val > maxStock) val = maxStock;
        input.value = val;
    }

    const addBtn = document.getElementById('addToCartBtn');
    if (addBtn) {
        addBtn.addEventListener('click', function() {
            const quantity = document.getElementById('quantityInput').value;
            const btn = this;
            
            btn.disabled = true;
            btn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i> ...';

            const params = new URLSearchParams();
            params.append('variantId', variantId);
            params.append('quantity', quantity);

            fetch(`\${contextPath}/api/cart/add`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: params
            })
            .then(res => {
                if (!res.ok) {
                    return res.json().then(json => { throw new Error(json.message || 'Lỗi server'); });
                }
                return res.json();
            })
            .then(data => {
                console.log('Success:', data);
                showToast(data.message);
                const badge = document.getElementById('cartBadge');
                if (badge && data.cartCount !== undefined) {
                    badge.innerText = data.cartCount;
                    badge.style.display = 'flex';
                }
            })
            .catch(err => {
                console.error('Error:', err);
                alert('Lỗi thêm giỏ hàng: ' + err.message);
            })
            .finally(() => {
                btn.disabled = false;
                btn.innerHTML = '<i class="fas fa-cart-plus me-2"></i>Thêm Vào Giỏ Hàng';
            });
        });
    }

    window.changeImage = function(url, el) {
        document.getElementById('mainImage').src = url;
        document.querySelectorAll('.thumb-item').forEach(item => item.classList.remove('active'));
        el.classList.add('active');
    }

    window.confirmDeleteProduct = function(id) {
        if (confirm('Bạn có chắc chắn muốn xóa sản phẩm này? Hành động này không thể hoàn tác.')) {
            window.location.href = `${url}/seller/product/delete/` + id;
        }
    }
});
</script>

<jsp:include page="../layout/footer.jsp" />
