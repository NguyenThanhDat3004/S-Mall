package com.service;

import com.dto.request.RegisterDTO;

public interface OtpService {
    String generateOtp(String email);
    void sendOtpEmail(String email, String otp);
    boolean verifyOtp(String email, String otp);
    void saveRegisterDTO(String email, RegisterDTO registerDTO);
    RegisterDTO getRegisterDTO(String email);
    void clearOtpData(String email);
}
