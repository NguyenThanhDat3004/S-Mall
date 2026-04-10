package com.service;

import java.util.Collections;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import org.springframework.security.authentication.LockedException;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.entity.User;
import com.repository.UserRepository;
import com.service.LoginAttemptService;

@Service
public class CustomUserDetailsService implements UserDetailsService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private LoginAttemptService loginAttemptService;

    @Override
    public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
        System.out.println(">>> Đang kiểm tra đăng nhập cho email: " + email);

        if (loginAttemptService.isBlocked(email)) {
            long remainingMinutes = loginAttemptService.getLockExpiry(email);
            System.out.println(">>> [LỖI] Tài khoản này đang bị khóa. Còn lại: " + remainingMinutes + " phút.");
            throw new LockedException(
                    "Tài khoản đã bị khóa do nhập sai quá nhiều lần. Vui lòng thử lại sau " + remainingMinutes
                            + " phút.");
        }

        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> {
                    System.out.println(">>> [LỖI] Không tìm thấy email này trong Database.");
                    return new UsernameNotFoundException("Không tìm thấy người dùng với email: " + email);
                });

        if (!user.isActive()) {
            System.out.println(">>> [LỖI] Tài khoản này đang bị khóa (is_active = false).");
            throw new UsernameNotFoundException("Tài khoản của bạn đã bị khóa.");
        }

        System.out.println(">>> [OK] Đã tìm thấy User. Password trong DB (BCrypt): " + user.getPassword());

        // Tên role trong DB (ví dụ ADMIN) cần được thêm tiền tố "ROLE_" cho Spring
        // Security
        String roleName = "ROLE_" + user.getRole().getName();
        System.out.println(">>> [OK] Quyền của người dùng: " + roleName);

        return new org.springframework.security.core.userdetails.User(
                user.getEmail(),
                user.getPassword(),
                Collections.singletonList(new SimpleGrantedAuthority(roleName)));
    }

}
