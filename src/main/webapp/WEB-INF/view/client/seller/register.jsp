<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
            <c:set var="url" value="${pageContext.request.contextPath}" />

            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>S-Mall | Trở Thành Người Bán</title>

                <!-- Google Fonts -->
                <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&display=swap"
                    rel="stylesheet">

                <!-- Bootstrap 5 -->
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

                <!-- Bootstrap Icons -->
                <link rel="stylesheet"
                    href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">

                <!-- Dự án CSS -->
                <link rel="stylesheet" href="${url}/resources/css/client/header.css">
                <link rel="stylesheet" href="${url}/resources/css/client/footer.css">
                <link rel="stylesheet" href="${url}/resources/css/client/seller-register.css">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
            </head>

            <body>
                <jsp:include page="../layout/header.jsp" />

                <main class="container">
                    <div class="register-seller-container">
                        <div class="hero-section">
                            <h1>Chào mừng đến với Kênh Người Bán</h1>
                            <p>Bắt đầu hành trình kinh doanh tuyệt vời của bạn tại S-Mall ngay hôm nay!</p>
                        </div>

                        <c:if test="${not empty error}">
                            <div
                                style="background: #fef2f2; border-left: 4px solid #ef4444; padding: 15px; margin-bottom: 20px; color: #991b1b;">
                                <i class="fas fa-exclamation-circle me-2"></i> ${error}
                            </div>
                        </c:if>

                        <form:form action="${url}/shop/register" method="POST" modelAttribute="shopDTO"
                            enctype="multipart/form-data">
                            <div class="form-group">
                                <label class="form-label">Tên Cửa Hàng (Shop Name) *</label>
                                <form:input path="name" class="form-control" placeholder="Tên shop của bạn là gì?" />
                                <form:errors path="name" cssClass="text-danger" />
                            </div>

                            <div class="form-group">
                                <label class="form-label">Mô Tả Cửa Hàng</label>
                                <form:textarea path="description" class="form-control" rows="4"
                                    placeholder="Giới thiệu ngắn gọn về shop của bạn..." />
                                <form:errors path="description" cssClass="text-danger" />
                            </div>

                            <div class="form-group">
                                <label class="form-label">Logo Shop</label>
                                <div class="logo-upload-zone" onclick="document.getElementById('logoFile').click()">
                                    <i class="fas fa-cloud-upload-alt fa-3x" style="color: #64748b;"></i>
                                    <p style="margin-top: 10px; color: #475569;">Nhấp để tải ảnh Logo lên</p>
                                    <input type="file" name="logoFile" id="logoFile" style="display: none;"
                                        onchange="previewLogo(this)" />
                                    <img id="logo-preview" src="#" alt="Logo Preview" />
                                </div>
                            </div>

                            <button type="submit" class="btn-register-shop">
                                <i class="fas fa-rocket me-2"></i> Đăng Ký Trở Thành Người Bán
                            </button>
                        </form:form>
                    </div>
                </main>

                <jsp:include page="../layout/footer.jsp" />

                <!-- Bootstrap JS -->
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

                <script>
                    function previewLogo(input) {
                        const preview = document.getElementById('logo-preview');
                        const icon = input.parentElement.querySelector('i');
                        const text = input.parentElement.querySelector('p');

                        if (input.files && input.files[0]) {
                            const reader = new FileReader();
                            reader.onload = function (e) {
                                preview.src = e.target.result;
                                preview.style.display = 'block';
                                icon.style.display = 'none';
                                text.style.display = 'none';
                            }
                            reader.readAsDataURL(input.files[0]);
                        }
                    }
                </script>
            </body>

            </html>