<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="url" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html style="height: 100%; overflow: hidden;">
<head>
    <meta charset="UTF-8">
    <title>AI Agent | S-Mall</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        /* CSS Reset triệt để */
        html, body { 
            height: 100% !important; 
            margin: 0 !important; 
            padding: 0 !important; 
            overflow: hidden !important; 
            background: #0F172A !important;
        }
        #viewport {
            display: flex;
            height: 100vh;
            width: 100vw;
            overflow: hidden;
        }
        #chat-panel {
            width: 400px;
            height: 100%;
            display: flex;
            flex-direction: column;
            border-left: 1px solid rgba(255,255,255,0.1);
            background: red !important;
            flex-shrink: 0;
        }
        #chat-messages {
            flex: 1;
            overflow-y: auto;
            padding: 20px;
        }
        /* Tùy chỉnh thanh cuộn nội bộ */
        #chat-messages::-webkit-scrollbar { width: 4px; }
        #chat-messages::-webkit-scrollbar-thumb { background: #10B981; border-radius: 10px; }
    </style>
</head>
<body>
    <div id="viewport">
        <!-- Sidebar -->
        <jsp:include page="../layout/sidebar.jsp" />

        <!-- Main Dashboard -->
        <div class="flex-1 p-10 overflow-y-auto bg-[#0F172A]">
            <h1 class="text-2xl font-bold text-white mb-6">Phân tích khách hàng</h1>
            <div class="bg-slate-800/50 rounded-3xl p-8 border border-white/5">
                <table class="w-full text-sm text-slate-300">
                    <tr class="border-b border-white/5 text-slate-500 uppercase text-[10px] tracking-widest">
                        <th class="text-left py-4">Khách hàng</th>
                        <th class="text-left py-4">Chi tiêu</th>
                        <th class="text-right py-4">Action</th>
                    </tr>
                    <tr>
                        <td class="py-4 font-bold text-white">Nguyen Thanh Dat</td>
                        <td class="py-4 text-emerald-400 font-bold">152,989,000đ</td>
                        <td class="text-right"><button class="text-slate-500"><i class="fas fa-paper-plane"></i></button></td>
                    </tr>
                </table>
            </div>
        </div>

        <!-- AI Panel (Cố định chiều cao) -->
        <div id="chat-panel">
            <div class="p-6 border-b border-white/10 flex justify-between items-center bg-slate-900">
                <div class="flex items-center gap-3">
                    <div class="w-8 h-8 rounded-lg bg-emerald-500 flex items-center justify-center text-white"><i class="fas fa-robot"></i></div>
                    <div>
                        <span class="font-bold text-white text-sm block">SMall AI</span>
                        <span class="text-[10px] text-emerald-400">● Đang hoạt động</span>
                    </div>
                </div>
                <button onclick="location.reload()" class="text-xs text-slate-500 hover:text-white transition-colors"><i class="fas fa-rotate-right mr-1"></i>Làm mới</button>
            </div>

            <div id="chat-messages" class="space-y-6">
                <!-- Tin nhắn bot -->
                <div class="flex gap-2 items-end">
                    <div class="w-7 h-7 rounded-full bg-emerald-600 flex items-center justify-center text-[9px] font-bold text-white shrink-0">AI</div>
                    <div class="bg-slate-800 p-3 rounded-2xl rounded-bl-none text-xs text-slate-300 max-w-[80%] leading-relaxed">
                        Xin chào! Tôi là <strong class="text-emerald-400">SMall AI</strong> — trợ lý thông minh của cửa hàng bạn. Hãy hỏi tôi bất cứ điều gì nhé!
                    </div>
                </div>
                <div id="history"></div>
            </div>

            <!-- Input Area -->
            <div class="p-4 bg-slate-900 border-t border-white/10">
                <div class="flex gap-2 bg-slate-800 rounded-xl p-2 items-center">
                    <input id="prompt" type="text" placeholder="Nhập câu hỏi..." class="flex-1 bg-transparent border-none text-xs text-white focus:ring-0 focus:outline-none placeholder-slate-500" onkeydown="if(event.key==='Enter') chat()">
                    <button onclick="chat()" class="bg-emerald-600 hover:bg-emerald-500 transition-colors p-2 rounded-lg text-white"><i class="fas fa-paper-plane text-xs"></i></button>
                </div>
            </div>
        </div>
    </div>

    <script>
        async function chat() {
            const input = document.getElementById('prompt');
            const val = input.value.trim();
            if(!val) return;
            
            append(val, true);
            input.value = '';

            const res = await fetch('${url}/api/seller/ai/chat', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(val)
            });
            const data = await res.json();
            append(data.finalResponse, false);
            
            const box = document.getElementById('chat-messages');
            box.scrollTop = box.scrollHeight;
        }

        function append(txt, isMe) {
            const h = document.getElementById('history');
            // User → bên PHẢI (justify-end), AI → bên TRÁI (flex gap)
            const html = isMe 
                ? `<div class="flex justify-end mb-3 items-end">
                       <div class="bg-emerald-600 text-white p-3 rounded-2xl rounded-br-none text-xs max-w-[80%] leading-relaxed">${txt}</div>
                   </div>`
                : `<div class="flex gap-2 mb-3 items-end">
                       <div class="w-7 h-7 rounded-full bg-emerald-600 flex items-center justify-center text-[9px] font-bold text-white shrink-0">AI</div>
                       <div class="bg-slate-800 p-3 rounded-2xl rounded-bl-none text-xs text-slate-300 whitespace-pre-line max-w-[80%] leading-relaxed">${txt}</div>
                   </div>`;
            h.innerHTML += html;
        }

        // Load history
        fetch('${url}/api/seller/ai/history').then(r => r.json()).then(data => {
            data.forEach(m => append(m.content, m.role === 'USER'));
            const box = document.getElementById('chat-messages');
            box.scrollTop = box.scrollHeight;
        });
    </script>
</body>
</html>
