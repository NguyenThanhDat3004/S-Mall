package com.entity;

import java.util.List;
import jakarta.persistence.*;

@Entity
@Table(name = "roles")
public class Role {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true, nullable = false, columnDefinition = "nvarchar(255)")
    private String name;

    @Column(columnDefinition = "nvarchar(255)")
    private String description;

    @OneToMany(mappedBy = "role")
    private List<User> users;

    public Role() {}
    public Role(Long id, String name) {
        this.id = id;
        this.name = name;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public List<User> getUsers() { return users; }
    public void setUsers(List<User> users) { this.users = users; }
}
