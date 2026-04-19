<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <c:set var="url" value="${pageContext.request.contextPath}" />
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>S-Mall | Modern E-Commerce Marketplace</title>

                <!-- Bootstrap CSS & Icons -->
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                <link rel="stylesheet"
                    href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">

                <!-- Custom CSS -->
                <link rel="stylesheet" href="${url}/resources/css/client/header.css">
                <link rel="stylesheet" href="${url}/resources/css/client/footer.css">
                <link rel="stylesheet" href="${url}/resources/css/client/homepage.css">

            </head>

            <body>

                <!-- Include Header -->
                <jsp:include page="../layout/header.jsp" />


                <!-- Main Content Area -->
                <main class="container py-4">

                    <!-- [DYNAMIC] Expandable Category Navigation Bar -->
                    <section class="category-section mb-5">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h2 class="section-title mb-0">Danh mục</h2>
                            <c:if test="${categories.size() > 7}">
                                <button class="btn btn-sm btn-link text-success text-decoration-none fw-bold"
                                    type="button" id="btnToggleCats" onclick="handleToggleCats(event)" 
                                    style="cursor: pointer !important; position: relative; z-index: 9999 !important;">
                                    <span class="toggle-label-text">Xem thêm</span> <i class="bi bi-chevron-down" id="toggleIcon"></i>
                                </button>
                            </c:if>
                        </div>

                        <!-- Row 1: First 7 items -->
                        <div class="category-grid">
                            <c:forEach var="cat" items="${categories}" varStatus="status" end="6">
                                <a href="${url}/category/${cat.slug}" class="category-item">
                                    <div class="category-icon">
                                        <img src="${cat.iconUrl}" alt="${cat.name}">
                                    </div>
                                    <span class="category-label">${cat.name}</span>
                                </a>
                            </c:forEach>
                        </div>

                        <!-- Row 2+: The rest hidden in collapse -->
                        <c:if test="${categories.size() > 7}">
                            <div id="extraCategories" style="display: none; transition: all 0.3s ease;">
                                <div class="category-grid mt-4">
                                    <c:forEach var="cat" items="${categories}" varStatus="status" begin="7">
                                        <a href="${url}/category/${cat.slug}" class="category-item">
                                            <div class="category-icon">
                                                <img src="${cat.iconUrl}" alt="${cat.name}">
                                            </div>
                                            <span class="category-label">${cat.name}</span>
                                        </a>
                                    </c:forEach>
                                </div>
                            </div>
                        </c:if>
                    </section>

                    <!-- Featured Products Grid -->
                    <div class="row">
                        <div class="col-12">
                            <div class="d-flex justify-content-between align-items-center mb-4">
                                <h2 class="section-title">Gợi ý cho bạn</h2>
                                <a href="${url}/products" class="btn btn-link text-success text-decoration-none">Xem
                                    thêm ></a>
                            </div>

                            <div class="product-grid-container">
                                <c:forEach var="p" items="${featuredProducts}">
                                    <a href="${url}/product/${p.id}" class="product-card">
                                        <div class="product-image-wrapper">
                                            <c:choose>
                                                <c:when test="${not empty p.images}">
                                                    <img src="${p.images[0].url}" alt="${p.name}">
                                                </c:when>
                                                <c:otherwise>
                                                    <img src="${url}/resources/images/default-item.png" alt="No image">
                                                </c:otherwise>
                                            </c:choose>
                                            <c:if test="${not empty p.variants and not empty p.variants[0].discountPrice and p.variants[0].discountPrice < p.variants[0].price}">
                                                <div class="product-badge">
                                                    <fmt:formatNumber value="${(p.variants[0].price - p.variants[0].discountPrice) / p.variants[0].price * 100}" maxFractionDigits="0"/>% GIẢM
                                                </div>
                                            </c:if>
                                        </div>
                                        <div class="product-info">
                                            <h3 class="product-name">${p.name}</h3>
                                            <div class="product-price-row">
                                                <span class="price-tag">
                                                    <c:choose>
                                                        <c:when test="${not empty p.variants}">
                                                            <fmt:formatNumber value="${p.variants[0].price}"
                                                                type="number" />
                                                        </c:when>
                                                        <c:otherwise>Liên hệ</c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </div>
                                            <div class="product-meta">
                                                <div class="rating-stars">
                                                    <i class="bi bi-star-fill"></i> ${p.averageRating > 0 ?
                                                    p.averageRating : '5.0'}
                                                </div>
                                                <div class="sold-count">Đã bán 0</div>
                                            </div>
                                        </div>
                                    </a>
                                </c:forEach>
                            </div>

                            <c:if test="${empty featuredProducts}">
                                <div class="alert alert-light border py-5 text-center">
                                    <p class="text-muted mb-0">Chưa có sản phẩm nào được đề xuất.</p>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </main>

                <!-- Footer -->
                <jsp:include page="/WEB-INF/view/client/layout/footer.jsp" />

                <!-- Bootstrap JS -->
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

                <script>
                    // Hàm Global - Bất tử, gọi là chạy
                    function handleToggleCats(e) {
                        if (e) {
                            e.preventDefault();
                            e.stopPropagation();
                        }
                        
                        const extraCats = document.getElementById('extraCategories');
                        const btnToggle = document.getElementById('btnToggleCats');
                        const toggleIcon = document.getElementById('toggleIcon');
                        
                        console.log('Toggle Button Clicked!'); // Debug log
                        
                        if (extraCats && btnToggle) {
                            const isHidden = extraCats.style.display === 'none';
                            const labelText = btnToggle.querySelector('.toggle-label-text');

                            if (isHidden) {
                                extraCats.style.setProperty('display', 'block', 'important');
                                labelText.textContent = 'Thu gọn';
                                if(toggleIcon) toggleIcon.style.transform = 'rotate(180deg)';
                                console.log('Status: Expanded');
                            } else {
                                extraCats.style.setProperty('display', 'none', 'important');
                                labelText.textContent = 'Xem thêm';
                                if(toggleIcon) toggleIcon.style.transform = 'rotate(0deg)';
                                console.log('Status: Collapsed');
                            }
                        } else {
                            console.error('Elements not found: extraCategories or btnToggleCats');
                        }
                    }
                    
                    // Đảm bảo nút vẫn hoạt động nếu log bị kẹt
                    document.addEventListener('DOMContentLoaded', function() {
                        console.log('Page Ready - Category Toggle Initialized');
                    });
                </script>
            </body>

            </html>