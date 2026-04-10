<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <c:if test="${not empty message}">
            <div class="alert ${messageType == 'error' ? 'alert-danger' : 'alert-success'} alert-dismissible fade show mb-4"
                role="alert" style="font-size: 14px; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.05);">
                <div class="d-flex align-items-center">
                    <div class="me-3">
                        <c:choose>
                            <c:when test="${messageType == 'error'}">
                                <i class="bi bi-exclamation-triangle-fill fs-4 text-danger"></i>
                            </c:when>
                            <c:otherwise>
                                <i class="bi bi-check-circle-fill fs-4 text-success"></i>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div>
                        <span class="fw-bold">${message}</span>
                        <c:if test="${not empty lockExpirySeconds}">
                            <span id="countdown-wrapper">
                                Vui lòng thử lại sau <span id="countdown-clock" class="fw-bold text-danger">--:--</span>
                            </span>
                            <script>
                                (function () {
                                    let seconds = parseInt("${lockExpirySeconds}");
                                    const clock = document.getElementById('countdown-clock');
                                    const wrapper = document.getElementById('countdown-wrapper');

                                    function formatTime(s) {
                                        const m = Math.floor(s / 60);
                                        const rs = s % 60;
                                        return m + " phút " + rs + " giây";
                                    }

                                    function updateClock() {
                                        if (seconds <= 0) {
                                            wrapper.innerHTML = " <span class='text-success fw-bold'>- Bây giờ bạn có thể thử lại!</span>";
                                            return;
                                        }
                                        clock.innerText = formatTime(seconds);
                                        seconds--;
                                        setTimeout(updateClock, 1000);
                                    }

                                    if (!isNaN(seconds)) {
                                        updateClock();
                                    }
                                })();
                            </script>
                        </c:if>
                    </div>
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>