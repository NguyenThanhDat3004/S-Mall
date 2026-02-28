package com.entity;

import java.math.BigDecimal;
import java.time.LocalTime;

public class TimeSlot {

    private int slotId;
    private String slotName;
    private LocalTime startHour;
    private LocalTime endHour;
    private BigDecimal price;

    public TimeSlot() {
    }
    //Dùng để insert dữ liệu mới
    public TimeSlot( String slotName, LocalTime startHour, LocalTime endHour, BigDecimal price) {
        this.slotId = slotId;
        this.slotName = slotName;
        this.startHour = startHour;
        this.endHour = endHour;
        this.price = price;
    }
    //Dùng để truy vấn dữ liệu
    public TimeSlot(int slotId, String slotName, LocalTime startHour, LocalTime endHour, BigDecimal price) {
        this.slotId = slotId;
        this.slotName = slotName;
        this.startHour = startHour;
        this.endHour = endHour;
        this.price = price;
    }

    public int getSlotId() {
        return slotId;
    }

    public void setSlotId(int slotId) {
        this.slotId = slotId;
    }

    public String getSlotName() {
        return slotName;
    }

    public void setSlotName(String slotName) {
        this.slotName = slotName;
    }

    public LocalTime getStartHour() {
        return startHour;
    }

    public void setStartHour(LocalTime startHour) {
        this.startHour = startHour;
    }

    public LocalTime getEndHour() {
        return endHour;
    }

    public void setEndHour(LocalTime endHour) {
        this.endHour = endHour;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }
}
