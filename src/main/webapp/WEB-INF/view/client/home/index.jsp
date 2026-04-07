<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <c:set var="url" value="${pageContext.request.contextPath}" />
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>S-Mall | Modern E-Commerce Marketplace</title>

            <!-- Bootstrap CSS -->
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

            <!-- Custom CSS -->
            <link rel="stylesheet" href="${url}/css/client/header.css">
            <link rel="stylesheet" href="${url}/css/client/footer.css">
            <link rel="stylesheet" href="${url}/css/client/homepage.css">
        </head>

        <body>

            <!-- Include Header -->
            <jsp:include page="../layout/header.jsp" />


            <!-- Main Content Area -->
            <main class="container py-4">
                
                <!-- [NEW] Expandable Category Navigation Bar -->
                <section class="category-section mb-5">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h2 class="section-title mb-0">Danh mục</h2>
                        <button class="btn btn-sm btn-link text-success text-decoration-none fw-bold" 
                                type="button" data-bs-toggle="collapse" data-bs-target="#extraCategories" 
                                aria-expanded="false" aria-controls="extraCategories" id="btnToggleCats">
                            <span class="toggle-text"></span> <i class="bi bi-chevron-down"></i>
                        </button>
                    </div>

                    <!-- Row 1: Always Visible (7 items) -->
                    <div class="category-grid">
                        <a href="#" class="category-item">
                            <div class="category-icon">
                                <img src="https://img.icons8.com/color/96/t-shirt.png" alt="Thời trang nam">
                            </div>
                            <span class="category-label">Thời trang nam</span>
                        </a>
                        <a href="#" class="category-item">
                            <div class="category-icon">
                                <img src="https://img.icons8.com/color/96/wedding-dress.png" alt="Thời trang nữ">
                            </div>
                            <span class="category-label">Thời trang nữ</span>
                        </a>
                        <a href="#" class="category-item">
                            <div class="category-icon">
                                <img src="https://img.icons8.com/color/96/washing-machine.png" alt="Đồ gia dụng">
                            </div>
                            <span class="category-label">Đồ gia dụng</span>
                        </a>
                        <a href="#" class="category-item">
                            <div class="category-icon">
                                <img src="https://img.icons8.com/color/96/smartphone.png" alt="Thiết bị điện tử">
                            </div>
                            <span class="category-label">Thiết bị điện tử</span>
                        </a>
                        <a href="#" class="category-item">
                            <div class="category-icon">
                                <img src="https://img.icons8.com/color/96/lipstick.png" alt="Mĩ phẩm">
                            </div>
                            <span class="category-label">Mĩ phẩm</span>
                        </a>
                        <a href="#" class="category-item">
                            <div class="category-icon">
                                <img src="https://img.icons8.com/color/96/shopping-basket.png" alt="Bách hóa online">
                            </div>
                            <span class="category-label">Bách hóa online</span>
                        </a>
                        <a href="#" class="category-item">
                            <div class="category-icon">
                                <img src="https://img.icons8.com/color/96/medical-heart.png" alt="Sức khỏe">
                            </div>
                            <span class="category-label">Sức khỏe</span>
                        </a>
                    </div>

                    <!-- Extra Rows: Collapsible (Next 7+ items) -->
                    <div class="collapse mt-4" id="extraCategories">
                        <div class="category-grid">
                            <a href="#" class="category-item">
                                <div class="category-icon">
                                    <img src="https://img.icons8.com/color/96/trainers.png" alt="Giày dép">
                                </div>
                                <span class="category-label">Giày dép</span>
                            </a>
                            <a href="#" class="category-item">
                                <div class="category-icon">
                                    <img src="https://img.icons8.com/color/96/teddy-bear.png" alt="Đồ chơi">
                                </div>
                                <span class="category-label">Đồ chơi</span>
                            </a>
                            <a href="#" class="category-item">
                                <div class="category-icon">
                                    <img src="https://img.icons8.com/color/96/books.png" alt="Sách">
                                </div>
                                <span class="category-label">Sách</span>
                            </a>
                            <a href="#" class="category-item">
                                <div class="category-icon">
                                    <img src="https://img.icons8.com/color/96/football.png" alt="Thể thao">
                                </div>
                                <span class="category-label">Thể thao</span>
                            </a>
                            <a href="#" class="category-item">
                                <div class="category-icon">
                                    <img src="https://img.icons8.com/color/96/car.png" alt="Ô tô & Xe máy">
                                </div>
                                <span class="category-label">Ô tô & Xe máy</span>
                            </a>
                            <a href="#" class="category-item">
                                <div class="category-icon">
                                    <img src="https://img.icons8.com/color/96/womens-watch.png" alt="Phụ kiện">
                                </div>
                                <span class="category-label">Phụ kiện</span>
                            </a>
                            <a href="#" class="category-item">
                                <div class="category-icon">
                                    <img src="https://img.icons8.com/color/96/blender.png" alt="Điện gia dụng">
                                </div>
                                <span class="category-label">Điện gia dụng</span>
                            </a>
                        </div>
                    </div>
                </section>

                <!-- Featured Products Grid -->
                <div class="row">
                    <div class="col-12">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h2 class="section-title">Gợi ý cho bạn</h2>
                            <a href="#" class="btn btn-link text-success text-decoration-none">Xem thêm ></a>
                        </div>
                        
                        <div class="alert alert-light border py-5 text-center">
                            <p class="text-muted mb-0">Hệ thống đang tải danh sách sản phẩm...</p>
                        </div>
                    </div>
                </div>
            </main>

            <!-- Footer -->
            <jsp:include page="/WEB-INF/view/client/layout/footer.jsp" />

            <!-- Bootstrap JS -->
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        </body>

        </html>