package com.entity;

import java.math.BigDecimal;

public class TicketDetail {
    private int invoiceId;
    private int seatId;
    private int hallId;
    private int showtimeId;
    private BigDecimal actualPrice;

    public TicketDetail() {}

    public TicketDetail(int invoiceId, int seatId, int hallId, int showtimeId, BigDecimal actualPrice) {
        this.invoiceId = invoiceId;
        this.seatId = seatId;
        this.hallId = hallId;
        this.showtimeId = showtimeId;
        this.actualPrice = actualPrice;
    }

    // Getters and Setters


    public int getShowtimeId() {return showtimeId;}

    public void setShowtimeId(int showtimeId) {this.showtimeId = showtimeId;}

    public int getInvoiceId() { return invoiceId; }
    public void setInvoiceId(int invoiceId) { this.invoiceId = invoiceId; }

    public int getSeatId() { return seatId; }
    public void setSeatId(int seatId) { this.seatId = seatId; }

    public int getHallId() { return hallId; }
    public void setHallId(int hallId) { this.hallId = hallId; }

    public BigDecimal getActualPrice() { return actualPrice; }
    public void setActualPrice(BigDecimal actualPrice) { this.actualPrice = actualPrice; }
}

