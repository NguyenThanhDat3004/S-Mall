<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="url" value="${pageContext.request.contextPath}" />

<jsp:include page="../layout/header.jsp" />

<!-- Tái sử dụng homepage CSS -->
<link rel="stylesheet" href="${url}/resources/css/client/homepage.css">

<style>
    .search-results-container {
        margin-top: 120px;
        min-height: 500px;
    }
    .search-header {
        background: #fff;
        padding: 20px;
        margin-bottom: 20px;
        border-radius: 4px;
        box-shadow: 0 1px 1px 0 rgba(0,0,0,.05);
    }
    .search-title {
        font-size: 18px;
        color: #555;
    }
    .search-query {
        color: #ee4d2d;
        font-weight: 600;
    }
</style>

<div class="container search-results-container">
    <div class="search-header">
        <h1 class="search-title">
            <i class="bi bi-search me-2"></i> K\u1EBFt qu\u1EA3 t\u00ECm ki\u1EBFm cho: 
            <span class="search-query">"${query}"</span>
        </h1>
        <p class="text-muted mb-0 small">\u0110\u00E3 t\u00ECm th\u1EA5y ${products.size()} s\u1EA3n ph\u1EA9m</p>
    </div>

    <div class="product-grid-container">
        <c:forEach var="p" items="${products}">
            <a href="${url}/product/${p.slug}" class="product-card">
                <div class="product-image-wrapper">
                    <c:choose>
                        <c:when test="${not empty p.images}">
                            <c:forEach var="img" items="${p.images}">
                                <c:if test="${img.main}">
                                    <img src="${img.url}" alt="${p.name}">
                                </c:if>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <img src="${url}/resources/images/default-item.png" alt="No image">
                        </c:otherwise>
                    </c:choose>
                    <c:if test="${not empty p.variants and p.variants[0].discountPrice < p.variants[0].price}">
                        <div class="product-badge">
                            -<fmt:formatNumber value="${(p.variants[0].price - p.variants[0].discountPrice) / p.variants[0].price}" type="percent" />
                        </div>
                    </c:if>
                </div>
                <div class="product-info">
                    <h3 class="product-name">${p.name}</h3>
                    <div class="product-price-row">
                        <span class="price-tag">
                            <fmt:formatNumber value="${p.variants[0].discountPrice < p.variants[0].price ? p.variants[0].discountPrice : p.variants[0].price}" type="number" /> \u20AB
                        </span>
                    </div>
                </div>
            </a>
        </c:forEach>
    </div>

    <c:if test="${empty products}">
        <div class="text-center py-5">
            <img src="https://img.icons8.com/color/96/search-property.png" alt="Empty">
            <h3 class="mt-4 text-muted">Kh\u00F4ng t\u00ECm th\u1EA5y s\u1EA3n ph\u1EA9m n\u00E0o khớp với từ khóa của bạn.</h3>
            <a href="${url}/" class="btn btn-primary mt-3">Quay v\u1EC1 trang ch\u1EE7</a>
        </div>
    </c:if>
</div>

<jsp:include page="../layout/footer.jsp" />
