package com.dto;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

public class CartDTO implements Serializable {
    private List<CartItemDTO> items = new ArrayList<>();
    private int totalItems;
    private double totalPrice;

    public CartDTO() {}

    public List<CartItemDTO> getItems() { return items; }
    public void setItems(List<CartItemDTO> items) { this.items = items; }

    public int getTotalItems() {
        return items.size();
    }

    public double getTotalPrice() {
        return items.stream().mapToDouble(item -> item.getPrice() * item.getQuantity()).sum();
    }
}
