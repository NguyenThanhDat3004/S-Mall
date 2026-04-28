package com.service;

import com.entity.Order;
import com.entity.User;
import java.util.List;

public interface OrderService {
    Order createOrder(User user, Order orderData, List<Long> variantIds);
    List<Order> getOrdersByUser(String email);
    Order getOrderDetails(String orderCode);
}
