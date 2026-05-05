<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="url" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="vi" style="height: 100%; overflow: hidden;">
<head>
    <meta charset="UTF-8">
    <title>Khách hàng đã mua | S-Mall</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        html, body { height: 100%; margin: 0; overflow: hidden; font-family: 'Inter', sans-serif; background: #f8fafc; }
        .custom-scrollbar::-webkit-scrollbar { width: 4px; }
        .custom-scrollbar::-webkit-scrollbar-thumb { background: #cbd5e1; border-radius: 10px; }
        
        #ai-sidebar { 
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1); 
            transform: translateX(100%); 
            width: 0; opacity: 0; visibility: hidden;
        }
        #ai-sidebar.open { transform: translateX(0); width: 450px; opacity: 1; visibility: visible; }
        
        .ai-chat-gradient { background: #0f172a; }
        .bubble-ai { background: #1e293b; color: #f1f5f9; border: 1px solid rgba(255,255,255,0.05); }
        .bubble-user { background: #10b981; color: white; }

        .robot-fab {
            position: fixed; bottom: 30px; right: 30px; width: 60px; height: 60px;
            background: #10b981; color: white; border-radius: 20px;
            display: flex; align-items: center; justify-content: center;
            font-size: 24px; cursor: pointer; z-index: 1000;
            box-shadow: 0 10px 25px rgba(16, 185, 129, 0.4);
            transition: all 0.3s ease;
        }
        .robot-fab:hover { transform: scale(1.1); }
        .robot-fab.hidden-fab { display: none; }
    </style>
</head>
<body class="text-slate-600">
    <jsp:include page="/WEB-INF/view/seller/layout/sidebar.jsp" />

    <div id="ai-toggle" class="robot-fab" onclick="toggleAI()">
        <i class="fas fa-robot"></i>
    </div>

    <div class="md:pl-64 flex h-screen overflow-hidden">
        <!-- Main Content -->
        <div class="flex-1 flex flex-col p-8 overflow-y-auto custom-scrollbar">
            <!-- Header -->
            <header class="mb-10">
                <h1 class="text-2xl font-bold text-slate-900">Khách hàng đã mua</h1>
                <p class="text-slate-500 text-sm mt-1">Phân tích hành vi mua sắm và tối ưu hóa chuyển đổi bằng AI.</p>
            </header>

            <!-- Table Header Section -->
            <div class="flex items-center justify-between mb-6">
                <h2 class="text-lg font-semibold text-slate-800">Top khách hàng mua sắm</h2>
                <div class="relative">
                    <input type="text" placeholder="Tìm khách hàng..." 
                           class="pl-4 pr-10 py-2 bg-white border border-slate-200 rounded-xl text-sm w-64 focus:outline-none focus:ring-2 focus:ring-emerald-500/20 focus:border-emerald-500 transition-all">
                    <i class="fas fa-search absolute right-3 top-3 text-slate-400 text-xs"></i>
                </div>
            </div>

            <!-- Table Section -->
            <div class="bg-white rounded-3xl shadow-sm border border-slate-200 overflow-hidden">
                <table class="w-full text-left text-sm">
                    <thead class="bg-white border-b border-slate-100">
                        <tr class="text-[10px] font-bold text-slate-400 uppercase tracking-wider">
                            <th class="px-8 py-5">Khách hàng</th>
                            <th class="px-8 py-5">Đơn hàng</th>
                            <th class="px-8 py-5">Tổng chi tiêu</th>
                            <th class="px-8 py-5">Mua lần cuối</th>
                            <th class="px-8 py-5">Thao tác</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-slate-50">
                        <c:choose>
                            <c:when test="${not empty customers}">
                                <c:forEach var="customer" items="${customers}">
                                    <tr class="hover:bg-slate-50/50 transition-colors">
                                        <td class="px-8 py-5">
                                            <div class="flex items-center gap-3">
                                                <div class="w-8 h-8 rounded-full bg-slate-100 flex items-center justify-center text-slate-400">
                                                    <i class="fas fa-user text-xs"></i>
                                                </div>
                                                <span class="font-medium text-slate-700">${customer.fullName}</span>
                                            </div>
                                        </td>
                                        <td class="px-8 py-5 text-slate-600 font-medium">${customer.totalOrders} đơn</td>
                                        <td class="px-8 py-5 font-bold text-slate-900">
                                            <fmt:formatNumber value="${customer.totalSpent}" type="currency" currencySymbol="₫" />
                                        </td>
                                        <td class="px-8 py-5 text-slate-500">
                                            <c:out value="${fn:replace(customer.lastOrderDate, 'T', ' ')}" />
                                        </td>
                                        <td class="px-8 py-5">
                                            <button onclick="analyzeDirectly('${customer.fullName}', '${customer.email}')" 
                                                    class="w-8 h-8 rounded-lg bg-emerald-50 text-emerald-600 flex items-center justify-center hover:bg-emerald-600 hover:text-white transition-all">
                                                <i class="fas fa-brain text-xs"></i>
                                            </button>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <!-- Empty State (Matching Screenshot) -->
                                <tr>
                                    <td colspan="5" class="py-32">
                                        <div class="flex flex-col items-center justify-center text-center">
                                            <div class="w-16 h-16 bg-slate-100 rounded-2xl flex items-center justify-center mb-4">
                                                <i class="fas fa-users-slash text-2xl text-slate-300"></i>
                                            </div>
                                            <h3 class="text-slate-900 font-bold">Chưa có khách hàng nào</h3>
                                            <p class="text-slate-500 text-sm mt-1 max-w-xs">Các khách hàng đã mua sản phẩm sẽ xuất hiện tại đây.</p>
                                        </div>
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- AI Panel (Right Side) -->
        <div id="ai-sidebar" class="ai-chat-gradient flex flex-col shadow-2xl z-50">
            <!-- AI Header -->
            <div class="p-6 border-b border-white/5 flex items-center justify-between">
                <div class="flex items-center gap-3">
                    <div class="w-10 h-10 bg-emerald-500 rounded-xl flex items-center justify-center text-white shadow-lg shadow-emerald-500/20">
                        <i class="fas fa-robot"></i>
                    </div>
                    <div>
                        <span class="block font-bold text-white text-sm">S-Mall Advisor</span>
                        <span class="block text-[10px] text-emerald-400 font-medium">Online • Trợ lý AI</span>
                    </div>
                </div>
                <button onclick="toggleAI()" class="w-8 h-8 flex items-center justify-center text-slate-500 hover:text-white transition-colors">
                    <i class="fas fa-times"></i>
                </button>
            </div>

            <!-- Messages Area -->
            <div id="chat-scroller" class="flex-1 overflow-y-auto p-6 custom-scrollbar">
                <div id="history" class="flex flex-col gap-6">
                    <!-- Default Greeting -->
                    <div class="flex flex-col items-start max-w-[90%]">
                        <div class="px-4 py-3 rounded-2xl bubble-ai text-sm shadow-sm leading-relaxed">
                            Chào bạn! Tôi có thể giúp gì cho chiến dịch Marketing của bạn?
                        </div>
                    </div>
                </div>
                <div id="loading" class="hidden mt-4">
                    <div class="flex items-center gap-2">
                        <div class="flex gap-1">
                            <div class="w-1 h-1 bg-emerald-400 rounded-full animate-bounce"></div>
                            <div class="w-1 h-1 bg-emerald-400 rounded-full animate-bounce [animation-delay:0.2s]"></div>
                            <div class="w-1 h-1 bg-emerald-400 rounded-full animate-bounce [animation-delay:0.4s]"></div>
                        </div>
                        <span class="text-[10px] text-emerald-400 font-bold uppercase tracking-wider">AI đang phân tích...</span>
                    </div>
                </div>
            </div>

            <!-- Input Area -->
            <div class="p-6 bg-slate-900/50 border-t border-white/5">
                <div class="bg-white/5 rounded-2xl p-1.5 flex items-center gap-2 border border-white/10 focus-within:border-emerald-500/50 transition-all">
                    <input id="ai-input" type="text" placeholder="Nhập câu hỏi..." 
                           class="flex-1 bg-transparent border-none text-sm text-white px-4 py-2 focus:ring-0 outline-none placeholder:text-slate-500">
                    <button onclick="send()" class="w-10 h-10 bg-emerald-600 text-white rounded-xl flex items-center justify-center hover:bg-emerald-500 transition-all shadow-lg shadow-emerald-600/20">
                        <i class="fas fa-paper-plane text-sm"></i>
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

        function toggleAI() {
            sidebar.classList.toggle('open');
            fab.classList.toggle('hidden-fab');
            setTimeout(() => { scroller.scrollTop = scroller.scrollHeight; }, 400);
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
                
                const finalContent = data.finalResponse || "Xin lỗi, tôi không thể xử lý yêu cầu này.";
                appendMsg(finalContent, false);
            } catch (err) {
                loading.classList.add('hidden');
                appendMsg("Lỗi kết nối: " + err.message, false);
            }
        }

        function appendMsg(text, isUser) {
            if (!text) return;
            const msgDiv = document.createElement('div');
            msgDiv.className = `flex flex-col ${isUser ? 'items-end ml-auto' : 'items-start'} max-w-[90%]`;
            const bubbleDiv = document.createElement('div');
            bubbleDiv.className = `px-4 py-3 rounded-2xl shadow-sm text-sm whitespace-pre-line leading-relaxed ${isUser ? 'bubble-user' : 'bubble-ai'}`;
            bubbleDiv.textContent = text;
            msgDiv.appendChild(bubbleDiv);
            historyDiv.appendChild(msgDiv);
            msgDiv.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
        }

        input.addEventListener('keydown', (e) => {
            if(e.key === 'Enter') {
                e.preventDefault();
                send();
            }
        });

        // Load History Init
        (async () => {
            try {
                const res = await fetch('${url}/api/seller/ai/history');
                const data = await res.json();
                data.forEach(m => appendMsg(m.content, m.role === 'USER' || m.role === 'user'));
            } catch(e) {}
        })();
    </script>
</body>
</html>