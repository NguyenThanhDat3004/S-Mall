package com.service.ai.skills;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import com.dto.CustomerInsightDTO;
import com.repository.OrderRepository;
import com.repository.MembershipRankRepository;
import com.entity.MembershipRank;

/**
 * Skill: Phân tích khách hàng (Customer Insight)
 */
@Component
public class CustomerInsightSkill {

    @Autowired
    private OrderRepository orderRepository;

    @Autowired
    private MembershipRankRepository membershipRankRepository;

    public List<CustomerInsightDTO> getTopBuyers(Long shopId) {
        List<CustomerInsightDTO> insights = orderRepository.findCustomerInsightsByShopId(shopId);
        populateRanks(insights);
        return insights.size() > 5 ? insights.subList(0, 5) : insights;
    }

    public List<CustomerInsightDTO> getTopBuyersThisMonth(Long shopId) {
        java.time.LocalDateTime since = java.time.LocalDateTime.now().withDayOfMonth(1).withHour(0).withMinute(0);
        List<CustomerInsightDTO> insights = orderRepository.findCustomerInsightsByShopIdAndDate(shopId, since);
        populateRanks(insights);
        return insights.size() > 5 ? insights.subList(0, 5) : insights;
    }

    public List<CustomerInsightDTO> getTopBuyersThisYear(Long shopId) {
        int currentYear = java.time.LocalDate.now().getYear();
        List<CustomerInsightDTO> insights = orderRepository.findCustomerInsightsByShopIdAndYear(shopId, currentYear);
        populateRanks(insights);
        return insights.size() > 5 ? insights.subList(0, 5) : insights;
    }

    private void populateRanks(List<CustomerInsightDTO> insights) {
        List<MembershipRank> ranks = membershipRankRepository.findAllByOrderByMinPointsDesc();
        for (CustomerInsightDTO dto : insights) {
            long points = (long) (dto.getTotalSpent() / 1000);
            dto.setPoints(points);
            
            String rankName = "THÀNH VIÊN";
            for (MembershipRank r : ranks) {
                if (points >= r.getMinPoints()) {
                    rankName = r.getRankName();
                    break;
                }
            }
            dto.setMembershipRank(rankName);
        }
    }

    public CustomerInsightDTO findCustomerByName(Long shopId, String name) {
        List<CustomerInsightDTO> all = orderRepository.findCustomerInsightsByShopId(shopId);
        populateRanks(all);
        return all.stream()
                .filter(c -> c.getFullName().toLowerCase().contains(name.toLowerCase()))
                .findFirst()
                .orElse(null);
    }
}
