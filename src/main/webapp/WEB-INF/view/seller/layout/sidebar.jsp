<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="url" value="${pageContext.request.contextPath}" />

<aside class="fixed inset-y-0 left-0 w-64 bg-[#0F172A] text-slate-400 hidden md:flex flex-col z-20 border-r border-white/5 scrollbar-hide">
    <!-- Brand Logo (Homepage Style) -->
    <div class="px-8 py-10">
        <a href="${url}/" class="flex items-center no-underline">
            <span class="text-3xl font-extrabold text-[#1A7A42] tracking-tighter">S</span>
            <span class="bg-[#1A7A42] text-white px-3 py-1 rounded-[10px] text-[22px] font-bold ml-2 shadow-lg shadow-emerald-900/20">Mall</span>
        </a>
        <div class="text-[10px] text-slate-500 font-bold uppercase tracking-widest mt-2 ml-1">Seller Center</div>
    </div>

    <!-- Navigation Menu -->
    <nav class="flex-1 px-4 space-y-1.5 overflow-y-auto mt-4 scrollbar-hide">
        <a href="${url}/" class="group flex items-center gap-3 px-4 py-3 rounded-xl transition-all hover:bg-white/5 hover:text-white" id="nav-home">
            <i class="fas fa-home w-5 text-center text-sm opacity-60 group-hover:text-emerald-400 transition-colors"></i>
            <span class="text-sm font-medium">Trang chủ</span>
        </a>

        <a href="${url}/seller/dashboard" class="nav-item group flex items-center gap-3 px-4 py-3 rounded-xl transition-all hover:bg-white/5 hover:text-white" id="nav-dashboard">
            <i class="fas fa-th-large w-5 text-center text-sm opacity-60 group-hover:text-emerald-400 transition-colors"></i>
            <span class="text-sm font-medium">Dashboard</span>
        </a>

        <!-- Products Menu with Dropdown -->
        <div x-data="{ open: window.location.pathname.includes('/seller/product/') }">
            <button @click="open = !open" 
               class="nav-item group flex items-center justify-between w-full px-4 py-3 rounded-xl transition-all hover:bg-white/5 hover:text-white"
               :class="open ? 'text-white' : ''">
                <div class="flex items-center gap-3">
                    <i class="fas fa-box w-5 text-center text-sm opacity-60 group-hover:text-emerald-400 transition-colors"
                       :class="open ? 'text-emerald-400 opacity-100' : ''"></i>
                    <span class="text-sm font-medium">Sản phẩm</span>
                </div>
                <i class="fas fa-chevron-right text-[10px] transition-transform duration-300" :class="open ? 'rotate-90' : ''"></i>
            </button>
            
            <div x-show="open" 
                 x-transition:enter="transition ease-out duration-200"
                 x-transition:enter-start="opacity-0 -translate-y-2"
                 x-transition:enter-end="opacity-100 translate-y-0"
                 class="pl-12 mt-1 space-y-1">
                <a href="${url}/seller/product/show" 
                   class="block py-2 text-sm hover:text-emerald-400 transition-colors ${pageContext.request.requestURI.contains('show.jsp') ? 'text-emerald-400 font-bold' : ''}">
                    Danh sách sản phẩm
                </a>
                <a href="${url}/seller/product/create" 
                   class="block py-2 text-sm hover:text-emerald-400 transition-colors ${pageContext.request.requestURI.contains('create.jsp') ? 'text-emerald-400 font-bold' : ''}">
                    Thêm sản phẩm mới
                </a>
            </div>
        </div>

        <a href="${url}/seller/order/list" class="nav-item group flex items-center gap-3 px-4 py-3 rounded-xl transition-all hover:bg-white/5 hover:text-white" id="nav-orders">
            <i class="fas fa-shopping-cart w-5 text-center text-sm opacity-60 group-hover:text-emerald-400 transition-colors"></i>
            <span class="text-sm font-medium">Orders</span>
        </a>

        <a href="#" class="nav-item group flex items-center gap-3 px-4 py-3 rounded-xl transition-all hover:bg-white/5 hover:text-white">
            <i class="fas fa-users w-5 text-center text-sm opacity-60 group-hover:text-emerald-400 transition-colors"></i>
            <span class="text-sm font-medium">Customers</span>
        </a>

        <a href="#" class="nav-item group flex items-center gap-3 px-4 py-3 rounded-xl transition-all hover:bg-white/5 hover:text-white">
            <i class="fas fa-chart-line w-5 text-center text-sm opacity-60 group-hover:text-emerald-400 transition-colors"></i>
            <span class="text-sm font-medium">Analytics</span>
        </a>

        <a href="#" class="nav-item group flex items-center gap-3 px-4 py-3 rounded-xl transition-all hover:bg-white/5 hover:text-white">
            <i class="fas fa-globe w-5 text-center text-sm opacity-60 group-hover:text-emerald-400 transition-colors"></i>
            <span class="text-sm font-medium">Global Reach</span>
        </a>

        <a href="#" class="nav-item group flex items-center gap-3 px-4 py-3 rounded-xl transition-all hover:bg-white/5 hover:text-white">
            <i class="fas fa-bolt w-5 text-center text-sm opacity-60 group-hover:text-emerald-400 transition-colors"></i>
            <span class="text-sm font-medium">Growth AI</span>
        </a>

        <a href="#" class="nav-item group flex items-center gap-3 px-4 py-3 rounded-xl transition-all hover:bg-white/5 hover:text-white">
            <i class="fas fa-cog w-5 text-center text-sm opacity-60 group-hover:text-emerald-400 transition-colors"></i>
            <span class="text-sm font-medium">Settings</span>
        </a>
    </nav>

    <!-- Sidebar Footer -->
    <div class="p-4 mt-auto">
        <!-- Monthly Revenue Card -->
        <div class="bg-[#1E293B]/40 rounded-[20px] p-5 border border-white/5 mb-4">
            <div class="text-[11px] text-slate-500 font-bold mb-3 tracking-wide">Monthly Revenue</div>
            <div class="text-2xl font-bold text-white mb-1">$127,450</div>
            <div class="text-[11px] text-emerald-400 font-medium">
                <i class="fas fa-arrow-up mr-1"></i> +18.3% from last month
            </div>
        </div>

    </div>
</aside>

<style>
    .nav-item.active {
        background-color: #064E3B !important;
        color: white !important;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
    }
    .nav-item.active i {
        color: white !important;
        opacity: 1 !important;
    }

    /* Kỹ thuật ẩn thanh cuộn triệt để */
    .scrollbar-hide::-webkit-scrollbar {
        display: none !important;
    }
    .scrollbar-hide {
        -ms-overflow-style: none !important;
        scrollbar-width: none !important;
        overflow: -moz-scrollbars-none !important;
    }
</style>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const currentPath = window.location.pathname;
        const navItems = document.querySelectorAll('.nav-item');
        
        navItems.forEach(item => {
            const href = item.getAttribute('href');
            if (href && currentPath.includes(href) && href !== '${url}/') {
                item.classList.add('active');
            }
        });
    });
</script>