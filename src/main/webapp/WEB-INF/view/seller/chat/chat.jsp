<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="url" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>S-Mall | Chat với khách hàng</title>

    <!-- Tailwind & Alpine (giống Dashboard) -->
    <script src="https://cdn.tailwindcss.com"></script>
    <script defer src="https://unpkg.com/alpinejs@3.x.x/dist/cdn.min.js"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        'small-emerald': '#065F46',
                        'small-navy': '#0F172A',
                    }
                }
            }
        }
    </script>

    <style>
        body { font-family: 'Inter', sans-serif; }
        .chat-bubble-in {
            background: #f1f5f9;
            border-radius: 18px 18px 18px 4px;
        }
        .chat-bubble-out {
            background: linear-gradient(135deg, #10B981 0%, #059669 100%);
            color: white;
            border-radius: 18px 18px 4px 18px;
        }
        .room-active {
            background: rgba(16, 185, 129, 0.08);
            border-left: 3px solid #10B981;
        }
        .scrollbar-hide::-webkit-scrollbar { display: none; }
    </style>
</head>
<body class="bg-slate-50">

    <!-- Sidebar -->
    <jsp:include page="/WEB-INF/view/seller/layout/sidebar.jsp" />

    <!-- Main Content -->
    <div id="main-content" class="md:pl-64 flex flex-col min-h-screen transition-all duration-300 ease-in-out">

        <!-- Header -->
        <header class="sticky top-0 z-10 bg-white/80 backdrop-blur-xl border-b border-slate-200/60 px-8 py-6">
            <div class="flex items-center justify-between">
                <div class="flex items-center gap-4">
                    <button onclick="toggleSidebar()" class="w-10 h-10 bg-white shadow-sm border border-slate-100 rounded-xl flex items-center justify-center text-slate-400 hover:text-emerald-500 hover:border-emerald-100 transition-all">
                        <i class="fas fa-bars"></i>
                    </button>
                    <div>
                        <h1 class="text-2xl font-bold text-small-navy tracking-tight">
                            <i class="fas fa-comments text-emerald-500 mr-2"></i>Chat với khách hàng
                        </h1>
                        <p class="text-sm text-slate-500">Trả lời tin nhắn từ khách hàng của bạn</p>
                    </div>
                </div>
            </div>
        </header>

        <!-- Chat Layout -->
        <main class="flex-1 flex p-4 gap-4" style="height: calc(100vh - 100px);">

            <!-- Room List -->
            <div class="w-80 bg-white rounded-2xl border border-slate-100 flex flex-col overflow-hidden shadow-sm">
                <div class="p-4 border-b border-slate-100">
                    <div class="relative">
                        <i class="fas fa-search absolute left-3 top-1/2 -translate-y-1/2 text-slate-400 text-sm"></i>
                        <input type="text" id="sellerSearchInput" placeholder="Tìm khách hàng..."
                               class="w-full pl-9 pr-4 py-2.5 bg-slate-50 border border-slate-200 rounded-xl text-sm outline-none focus:border-emerald-400 transition-colors">
                    </div>
                </div>
                <div class="flex-1 overflow-y-auto scrollbar-hide" id="sellerRoomList">
                    <div class="flex items-center justify-center py-12 text-slate-400">
                        <i class="fas fa-spinner fa-spin mr-2"></i> Đang tải...
                    </div>
                </div>
            </div>

            <!-- Chat Area -->
            <div class="flex-1 bg-white rounded-2xl border border-slate-100 flex flex-col overflow-hidden shadow-sm">
                <!-- Empty State -->
                <div class="flex-1 flex items-center justify-center" id="sellerEmptyState">
                    <div class="text-center">
                        <div class="w-20 h-20 bg-emerald-50 rounded-full flex items-center justify-center mx-auto mb-4">
                            <i class="fas fa-comments text-emerald-500 text-3xl"></i>
                        </div>
                        <h3 class="text-lg font-bold text-small-navy mb-2">Tin nhắn từ khách hàng</h3>
                        <p class="text-sm text-slate-400 max-w-xs">Chọn một cuộc trò chuyện để bắt đầu hỗ trợ khách hàng</p>
                    </div>
                </div>

                <!-- Chat Header (hidden) -->
                <div class="px-6 py-4 border-b border-slate-100 flex items-center gap-3" id="sellerChatHeader" style="display: none;">
                    <div class="w-10 h-10 bg-emerald-100 rounded-full flex items-center justify-center text-emerald-600 font-bold" id="sellerPartnerInitial">K</div>
                    <div>
                        <div class="font-bold text-small-navy" id="sellerPartnerName">Khách hàng</div>
                        <div class="text-xs text-emerald-500 font-semibold">Đang hoạt động</div>
                    </div>
                </div>

                <!-- Messages (hidden) -->
                <div class="flex-1 overflow-y-auto p-6 space-y-3 scrollbar-hide" id="sellerChatMessages" style="display: none;"></div>

                <!-- Input (hidden) -->
                <div class="px-6 py-4 border-t border-slate-100 flex items-center gap-3" id="sellerChatInput" style="display: none;">
                    <input type="text" id="sellerInput" placeholder="Nhập tin nhắn..."
                           class="flex-1 px-5 py-3 bg-slate-50 border border-slate-200 rounded-2xl text-sm outline-none focus:border-emerald-400 transition-colors"
                           autocomplete="off" maxlength="1000">
                    <button id="sellerSendBtn"
                            class="w-11 h-11 bg-gradient-to-br from-emerald-500 to-emerald-600 text-white rounded-full flex items-center justify-center shadow-lg shadow-emerald-500/30 hover:scale-105 transition-transform">
                        <i class="fas fa-paper-plane text-sm"></i>
                    </button>
                </div>
            </div>
        </main>
    </div>

    <!-- SockJS + STOMP -->
    <script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>

    <script>
    document.addEventListener('DOMContentLoaded', function() {
        const url = '${url}';
        let currentRoomId = null;
        let currentPage = 0;
        let isLoadingMore = false;
        let hasMore = true;
        const shopId = ${shopId};
        const currentUserId = ${currentUserId};
        let stompClient = null;

        // ========== WEBSOCKET ==========
        function connectWebSocket() {
            const socket = new SockJS(url + '/ws');
            stompClient = Stomp.over(socket);
            stompClient.debug = null;

            stompClient.connect({}, function(frame) {
                stompClient.subscribe('/user/queue/messages', function(message) {
                    const msg = JSON.parse(message.body);
                    if (msg.roomId == currentRoomId) {
                        appendMessage(msg);
                        fetch(url + '/api/chat/rooms/' + currentRoomId + '/read', { method: 'POST' });
                    }
                    loadRooms();
                });
            }, function(error) {
                setTimeout(connectWebSocket, 5000);
            });
        }

        // ========== LOAD ROOMS ==========
        function loadRooms() {
            fetch(url + '/api/chat/rooms?shopId=' + shopId)
                .then(res => res.json())
                .then(rooms => {
                    const list = document.getElementById('sellerRoomList');
                    if (rooms.length === 0) {
                        list.innerHTML = '<div class="flex flex-col items-center justify-center py-12 text-slate-400"><i class="fas fa-inbox text-3xl mb-3 opacity-30"></i><p class="text-sm">Chưa có tin nhắn nào</p></div>';
                        return;
                    }

                    list.innerHTML = rooms.map(room => {
                        const activeClass = room.roomId === currentRoomId ? 'room-active' : '';
                        const unreadHtml = room.unreadCount > 0 ? '<span class="bg-emerald-500 text-white text-[10px] font-bold rounded-full w-5 h-5 flex items-center justify-center">' + room.unreadCount + '</span>' : '';
                        
                        return '<div class="flex items-center gap-3 px-4 py-3.5 cursor-pointer hover:bg-slate-50 transition-colors ' + activeClass + '" ' +
                             'data-room-id="' + room.roomId + '" ' +
                             'data-partner-name="' + room.partnerName + '" ' +
                             'onclick="openSellerRoom(' + room.roomId + ', \'' + room.partnerName.replace(/'/g, "\\'") + '\')">' +
                            '<div class="w-10 h-10 bg-gradient-to-br from-slate-200 to-slate-300 rounded-full flex items-center justify-center text-slate-600 font-bold text-sm flex-shrink-0">' +
                                room.partnerName.charAt(0).toUpperCase() +
                            '</div>' +
                            '<div class="flex-1 min-w-0">' +
                                '<div class="font-semibold text-sm text-small-navy truncate">' + room.partnerName + '</div>' +
                                '<div class="text-xs text-slate-400 truncate">' + (room.lastMessage || 'Chưa có tin nhắn') + '</div>' +
                            '</div>' +
                            '<div class="flex flex-col items-end gap-1 flex-shrink-0">' +
                                '<span class="text-[10px] text-slate-400">' + (room.lastMessageAt || '') + '</span>' +
                                unreadHtml +
                            '</div>' +
                        '</div>';
                    }).join('');
                });
        }

        // ========== OPEN ROOM ==========
        window.openSellerRoom = function(roomId, partnerName) {
            console.log('[S-Mall Seller Chat] Opening room:', roomId);
            currentRoomId = roomId;
            currentPage = 0;
            hasMore = true;
            isLoadingMore = false;

            document.getElementById('sellerEmptyState').style.display = 'none';
            document.getElementById('sellerChatHeader').style.display = 'flex';
            document.getElementById('sellerChatMessages').style.display = 'block';
            document.getElementById('sellerChatInput').style.display = 'flex';
            
            document.getElementById('sellerPartnerName').textContent = partnerName;
            document.getElementById('sellerPartnerInitial').textContent = partnerName.charAt(0).toUpperCase();

            document.querySelectorAll('[data-room-id]').forEach(el => {
                el.classList.toggle('room-active', parseInt(el.dataset.roomId) === roomId);
            });

            document.getElementById('sellerChatMessages').innerHTML = '';
            loadSellerMessages(roomId, 0);
            document.getElementById('sellerInput').focus();
            
            // Đánh dấu đã đọc
            fetch(url + '/api/chat/rooms/' + roomId + '/read', { method: 'POST' });
        };

        // ========== LOAD MESSAGES ==========
        function loadSellerMessages(roomId, page) {
            if (isLoadingMore || !hasMore) return;
            isLoadingMore = true;
            
            if (page > 0) {
                const container = document.getElementById('sellerChatMessages');
                const loadingDiv = document.createElement('div');
                loadingDiv.id = 'historyLoading';
                loadingDiv.className = 'text-center py-2 text-slate-400 text-[10px]';
                loadingDiv.innerHTML = '<i class="fas fa-spinner fa-spin mr-1"></i>Đang tải tin nhắn cũ...';
                container.prepend(loadingDiv);
            }

            fetch(url + '/api/chat/rooms/' + roomId + '/messages?page=' + page + '&size=20')
                .then(res => {
                    if (res.status === 403) throw new Error('403: Không có quyền truy cập.');
                    if (!res.ok) throw new Error('Lỗi máy chủ: ' + res.status);
                    return res.json();
                })
                .then(messages => {
                    const container = document.getElementById('sellerChatMessages');
                    const loadingDiv = document.getElementById('historyLoading');
                    if (loadingDiv) loadingDiv.remove();

                    if (!Array.isArray(messages)) return;

                    if (messages.length < 20) {
                        hasMore = false;
                    }

                    if (page === 0 && messages.length === 0) {
                        container.innerHTML = '<div class="flex justify-center py-8 text-slate-400 text-sm"><i class="fas fa-hand-peace mr-2"></i>Gửi tin nhắn đầu tiên!</div>';
                    }

                    const oldScrollHeight = container.scrollHeight;

                    if (page === 0) {
                        // Trang 0: Thêm vào cuối theo thứ tự thời gian (Oldest -> Newest)
                        messages.forEach(msg => appendMessage(msg));
                        scrollToBottom();
                    } else {
                        // Trang > 0: Thêm vào đầu, đảo ngược để prepend đúng thứ tự
                        [...messages].reverse().forEach(msg => prependMessage(msg));
                        // Giữ vị trí cuộn để không bị nhảy
                        container.scrollTop = container.scrollHeight - oldScrollHeight;
                    }

                    isLoadingMore = false;
                    loadRooms();
                })
                .catch(err => {
                    console.error('[S-Mall Seller Chat] Load error:', err);
                    isLoadingMore = false;
                });
        }

        function prependMessage(msg) {
            const container = document.getElementById('sellerChatMessages');
            const isOwn = msg.isOwn || msg.senderId === currentUserId;
            
            const html = isOwn
                ? '<div class="flex justify-end mb-4"><div class="max-w-[65%]"><div class="chat-bubble-out px-4 py-2.5 text-sm">' + escapeHtml(msg.content) + '</div><div class="text-right text-[10px] text-slate-400 mt-1 pr-1">' + (msg.time || '') + '</div></div></div>'
                : '<div class="flex gap-2 mb-4"><div class="w-7 h-7 bg-slate-200 rounded-full flex items-center justify-center text-slate-500 text-[10px] font-bold flex-shrink-0 mt-1">' + (msg.senderName || '?').charAt(0).toUpperCase() + '</div><div class="max-w-[65%]"><div class="chat-bubble-in px-4 py-2.5 text-sm text-small-navy">' + escapeHtml(msg.content) + '</div><div class="text-[10px] text-slate-400 mt-1 pl-1">' + (msg.time || '') + '</div></div></div>';
            
            container.insertAdjacentHTML('afterbegin', html);
        }

        // Xử lý cuộn để load thêm
        document.getElementById('sellerChatMessages').addEventListener('scroll', function() {
            if (this.scrollTop === 0 && hasMore && !isLoadingMore && currentRoomId) {
                currentPage++;
                loadSellerMessages(currentRoomId, currentPage);
            }
        });

        // ========== APPEND MESSAGE ==========
        function appendMessage(msg) {
            const container = document.getElementById('sellerChatMessages');
            const emptyMsg = container.querySelector('.flex.justify-center');
            if (emptyMsg) emptyMsg.remove();

            const isOwn = msg.isOwn || msg.senderId === currentUserId;

            const html = isOwn
                ? '<div class="flex justify-end mb-4"><div class="max-w-[65%]"><div class="chat-bubble-out px-4 py-2.5 text-sm">' + escapeHtml(msg.content) + '</div><div class="text-right text-[10px] text-slate-400 mt-1 pr-1">' + (msg.time || '') + '</div></div></div>'
                : '<div class="flex gap-2 mb-4"><div class="w-7 h-7 bg-slate-200 rounded-full flex items-center justify-center text-slate-500 text-[10px] font-bold flex-shrink-0 mt-1">' + (msg.senderName || '?').charAt(0).toUpperCase() + '</div><div class="max-w-[65%]"><div class="chat-bubble-in px-4 py-2.5 text-sm text-small-navy">' + escapeHtml(msg.content) + '</div><div class="text-[10px] text-slate-400 mt-1 pl-1">' + (msg.time || '') + '</div></div></div>';

            container.insertAdjacentHTML('beforeend', html);
            scrollToBottom();
        }

        // ========== SEND MESSAGE ==========
        function sendMessage() {
            const input = document.getElementById('sellerInput');
            const content = input.value.trim();
            
            if (!content) return;
            if (!currentRoomId) return;
            if (!stompClient || !stompClient.connected) {
                connectWebSocket();
                return;
            }

            try {
                stompClient.send('/app/chat.send', {}, JSON.stringify({
                    roomId: currentRoomId,
                    content: content
                }));
                input.value = '';
                input.focus();
            } catch (err) {
                console.error('[S-Mall Seller Chat] Error sending message:', err);
            }
        }

        document.getElementById('sellerSendBtn').addEventListener('click', sendMessage);
        document.getElementById('sellerInput').addEventListener('keypress', function(e) {
            if (e.key === 'Enter') { e.preventDefault(); sendMessage(); }
        });

        // ========== SEARCH ==========
        document.getElementById('sellerSearchInput').addEventListener('input', function() {
            const query = this.value.toLowerCase();
            document.querySelectorAll('[data-room-id]').forEach(item => {
                const name = (item.dataset.partnerName || '').toLowerCase();
                item.style.display = name.includes(query) ? 'flex' : 'none';
            });
        });

        // ========== HELPERS ==========
        function scrollToBottom() {
            const c = document.getElementById('sellerChatMessages');
            setTimeout(() => c.scrollTop = c.scrollHeight, 50);
        }

        function escapeHtml(text) {
            const d = document.createElement('div');
            d.textContent = text;
            return d.innerHTML;
        }

        // ========== INIT ==========
        connectWebSocket();
        loadRooms();
    });
    </script>
</body>
</html>
