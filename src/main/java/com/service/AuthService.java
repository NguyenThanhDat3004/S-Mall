package com.service;

import com.dto.request.RegisterDTO;
import com.entity.User;

public interface AuthService {
    User register(RegisterDTO registerDTO);
    boolean checkEmailExists(String email);
}
