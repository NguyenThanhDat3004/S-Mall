<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="url" value="${pageContext.request.contextPath}" />

<jsp:include page="../client/layout/header.jsp" />

<div class="container py-5 text-center">
    <div class="error-wrapper py-5">
        <div class="error-icon mb-4">
            <i class="fas fa-map-signs text-primary" style="font-size: 5rem;"></i>
        </div>
        <h1 class="display-4 fw-bold text-dark mb-3">404 - Không Tìm Thấy</h1>
        <p class="lead text-muted mb-5">
            Trang bạn đang tìm kiếm có thể đã bị xóa, thay đổi tên hoặc tạm thời không khả dụng.
        </p>
        <div class="error-actions">
            <a href="${url}/" class="btn btn-success px-4 py-2 rounded-pill">
                <i class="fas fa-home me-2"></i> Quay về trang chủ
            </a>
        </div>
    </div>
</div>

<jsp:include page="../client/layout/footer.jsp" />
