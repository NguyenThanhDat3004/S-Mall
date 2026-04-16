<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
            <c:set var="url" value="${pageContext.request.contextPath}" />

            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>S-Mall | Thêm Sản Phẩm Mới</title>

                <!-- Link CSS -->
                <link rel="stylesheet" href="${url}/resources/css/admin/dashboard.css">
                <link rel="stylesheet" href="${url}/resources/css/seller/product-form.css">
                <link rel="stylesheet"
                    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/font-awesome.min.css">
                <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
                    rel="stylesheet">
            </head>

            <body>
                <jsp:include page="../layout/sidebar.jsp" />

                <div class="content-wrapper">
                    <div class="header-content mb-4">
                        <h2 style="font-weight: 700; color: #1e293b;">Quản lý Sản phẩm</h2>
                    </div>

                    <!-- Hiển thị thông báo (Sạch bóng vạch đỏ) -->
                    <c:if test="${not empty message}">
                        <div
                            class="alert alert-custom ${messageType == 'success' ? 'alert-success-custom' : 'alert-danger-custom'}">
                            <i
                                class="fas ${messageType == 'success' ? 'fa-check-circle' : 'fa-exclamation-circle'} me-2"></i>
                            ${message}
                        </div>
                    </c:if>

                    <!-- Sử dụng form:form của Spring để binding dữ liệu -->
                    <form:form action="${url}/seller/product/create" method="POST" modelAttribute="productDTO"
                        enctype="multipart/form-data">
                        <div class="grid-container">
                            <div class="form-card">
                                <h3 class="section-title">Thông tin chung</h3>

                                <div class="form-group">
                                    <label for="name">Tên sản phẩm *</label>
                                    <form:input path="name" id="name" class="form-control"
                                        placeholder="Nhập tên sản phẩm..." onkeyup="syncData()" />
                                    <form:errors path="name" cssClass="text-danger" style="font-size: 13px;" />
                                </div>

                                <form:hidden path="slug" id="slug" />

                                <div class="form-group">
                                    <label for="category">Danh mục sản phẩm</label>
                                    <form:select path="categoryId" id="category" class="form-control"
                                        onchange="syncData()">
                                        <form:option value="" label="-- Chọn danh mục --" />
                                        <c:forEach var="cat" items="${categories}">
                                            <option value="${cat.id}" data-prefix="${cat.code}">${cat.name}</option>
                                        </c:forEach>
                                    </form:select>
                                    <form:errors path="categoryId" cssClass="text-danger" style="font-size: 13px;" />
                                </div>

                                <div class="form-group">
                                    <label for="description">Mô tả sản phẩm</label>
                                    <form:textarea path="description" id="description" class="form-control" rows="10"
                                        placeholder="Viết mô tả chi tiết tại đây..." />
                                </div>

                                <!-- Bảng biến thể động với Spring Data Binding -->
                                <div class="variant-section">
                                    <h3 class="section-title">Các biến thể sản phẩm</h3>
                                    <p style="font-size: 13px; color: #64748b; margin-top: -10px;">Nhập giá, kho cho
                                        từng loại</p>

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
                                                <c:forEach var="variant" items="${productDTO.variants}"
                                                    varStatus="status">
                                                    <tr class="variant-row">
                                                        <td>
                                                            <form:input path="variants[${status.index}].name"
                                                                class="var-name var-input" placeholder="VD: Đen - XL"
                                                                onkeyup="syncData()" />
                                                        </td>
                                                        <td>
                                                            <form:input path="variants[${status.index}].price"
                                                                type="number" class="var-input" placeholder="0" />
                                                        </td>
                                                        <td>
                                                            <form:input path="variants[${status.index}].stock"
                                                                type="number" class="var-input" placeholder="0" />
                                                        </td>
                                                        <form:hidden path="variants[${status.index}].sku"
                                                            class="var-sku" />
                                                        <td>
                                                            <i class="fas fa-trash-alt btn-remove-row"
                                                                onclick="removeRow(this)"></i>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                    <button type="button" class="btn-add-variant" onclick="addVariantRow()">
                                        <i class="fas fa-plus me-2"></i> Thêm biến thể khác
                                    </button>
                                </div>
                            </div>

                            <div class="form-sidebar">
                                <div class="form-card">
                                    <h3 class="section-title">Hình ảnh sản phẩm</h3>
                                    <div class="image-preview-zone" id="main-image-zone">
                                        <i class="fas fa-images fa-3x"></i>
                                        <p style="margin-top: 10px;">Ảnh chính sản phẩm</p>
                                        <input type="file" name="images" multiple style="display: none;"
                                            id="imageInput">
                                        <div id="main-preview-container" class="mt-2 d-flex flex-wrap gap-2"></div>
                                    </div>

                                    <!-- Vùng chứa ảnh cho từng biến thể -->
                                    <div id="variant-images-container" class="mt-4">
                                        <!-- Các form chọn ảnh biến thể sẽ tự sinh ra ở đây -->
                                    </div>

                                    <div id="validation-msg"
                                        style="color: #ef4444; font-size: 13px; margin-top: 10px; display: none;">
                                        <i class="fas fa-exclamation-triangle me-1"></i> Vui lòng nhập đầy đủ Tên, Giá
                                        và Kho của biến thể hiện tại!
                                    </div>

                                    <button type="submit" class="btn-save">
                                        <i class="fas fa-save me-2"></i> Lưu sản phẩm
                                    </button>
                                </div>
                            </div>
                        </div>
                    </form:form>
                </div>

                <script>
                    function syncData() {
                        generateSlug();
                        updateAllSKUs();
                    }

                    function generateSlug() {
                        const name = document.getElementById('name').value;
                        let slug = name.toLowerCase();
                        slug = slug.normalize('NFD').replace(/[\u0300-\u036f]/g, '').replace(/[đĐ]/g, 'd');
                        slug = slug.replace(/([^0-9a-z-\s])/g, '').replace(/(\s+)/g, '-').replace(/^-+|-+$/g, '');
                        document.getElementById('slug').value = slug;
                    }

                    function updateAllSKUs() {
                        const categoryElement = document.getElementById('category');
                        const categoryPrefix = categoryElement.options[categoryElement.selectedIndex]?.dataset?.prefix || "SP";
                        let prodCode = document.getElementById('slug').value.substring(0, 5).toUpperCase() || "NEW";

                        const rows = document.querySelectorAll('.variant-row');
                        rows.forEach(row => {
                            const varNameInput = row.querySelector('.var-name');
                            const varSkuInput = row.querySelector('.var-sku');
                            if (!varNameInput || !varSkuInput) return;

                            let varSuffix = varNameInput.value.toLowerCase()
                                .normalize('NFD').replace(/[\u0300-\u036f]/g, '').replace(/[đĐ]/g, 'd')
                                .replace(/([^0-9a-z\s])/g, '').replace(/(\s+)/g, '-').toUpperCase();

                            varSkuInput.value = varSuffix ? (categoryPrefix + "-" + prodCode + "-" + varSuffix) : (categoryPrefix + "-" + prodCode);
                        });
                    }

                    function addVariantRow() {
                        const rows = document.querySelectorAll('.variant-row');
                        const msg = document.getElementById('validation-msg');

                        // Kiểm tra dòng cuối cùng trước khi thêm dòng mới
                        if (rows.length > 0) {
                            const lastRow = rows[rows.length - 1];
                            const name = lastRow.querySelector('input[name*=".name"]').value;
                            const price = lastRow.querySelector('input[name*=".price"]').value;
                            const stock = lastRow.querySelector('input[name*=".stock"]').value;

                            if (!name || !price || !stock) {
                                msg.style.display = 'block';
                                return;
                            }
                        }

                        msg.style.display = 'none';
                        const index = rows.length;

                        // 1. Thêm dòng vào bảng
                        const body = document.getElementById('variant-body');
                        const newRow = document.createElement('tr');
                        newRow.className = 'variant-row';
                        newRow.setAttribute('data-index', index);
                        newRow.innerHTML = `
                            <td><input name="variants[${index}].name" class="var-name var-input" placeholder="VD: Trắng - M" onkeyup="syncData()"></td>
                            <td><input name="variants[${index}].price" type="number" class="var-input" placeholder="0"></td>
                            <td><input name="variants[${index}].stock" type="number" class="var-input" placeholder="0"></td>
                            <input type="hidden" name="variants[${index}].sku" class="var-sku">
                            <td><i class="fas fa-trash-alt btn-remove-row" onclick="removeRow(${index})"></i></td>
                        `;
                        body.appendChild(newRow);

                        // 2. Thêm form ảnh vào Sidebar (đúng thứ tự)
                        const sideContainer = document.getElementById('variant-images-container');
                        const newImgForm = document.createElement('div');
                        newImgForm.className = 'variant-image-item mb-3';
                        newImgForm.setAttribute('data-index', index);
                        newImgForm.innerHTML = `
                            <label class="form-label d-block mb-1" style="font-size: 13px; font-weight: 600; color: #475569;">
                                Hình ảnh biến thể ${index + 1}
                            </label>
                            <div class="image-preview-zone p-2" onclick="document.getElementById('img-input-${index}').click()" style="min-height: 80px;">
                                <i class="fas fa-camera fa-lg opacity-50"></i>
                                <p class="mb-0 mt-1" style="font-size: 11px;">Click để chọn ảnh</p>
                                <input type="file" name="variants[${index}].variantImage" id="img-input-${index}" 
                                       style="display: none;" onchange="previewVariantImage(this, ${index})">
                                <img id="preview-${index}" src="#" alt="Preview" style="display: none; max-width: 100%; height: 60px; object-fit: contain; margin-top: 5px;">
                            </div>
                        `;
                        sideContainer.appendChild(newImgForm);

                        updateAllSKUs();
                    }

                    function removeRow(idx) {
                        const rows = document.querySelectorAll('.variant-row');
                        if (rows.length > 1) {
                            // Xóa dòng trong bảng
                            document.querySelector(`.variant-row[data-index="${idx}"]`).remove();
                            // Xóa form ảnh trong sidebar
                            document.querySelector(`.variant-image-item[data-index="${idx}"]`).remove();
                            reIndexAll();
                        } else {
                            alert("Sản phẩm phải có ít nhất một biến thể!");
                        }
                    }

                    function reIndexAll() {
                        const rows = document.querySelectorAll('.variant-row');
                        const sideItems = document.querySelectorAll('.variant-image-item');

                        rows.forEach((row, index) => {
                            row.setAttribute('data-index', index);
                            row.querySelector('input[name*=".name"]').name = `variants[${index}].name`;
                            row.querySelector('input[name*=".price"]').name = `variants[${index}].price`;
                            row.querySelector('input[name*=".stock"]').name = `variants[${index}].stock`;
                            row.querySelector('input[name*=".sku"]').name = `variants[${index}].sku`;
                            row.querySelector('.btn-remove-row').setAttribute('onclick', `removeRow(${index})`);
                        });

                        sideItems.forEach((item, index) => {
                            item.setAttribute('data-index', index);
                            item.querySelector('label').innerText = `Hình ảnh biến thể ${index + 1}`;
                            const input = item.querySelector('input[type="file"]');
                            input.name = `variants[${index}].variantImage`;
                            input.id = `img-input-${index}`;
                            input.setAttribute('onchange', `previewVariantImage(this, ${index})`);
                            item.querySelector('.image-preview-zone').setAttribute('onclick', `document.getElementById('img-input-${index}').click()`);
                            const img = item.querySelector('img');
                            img.id = `preview-${index}`;
                        });
                    }

                    function previewVariantImage(input, index) {
                        const preview = document.getElementById(`preview-${index}`);
                        if (input.files && input.files[0]) {
                            const reader = new FileReader();
                            reader.onload = function (e) {
                                preview.src = e.target.result;
                                preview.style.display = 'block';
                                input.parentElement.querySelector('i').style.display = 'none';
                                input.parentElement.querySelector('p').style.display = 'none';
                            }
                            reader.readAsDataURL(input.files[0]);
                        }
                    }

                    document.getElementById('main-image-zone').addEventListener('click', (e) => {
                        if (e.target.id !== 'imageInput') {
                            document.getElementById('imageInput').click();
                        }
                    });

                    document.getElementById('imageInput').onchange = function () {
                        const container = document.getElementById('main-preview-container');
                        container.innerHTML = '';
                        if (this.files) {
                            Array.from(this.files).forEach(file => {
                                const reader = new FileReader();
                                reader.onload = function (e) {
                                    const img = document.createElement('img');
                                    img.src = e.target.result;
                                    img.style.width = '50px';
                                    img.style.height = '50px';
                                    img.style.objectFit = 'cover';
                                    img.style.borderRadius = '4px';
                                    container.appendChild(img);
                                }
                                reader.readAsDataURL(file);
                            });
                        }
                    };
                </script>
            </body>

            </html>