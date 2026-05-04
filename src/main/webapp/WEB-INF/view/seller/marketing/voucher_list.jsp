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
    <div class="md:pl-64 flex flex-col min-h-screen">
        
        <!-- Header -->
        <header class="sticky top-0 z-10 bg-white/80 backdrop-blur-xl border-b border-slate-200/60 px-8 py-6">
            <div class="flex items-center justify-between">
                <div>
                    <h1 class="text-2xl font-bold text-small-navy tracking-tight">Quản lý Voucher</h1>
                    <p class="text-sm text-slate-500">Tạo mã giảm giá công khai hoặc ưu đãi riêng tư.</p>
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
                <div class="bg-rose-50 border border-rose-100 text-rose-600 px-6 py-4 rounded-2xl text-sm font-medium">
                    <i class="fas fa-exclamation-circle mr-2"></i> ${error}
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
                                <span class="px-3 py-1 rounded-full text-[10px] font-bold uppercase tracking-widest ${v.publicVoucher ? 'bg-emerald-50 text-emerald-600' : 'bg-amber-50 text-amber-600'}">
                                    ${v.publicVoucher ? 'Công khai' : 'Cá nhân'}
                                </span>
                            </div>
                            
                            <h3 class="text-xl font-black text-small-navy mb-1">${v.code}</h3>
                            <p class="text-xs text-slate-400 font-medium mb-6">Giảm <fmt:formatNumber value="${v.discountAmount}" type="currency" currencySymbol="₫"/> cho đơn từ <fmt:formatNumber value="${v.minOrderValue}" type="currency" currencySymbol="₫"/></p>
                            
                            <div class="space-y-3">
                                <div class="flex justify-between text-xs">
                                    <span class="text-slate-500">Số lượng còn lại:</span>
                                    <span class="font-bold text-small-navy">${v.quantity}</span>
                                </div>
                                <div class="w-full bg-slate-100 h-1.5 rounded-full overflow-hidden">
                                    <div class="bg-emerald-500 h-full transition-all duration-1000" 
                                         style="width: ${v.initialQuantity > 0 ? (v.quantity * 100 / v.initialQuantity) : 100}%"></div>
                                </div>
                                <div class="flex items-center gap-2 text-[10px] text-slate-400 font-bold">
                                    <i class="fas fa-clock"></i>
                                    <span>Hết hạn: ${v.formattedExpiryDate}</span>
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

                <div class="grid grid-cols-2 gap-6">
                    <div class="space-y-2">
                        <label class="text-[10px] font-bold text-slate-400 uppercase tracking-widest ml-1">Số tiền giảm (₫)</label>
                        <input type="number" name="discountAmount" required min="1000" step="1000" placeholder="10.000" 
                               class="w-full px-5 py-4 bg-slate-50 border border-slate-200 rounded-2xl text-sm font-bold text-emerald-600 focus:ring-2 focus:ring-emerald-500/20 outline-none transition-all">
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
