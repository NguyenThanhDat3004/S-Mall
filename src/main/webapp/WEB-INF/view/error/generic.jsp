<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="url" value="${pageContext.request.contextPath}" />

<jsp:include page="../client/layout/header.jsp" />

<div class="container py-5 text-center">
    <div class="error-wrapper py-5">
        <div class="error-icon mb-4">
            <i class="fas fa-exclamation-triangle text-warning" style="font-size: 5rem;"></i>
        </div>
        <h1 class="display-4 fw-bold text-dark mb-3">Rất Tiếc!</h1>
        <p class="lead text-muted mb-5">
            Đã có lỗi xảy ra trong quá trình xử lý yêu cầu của bạn.<br>
            <span class="text-danger font-monospace">${errorMessage}</span>
        </p>
        <div class="error-actions">
            <a href="${url}/" class="btn btn-success px-4 py-2 rounded-pill me-3">
                <i class="fas fa-home me-2"></i> Quay về trang chủ
            </a>
            <button onclick="history.back()" class="btn btn-outline-secondary px-4 py-2 rounded-pill">
                <i class="fas fa-arrow-left me-2"></i> Quay lại trang trước
            </button>
        </div>
    </div>
</div>

<jsp:include page="../client/layout/footer.jsp" />
