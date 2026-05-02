<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>S-Mall Order Passport | #${order.orderCode}</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <script src="https://unpkg.com/alpinejs@3.x.x/dist/cdn.min.js" defer></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        body { font-family: 'Plus Jakarta Sans', sans-serif; }
        .glass { background: rgba(255, 255, 255, 0.7); backdrop-filter: blur(20px); border: 1px solid rgba(255, 255, 255, 0.3); }
        [x-cloak] { display: none !important; }
        .passport-pattern {
            background-image: radial-gradient(#065F46 0.5px, transparent 0.5px);
            background-size: 10px 10px;
            opacity: 0.05;
        }
    </style>
</head>
<body class="bg-[#F0FDF4] min-h-screen pb-20">
    <div class="fixed inset-0 passport-pattern -z-10"></div>

    <div class="max-w-md mx-auto px-6 py-8">
        <!-- Header Passport -->
        <div class="text-center mb-10">
            <div class="inline-flex items-center gap-2 px-4 py-1.5 bg-emerald-900 text-white rounded-full text-[10px] font-extrabold uppercase tracking-[0.2em] mb-4 shadow-lg shadow-emerald-900/20">
                <i class="fas fa-shield-halved"></i> Official Order Passport
            </div>
            <h1 class="text-2xl font-extrabold text-[#064E3B]">S-Mall System</h1>
            <p class="text-emerald-600/60 text-xs font-semibold mt-1">Verified Digital Shipment Identity</p>
        </div>

        <!-- Main Ticket Card -->
        <div class="glass rounded-[40px] shadow-2xl overflow-hidden relative border-t-4 border-emerald-600">
            <!-- Order ID Section -->
            <div class="p-8 text-center border-b border-dashed border-emerald-100">
                <div class="text-[10px] text-gray-400 font-bold uppercase tracking-widest mb-1">Passport ID</div>
                <div class="text-3xl font-black text-[#064E3B] tracking-tight">#${order.orderCode}</div>
                
                <div class="mt-4 flex items-center justify-center gap-2">
                    <c:set var="statusColor" value="" />
                    <c:choose>
                        <c:when test="${order.status == 'PENDING'}"><c:set var="statusColor" value="bg-amber-100 text-amber-700" /></c:when>
                        <c:when test="${order.status == 'CONFIRMED'}"><c:set var="statusColor" value="bg-blue-100 text-blue-700" /></c:when>
                        <c:when test="${order.status == 'SHIPPING'}"><c:set var="statusColor" value="bg-indigo-100 text-indigo-700" /></c:when>
                        <c:when test="${order.status == 'DELIVERED'}"><c:set var="statusColor" value="bg-emerald-100 text-emerald-700" /></c:when>
                        <c:otherwise><c:set var="statusColor" value="bg-red-100 text-red-700" /></c:otherwise>
                    </c:choose>
                    <span class="px-4 py-1.5 rounded-full text-[10px] font-black uppercase tracking-widest ${statusColor}">
                        ${order.status.displayName}
                    </span>
                </div>
            </div>

            <!-- Content Details -->
            <div class="p-8 space-y-6">
                <!-- Role Recognition Message -->
                <div class="p-4 bg-emerald-50 rounded-2xl border border-emerald-100 text-center">
                    <div class="text-[10px] text-emerald-800 font-bold uppercase tracking-wider mb-1">Identity Recognized</div>
                    <div class="text-sm font-bold text-emerald-900">
                        <c:choose>
                            <c:when test="${role == 'SELLER'}"><i class="fas fa-store mr-2"></i> Hello, Seller!</c:when>
                            <c:when test="${role == 'SHIPPER'}"><i class="fas fa-truck-fast mr-2"></i> Hello, Shipper!</c:when>
                            <c:when test="${role == 'BUYER'}"><i class="fas fa-user-check mr-2"></i> Hello, Customer!</c:when>
                            <c:otherwise><i class="fas fa-globe mr-2"></i> Public Tracking View</c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- Info Grid -->
                <div class="grid grid-cols-2 gap-6">
                    <div>
                        <div class="text-[10px] text-gray-400 font-bold uppercase tracking-widest mb-1">Placed On</div>
                        <div class="text-sm font-bold text-[#064E3B]">
                             <fmt:parseDate value="${order.createdAt.toString()}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both" />
                             <fmt:formatDate value="${parsedDate}" pattern="HH:mm - dd/MM" />
                        </div>
                    </div>
                    <div class="text-right">
                        <div class="text-[10px] text-gray-400 font-bold uppercase tracking-widest mb-1">Total Amount</div>
                        <div class="text-sm font-bold text-emerald-600">
                             <fmt:formatNumber value="${order.totalPrice}" type="currency" currencySymbol="₫"/>
                        </div>
                    </div>
                </div>

                <!-- Shipping To -->
                <div class="pt-6 border-t border-emerald-50">
                    <div class="text-[10px] text-gray-400 font-bold uppercase tracking-widest mb-3">Shipping Passport Address</div>
                    <div class="flex gap-4">
                        <div class="w-12 h-12 rounded-2xl bg-white shadow-sm border border-emerald-50 flex items-center justify-center text-emerald-600">
                            <i class="fas fa-map-location-dot text-lg"></i>
                        </div>
                        <div class="flex-1">
                            <div class="font-bold text-sm text-[#064E3B]">${order.account.profile.fullName}</div>
                            <div class="text-xs text-emerald-600/70 font-medium">${order.account.profile.phoneNumber}</div>
                            <div class="text-[11px] text-gray-500 mt-1 leading-relaxed">${order.shippingAddress}</div>
                        </div>
                    </div>
                </div>

                <!-- Product Snapshot -->
                <div class="pt-6 border-t border-emerald-50">
                    <div class="text-[10px] text-gray-400 font-bold uppercase tracking-widest mb-4">Package Content</div>
                    <div class="space-y-3">
                        <c:forEach var="item" items="${order.orderDetails}" varStatus="loop">
                            <c:if test="${loop.index < 3}">
                                <div class="flex items-center gap-4">
                                    <img src="${pageContext.request.contextPath}${not empty item.productVariant.imageUrl ? item.productVariant.imageUrl : item.product.images[0].url}" 
                                         class="w-10 h-10 rounded-xl object-cover bg-white border border-emerald-50 shadow-sm">
                                    <div class="flex-1 min-w-0">
                                        <div class="text-xs font-bold text-[#064E3B] truncate">${item.product.name}</div>
                                        <div class="text-[9px] text-gray-400">Qty: ${item.quantity} | SKU: ${item.productVariant.sku}</div>
                                    </div>
                                </div>
                            </c:if>
                        </c:forEach>
                        <c:if test="${order.orderDetails.size() > 3}">
                            <div class="text-[9px] text-center text-emerald-600 font-bold uppercase tracking-widest pt-2">
                                + ${order.orderDetails.size() - 3} other items in package
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>

            <!-- Footer Action Area -->
            <div class="p-8 bg-emerald-50/50 border-t border-emerald-100">
                <c:choose>
                    <c:when test="${role == 'SELLER' && order.status == 'PENDING'}">
                        <button onclick="updateStatus('CONFIRMED')" class="w-full py-4 bg-emerald-900 text-white rounded-2xl font-black text-xs uppercase tracking-[0.2em] shadow-xl shadow-emerald-900/30 active:scale-95 transition-all">
                            Confirm Package Ready
                        </button>
                    </c:when>
                    <c:when test="${role == 'SHIPPER' && order.status == 'CONFIRMED'}">
                        <button onclick="updateStatus('SHIPPING')" class="w-full py-4 bg-indigo-600 text-white rounded-2xl font-black text-xs uppercase tracking-[0.2em] shadow-xl shadow-indigo-900/30 active:scale-95 transition-all">
                            Pickup Package Now
                        </button>
                    </c:when>
                    <c:when test="${role == 'SHIPPER' && order.status == 'SHIPPING'}">
                        <button onclick="updateStatus('DELIVERED')" class="w-full py-4 bg-emerald-600 text-white rounded-2xl font-black text-xs uppercase tracking-[0.2em] shadow-xl shadow-emerald-900/30 active:scale-95 transition-all">
                            Delivered to Buyer
                        </button>
                    </c:when>
                    <c:when test="${role == 'BUYER' && order.status == 'SHIPPING'}">
                        <button onclick="updateStatus('DELIVERED')" class="w-full py-4 bg-emerald-600 text-white rounded-2xl font-black text-xs uppercase tracking-[0.2em] shadow-xl shadow-emerald-900/30 active:scale-95 transition-all">
                            I Received the Package
                        </button>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center">
                            <p class="text-xs font-bold text-emerald-600 uppercase tracking-widest mb-4">No Actions Required</p>
                            <a href="${pageContext.request.contextPath}/" class="text-[10px] text-emerald-800 underline font-bold">Return to Homepage</a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
        
        <!-- Safety Note -->
        <p class="mt-8 text-center text-[10px] text-emerald-600/40 font-bold uppercase tracking-widest px-8">
            This digital passport is protected by S-Mall Security. Any unauthorized action will be logged.
        </p>
    </div>

    <script>
        function updateStatus(status) {
            Swal.fire({
                title: 'Confirm Action?',
                text: "Update order status to: " + status,
                icon: 'question',
                showCancelButton: true,
                confirmButtonColor: '#065F46',
                cancelButtonColor: '#94A3B8',
                confirmButtonText: 'Yes, Proceed!',
                border: 'none',
                customClass: {
                    popup: 'rounded-[32px] border-none shadow-2xl',
                    confirmButton: 'rounded-xl px-6 py-3 font-bold',
                    cancelButton: 'rounded-xl px-6 py-3 font-bold'
                }
            }).then((result) => {
                if (result.isConfirmed) {
                    const params = new URLSearchParams();
                    params.append('orderId', '${order.id}');
                    params.append('status', status);

                    fetch('${pageContext.request.contextPath}/seller/order/update-status', {
                        method: 'POST',
                        body: params
                    })
                    .then(response => {
                        if(response.ok) {
                            Swal.fire({
                                title: 'Success!',
                                text: 'Order status updated.',
                                icon: 'success',
                                confirmButtonColor: '#065F46',
                                customClass: { popup: 'rounded-[32px]' }
                            }).then(() => window.location.reload());
                        } else {
                            Swal.fire('Error', 'Update failed!', 'error');
                        }
                    });
                }
            });
        }
    </script>
</body>
</html>
