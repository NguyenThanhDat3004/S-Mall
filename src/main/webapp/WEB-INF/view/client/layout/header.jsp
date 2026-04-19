<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <c:set var="url" value="${pageContext.request.contextPath}" />

        <!-- Font Awesome for Icons -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

        <header>
            <!-- Top Utility Bar -->
            <nav class="top-header">
                <div class="container d-flex justify-content-between align-items-center">
                    <div class="top-header-left">
                        <c:choose>
                            <c:when test="${not empty sessionScope.shopId || sessionScope.userRole == 'SELLER' || sessionScope.userRole == 'ADMIN' || sessionScope.userRole == 'SUPER_ADMIN'}">
                                <a href="${url}/seller/dashboard">Kênh người bán</a>
                            </c:when>
                            <c:otherwise>
                                <a href="${url}/shop/register">Trở thành người bán</a>
                            </c:otherwise>
                        </c:choose>
                        <span class="top-header-divider">|</span>
                        <a href="#"><i class="fab fa-facebook me-1"></i>Kết nối FB</a>
                    </div>
                    <div class="top-header-right d-flex align-items-center">
                        <a href="#"><i class="fas fa-bell me-1"></i>Thông báo</a>
                        <a href="#"><i class="fas fa-question-circle me-1"></i>Hỗ trợ</a>
                        <div class="top-header-item">
                            <a href="#"><i class="fas fa-globe me-1"></i>Ngôn ngữ <i class="fas fa-chevron-down ms-1"
                                    style="font-size: 0.7rem;"></i></a>
                            <ul class="dropdown-menu-custom">
                                <li><a href="#">Tiếng Việt</a></li>
                                <li><a href="#">Tiếng Anh</a></li>
                            </ul>
                        </div>

                        <span class="top-header-divider ms-2">|</span>

                        <div class="ms-2 d-flex align-items-center">
                            <c:choose>
                                <c:when test="${not empty pageContext.request.userPrincipal}">
                                    <span class="me-2 text-white" style="font-size: 0.9rem;">Chào, ${sessionScope.userEmail}</span>
                                    <a href="${url}/profile">Profile</a>
                                    <span class="top-header-divider">|</span>
                                    <a href="${url}/logout" class="text-danger fw-bold">Đăng xuất</a>
                                </c:when>
                                <c:otherwise>
                                    <a href="${url}/register" class="fw-bold">Đăng ký</a>
                                    <span class="top-header-divider">|</span>
                                    <a href="${url}/login" class="fw-bold">Đăng nhập</a>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </nav>

            <!-- Main Header Container -->
            <div class="header-container">
                <div class="container header-content">
                    <!-- Logo Section -->
                    <div class="logo-section">
                        <a href="${url}/">S-<span>Mall</span></a>
                    </div>

                    <!-- Search Section -->
                    <div class="search-section">
                        <form action="${url}/search" method="GET" class="search-group">
                            <input type="text" name="query" class="search-input"
                                placeholder="Search for products, brands, and more...">
                            <button type="submit" class="search-btn">
                                <i class="fa fa-search"></i> Search
                            </button>
                        </form>
                    </div>

                    <!-- Cart Section -->
                    <div class="cart-section">
                        <div class="cart-icon-wrapper">
                            <a href="${url}/cart" style="text-decoration: none;">
                                <i class="fa fa-shopping-cart cart-icon"></i>
                                <span class="cart-badge">0</span>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </header>