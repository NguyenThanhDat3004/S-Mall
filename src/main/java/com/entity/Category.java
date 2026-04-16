package com.entity;

import java.util.List;
import jakarta.persistence.*;

@Entity
@Table(name = "categories")
public class Category {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, columnDefinition = "NVARCHAR(255)")
    private String name;

    @Column(unique = true, columnDefinition = "NVARCHAR(255)")
    private String slug;

    @Column(name = "icon_url")
    private String iconUrl;

    @Column(unique = true, length = 10)
    private String code;

    @Column(name = "is_active")
    private boolean isActive = true;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "parent_id")
    private Category parent;

    @OneToMany(mappedBy = "parent", cascade = CascadeType.ALL)
    private List<Category> children;

    @OneToMany(mappedBy = "category")
    private List<Product> products;

    public Category() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getSlug() { return slug; }
    public void setSlug(String slug) { this.slug = slug; }
    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }
    public String getIconUrl() { return iconUrl; }
    public void setIconUrl(String iconUrl) { this.iconUrl = iconUrl; }
    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }
    public Category getParent() { return parent; }
    public void setParent(Category parent) { this.parent = parent; }
    public List<Category> getChildren() { return children; }
    public void setChildren(List<Category> children) { this.children = children; }
    public List<Product> getProducts() { return products; }
    public void setProducts(List<Product> products) { this.products = products; }
}
