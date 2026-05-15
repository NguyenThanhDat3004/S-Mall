/* S-Mall Chat Widget Logic */

(function() {
    const url = window.location.origin + (window.location.pathname.startsWith('/spring_mvc') ? '/spring_mvc' : '');
    let currentRoomId = null;
    let currentShopId = null;
    let currentPage = 0;
    let isLoadingMore = false;
    let hasMore = true;
    let stompClient = null;
    let isWindowOpen = false;
    let lastAppendDate = null; // theo dõi ngày để chèn thanh ngăn cách

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
        if (isWindowOpen && !currentRoomId) {
            loadRooms();
        }
    }

    closeBtn.onclick = (e) => {
        e.stopPropagation();
        if (currentRoomId) {
            fetch(url + '/api/chat/rooms/' + currentRoomId + '/close', { method: 'POST' });
        }
        isWindowOpen = false;
        windowEl.style.display = 'none';
    };

    backBtn.onclick = () => {
        if (currentRoomId) {
            fetch(url + '/api/chat/rooms/' + currentRoomId + '/close', { method: 'POST' });
        }
        currentRoomId = null;
        conversation.style.display = 'none';
        roomList.style.display = 'flex';
        backBtn.style.display = 'none';
        title.innerText = 'Tin nhắn';
        loadRooms();
    };

    // Smart time format: Trong ngày → HH:mm, Khác ngày → dd/MM
    function formatRoomTime(ms) {
        if (!ms) return '';
        const d = new Date(ms);
        const now = new Date();
        const isToday = d.getDate() === now.getDate() &&
                        d.getMonth() === now.getMonth() &&
                        d.getFullYear() === now.getFullYear();
        if (isToday) {
            return d.getHours().toString().padStart(2,'0') + ':' + d.getMinutes().toString().padStart(2,'0');
        } else {
            return d.getDate().toString().padStart(2,'0') + '/' + (d.getMonth()+1).toString().padStart(2,'0');
        }
    }

    // Nhãn ngày cho thanh ngăn cách
    function getDateLabel(ms) {
        if (!ms) return null;
        const d = new Date(ms);
        const now = new Date();
        const today    = new Date(now.getFullYear(), now.getMonth(), now.getDate());
        const yesterday = new Date(today - 86400000);
        const msgDay   = new Date(d.getFullYear(), d.getMonth(), d.getDate());
        if (msgDay.getTime() === today.getTime())     return 'Hôm nay';
        if (msgDay.getTime() === yesterday.getTime()) return 'Hôm qua';
        return d.getDate().toString().padStart(2,'0') + '/' +
               (d.getMonth()+1).toString().padStart(2,'0') + '/' +
               d.getFullYear();
    }

    // Tạo thanh ngăn cách ngày
    function createDateSep(label) {
        const sep = document.createElement('div');
        sep.className = 'cw-date-sep';
        sep.innerHTML = '<span>' + label + '</span>';
        return sep;
    }

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
                        '<div class="chat-widget-room-meta">' +
                            '<div class="chat-widget-room-time">' + formatRoomTime(room.lastMessageAtMs) + '</div>' +
                            (room.unreadCount > 0 ? '<span class="badge bg-danger rounded-pill">' + room.unreadCount + '</span>' : '') +
                        '</div>' +
                    '</div>';
                }).join('');
            })
            .catch(err => {
                console.error("Error loading rooms:", err);
                roomList.innerHTML = '<div class="p-4 text-center text-danger small">Lỗi tải danh sách phòng. Vui lòng thử lại.</div>';
            });
    }

    // Open Room
    window.chatWidget = {
        toggle: function(forceOpen = null) {
            toggleWindow(forceOpen);
        },

        openRoom: function(roomId, partnerName, shopId = null) {
            currentRoomId = roomId;
            currentShopId = shopId;
            roomList.style.display = 'none';
            conversation.style.display = 'flex';
            backBtn.style.display = 'block';
            title.innerText = partnerName;
            
            toggleWindow(true);

            currentPage = 0;
            hasMore = true;
            lastAppendDate = null;
            messagesEl.innerHTML = '';
            loadMessages(roomId, 0);
            fetch(url + '/api/chat/rooms/' + roomId + '/read', { method: 'POST' });
        },
        
        // Trigger from external (like product page)
        initChat: function(shopId) {
            fetch(url + '/api/chat/rooms/init?shopId=' + shopId, { method: 'POST' })
                .then(res => res.json())
                .then(data => {
                    this.openRoom(data.roomId, data.partnerName, shopId);
                });
        }
    };

    function loadMessages(roomId, page) {
        if (!roomId) {
            messagesEl.innerHTML = '<div class="text-center p-3 text-muted small">Hãy gửi tin nhắn đầu tiên!</div>';
            return;
        }
        
        if (page === 0) {
            messagesEl.innerHTML = '<div class="text-center p-3 text-muted small">Đang tải tin nhắn...</div>';
        } else {
            const loading = document.createElement('div');
            loading.id = 'cwLoadingMore';
            loading.className = 'text-center p-2 text-muted small';
            loading.innerText = 'Đang tải tin nhắn cũ...';
            messagesEl.prepend(loading);
        }

        isLoadingMore = true;
        fetch(url + '/api/chat/rooms/' + roomId + '/messages?page=' + page + '&size=20')
            .then(res => {
                if (!res.ok) throw new Error('Failed to load messages');
                return res.json();
            })
            .then(messages => {
                const loadingMore = document.getElementById('cwLoadingMore');
                if (loadingMore) loadingMore.remove();

                if (page === 0) {
                    messagesEl.innerHTML = '';
                    if (messages.length === 0) {
                        messagesEl.innerHTML = '<div class="text-center p-3 text-muted small">Chưa có tin nhắn</div>';
                    }
                }
                
                if (messages.length < 20) {
                    hasMore = false;
                }

                const oldScrollHeight = messagesEl.scrollHeight;

                if (page === 0) {
                    // Trang đầu: append theo đúng thứ tự + chèn separator ngày
                    messages.forEach(msg => {
                        const label = getDateLabel(msg.timestamp);
                        if (label && label !== lastAppendDate) {
                            messagesEl.appendChild(createDateSep(label));
                            lastAppendDate = label;
                        }
                        appendMessageDirect(msg);
                    });
                    scrollToBottom();
                } else {
                    // Trang cũ hơn: prepend theo thứ tự ngược
                    let lastPrependDate = null;
                    messages.slice().reverse().forEach(msg => {
                        const label = getDateLabel(msg.timestamp);
                        if (label && label !== lastPrependDate) {
                            if (lastPrependDate !== null) {
                                messagesEl.prepend(createDateSep(label));
                            }
                            lastPrependDate = label;
                        }
                        prependMessageDirect(msg);
                    });
                    if (lastPrependDate) messagesEl.prepend(createDateSep(lastPrependDate));
                    messagesEl.scrollTop = messagesEl.scrollHeight - oldScrollHeight;
                }
                
                isLoadingMore = false;
            })
            .catch(err => {
                console.error(err);
                if (page === 0) {
                    messagesEl.innerHTML = '<div class="text-center p-3 text-danger small">Lỗi khi tải tin nhắn</div>';
                }
                isLoadingMore = false;
            });
    }

    // Append trực tiếp (dùng khi load trang đầu, không tự xử lý separator)
    function appendMessageDirect(msg) {
        if (messagesEl.querySelector('.text-muted')) messagesEl.innerHTML = '';
        const wrapper = document.createElement('div');
        wrapper.className = 'cw-msg-wrapper ' + (msg.isOwn ? 'out' : 'in');
        const bubble = document.createElement('div');
        bubble.className = 'cw-msg ' + (msg.isOwn ? 'out' : 'in');
        bubble.innerText = msg.content;
        const timeEl = document.createElement('div');
        timeEl.className = 'cw-msg-time';
        timeEl.innerText = msg.time || '';
        wrapper.appendChild(bubble);
        wrapper.appendChild(timeEl);
        messagesEl.appendChild(wrapper);
    }

    // Prepend trực tiếp (dùng khi load trang cũ, không tự xử lý separator)
    function prependMessageDirect(msg) {
        if (messagesEl.querySelector('.text-muted')) messagesEl.innerHTML = '';
        const wrapper = document.createElement('div');
        wrapper.className = 'cw-msg-wrapper ' + (msg.isOwn ? 'out' : 'in');
        const bubble = document.createElement('div');
        bubble.className = 'cw-msg ' + (msg.isOwn ? 'out' : 'in');
        bubble.innerText = msg.content;
        const timeEl = document.createElement('div');
        timeEl.className = 'cw-msg-time';
        timeEl.innerText = msg.time || '';
        wrapper.appendChild(bubble);
        wrapper.appendChild(timeEl);
        messagesEl.prepend(wrapper);
    }

    // Append real-time (có kiểm tra đổi ngày để thêm separator)
    function appendMessage(msg) {
        if (messagesEl.querySelector('.text-muted')) messagesEl.innerHTML = '';
        const label = getDateLabel(msg.timestamp);
        if (label && label !== lastAppendDate) {
            messagesEl.appendChild(createDateSep(label));
            lastAppendDate = label;
        }
        appendMessageDirect(msg);
        scrollToBottom();
    }

    function scrollToBottom() {
        messagesEl.scrollTop = messagesEl.scrollHeight;
    }

    messagesEl.onscroll = () => {
        if (messagesEl.scrollTop === 0 && hasMore && !isLoadingMore && currentRoomId) {
            currentPage++;
            loadMessages(currentRoomId, currentPage);
        }
    };

    // Send Message
    function sendMessage() {
        const content = input.value.trim();
        if (!content) return;
        if (!currentRoomId && !currentShopId) return;

        // Ensure WebSocket is connected
        if (!window.stompClient) {
            alert('Mất kết nối máy chủ. Vui lòng thử lại.');
            return;
        }

        window.stompClient.send('/app/chat.send', {}, JSON.stringify({
            roomId: currentRoomId,
            shopId: currentShopId,
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
                // Nếu vừa gửi tin nhắn đầu tiên và phòng mới được tạo
                if (!currentRoomId && currentShopId && msg.roomId) {
                    currentRoomId = msg.roomId;
                }
                if (msg.roomId === currentRoomId) {
                    appendMessage(msg);
                }
                if (isWindowOpen && !currentRoomId) loadRooms();
            });
            clearInterval(checkWS);
        }
    }, 1000);
})();
