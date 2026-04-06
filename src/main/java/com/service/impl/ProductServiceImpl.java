package com.service.impl;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import com.entity.Category;
import com.entity.Product;
import com.entity.Shop;
import com.repository.ProductRepository;
import com.service.ProductService;

@Service
public class ProductServiceImpl implements ProductService {

    private final ProductRepository productRepository;

    public ProductServiceImpl(ProductRepository productRepository) {
        this.productRepository = productRepository;
    }

    @Override
    public Page<Product> getAllActiveProducts(Pageable pageable) {
        return this.productRepository.findByIsActiveTrue(pageable);
    }

    @Override
    public Page<Product> getProductsByCategory(Category category, Pageable pageable) {
        return this.productRepository.findByCategoryAndIsActiveTrue(category, pageable);
    }

    @Override
    public Page<Product> getProductsByShop(Shop shop, Pageable pageable) {
        return this.productRepository.findByShopAndIsActiveTrue(shop, pageable);
    }

    @Override
    public Product getBySlug(String slug) {
        return this.productRepository.findBySlug(slug);
    }

    @Override
    public Product findById(Long id) {
        return this.productRepository.findById(id).orElse(null);
    }

    @Override
    public Product handleSaveProduct(Product product) {
        return this.productRepository.save(product);
    }

    @Override
    public void softDelete(Long id) {
        Product product = this.findById(id);
        if (product != null) {
            product.setActive(false);
            this.productRepository.save(product);
        }
    }
}
