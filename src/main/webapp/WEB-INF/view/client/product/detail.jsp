<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="url" value="${pageContext.request.contextPath}" />

<jsp:include page="../layout/header.jsp" />

<link rel="stylesheet" href="${url}/resources/css/client/product_detail.css">
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
                    <span class="text-dark fw-medium">2.5k</span> Đánh giá
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

            <div class="action-buttons">
                <button class="btn-cart">
                    <i class="fas fa-cart-plus me-2"></i>
                    Thêm Vào Giỏ Hàng
                </button>
                <button class="btn-buy">Mua Ngay</button>
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
function changeImage(url, el) {
    document.getElementById('mainImage').src = url;
    document.querySelectorAll('.thumb-item').forEach(item => item.classList.remove('active'));
    el.classList.add('active');
}
</script>

<jsp:include page="../layout/footer.jsp" />
