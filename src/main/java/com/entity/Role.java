package com.entity;

import java.util.List;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;

@Entity
public class Role {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    int roleId;
    String name;
    @OneToMany(mappedBy = "role")
    private List<Account> accounts;
    public Role() {
    }
    public Role(int id, String name) {
        this.roleId = id;
        this.name = name;
    }
    public int getId() {
        return roleId;
    }
    public String getName() {
        return name;
    }
    public void setId(int id) {
        this.roleId = id;
    }
    public void setName(String name) {
        this.name = name;
    }
    @Override
    public String toString() {
        return "Role [id=" + roleId + ", name=" + name + "]";
    }
}
