<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="url" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Product Management | S-Mall Seller</title>
    
    <script src="https://cdn.tailwindcss.com"></script>
    <script defer src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js"></script>
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
        body { font-family: 'Inter', sans-serif; overflow-x: hidden; }
        .glass-card {
            background: rgba(255, 255, 255, 0.6);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(226, 232, 240, 0.5);
        }
        .stats-card {
            background: white;
            border: 1px solid #E2E8F0;
            border-radius: 20px;
            padding: 24px;
        }

        .sticky-search {
            position: sticky;
            top: 0;
            z-index: 40;
            background: rgba(239, 247, 242, 0.8);
            backdrop-filter: blur(20px);
            border-bottom: 1px solid rgba(6, 95, 70, 0.05);
            margin-left: -2.5rem;
            margin-right: -2.5rem;
            padding-left: 2.5rem;
            padding-right: 2.5rem;
            transition: all 0.3s ease;
        }

        /* Hiệu ứng loading cho nút Load More */
        .loading-dots:after {
            content: '.';
            animation: dots 1.5s steps(5, end) infinite;
        }
        @keyframes dots {
            0%, 20% { content: '.'; }
            40% { content: '..'; }
            60% { content: '...'; }
            80%, 100% { content: ''; }
        }
    </style>
</head>
<body class="bg-[#EFF7F2]">

    <!-- Sidebar Inclusion -->
    <jsp:include page="/WEB-INF/view/seller/layout/sidebar.jsp" />

    <!-- Main Content Wrapper -->
    <div class="md:pl-64 flex flex-col min-h-screen">
        
        <!-- Inner Container -->
        <div class="w-full max-w-7xl mx-auto px-10">
            
            <!-- Header Top Section -->
            <div class="pt-10 pb-6">
                <div class="flex items-start justify-between mb-8">
                    <div>
                        <h1 class="text-3xl font-semibold text-small-navy mb-2">Product Management</h1>
                        <p class="text-sm text-gray-500">Manage and analyze all your products with AI-powered insights</p>
                    </div>
                    <a href="${url}/seller/product/create" class="flex items-center gap-3 px-6 py-3.5 bg-small-emerald text-white rounded-2xl hover:bg-emerald-900 transition-all shadow-xl shadow-emerald-900/20 font-bold">
                        <i class="fas fa-plus"></i>
                        <span>Add Product</span>
                    </a>
                </div>

                <!-- Stats Grid -->
                <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                    <div class="stats-card">
                        <div class="text-[11px] text-gray-400 uppercase font-bold tracking-widest mb-2">Total Products</div>
                        <div class="text-3xl font-semibold text-small-navy">${totalElements}</div>
                    </div>
                    <div class="stats-card">
                        <div class="text-[11px] text-gray-400 uppercase font-bold tracking-widest mb-2">Avg Global Reach</div>
                        <div class="text-3xl font-semibold text-emerald-600">82.6%</div>
                    </div>
                    <div class="stats-card">
                        <div class="text-[11px] text-gray-400 uppercase font-bold tracking-widest mb-2">Total Views</div>
                        <div class="text-3xl font-semibold text-small-navy">
                            <c:set var="totalViews" value="0" />
                            <c:forEach var="p" items="${products}"><c:set var="totalViews" value="${totalViews + p.viewCount}" /></c:forEach>
                            <fmt:formatNumber value="${totalViews}" type="number" />
                        </div>
                    </div>
                </div>
            </div>

            <!-- Sticky Search Bar -->
            <div class="sticky-search py-6 -mx-10 px-10">
                <div class="flex items-center gap-4">
                    <div class="flex-1 relative group">
                        <i class="fas fa-search absolute left-4 top-1/2 -translate-y-1/2 text-gray-400 group-focus-within:text-small-emerald transition-colors"></i>
                        <input type="text" placeholder="Search products by name, category, or SKU..." 
                               class="w-full pl-12 pr-4 py-3.5 bg-white border border-gray-200/50 rounded-2xl focus:ring-4 focus:ring-small-emerald/5 focus:border-small-emerald outline-none transition-all text-sm shadow-sm">
                    </div>
                    <button class="flex items-center gap-2 px-6 py-3 bg-white border border-gray-200 rounded-2xl hover:bg-gray-50 transition-all text-sm font-medium text-gray-600">
                        <i class="fas fa-filter"></i> Filters
                    </button>
                </div>
            </div>

            <!-- Product Cards List Container -->
            <main id="productContainer" class="py-8">
                <jsp:include page="product_items.jsp" />
            </main>

            <!-- Load More Section -->
            <div id="loadMoreSection" class="pb-20 flex flex-col items-center gap-4">
                <c:if test="${currentPage < totalPages - 1}">
                    <button id="loadMoreBtn" 
                            onclick="loadMoreProducts()"
                            class="px-10 py-4 bg-white border border-gray-200 text-small-navy font-bold rounded-2xl hover:bg-gray-50 hover:border-gray-300 transition-all shadow-sm flex items-center gap-3">
                        <span>Hiển thị thêm</span>
                        <i class="fas fa-chevron-down text-xs text-gray-400"></i>
                    </button>
                    <p class="text-xs text-gray-400 font-medium">Hiển thị thêm 10 sản phẩm tiếp theo</p>
                </c:if>
                <c:if test="${currentPage >= totalPages - 1}">
                    <p class="text-sm text-gray-400 font-medium italic">Bạn đã xem hết danh sách sản phẩm</p>
                </c:if>
            </div>
        </div>
    </div>

    <script>
        let currentPage = ${currentPage};
        const totalPages = ${totalPages};
        const loadMoreBtn = document.getElementById('loadMoreBtn');
        const loadMoreSection = document.getElementById('loadMoreSection');
        const productContainer = document.getElementById('productContainer');

        async function loadMoreProducts() {
            if (currentPage >= totalPages - 1) return;

            // Hiệu ứng Loading
            const originalContent = loadMoreBtn.innerHTML;
            loadMoreBtn.disabled = true;
            loadMoreBtn.innerHTML = '<span class="loading-dots">Đang tải</span>';
            loadMoreBtn.classList.add('opacity-75', 'cursor-not-allowed');

            try {
                currentPage++;
                const response = await fetch(`${url}/seller/product/load-more?page=${currentPage}`);
                
                if (!response.ok) throw new Error('Network response was not ok');
                
                const html = await response.text();
                
                // Thêm sản phẩm mới vào container
                productContainer.insertAdjacentHTML('beforeend', html);

                // Kiểm tra xem còn trang nào không
                if (currentPage >= totalPages - 1) {
                    loadMoreSection.innerHTML = '<p class="text-sm text-gray-400 font-medium italic">Bạn đã xem hết danh sách sản phẩm</p>';
                } else {
                    // Trả lại trạng thái nút
                    loadMoreBtn.disabled = false;
                    loadMoreBtn.innerHTML = originalContent;
                    loadMoreBtn.classList.remove('opacity-75', 'cursor-not-allowed');
                }
            } catch (error) {
                console.error('Error loading more products:', error);
                alert('Có lỗi xảy ra khi tải thêm sản phẩm. Vui lòng thử lại.');
                currentPage--;
                loadMoreBtn.disabled = false;
                loadMoreBtn.innerHTML = originalContent;
            }
        }

        async function deleteProduct(id) {
            if (!confirm('Bạn có chắc chắn muốn xóa sản phẩm này? Thao tác này sẽ ẩn sản phẩm khỏi cửa hàng.')) {
                return;
            }

            try {
                const response = await fetch(`${url}/seller/product/delete/${id}`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    }
                });

                const result = await response.json();
                if (result.success) {
                    const item = document.querySelector(`button[onclick="deleteProduct(${id})"]`).closest('.product-item');
                    if (item) {
                        item.classList.add('opacity-0', 'transition-all', 'duration-500', '-translate-x-full');
                        setTimeout(() => item.remove(), 500);
                    }
                } else {
                    alert('Lỗi: ' + result.message);
                }
            } catch (error) {
                console.error('Error deleting product:', error);
            }
        }
    </script>

</body>
</html>
