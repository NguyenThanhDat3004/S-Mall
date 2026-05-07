/* S-Mall Chat Widget Logic */

(function() {
    const url = window.location.origin + (window.location.pathname.startsWith('/spring_mvc') ? '/spring_mvc' : '');
    let currentRoomId = null;
    let stompClient = null;
    let isWindowOpen = false;

    // UI Elements
    const container = document.createElement('div');
    container.className = 'chat-widget-container';
    container.innerHTML = `
        <div class="chat-widget-window" id="cwWindow">
            <div class="chat-widget-header">
                <div class="d-flex align-items-center">
                    <i class="fas fa-chevron-left chat-widget-back" id="cwBack" style="display: none;"></i>
                    <h5 id="cwTitle">Tin nhắn</h5>
                </div>
                <i class="fas fa-times chat-widget-close" id="cwClose"></i>
            </div>
            
            <!-- View: Room List -->
            <div class="chat-widget-rooms" id="cwRoomList">
                <div class="p-4 text-center text-muted small">Đang tải...</div>
            </div>

            <!-- View: Conversation -->
            <div class="chat-widget-conversation" id="cwConversation">
                <div class="chat-widget-messages" id="cwMessages"></div>
                <div class="chat-widget-input-area">
                    <input type="text" class="chat-widget-input" id="cwInput" placeholder="Nhập tin nhắn..." autocomplete="off">
                    <i class="fas fa-paper-plane chat-widget-send" id="cwSend"></i>
                </div>
            </div>
        </div>
    `;
    document.body.appendChild(container);

    const windowEl = document.getElementById('cwWindow');
    const closeBtn = document.getElementById('cwClose');
    const backBtn = document.getElementById('cwBack');
    const roomList = document.getElementById('cwRoomList');
    const conversation = document.getElementById('cwConversation');
    const messagesEl = document.getElementById('cwMessages');
    const input = document.getElementById('cwInput');
    const sendBtn = document.getElementById('cwSend');
    const title = document.getElementById('cwTitle');

    // Toggle Window
    function toggleWindow(forceOpen = null) {
        isWindowOpen = forceOpen !== null ? forceOpen : !isWindowOpen;
        windowEl.style.display = isWindowOpen ? 'flex' : 'none';
        if (isWindowOpen) {
            if (!currentRoomId) loadRooms();
            else openRoom(currentRoomId, title.innerText);
        }
    }

    closeBtn.onclick = (e) => {
        e.stopPropagation();
        isWindowOpen = false;
        windowEl.style.display = 'none';
    };

    backBtn.onclick = () => {
        currentRoomId = null;
        conversation.style.display = 'none';
        roomList.style.display = 'flex';
        backBtn.style.display = 'none';
        title.innerText = 'Tin nhắn';
        loadRooms();
    };

    // Load Rooms
    function loadRooms() {
        fetch(url + '/api/chat/rooms')
            .then(res => res.json())
            .then(rooms => {
                if (rooms.length === 0) {
                    roomList.innerHTML = '<div class="p-4 text-center text-muted small">Chưa có tin nhắn nào</div>';
                    return;
                }
                roomList.innerHTML = rooms.map(room => {
                    const partnerAvatar = room.partnerAvatar ? (room.partnerAvatar.startsWith('/') ? url + room.partnerAvatar : room.partnerAvatar) : '';
                    const avatarHtml = partnerAvatar 
                        ? '<img src="' + partnerAvatar + '" class="chat-widget-room-avatar">'
                        : '<div class="chat-widget-room-avatar d-flex align-items-center justify-content-center bg-secondary text-white fw-bold">' + room.partnerName.charAt(0).toUpperCase() + '</div>';
                    
                    return '<div class="chat-widget-room-item" onclick="window.chatWidget.openRoom(' + room.roomId + ', \'' + room.partnerName.replace(/'/g, "\\'") + '\')">' +
                        avatarHtml +
                        '<div class="chat-widget-room-info">' +
                            '<div class="chat-widget-room-name">' + room.partnerName + '</div>' +
                            '<div class="chat-widget-room-last">' + (room.lastMessage || 'Chưa có tin nhắn') + '</div>' +
                        '</div>' +
                        (room.unreadCount > 0 ? '<span class="badge bg-danger rounded-pill">' + room.unreadCount + '</span>' : '') +
                    '</div>';
                }).join('');
            });
    }

    // Open Room
    window.chatWidget = {
        toggle: function(forceOpen = null) {
            toggleWindow(forceOpen);
        },

        openRoom: function(roomId, partnerName) {
            currentRoomId = roomId;
            roomList.style.display = 'none';
            conversation.style.display = 'flex';
            backBtn.style.display = 'block';
            title.innerText = partnerName;
            
            toggleWindow(true);

            loadMessages(roomId);
            fetch(url + '/api/chat/rooms/' + roomId + '/read', { method: 'POST' });
        },
        
        // Trigger from external (like product page)
        initChat: function(shopId) {
            fetch(url + '/api/chat/rooms/init?shopId=' + shopId, { method: 'POST' })
                .then(res => res.json())
                .then(data => {
                    this.openRoom(data.roomId, data.partnerName);
                });
        }
    };

    function loadMessages(roomId) {
        messagesEl.innerHTML = '<div class="text-center p-3 text-muted small">Đang tải tin nhắn...</div>';
        fetch(url + '/api/chat/rooms/' + roomId + '/messages')
            .then(res => res.json())
            .then(messages => {
                messagesEl.innerHTML = '';
                messages.forEach(msg => appendMessage(msg));
                scrollToBottom();
            });
    }

    function appendMessage(msg) {
        const div = document.createElement('div');
        div.className = 'cw-msg ' + (msg.isOwn ? 'out' : 'in');
        div.innerText = msg.content;
        messagesEl.appendChild(div);
        scrollToBottom();
    }

    function scrollToBottom() {
        messagesEl.scrollTop = messagesEl.scrollHeight;
    }

    // Send Message
    function sendMessage() {
        const content = input.value.trim();
        if (!content || !currentRoomId) return;

        // Ensure WebSocket is connected
        if (!window.stompClient) {
            alert('Mất kết nối máy chủ. Vui lòng thử lại.');
            return;
        }

        window.stompClient.send('/app/chat.send', {}, JSON.stringify({
            roomId: currentRoomId,
            content: content
        }));

        input.value = '';
    }

    sendBtn.onclick = sendMessage;
    input.onkeypress = (e) => { if (e.key === 'Enter') sendMessage(); };

    // Connect WebSocket (Shared with Header or separate)
    const checkWS = setInterval(() => {
        if (window.stompClient && window.stompClient.connected) {
            window.stompClient.subscribe('/user/queue/messages', function(message) {
                const msg = JSON.parse(message.body);
                if (msg.roomId === currentRoomId) {
                    appendMessage(msg);
                }
                if (isWindowOpen && !currentRoomId) loadRooms();
            });
            clearInterval(checkWS);
        }
    }, 1000);
})();
