package com.service.impl;

import com.dto.CustomerInsightDTO;
import com.repository.OrderRepository;
import com.service.MarketingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class MarketingServiceImpl implements MarketingService {

    @Autowired
    private OrderRepository orderRepository;

    @Override
    public List<CustomerInsightDTO> getCustomerInsights(Long shopId) {
        return orderRepository.findCustomerInsightsByShopId(shopId);
    }
}
