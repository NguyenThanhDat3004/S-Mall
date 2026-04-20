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
                            <c:when
                                test="${not empty sessionScope.shopId || sessionScope.userRole == 'SELLER' || sessionScope.userRole == 'ADMIN' || sessionScope.userRole == 'SUPER_ADMIN'}">
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
                                    <!-- Notifications -->
                                    <div class="top-header-item">
                                        <a href="javascript:void(0)" class="btn-notification-top"
                                            id="notificationTrigger">
                                            <i class="fas fa-bell me-1" style="position: relative;">
                                                <span class="badge-dot" id="unreadBadge"
                                                    style="display: none; position: absolute; top: -2px; right: -4px; width: 8px; height: 8px; background: #ff4d4f; border-radius: 50%; border: 1px solid white;"></span>
                                            </i>
                                            Thông báo
                                        </a>
                                        <div class="notification-dropdown" id="notificationDropdown"
                                            style="display: none; position: absolute; top: 100%; right: 0; z-index: 9999; background: white; min-width: 250px; border-radius: 6px; box-shadow: 0 10px 25px rgba(0,0,0,0.2); border: 1px solid #eee; margin-top: 10px;">
                                            <div class="noti-content" id="notificationList">
                                                <div class="noti-empty"
                                                    style="color: #333; padding: 20px; text-align: center; font-size: 0.9rem;">
                                                    Chưa có thông báo nào
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <span class="top-header-divider ms-2">|</span>

                                    <!-- Profile Dropdown -->
                                    <div class="top-header-item ms-2">
                                        <a href="javascript:void(0)" class="btn-notification-top" id="profileTrigger"
                                            style="background: rgba(255,255,255,0.1);">
                                            <i class="fas fa-user-circle me-1"></i> Tài khoản
                                        </a>
                                        <div class="notification-dropdown" id="profileDropdown"
                                            style="display: none; position: absolute; top: 100%; right: 0; z-index: 9999; background: white; min-width: 180px; border-radius: 6px; box-shadow: 0 10px 25px rgba(0,0,0,0.2); border: 1px solid #eee; margin-top: 10px;">
                                            <div class="noti-content">
                                                <a href="${url}/profile"
                                                    style="color: #333 !important; display: block !important; padding: 12px 15px !important; border-bottom: 1px solid #f0f0f0 !important; margin: 0 !important; text-decoration: none;">
                                                    <i class="fas fa-user-edit me-2"></i> Xem trang cá nhân
                                                </a>
                                                <a href="${url}/logout"
                                                    style="color: #ef4444 !important; display: block !important; padding: 12px 15px !important; font-weight: 600 !important; margin: 0 !important; text-decoration: none;">
                                                    <i class="fas fa-sign-out-alt me-2"></i> Đăng xuất
                                                </a>
                                            </div>
                                        </div>
                                    </div>

                                    <script>
                                        document.addEventListener('DOMContentLoaded', function () {
                                            const setupDropdown = (triggerId, dropdownId) => {
                                                const trigger = document.getElementById(triggerId);
                                                const dropdown = document.getElementById(dropdownId);
                                                if (trigger && dropdown) {
                                                    trigger.addEventListener('click', function (e) {
                                                        e.preventDefault();
                                                        e.stopPropagation();
                                                        // Đóng các dropdown khác
                                                        document.querySelectorAll('.notification-dropdown').forEach(d => {
                                                            if (d !== dropdown) d.style.display = 'none';
                                                        });
                                                        // Bật/Tắt dropdown hiện tại
                                                        dropdown.style.display = dropdown.style.display === 'none' ? 'block' : 'none';
                                                    });
                                                }
                                            };

                                            setupDropdown('notificationTrigger', 'notificationDropdown');
                                            setupDropdown('profileTrigger', 'profileDropdown');

                                            // Click ra ngoài thì đóng hết
                                            document.addEventListener('click', function (e) {
                                                document.querySelectorAll('.notification-dropdown').forEach(d => {
                                                    if (!d.contains(e.target)) d.style.display = 'none';
                                                });
                                            });
                                        });
                                    </script>
                                </c:when>
                                <c:otherwise>
                                    <div class="ms-2">
                                        <a href="${url}/register" class="fw-bold" style="text-decoration: none;">Đăng
                                            ký</a>
                                        <span class="top-header-divider">|</span>
                                        <a href="${url}/login" class="fw-bold" style="text-decoration: none;">Đăng
                                            nhập</a>
                                    </div>
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