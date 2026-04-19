<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
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
                                    <span class="toggle-label-text">Xem thêm</span> <i class="bi bi-chevron-down"
                                        id="toggleIcon"></i>
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
                            </div>

                            <div class="product-grid-container" id="homepageProductGrid">
                                <c:forEach var="p" items="${featuredProducts}" varStatus="status">
                                    <a href="${url}/product/${p.slug}"
                                        class="product-card ${status.index >= 12 ? 'd-none-custom' : ''}"
                                        data-index="${status.index}"
                                        style="${status.index >= 12 ? 'display: none !important;' : ''}">
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
                                            <c:if
                                                test="${not empty p.variants and not empty p.variants[0].discountPrice and p.variants[0].discountPrice < p.variants[0].price}">
                                                <div class="product-badge">
                                                    <fmt:formatNumber
                                                        value="${(p.variants[0].price - p.variants[0].discountPrice) / p.variants[0].price * 100}"
                                                        maxFractionDigits="0" />% GIẢM
                                                </div>
                                            </c:if>
                                        </div>
                                        <div class="product-info">
                                            <h3 class="product-name">${p.name}</h3>
                                            <div class="product-price-row">
                                                <span class="price-tag">
                                                    <c:choose>
                                                        <c:when test="${not empty p.variants}">
                                                            <c:choose>
                                                                <c:when
                                                                    test="${p.variants[0].discountPrice < p.variants[0].price}">
                                                                    <fmt:formatNumber
                                                                        value="${p.variants[0].discountPrice}"
                                                                        type="number" /> ₫
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <fmt:formatNumber value="${p.variants[0].price}"
                                                                        type="number" /> ₫
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </c:when>
                                                        <c:otherwise>Liên hệ</c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </div>
                                            <div class="product-meta">
                                                <div class="rating-stars">
                                                    <i class="bi bi-star-fill"></i> ${p.averageRating != null ?
                                                    p.averageRating : '5.0'}
                                                </div>
                                                <div class="sold-count">Đã bán ${p.soldCount != null ? p.soldCount : 0}
                                                </div>
                                            </div>
                                        </div>
                                    </a>
                                </c:forEach>
                            </div>


                            <div class="text-center mt-5" id="paginationControls"
                                style="${not hasNextInitial and featuredProducts.size() <= 12 ? 'display: none;' : ''}">
                                <div class="d-flex justify-content-center gap-3">
                                    <button class="btn btn-outline-success px-4 py-2 fw-bold" id="btnLoadMore"
                                        onclick="handleLoadMore()"
                                        style="${not hasNextInitial and featuredProducts.size() <= 12 ? 'display: none;' : ''}">
                                        <i class="bi bi-plus-lg"></i> Xem thêm sản phẩm
                                    </button>

                                    <button class="btn btn-outline-secondary px-4 py-2 fw-bold" id="btnCollapse"
                                        onclick="handleCollapse()" style="display: none;">
                                        <i class="bi bi-dash-lg"></i> Thu gọn lại
                                    </button>
                                </div>
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
                    const contextPath = '${url}';
                    let currentShown = 12;
                    let currentPage = 1;
                    let hasMoreDataOnServer = ${ hasNextInitial != null ? hasNextInitial : 'false'};
                    const itemsPerStep = 6;
                    const minShown = 12;






                    function updateButtonVisibility() {
                        const btnMore = document.getElementById('btnLoadMore');
                        const btnLess = document.getElementById('btnCollapse');
                        const allItemsInDom = document.querySelectorAll('.product-card').length;

                        // Nút "Xem thêm" hiện khi: (Còn hàng trong DOM chưa hiện) HOẶC (Đã hiện hết DOM nhưng Server vẫn còn hàng)
                        if (currentShown < allItemsInDom || hasMoreDataOnServer) {
                            btnMore.style.display = 'inline-block';
                        } else {
                            btnMore.style.display = 'none';
                        }

                        // Nút "Thu gọn" hiện khi: Số lượng đang hiện lớn hơn mức tối thiểu (12)
                        if (currentShown > minShown) {
                            btnLess.style.display = 'inline-block';
                        } else {
                            btnLess.style.display = 'none';
                        }
                    }


                    async function handleLoadMore() {
                        const hiddenItems = document.querySelectorAll('.product-card.d-none-custom');

                        // Trường hợp 1: Trong DOM vẫn còn hàng chưa hiện
                        if (hiddenItems.length > 0) {
                            revealRemainingLocal();
                            return;
                        }

                        // Trường hợp 2: Đã hiện hết DOM nhưng Server vẫn còn hàng -> Gọi AJAX
                        if (!hasMoreDataOnServer) return;

                        const btnMore = document.getElementById('btnLoadMore');
                        btnMore.disabled = true;
                        btnMore.innerHTML = '<span class="spinner-border spinner-border-sm"></span> Đang nạp...';

                        try {
                            const url = `\${contextPath}/api/recommendations/more?page=\${currentPage}&size=18`;

                            const response = await fetch(url);
                            if (!response.ok) {
                                throw new Error(`HTTP error! status: \${response.status}`);
                            }


                            const data = await response.json();

                            const products = data.products;
                            hasMoreDataOnServer = data.hasNext;

                            if (!products || products.length === 0) {
                                updateButtonVisibility();
                                return;
                            }

                            // Append sản phẩm mới vào Grid
                            const grid = document.getElementById('homepageProductGrid');
                            products.forEach((p, idx) => {
                                const cardHtml = renderProductCard(p, idx);
                                grid.insertAdjacentHTML('beforeend', cardHtml);
                            });

                            currentPage++;

                            // Sau khi nạp xong, hiện 6 cái đầu tiên (hoặc hiện hết nếu là lô cuối)
                            revealRemainingLocal(hasMoreDataOnServer ? itemsPerStep : 999);

                        } catch (err) {
                            // Silent fail for production or simple UI toast if needed
                        } finally {
                            btnMore.disabled = false;
                            btnMore.innerHTML = '<i class="bi bi-plus-lg"></i> Xem thêm sản phẩm';
                        }

                    }


                    function revealRemainingLocal(step = itemsPerStep) {
                        const hiddenItems = document.querySelectorAll('.product-card.d-none-custom');
                        const revealCount = Math.min(step, hiddenItems.length);

                        for (let i = 0; i < revealCount; i++) {
                            const item = hiddenItems[i];
                            item.classList.remove('d-none-custom');
                            item.style.setProperty('display', 'flex', 'important');
                            item.style.opacity = '0';
                            setTimeout(() => {
                                item.style.transition = 'opacity 0.4s ease';
                                item.style.opacity = '1';
                            }, i * 50);
                        }

                        // Cập nhật lại số lượng đang hiện dựa trên thực tế DOM
                        currentShown = document.querySelectorAll('.product-card:not(.d-none-custom)').length;
                        updateButtonVisibility();
                    }


                    function renderProductCard(p, idx) {
                        // Sử dụng dấu . làm ngăn cách hàng nghìn cho chuẩn VN
                        const formatPrice = (num) => {
                            return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ".");
                        };
                        const priceFmt = formatPrice(p.price || 0);
                        const discPriceFmt = p.discountPrice ? formatPrice(p.discountPrice) : priceFmt;

                        const isDiscount = p.discountPrice && p.discountPrice < p.price;

                        return `
                            <a href="\${contextPath}/product/\${p.slug}" 
                               class="product-card d-none-custom" 
                               style="display: none !important; opacity: 0;">
                                <div class="product-image-wrapper">
                                    <img src="\${p.mainImageUrl || contextPath + '/resources/images/default-item.png'}" alt="\${p.name}">
                                    \${isDiscount ? `< div class="product-badge" >\${ p.discountPercentage }% GIẢM</div > ` : ''}
                                </div>
                                <div class="product-info">
                                    <h3 class="product-name">\${p.name}</h3>
                                    <div class="product-price-row">
                                        <span class="price-tag">\${discPriceFmt} ₫</span>
                                    </div>
                                    <div class="product-meta">
                                        <div class="rating-stars">
                                            <i class="bi bi-star-fill"></i> \${p.averageRating ? p.averageRating.toFixed(1) : '5.0'}
                                        </div>
                                        <div class="sold-count">Đã bán \${p.soldCount || 0}</div>


                                    </div>
                                </div>
                            </a>
                        `;
                    }


                    function handleCollapse() {
                        const allItems = document.querySelectorAll('.product-card');
                        let targetCount = Math.max(currentShown - itemsPerStep, minShown);

                        for (let i = targetCount; i < currentShown; i++) {
                            allItems[i].classList.add('d-none-custom');
                            allItems[i].style.setProperty('display', 'none', 'important');
                        }

                        currentShown = targetCount;
                        updateButtonVisibility();

                        window.scrollTo({
                            top: document.getElementById('homepageProductGrid').offsetTop + (currentShown * 40),
                            behavior: 'smooth'
                        });
                    }

                    function handleToggleCats(e) {
                        e.preventDefault();
                        const extraCats = document.getElementById('extraCategories');
                        const btnToggle = document.getElementById('btnToggleCats');
                        const toggleIcon = document.getElementById('toggleIcon');
                        const isHidden = extraCats.style.display === 'none';
                        const labelText = btnToggle.querySelector('.toggle-label-text');

                        if (isHidden) {
                            extraCats.style.setProperty('display', 'block', 'important');
                            labelText.textContent = 'Thu gọn';
                            if (toggleIcon) toggleIcon.style.transform = 'rotate(180deg)';
                        } else {
                            extraCats.style.setProperty('display', 'none', 'important');
                            labelText.textContent = 'Xem thêm';
                            if (toggleIcon) toggleIcon.style.transform = 'rotate(0deg)';
                        }
                    }
                </script>
            </body>

            </html>