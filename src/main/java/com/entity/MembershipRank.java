package com.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "membership_ranks")
public class MembershipRank {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "rank_name", unique = true, nullable = false)
    private String rankName;

    @Column(name = "min_points", nullable = false)
    private long minPoints;

    public MembershipRank() {}

    public MembershipRank(String rankName, long minPoints) {
        this.rankName = rankName;
        this.minPoints = minPoints;
    }

    public Long getId() { return id; }
    public String getRankName() { return rankName; }
    public void setRankName(String rankName) { this.rankName = rankName; }
    public long getMinPoints() { return minPoints; }
    public void setMinPoints(long minPoints) { this.minPoints = minPoints; }
}
