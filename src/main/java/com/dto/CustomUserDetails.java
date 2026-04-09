package com.dto;

import java.util.Collection;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.User;

public class CustomUserDetails extends User {
    private final Long id;
    private final String fullName;

    public CustomUserDetails(String username, String password, 
                             Collection<? extends GrantedAuthority> authorities, 
                             Long id, String fullName) {
        super(username, password, authorities);
        this.id = id;
        this.fullName = fullName;
    }

    public Long getId() {
        return id;
    }

    public String getFullName() {
        return fullName;
    }
}
