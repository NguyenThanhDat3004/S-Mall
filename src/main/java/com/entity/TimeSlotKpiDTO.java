/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.entity;

/**
 *
 * @author nguye
 */
import java.time.LocalDate;
import java.time.LocalTime;

public class TimeSlotKpiDTO {

    private LocalDate showDate;
    private int slotId;
    private String slotName;
    private LocalTime startTime;
    private LocalTime endTime;
    private int ticketsSold;
    private double revenue;

    public TimeSlotKpiDTO() {
    }

    public TimeSlotKpiDTO(LocalDate showDate, int slotId, String slotName,
                          LocalTime startTime, LocalTime endTime,
                          int ticketsSold, double revenue) {
        this.showDate = showDate;
        this.slotId = slotId;
        this.slotName = slotName;
        this.startTime = startTime;
        this.endTime = endTime;
        this.ticketsSold = ticketsSold;
        this.revenue = revenue;
    }

    public LocalDate getShowDate() {
        return showDate;
    }

    public void setShowDate(LocalDate showDate) {
        this.showDate = showDate;
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

    public LocalTime getStartTime() {
        return startTime;
    }

    public void setStartTime(LocalTime startTime) {
        this.startTime = startTime;
    }

    public LocalTime getEndTime() {
        return endTime;
    }

    public void setEndTime(LocalTime endTime) {
        this.endTime = endTime;
    }

    public int getTicketsSold() {
        return ticketsSold;
    }

    public void setTicketsSold(int ticketsSold) {
        this.ticketsSold = ticketsSold;
    }

    public double getRevenue() {
        return revenue;
    }

    public void setRevenue(double revenue) {
        this.revenue = revenue;
    }
}
