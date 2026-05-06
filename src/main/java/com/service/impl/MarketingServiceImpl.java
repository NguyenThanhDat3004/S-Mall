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

    @Autowired
    private com.repository.MembershipRankRepository membershipRankRepository;

    @Override
    public List<CustomerInsightDTO> getCustomerInsights(Long shopId) {
        List<CustomerInsightDTO> insights = orderRepository.findCustomerInsightsByShopId(shopId);
        populateRanks(insights);
        return insights;
    }

    @Override
    public List<CustomerInsightDTO> getCustomerInsightsByYear(Long shopId, int year) {
        List<CustomerInsightDTO> insights = orderRepository.findCustomerInsightsByShopIdAndYear(shopId, year);
        populateRanks(insights);
        return insights;
    }

    private void populateRanks(List<CustomerInsightDTO> insights) {
        List<com.entity.MembershipRank> ranks = membershipRankRepository.findAllByOrderByMinPointsDesc();
        for (CustomerInsightDTO dto : insights) {
            long points = (long) (dto.getTotalSpent() / 1000);
            dto.setPoints(points);
            
            String rankName = "THÀNH VIÊN";
            for (com.entity.MembershipRank r : ranks) {
                if (points >= r.getMinPoints()) {
                    rankName = r.getRankName();
                    break;
                }
            }
            dto.setMembershipRank(rankName);
        }
    }
}
