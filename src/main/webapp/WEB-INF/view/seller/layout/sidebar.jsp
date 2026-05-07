<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="url" value="${pageContext.request.contextPath}" />

<aside id="main-sidebar" class="fixed inset-y-0 left-0 w-64 bg-white text-slate-500 hidden md:flex flex-col z-20 border-r border-slate-100 scrollbar-hide transition-transform duration-300 ease-in-out">
    <!-- Brand Logo (Premium Light Style) -->
    <div class="px-8 py-10">
        <a href="${url}/" class="flex items-center no-underline">
            <span class="text-3xl font-extrabold text-[#10B981] tracking-tighter italic">S</span>
            <span class="bg-[#10B981] text-white px-3 py-1 rounded-[12px] text-[20px] font-bold ml-1.5 shadow-lg shadow-emerald-500/30">Mall</span>
        </a>
        <div class="text-[10px] text-slate-400 font-bold uppercase tracking-[0.2em] mt-2 ml-1">Seller Center</div>
    </div>

    <!-- Navigation Menu -->
    <nav class="flex-1 px-4 space-y-2.5 overflow-y-auto mt-2 scrollbar-hide">
        <a href="${url}/" class="nav-item group flex items-center gap-4 px-4 py-4 rounded-2xl transition-all hover:bg-slate-50" id="nav-home">
            <i class="fas fa-home w-6 text-center text-base opacity-70 group-hover:text-emerald-500 transition-colors"></i>
            <span class="text-[15px] font-semibold">Tổng hợp</span>
        </a>

        <a href="${url}/seller/dashboard" class="nav-item group flex items-center gap-4 px-4 py-4 rounded-2xl transition-all hover:bg-slate-50" id="nav-dashboard">
            <i class="fas fa-th-large w-6 text-center text-base opacity-70 group-hover:text-emerald-500 transition-colors"></i>
            <span class="text-[15px] font-semibold">Dashboard</span>
        </a>

        <!-- Products Menu: Sửa logic để không bị tự động xổ ra -->
        <div x-data="{ open: window.location.pathname.endsWith('/product/show') || window.location.pathname.endsWith('/product/create') }">
            <button @click="open = !open" 
               class="group flex items-center justify-between w-full px-4 py-4 rounded-2xl transition-all hover:bg-slate-50 outline-none"
               :class="open ? 'bg-slate-50/50' : ''">
                <div class="flex items-center gap-4">
                    <i class="fas fa-box w-6 text-center text-base opacity-70 group-hover:text-emerald-500 transition-colors"
                       :class="open ? 'text-emerald-500 opacity-100' : ''"></i>
                    <span class="text-[15px] font-semibold" :class="open ? 'text-slate-900' : ''">Sản phẩm</span>
                </div>
                <i class="fas fa-chevron-right text-[11px] transition-transform duration-300 opacity-40" :class="open ? 'rotate-90' : ''"></i>
            </button>
            <div x-show="open" x-cloak class="pl-14 mt-1 space-y-1.5">
                <a href="${url}/seller/product/show" 
                   class="block py-2.5 text-[13px] font-medium transition-colors hover:text-emerald-500 ${pageContext.request.requestURI.contains('show.jsp') ? 'text-emerald-500 font-bold' : 'text-slate-500'}">
                   Danh sách sản phẩm
                </a>
                <a href="${url}/seller/product/create" 
                   class="block py-2.5 text-[13px] font-medium transition-colors hover:text-emerald-500 ${pageContext.request.requestURI.contains('create.jsp') ? 'text-emerald-500 font-bold' : 'text-slate-500'}">
                   Thêm mới
                </a>
            </div>
        </div>

        <a href="${url}/seller/order/list" class="nav-item group flex items-center gap-4 px-4 py-4 rounded-2xl transition-all hover:bg-slate-50" id="nav-orders">
            <i class="fas fa-shopping-bag w-6 text-center text-base opacity-70 group-hover:text-emerald-500 transition-colors"></i>
            <span class="text-[15px] font-semibold">Đơn hàng</span>
        </a>

        <a href="${url}/seller/chat" class="nav-item group flex items-center gap-4 px-4 py-4 rounded-2xl transition-all hover:bg-slate-50" id="nav-chat">
            <i class="fas fa-comments w-6 text-center text-base opacity-70 group-hover:text-emerald-500 transition-colors"></i>
            <span class="text-[15px] font-semibold">Chat</span>
        </a>

        <a href="${url}/seller/marketing/customers" class="nav-item group flex items-center gap-4 px-4 py-4 rounded-2xl transition-all hover:bg-slate-50" id="nav-customers">
            <i class="fas fa-users w-6 text-center text-base opacity-70 group-hover:text-emerald-500 transition-colors"></i>
            <span class="text-[15px] font-semibold">Customers</span>
        </a>

        <a href="${url}/seller/marketing/vouchers" class="nav-item group flex items-center gap-4 px-4 py-4 rounded-2xl transition-all hover:bg-slate-50" id="nav-vouchers">
            <i class="fas fa-ticket-alt w-6 text-center text-base opacity-70 group-hover:text-emerald-500 transition-colors"></i>
            <span class="text-[15px] font-semibold">Vouchers</span>
        </a>

        <a href="#" class="nav-item group flex items-center gap-4 px-4 py-4 rounded-2xl transition-all hover:bg-slate-50">
            <i class="fas fa-chart-pie w-6 text-center text-base opacity-70 group-hover:text-emerald-500 transition-colors"></i>
            <span class="text-[15px] font-semibold">Phân tích</span>
        </a>

        <a href="#" class="nav-item group flex items-center gap-4 px-4 py-4 rounded-2xl transition-all hover:bg-slate-50">
            <i class="fas fa-cog w-6 text-center text-base opacity-70 group-hover:text-emerald-500 transition-colors"></i>
            <span class="text-[15px] font-semibold">Cài đặt</span>
        </a>
    </nav>

    <!-- Sidebar Footer -->
    <div class="p-6 mt-auto">
        <div class="bg-emerald-50/50 rounded-[24px] p-5 border border-emerald-100/50">
            <div class="text-[10px] text-emerald-600/60 font-bold mb-2 uppercase tracking-wider">Monthly Revenue</div>
            <div class="text-xl font-bold text-slate-900 mb-1">$127,450</div>
            <div class="text-[10px] text-emerald-500 font-bold flex items-center gap-1">
                <i class="fas fa-arrow-up"></i> +18.3% from last month
            </div>
        </div>
    </div>
</aside>

<style>
    [x-cloak] { display: none !important; }
    .nav-item.active {
        background-color: #10B981 !important;
        color: white !important;
        box-shadow: 0 12px 20px -8px rgba(16, 185, 129, 0.4);
    }
    .nav-item.active i {
        color: white !important;
        opacity: 1 !important;
    }
    .scrollbar-hide::-webkit-scrollbar { display: none; }
    
    #main-sidebar.collapsed {
        transform: translateX(-100%);
    }
    .content-expanded {
        padding-left: 0 !important;
    }
</style>

<script>
    function toggleSidebar() {
        const sidebar = document.getElementById('main-sidebar');
        const content = document.getElementById('main-content');
        sidebar.classList.toggle('collapsed');
        if (content) {
            content.classList.toggle('content-expanded');
        }
    }

    document.addEventListener('DOMContentLoaded', function() {
        const currentPath = window.location.pathname;
        document.querySelectorAll('.nav-item').forEach(item => {
            const href = item.getAttribute('href');
            if (href && currentPath.includes(href) && href !== '${url}/') {
                item.classList.add('active');
            }
        });
    });
</script>