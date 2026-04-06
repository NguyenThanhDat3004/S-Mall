package com.service.impl;

import java.util.List;
import java.util.Optional;

import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;

import com.entity.Category;
import com.repository.CategoryRepository;
import com.service.CategoryService;

@Service
public class CategoryServiceImpl implements CategoryService {

    private final CategoryRepository categoryRepository;

    public CategoryServiceImpl(CategoryRepository categoryRepository) {
        this.categoryRepository = categoryRepository;
    }

    @Override
    @Cacheable(value = "categories", key = "'all'")
    public List<Category> getAllCategories() {
        System.out.println("Cache Miss - Lấy toàn bộ Category từ Database");
        return this.categoryRepository.findByIsActiveTrue();
    }

    @Override
    @Cacheable(value = "categories", key = "'topLevel'")
    public List<Category> getTopLevelCategories() {
        return this.categoryRepository.findByParentIsNull();
    }

    @Override
    @Cacheable(value = "categories", key = "#slug")
    public Category getBySlug(String slug) {
        return this.categoryRepository.findBySlug(slug);
    }

    @Override
    @CacheEvict(value = "categories", allEntries = true)
    public Category handleSaveCategory(Category category) {
        System.out.println("Clear Cache - Cập nhật dữ liệu Category");
        return this.categoryRepository.save(category);
    }

    @Override
    @CacheEvict(value = "categories", allEntries = true)
    public void deleteById(Long id) {
        this.categoryRepository.deleteById(id);
    }

    @Override
    public Category findById(Long id) {
        Optional<Category> opt = this.categoryRepository.findById(id);
        return opt.orElse(null);
    }
}
