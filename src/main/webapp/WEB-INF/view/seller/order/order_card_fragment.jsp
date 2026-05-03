<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
    <%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
    <c:set var="url" value="${pageContext.request.contextPath}" />

            <c:set var="order" value="${currentOrder}" />
            <c:set var="formattedDate" value="${fn:replace(order.createdAt, 'T', ' ')}" />

            <c:set var="orderJson">{id:${order.id},code:'${order.orderCode}',status:'${order.status}',totalPrice:'<fmt:formatNumber value="${order.totalPrice}" type="currency" currencySymbol="₫" />',paymentMethod:'${order.paymentMethod}',customerName:'${order.account.profile.fullName.replace("'", "\\'")}',customerPhone:'${order.account.profile.phoneNumber}',customerEmail:'${order.account.email}',shippingAddress:'${order.shippingAddress.replace("'", "\\'")}',customerAvatar:'${not empty order.account.profile.avatarUrl ? url.concat(order.account.profile.avatarUrl) : "https://api.dicebear.com/7.x/avataaars/svg?seed=".concat(order.account.id)}',time:'${formattedDate}',items:[<c:forEach var="item" items="${order.orderDetails}" varStatus="i">{id:${item.id},name:'${item.product.name.replace("'", "\\'")}',image:'${url}${not empty item.productVariant.imageUrl ? item.productVariant.imageUrl : item.product.images[0].url}',variant:'${item.productVariant.sku}',quantity:${item.quantity},price:'<fmt:formatNumber value="${item.priceAtPurchase}" type="currency" currencySymbol="₫" />'}${!i.last ? ',' : ''}</c:forEach>]}</c:set>

            <div class="order-card group glass-card p-5 rounded-[24px] hover:shadow-2xl hover:bg-white/80 transition-all duration-300 cursor-pointer active:scale-[0.98] relative"
                :class="openMenu ? 'z-[100]' : 'z-0'"
                x-data="{ openMenu: false }"
                data-status="${order.status}" @click="openDetail(${orderJson})">
                <div class="flex items-center gap-6">
                    <!-- ID & Time -->
                    <div class="w-32 flex-shrink-0">
                        <div class="font-mono font-bold text-small-navy">#${order.orderCode}</div>
                        <div class="text-[10px] text-gray-400 mt-1 uppercase font-bold tracking-wider">
                            ${fn:substring(formattedDate, 11, 16)} - ${fn:substring(formattedDate, 8, 10)}/${fn:substring(formattedDate, 5, 7)}
                        </div>
                    </div>

                    <!-- Customer -->
                    <div class="flex items-center gap-3 w-48 flex-shrink-0">
                        <c:choose>
                            <c:when test="${not empty order.account.profile.avatarUrl}">
                                <img src="${url}${order.account.profile.avatarUrl}"
                                    class="w-11 h-11 rounded-full border-2 border-white shadow-sm object-cover bg-emerald-50">
                            </c:when>
                            <c:otherwise>
                                <img src="https://api.dicebear.com/7.x/avataaars/svg?seed=${order.account.id}"
                                    class="w-11 h-11 rounded-full border-2 border-white shadow-sm bg-emerald-50">
                            </c:otherwise>
                        </c:choose>
                        <div class="min-w-0">
                            <div class="font-bold text-sm text-small-navy truncate">
                                ${order.account.profile.fullName}</div>
                            <div class="text-[10px] text-gray-400 font-medium uppercase tracking-tight">Customer
                            </div>
                        </div>
                    </div>

                    <!-- Products Preview -->
                    <div class="flex items-center gap-3 w-40 flex-shrink-0">
                        <div class="flex -space-x-3">
                            <c:forEach var="item" items="${order.orderDetails}" varStatus="loop">
                                <c:if test="${loop.index < 2}">
                                    <c:choose>
                                        <c:when test="${not empty item.productVariant.imageUrl}">
                                            <c:set var="imgUrl" value="${item.productVariant.imageUrl}" />
                                        </c:when>
                                        <c:otherwise>
                                            <c:set var="imgUrl" value="${item.product.images[0].url}" />
                                        </c:otherwise>
                                    </c:choose>
                                    <img src="${url}${imgUrl}"
                                        class="w-10 h-10 rounded-xl border-2 border-white shadow-sm object-cover bg-white">
                                    <c:set var="firstItemName" value="${item.product.name}" />
                                </c:if>
                            </c:forEach>
                        </div>
                        <c:if test="${order.orderDetails.size() > 2}">
                            <div class="text-[10px] text-gray-400 font-bold tracking-tight">
                                +${order.orderDetails.size() - 2} items</div>
                        </c:if>
                    </div>

                    <!-- Total & Payment -->
                    <div class="flex items-center gap-3 w-44 flex-shrink-0">
                        <div class="font-bold text-small-navy">
                            <fmt:formatNumber value="${order.totalPrice}" type="currency" currencySymbol="₫" />
                        </div>
                        <div class="p-1.5 bg-gray-50 rounded-lg text-gray-400">
                            <c:choose>
                                <c:when test="${order.paymentMethod == 'COD'}"><i
                                        class="fas fa-box text-xs"></i></c:when>
                                <c:when test="${order.paymentMethod == 'QR'}"><i
                                        class="fas fa-qrcode text-xs"></i></c:when>
                                <c:otherwise><i class="fas fa-credit-card text-xs"></i></c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- Status Badge -->
                    <div class="flex-1 flex items-center gap-2">
                        <c:set var="statusClass" value="" />
                        <c:choose>
                            <c:when test="${order.status == 'PENDING'}">
                                <c:set var="statusClass"
                                    value="bg-amber-50 text-amber-600 border-amber-100/50" />
                            </c:when>
                            <c:when test="${order.status == 'CONFIRMED'}">
                                <c:set var="statusClass" value="bg-blue-50 text-blue-600 border-blue-100/50" />
                            </c:when>
                            <c:when test="${order.status == 'SHIPPING' || order.status == 'READY_FOR_PICKUP'}">
                                <c:set var="statusClass"
                                    value="bg-indigo-50 text-indigo-600 border-indigo-100/50" />
                            </c:when>
                            <c:when test="${order.status == 'DELIVERED'}">
                                <c:set var="statusClass"
                                    value="bg-emerald-50 text-emerald-600 border-emerald-100/50" />
                            </c:when>
                            <c:otherwise>
                                <c:set var="statusClass" value="bg-red-50 text-red-600 border-red-100/50" />
                            </c:otherwise>
                        </c:choose>
                        <span
                            class="px-4 py-1.5 rounded-full text-[10px] font-bold uppercase tracking-[0.1em] border ${statusClass}">
                            ${order.status == 'READY_FOR_PICKUP' ? 'ĐANG GIAO HÀNG' : order.status.displayName}
                        </span>
                    </div>

                    <!-- Quick Actions -->
                    <div class="flex items-center gap-3 flex-shrink-0">
                        <c:choose>
                            <c:when test="${order.status == 'PENDING'}">
                                <button
                                    onclick="event.stopPropagation(); updateStatus(${order.id}, 'CONFIRMED')"
                                    class="px-5 py-2.5 bg-small-emerald text-white text-xs font-bold rounded-xl hover:bg-emerald-900 transition-all opacity-0 group-hover:opacity-100 shadow-lg shadow-emerald-900/20">
                                    Xác nhận ngay
                                </button>
                            </c:when>
                            <c:when test="${order.status == 'CONFIRMED'}">
                                <button onclick="event.stopPropagation(); updateStatus(${order.id}, 'SHIPPING')"
                                    class="px-5 py-2.5 bg-indigo-600 text-white text-xs font-bold rounded-xl hover:bg-indigo-800 transition-all opacity-0 group-hover:opacity-100 shadow-lg shadow-indigo-900/20">
                                    Giao cho ĐVVC
                                </button>
                            </c:when>
                            <c:when test="${order.status == 'SHIPPING'}">
                                <sec:authorize access="hasRole('ROLE_SHIPPER')">
                                    <button
                                        onclick="event.stopPropagation(); updateStatus(${order.id}, 'DELIVERED')"
                                        class="px-5 py-2.5 bg-emerald-600 text-white text-xs font-bold rounded-xl hover:bg-emerald-800 transition-all opacity-0 group-hover:opacity-100 shadow-lg shadow-emerald-900/20">
                                        Đã giao hàng
                                    </button>
                                </sec:authorize>
                            </c:when>
                        </c:choose>

                        <div class="relative">
                            <button @click="event.stopPropagation(); openMenu = !openMenu"
                                @click.away="openMenu = false"
                                class="w-10 h-10 flex items-center justify-center rounded-xl bg-white border border-gray-100 text-gray-400 hover:bg-gray-50 transition-all">
                                <i class="fas fa-ellipsis-v text-xs"></i>
                            </button>
                            <div x-show="openMenu" x-cloak
                                class="absolute right-0 top-full mt-2 w-48 rounded-2xl bg-white border border-gray-100 shadow-2xl z-50 overflow-hidden">
                                <div class="py-2 text-sm">
                                    <a href="${url}/order/passport/${order.orderCode}"
                                        class="flex items-center gap-3 px-4 py-3 text-gray-600 hover:bg-emerald-50 hover:text-emerald-700 transition-all">
                                        <i class="fas fa-id-card w-5"></i> Mở Hộ chiếu đơn hàng
                                    </a>
                                    <c:if test="${order.status == 'PENDING'}">
                                        <button
                                            onclick="event.stopPropagation(); updateStatus(${order.id}, 'CANCELLED')"
                                            class="w-full flex items-center gap-3 px-4 py-3 text-red-500 hover:bg-red-50 transition-all">
                                            <i class="fas fa-times w-5"></i> Hủy đơn hàng
                                        </button>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>