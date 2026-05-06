<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="url" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="vi" style="height: 100%; overflow: hidden;">
<head>
    <meta charset="UTF-8">
    <title>Xếp hạng khách hàng | S-Mall</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        html, body { height: 100%; margin: 0; overflow: hidden; font-family: 'Inter', sans-serif; background: #f8fafc; }
        .custom-scrollbar::-webkit-scrollbar { width: 4px; }
        .custom-scrollbar::-webkit-scrollbar-thumb { background: #e2e8f0; border-radius: 10px; }
        #ai-sidebar { transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1); transform: translateX(100%); width: 0; opacity: 0; visibility: hidden; }
        #ai-sidebar.open { transform: translateX(0); width: 400px; opacity: 1; visibility: visible; }
        .bubble-ai { background: #f0fdf4; color: #065f46; border: 1px solid #dcfce7; }
        .bubble-user { background: #10b981; color: #ffffff; border: none; }
        .robot-fab { position: fixed; bottom: 30px; right: 30px; width: 56px; height: 56px; background: #10b981; color: white; border-radius: 18px; display: flex; align-items: center; justify-content: center; font-size: 22px; cursor: pointer; z-index: 1000; box-shadow: 0 10px 20px rgba(16, 185, 129, 0.3); transition: all 0.3s ease; }
        .robot-fab:hover { transform: scale(1.05) translateY(-2px); }
        .robot-fab.hidden-fab { display: none; }
        .rank-card { transition: all 0.3s ease; }
        .rank-card:hover { transform: translateY(-8px); }
        .gold-card { background: linear-gradient(180deg, #FFD700 0%, #FFB900 100%); }
        .silver-card { background: linear-gradient(180deg, #94A3B8 0%, #64748B 100%); }
        .bronze-card { background: linear-gradient(180deg, #F97316 0%, #EA580C 100%); }
    </style>
</head>
<body class="text-slate-600">
    <jsp:include page="/WEB-INF/view/seller/layout/sidebar.jsp" />

    <div id="ai-toggle" class="robot-fab" onclick="toggleAI()">
        <i class="fas fa-robot"></i>
    </div>

    <div id="main-content" class="md:pl-64 flex h-screen overflow-hidden transition-all duration-300 ease-in-out">
        <div class="flex-1 flex flex-col p-8 overflow-y-auto custom-scrollbar">
            <header class="flex items-center justify-between mb-10">
                <div class="flex items-center gap-4">
                    <button onclick="toggleSidebar()" class="w-10 h-10 bg-white shadow-sm border border-slate-100 rounded-xl flex items-center justify-center text-slate-400 hover:text-emerald-500 hover:border-emerald-100 transition-all">
                        <i class="fas fa-bars"></i>
                    </button>
                    <h1 class="text-xl font-bold text-slate-800">Xếp hạng khách hàng</h1>
                </div>
                <div class="relative">
                    <input type="text" placeholder="Tìm kiếm khách hàng..." class="pl-12 pr-6 py-2.5 bg-white border border-slate-100 rounded-2xl text-sm w-72 focus:outline-none focus:ring-4 focus:ring-emerald-500/5 focus:border-emerald-500 transition-all shadow-sm">
                    <i class="fas fa-search absolute left-4 top-3.5 text-slate-300 text-sm"></i>
                </div>
            </header>

            <!-- Top 3 Ranking Section -->
            <div class="mb-12">
                <div class="flex items-center gap-2 mb-8">
                    <i class="fas fa-crown text-yellow-500"></i>
                    <h2 class="text-lg font-bold text-slate-800">Top 3 Khách Hàng Xuất Sắc</h2>
                </div>

                <div class="flex items-end justify-center gap-6">
                    <!-- Rank 2 -->
                    <c:if test="${fn:length(customers) >= 2}">
                        <c:set var="c2" value="${customers[1]}" />
                        <div class="rank-card silver-card w-64 rounded-[32px] p-1 shadow-xl shadow-slate-400/20">
                            <div class="bg-slate-700/10 rounded-[31px] p-6 text-center text-white">
                                <div class="relative inline-block mb-4">
                                    <c:choose>
                                        <c:when test="${not empty c2.avatarUrl}"><img src="${c2.avatarUrl}" class="w-20 h-20 rounded-full border-4 border-white/30 object-cover shadow-lg"></c:when>
                                        <c:otherwise><div class="w-20 h-20 rounded-full bg-white/20 flex items-center justify-center text-2xl font-bold border-4 border-white/30">${fn:substring(c2.fullName, 0, 1)}</div></c:otherwise>
                                    </c:choose>
                                    <div class="absolute -top-2 -right-2 w-8 h-8 rounded-full bg-white text-slate-600 font-bold flex items-center justify-center text-sm shadow-md">2</div>
                                </div>
                                <h3 class="font-bold text-lg mb-1 truncate px-2">${c2.fullName}</h3>
                                <p class="text-white/60 text-[10px] mb-6">${c2.email}</p>
                                <div class="bg-white/10 rounded-2xl p-4">
                                    <span class="block text-[10px] text-white/60 uppercase font-bold mb-1">Tổng chi tiêu</span>
                                    <span class="text-xl font-bold italic"><fmt:formatNumber value="${c2.totalSpent}" type="currency" currencySymbol="₫" maxFractionDigits="0" /></span>
                                </div>
                                <div class="flex justify-center gap-3 mt-4">
                                    <div class="bg-white/5 rounded-xl px-3 py-2">
                                        <span class="block text-[9px] opacity-60">Đơn hàng</span>
                                        <span class="font-bold text-sm">${c2.totalOrders}</span>
                                    </div>
                                    <div class="bg-white/5 rounded-xl px-3 py-2">
                                        <span class="block text-[9px] opacity-60">Điểm</span>
                                        <span class="font-bold text-sm">${c2.points}</span>
                                    </div>
                                </div>
                                <div class="mt-3 bg-white/10 border border-white/10 rounded-xl px-3 py-2">
                                    <span class="block text-[9px] opacity-70 uppercase font-bold">Hạng</span>
                                    <span class="font-bold text-xs">${c2.membershipRank}</span>
                                </div>
                            </div>
                        </div>
                    </c:if>

                    <!-- Rank 1 -->
                    <c:if test="${fn:length(customers) >= 1}">
                        <c:set var="c1" value="${customers[0]}" />
                        <div class="rank-card gold-card w-72 rounded-[40px] p-1 shadow-2xl shadow-yellow-500/30 -translate-y-4">
                            <div class="bg-white/5 rounded-[39px] p-8 text-center text-white">
                                <div class="relative inline-block mb-6">
                                    <c:choose>
                                        <c:when test="${not empty c1.avatarUrl}"><img src="${c1.avatarUrl}" class="w-24 h-24 rounded-full border-4 border-white/50 object-cover shadow-xl"></c:when>
                                        <c:otherwise><div class="w-24 h-24 rounded-full bg-white/30 flex items-center justify-center text-3xl font-black border-4 border-white/50 shadow-inner">${fn:substring(c1.fullName, 0, 1)}</div></c:otherwise>
                                    </c:choose>
                                    <div class="absolute -top-3 -right-3 w-12 h-12 rounded-full bg-white text-yellow-600 font-black flex items-center justify-center shadow-lg border-4 border-yellow-100">
                                        <i class="fas fa-crown"></i>
                                    </div>
                                </div>
                                <h3 class="font-extrabold text-2xl mb-1 truncate px-2">${c1.fullName}</h3>
                                <p class="text-white/70 text-xs mb-8">${c1.email}</p>
                                <div class="bg-white/20 rounded-[28px] p-6 backdrop-blur-sm border border-white/10">
                                    <span class="block text-xs text-white/60 uppercase font-bold mb-2">Tổng chi tiêu</span>
                                    <span class="text-2xl font-black italic"><fmt:formatNumber value="${c1.totalSpent}" type="currency" currencySymbol="₫" maxFractionDigits="0" /></span>
                                </div>
                                <div class="flex justify-center gap-4 mt-6">
                                    <div class="bg-white/10 rounded-2xl px-4 py-3">
                                        <span class="block text-[10px] opacity-70">Đơn hàng</span>
                                        <span class="font-bold text-lg">${c1.totalOrders}</span>
                                    </div>
                                    <div class="bg-white/10 rounded-2xl px-4 py-3">
                                        <span class="block text-[10px] opacity-70">Điểm</span>
                                        <span class="font-bold text-lg">${c1.points}</span>
                                    </div>
                                </div>
                                <div class="mt-4 bg-white/20 border border-white/20 rounded-2xl px-4 py-3">
                                    <span class="block text-[10px] opacity-80 uppercase font-black">Hạng</span>
                                    <span class="font-black text-sm">${c1.membershipRank}</span>
                                </div>
                            </div>
                        </div>
                    </c:if>

                    <!-- Rank 3 -->
                    <c:if test="${fn:length(customers) >= 3}">
                        <c:set var="c3" value="${customers[2]}" />
                        <div class="rank-card bronze-card w-64 rounded-[32px] p-1 shadow-xl shadow-orange-500/20">
                            <div class="bg-orange-700/10 rounded-[31px] p-6 text-center text-white">
                                <div class="relative inline-block mb-4">
                                    <c:choose>
                                        <c:when test="${not empty c3.avatarUrl}"><img src="${c3.avatarUrl}" class="w-20 h-20 rounded-full border-4 border-white/30 object-cover shadow-lg"></c:when>
                                        <c:otherwise><div class="w-20 h-20 rounded-full bg-white/20 flex items-center justify-center text-2xl font-bold border-4 border-white/30">${fn:substring(c3.fullName, 0, 1)}</div></c:otherwise>
                                    </c:choose>
                                    <div class="absolute -top-2 -right-2 w-8 h-8 rounded-full bg-white text-orange-600 font-bold flex items-center justify-center text-sm shadow-md">3</div>
                                </div>
                                <h3 class="font-bold text-lg mb-1 truncate px-2">${c3.fullName}</h3>
                                <p class="text-white/60 text-[10px] mb-6">${c3.email}</p>
                                <div class="bg-white/10 rounded-2xl p-4">
                                    <span class="block text-[10px] text-white/60 uppercase font-bold mb-1">Tổng chi tiêu</span>
                                    <span class="text-xl font-bold italic"><fmt:formatNumber value="${c3.totalSpent}" type="currency" currencySymbol="₫" maxFractionDigits="0" /></span>
                                </div>
                                <div class="flex justify-center gap-3 mt-4">
                                    <div class="bg-white/5 rounded-xl px-3 py-2">
                                        <span class="block text-[9px] opacity-60">Đơn hàng</span>
                                        <span class="font-bold text-sm">${c3.totalOrders}</span>
                                    </div>
                                    <div class="bg-white/5 rounded-xl px-3 py-2">
                                        <span class="block text-[9px] opacity-60">Điểm</span>
                                        <span class="font-bold text-sm">${c3.points}</span>
                                    </div>
                                </div>
                                <div class="mt-3 bg-white/10 border border-white/10 rounded-xl px-3 py-2">
                                    <span class="block text-[9px] opacity-70 uppercase font-bold">Hạng</span>
                                    <span class="font-bold text-xs">${c3.membershipRank}</span>
                                </div>
                            </div>
                        </div>
                    </c:if>
                </div>
            </div>

            <!-- Khách hàng khác Section -->
            <div class="mb-8">
                <div class="flex items-center gap-2 mb-8">
                    <i class="fas fa-user-group text-emerald-500"></i>
                    <h2 class="text-lg font-bold text-slate-800">Khách Hàng Khác</h2>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                    <c:forEach var="customer" items="${customers}" varStatus="status">
                        <c:if test="${status.index > 2}">
                            <div class="bg-white p-8 rounded-[32px] border border-slate-100 shadow-sm hover:shadow-xl hover:border-emerald-100 transition-all text-center group">
                                <div class="flex justify-between items-center mb-6">
                                    <span class="text-xs font-bold text-slate-400 bg-slate-50 px-3 py-1 rounded-full">#${status.index + 1}</span>
                                    <div class="w-8 h-8 bg-slate-50 rounded-full flex items-center justify-center text-slate-300">
                                        <i class="fas fa-medal text-xs"></i>
                                    </div>
                                </div>
                                <div class="mx-auto mb-4">
                                    <c:choose>
                                        <c:when test="${not empty customer.avatarUrl}">
                                            <img src="${customer.avatarUrl}" class="w-20 h-20 rounded-full border-4 border-white shadow-md mx-auto object-cover">
                                        </c:when>
                                        <c:otherwise>
                                            <div class="w-20 h-20 rounded-full bg-emerald-50 flex items-center justify-center text-emerald-600 text-2xl font-bold mx-auto border-4 border-white shadow-inner">
                                                ${fn:substring(customer.fullName, 0, 1)}
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <h4 class="font-bold text-slate-800 mb-1">${customer.fullName}</h4>
                                <p class="text-[10px] text-slate-400 mb-6">${customer.email}</p>

                                <div class="flex justify-between items-center mb-4 px-4">
                                    <div class="text-left">
                                        <span class="block text-[10px] text-slate-400 font-bold uppercase">Tổng chi tiêu</span>
                                        <span class="text-sm font-bold text-emerald-600">
                                            <fmt:formatNumber value="${customer.totalSpent}" type="currency" currencySymbol="₫" maxFractionDigits="0" />
                                        </span>
                                    </div>
                                    <div class="flex gap-2">
                                        <div class="bg-slate-50 rounded-xl px-3 py-2">
                                            <span class="block text-[8px] text-slate-400">Đơn</span>
                                            <span class="font-bold text-xs">${customer.totalOrders}</span>
                                        </div>
                                        <div class="bg-slate-50 rounded-xl px-3 py-2">
                                            <span class="block text-[8px] text-slate-400">Điểm</span>
                                            <span class="font-bold text-xs">${customer.points}</span>
                                        </div>
                                    </div>
                                </div>
                                <div class="mx-4 mb-6 bg-emerald-50 border border-emerald-100 rounded-xl px-3 py-2 text-center">
                                    <span class="block text-[8px] text-emerald-500 font-bold uppercase">Hạng</span>
                                    <span class="font-bold text-[10px] text-emerald-700">${customer.membershipRank}</span>
                                </div>

                                <button onclick="analyzeDirectly('${customer.fullName}', '${customer.email}')"
                                        class="w-full py-3 bg-[#10b981] text-white rounded-2xl font-bold text-xs shadow-lg shadow-emerald-500/20 hover:scale-[1.02] active:scale-95 transition-all">
                                    Xem chi tiết
                                </button>
                            </div>
                        </c:if>
                    </c:forEach>
                </div>
            </div>
        </div>

        <!-- AI Sidebar -->
        <div id="ai-sidebar" class="bg-white border-l border-slate-100 flex flex-col shadow-2xl z-50">
            <div class="p-6 border-b border-slate-50 flex items-center justify-between">
                <div class="flex items-center gap-3">
                    <div class="w-10 h-10 bg-emerald-500 rounded-xl flex items-center justify-center text-white shadow-lg shadow-emerald-500/20">
                        <i class="fas fa-robot"></i>
                    </div>
                    <div>
                        <span class="block font-bold text-slate-800 text-sm">SMall AI</span>
                        <span class="block text-[10px] text-emerald-500 font-bold uppercase tracking-wider">Online</span>
                    </div>
                </div>
                <div class="flex items-center gap-2">
                    <button onclick="refreshChat()" class="w-8 h-8 rounded-lg flex items-center justify-center text-slate-300 hover:text-emerald-500 hover:bg-emerald-50 transition-all" title="Phiên mới">
                        <i class="fas fa-rotate-right text-xs"></i>
                    </button>
                    <button onclick="toggleAI()" class="text-slate-300 hover:text-slate-500 transition-colors">
                        <i class="fas fa-times text-sm"></i>
                    </button>
                </div>
            </div>

            <div id="chat-scroller" class="flex-1 overflow-y-auto p-6 custom-scrollbar bg-slate-50/30">
                <div id="history" class="flex flex-col gap-4">
                    <div class="self-start max-w-[85%]">
                        <div class="px-5 py-4 rounded-[24px] bubble-ai text-sm shadow-sm leading-relaxed">
                            Xin chào! Tôi là <b>SMall AI</b> — trợ lý thông minh của cửa hàng bạn. Hãy hỏi tôi về khách hàng, doanh thu hoặc Voucher nhé!
                        </div>
                    </div>
                </div>
                <div id="loading" class="hidden mt-4 pl-2">
                    <div class="flex gap-1.5">
                        <div class="w-1.5 h-1.5 bg-emerald-400 rounded-full animate-bounce"></div>
                        <div class="w-1.5 h-1.5 bg-emerald-400 rounded-full animate-bounce [animation-delay:0.2s]"></div>
                        <div class="w-1.5 h-1.5 bg-emerald-400 rounded-full animate-bounce [animation-delay:0.4s]"></div>
                    </div>
                </div>
            </div>

            <div class="p-6 bg-white border-t border-slate-50">
                <div class="bg-slate-50 rounded-[22px] p-1.5 flex items-center gap-2 border border-slate-100 focus-within:border-emerald-500/30 focus-within:bg-white transition-all">
                    <input id="ai-input" type="text" placeholder="Nhập câu hỏi..."
                           class="flex-1 bg-transparent border-none text-sm text-slate-700 px-4 py-2 focus:ring-0 outline-none placeholder:text-slate-400">
                    <button onclick="send()" class="w-10 h-10 bg-emerald-500 text-white rounded-[18px] flex items-center justify-center hover:bg-emerald-600 transition-all shadow-lg shadow-emerald-500/20">
                        <i class="fas fa-paper-plane text-xs"></i>
                    </button>
                </div>
            </div>
        </div>
    </div>

    <script>
        const sidebar = document.getElementById('ai-sidebar');
        const fab = document.getElementById('ai-toggle');
        const historyDiv = document.getElementById('history');
        const scroller = document.getElementById('chat-scroller');
        const input = document.getElementById('ai-input');
        const loading = document.getElementById('loading');
        let currentSessionId = null;

        (async () => {
            try {
                const res = await fetch('${url}/api/seller/ai/history');
                const data = await res.json();
                if (data.sessionId) currentSessionId = data.sessionId;
                if (data.history) data.history.forEach(m => appendMsg(m.content, m.role === 'USER' || m.role === 'user'));
            } catch(e) {}
        })();




        function toggleAI() {
            sidebar.classList.toggle('open');
            fab.classList.toggle('hidden-fab');
            setTimeout(() => { scroller.scrollTop = scroller.scrollHeight; }, 400);
        }

        async function refreshChat() {
            currentSessionId = null;
            historyDiv.innerHTML = '<div class="flex w-full justify-start mb-2"><div class="px-5 py-4 max-w-[85%] rounded-[24px] rounded-tl-none bubble-ai text-sm shadow-sm leading-relaxed">Phiên mới! Hãy hỏi tôi bất cứ điều gì nhé!</div></div>';
            try {
                var res = await fetch('${url}/api/seller/ai/session', { method: 'POST' });
                var data = await res.json();
                if (data.id) currentSessionId = data.id;
            } catch(e) {}
        }

        function analyzeDirectly(name, email) {
            if(!sidebar.classList.contains('open')) toggleAI();
            input.value = "Phân tích khách hàng: " + name;
            send();
        }

        async function send() {
            const msg = input.value.trim();
            if(!msg) return;
            appendMsg(msg, true);
            input.value = '';
            input.focus();
            loading.classList.remove('hidden');
            scroller.scrollTop = scroller.scrollHeight;
            try {
                const res = await fetch('${url}/api/seller/ai/chat', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ message: msg })
                });
                const data = await res.json();
                loading.classList.add('hidden');
                appendMsg(data.finalResponse || "Lỗi phản hồi từ AI.", false);
            } catch (err) {
                loading.classList.add('hidden');
                appendMsg("Lỗi kết nối: " + err.message, false);
            }
        }

        function appendMsg(text, isUser) {
            if (!text) return;
            const container = document.createElement('div');
            container.className = 'flex w-full mb-2 ' + (isUser ? 'justify-end' : 'justify-start');
            const bubbleDiv = document.createElement('div');
            bubbleDiv.className = 'px-5 py-4 max-w-[85%] rounded-[24px] shadow-sm text-sm whitespace-pre-line leading-relaxed ' + (isUser ? 'bubble-user rounded-tr-none' : 'bubble-ai rounded-tl-none');
            bubbleDiv.textContent = text;
            container.appendChild(bubbleDiv);
            historyDiv.appendChild(container);
            container.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
        }

        input.addEventListener('keydown', (e) => { if(e.key === 'Enter') { e.preventDefault(); send(); } });
    </script>
</body>
</html>