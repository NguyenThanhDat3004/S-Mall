package com.repository;

import com.entity.MembershipRank;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface MembershipRankRepository extends JpaRepository<MembershipRank, Long> {
    // Tìm kiếm chính xác theo tên hạng
    java.util.Optional<MembershipRank> findByRankName(String rankName);

    // Lấy danh sách hạng sắp xếp theo điểm giảm dần để dễ so sánh
    List<MembershipRank> findAllByOrderByMinPointsDesc();
}
