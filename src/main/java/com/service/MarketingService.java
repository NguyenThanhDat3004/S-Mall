package com.service;

import com.dto.CustomerInsightDTO;
import java.util.List;

public interface MarketingService {
    List<CustomerInsightDTO> getCustomerInsights(Long shopId);
    List<CustomerInsightDTO> getCustomerInsightsByYear(Long shopId, int year);
}
