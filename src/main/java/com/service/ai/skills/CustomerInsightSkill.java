package com.service.ai.skills;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import com.dto.CustomerInsightDTO;
import com.repository.OrderRepository;

/**
 * Skill: Phân tích khách hàng (Customer Insight)
 */
@Component
public class CustomerInsightSkill {

    @Autowired
    private OrderRepository orderRepository;

    /**
     * Lấy danh sách top khách hàng chi tiêu nhiều nhất của Shop (All-time)
     */
    public List<CustomerInsightDTO> getTopBuyers(Long shopId) {
        List<CustomerInsightDTO> insights = orderRepository.findCustomerInsightsByShopId(shopId);
        return insights.size() > 5 ? insights.subList(0, 5) : insights;
    }

    /**
     * Lấy danh sách top khách hàng theo tháng hiện tại
     */
    public List<CustomerInsightDTO> getTopBuyersThisMonth(Long shopId) {
        java.time.LocalDateTime since = java.time.LocalDateTime.now().withDayOfMonth(1).withHour(0).withMinute(0);
        List<CustomerInsightDTO> insights = orderRepository.findCustomerInsightsByShopIdAndDate(shopId, since);
        return insights.size() > 5 ? insights.subList(0, 5) : insights;
    }

    /**
     * Lấy danh sách top khách hàng theo năm hiện tại
     */
    public List<CustomerInsightDTO> getTopBuyersThisYear(Long shopId) {
        java.time.LocalDateTime since = java.time.LocalDateTime.now().withDayOfYear(1).withHour(0).withMinute(0);
        List<CustomerInsightDTO> insights = orderRepository.findCustomerInsightsByShopIdAndDate(shopId, since);
        return insights.size() > 5 ? insights.subList(0, 5) : insights;
    }

    /**
     * Lấy thông tin chi tiết của một khách hàng cụ thể dựa trên Email hoặc Tên
     */
    public CustomerInsightDTO findCustomerByName(Long shopId, String name) {
        List<CustomerInsightDTO> all = orderRepository.findCustomerInsightsByShopId(shopId);
        return all.stream()
                .filter(c -> c.getFullName().toLowerCase().contains(name.toLowerCase()))
                .findFirst()
                .orElse(null);
    }
}
