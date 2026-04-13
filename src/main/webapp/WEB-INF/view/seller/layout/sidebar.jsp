<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="url" value="${pageContext.request.contextPath}" />

<aside class="admin-sidebar">
    <div class="sidebar-brand">
        <i class="fas fa-store"></i>
        <span>S-Mall Seller</span>
    </div>

    <ul class="sidebar-menu">
        <li class="menu-item active">
            <a href="${url}/seller/dashboard" class="menu-link">
                <i class="fas fa-th-large"></i>
                <span>Tổng quan</span>
            </a>
        </li>
        <li class="menu-item">
            <a href="${url}/admin/product/show" class="menu-link">
                <i class="fas fa-box"></i>
                <span>Sản phẩm</span>
            </a>
        </li>
        <li class="menu-item">
            <a href="${url}/admin/order/show" class="menu-link">
                <i class="fas fa-file-invoice-dollar"></i>
                <span>Đơn hàng</span>
            </a>
        </li>
        <li class="menu-item">
            <a href="${url}/admin/user/show" class="menu-link">
                <i class="fas fa-users"></i>
                <span>Khách hàng</span>
            </a>
        </li>
        <li class="menu-item">
            <a href="#" class="menu-link">
                <i class="fas fa-chart-line"></i>
                <span>Doanh thu</span>
            </a>
        </li>
        <li class="menu-item">
            <a href="#" class="menu-link">
                <i class="fas fa-cog"></i>
                <span>Cài đặt</span>
            </a>
        </li>
    </ul>

    <div class="sidebar-footer">
        <a href="${url}/logout" class="menu-link">
            <i class="fas fa-sign-out-alt"></i>
            <span>Đăng xuất</span>
        </a>
    </div>
</aside>
