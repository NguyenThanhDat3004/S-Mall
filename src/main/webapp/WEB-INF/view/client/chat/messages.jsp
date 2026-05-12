<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="url" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>S-Mall | Tin nhắn</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${url}/resources/css/client/messages.css">
    <style>body { font-family: 'Inter', sans-serif; background: #f1f5f9; }</style>
</head>
<body>

    <!-- Header -->
    <jsp:include page="/WEB-INF/view/client/layout/header.jsp" />

    <div class="container" style="max-width: 1100px; margin-top: 16px;">

        <div class="chat-container" id="chatContainer">
            <!-- Sidebar: Danh sách phòng chat -->
            <div class="chat-sidebar" id="chatSidebar">
                <div class="chat-sidebar-header">
                    <h2><i class="fas fa-comment-dots me-2" style="color: #EE4D2D;"></i>Tin nhắn</h2>
                    <div class="chat-search">
                        <i class="fas fa-search"></i>
                        <input type="text" placeholder="Tìm kiếm cuộc trò chuyện..." id="chatSearchInput">
                    </div>
                </div>
                <div class="chat-room-list" id="chatRoomList">
                    <div class="chat-empty-state" style="padding: 40px 20px;">
                        <i class="fas fa-spinner fa-spin"></i>
                        <p>Đang tải...</p>
                    </div>
                </div>
            </div>

            <!-- Main: Khung chat -->
            <div class="chat-main" id="chatMain">
                <div class="chat-empty-state" id="chatEmptyState">
                    <i class="fas fa-comments"></i>
                    <h3>Chào mừng đến S-Mall Chat</h3>
                    <p>Chọn một cuộc trò chuyện để bắt đầu nhắn tin với người bán</p>
                </div>

                <!-- Header phòng chat (ẩn mặc định) -->
                <div class="chat-main-header" id="chatHeader" style="display: none;">
                    <img class="chat-msg-avatar" id="chatPartnerAvatar" src="" alt="">
                    <div>
                        <div class="partner-name" id="chatPartnerName"></div>
                        <div class="partner-status">Đang hoạt động</div>
                    </div>
                </div>

                <!-- Khu vực tin nhắn (ẩn mặc định) -->
                <div class="chat-messages" id="chatMessages" style="display: none;"></div>

                <!-- Ô nhập tin nhắn (ẩn mặc định) -->
                <div class="chat-input-area" id="chatInputArea" style="display: none;">
                    <input type="text" id="chatInput" placeholder="Nhập tin nhắn..."
                           autocomplete="off" maxlength="1000">
                    <button class="chat-send-btn" id="chatSendBtn" title="Gửi">
                        <i class="fas fa-paper-plane"></i>
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- SockJS + STOMP -->
    <script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>

    <script>
    document.addEventListener('DOMContentLoaded', function() {
        const url = '${url}';
        const currentUserId = ${currentUserId};
        const activeRoomId = ${activeRoomId != null ? activeRoomId : 'null'};
        let currentRoomId = null;
        let stompClient = null;

        // ========== WEBSOCKET CONNECTION ==========
        function connectWebSocket() {
            const socket = new SockJS(url + '/ws');
            stompClient = Stomp.over(socket);
            stompClient.debug = null;

            stompClient.connect({}, function(frame) {
                console.log('[S-Mall Chat] WebSocket Connected');

                // Subscribe tin nhắn cá nhân
                stompClient.subscribe('/user/queue/messages', function(message) {
                    const msg = JSON.parse(message.body);
                    console.log('[S-Mall Chat] New message received:', msg);

                    // Nếu tin nhắn thuộc phòng đang mở → hiển thị
                    if (msg.roomId === currentRoomId) {
                        appendMessage(msg);
                        // Đánh dấu đã đọc
                        fetch(url + '/api/chat/rooms/' + currentRoomId + '/read', { method: 'POST' });
                    }

                    // Cập nhật danh sách phòng chat
                    loadRooms();
                    // Cập nhật badge trên header
                    updateChatBadge();
                });
            }, function(error) {
                console.log('[S-Mall Chat] WebSocket Error:', error);
                setTimeout(connectWebSocket, 5000);
            });
        }

        // ========== LOAD ROOM LIST ==========
        function loadRooms() {
            fetch(url + '/api/chat/rooms')
                .then(res => res.json())
                .then(rooms => {
                    const list = document.getElementById('chatRoomList');
                    if (rooms.length === 0) {
                        list.innerHTML = `
                            <div class="chat-empty-state" style="padding: 40px 20px;">
                                <i class="fas fa-inbox" style="font-size: 2rem;"></i>
                                <p style="margin-top: 12px;">Chưa có cuộc trò chuyện nào</p>
                            </div>`;
                        return;
                    }

                    list.innerHTML = rooms.map(room => {
                        const avatarHtml = room.partnerAvatar
                            ? '<img class="chat-room-avatar" src="' + (room.partnerAvatar.startsWith('/') ? url + room.partnerAvatar : room.partnerAvatar) + '" alt="">'
                            : '<div class="chat-room-avatar-placeholder">' + room.partnerName.charAt(0).toUpperCase() + '</div>';

                        const badgeHtml = room.unreadCount > 0 ? '<span class="chat-room-badge">' + room.unreadCount + '</span>' : '';

                        return '<div class="chat-room-item ' + (room.roomId === currentRoomId ? 'active' : '') + '" ' +
                             'data-room-id="' + room.roomId + '" ' +
                             'data-partner-name="' + room.partnerName + '" ' +
                             'data-partner-avatar="' + (room.partnerAvatar || '') + '" ' +
                             'onclick="openRoom(' + room.roomId + ', \'' + room.partnerName.replace(/'/g, "\\'") + '\', \'' + (room.partnerAvatar || '') + '\')">' +
                            avatarHtml +
                            '<div class="chat-room-info">' +
                                '<div class="chat-room-name">' + room.partnerName + '</div>' +
                                '<div class="chat-room-preview">' + (room.lastMessage || '') + '</div>' +
                            '</div>' +
                            '<div class="chat-room-meta">' +
                                '<span class="chat-room-time">' + (room.lastMessageAt || '') + '</span>' +
                                badgeHtml +
                            '</div>' +
                        '</div>';
                    }).join('');
                });
        }

        // ========== OPEN ROOM ==========
        window.openRoom = function(roomId, partnerName, partnerAvatar) {
            currentRoomId = roomId;

            // Hiển thị UI chat
            document.getElementById('chatEmptyState').style.display = 'none';
            document.getElementById('chatHeader').style.display = 'flex';
            document.getElementById('chatMessages').style.display = 'flex';
            document.getElementById('chatInputArea').style.display = 'flex';

            // Set header info
            document.getElementById('chatPartnerName').textContent = partnerName;
            const avatarEl = document.getElementById('chatPartnerAvatar');
            if (partnerAvatar) {
                avatarEl.src = partnerAvatar.startsWith('/') ? url + partnerAvatar : partnerAvatar;
                avatarEl.style.display = 'block';
            } else {
                avatarEl.style.display = 'none';
            }

            // Highlight active room
            document.querySelectorAll('.chat-room-item').forEach(item => {
                item.classList.toggle('active', parseInt(item.dataset.roomId) === roomId);
            });

            // Load messages
            loadMessages(roomId);

            // Focus input
            document.getElementById('chatInput').focus();
        }

        // ========== LOAD MESSAGES ==========
        function loadMessages(roomId) {
            console.log('[S-Mall Chat] Loading messages for room:', roomId);
            fetch(url + '/api/chat/rooms/' + roomId + '/messages')
                .then(res => {
                    if (!res.ok) throw new Error('API return status ' + res.status);
                    return res.json();
                })
                .then(messages => {
                    console.log('[S-Mall Chat] Received messages:', messages);
                    const container = document.getElementById('chatMessages');
                    container.innerHTML = '';

                    if (!Array.isArray(messages)) {
                        console.error('[S-Mall Chat] Expected array but got:', messages);
                        container.innerHTML = '<div style="text-align: center; color: #ef4444; padding: 20px;">Lỗi tải tin nhắn: Dữ liệu không hợp lệ</div>';
                        return;
                    }

                    if (messages.length === 0) {
                        container.innerHTML = `
                            <div style="text-align: center; color: #94a3b8; padding: 40px; font-size: 0.85rem;">
                                <i class="fas fa-hand-peace" style="font-size: 2rem; margin-bottom: 8px; display: block;"></i>
                                Hãy gửi tin nhắn đầu tiên!
                            </div>`;
                        return;
                    }

                    messages.forEach(msg => {
                        try {
                            appendMessage(msg);
                        } catch (err) {
                            console.error('[S-Mall Chat] Error appending message:', err, msg);
                        }
                    });
                    scrollToBottom();

                    // Reload rooms to update unread count
                    loadRooms();
                    updateChatBadge();
                })
                .catch(err => {
                    console.error('[S-Mall Chat] Fetch error:', err);
                    const container = document.getElementById('chatMessages');
                    container.innerHTML = '<div style="text-align: center; color: #ef4444; padding: 20px;">Không thể tải tin nhắn. Vui lòng thử lại sau.</div>';
                });
        }

        // ========== APPEND MESSAGE ==========
        function appendMessage(msg) {
            const container = document.getElementById('chatMessages');
            // Remove empty state if present
            const emptyState = container.querySelector('[style*="text-align: center"]');
            if (emptyState) emptyState.remove();

            const isOwn = msg.isOwn || msg.senderId === currentUserId;
            const avatarHtml = msg.senderAvatar
                ? `<img class="chat-msg-avatar" src="${msg.senderAvatar.startsWith('/') ? url + msg.senderAvatar : msg.senderAvatar}" alt="">`
                : `<div class="chat-msg-avatar-placeholder">${(msg.senderName || '?').charAt(0).toUpperCase()}</div>`;

            const html = '<div class="chat-msg ' + (isOwn ? 'own' : '') + '">' +
                    (!isOwn ? avatarHtml : '') +
                    '<div>' +
                        '<div class="chat-msg-bubble">' + escapeHtml(msg.content) + '</div>' +
                        '<div class="chat-msg-time">' + (msg.time || '') + '</div>' +
                    '</div>' +
                '</div>';

            container.insertAdjacentHTML('beforeend', html);
            scrollToBottom();
        }

        // ========== SEND MESSAGE ==========
        function sendMessage() {
            const input = document.getElementById('chatInput');
            const content = input.value.trim();
            if (!content || !currentRoomId || !stompClient) return;

            stompClient.send('/app/chat.send', {}, JSON.stringify({
                roomId: currentRoomId,
                content: content
            }));

            input.value = '';
            input.focus();
        }

        // Send button click
        document.getElementById('chatSendBtn').addEventListener('click', sendMessage);

        // Enter key
        document.getElementById('chatInput').addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                e.preventDefault();
                sendMessage();
            }
        });

        // ========== SEARCH ==========
        document.getElementById('chatSearchInput').addEventListener('input', function() {
            const query = this.value.toLowerCase();
            document.querySelectorAll('.chat-room-item').forEach(item => {
                const name = item.dataset.partnerName.toLowerCase();
                item.style.display = name.includes(query) ? 'flex' : 'none';
            });
        });

        // ========== HELPERS ==========
        function scrollToBottom() {
            const container = document.getElementById('chatMessages');
            setTimeout(() => container.scrollTop = container.scrollHeight, 50);
        }

        function escapeHtml(text) {
            const div = document.createElement('div');
            div.textContent = text;
            return div.innerHTML;
        }

        function updateChatBadge() {
            fetch(url + '/api/chat/unread-count')
                .then(res => res.json())
                .then(data => {
                    const badge = document.getElementById('chatBadge');
                    if (badge) {
                        const count = data.count || 0;
                        badge.innerText = count > 9 ? '9+' : count;
                        badge.style.display = count > 0 ? 'flex' : 'none';
                    }
                });
        }

        // ========== INIT ==========
        connectWebSocket();
        loadRooms();

        // Nếu có activeRoomId (từ "Chat với Shop"), tự mở phòng đó
        if (activeRoomId) {
            setTimeout(() => {
                // Đợi rooms load xong rồi mở
                const checkRoom = setInterval(() => {
                    const roomEl = document.querySelector('[data-room-id="' + activeRoomId + '"]');
                    if (roomEl) {
                        clearInterval(checkRoom);
                        roomEl.click();
                    }
                }, 200);
                // Timeout sau 3s
                setTimeout(() => clearInterval(checkRoom), 3000);
            }, 500);
        }
    });
    </script>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
