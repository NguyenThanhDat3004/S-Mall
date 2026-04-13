<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="url" value="${pageContext.request.contextPath}" />

<header class="admin-top-header">
    <div class="header-search">
        <i class="fas fa-search"></i>
        <input type="text" placeholder="Tìm kiếm thống kê hoặc hóa đơn...">
    </div>
    <div class="header-actions">
        <div class="notification-icon">
            <i class="fas fa-bell"></i>
            <span class="badge">3</span>
        </div>
        <div class="user-profile">
            <img src="https://ui-avatars.com/api/?name=${sessionScope.userEmail}&background=27ae60&color=fff" alt="User Avatar">
            <span>${sessionScope.userEmail}</span>
            <i class="fas fa-chevron-down"></i>
        </div>
    </div>
</header>
