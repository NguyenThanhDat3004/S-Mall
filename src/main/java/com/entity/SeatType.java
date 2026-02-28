package com.entity;

import java.math.BigDecimal;

public class SeatType {
    private int seatTypeId;
    private String typeName;
    private BigDecimal extraFee;

    public SeatType() {
        this.extraFee = BigDecimal.ZERO;
    }

    public SeatType(int seatTypeId, String typeName, BigDecimal extraFee) {
        this.seatTypeId = seatTypeId;
        this.typeName = typeName;
        this.extraFee = extraFee;
    }

    // Getters and Setters
    public int getSeatTypeId() { return seatTypeId; }
    public void setSeatTypeId(int seatTypeId) { this.seatTypeId = seatTypeId; }

    public String getTypeName() { return typeName; }
    public void setTypeName(String typeName) { this.typeName = typeName; }

    public BigDecimal getExtraFee() { return extraFee; }
    public void setExtraFee(BigDecimal extraFee) { this.extraFee = extraFee; }
}
