/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.entity;

import java.time.LocalTime;

/**
 *
 * @author nguye
 */
public class TicketSoldBySlot_ViewDTO {
    private int slotId;
    private String slotName;
    private LocalTime startTime;
    private LocalTime endTime;
    private int ticketsSold;
    private double slotRevenue;

    public TicketSoldBySlot_ViewDTO() {
    }

    public TicketSoldBySlot_ViewDTO(int slotId, String slotName,
                               LocalTime startTime, LocalTime endTime,
                               int ticketsSold, double slotRevenue) {
        this.slotId = slotId;
        this.slotName = slotName;
        this.startTime = startTime;
        this.endTime = endTime;
        this.ticketsSold = ticketsSold;
        this.slotRevenue = slotRevenue;
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

    public double getSlotRevenue() {
        return slotRevenue;
    }

    public void setSlotRevenue(double slotRevenue) {
        this.slotRevenue = slotRevenue;
    }
}

