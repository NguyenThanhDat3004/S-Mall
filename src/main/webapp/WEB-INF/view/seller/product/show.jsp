<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="url" value="${pageContext.request.contextPath}" />

<jsp:include page="../../client/layout/header.jsp" />

        <link rel="stylesheet" href="${url}/resources/css/client/footer.css">
<style>
    .seller-show-container {
        max-width: 1200px;
        margin: 40px auto;
        padding: 0 15px;
    }
    .product-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
        gap: 20px;
    }
    .product-card {
        background: white;
        border-radius: 12px;
        overflow: hidden;
        transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        border: 1px solid #f1f5f9;
        position: relative;
        text-decoration: none;
        color: inherit;
        display: flex;
        flex-direction: column;
    }
    .product-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 15px 30px rgba(0,0,0,0.08);
        border-color: #ee4d2d;
    }
    .product-img-wrapper {
        position: relative;
        padding-top: 100%; /* 1:1 Aspect Ratio */
        overflow: hidden;
        background: #f8fafc;
    }
    .product-img {
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        object-fit: cover;
        transition: transform 0.5s ease;
    }
    .product-card:hover .product-img {
        transform: scale(1.1);
    }
    .product-info {
        padding: 15px;
        flex-grow: 1;
        display: flex;
        flex-direction: column;
    }
    .product-name {
        font-size: 0.9rem;
        font-weight: 500;
        margin-bottom: 10px;
        color: #1e293b;
        display: -webkit-box;
        -webkit-line-clamp: 2;
        -webkit-box-orient: vertical;
        overflow: hidden;
        height: 2.5rem;
        line-height: 1.25rem;
    }
    .product-price {
        color: #ee4d2d;
        font-size: 1.1rem;
        font-weight: 700;
        margin-top: auto;
    }
    .product-meta {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-top: 10px;
        font-size: 0.75rem;
        color: #64748b;
    }
    .badge-status {
        position: absolute;
        top: 10px;
        right: 10px;
        color: white;
        padding: 4px 10px;
        border-radius: 20px;
        font-size: 0.7rem;
        backdrop-filter: blur(4px);
        z-index: 2;
        font-weight: 700;
    }
    .badge-published { background: rgba(40, 167, 69, 0.9); }
    .badge-other { background: rgba(220, 53, 69, 0.9); }
    
    .pagination-wrapper {
        margin-top: 40px;
        display: flex;
        justify-content: center;
    }
</style>

<div class="seller-show-container">
    <div class="d-flex justify-content-between align-items-center mb-5">
        <div>
            <h2 class="fw-bold mb-1">Sản phẩm của tôi</h2>
            <p class="text-muted small">Quản lý và xem tất cả sản phẩm đang kinh doanh</p>
        </div>
        <a href="${url}/seller/product/create" class="btn btn-primary px-4 py-2" style="background: #ee4d2d; border: none; border-radius: 10px; font-weight: 600;">
            <i class="fas fa-plus me-2"></i>Thêm sản phẩm mới
        </a>
    </div>

    <div class="product-grid">
        <c:forEach var="product" items="${products}">
            <a href="${url}/product/${product.slug}" class="product-card">
                <span class="badge-status ${product.status == 'PUBLISHED' ? 'badge-published' : 'badge-other'}">
                    ${product.status}
                </span>
                <div class="product-img-wrapper">
                    <c:choose>
                        <c:when test="${not empty product.images}">
                            <img src="${url}${product.images[0].url}" class="product-img" alt="${product.name}">
                        </c:when>
                        <c:otherwise>
                            <img src="https://via.placeholder.com/300" class="product-img" alt="Placeholder">
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="product-info">
                    <div class="product-name">${product.name}</div>
                    <div class="product-price">
                        <fmt:formatNumber value="${product.variants[0].price}" type="currency" currencySymbol="₫" />
                    </div>
                    <div class="product-meta">
                        <span>Kho: ${product.variants[0].stock}</span>
                        <span><i class="fas fa-star text-warning me-1"></i>${product.averageRating}</span>
                    </div>
                </div>
            </a>
        </c:forEach>
    </div>

    <c:if test="${empty products}">
        <div class="text-center py-5">
            <i class="fas fa-box-open fa-4x text-muted mb-4 opacity-25"></i>
            <h4 class="text-muted">Bạn chưa có sản phẩm nào</h4>
            <p class="text-muted">Hãy đăng sản phẩm đầu tiên để bắt đầu bán hàng!</p>
            <a href="${url}/seller/product/create" class="btn btn-outline-primary mt-3">Đăng ngay</a>
        </div>
    </c:if>

    <!-- Phân trang -->
    <c:if test="${totalPages > 1}">
        <div class="pagination-wrapper">
            <nav>
                <ul class="pagination">
                    <c:forEach var="i" begin="0" end="${totalPages - 1}">
                        <li class="page-item ${currentPage == i ? 'active' : ''}">
                            <a class="page-link" href="?page=${i}">${i + 1}</a>
                        </li>
                    </c:forEach>
                </ul>
            </nav>
        </div>
    </c:if>
</div>

<jsp:include page="../../client/layout/footer.jsp" />
