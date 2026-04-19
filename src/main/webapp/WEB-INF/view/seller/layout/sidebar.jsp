<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="url" value="${pageContext.request.contextPath}" />

<aside class="admin-sidebar">
    <div class="sidebar-brand">
        <i class="fas fa-store"></i>
        <span>S-Mall Seller</span>
    </div>

    <ul class="sidebar-menu">
        <li class="menu-item">
            <a href="${url}/" class="menu-link">
                <i class="fas fa-home"></i>
                <span>Trang chủ</span>
            </a>
        </li>
        <li class="menu-item dashboard-item">
            <a href="${url}/seller/dashboard" class="menu-link">
                <i class="fas fa-th-large"></i>
                <span>Tổng quan</span>
            </a>
        </li>
        <li class="menu-item has-submenu">
            <a href="javascript:void(0)" class="menu-link submenu-toggle">
                <i class="fas fa-box"></i>
                <span>Sản phẩm</span>
                <i class="fas fa-chevron-right ms-auto arrow-icon"></i>
            </a>
            <ul class="submenu">
                <li><a href="${url}/seller/product/create">Tạo sản phẩm</a></li>
                <li><a href="${url}/seller/product/update">Cập nhật sản phẩm</a></li>
                <li><a href="${url}/seller/product/show">Danh sách sản phẩm</a></li>
            </ul>
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

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const menuLinks = document.querySelectorAll('.menu-link');
        const menuItems = document.querySelectorAll('.menu-item');
        
        // Logic xử lý khi nhấp
        menuLinks.forEach(link => {
            link.addEventListener('click', function(e) {
                const menuItem = this.closest('.menu-item');
                
                if (menuItem.classList.contains('has-submenu')) {
                    // Nếu là dropdown, chỉ toggle mở/đóng và tô xanh
                    e.preventDefault();
                    menuItem.classList.toggle('open');
                }
                
                // Loại bỏ active ở tất cả các mục khác
                menuItems.forEach(item => item.classList.remove('active'));
                // Thêm active vào mục hiện tại
                menuItem.classList.add('active');
            });
        });

        // Tự động tô xanh dựa trên URL hiện tại (để giữ trạng thái khi load lại trang)
        const currentPath = window.location.pathname;
        const contextPath = '${url}';

        menuLinks.forEach(link => {
            const href = link.getAttribute('href');
            if (href !== 'javascript:void(0)' && href !== '#' && href !== '') {
                // Không tự động tô xanh "Trang chủ" trong menu Seller trừ khi ở đúng trang chủ
                if (href === contextPath + '/' || href === '/') {
                    if (currentPath === href) {
                        link.closest('.menu-item').classList.add('active');
                    }
                } else if (currentPath.includes(href)) {
                    link.closest('.menu-item').classList.add('active');
                    if (link.closest('.submenu')) {
                        link.closest('.has-submenu').classList.add('open', 'active');
                    }
                }
            }
        });
        
        // Mặc định tô xanh Tổng quan nếu ở đúng trang
        if (currentPath.endsWith('/seller/dashboard')) {
             document.querySelector('.dashboard-item').classList.add('active');
        }
    });
</script>
