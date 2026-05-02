<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="url" value="${pageContext.request.contextPath}" />

<c:forEach var="p" items="${products}">
    <div class="product-item group relative glass-card p-6 rounded-[24px] hover:shadow-2xl hover:shadow-emerald-900/5 transition-all duration-300 w-full mb-4">
        <div class="flex gap-6">
            <!-- Image with Hover Overlay -->
            <a href="${url}/product/${p.slug}" class="relative w-24 h-24 rounded-2xl overflow-hidden bg-gray-100 flex-shrink-0 border border-gray-200/50 group/img">
                <c:choose>
                    <c:when test="${not empty p.images}">
                        <img src="${url}${p.images[0].url}" class="w-full h-full object-cover transition-transform duration-500 group-hover/img:scale-110">
                    </c:when>
                    <c:otherwise>
                        <img src="https://via.placeholder.com/100" class="w-full h-full object-cover">
                    </c:otherwise>
                </c:choose>
                
                <!-- View Details Overlay -->
                <div class="absolute inset-0 bg-small-navy/60 opacity-0 group-hover/img:opacity-100 transition-opacity duration-300 flex flex-col items-center justify-center gap-1">
                    <i class="fas fa-eye text-white text-sm"></i>
                    <span class="text-[8px] text-white font-bold uppercase tracking-widest text-center px-2">Xem chi tiết</span>
                </div>
            </a>

            <!-- Content -->
            <div class="flex-1 min-w-0">
                <div class="flex items-start justify-between mb-4">
                    <div>
                        <h4 class="text-xl font-semibold text-small-navy mb-0.5">${p.name}</h4>
                        <div class="flex items-center gap-2">
                            <p class="text-xs text-gray-400 font-medium">${p.category.name}</p>
                            <span class="text-[10px] text-gray-300">•</span>
                            <p class="text-[10px] font-mono text-gray-400 tracking-wider">SKU: ${p.variants[0].sku}</p>
                        </div>
                    </div>
                    <div class="flex items-center gap-1.5 px-2.5 py-1.5 bg-emerald-50 rounded-full border border-emerald-100">
                        <i class="fas fa-globe text-[10px] text-emerald-600"></i>
                        <span class="text-xs font-bold text-emerald-600">95%</span>
                    </div>
                </div>

                <div class="grid grid-cols-2 sm:grid-cols-4 gap-8 mb-4">
                    <div>
                        <div class="text-[11px] text-gray-400 uppercase font-bold mb-1">Price</div>
                        <div class="text-sm font-bold text-small-navy">
                            <fmt:formatNumber value="${p.variants[0].price}" type="currency" currencySymbol="₫"/>
                        </div>
                    </div>
                    <div>
                        <div class="text-[11px] text-gray-400 uppercase font-bold mb-1">Stock</div>
                        <div class="text-sm font-bold text-small-navy">${p.variants[0].stock}</div>
                    </div>
                    <div>
                        <div class="text-[11px] text-gray-400 uppercase font-bold mb-1">Sold</div>
                        <div class="text-sm font-bold text-small-navy">${p.soldCount}</div>
                    </div>
                    <div>
                        <div class="text-[11px] text-gray-400 uppercase font-bold mb-1">Views</div>
                        <div class="text-sm font-bold text-small-navy">${p.viewCount}</div>
                    </div>
                </div>

                <div class="flex items-center justify-between">
                    <div class="flex items-center gap-2">
                        <span class="px-3 py-1 bg-emerald-50 text-emerald-700 rounded-full text-[9px] font-bold uppercase tracking-[0.1em] border border-emerald-100/50">
                            ${p.status}
                        </span>
                        <c:choose>
                            <c:when test="${p.variants[0].stock == 0}">
                                <span class="px-3 py-1 bg-slate-50 text-slate-400 rounded-full text-[9px] font-bold uppercase tracking-[0.1em] border border-slate-200">
                                    Hết hàng
                                </span>
                            </c:when>
                            <c:when test="${p.variants[0].stock < 10}">
                                <span class="px-3 py-1 bg-amber-50 text-amber-600 rounded-full text-[9px] font-bold uppercase tracking-[0.1em] border border-amber-100/50">
                                    Sắp hết hàng
                                </span>
                            </c:when>
                            <c:when test="${p.soldCount > 50}">
                                <span class="px-3 py-1 bg-emerald-700 text-white rounded-full text-[9px] font-bold uppercase tracking-[0.1em] shadow-sm">
                                    Bán chạy
                                </span>
                            </c:when>
                            <c:when test="${p.viewCount > 500 && p.soldCount < 10}">
                                <span class="px-3 py-1 bg-indigo-50 text-indigo-600 rounded-full text-[9px] font-bold uppercase tracking-[0.1em] border border-indigo-100/50">
                                    Xu hướng
                                </span>
                            </c:when>
                        </c:choose>
                    </div>

                    <!-- Direct Actions (High Visibility) -->
                    <div class="flex gap-3">
                        <a href="${url}/seller/product/edit/${p.id}" 
                           class="w-11 h-11 flex items-center justify-center rounded-2xl bg-emerald-50 text-emerald-600 hover:bg-emerald-600 hover:text-white transition-all duration-300 border border-emerald-100 shadow-sm hover:shadow-emerald-900/20 group/edit"
                           title="Chỉnh sửa sản phẩm">
                            <i class="fas fa-edit transition-transform group-hover/edit:scale-110"></i>
                        </a>
                        <button onclick="deleteProduct(${p.id})" 
                                class="w-11 h-11 flex items-center justify-center rounded-2xl bg-red-50 text-red-600 hover:bg-red-600 hover:text-white transition-all duration-300 border border-red-100 shadow-sm hover:shadow-red-900/20 group/del"
                                title="Xóa sản phẩm">
                            <i class="fas fa-trash-alt transition-transform group-hover/del:scale-110"></i>
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</c:forEach>
