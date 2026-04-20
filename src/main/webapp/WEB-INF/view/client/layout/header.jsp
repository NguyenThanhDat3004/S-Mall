<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="url" value="${pageContext.request.contextPath}" />

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link rel="stylesheet" href="${url}/resources/css/client/header.css">

<style>
    /* CSS ÉP BUỘC - Đảm bảo không bị lệch giao diện */
    .top-header-item {
        position: relative !important;
        display: inline-block !important;
    }
    .notification-dropdown {
        display: none;
        position: absolute !important;
        top: 130% !important; /* Đẩy xuống một chút để đẹp hơn */
        right: 0 !important;
        background: white !important;
        width: max-content !important;
        min-width: 220px !important;
        white-space: nowrap !important;
        box-shadow: 0 8px 24px rgba(0,0,0,0.2) !important;
        z-index: 99999 !important;
        border-radius: 8px !important;
        border: 1px solid #ddd !important;
        padding: 5px 0 !important;
    }
    .noti-content a {
        color: #333 !important;
        text-decoration: none !important;
        display: flex !important;
        align-items: center !important;
        padding: 12px 20px !important;
        transition: background 0.2s !important;
        font-weight: 500 !important;
    }
    .noti-content a:hover {
        background-color: #f0f0f0 !important;
    }
    .btn-notification-top {
        cursor: pointer !important;
        color: white !important;
        text-decoration: none !important;
        display: inline-flex !important;
        align-items: center !important;
    }
</style>

<header>
    <nav class="top-header" style="background-color: #1a7a42; color: white; padding: 8px 0;">
        <div class="container d-flex justify-content-between align-items-center">
            <div class="top-header-left">
                <c:choose>
                    <c:when test="${not empty pageContext.request.userPrincipal}">
                        <a href="${url}/seller/dashboard" class="btn-notification-top">Kênh người bán</a>
                    </c:when>
                    <c:otherwise>
                        <a href="${url}/shop/register" class="btn-notification-top">Trở thành người bán</a>
                    </c:otherwise>
                </c:choose>
                <span class="mx-2" style="opacity: 0.5;">|</span>
                <a href="#" class="btn-notification-top"><i class="fab fa-facebook me-1"></i>Kết nối</a>
            </div>
            
            <div class="top-header-right d-flex align-items-center">
                <a href="#" class="btn-notification-top me-3"><i class="fas fa-question-circle me-1"></i>Hỗ trợ</a>
                
                <div class="top-header-item me-3">
                    <a href="javascript:void(0)" class="btn-notification-top" id="langTrigger">
                        <i class="fas fa-globe me-1"></i>Tiếng Việt <i class="fas fa-chevron-down ms-1" style="font-size: 0.7rem;"></i>
                    </a>
                    <div class="notification-dropdown" id="langDropdown" style="min-width: 120px;">
                        <div class="noti-content">
                            <a href="?lang=vi">Tiếng Việt</a>
                            <a href="?lang=en">Tiếng Anh</a>
                        </div>
                    </div>
                </div>

                <span class="me-3" style="opacity: 0.5;">|</span>

                <div class="d-flex align-items-center">
                    <c:choose>
                        <c:when test="${not empty pageContext.request.userPrincipal}">
                            <!-- THÔNG BÁO -->
                            <div class="top-header-item" style="margin-right: 15px;">
                                <a href="javascript:void(0)" class="btn-notification-top" id="notificationTrigger">
                                    <i class="fas fa-bell me-1"></i> Thông báo
                                </a>
                                <div class="notification-dropdown" id="notificationDropdown">
                                    <div class="noti-content">
                                        <div style="padding: 20px; text-align: center; color: #999;">Chưa có thông báo nào</div>
                                    </div>
                                </div>
                            </div>
                            
                            <span class="me-3" style="opacity: 0.5;">|</span>

                            <!-- TÀI KHOẢN -->
                            <div class="top-header-item">
                                <a href="javascript:void(0)" class="btn-notification-top" id="profileTrigger">
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
                                <a href="${url}/register" class="btn-notification-top">Đăng ký</a>
                            </div>
                            <span class="mx-2" style="opacity: 0.5;">|</span>
                            <div class="top-header-item">
                                <a href="${url}/login" class="btn-notification-top">Đăng nhập</a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </nav>

    <div class="header-container" style="background: white; padding: 12px 0; border-bottom: 1px solid #f0f0f0; box-shadow: 0 2px 10px rgba(0,0,0,0.05);">
        <div class="container d-flex justify-content-between align-items-center">
            <div class="logo-section">
                <a href="${url}/" style="text-decoration: none; font-size: 30px; font-weight: 800; color: #1a7a42;">S-<span>Mall</span></a>
            </div>
            <div class="search-section flex-grow-1 mx-5">
                <form action="${url}/search" method="GET" style="display: flex;">
                    <input type="text" name="query" class="form-control" placeholder="Tìm sản phẩm, thương hiệu..." style="border-radius: 25px 0 0 25px; border: 2px solid #1a7a42; padding: 10px 25px;">
                    <button type="submit" class="btn" style="background: #1a7a42; color: white; border-radius: 0 25px 25px 0; padding: 0 30px;">
                        <i class="fa fa-search"></i>
                    </button>
                </form>
            </div>
            <div class="cart-section d-flex align-items-center">
                <a href="${url}/messages" class="me-4" style="color: #1a7a42; font-size: 24px; transition: all 0.3s ease; position: relative;" title="Tin nhắn">
                    <i class="fas fa-comment-dots"></i>
                    <span style="position: absolute; top: -8px; right: -10px; background: #ef4444; color: white; font-size: 11px; padding: 2px 6px; border-radius: 50%; font-weight: bold;">0</span>
                </a>
                <a href="${url}/cart" style="color: #1a7a42; font-size: 26px; position: relative;">
                    <i class="fa fa-shopping-cart"></i>
                    <span style="position: absolute; top: -10px; right: -12px; background: #ef4444; color: white; font-size: 11px; padding: 2px 6px; border-radius: 50%; font-weight: bold;">0</span>
                </a>
            </div>
        </div>
    </div>
</header>

<script>
document.addEventListener('DOMContentLoaded', function() {
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