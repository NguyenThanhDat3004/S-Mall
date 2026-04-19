package com.dto;

import java.io.Serializable;
import java.util.List;

public class RecommendationResponse implements Serializable {
    private static final long serialVersionUID = 1L;

    private List<ProductDTO> products;
    private boolean hasNext;

    public RecommendationResponse() {}

    public RecommendationResponse(List<ProductDTO> products, boolean hasNext) {
        this.products = products;
        this.hasNext = hasNext;
    }


    public List<ProductDTO> getProducts() { return products; }
    public void setProducts(List<ProductDTO> products) { this.products = products; }

    public boolean isHasNext() { return hasNext; }
    public void setHasNext(boolean hasNext) { this.hasNext = hasNext; }
}
