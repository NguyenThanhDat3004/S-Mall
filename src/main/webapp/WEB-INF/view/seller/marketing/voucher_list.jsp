<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="url" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>S-Mall | Quản lý Voucher</title>
    
    <!-- Tailwind & Alpine -->
    <script src="https://cdn.tailwindcss.com"></script>
    <script defer src="https://unpkg.com/alpinejs@3.x.x/dist/cdn.min.js"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        'small-emerald': '#065F46',
                        'small-navy': '#0F172A',
                        'small-platinum': '#E2E8F0',
                    }
                }
            }
        }
    </script>
    
    <style>
        body { font-family: 'Inter', sans-serif; }
        .glass-card {
            background: rgba(255, 255, 255, 0.7);
            backdrop-filter: blur(12px);
            border: 1px solid rgba(226, 232, 240, 0.5);
        }
    </style>
</head>
<body class="bg-slate-50 min-h-screen" x-data="{ showModal: false, showSuccessModal: ${not empty generatedCode ? 'true' : 'false'} }">

    <!-- Sidebar Inclusion -->
    <jsp:include page="/WEB-INF/view/seller/layout/sidebar.jsp" />

    <!-- Main Wrapper -->
    <div id="main-content" class="md:pl-64 flex flex-col min-h-screen transition-all duration-300 ease-in-out">
        
        <!-- Header -->
        <header class="sticky top-0 z-10 bg-white/80 backdrop-blur-xl border-b border-slate-200/60 px-8 py-6">
            <div class="flex items-center justify-between">
                <div class="flex items-center gap-4">
                    <button onclick="toggleSidebar()" class="w-10 h-10 bg-white shadow-sm border border-slate-100 rounded-xl flex items-center justify-center text-slate-400 hover:text-emerald-500 hover:border-emerald-100 transition-all">
                        <i class="fas fa-bars"></i>
                    </button>
                    <div>
                        <h1 class="text-2xl font-bold text-small-navy tracking-tight">Quản lý Voucher</h1>
                        <p class="text-sm text-slate-500">Tạo mã giảm giá công khai hoặc ưu đãi riêng tư.</p>
                    </div>
                </div>
                <button @click="showModal = true" 
                        class="bg-emerald-600 text-white px-6 py-3 rounded-2xl text-sm font-bold shadow-lg shadow-emerald-600/20 hover:bg-emerald-700 transition-all">
                    <i class="fas fa-plus mr-2"></i> Tạo Voucher mới
                </button>
            </div>
        </header>

        <main class="p-8 space-y-8">
            <c:if test="${not empty success}">
                <div class="bg-emerald-50 border border-emerald-100 text-emerald-600 px-6 py-4 rounded-2xl text-sm font-medium">
                    <i class="fas fa-check-circle mr-2"></i> ${success}
                </div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="bg-rose-50 border-l-4 border-rose-500 p-4 rounded-2xl shadow-sm animate-in fade-in slide-in-from-top duration-500 flex items-center gap-4">
                    <div class="w-10 h-10 bg-rose-500 rounded-xl flex items-center justify-center text-white shrink-0">
                        <i class="fas fa-exclamation-triangle"></i>
                    </div>
                    <div>
                        <h4 class="text-rose-800 font-bold text-sm">Cần kiểm tra lại</h4>
                        <p class="text-rose-600 text-xs">${error}</p>
                    </div>
                </div>
            </c:if>

            <!-- Voucher Grid -->
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                <c:forEach var="v" items="${vouchers}">
                    <div class="glass-card rounded-[32px] p-1 flex flex-col shadow-sm relative overflow-hidden group">
                        <!-- Decorative Circle -->
                        <div class="absolute -top-12 -right-12 w-32 h-32 bg-emerald-500/5 rounded-full group-hover:scale-150 transition-transform duration-700"></div>
                        
                        <div class="p-6 flex-1">
                            <div class="flex justify-between items-start mb-6">
                                <div class="w-12 h-12 bg-emerald-100 rounded-2xl flex items-center justify-center text-emerald-600">
                                    <i class="fas fa-ticket-alt text-xl"></i>
                                </div>
                                <div class="flex flex-col gap-2">
                                    <div class="flex items-center justify-between mb-4">
                                        <div class="flex items-center gap-2">
                                            <span class="px-2 py-1 ${v.publicVoucher ? 'bg-emerald-50 text-emerald-600' : 'bg-amber-50 text-amber-600'} rounded-lg text-[10px] font-bold uppercase tracking-wider border ${v.publicVoucher ? 'border-emerald-100' : 'border-amber-100'}">
                                                ${v.publicVoucher ? 'Công khai' : 'Cá nhân'}
                                            </span>
                                            
                                            <%-- Tính toán trạng thái --%>
                                            <c:set var="now" value="<%= java.time.LocalDateTime.now() %>" />
                                            <c:choose>
                                                <c:when test="${v.quantity <= 0}">
                                                    <span class="px-2 py-1 bg-rose-50 text-rose-600 rounded-lg text-[10px] font-bold uppercase tracking-wider border border-rose-100">
                                                        Hết lượt
                                                    </span>
                                                </c:when>
                                                <c:when test="${not empty v.expiryDate and v.expiryDate.isBefore(now)}">
                                                    <span class="px-2 py-1 bg-slate-100 text-slate-500 rounded-lg text-[10px] font-bold uppercase tracking-wider border border-slate-200">
                                                        Hết hạn
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="px-2 py-1 bg-emerald-500 text-white rounded-lg text-[10px] font-bold uppercase tracking-wider animate-pulse">
                                                        Đang chạy
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="text-right">
                                            <div class="text-xs text-slate-400">Giảm giá</div>
                                            <div class="text-lg font-bold text-emerald-600">
                                                <c:choose>
                                                    <c:when test="${v.discountType == 'PERCENTAGE'}">
                                                        <fmt:formatNumber value="${v.discountAmount}" pattern="#,###" />%
                                                    </c:when>
                                                    <c:otherwise>
                                                        <fmt:formatNumber value="${v.discountAmount}" type="currency" currencySymbol="₫" />
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="space-y-3 mb-6">
                                        <div class="flex items-center justify-between text-xs">
                                            <span class="text-slate-500">Mã: <span class="font-mono font-bold text-slate-700">${v.code}</span></span>
                                            <span class="text-slate-500">Đơn tối thiểu: <b><fmt:formatNumber value="${v.minOrderValue}" type="currency" currencySymbol="₫" /></b></span>
                                        </div>
                                        
                                        <div class="space-y-1">
                                            <div class="flex justify-between text-[10px] font-bold text-slate-500">
                                                <span>TIẾN ĐỘ SỬ DỤNG</span>
                                                <span>${v.initialQuantity > 0 ? (v.initialQuantity - v.quantity) : 0}/${v.initialQuantity}</span>
                                            </div>
                                            <div class="h-2 bg-slate-100 rounded-full overflow-hidden border border-slate-50">
                                                <div class="h-full bg-gradient-to-r from-emerald-500 to-teal-400 transition-all duration-1000" 
                                                     style="width: ${v.initialQuantity > 0 ? ((v.initialQuantity - v.quantity) * 100 / v.initialQuantity) : 0}%">
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <div class="flex items-center gap-2 text-[10px] ${not empty v.expiryDate and v.expiryDate.isBefore(now) ? 'text-rose-500 font-bold' : 'text-slate-400'}">
                                            <i class="far fa-clock"></i>
                                            <span>Hết hạn: <fmt:parseDate value="${v.expiryDate}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both" />
                                                           <fmt:formatDate value="${parsedDate}" pattern="dd/MM/yyyy HH:mm" />
                                            </span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="p-4 bg-slate-50/50 border-t border-slate-200/60 rounded-b-[31px] flex gap-2">
                            <button class="flex-1 py-2 text-xs font-bold text-slate-500 hover:text-small-navy transition-colors">Chi tiết</button>
                            <div class="w-px h-4 bg-slate-200 self-center"></div>
                            <button class="flex-1 py-2 text-xs font-bold text-rose-500 hover:text-rose-600 transition-colors">Xóa</button>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <c:if test="${empty vouchers}">
                <div class="py-20 text-center glass-card rounded-[40px]">
                    <div class="w-20 h-20 bg-slate-100 rounded-3xl flex items-center justify-center text-slate-300 mx-auto mb-6">
                        <i class="fas fa-ticket-alt text-3xl"></i>
                    </div>
                    <h3 class="text-lg font-bold text-slate-700">Chưa có Voucher nào</h3>
                    <p class="text-sm text-slate-400 mt-2">Hãy tạo mã giảm giá đầu tiên để thu hút khách hàng.</p>
                </div>
            </c:if>
        </main>
    </div>

    <!-- Create Voucher Modal -->
    <div x-show="showModal" 
         x-transition:enter="transition ease-out duration-300"
         x-transition:enter-start="opacity-0"
         x-transition:enter-end="opacity-100"
         x-transition:leave="transition ease-in duration-200"
         x-transition:leave-start="opacity-100"
         x-transition:leave-end="opacity-0"
         class="fixed inset-0 z-50 flex items-center justify-center p-4 bg-small-navy/60 backdrop-blur-sm">
        
        <div @click.away="showModal = false" 
             class="bg-white w-full max-w-xl rounded-[40px] shadow-2xl overflow-hidden"
             x-transition:enter="transition ease-out duration-300 transform"
             x-transition:enter-start="scale-95 translate-y-8"
             x-transition:enter-end="scale-100 translate-y-0">
            
            <div class="px-10 py-8 border-b border-slate-100 flex justify-between items-center bg-slate-50/50">
                <div>
                    <h3 class="text-xl font-bold text-small-navy">Tạo Voucher mới</h3>
                    <p class="text-xs text-slate-500 mt-1">Mã giảm giá sẽ được hệ thống tự động sinh ra.</p>
                </div>
                <button @click="showModal = false" class="w-10 h-10 rounded-2xl hover:bg-slate-200 flex items-center justify-center text-slate-400 transition-colors">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            
            <form action="${url}/seller/marketing/vouchers/create" method="POST" class="p-10 space-y-6">
                <div class="grid grid-cols-2 gap-6">
                    <div class="space-y-2 col-span-2">
                        <label class="text-[10px] font-bold text-slate-400 uppercase tracking-widest ml-1">Số lượng phát hành</label>
                        <input type="number" name="quantity" required min="1" placeholder="Ví dụ: 100" 
                               class="w-full px-5 py-4 bg-slate-50 border border-slate-200 rounded-2xl text-sm font-bold focus:ring-2 focus:ring-emerald-500/20 outline-none transition-all">
                    </div>
                </div>

                <div class="grid grid-cols-2 gap-6" x-data="{ discountType: 'FIXED' }">
                    <div class="space-y-2">
                        <label class="text-[10px] font-bold text-slate-400 uppercase tracking-widest ml-1">Loại giảm giá</label>
                        <select name="discountType" x-model="discountType"
                                class="w-full px-5 py-4 bg-slate-50 border border-slate-200 rounded-2xl text-sm font-bold focus:ring-2 focus:ring-emerald-500/20 outline-none transition-all">
                            <option value="FIXED">Cố định (₫)</option>
                            <option value="PERCENTAGE">Phần trăm (%)</option>
                        </select>
                    </div>
                    <div class="space-y-2">
                        <label class="text-[10px] font-bold text-slate-400 uppercase tracking-widest ml-1">
                            Mức giảm (<span x-text="discountType == 'FIXED' ? '₫' : '%'"></span>)
                        </label>
                        <input type="number" name="discountAmount" required min="1" :step="discountType == 'FIXED' ? 1000 : 1" 
                               :placeholder="discountType == 'FIXED' ? '10.000' : '10'" 
                               class="w-full px-5 py-4 bg-slate-50 border border-slate-200 rounded-2xl text-sm font-bold text-emerald-600 focus:ring-2 focus:ring-emerald-500/20 outline-none transition-all">
                    </div>
                </div>
                    <div class="space-y-2">
                        <label class="text-[10px] font-bold text-slate-400 uppercase tracking-widest ml-1">Đơn tối thiểu (₫)</label>
                        <input type="number" name="minOrderValue" required min="0" step="1000" placeholder="50.000" 
                               class="w-full px-5 py-4 bg-slate-50 border border-slate-200 rounded-2xl text-sm font-medium focus:ring-2 focus:ring-emerald-500/20 outline-none transition-all">
                    </div>
                </div>

                <div class="space-y-2">
                    <label class="text-[10px] font-bold text-slate-400 uppercase tracking-widest ml-1">Ngày hết hạn</label>
                    <input type="datetime-local" name="expiryDateStr" required 
                           class="w-full px-5 py-4 bg-slate-50 border border-slate-200 rounded-2xl text-sm font-medium focus:ring-2 focus:ring-emerald-500/20 outline-none transition-all">
                </div>

                <div class="pt-4">
                    <button type="submit" class="w-full py-4 bg-emerald-600 text-white rounded-2xl font-bold shadow-lg shadow-emerald-600/20 hover:bg-emerald-700 transition-all flex items-center justify-center gap-2">
                        <i class="fas fa-magic"></i> Tạo Voucher ngay
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- Success Modal -->
    <div x-show="showSuccessModal" 
         x-transition:enter="transition ease-out duration-300"
         x-transition:enter-start="opacity-0"
         x-transition:enter-end="opacity-100"
         x-transition:leave="transition ease-in duration-200"
         x-transition:leave-start="opacity-100"
         x-transition:leave-end="opacity-0"
         class="fixed inset-0 z-[60] flex items-center justify-center p-4 bg-emerald-900/40 backdrop-blur-md">
        
        <div class="bg-white w-full max-w-sm rounded-[40px] shadow-2xl p-10 text-center"
             x-transition:enter="transition ease-out duration-300 transform"
             x-transition:enter-start="scale-95 translate-y-8"
             x-transition:enter-end="scale-100 translate-y-0">
            
            <div class="w-20 h-20 bg-emerald-100 text-emerald-600 rounded-3xl flex items-center justify-center text-3xl mx-auto mb-6 animate-bounce">
                <i class="fas fa-check"></i>
            </div>
            
            <h3 class="text-2xl font-black text-small-navy mb-2">Thành công!</h3>
            <p class="text-sm text-slate-500 mb-8">Mã Voucher của bạn đã được khởi tạo:</p>
            
            <div class="bg-slate-100 border-2 border-dashed border-slate-200 p-6 rounded-3xl mb-8 group relative cursor-pointer"
                 @click="navigator.clipboard.writeText('${generatedCode}')">
                <span class="text-3xl font-black tracking-widest text-emerald-600">${generatedCode}</span>
                <div class="absolute inset-0 bg-emerald-600 text-white flex items-center justify-center opacity-0 group-hover:opacity-100 rounded-3xl transition-opacity font-bold">
                    <i class="fas fa-copy mr-2"></i> Sao chép mã
                </div>
            </div>
            
            <button @click="showSuccessModal = false" 
                    class="w-full py-4 bg-small-navy text-white rounded-2xl font-bold hover:bg-slate-800 transition-all">
                Đóng thông báo
            </button>
        </div>
    </div>

</body>
</html>
