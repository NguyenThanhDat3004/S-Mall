package com.service;

import java.util.Collections;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.dto.CustomUserDetails;
import com.entity.User;
import com.repository.UserRepository;

@Service
public class CustomUserDetailsService implements UserDetailsService {

    @Autowired
    private UserRepository userRepository;

    @Override
    public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new UsernameNotFoundException("Không tìm thấy người dùng với email: " + email));

        if (!user.isActive()) {
            throw new UsernameNotFoundException("Tài khoản của bạn đã bị khóa.");
        }

        // Tên role trong DB (ví dụ ADMIN) cần được thêm tiền tố "ROLE_" cho Spring Security
        String roleName = "ROLE_" + user.getRole().getName();

        return new CustomUserDetails(
                user.getEmail(),
                user.getPassword(),
                Collections.singletonList(new SimpleGrantedAuthority(roleName)),
                user.getId(),
                user.getProfile() != null ? user.getProfile().getFullName() : "User"
        );
    }
}
