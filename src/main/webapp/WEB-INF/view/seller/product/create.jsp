<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <c:set var="url" value="${pageContext.request.contextPath}" />

        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>S-Mall | Thêm Sản Phẩm Mới</title>

            <!-- Link CSS gốc của Dashboard -->
            <link rel="stylesheet" href="${url}/resources/css/admin/dashboard.css">
            <link rel="stylesheet" href="${url}/resources/css/seller/product-form.css">
            <link rel="stylesheet"
                href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/font-awesome.min.css">
            <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
                rel="stylesheet">
        </head>

        <body>

            <!-- 1. Include Sidebar -->
            <jsp:include page="../layout/sidebar.jsp" />

            <!-- 2. Main Content Area -->
            <div class="content-wrapper">
                <div class="header-content mb-4">
                    <h2 style="font-weight: 700; color: #1e293b;">Quản lý Sản phẩm</h2>
                </div>

                <form action="${url}/seller/product/create" method="POST" enctype="multipart/form-data">
                    <div class="grid-container">
                        <!-- Cột trái: Thông tin nội dung -->
                        <div class="form-card">
                            <h3 class="section-title">Thông tin chung</h3>

                            <div class="form-group">
                                <label for="name">Tên sản phẩm *</label>
                                <input type="text" id="name" name="name" class="form-control"
                                    placeholder="Nhập tên sản phẩm..." required onkeyup="syncData()">
                            </div>

                            <input type="hidden" id="slug" name="slug">

                            <div class="form-group">
                                <label for="category">Danh mục sản phẩm</label>
                                <select id="category" name="category_id" class="form-control" onchange="syncData()">
                                    <option value="">-- Chọn danh mục --</option>
                                    <c:forEach var="cat" items="${categories}">
                                        <option value="${cat.id}" data-prefix="${cat.code}">${cat.name}</option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="form-group">
                                <label for="description">Mô tả sản phẩm</label>
                                <textarea id="description" name="description" class="form-control" rows="10"
                                    placeholder="Viết mô tả chi tiết tại đây..."></textarea>
                            </div>

                            <!-- Bảng biến thể động -->
                            <div class="variant-section">
                                <h3 class="section-title">Các biến thể sản phẩm</h3>
                                <p style="font-size: 13px; color: #64748b; margin-top: -10px;">Nhập giá, kho và SKU cho
                                    từng loại (Màu, Size...)</p>

                                <div class="variant-table-container">
                                    <table class="variant-table">
                                        <thead>
                                            <tr>
                                                <th style="width: 30%;">Tên biến thể</th>
                                                <th style="width: 20%;">Giá tiền</th>
                                                <th style="width: 15%;">Số lượng</th>
                                                <th style="width: 5%;"></th>
                                            </tr>
                                        </thead>
                                        <tbody id="variant-body">
                                            <!-- Dòng mặc định -->
                                            <tr class="variant-row">
                                                <td><input type="text" name="variant_names[]" class="var-name"
                                                        placeholder="VD: Đen - 128GB" onkeyup="syncData()"></td>
                                                <td><input type="number" name="variant_prices[]" placeholder="0"></td>
                                                <td><input type="number" name="variant_stocks[]" placeholder="0"></td>
                                                <input type="hidden" name="variant_skus[]" class="var-sku">
                                                <td><i class="fas fa-trash-alt btn-remove-row"
                                                        onclick="removeRow(this)"></i></td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                                <button type="button" class="btn-add-variant" onclick="addVariantRow()">
                                    <i class="fas fa-plus me-2"></i> Thêm biến thể khác
                                </button>
                            </div>
                        </div>

                        <!-- Cột phải: Hình ảnh & Lưu -->
                        <div class="form-sidebar">
                            <div class="form-card">
                                <h3 class="section-title">Hình ảnh sản phẩm</h3>
                                <div class="image-preview-zone">
                                    <i class="fas fa-images fa-3x"></i>
                                    <p style="margin-top: 10px;">Click để tải ảnh sản phẩm</p>
                                    <input type="file" name="images" multiple style="display: none;" id="imageInput">
                                </div>

                                <button type="submit" class="btn-save">
                                    <i class="fas fa-save me-2"></i> Lưu sản phẩm
                                </button>

                                <p style="font-size: 12px; color: #94a3b8; margin-top: 15px; text-align: center;">
                                    <i class="fas fa-info-circle"></i> Sản phẩm và các biến thể sẽ được lưu cùng lúc.
                                </p>
                            </div>
                        </div>
                    </div>
                </form>
            </div>

            <!-- Script xử lý Logic -->
            <script>
                // 1. Hàm chính đồng bộ tất cả dữ liệu (Slug & SKUs)
                function syncData() {
                    generateSlug();
                    updateAllSKUs();
                }

                // 2. Tự động tạo Slug
                function generateSlug() {
                    const name = document.getElementById('name').value;
                    let slug = name.toLowerCase();
                    slug = slug.normalize('NFD').replace(/[\u0300-\u036f]/g, '').replace(/[đĐ]/g, 'd');
                    slug = slug.replace(/([^0-9a-z-\s])/g, '').replace(/(\s+)/g, '-').replace(/^-+|-+$/g, '');
                    document.getElementById('slug').value = slug;
                }

                // 3. Tự động sinh mã SKU cho từng dòng
                function updateAllSKUs() {
                    const categoryElement = document.getElementById('category');
                    const categoryPrefix = categoryElement.options[categoryElement.selectedIndex]?.dataset?.prefix || "SP";

                    // Lấy mã sản phẩm (lấy 5 ký tự đầu của slug)
                    let prodCode = document.getElementById('slug').value.substring(0, 5).toUpperCase();
                    if (!prodCode) prodCode = "NEW";

                    const rows = document.querySelectorAll('.variant-row');
                    rows.forEach(row => {
                        const varNameInput = row.querySelector('.var-name');
                        const varSkuInput = row.querySelector('.var-sku');

                        if (!varNameInput || !varSkuInput) return;

                        // Chuẩn hóa tên biến thể (không dấu, gạch ngang)
                        let varSuffix = varNameInput.value.toLowerCase()
                            .normalize('NFD').replace(/[\u0300-\u036f]/g, '').replace(/[đĐ]/g, 'd')
                            .replace(/([^0-9a-z\s])/g, '').replace(/(\s+)/g, '-').toUpperCase();

                        if (varSuffix) {
                            varSkuInput.value = categoryPrefix + "-" + prodCode + "-" + varSuffix;
                        } else {
                            varSkuInput.value = categoryPrefix + "-" + prodCode;
                        }
                    });
                }

                // 4. Quản lý bảng biến thể
                function addVariantRow() {
                    const body = document.getElementById('variant-body');
                    const newRow = document.createElement('tr');
                    newRow.className = 'variant-row';
                    newRow.innerHTML = `
                        <td><input type="text" name="variant_names[]" class="var-name" placeholder="VD: Trắng - M" onkeyup="syncData()"></td>
                        <td><input type="number" name="variant_prices[]" placeholder="0"></td>
                        <td><input type="number" name="variant_stocks[]" placeholder="0"></td>
                        <input type="hidden" name="variant_skus[]" class="var-sku">
                        <td><i class="fas fa-trash-alt btn-remove-row" onclick="removeRow(this)"></i></td>
                    `;
                    body.appendChild(newRow);
                    updateAllSKUs();
                }

                function removeRow(btn) {
                    const rows = document.querySelectorAll('.variant-row');
                    if (rows.length > 1) {
                        btn.closest('tr').remove();
                    } else {
                        alert("Sản phẩm phải có ít nhất một biến thể!");
                    }
                }

                // Kích hoạt click vào vùng upload
                document.querySelector('.image-preview-zone').addEventListener('click', () => {
                    document.getElementById('imageInput').click();
                });
            </script>
        </body>

        </html>