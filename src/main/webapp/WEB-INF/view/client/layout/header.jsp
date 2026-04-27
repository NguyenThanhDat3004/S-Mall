<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="url" value="${pageContext.request.contextPath}" />

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${url}/resources/css/client/header.css">

<header>
    <nav class="top-header">
        <div class="container d-flex justify-content-between align-items-center">
            <div class="top-header-left">
                <c:choose>
                    <c:when test="${not empty pageContext.request.userPrincipal}">
                        <a href="${url}/seller/dashboard">Kênh người bán</a>
                    </c:when>
                    <c:otherwise>
                        <a href="${url}/shop/register">Trở thành người bán</a>
                    </c:otherwise>
                </c:choose>
                <span style="opacity: 0.3;">|</span>
                <a href="#"><i class="fab fa-facebook me-1"></i>Kết nối</a>
            </div>
            
            <div class="top-header-right d-flex align-items-center">
                <a href="#" class=""><i class="fas fa-question-circle me-1"></i>Hỗ trợ</a>
                <span style="opacity: 0.3;">|</span>
                <div class="top-header-item">
                    <a href="javascript:void(0)" id="langTrigger">
                        <i class="fas fa-globe me-1"></i>Tiếng Việt <i class="fas fa-chevron-down ms-1" style="font-size: 0.7rem;"></i>
                    </a>
                    <div class="notification-dropdown" id="langDropdown">
                        <div class="noti-content">
                            <a href="?lang=vi">Tiếng Việt</a>
                            <a href="?lang=en">Tiếng Anh</a>
                        </div>
                    </div>
                </div>

                <span style="opacity: 0.3;">|</span>

                <div class="d-flex align-items-center" style="gap: 15px;">
                    <c:choose>
                        <c:when test="${not empty pageContext.request.userPrincipal}">
                            <div class="top-header-item">
                                <a href="javascript:void(0)" id="notificationTrigger">
                                    <i class="fas fa-bell me-1"></i> Thông báo
                                </a>
                                <div class="notification-dropdown" id="notificationDropdown">
                                    <div class="noti-content">
                                        <div style="padding: 20px; text-align: center; color: #999;">Chưa có thông báo nào</div>
                                    </div>
                                </div>
                            </div>
                            
                            <span style="opacity: 0.3;">|</span>

                            <div class="top-header-item">
                                <a href="javascript:void(0)" id="profileTrigger">
                                    <i class="fas fa-user-circle me-1"></i> Tài khoản
                                </a>
                                <div class="notification-dropdown" id="profileDropdown">
                                    <div class="noti-content">
                                        <a href="${url}/profile">
                                            <i class="fas fa-user-edit me-2"></i> Xem trang cá nhân
                                        </a>
                                        <div style="height: 1px; background: #eee; margin: 4px 0;"></div>
                                        <a href="${url}/logout" style="color: #ef4444 !important;">
                                            <i class="fas fa-sign-out-alt me-2"></i> Đăng xuất
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="top-header-item">
                                <a href="${url}/register">Đăng ký</a>
                            </div>
                            <span style="opacity: 0.3;">|</span>
                            <div class="top-header-item">
                                <a href="${url}/login">Đăng nhập</a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </nav>

    <div class="header-container" id="mainHeader">
        <div class="container d-flex justify-content-between align-items-center">
            <div class="logo-section">
                <a href="${url}/">S<span class="mall-box">Mall</span></a>
            </div>
            
            <div class="search-section">
                <form action="${url}/search" method="GET" class="search-group">
                    <input type="text" name="query" class="search-input" placeholder="Tìm kiếm sản phẩm, thương hiệu...">
                    <button type="submit" class="search-btn">
                        <i class="fa fa-search"></i>
                    </button>
                </form>
            </div>

            <div class="cart-section">
                <a href="${url}/messages" class="cart-icon-wrapper">
                    <i class="fas fa-comment-dots cart-icon"></i>
                    <span class="d-none d-lg-inline" style="font-size: 14px; font-weight: 500;">Chat</span>
                    <span class="cart-badge">0</span>
                </a>
                <a href="${url}/cart" class="cart-icon-wrapper">
                    <i class="fa fa-shopping-cart cart-icon"></i>
                    <span class="d-none d-lg-inline" style="font-size: 14px; font-weight: 500;">Giỏ hàng</span>
                    <span class="cart-badge">0</span>
                </a>
            </div>
        </div>
    </div>
</header>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const header = document.getElementById('mainHeader');
    window.addEventListener('scroll', () => {
        if (window.scrollY > 50) {
            header.classList.add('sticky');
        } else {
            header.classList.remove('sticky');
        }
    });

    const setupDropdown = (triggerId, dropdownId) => {
        const trigger = document.getElementById(triggerId);
        const dropdown = document.getElementById(dropdownId);
        if (trigger && dropdown) {
            trigger.addEventListener('click', function(e) {
                e.preventDefault(); e.stopPropagation();
                document.querySelectorAll('.notification-dropdown').forEach(d => {
                    if (d !== dropdown) d.style.display = 'none';
                });
                dropdown.style.display = dropdown.style.display === 'none' ? 'block' : 'none';
            });
        }
    };
    setupDropdown('notificationTrigger', 'notificationDropdown');
    setupDropdown('profileTrigger', 'profileDropdown');
    setupDropdown('langTrigger', 'langDropdown');
    
    document.addEventListener('click', function(e) {
        document.querySelectorAll('.notification-dropdown').forEach(d => {
            if (!d.contains(e.target)) d.style.display = 'none';
        });
    });
});
</script>