<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <c:set var="url" value="${pageContext.request.contextPath}" />

            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>S-Mall | Customer Insights</title>

                <!-- Tailwind & Alpine -->
                <script src="https://cdn.tailwindcss.com"></script>
                <script defer src="https://unpkg.com/alpinejs@3.x.x/dist/cdn.min.js"></script>
                <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
                    rel="stylesheet">
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
                    body {
                        font-family: 'Inter', sans-serif;
                    }

                    .glass-card {
                        background: rgba(255, 255, 255, 0.7);
                        backdrop-filter: blur(12px);
                        border: 1px solid rgba(226, 232, 240, 0.5);
                    }

                    .ai-chat-gradient {
                        background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%);
                    }

                    .custom-scrollbar::-webkit-scrollbar {
                        width: 4px;
                    }

                    .custom-scrollbar::-webkit-scrollbar-track {
                        background: transparent;
                    }

                    .custom-scrollbar::-webkit-scrollbar-thumb {
                        background: #e2e8f0;
                        border-radius: 10px;
                    }
                </style>
            </head>

            <body class="bg-slate-50 min-h-screen">

                <!-- Sidebar Inclusion -->
                <jsp:include page="/WEB-INF/view/seller/layout/sidebar.jsp" />

                <!-- Main Wrapper -->
                <div class="md:pl-64 flex flex-col min-h-screen">

                    <!-- Header -->
                    <header
                        class="sticky top-0 z-10 bg-white/80 backdrop-blur-xl border-b border-slate-200/60 px-8 py-6">
                        <div class="flex items-center justify-between">
                            <div>
                                <h1 class="text-2xl font-bold text-small-navy tracking-tight">Khách hàng đã mua</h1>
                                <p class="text-sm text-slate-500">Phân tích hành vi mua sắm và tối ưu hóa chuyển đổi
                                    bằng AI.</p>
                            </div>
                            <div class="flex items-center gap-4">
                                <button
                                    class="bg-emerald-50 text-emerald-600 px-4 py-2 rounded-xl text-sm font-bold border border-emerald-100 hover:bg-emerald-100 transition-all">
                                    <i class="fas fa-plus mr-2"></i> Tạo Voucher mới
                                </button>
                                <div
                                    class="flex items-center gap-4 bg-slate-100 p-1.5 rounded-2xl border border-slate-200">
                                    <c:choose>
                                        <c:when test="${not empty sessionScope.shopLogoUrl}">
                                            <img src="${url}${sessionScope.shopLogoUrl}"
                                                class="w-8 h-8 rounded-xl object-cover border border-white">
                                        </c:when>
                                        <c:otherwise>
                                            <div
                                                class="w-8 h-8 bg-emerald-500 rounded-xl flex items-center justify-center text-white text-xs">
                                                <i class="fas fa-store"></i>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                    <span class="text-sm font-bold text-slate-700 pr-3">${sessionScope.shopName}</span>
                                </div>
                            </div>
                        </div>
                    </header>

                    <main class="p-8 flex gap-8 flex-1 overflow-hidden">

                        <!-- Customer List Section (Left) -->
                        <div class="flex-1 space-y-6 flex flex-col min-w-0">
                            <div class="flex items-center justify-between">
                                <h3 class="text-lg font-bold text-small-navy">Top khách hàng mua sắm</h3>
                                <div class="flex gap-2">
                                    <div class="relative">
                                        <i
                                            class="fas fa-search absolute left-3 top-1/2 -translate-y-1/2 text-slate-400 text-xs"></i>
                                        <input type="text" placeholder="Tìm khách hàng..."
                                            class="pl-9 pr-4 py-2 bg-white border border-slate-200 rounded-xl text-xs outline-none focus:ring-2 focus:ring-emerald-500/20 transition-all w-64">
                                    </div>
                                </div>
                            </div>

                            <!-- Table Container -->
                            <div class="glass-card rounded-3xl overflow-hidden shadow-sm flex-1 flex flex-col">
                                <div class="overflow-x-auto custom-scrollbar">
                                    <table class="w-full text-left">
                                        <thead class="bg-slate-50/50 border-b border-slate-200/60">
                                            <tr>
                                                <th
                                                    class="px-6 py-4 text-[10px] font-bold text-slate-400 uppercase tracking-widest">
                                                    Khách hàng</th>
                                                <th
                                                    class="px-6 py-4 text-[10px] font-bold text-slate-400 uppercase tracking-widest">
                                                    Đơn hàng</th>
                                                <th
                                                    class="px-6 py-4 text-[10px] font-bold text-slate-400 uppercase tracking-widest">
                                                    Tổng chi tiêu</th>
                                                <th
                                                    class="px-6 py-4 text-[10px] font-bold text-slate-400 uppercase tracking-widest">
                                                    Mua lần cuối</th>
                                                <th
                                                    class="px-6 py-4 text-[10px] font-bold text-slate-400 uppercase tracking-widest text-right">
                                                    Thao tác</th>
                                            </tr>
                                        </thead>
                                        <tbody class="divide-y divide-slate-100">
                                            <c:forEach var="customer" items="${customers}">
                                                <tr class="hover:bg-slate-50/50 transition-colors">
                                                    <td class="px-6 py-4">
                                                        <div class="flex items-center gap-3">
                                                            <div class="relative">
                                                                <img src="${not empty customer.avatarUrl ? (customer.avatarUrl.startsWith('http') ? customer.avatarUrl : url.concat(customer.avatarUrl)) : 'https://ui-avatars.com/api/?name='.concat(customer.fullName)}"
                                                                    class="w-10 h-10 rounded-xl object-cover border border-slate-100">
                                                                <c:if test="${customer.totalSpent > 1000000}">
                                                                    <div
                                                                        class="absolute -top-1 -right-1 w-4 h-4 bg-amber-400 border-2 border-white rounded-full flex items-center justify-center">
                                                                        <i
                                                                            class="fas fa-crown text-[8px] text-white"></i>
                                                                    </div>
                                                                </c:if>
                                                            </div>
                                                            <div>
                                                                <p class="text-sm font-bold text-slate-700">
                                                                    ${customer.fullName}</p>
                                                                <p class="text-[10px] text-slate-400 font-medium">
                                                                    ${customer.email}</p>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td class="px-6 py-4">
                                                        <span
                                                            class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-bold bg-blue-50 text-blue-600">
                                                            ${customer.totalOrders} đơn
                                                        </span>
                                                    </td>
                                                    <td class="px-6 py-4">
                                                        <p class="text-sm font-bold text-small-navy">
                                                            <fmt:formatNumber value="${customer.totalSpent}"
                                                                type="currency" currencySymbol="₫" />
                                                        </p>
                                                    </td>
                                                    <td class="px-6 py-4">
                                                        <p class="text-[11px] text-slate-500 font-medium">
                                                            <fmt:parseDate value="${customer.lastOrderDate}"
                                                                pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate"
                                                                type="both" />
                                                            <fmt:formatDate value="${parsedDate}"
                                                                pattern="dd/MM/yyyy HH:mm" />
                                                        </p>
                                                    </td>
                                                    <td class="px-6 py-4 text-right">
                                                        <button
                                                            @click="$dispatch('open-chat', { name: '${customer.fullName}', email: '${customer.email}' })"
                                                            class="p-2 hover:bg-emerald-50 text-slate-400 hover:text-emerald-600 rounded-lg transition-all">
                                                            <i class="fas fa-paper-plane text-sm"></i>
                                                        </button>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>

                                <c:if test="${empty customers}">
                                    <div class="p-20 text-center">
                                        <div
                                            class="w-16 h-16 bg-slate-100 rounded-2xl flex items-center justify-center text-slate-400 mx-auto mb-4">
                                            <i class="fas fa-users-slash text-2xl"></i>
                                        </div>
                                        <h4 class="text-slate-700 font-bold">Chưa có khách hàng nào</h4>
                                        <p class="text-slate-400 text-xs mt-1">Các khách hàng đã mua sản phẩm sẽ xuất
                                            hiện tại đây.</p>
                                    </div>
                                </c:if>
                            </div>
                        </div>

                        <!-- AI Growth Advisor (Right) -->
                        <div class="w-96 flex flex-col"
                            x-data="{ messages: [{ role: 'ai', content: 'Chào bạn! Tôi là S-Mall AI. Dựa trên danh sách khách hàng, tôi có thể giúp bạn đề xuất Voucher phù hợp để tăng tỉ lệ quay lại. Bạn muốn phân tích ai trước?' }], input: '' }">
                            <div
                                class="ai-chat-gradient rounded-[32px] flex-1 shadow-xl flex flex-col border border-white/5 overflow-hidden">
                                <!-- Chat Header -->
                                <div
                                    class="px-6 py-5 border-b border-white/5 flex items-center justify-between bg-white/5 backdrop-blur-sm">
                                    <div class="flex items-center gap-3">
                                        <div
                                            class="w-10 h-10 bg-emerald-500 rounded-2xl flex items-center justify-center text-white shadow-lg shadow-emerald-500/20">
                                            <i class="fas fa-robot text-lg"></i>
                                        </div>
                                        <div>
                                            <h4 class="text-white text-sm font-bold">AI Growth Advisor</h4>
                                            <p class="text-[10px] text-emerald-400 font-bold flex items-center gap-1.5">
                                                <span
                                                    class="w-1.5 h-1.5 bg-emerald-400 rounded-full animate-pulse"></span>
                                                Đang trực tuyến
                                            </p>
                                        </div>
                                    </div>
                                    <button class="text-slate-400 hover:text-white transition-colors">
                                        <i class="fas fa-ellipsis-v text-xs"></i>
                                    </button>
                                </div>

                                <!-- Chat Messages -->
                                <div class="flex-1 overflow-y-auto p-6 space-y-4 custom-scrollbar" id="chat-container">
                                    <template x-for="(msg, index) in messages" :key="index">
                                        <div
                                            :class="msg.role === 'ai' ? 'flex items-start gap-3' : 'flex flex-row-reverse items-start gap-3'">
                                            <div
                                                :class="msg.role === 'ai' ? 'w-8 h-8 rounded-lg bg-emerald-500/20 flex items-center justify-center text-emerald-400 flex-shrink-0' : 'w-8 h-8 rounded-lg bg-slate-700 flex items-center justify-center text-slate-300 flex-shrink-0'">
                                                <i
                                                    :class="msg.role === 'ai' ? 'fas fa-robot text-[10px]' : 'fas fa-user text-[10px]'"></i>
                                            </div>
                                            <div
                                                :class="msg.role === 'ai' ? 'bg-white/5 border border-white/5 rounded-2xl rounded-tl-none p-4' : 'bg-emerald-600 rounded-2xl rounded-tr-none p-4 shadow-lg shadow-emerald-600/20'">
                                                <p class="text-xs text-white leading-relaxed" x-text="msg.content"></p>
                                            </div>
                                        </div>
                                    </template>
                                </div>

                                <!-- Chat Input -->
                                <div class="p-6 bg-white/5 border-t border-white/5">
                                    <div class="relative">
                                        <textarea x-model="input"
                                            @keydown.enter.prevent="if(input.trim()) { messages.push({role: 'user', content: input}); input = ''; setTimeout(() => { messages.push({role: 'ai', content: 'Cảm ơn bạn! Để tôi phân tích hành vi mua sắm của khách hàng này và đưa ra gợi ý Voucher tối ưu nhất...'}); }, 1000); }"
                                            placeholder="Hỏi AI về chiến dịch Voucher..."
                                            class="w-full bg-slate-800/50 border border-white/10 rounded-2xl px-4 py-3 text-xs text-white outline-none focus:ring-2 focus:ring-emerald-500/50 transition-all resize-none h-20"></textarea>
                                        <button
                                            class="absolute bottom-3 right-3 w-8 h-8 bg-emerald-500 text-white rounded-xl flex items-center justify-center hover:bg-emerald-400 transition-all">
                                            <i class="fas fa-arrow-up text-xs"></i>
                                        </button>
                                    </div>
                                    <p
                                        class="text-[9px] text-slate-500 mt-3 text-center uppercase tracking-widest font-bold">
                                        Powered by S-Mall AI Core</p>
                                </div>
                            </div>
                        </div>
                    </main>
                </div>

                <script>
                    document.addEventListener('open-chat', e => {
                        // This will be used to trigger AI analysis for a specific customer
                        console.log('Opening chat for:', e.detail);
                    });
                </script>
            </body>

            </html>