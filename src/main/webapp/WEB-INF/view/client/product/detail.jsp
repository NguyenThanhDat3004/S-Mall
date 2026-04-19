<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="url" value="${pageContext.request.contextPath}" />

<jsp:include page="../layout/header.jsp" />

<link rel="stylesheet" href="${url}/resources/css/client/product_detail.css">

<div class="detail-container">

    <div class="product-main">
        <div class="product-images">
            <div class="main-image-wrapper">
                <c:forEach var="img" items="${product.images}">
                    <c:if test="${img.main}">
                        <img src="${img.url}" alt="${product.name}">
                    </c:if>
                </c:forEach>
            </div>
        </div>

        <div class="product-info">
            <h1 class="product-title">${product.name}</h1>
            
            <div class="product-stats">
                <div class="rating-badge">
                    <span>${product.averageRating}</span>
                    <i class="fas fa-star"></i>
                </div>
                <span>${product.soldCount} \u0110\u00E3 b\u00E1n</span>
            </div>

            <div class="price-section">
                <c:set var="variant" value="${product.variants[0]}" />
                <c:if test="${variant.discountPrice < variant.price}">
                    <span class="old-price">
                        <fmt:formatNumber value="${variant.price}" type="currency" currencySymbol="\u20AB" />
                    </span>
                    <span class="current-price">
                        <fmt:formatNumber value="${variant.discountPrice}" type="currency" currencySymbol="\u20AB" />
                    </span>
                    <span class="discount-tag">
                        -<fmt:formatNumber value="${(variant.price - variant.discountPrice)/variant.price}" type="percent" />
                    </span>
                </c:if>
                <c:if test="${variant.discountPrice >= variant.price}">
                    <span class="current-price">
                        <fmt:formatNumber value="${variant.price}" type="currency" currencySymbol="\u20AB" />
                    </span>
                </c:if>
            </div>

            <div class="product-description">
                <h3 class="description-title">Chi ti\u1EBFt s\u1EA3n ph\u1EA9m</h3>
                <div class="description-content">
                    ${product.description}
                </div>
            </div>

            <div class="action-buttons">
                <button class="btn-cart">
                    <i class="fas fa-cart-plus"></i>
                    Th\u00EAm V\u00E0o Gi\u1ECF H\u00E0ng
                </button>
                <button class="btn-buy">Mua Ngay</button>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../layout/footer.jsp" />
