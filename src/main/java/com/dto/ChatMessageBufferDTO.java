package com.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ChatMessageBufferDTO implements Serializable {
    private static final long serialVersionUID = 1L;

    private Long roomId;
    private Long senderId;
    private String content;
    private Long shopId; // Dùng cho Lazy Creation
    private LocalDateTime createdAt;
    private String senderName;
    private String senderAvatar;
}
