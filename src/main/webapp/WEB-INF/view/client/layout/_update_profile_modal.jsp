<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

        <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/client/profile_modal.css">

        <div class="modal fade" id="updateProfileModal" tabindex="-1" aria-labelledby="updateProfileModalLabel"
            aria-hidden="true" data-bs-backdrop="static">
            <div class="modal-dialog modal-dialog-centered modal-lg">
                <div class="modal-content"
                    style="border-radius: 12px; border: none; box-shadow: 0 10px 30px rgba(0,0,0,0.1); background: rgba(255, 255, 255, 0.95); backdrop-filter: blur(10px);">
                    <div class="modal-header" style="border-bottom: 1px solid #eee; border-radius: 12px 12px 0 0;">
                        <h5 class="modal-title" id="updateProfileModalLabel" style="font-weight: 600; color: #333;">
                            Cập nhật thông tin cá nhân
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body p-4">
                        <div class="alert" role="alert"
                            style="font-size: 0.9rem; background-color: rgba(26, 122, 66, 0.1); color: #1A7A42; border: 1px solid rgba(26, 122, 66, 0.2); border-radius: 8px; font-weight: 500;">
                            <i class="fas fa-exclamation-circle me-1"></i> Hệ thống yêu cầu bạn cung cấp đầy đủ TẤT CẢ
                            thông tin hồ sơ (bao gồm cả ảnh đại diện và ngày sinh) trước khi mua hàng.
                        </div>

                        <form id="updateProfileForm" enctype="multipart/form-data">
                            <div class="row">
                                <!-- Cột Trái -->
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="modalFullName" class="form-label"
                                            style="font-weight: 600; font-size: 0.9rem; color: #334155;">Họ và Tên <span
                                                class="text-danger">*</span></label>
                                        <input type="text" class="form-control profile-modal-input" id="modalFullName"
                                            name="fullName" required placeholder="Nhập họ và tên của bạn"
                                            value="${userProfile.fullName}"
                                            style="${not empty userProfile.fullName ? 'background-color: #f1f5f9; color: #475569;' : ''}">
                                    </div>

                                    <div class="mb-3">
                                        <label for="modalPhoneNumber" class="form-label"
                                            style="font-weight: 600; font-size: 0.9rem; color: #334155;">Số điện thoại
                                            <span class="text-danger">*</span></label>
                                        <input type="tel" class="form-control profile-modal-input" id="modalPhoneNumber"
                                            name="phoneNumber" required placeholder="Ví dụ: 0912345678"
                                            value="${userProfile.phoneNumber}"
                                            style="${not empty userProfile.phoneNumber ? 'background-color: #f1f5f9; color: #475569;' : ''}">
                                    </div>

                                    <div class="mb-3">
                                        <label class="form-label"
                                            style="font-weight: 600; font-size: 0.9rem; color: #334155;">Giới tính <span
                                                class="text-danger">*</span></label>
                                        <div class="gender-selector">
                                            <div class="gender-pill">
                                                <input type="radio" name="gender" id="genderMale" value="true"
                                                    ${userProfile.gender==true ? 'checked' : '' } required>
                                                <label for="genderMale">Nam</label>
                                            </div>
                                            <div class="gender-pill">
                                                <input type="radio" name="gender" id="genderFemale" value="false"
                                                    ${userProfile.gender==false ? 'checked' : '' } required>
                                                <label for="genderFemale">Nữ</label>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Cột Phải -->
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label class="form-label"
                                            style="font-weight: 600; font-size: 0.9rem; color: #334155;">Ngày sinh <span
                                                class="text-danger">*</span></label>
                                        <div class="row g-2">
                                            <div class="col-4">
                                                <select name="dob_day" class="form-select profile-modal-input" id="modalDobDaySelect" required
                                                    style="padding: 10px 12px; cursor: pointer;">
                                                    <option value="" disabled selected>Ngày</option>
                                                </select>
                                            </div>
                                            <div class="col-4">
                                                <select name="dob_month" class="form-select profile-modal-input" id="modalDobMonthSelect" required
                                                    style="padding: 10px 12px; cursor: pointer;">
                                                    <option value="" disabled selected>Tháng</option>
                                                </select>
                                            </div>
                                            <div class="col-4">
                                                <select name="dob_year" class="form-select profile-modal-input" id="modalDobYearSelect" required
                                                    style="padding: 10px 12px; cursor: pointer;">
                                                    <option value="" disabled selected>Năm</option>
                                                </select>
                                            </div>
                                        </div>
                                        <input type="hidden" name="dateOfBirth" id="modalDobValueHidden">
                                    </div>

                                    <div class="mb-3">
                                        <label for="modalAvatar" class="form-label"
                                            style="font-weight: 600; font-size: 0.9rem; color: #334155;">Ảnh đại diện
                                            (Avatar) <span class="text-danger">*</span></label>
                                        <c:if test="${not empty userProfile.avatarUrl}">
                                            <div class="mb-2 d-flex align-items-center">
                                                <img src="${pageContext.request.contextPath}${userProfile.avatarUrl}"
                                                    alt="Current Avatar"
                                                    style="width: 45px; height: 45px; border-radius: 50%; object-fit: cover; border: 2px solid #e2e8f0; box-shadow: 0 2px 5px rgba(0,0,0,0.05);">
                                                <span class="ms-3"
                                                    style="font-size: 0.85rem; color: #10b981; font-weight: 500;"><i
                                                        class="fas fa-check-circle me-1"></i>Đã có ảnh</span>
                                            </div>
                                        </c:if>
                                        <input type="file" class="form-control profile-modal-input" id="modalAvatar"
                                            name="avatarFile" accept="image/*"
                                            style="padding: 8px 12px; cursor: pointer;"
                                            ${empty userProfile.avatarUrl ? 'required' : '' }>
                                        <div id="avatarPreviewContainer" class="mt-3 d-none align-items-center">
                                            <div style="position: relative;">
                                                <img id="avatarPreview" src="#" alt="Preview"
                                                    style="width: 80px; height: 80px; border-radius: 50%; object-fit: cover; border: 3px solid #EE4D2D; padding: 3px;">
                                                <div
                                                    style="position: absolute; bottom: 0; right: 0; background: #EE4D2D; color: white; width: 24px; height: 24px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 12px; border: 2px solid white;">
                                                    <i class="fas fa-camera"></i>
                                                </div>
                                            </div>
                                            <div class="ms-3">
                                                <div style="font-size: 0.85rem; font-weight: 600; color: #EE4D2D;">Ảnh
                                                    bạn vừa chọn</div>
                                                <div style="font-size: 0.75rem; color: #64748b;">Sẵn sàng để tải lên
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="mb-4">
                                <label class="form-label" style="font-weight: 600; font-size: 0.9rem; color: #334155;">Địa
                                    chỉ nhận hàng chi tiết <span class="text-danger">*</span></label>
                                <div class="row g-2">
                                    <div class="col-md-12 mb-2">
                                        <input type="text" class="form-control profile-modal-input" id="modalStreet"
                                            placeholder="Số nhà, tên đường, thôn / xóm..." required
                                            style="padding: 12px; border-radius: 8px;">
                                    </div>
                                    <div class="col-md-6">
                                        <input type="text" class="form-control profile-modal-input" id="modalWard"
                                            placeholder="Xã / Phường" required
                                            style="padding: 12px; border-radius: 8px;">
                                    </div>
                                    <div class="col-md-6">
                                        <input type="text" class="form-control profile-modal-input" id="modalProvince"
                                            placeholder="Quận / Huyện / Tỉnh" required
                                            style="padding: 12px; border-radius: 8px;">
                                    </div>
                                </div>
                                <div class="form-text mt-2" style="font-size: 0.8rem; color: #10b981;"><i
                                        class="fas fa-info-circle me-1"></i> Chia nhỏ địa chỉ giúp Shipper giao hàng
                                    nhanh và chính xác hơn.</div>
                            </div>

                            <div class="d-grid gap-2">
                                <button type="submit" class="btn btn-primary" id="btnSaveProfile"
                                    style="background-color: #EE4D2D; border-color: #EE4D2D; font-weight: 500; padding: 12px;">
                                    <span class="spinner-border spinner-border-sm d-none" id="saveProfileSpinner"
                                        role="status" aria-hidden="true"></span>
                                    Lưu & Tiếp tục thanh toán
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <script>
            document.addEventListener('DOMContentLoaded', function () {
                const updateProfileForm = document.getElementById('updateProfileForm');

                // Xử lý Preview Ảnh
                const modalAvatarInput = document.getElementById('modalAvatar');
                const avatarPreviewContainer = document.getElementById('avatarPreviewContainer');
                const avatarPreview = document.getElementById('avatarPreview');

                if (modalAvatarInput) {
                    modalAvatarInput.addEventListener('change', function (event) {
                        const file = event.target.files[0];
                        if (file) {
                            const reader = new FileReader();
                            reader.onload = function (e) {
                                avatarPreview.src = e.target.result;
                                avatarPreviewContainer.classList.remove('d-none');
                                avatarPreviewContainer.classList.add('d-flex');
                            }
                            reader.readAsDataURL(file);
                        } else {
                            avatarPreviewContainer.classList.add('d-none');
                            avatarPreviewContainer.classList.remove('d-flex');
                        }
                    });
                }

                // Khởi tạo Select Ngày Sinh (Day / Month / Year)
                const dobDay = document.getElementById('modalDobDaySelect');
                const dobMonth = document.getElementById('modalDobMonthSelect');
                const dobYear = document.getElementById('modalDobYearSelect');
                const hiddenDob = document.getElementById('modalDobValueHidden');

                if (dobYear && dobMonth && dobDay) {
                    const currentYear = new Date().getFullYear();
                    // Đổ dữ liệu Năm (Từ hiện tại lùi về 1900)
                    for (let i = currentYear; i >= 1900; i--) {
                        dobYear.add(new Option(i, i));
                    }
                    // Đổ dữ liệu Tháng
                    for (let i = 1; i <= 12; i++) {
                        dobMonth.add(new Option(i, i.toString().padStart(2, '0')));
                    }

                    // Cập nhật số ngày tùy theo tháng và năm nhuận
                    function updateDays() {
                        const year = parseInt(dobYear.value) || currentYear;
                        const month = parseInt(dobMonth.value) || 1;
                        let daysInMonth = 31;

                        if (month === 2) {
                            daysInMonth = (year % 4 === 0 && (year % 100 !== 0 || year % 400 === 0)) ? 29 : 28;
                        } else if ([4, 6, 9, 11].includes(month)) {
                            daysInMonth = 30;
                        }

                        const currentDay = parseInt(dobDay.value);
                        dobDay.innerHTML = '<option value="" disabled selected>Ngày</option>';
                        for (let i = 1; i <= daysInMonth; i++) {
                            const opt = new Option(i, i.toString().padStart(2, '0'));
                            if (i === currentDay) opt.selected = true;
                            dobDay.add(opt);
                        }
                    }

                    dobYear.addEventListener('change', updateDays);
                    dobMonth.addEventListener('change', updateDays);
                    updateDays(); // Init lần đầu

                    // Nếu có dữ liệu cũ từ DB (YYYY-MM-DD), tự động fill vào select
                    if (hiddenDob && hiddenDob.value) {
                        const parts = hiddenDob.value.split('-');
                        if (parts.length === 3) {
                            dobYear.value = parts[0];
                            dobMonth.value = parts[1];
                            updateDays(); // Cập nhật lại list ngày cho khớp tháng/năm cũ
                            dobDay.value = parts[2];
                        }
                    }
                }

                if (updateProfileForm) {
                    updateProfileForm.addEventListener('submit', function (e) {
                        e.preventDefault();


                        const formData = new FormData(this);
                        
                        // Lấy trực tiếp từ element để loại bỏ mọi nghi ngờ về FormData
                        const dEl = this.querySelector('[name="dob_day"]');
                        const mEl = this.querySelector('[name="dob_month"]');
                        const yEl = this.querySelector('[name="dob_year"]');

                        const dVal = dEl ? dEl.value : "NULL_EL";
                        const mVal = mEl ? mEl.value : "NULL_EL";
                        const yVal = yEl ? yEl.value : "NULL_EL";



                        if (!dVal || dVal === "" || !mVal || mVal === "" || !yVal || yVal === "") {
                            alert("BẠN CHƯA CHỌN ĐỦ: Ngày=" + dVal + ", Tháng=" + mVal + ", Năm=" + yVal);
                            return;
                        }

                        const finalDob = yVal + "-" + mVal + "-" + dVal;
                        formData.set('dateOfBirth', finalDob);



                        // Gộp địa chỉ
                        const street = document.getElementById('modalStreet').value.trim();
                        const ward = document.getElementById('modalWard').value.trim();
                        const province = document.getElementById('modalProvince').value.trim();
                        const fullAddress = [street, ward, province].filter(Boolean).join(', ');
                        formData.set('address', fullAddress);

                        const btnSave = document.getElementById('btnSaveProfile');
                        const spinner = document.getElementById('saveProfileSpinner');
                        btnSave.disabled = true;
                        spinner.classList.remove('d-none');



                        fetch('${pageContext.request.contextPath}/api/profile/update-fast', {
                            method: 'POST',
                            body: formData // Không set Content-Type, fetch sẽ tự set là multipart/form-data với boundary
                        })
                            .then(response => response.json())
                            .then(result => {
                                if (result.success) {
                                    const modal = bootstrap.Modal.getInstance(document.getElementById('updateProfileModal'));
                                    if (modal) modal.hide();

                                    alert('Cập nhật thông tin thành công! Đang chuyển đến trang thanh toán...');
                                    if (window.location.href.includes('cart') || window.location.href.includes('payment')) {
                                        window.location.href = '${pageContext.request.contextPath}/payment';
                                    } else {
                                        location.reload();
                                    }
                                } else {
                                    alert('Lỗi: ' + (result.message || 'Không thể cập nhật thông tin.'));
                                    btnSave.disabled = false;
                                    spinner.classList.add('d-none');
                                }
                            })
                            .catch(error => {
                                console.error('Error:', error);
                                alert('Đã có lỗi xảy ra. Vui lòng thử lại.');
                                btnSave.disabled = false;
                                spinner.classList.add('d-none');
                            });
                    });
                }
            });
        </script>